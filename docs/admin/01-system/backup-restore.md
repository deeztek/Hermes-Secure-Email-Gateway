# Backup/Restore

Admin path: **System > Backup/Restore** (`view_system_backup.cfm`).
Underlying scripts: `scripts/system_backup.sh` (#219, pending Docker
rewrite) and `scripts/system_restore.sh` (#220, pending Docker rewrite).
Both are tracked but **not yet shipped** in the current build.

This page is where the operator will eventually run scoped backups
across Hermes's [five storage tiers](../../install/storage-topology.md),
inspect past backup archives, and restore from them. Backup and
restore are the operational surface that ties the storage topology
together — what you can back up cleanly depends entirely on which
paths the operator chose at install time for Data, Archive, Vmail,
and Nextcloud, and the script reads those choices back from
`.hermes_install_config` at runtime.

> **The page is currently a notice, not a workflow.** In today's
> build, `view_system_backup.cfm` displays an alert pointing at the
> external admin-guide docs and instructs the admin to run
> backup/restore via SSH against the legacy
> `/opt/hermes/scripts/system_backup.sh` and `system_restore.sh`
> scripts (the pre-Docker shell wrappers carried over verbatim into
> `config/hermes/opt/hermes/scripts/`). The Docker-aware refactor
> tracked by [#219](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219)
> and [#220](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220)
> will replace those wrappers with topology-aware versions and wire
> a launch button into this page. Until that ships, the workflow
> below is the supported path.

## Scope model (planned for #219)

The Docker-aware backup script will offer five scopes that map
one-to-one onto the storage topology:

| Scope | What's included | Typical use |
|---|---|---|
| `system` | Config tier + Data tier (DBs, configs, logs) | Disaster-recovery snapshot; fits on modest backup storage |
| `archive` | Just the Archive tier — Amavis quarantine archive at `<ARCHIVE_MOUNT>/amavis/` | Compliance / retention; separate cadence from system backups |
| `vmail` | Just the Vmail tier (Dovecot mailboxes under `<VMAIL_MOUNT>/dovecot/`) | Per-user mail recovery; mailbox migration |
| `nextcloud` | Just the Nextcloud tier (`<FILES_MOUNT>/app/` + the NC database) | File-store recovery; large, slow |
| `all` | Every tier in a single archive | Cold-storage full backup |

Splitting the scopes lets each tier ride its own cadence. Most sites
run `system` nightly, `archive` weekly, and `vmail` / `nextcloud` on
a cadence matching their actual change rate.

## Tier coverage at a glance

Each scope draws from the [5-tier storage topology](../../install/storage-topology.md)
in a different combination:

```
                  Config       Data          Archive        Vmail         Nextcloud
                  (install     (/mnt/data)   (/mnt/archive) (/mnt/vmail)  (/mnt/files)
                   root)
                  ---------    ---------     ----------     ---------     ----------
system            [INCLUDED]   [INCLUDED]    [skipped]      [skipped]     [skipped]
archive           [skipped]    [skipped]     [INCLUDED]     [skipped]     [skipped]
vmail             [skipped]    [skipped]     [skipped]      [INCLUDED]    [skipped]
nextcloud         [skipped]    [nc DB only]  [skipped]      [skipped]     [INCLUDED]
all               [INCLUDED]   [INCLUDED]    [INCLUDED]     [INCLUDED]    [INCLUDED]
```

Since #260 promoted Archive to its own tier, the `system` scope no longer needs to exclude `amavis/` from the Data tier — the two are now physically separate paths. Operators who kept Archive collocated with Data (`ARCHIVE_MOUNT == DATA_MOUNT`) still get the same backup shape because the script reads the actual path from `.hermes_install_config` per-scope.

Config tier is implicit — it's wherever the operator ran `git clone`.
The script self-locates the install root via the walk-up locator
described in [Storage Topology § Self-locating scripts](../../install/storage-topology.md#self-locating-scripts).

## Databases included

All Hermes databases live in `hermes_db_server` (MariaDB). The
planned script dumps them via `docker exec hermes_db_server
mariadb-dump …` rather than reaching into the data directory:

| Database | Scope it ships in | Notes |
|---|---|---|
| `hermes` | `system`, `all` | Core admin config, parameters, policies |
| `djigzo` | `system`, `all` | Ciphermail encryption state |
| `opendmarc` | `system`, `all` | DMARC aggregate-report history |
| `Syslog` | `system`, `all` | rsyslog event store (large; index choices affect dump size) |
| `authelia` | `system`, `all` | TOTP secrets, WebAuthn devices, identity verification, session history |
| `nextcloud` | `nextcloud`, `all` | NC app data, shares, comments, activity |

Dumping via `mariadb-dump` against the running container yields a
consistent-enough snapshot for disaster recovery — InnoDB's MVCC
ensures the dump reflects a single point in time per table. It does
**not** suspend writes, so a transaction in flight at dump time may
or may not appear in the snapshot. For point-in-time-precise
backups, stop `hermes_db_server` briefly before the dump (the
script will offer a `--quiesce` flag for this).

## Reading the operator's tier choices

The planned `load_config()` helper sources `.hermes_install_config`
from the install root:

```bash
DATA_MOUNT=/mnt/data
ARCHIVE_MOUNT=/mnt/archive
VMAIL_MOUNT=/mnt/vmail
FILES_MOUNT=/mnt/files
ENABLE_NEXTCLOUD=true
```

Every scope's source-path logic is derived from these variables.
This means:

- If the operator chose `DATA_MOUNT=/srv/hermes-data` at install,
  the `system` scope follows them there automatically without script
  edits.
- If `ENABLE_NEXTCLOUD=false`, the `nextcloud` scope refuses to run
  and `all` skips that tier silently.
- If a tier was left empty at install (falling back to a Docker
  default named volume under `/var/lib/docker/volumes/`), the
  script resolves the volume path via `docker volume inspect` so
  the bind-vs-volume distinction is invisible to the backup
  workflow.

`.hermes_install_config` itself lives in the Config tier and is
captured by every `system` and `all` backup. A restore therefore
recovers not just the data but the topology declaration that told
the original install where to put it.

## Today's workflow (legacy, pre-#219)

The legacy scripts under `config/hermes/opt/hermes/scripts/`
(`system_backup.sh`, `system_restore.sh`) carried over from the
pre-Docker era. They predate the 5-tier topology and assume a single
flat layout under `/mnt/data` and `/mnt/vmail`. They work on
Docker installs only because those mount points are the defaults.

```
# Run a system backup via SSH on the Docker host
docker exec hermes_commandbox /opt/hermes/scripts/system_backup.sh \
    -D '7' \
    -P '/mnt/backups' \
    -E 'admin@example.com' \
    -F 'postmaster@example.com' \
    -B 'system' \
    -R 'mysql_root_password'

# Restore from a system backup archive
docker exec hermes_commandbox /opt/hermes/scripts/system_restore.sh \
    -F '/mnt/backups/hermes-system-260119-05-26-2026-1430.tar.gz' \
    -M 'system' \
    -R 'mysql_root_password'
```

The legacy script accepts three scopes (`system`, `archive`, `all`)
not five — the `vmail` and `nextcloud` splits are part of the #219
refactor. Output archives are named
`hermes-<scope>-<build_no>-<MM-DD-YYYY-HHMM>.tar.gz` and land at
`-P <path>`. Retention pruning (`-D <days>`) deletes older archives
in the same path.

> **Operational caveat.** The legacy script reads MySQL credentials
> from `/opt/hermes/creds/hermes_username` and
> `/opt/hermes/creds/hermes_password` and connects to
> `127.0.0.1:3306`. Inside `hermes_commandbox`, that resolves to the
> container's loopback — not to `hermes_db_server`. The script
> works on current builds because the database container is reached
> as a named host (`hermes_db_server`) via the Docker network, and
> the legacy script's hostname needs the `-h` patch the #219
> refactor will bake in. If you hit "can't connect to MySQL on
> 127.0.0.1" running the legacy script, that's the cause.

## Restore concerns

Restore is more fragile than backup because the script is writing
into live state.

### Container quiescence

The planned restore will stop the affected containers before
extraction and start them afterward. For a `system` restore that
means stopping `hermes_commandbox`, `hermes_postfix_dkim`,
`hermes_mail_filter`, and friends. For a `nextcloud` restore, just
`hermes_nextcloud`. For `all`, everything.

The legacy script does **not** stop containers — it relies on tar
extracting into bind-mounted paths the containers happen to have
open. That works for static config files but is a hazard for
SQLite-backed sub-services and for the Postfix queue.

### Postfix queue draining

If a restore runs while mail is in `hermes_postfix_dkim`'s active
queue, that queue gets clobbered when the Data-tier postfix-queue
directory is overwritten. Mail loss is the visible symptom. Drain
the queue first:

```
docker exec hermes_postfix_dkim postsuper -h ALL    # hold the queue
docker exec hermes_postfix_dkim postqueue -f        # flush attempts
# wait for `mailq` to report empty, then proceed with restore
```

### Topology validation

A `system` archive captures `.hermes_install_config`. Restoring it
onto a host where the operator chose **different** tier paths
silently miswires the layout — bind mounts in
`docker-compose.override.yml` point at paths that don't exist, and
containers fail to start. The #220 rewrite will refuse to restore
unless the target host's `.hermes_install_config` matches the one
in the archive, or unless the operator passes `--remap-tiers` to
explicitly accept the mismatch.

### Hot-running Amavis archive

The `archive` scope tars `<DATA_MOUNT>/amavis/` while Amavis is
running. Messages quarantined during the tar pass may or may not
make it into the archive depending on tar's stat-vs-read ordering.
For compliance-grade archive snapshots, stop `hermes_mail_filter`
during the tar — but then you're stopping mail filtering for the
duration of the backup. The operational trade-off is real; the
script can't make it for you.

## Inspecting past backups

Today, this means `ls -lh` on the backup path. The planned page
will list every archive present at the configured backup path,
parse the filename for scope and timestamp, surface size and age,
and offer per-archive Restore and Delete buttons.

There is no database table tracking backup history — the filesystem
itself is the canonical inventory. This is deliberate: backups need
to survive total Hermes loss, so making the inventory a function of
file presence (not a row in the `hermes` DB) means an admin
recovering from bare metal can list archives without first standing
up the DB.

## Backup schedule (planned)

The legacy `daily_backup.sh` (also at
`config/hermes/opt/hermes/scripts/`) is the cron-callable wrapper.
On Docker installs, the #219 refactor will move scheduling into the
Ofelia table alongside every other recurring Hermes job — see
[Scheduled Tasks](scheduled-tasks.md). The seeded job will be
disabled by default; an admin must enable it from this page after
choosing scope, destination, retention, and notification email.

The current build has no Ofelia entry for backups. Operators who
want recurring backups today are setting up host crontab entries
that `docker exec` into `hermes_commandbox` and call the legacy
script — outside Hermes's own visibility.

## Migrating from a legacy (non-Docker) install

Separate from this page's normal backup/restore workflow, the
[`scripts/migrate_legacy_to_docker.sh`](../../scripts/migrate_legacy_to_docker.sh)
one-shot consumes a legacy `hermes-system-*.tar.gz` produced by an
**old non-Docker** Hermes SEG host's `system_backup.sh` and lands
its contents into a fresh Docker install. It's a parallel tool, not
something invoked from this page:

```
./scripts/migrate_legacy_to_docker.sh \
    -B /path/to/hermes-system-backup.tar.gz \
    -R 'mysql_root_password' \
    -D /opt/hermes-seg \
    -M /mnt/data \
    -V /mnt/vmail
```

The migration script restores the four legacy databases (`hermes`,
`djigzo`, `opendmarc`, `Syslog`) into `hermes_db_server` and
**creates fresh empty** `authelia` and `nextcloud` databases — the
legacy world had neither, so there's nothing to carry forward.
System users have to be re-created in LDAP (the migration script
prints guidance). Web-application files under `/var/www/html` are
**not** copied — the Docker repo ships its own.

Use this script exactly once at cut-over time. After it's run, this
page's normal backup/restore workflow takes over.

## Failure semantics

| What breaks | What happens |
|---|---|
| Backup destination path doesn't exist | Legacy script aborts with `Backup Path does not exist`. The #219 rewrite will offer to create it. |
| Backup destination out of space | tar fails mid-write; archive is left truncated. Retention pruning won't delete it because the filename matches the pattern; cleanup is manual. |
| `mariadb-dump` cannot reach `hermes_db_server` | Dump file is empty (or zero-row), tar succeeds, restore would silently restore nothing. The #219 rewrite will refuse to package a dump smaller than a sentinel threshold. |
| Restore target's `.hermes_install_config` mismatches the archive | Legacy script proceeds blindly and breaks the install. The #220 rewrite will refuse without `--remap-tiers`. |
| Restore runs against a half-stopped stack | Bind-mounted config files clobber while containers still hold old copies in memory; restart resolves; transient errors during the window. |
| `archive` scope tar racing live Amavis writes | New quarantine entries in flight at tar time may be partial or missing. Not an error — just an inconsistency. |
| `vmail` scope restore over a running Dovecot | Dovecot's index files become stale; user mail clients see "this folder has changed unexpectedly". Index rebuild on next IMAP connect resolves. |
| `nextcloud` scope restore without matching DB restore | NC app files reference rows in `oc_filecache` that don't exist; users see empty file trees. Always restore the `nextcloud` DB and the file tree as a pair. |

## Files and containers touched

| Path | Owner | Role |
|---|---|---|
| `config/hermes/var/www/html/admin/2/view_system_backup.cfm` | `hermes_commandbox` | The admin page (notice today; backup/restore workflow after #219/#220) |
| `scripts/system_backup.sh` | host shell | **Planned** Docker-aware backup orchestrator (#219) |
| `scripts/system_restore.sh` | host shell | **Planned** Docker-aware restore orchestrator (#220) |
| `scripts/migrate_legacy_to_docker.sh` | host shell | One-shot legacy → Docker migration; uses legacy archives |
| `config/hermes/opt/hermes/scripts/system_backup.sh` | `hermes_commandbox` | Legacy pre-Docker backup script; still functional |
| `config/hermes/opt/hermes/scripts/system_restore.sh` | `hermes_commandbox` | Legacy pre-Docker restore script; still functional |
| `config/hermes/opt/hermes/scripts/daily_backup.sh` | `hermes_commandbox` | Legacy cron wrapper around `system_backup.sh` |
| `config/hermes/opt/hermes/templates/backup_task.cfm` | `hermes_commandbox` | Legacy CFML template for scheduling backup tasks; superseded by Ofelia |
| `config/hermes/opt/hermes/templates/restore_task.cfm` | `hermes_commandbox` | Legacy CFML template for scheduling restore tasks; superseded by Ofelia |
| `.hermes_install_config` | install root (Config tier) | Operator's tier choices; `load_config()` reads this |
| `<DATA_MOUNT>/amavis/` | `hermes_mail_filter` | Source for `archive` scope |
| `<VMAIL_MOUNT>/dovecot_mail/` | `hermes_dovecot` | Source for `vmail` scope |
| `<FILES_MOUNT>/app/` | `hermes_nextcloud` | Source for `nextcloud` scope |
| `hermes`, `djigzo`, `opendmarc`, `Syslog`, `authelia`, `nextcloud` databases | `hermes_db_server` | Dumped via `mariadb-dump` into the archive |

## Related

- [Storage Topology](../../install/storage-topology.md) — **the
  canonical reference** for the 4-tier layout this page operates
  over. Read it before configuring backup destinations or planning
  a restore.
- [System Update](system-update.md) — the orchestrator pattern
  parallel to backup/restore; updates touch the same tiers but in
  a different direction
- [Scheduled Tasks](scheduled-tasks.md) — where the post-#219
  recurring-backup job will live once the Ofelia entry is seeded
- [System Status](system-status.md) — the dashboard will eventually
  surface "last successful backup" age as a system-health cell
- [System Notifications](system-notifications.md) — backup
  success/failure emails go to `admin_email` (`-E` flag today; an
  admin-page setting after #219)
- [Release and Update Methodology](../../install/release-and-update-methodology.md)
  — describes the per-release artifact category the #219/#220
  refactor will ship as
