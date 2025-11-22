set -e

docker compose --profile runtime  --env-file ./.env \
-f compose.yaml \
-f ./postgres/compose.yaml \
-f ./n8n/compose.yaml \
-f ./duplicati/compose.yaml \
-f ./caddy/compose.yaml \
up  -d --force-recreate
