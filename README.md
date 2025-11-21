# Readme
This repo contains docker configurations, shell scripts and infrastructure-as-code for my personal server's applications and services. I decided to split docker-compose files across service folders instead of having to look at one big compose file containing all configs.

## Architecture
TODO

## Services
- **Caddy**: Reverse proxy to route rleonr.com subdomains to specific services listening in the host's loopback address.
- **Postgres**: Favored SQL DBMS for general purposes and current n8n storage engine
- **n8n**: Workflow automation tool
- **Duplicati**: Manage, schedule and encrypt backups

## Shell Scripts
- Each service contains a `start.sh`script which ensures the shared docker network `web` is defines ahead of deploying the service

## TO-DOs
1. Need to split config and secrets apart in each of the services' .env files. We want to add config to source control but not secrets
2. Currently each service relies on a .env file defined next to each `docker-compose.yml`in order to have secrets and configuration injected into it. Need to add a better secret-management tool that injects secrets automatically. Probably Doppler
3. Add high-level run script that starts/stops/restarts services in coordinated manner.
