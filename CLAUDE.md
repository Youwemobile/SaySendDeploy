# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is the infrastructure/deployment repo for SaySend (separate from the application source repos). It holds Helm charts and GitHub Actions workflows that deploy SaySend's microservices to Kubernetes. There is no application code here — only Helm charts, values files, and CI/CD workflow/action definitions.

## Architecture

Two independent Helm chart trees:

- **`charts/fastapi-base/`** — a reusable base chart (`type: application`) modeling a single generic FastAPI microservice: one Deployment + one Service on port 8000, and an optional pre-install/pre-upgrade migration Job (`alembic upgrade head`, gated by `migrations.enabled`).
- **`components/apps/`** — the umbrella chart that instantiates `fastapi-base` several times as subchart dependencies via aliasing (one per microservice, see `components/apps/Chart.yaml`), each with its own `image` and `env` overrides in `components/apps/values.yaml`. Because Helm dependency aliases are used, per-service config in values files is keyed by the alias name (e.g. `auth-service:`), not `fastapi-base:`.
- **`components/infra/`** — infra chart deployed on both envs, templating two kinds of resources:
  - **Ingress** (`templates/ingress.yaml`) — one separate `Ingress` resource per backend, each routing its own path prefix (the docs backend's `Ingress` gated by `ingress.enableDocs`). Split per resource (rather than one `Ingress` with multiple paths) because the haproxy-ingress controller's `proxy-body-size` annotation applies per `Ingress` resource, not per path, and each backend needs its own request body size cap (`ingress.bodySize.default`, overridden per service e.g. `ingress.bodySize.transcription`).
  - **Redis** (`templates/redis.yaml`) — a Redis operator CR (`redis.redis.opstreelabs.in/v1beta2`), shared by the app services.
- **`components/infra/environments/{stage,prod}.yaml`** — env-specific value overlays for `infra` (ingress host, `ingress.enableDocs`).
- **`components/stage-infra/`** — stage-only chart: Postgres as a Zalando `postgresql` operator CR (`acid.zalan.do/v1`), shared by the app services.
- **`components/apps/environments/{stage,prod}.yaml`** — env-specific value overlays (DB connection env vars, secret sources, `docs.enabled`) applied on top of `components/apps/values.yaml` at deploy time.

### Secrets mechanism

Every secret-backed env var is wired via a plain `env` entry with `valueFrom.secretKeyRef`, pointing at a k8s Secret that already exists in the target namespace (declared per-service in `components/apps/environments/{stage,prod}.yaml`, alongside the plain env vars).

- **prod** — the referenced Secret (`saysend.prod`) is created and rotated manually/externally in the cluster; this repo only references its keys, never its values.
- **stage** — `.github/workflows/deploy.yml` creates/updates a single consolidated Secret (`saysend.stage`) via `kubectl create secret ... | kubectl apply -f -` in the target namespace before the Helm app deploy, sourcing values from GitHub Actions secrets (`STAGE_*`). Nothing about its contents passes through Helm `--set` or gets stored in Helm release values.
- Postgres credentials for both envs likewise come via `secretKeyRef` — stage points at the Zalando operator's auto-generated credentials Secret, prod at the pre-existing `saysend-db` Secret (`host`/`port`/`username`/`password`).

### Environments and deployment flow

- `.github/workflows/deploy.yml` — triggers on push to a `stage/**` branch or manual `workflow_dispatch`; the job runs only for a push whose head commit message starts with `[deploy]`, or a `workflow_dispatch` from a tag (dispatch from any branch is skipped: stage is deployed only by the source repo's CI pushing a `[deploy]` commit that also sets the image tags). Env resolution: a tag ref selects **prod** (fixed namespace `saysend-prod`, `PROD_KUBECONFIG_DATA`; the tag must be semver, e.g. `1.0.0`, or the job fails); a branch ref selects **stage**, namespace `saysend-<ref_name with "/" replaced by "-">` (e.g. `stage/001` → `saysend-stage-001`), `STAGE_KUBECONFIG_DATA`. Phases: resolve env → `k8s-env-setup` (kubeconfig, namespace, `nexus-registry-key`) → `helm upgrade --install infra` (both envs, with the matching `components/infra/environments/<env>.yaml` overlay) → (stage only) `helm upgrade --install stage-infra` → (stage only) create/update the `saysend.stage` Secret (see Secrets mechanism above) → `helm dependency build` + `helm upgrade --install app` (both envs, with the matching `environments/<env>.yaml` overlay and `global.deployDate`) → `k8s-cleanup`.
- **Prod release version** — set once as `releaseVersion: &release "<version>"` at the top of `components/apps/environments/prod.yaml`; each service's `image.tag` refers to it via the YAML alias `*release` (nothing is passed via `--set`). The release/rollback runbook for humans is in `README.md`.
- `.github/workflows/cleanup.yml` — triggers on the repo's `delete` event, gated to `ref_type == 'branch' && startsWith(ref, 'stage/')` (i.e. deleting a `stage/**` branch fires it). Resolves the namespace the same way as deploy (`saysend-<branch with "/" replaced by "-">`), then `kubectl delete namespace`s it (the Helm releases are stored in the namespace and go with it).
- `.github/actions/k8s-env-setup` — shared composite action: writes kubeconfig from a base64 secret; when `namespace` is given, also ensures the namespace exists and (optionally) creates the `nexus-registry-key` imagePullSecret from a base64 docker config. The namespace is ensured with `get || create` and Helm runs without `--create-namespace`, because the prod namespace already exists and CI may only `get` it.
- `.github/actions/k8s-cleanup` — removes the local `~/.kube` dir at the end of a job.

## Working in this repo

- `helm dependency build ./components/apps` must be run before installing/upgrading the `apps` chart (it pulls in the local `file://` `fastapi-base` dependency); the deploy workflow does this automatically.
- To validate chart changes locally: `helm template ./components/apps -f ./components/apps/values.yaml -f ./components/apps/environments/stage.yaml` (swap in `prod.yaml` for the prod overlay), the same for `./components/infra` with its `environments/<env>.yaml`, and `helm lint` on each chart.
- When adding a new microservice, add it as another aliased `fastapi-base` dependency in `components/apps/Chart.yaml`, then add its config block (image, env) to `components/apps/values.yaml` and env-specific overrides to the environment overlay files (including `image.tag: *release` for the service in `prod.yaml`, or prod falls back to `latest`) — don't fork `fastapi-base` itself unless the new service genuinely needs a different pod shape.
- Any new secret key a service needs must be added as a `secretKeyRef` env entry in the relevant `components/apps/environments/{stage,prod}.yaml` block, and the underlying Secret key added to `saysend.stage` (via `deploy.yml`, sourced from a new `STAGE_*` GitHub Actions secret) and to `saysend.prod` (manually, in the cluster).
