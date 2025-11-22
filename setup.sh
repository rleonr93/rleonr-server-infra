set -e

docker compose --profile setup --env-file ./.env  \
-f compose.yaml \
-f ./doppler/compose.yaml \
up  -d --force-recreate
