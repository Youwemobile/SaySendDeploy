#!/bin/sh
# Replaces a stage namespace's reference tables with seeds/<db>.sql (prod
# dumps, see README) and restarts translation-service, which reads them only
# at startup.
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <namespace>" >&2
  exit 1
fi
NAMESPACE=$1
SEEDS_DIR="$(dirname "$0")/../seeds"

for f in "$SEEDS_DIR"/*.sql; do
  db=$(basename "$f" .sql)
  echo "Seeding $db"
  kubectl exec -i -n "$NAMESPACE" infra-pg-0 -c postgres -- \
    psql -q -v ON_ERROR_STOP=1 -1 -U postgres -d "$db" < "$f"
done

kubectl rollout restart deployment/translation-service -n "$NAMESPACE"
kubectl rollout status deployment/translation-service -n "$NAMESPACE"
