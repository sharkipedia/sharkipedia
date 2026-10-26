#!/bin/bash
# Refresh sharkipedia_seed, the template for PR preview databases, from
# production. Run nightly by .github/workflows/preview-maintenance.yml.
# Usage: ssh root@HOST 'bash -s' < config/server/preview-seed.sh
#
# The copy is restored as the "preview" role (no owners or grants from
# production), so previews can migrate it freely. Job queue and error
# records are left out.
set -euo pipefail

sql() { docker exec -i sharkipedia-db psql -v ON_ERROR_STOP=1 -U postgres -d "$1" -Atc "$2"; }

sql postgres "DROP DATABASE IF EXISTS sharkipedia_seed_new WITH (FORCE)"
sql postgres "CREATE DATABASE sharkipedia_seed_new OWNER preview"
sql sharkipedia_seed_new "CREATE SCHEMA IF NOT EXISTS heroku_ext; CREATE EXTENSION IF NOT EXISTS postgis; CREATE EXTENSION IF NOT EXISTS pgcrypto;"

# pg_restore reports harmless errors for the extensions that already exist
# (the preview role can't comment on them), so check the result instead of
# the exit status.
docker exec sharkipedia-db bash -c '
  pg_dump -U postgres -Fc --no-owner --no-acl \
    --exclude-table-data="good_job*" --exclude-table-data="solid_errors*" \
    sharkipedia_production |
  pg_restore -U preview --no-owner --no-acl -d sharkipedia_seed_new
' || true

migrations="$(sql sharkipedia_seed_new "SELECT count(*) FROM schema_migrations" 2>/dev/null || echo 0)"
echo "seed copy has $migrations migrations, $(sql sharkipedia_seed_new "SELECT count(*) FROM users" 2>/dev/null || echo 0) users"
[ "$migrations" -gt 0 ] || { echo "restore looks empty, keeping the old seed" >&2; exit 1; }

sql postgres "DROP DATABASE IF EXISTS sharkipedia_seed WITH (FORCE)"
sql postgres "ALTER DATABASE sharkipedia_seed_new RENAME TO sharkipedia_seed"
sql postgres "REVOKE ALL ON DATABASE sharkipedia_seed FROM PUBLIC"
echo "sharkipedia_seed refreshed"
