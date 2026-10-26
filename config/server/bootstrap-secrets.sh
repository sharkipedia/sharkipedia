#!/bin/bash
# One-time: create the deploy secrets in GitHub without showing them.
# Run from the repo root on a machine on the tailnet:
#   config/server/bootstrap-secrets.sh
#
# - SSH_PRIVATE_KEY: a new deploy key; its public half goes onto the server.
# - POSTGRES_PASSWORD, DB_PASSWORD, PREVIEW_DB_PASSWORD: random passwords.
#   The database reads them only when it's first created, so don't re-run
#   this after the db accessory has booted.
# - RAILS_MASTER_KEY: from config/master.key.
set -euo pipefail

repo=sharkipedia/sharkipedia
server=root@100.89.83.34

dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT

ssh-keygen -q -t ed25519 -N "" -C "github-actions@sharkipedia" -f "$dir/id"
ssh "$server" 'cat >> /root/.ssh/authorized_keys' < "$dir/id.pub"
gh secret set SSH_PRIVATE_KEY -R "$repo" < "$dir/id"

for name in POSTGRES_PASSWORD DB_PASSWORD PREVIEW_DB_PASSWORD; do
  openssl rand -hex 24 | tr -d '\n' | gh secret set "$name" -R "$repo"
done

gh secret set RAILS_MASTER_KEY -R "$repo" < config/master.key

# Nightly database dump on the server (see backup.sh).
scp -q config/server/backup.sh "$server":/usr/local/bin/sharkipedia-backup
ssh "$server" 'chmod 755 /usr/local/bin/sharkipedia-backup &&
  echo "30 3 * * * root /usr/local/bin/sharkipedia-backup" > /etc/cron.d/sharkipedia-backup'

gh secret list -R "$repo"
