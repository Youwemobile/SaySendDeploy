# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is the infrastructure/deployment repo for SaySend (separate from the application source repos). It holds Helm charts and GitHub Actions workflows that deploy SaySend's microservices to Kubernetes. There is no application code here — only Helm charts, values files, and CI/CD workflow/action definitions.

## Architecture

Two independent Helm chart trees:

- **`charts/fastapi-base/`** — a reusable base chart (`type: application`) modeling a single generic FastAPI microservice: one Deployment + one Service on port 8000, an optional Secret, and an optional pre-install/pre-upgrade migration Job (`alembic upgrade head`, gated by `migrations.enabled`).
- **`components/apps/`** — the umbrella chart that instantiates `fastapi-base` four times as subchart dependencies via aliasing (`auth-service`, `transcription-service`, `translation-service`, `docs-service`), each with its own `image`, `env`, and `secrets` overrides in `components/apps/values.yaml`. Because Helm dependency aliases are used, per-service config in values files is keyed by the alias name (e.g. `auth-service:`), not `fastapi-base:`.
- **`components/infra/`** — cluster-level infra chart: HAProxy Ingress and a Zalando `postgresql` operator CR (`acid.zalan.do/v1`). The ingress is templated as four separate `Ingress` resources, one per backend (`auth-service`, `transcription-service`, `translation-service`, `docs-service`, the last gated by `ingress.enableDocs`), routing `/auth`, `/transcription`, `/translation`, `/docs` respectively — split per resource (rather than one `Ingress` with multiple paths) because the haproxy-ingress controller's `proxy-body-size` annotation applies per `Ingress` resource, not per path, and each backend needs its own request body size cap (`ingress.bodySize.default`, overridden per service e.g. `ingress.bodySize.transcription`).
- **`components/apps/environments/{stage,prod}.yaml`** — env-specific value overlays (DB connection env vars, secret sources, `docs.enabled`) applied on top of `components/apps/values.yaml` at deploy time.

### Secrets mechanism

`fastapi-base` does not hardcode secret values. Each service subchart declares which secret *keys* it needs via its `secrets:` list (e.g. `secrets: [JWT_SECRET_KEY, OPENAI_API_KEY]`). The `_helpers.tpl` `fastapi-base.hasSecrets` helper checks whether that list is non-empty; if so, `templates/secret.yaml` builds a k8s Secret by looking up each key in `.Values.global.secrets` (a dict populated dynamically at deploy time via `--set global.secrets.KEY=value`) and fails the render (`fail`) if a required key has no value. The Deployment mounts this via `envFrom.secretRef` when secrets exist, plus any additional plain `env` entries.

### Environments and deployment flow

Deployment is triggered externally via `repository_dispatch` (from an app repo's CI, not from pushes to this repo):

- `.github/workflows/deploy.yml` — event `deploy-services`. `client_payload.is_prod == 'true'` selects **prod** (fixed namespace `saysend-prod`, branch `main`); otherwise it's a **stage** deploy to a dynamic namespace `saysend-<image_tag>` on a dynamically created/checked-out branch named after `client_payload.ref_name`. It bumps image tags in `components/apps/values.yaml` via `yq`, commits those changes back to the target branch, bumps `components/apps/Chart.yaml` patch version on prod only, sets the stage ingress host dynamically, then runs `helm upgrade --install` for `infra` (stage only — prod infra is presumably managed separately/already exists) and always for `app` (`components/apps`), passing per-env secrets as `global.secrets.*` via `--set`.
- `.github/workflows/cleanup.yml` — event `delete-env`, only for refs starting with `stage/`. Uninstalls both Helm releases, deletes the namespace, and deletes the remote branch created for that stage environment.
- `.github/actions/k8s-env-setup` — shared composite action: writes kubeconfig from a base64 secret, ensures the namespace exists, and (optionally) creates the `nexus-registry-key` imagePullSecret from a base64 docker config.
- `.github/actions/k8s-cleanup` — removes the local `~/.kube` dir at the end of a job.

## Working in this repo

- `helm dependency build ./components/apps` must be run before installing/upgrading the `apps` chart (it pulls in the local `file://` `fastapi-base` dependency); the deploy workflow does this automatically.
- To validate chart changes locally: `helm template ./components/apps -f ./components/apps/values.yaml -f ./components/apps/environments/stage.yaml` (swap in `prod.yaml` for the prod overlay), and `helm lint` on either chart.
- When adding a new microservice, add it as another aliased `fastapi-base` dependency in `components/apps/Chart.yaml`, then add its config block (image, secrets, env) to `components/apps/values.yaml` and env-specific overrides to the environment overlay files — don't fork `fastapi-base` itself unless the new service genuinely needs a different pod shape.
- Any new secret key a service needs must be added both to that service's `secrets:` list in values and threaded through as a `--set global.secrets.KEY=...` in `deploy.yml` (sourced from a GitHub Actions secret, prod/stage variants).
