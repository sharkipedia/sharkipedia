#!/bin/bash
# Nightly production database dump. Kept for 14 days on the server and
# copied to S3 when /etc/sharkipedia/backup-s3.env exists.
# Installed by config/server/install-backup.sh and run by cron.
set -euo pipefail

dir=/var/backups/sharkipedia
mkdir -p "$dir"
chmod 700 "$dir"

name="sharkipedia_production-$(date -u +%Y%m%dT%H%M%SZ).dump"
docker exec sharkipedia-db pg_dump -U postgres -Fc sharkipedia_production > "$dir/$name.tmp"
mv "$dir/$name.tmp" "$dir/$name"

find "$dir" -name 'sharkipedia_production-*.dump' -mtime +14 -delete

# Off-site copy. The key can only write to the bucket; the bucket keeps
# old versions and expires them (see docs/deploy.md).
env_file=/etc/sharkipedia/backup-s3.env
if [ -f "$env_file" ]; then
  bucket=$(sed -n 's/^BACKUP_S3_BUCKET=//p' "$env_file")
  docker run --rm --env-file "$env_file" -v "$dir:/backup:ro" amazon/aws-cli:2.39.3 \
    s3 cp "/backup/$name" "s3://$bucket/$name" --storage-class STANDARD_IA --only-show-errors
fi
