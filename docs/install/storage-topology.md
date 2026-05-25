# Storage Topology (4 tiers)

Hermes SEG splits storage into four independent tiers so each can live on the right kind of disk for its workload. Three are operator-chosen at install time; the fourth (Config) is implicit — chosen by where the operator `git clone`d the repo.

| Tier | Default path | Contents | Storage profile |
| --- | --- | --- | --- |
| **1. Config** | install root (implicit) | Repo working tree, `config/` subtrees, install script, secrets in `config/hermes/opt/hermes/keys/`, `.env`, `docker-compose.override.yml`, `.hermes_install_config` | Fast SSD, modest size — chosen by where the repo lives |
| **2. Data** | `/mnt/data` | DBs (MariaDB, Authelia, OpenLDAP), Amavis archive + runtime, ClamAV signatures, Fangfrisch state, Lucee server home, sieve scripts, all service logs, OpenDMARC, Postfix queue | Fast SSD; sized for DB growth + log retention |
| **3. Vmail** | `/mnt/vmail` | Dovecot mailboxes | Cheap bulk; sized for users × quota |
| **4. Nextcloud** | `/mnt/files` (`FILES_MOUNT` var) | Nextcloud app + user files + Nextcloud's Redis cache | Cheap bulk; sized for user file storage |

Each tier is **one host path**; the install script lays out the canonical sub-directory structure underneath it.

## Why split storage

| Tier | Why it gets its own disk |
| --- | --- |
| **Config** | Frequent reads (every container start); small footprint; lives with the install script + version control |
| **Data** | High write rate (logs + DBs); benefits from fast SSD; backup hot spot |
| **Vmail** | Grows linearly with user count × quota; cheaper bulk storage; separate backup cadence (often less frequent than Data) |
| **Nextcloud** | Same growth characteristics as Vmail but different access pattern; often shared across multiple Hermes installs in larger deployments |

Smaller deployments can collapse tiers — set Vmail and Nextcloud to the same path as Data, or leave any tier empty to fall back to Docker default named volumes (state lives under `/var/lib/docker/volumes/`).

## Canonical sub-directory layout

### Tier 2 — Data (default `/mnt/data/`)

| Sub-path | Named volume | Service |
| --- | --- | --- |
| `dbase/` | `db_data` | MariaDB |
| `amavis/` | `amavis_data` | Amavis quarantine archive |
| `authelia/db/` | `authelia_db` | Authelia state DB |
| `authelia/logs/` | `authelia_logs` | Authelia logs |
| `authelia/redis/` | `authelia_redis` | Authelia Redis |
| `commandbox/serverhome/` | `commandbox_serverhome` | Lucee server home |
| `dmarc/logs/` | `dmarc_logs` | OpenDMARC logs |
| `dovecot/logs/` | `dovecot_logs` | Dovecot service logs |
| `dovecot/sieve/` | `dovecot_sieve` | Sieve scripts (shared by commandbox + dovecot) |
| `ldap/data/` | `ldap_data` | OpenLDAP data |
| `ldap/logs/` | `ldap_logs` | OpenLDAP logs |
| `mail_filter/data/amavis/` | `mail_filter_data_amavis` | Amavis runtime state |
| `mail_filter/data/clamav/` | `mail_filter_data_clamav` | ClamAV signatures |
| `mail_filter/data/fangfrisch/` | `mail_filter_data_fangfrisch` | Fangfrisch state |
| `mail_filter/logs/` | `mail_filter_logs` | Mail filter logs |
| `nginx/logs/` | `nginx_logs` | Nginx logs |
| `postfix_dkim/logs/` | `postfix_dkim_logs` | Postfix logs |
| `postfix_dkim/queue/` | `postfix_dkim_queue` | Postfix mail queue |

### Tier 3 — Vmail (default `/mnt/vmail/`)

| Sub-path | Named volume | Service |
| --- | --- | --- |
| `dovecot_mail/` | `dovecot_mail` | Dovecot mailboxes |

### Tier 4 — Nextcloud (default `/mnt/files/`)

| Sub-path | Named volume | Service |
| --- | --- | --- |
| `app/` | `nextcloud` | NC app + user files |
| `redis/` | `nextcloud_redis` | NC's Redis cache |

## How it works at install time

1. `prompt_mount_points()` asks the operator for three paths (Data / Vmail / Nextcloud) — Config is already chosen by where the repo lives. Defaults `/mnt/data`, `/mnt/vmail`, `/mnt/files`. Choices saved to `.hermes_install_config` at the install root.

2. `provision_mount_dirs()` creates the entire sub-directory layout under each chosen path with the correct UID/GID for the containers that will write to them. Critical: bind-mounted volumes (`type: none, o: bind` in `docker-compose.override.yml`) require the source directory to **pre-exist** — Docker refuses to start the container otherwise.

3. `generate_compose_override()` reads `.hermes_install_config` and emits per-volume bind directives in `docker-compose.override.yml` (which Docker Compose auto-merges with the base file). Each named volume in `docker-compose.yml` maps to exactly one tier.

4. If the operator answered empty for a tier, the override omits those volumes — Docker's default named-volume kicks in for them (`/var/lib/docker/volumes/`).

## Self-locating scripts

`install_hermes_docker.sh`, `rotate_db_credentials.sh`, and any other Hermes script needing the install root use a **walk-up self-locator** pattern that finds `docker-compose.yml` by walking up from `BASH_SOURCE[0]`:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]] && [[ ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "ERROR: Could not locate docker-compose.yml in any parent of $SCRIPT_DIR" >&2
        echo "Set HERMES_ROOT environment variable manually and retry." >&2
        exit 1
    fi
fi
```

This is depth-independent (works at 1 level or 5 levels deep in the tree) and survives the script being relocated. **Do not use a hardcoded `dirname/..` chain** — it depends on the script's exact depth and breaks silently if the script moves.

## Reading topology at runtime

`.hermes_install_config` is the source of truth for which paths the operator chose. Scripts that need this (`system_backup.sh`, `system_restore.sh`) source the file via the `load_config()` helper. Format:

```bash
DATA_MOUNT=/mnt/data
VMAIL_MOUNT=/mnt/vmail
FILES_MOUNT=/mnt/files
ENABLE_NEXTCLOUD=true
```

The file lives in the Config tier (install root), so it's part of every Config-tier backup automatically.
