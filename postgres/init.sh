#!/bin/bash
set -e

# --- 1. Validate Environment Variables ---
if [ -z "$N8N_DB" ] || [ -z "$N8N_USER" ] || [ -z "$N8N_PASSWORD" ]; then
  echo "Error: Required environment variables N8N_DB, N8N_USER, and N8N_PASSWORD are not set."
  exit 1
fi

# --- 2. SQL Execution ---
# Connect to the default 'postgres' database (which is owned by the superuser POSTGRES_USER)
# and execute the commands. The shell variable substitution happens here.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

  -- Create the database
  CREATE DATABASE "$N8N_DB";
  
  -- Create the non-admin user (role)
  CREATE USER "$N8N_USER" WITH PASSWORD '$N8N_PASSWORD';
  
  -- Grant connection and ownership to the database
  GRANT CONNECT ON DATABASE "$N8N_DB" TO "$N8N_USER";
  ALTER DATABASE "$N8N_DB" OWNER TO "$N8N_USER";
  
  -- Connect to the newly created database
  \c "$N8N_DB"
  
  -- Grant usage on the public schema
  GRANT USAGE ON SCHEMA public TO "$N8N_USER";
  
  -- Grant permissions for *current* and *future* objects
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "$N8N_USER";
  GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "$N8N_USER";
  
  -- Set default privileges for objects created by the owner in the future
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO "$N8N_USER";
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO "$N8N_USER";

EOSQL

echo "PostgreSQL setup complete for database $N8N_DB and user $N8N_USER."