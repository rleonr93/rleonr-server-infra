set -e

export VOLUME_NAME="secrets"

# Check if the volume exists
if ! docker volume ls --format '{{.Name}}' | grep -q "^${VOLUME_NAME}$"; then
    echo "Docker network '${VOLUME_NAME}' not found. Creating..."
    docker volume create "${VOLUME_NAME}"
else
    echo "Docker volume '${VOLUME_NAME}' already exists."
fi


docker compose --env-file config.ini --env-file .env --profile setup up -d --force-recreate
docker logs doppler-injector -f
