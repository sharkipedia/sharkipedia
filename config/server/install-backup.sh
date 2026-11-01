#!/bin/bash
# Install or update the nightly database backup (backup.sh) on the server.
# Run from the repo root on a machine on the tailnet:
#   config/server/install-backup.sh          # script + cron
#   config/server/install-backup.sh --keys   # also ask for the S3 upload key
#
# The key is read without echo and written to /etc/sharkipedia/backup-s3.env
# on the server (root only). It is asked for automatically the first time.
set -euo pipefail

server=root@100.89.83.34
bucket=sharkipedia-db-backups

scp -q config/server/backup.sh "$server":/usr/local/bin/sharkipedia-backup
ssh "$server" 'chmod 755 /usr/local/bin/sharkipedia-backup &&
  echo "30 3 * * * root /usr/local/bin/sharkipedia-backup" > /etc/cron.d/sharkipedia-backup'

if [ "${1:-}" = "--keys" ] || ! ssh "$server" test -f /etc/sharkipedia/backup-s3.env; then
  read -rp "AWS access key ID for $bucket: " key_id
  read -rsp "AWS secret access key: " secret
  echo
  printf 'AWS_ACCESS_KEY_ID=%s\nAWS_SECRET_ACCESS_KEY=%s\nAWS_DEFAULT_REGION=us-east-1\nBACKUP_S3_BUCKET=%s\n' \
    "$key_id" "$secret" "$bucket" |
    ssh "$server" 'umask 077 && mkdir -p /etc/sharkipedia && cat > /etc/sharkipedia/backup-s3.env'
fi

echo "Installed. Test with: ssh $server sharkipedia-backup"
