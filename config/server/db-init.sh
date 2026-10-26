#!/bin/bash
# Runs once, when the Postgres accessory starts with an empty data directory.
#
# Roles:
#   sharkipedia  owns the production database.
#   preview      owns the PR preview databases and can't connect to production,
#                so code from a pull request can't touch production data.
set -euo pipefail

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d postgres \
  -v db_password="$DB_PASSWORD" -v preview_password="$PREVIEW_DB_PASSWORD" <<'SQL'
CREATE ROLE sharkipedia LOGIN PASSWORD :'db_password';
CREATE ROLE preview LOGIN PASSWORD :'preview_password';

CREATE DATABASE sharkipedia_production OWNER sharkipedia;
REVOKE ALL ON DATABASE sharkipedia_production FROM PUBLIC;
GRANT CONNECT ON DATABASE sharkipedia_production TO sharkipedia;

-- Template for PR previews, refreshed nightly from production
-- (config/server/preview-seed.sh).
CREATE DATABASE sharkipedia_seed OWNER preview;
REVOKE ALL ON DATABASE sharkipedia_seed FROM PUBLIC;
SQL

# Extensions need a superuser; create them up front so the app roles never
# need one. heroku_ext only exists so dumps taken on Heroku restore cleanly.
for db in sharkipedia_production sharkipedia_seed; do
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$db" <<'SQL'
CREATE SCHEMA IF NOT EXISTS heroku_ext;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SQL
done
