[![rleonr.com](https://github.com/rleonr93/rleonr-server-infra/actions/workflows/deploy-to-prod.yml/badge.svg?branch=master)](https://github.com/rleonr93/rleonr-server-infra/actions/workflows/deploy-to-production.yml)

# Personal Lab infra
This repo contains docker configurations and shell scripts for my personal server's applications and services. I decided to split docker-compose files across service folders instead of having to look at one big compose file containing all configs.

## Network Architecture
TODO

## Services
- **Caddy**: Reverse proxy to route rleonr.com subdomains to specific services listening in the host's loopback address.
- **Postgres**: Favored SQL DBMS for general purposes and current n8n storage engine
- **n8n**: Workflow automation tool
- **Duplicati**: Manage, schedule and encrypt backups

## Getting Started
### Requirements
- [Docker](https://docs.docker.com/engine/install/)
- [Docker compose plugin](https://docs.docker.com/compose/install/linux/#install-using-the-repository)
- [Doppler](https://dashboard.doppler.com/)

### Steps
1. Create a copy of `.env.example` as `.env` and populate it with an ENV value matching a Doppler config slug and Doppler tokens for your respective environment.
2. Run `setup.sh`. Confirm that secrets have been loaded into `env` folder
3. Run `start.sh`

## Structure
Each service has its own folder which includes relevant config files and a docker `compose.yaml` file. However, each service must also be defined in the root `compose.yaml` file. Service folders contain a `config.ini` file which includes non-secret options.

## Development

### Load Secrets and Dynamic Variables into Docker
Secrets and dynamic variables are injected into services by downloading them to the `env` folder first. In order to do this for a new service:
1. Create a new project in Doppler e.g. *new-service*
2. Create a [Service Token](https://docs.doppler.com/docs/service-tokens) e.g. *new-service-prod*
3. Include a new DOPPLER_CONFIG_ variable on `.env` (and `.env.example` for documentation purposes) e.g. *DOPPLER_CONFIG_NEW_SERVICE*
4. Edit `doppler/compose.yaml`. Add a new line to the container command in order to download the project's. Here is where we will map the new environment variable to a doppler cli command that downloads the secrets into a file that other containers can use. e.g. *DOPPLER_TOKEN=$DOPPLER_TOKEN_NEW_SERVICE doppler secrets download -p new-service  --no-file --format=env > /secrets/new_service_${ENV}.env &&*
5. Lastly, include the downloaded env file into the service's own `compose.yaml` file e.g. *env/new_service_${ENV}.env*

### Shell Scripts
- `setup.sh` ensures that secrets are downloaded into the `env` folder. Runs services with the `setup` profile defined in the root-level `compose.yaml` file. New services do not require to be added manually to this script. Consider following the previous section on loading secrets prior to running.
- `start.sh` runs services with the `runtime` profile defined in the root-level `compose.yaml` file. New services must be added manually to this script in most cases in order to include modular, service-specific `compose.yaml` files into the merged docker compose definition.
- `stop.sh` stops services. Edit manually if you want to have a new service be stopped alongside others in one go.
