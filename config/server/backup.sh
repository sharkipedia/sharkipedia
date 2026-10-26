#!/bin/bash
# Nightly production database dump, kept for 14 days on the server.
# Installed to /usr/local/bin/sharkipedia-backup by setup.sh and run by cron.
# Off-site copies come from Hetzner's server backups.
set -euo pipefail

dir=/var/backups/sharkipedia
mkdir -p "$dir"
chmod 700 "$dir"

file="$dir/sharkipedia_production-$(date -u +%Y%m%dT%H%M%SZ).dump"
docker exec sharkipedia-db pg_dump -U postgres -Fc sharkipedia_production > "$file.tmp"
mv "$file.tmp" "$file"

find "$dir" -name 'sharkipedia_production-*.dump' -mtime +14 -delete
