#!/bin/bash
set -e

export PGPASSWORD="$POSTGRES_PASSWORD"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE $DATABASE_NAME;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname $DATABASE_NAME <<-EOSQL
    REVOKE CREATE ON SCHEMA public FROM public;
    REVOKE ALL ON DATABASE $DATABASE_NAME FROM public;

    CREATE ROLE oioioi;
    GRANT CONNECT ON DATABASE $DATABASE_NAME TO oioioi;
    GRANT USAGE, CREATE ON SCHEMA public TO oioioi;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO oioioi;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO oioioi;
    GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO oioioi;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO oioioi;

    CREATE USER $DATABASE_USERNAME WITH PASSWORD '$DATABASE_PASSWORD';
    GRANT oioioi TO $DATABASE_USERNAME;
EOSQL
