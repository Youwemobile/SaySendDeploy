# SaySend deploy

Helm charts and GitHub Actions workflows that deploy SaySend's services to Kubernetes. Application code and image builds live in the source repo. For how the charts and workflows are put together, see [CLAUDE.md](CLAUDE.md).

## Stage

Every `stage/NNN` branch gets its own namespace, `saysend-stage-NNN`, at `https://saysend-stage-NNN.k8s-dev.saysend.me`.

**Deploy:** push to a `stage/NNN` branch in the source repo. The source CI:

1. builds the images and tags them `stage-NNN`;
2. commits a `[deploy] ...` commit to the branch with the same name here (creating it from `main` if it's new), setting the image tags and the ingress host;
3. that commit triggers `deploy.yml`, which deploys to the stage namespace.

Stage has no manual run: `workflow_dispatch` from a branch is skipped, because only the source CI's commit sets the image tags. To ship chart changes to a stage, merge them into its branch here; they go out with the next push to that branch in the source repo.

**Tear down:** delete the `stage/NNN` branch in this repo. `cleanup.yml` deletes the namespace, and the Helm releases and stage Postgres go with it.

### Reference data

A new stage's DB only has the defaults the migrations insert. To load prod's reference tables (`translation`: `language`, `tone`, `prompt_template`; `auth`: `document_version`), after the stage's first deploy run Actions → **Seed Stage Databases** → **Run workflow** from the `stage/NNN` branch. With your own kubeconfig you can run the same script directly:

```bash
scripts/seed-stage.sh saysend-stage-NNN
```

It replaces those tables with `seeds/<db>.sql` (one file per DB, named after it) and restarts translation-service, which reads them only at startup. A rerun throws away any manual edits of those tables on that stage. The seeds come from the branch you run it on, which starts from `main`.

To refresh the dumps from prod (e.g. after the tables were edited there):

```bash
echo 'TRUNCATE public.language, public.prompt_template, public.tone;' > seeds/translation.sql
pg_dump --data-only --column-inserts -t language -t tone -t prompt_template -d translation >> seeds/translation.sql

echo 'TRUNCATE public.document_version;' > seeds/auth.sql
pg_dump --data-only --column-inserts -t document_version -d auth >> seeds/auth.sql
```

A new table goes into both the `TRUNCATE` and the `-t` list; a new DB is a new file.

## Prod

Namespace `saysend-prod`, at `https://api.saysend.me`. A prod deploy only runs when someone starts it by hand from a semver tag (`1.0.0`).

What gets deployed is whatever the tagged commit contains, in both repos. Branches don't matter to CI. Normally the tagged commits are on `main`, because the next release and new stage branches start from `main`, so a release made elsewhere (e.g. a hotfix branch) must be merged back into `main` afterwards.

### Release

1. **Build the images.** In the source repo, tag the commit you want to release (normally the tip of `main`) and push the tag:
   ```bash
   git tag 1.0.0 && git push origin 1.0.0
   ```
   The source CI builds all service images as `:1.0.0`. It doesn't touch this repo. Wait for the build to finish and check that the images are in the registry.
2. **Set the version.** Here, bump the single line at the top of `components/apps/environments/prod.yaml`, normally in a PR into `main`:
   ```yaml
   releaseVersion: &release "1.0.0"
   ```
   Every service's `image.tag` points at it (`tag: *release`). Chart changes meant for prod go in the same PR, or are merged before it.
3. **Tag the release.** Tag the commit holding that version (normally the merge commit on `main`) with the same version. Pushing the tag deploys nothing.
   ```bash
   git checkout main && git pull
   git tag 1.0.0 && git push origin 1.0.0
   ```
4. **Deploy.** Actions → **Deploy Platform Components** → **Run workflow** → under "Use workflow from" switch to **Tags** → pick `1.0.0` → **Run workflow**. The run fails if the tag isn't semver.
5. **Check.**
   ```bash
   kubectl get pods -n saysend-prod
   kubectl get deploy -n saysend-prod -o wide   # IMAGES should show :1.0.0
   helm history app -n saysend-prod
   ```

### Rollback

Run the workflow on an older tag (step 4 with, e.g., `1.0.0`). It redeploys that tag's charts and image versions. Then open a revert PR so `main` matches prod again; otherwise the next release ships from the broken state.

DB migrations (`alembic upgrade head`) are not rolled back. If the bad release changed the schema, the old code meets the new schema. Write migrations to stay backward compatible: add a column in one release, drop the old one in a later release.

### Rules

- Never move or reuse a tag. Each prod state gets a new tag, so every tag still means exactly what was deployed.
- All services share one version. To change only the chart (env, resources, ingress), cut a new patch release (`1.0.1`): tag the source repo, rebuild the images, then follow the release steps.
- Every deploy restarts all services, since the pods carry a `deploy.date` annotation that changes on every run.

## Secrets

Services read secrets through `secretKeyRef` to Secrets that already exist in the namespace. If a referenced key is missing, the pods don't start (`CreateContainerConfigError`). For a new key:

- **stage:** add a `STAGE_*` GitHub Actions secret and a `--from-literal` line for it in the "Create Stage Application Secrets" step of `deploy.yml`.
- **prod:** add the key to the `saysend.prod` Secret in the cluster by hand, **before** the release that needs it is deployed.

Then reference it from the service's `env` in `components/apps/environments/{stage,prod}.yaml`.
