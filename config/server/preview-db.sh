#!/bin/bash
# Create or drop a PR preview database on the server.
# Usage: ssh root@HOST 'bash -s' -- create|drop <pr-number> < config/server/preview-db.sh
#
# A new preview database is a copy of sharkipedia_seed (a nightly snapshot
# of production, see preview-seed.sh), owned by the "preview" role.
set -euo pipefail

action="$1"
pr="$2"
[[ "$pr" =~ ^[0-9]+$ ]] || { echo "PR number must be numeric" >&2; exit 1; }
db="sharkipedia_pr_${pr}"

sql() { docker exec sharkipedia-db psql -v ON_ERROR_STOP=1 -U postgres -d postgres -Atc "$1"; }

case "$action" in
  create)
    if [ "$(sql "SELECT 1 FROM pg_database WHERE datname = '$db'")" = "1" ]; then
      echo "$db exists"
    else
      sql "CREATE DATABASE $db TEMPLATE sharkipedia_seed OWNER preview"
      sql "REVOKE ALL ON DATABASE $db FROM PUBLIC"
      sql "GRANT CONNECT ON DATABASE $db TO preview"
      echo "created $db"
    fi
    ;;
  drop)
    sql "DROP DATABASE IF EXISTS $db WITH (FORCE)"
    echo "dropped $db"
    ;;
  *)
    echo "unknown action: $action" >&2
    exit 1
    ;;
esac
