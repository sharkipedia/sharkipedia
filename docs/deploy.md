# Deploying Sharkipedia

Production runs on one Hetzner Cloud server (CAX21, Arm, Ubuntu 26.04) with
[Kamal](https://kamal-deploy.org). GitHub Actions does all deploys.

| What | Where |
|---|---|
| Production | https://www.sharkipedia.org, deployed after CI passes on `master` |
| PR previews | `https://pr-<number>.sharkipedia.org`, for PRs from branches in this repo |
| Images | `ghcr.io/sharkipedia/sharkipedia` (built on GitHub's Arm runners) |
| Errors | https://www.sharkipedia.org/admin/errors (admins) |
| Jobs | https://www.sharkipedia.org/admin/good_job (admins) |

## How traffic and access work

```
visitor -> Route53 DNS -> server (ports 80/443) -> kamal-proxy (TLS) -> app
GitHub Actions / admins -> Tailscale -> SSH (port 22, tailnet only)
```

`sharkipedia.org` DNS is in Route53. `sharkipedia.org`, `www` and
`*.sharkipedia.org` (previews) have A/AAAA records for the server
(`2.31.98.104`, `2a01:4f8:c016:6d08::1`). kamal-proxy picks the app by
hostname and gets a Let's Encrypt certificate for each one on first request.
`sharkipedia.org` redirects to `www` (`config/routes.rb`).

Only ports 80 and 443 are open to the internet (Hetzner firewall and ufw).
SSH works only over Tailscale (`ssh root@sharkipedia` or `root@100.89.83.34`).
GitHub Actions joins the tailnet as an ephemeral `tag:ci` node via OIDC (no
stored Tailscale secret); the tailnet policy only lets `tag:ci` reach the
server on port 22.

## Containers on the server

| Container | What |
|---|---|
| `sharkipedia-web-*`, `sharkipedia-worker-*` | Production app and GoodJob worker |
| `sharkipedia-db` | Postgres 17 + PostGIS (`imresamu/postgis`, multi-arch) |
| `kamal-proxy` | TLS and routing by hostname |
| `sharkipedia-pr-<n>-web-*` | One per open PR preview |

Database roles: `sharkipedia` owns `sharkipedia_production`; `preview` owns
`sharkipedia_seed` and the `sharkipedia_pr_<n>` databases and cannot connect
to production. See `config/server/db-init.sh`.

## Previews

`.github/workflows/preview.yml` deploys every push to a PR and removes the
preview when the PR closes. Each preview gets its own database, copied from
`sharkipedia_seed`, a nightly snapshot of production
(`preview-maintenance.yml`, which also removes previews of closed PRs).
Previews run with `PREVIEW=true`: no email, no cron, the development S3
bucket, `noindex`. Jobs run inside the web process.

PRs from forks and from Dependabot get no preview: GitHub withholds secrets
from them. Push the branch to this repo to preview it. Don't change the trigger
to `pull_request_target`.

Anyone who can push a branch here can run code on the server through a
preview, so write access to the repo means trusted.

## Secrets

GitHub repository secrets: `RAILS_MASTER_KEY`, `SSH_PRIVATE_KEY`,
`DB_PASSWORD`, `POSTGRES_PASSWORD`, `PREVIEW_DB_PASSWORD`, all set by
`config/server/bootstrap-secrets.sh`. Repository variable (optional):
`SOLIDERRORS_EMAIL_TO`. Everything else (SMTP, AWS) is in `config/credentials.yml.enc`.

## Common tasks

Run from a machine on the tailnet with the secrets exported, or use the
**Server** workflow in the Actions tab.

```sh
kamal console                  # Rails console in production
kamal logs                     # follow app logs
kamal dbc                      # psql
kamal app exec "bin/rails regions:load"
kamal accessory logs db
```

Backups: `/usr/local/bin/sharkipedia-backup` dumps the production database
nightly to `/var/backups/sharkipedia` (14 days), plus Hetzner's server backups.

## Rebuilding the server

1. Create a CAX21 with Ubuntu, add your SSH key, and attach the Hetzner
   firewall (inbound TCP 80 and 443 only).
2. `ssh root@<public-ip> 'bash -s' < config/server/setup.sh` and approve the
   Tailscale login link it prints. After that, SSH works only via Tailscale.
3. Update the server's Tailscale IP and host key in `config/deploy*.yml`, the
   workflows and `.github/actions/kamal-setup/action.yml`, and its public IPs
   in Route53 and this file.
4. `config/server/bootstrap-secrets.sh` (new deploy key and DB passwords).
5. Actions → Server: `accessory boot db`.
6. Restore the latest dump into `sharkipedia_production`, then Actions →
   Deploy → Run workflow.
