# Backup/Restore

Admin path: **System > Backup/Restore** (`view_system_backup.cfm`).

> **CLI-only by design.** Backup and restore run from the Docker host's shell, not from the admin console. The admin console's *Backup/Restore* page is a read-only info surface (CLI examples + a list of backups detected on disk + a link back to this doc). There are no buttons. Long-running operations + web UIs is a known footgun (page reload kills progress, browser timeouts, race conditions); the CLI is the canonical interface.

## What ships in this release

Two scripts under [`scripts/`](../../../scripts/):

| Script | Purpose |
|---|---|
| [`system_backup.sh`](../../../scripts/system_backup.sh) | Cold-mode full-stack backup: stops the stack, dumps all six databases, tars all five storage tiers, emits a manifest with SHA256 per archive, atomically renames `.partial` to final, restarts the stack. |
| [`system_restore.sh`](../../../scripts/system_restore.sh) | Cold-mode restore: verifies the manifest + per-archive SHA256 BEFORE any destructive action, refuses on storage-topology mismatch unless `FORCE_REMAP=1` is set, stops the stack, restores all six databases via socket auth, rsyncs each tier from staging to its mount path with `--delete`, restarts the stack, verifies Nextcloud is not stuck in maintenance mode post-restore. |

**Cold mode means the stack is stopped for the duration of the backup or restore** — 5–15 minutes for small sites, longer for large mailbox / Nextcloud installs. Plan around your mail-flow tolerances. For zero-downtime backups, use hypervisor snapshots (see [Hot-backup alternatives](#hot-backup-alternatives)) until hot-mode lands.

## Backup

### Backup quick start

```bash
sudo /opt/hermes-seg-docker-gl/scripts/system_backup.sh -P /mnt/backups
```

The script creates `/mnt/backups/hermes-backup-<build_no>-<UTC-timestamp>.tar`. The outer tar is uncompressed (each tier inside is already `.tar.gz`); operators can `tar -xf` it once to inspect the manifest before deciding to restore.

### Output layout

Inside the outer `.tar`:

```text
backup_manifest.json           ← topology, build, timestamps, SHA256 per archive
databases.tar.gz               ← all six .sql files
config.tar.gz                  ← install root MINUS data tiers
                                  (excludes install-logs/ and .git/)
data.tar.gz                    ← the Data tier (/mnt/data)
archive.tar.gz                 ← the Archive tier (/mnt/archive)
vmail.tar.gz                   ← the Vmail tier (/mnt/vmail)
nextcloud.tar.gz               ← the Nextcloud tier (/mnt/files)
```

### Backup flags

| Flag | Purpose |
|---|---|
| `-P <path>` | **Required.** Output directory. Must exist and be writable. |
| `--yes` (or `-y`) | Skip the interactive confirmation prompt. Use for cron / Ofelia. |
| `--dry-run` (or `-n`) | Print what would happen without stopping anything or writing any files. |
| `--help` (or `-h`) | Show usage. |

### Scheduling

For nightly automated backups, register the command as an Ofelia job using the existing **System > Scheduled Tasks** admin page. The Ofelia job is just a shell command on the Docker host; no separate backup-scheduling UI exists by design. Example Ofelia job spec:

```text
schedule: 0 0 3 * * *
command:  /opt/hermes-seg-docker-gl/scripts/system_backup.sh -P /mnt/backups --yes
```

The script's exit code reflects success (0) or failure (non-zero), so Ofelia's built-in alerting picks up failures.

### Off-site copy

`system_backup.sh` writes to the local `-P` path only. Off-site copy is left to your existing tooling — `rclone`, `rsync` to remote storage, `aws s3 cp`, `restic`, whatever you already use. Typical pattern:

```bash
sudo /opt/hermes-seg-docker-gl/scripts/system_backup.sh -P /mnt/backups --yes \
  && rclone sync /mnt/backups remote:hermes-backups/
```

## Restore

### Restore quick start

```bash
sudo /opt/hermes-seg-docker-gl/scripts/system_restore.sh -F /mnt/backups/hermes-backup-v260119-20260601T103000Z.tar
```

**This replaces all current data on this host** with the backup's contents — all six databases, the install root (repo working tree, secrets, `.env`), and all four storage tiers. The stack is stopped for the duration. There is no rollback once it starts.

### Safety: SHA256 verification + topology refusal

Two gates fire BEFORE any destructive action:

1. **Manifest SHA256 verification.** Every inner archive's SHA256 is checked against the manifest. If any byte of the backup is corrupt or tampered with, the restore aborts BEFORE stopping the stack or touching any data.
2. **Storage-topology refusal.** If the backup's recorded mount paths (`/mnt/data`, `/mnt/vmail`, etc.) don't match this host's current mount paths from `.env`, the restore aborts with a clear error and instructions for forcing a remap.

To restore a backup onto a host with a different storage topology (e.g., backup took on a 5-tier-split host, restoring onto a single-mount host where everything lives under `/mnt/data`), set `FORCE_REMAP=1`:

```bash
sudo FORCE_REMAP=1 /opt/hermes-seg-docker-gl/scripts/system_restore.sh -F /path/to/backup.tar
```

`FORCE_REMAP=1` is all-or-nothing in Phase A. A per-tier `--remap-tiers` flag will land in Phase B.

### Disaster-recovery flow (different host)

1. Install Hermes fresh on the new host using [`install_hermes_docker.sh`](../../../scripts/install_hermes_docker.sh). The install root needs to exist and `.env` needs to be populated with the right mount paths before restore can succeed.
2. `scp` the backup tarball from off-site storage to the new host.
3. Run `system_restore.sh -F /path/to/backup.tar`. If the new host's mount paths differ from the original (typical when restoring onto different hardware), prefix with `FORCE_REMAP=1`.
4. Verify the admin console loads and a test message flows end-to-end.

### Restore flags

| Flag | Purpose |
|---|---|
| `-F <path>` | **Required.** Path to the backup tarball produced by `system_backup.sh`. |
| `--yes` (or `-y`) | Skip the interactive confirmation prompt. |
| `--dry-run` (or `-n`) | Show what would happen without changing anything. |
| `--help` (or `-h`) | Show usage. |
| `FORCE_REMAP=1` (env) | Required to proceed past the topology-mismatch refusal. |

## Hot-backup alternatives

Cold mode means downtime. When zero-downtime is needed (busy mail flow, can't take an outage window), use **hypervisor / VM snapshots** instead. Snapshot the entire Hermes host VM via your virtualization platform's native mechanism:

| Platform | Snapshot mechanism |
|---|---|
| Proxmox VE | Datacenter > Backup, or Snapshot from the VM's right-click menu |
| VMware vSphere / ESXi | VM > Snapshots > Take Snapshot |
| KVM / libvirt | `virsh snapshot-create-as <domain> <name> --disk-only --atomic` (or `virt-manager`) |
| AWS EC2 | EBS volume snapshot (or AMI for a full image) |
| Azure VMs | Disk snapshot, or Recovery Services Vault |
| Google Compute Engine | Disk snapshot |
| Hyper-V | Checkpoint |

Take the snapshot with the VM either:

1. **Powered off** — safest.
2. **Quiesced via guest tools** — VMware Tools, qemu-guest-agent, Hyper-V Integration Services. Verify quiesce behavior on your specific guest OS first.

A whole-VM snapshot captures every storage tier, every database, every container's state, and the Docker daemon's metadata in one consistent point-in-time image. Restoration is your hypervisor's "revert to snapshot" — no Hermes-specific tooling needed.

**Always take a hypervisor snapshot before running `system_update_docker.sh`** for any upgrade — that gives you a working rollback if the upgrade fails mid-flight.

## What you should NOT do

### Do NOT run the legacy bare-metal scripts on a Docker host

The pre-Docker `config/hermes/opt/hermes/scripts/system_backup.sh` and `system_restore.sh` are kept in the repo for reference and for the legacy-to-Docker migration path. **Do not run them on a Docker install.** Specifically:

- The legacy `system_restore.sh` does `cd / && tar -xvzf <backup-file>` — extracts the backup tarball relative to the host filesystem root. On a Docker host it will overwrite host directories with files from a layout that does not match the Docker host's reality. Hermes services fail to start, host OS may become unbootable.
- The legacy `system_backup.sh` does not know about the Authelia or Nextcloud databases (which didn't exist in the bare-metal era), does not coordinate with running containers, and produces backups that won't restore on a Docker install via the new Docker-aware restore.

The Docker-aware scripts under [`scripts/`](../../../scripts/) are the only safe option.

### Do NOT tar a running storage tier

If for some reason you reach for `tar` directly instead of `system_backup.sh`, do NOT tar `/mnt/data`, `/mnt/vmail`, `/mnt/files`, or `/mnt/archive` while the stack is running:

- `/mnt/data` contains MariaDB's tablespace files — tar'ing while `hermes_db_server` is running produces a backup MariaDB will reject as inconsistent on restore.
- `/mnt/vmail` contains Dovecot mailboxes — tar'ing while `hermes_dovecot` has them open captures torn writes mid-delivery.
- `/mnt/files` contains Nextcloud user files plus the NC Redis cache state — file-level copies break NC's `oc_filecache` table's consistency with the underlying filesystem.

If you want a file-level backup outside of `system_backup.sh`, stop the stack first (`docker compose down`), tar, then restart (`docker compose up -d`).

### Do NOT trust an untested restore procedure

Whatever backup strategy you adopt (cold-mode scripts, hypervisor snapshots, file-level), **practice the restore at least once on a non-production system before you rely on it.** Take a backup of your live Hermes host, spin up a second VM, run the restore, and verify you can log into the admin console and send a test message. A backup procedure that has never been restored from is not a backup procedure — it is wishful thinking.

## What's coming in Phase B

The Phase A scripts are deliberately minimal. The Phase B refactor (post-Link-Guard) will add:

- **Scoped categories** (`--scope=config|data|archive|vmail|nextcloud|all`) so operators can back up or restore just one tier
- **Hot mode** (`mariadb-backup` for DBs + NC `occ maintenance:mode --on` for files) for zero-downtime backups without needing hypervisor snapshots
- **Retention pruning** (`--retain-last=N` deletes older backups beyond N)
- **Ofelia-scheduled** backups configured natively (today the operator wires it up by hand via the Scheduled Tasks page)
- **Net::SMTP** notification on success/failure (today's pattern is "pipe exit code into your existing alerting")
- **Per-tier `--remap-tiers`** flag replacing the all-or-nothing `FORCE_REMAP=1` env var
- **Selective container restart** instead of full `compose down` (faster restart, smaller blast radius)

Tracking: [#219](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219) for the backup-side enhancements, [#220](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220) for the restore-side.

## Migrating from a legacy bare-metal install

A separate tool exists at [`scripts/migrate_legacy_to_docker.sh`](../../../scripts/migrate_legacy_to_docker.sh) for operators moving from a legacy bare-metal install to the Docker install. It consumes a backup produced by the **legacy** `system_backup.sh` (which is correct in the bare-metal context where it ran) and restores it into the Docker layout via a translation step — NOT the same as running the legacy restore script directly. See the migration section of the [v260119 release notes](https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases/tag/v260119) for current scope.

## Cross-references

- [Storage Topology](../../install/storage-topology.md) — the five-tier layout the backup operates on
- [Release & Update Methodology](../../install/release-and-update-methodology.md) — recommends taking a hypervisor snapshot before running `system_update_docker.sh`
- [scripts/migrate_legacy_to_docker.sh](../../../scripts/migrate_legacy_to_docker.sh) — separate from backup/restore; for one-time bare-metal-to-Docker migration only
