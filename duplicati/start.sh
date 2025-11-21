set -e

NETWORK_NAME="web"

# Check if the network exists
if ! docker network ls --format '{{.Name}}' | grep -q "^${NETWORK_NAME}$"; then
    echo "Docker network '${NETWORK_NAME}' not found. Creating..."
    docker network create "${NETWORK_NAME}"
else
    echo "Docker network '${NETWORK_NAME}' already exists."
fi

docker compose up -d
docker compose ps
