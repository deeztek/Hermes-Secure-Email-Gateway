# Backup/Restore

Admin path: **System > Backup/Restore** (`view_system_backup.cfm`).

> **Coming soon.** First-class Docker-aware backup and restore tooling is in development and is **not yet shipped** in this release. Until it lands, the recommended interim strategy is hypervisor / VM snapshots — see [Recommended interim strategy](#recommended-interim-strategy) below. Tracking issues: [#219](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219) (`system_backup.sh` Docker refactor) and [#220](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220) (`system_restore.sh` Docker refactor).

## Why this page is a notice, not a workflow

Hermes shipped for years as a bare-metal Ubuntu install, and the legacy bare-metal install came with `system_backup.sh` and `system_restore.sh` scripts that tarred host paths like `/opt/hermes/`, `/etc/postfix/`, `/var/spool/postfix/`, and `/var/lib/mysql/` into a single archive — then restored by extracting that archive relative to the host filesystem root. That model worked on bare-metal because the backup originated from the same layout it was restored into.

The Dockerized rewrite changed the layout entirely:

- Service config moved into volume-mounted directories under `config/<service>/etc/...` in the repo
- Database files moved into named volumes backed by the host path you chose for the **Data** storage tier
- Mailboxes moved into the **Vmail** tier
- Quarantine moved into the **Archive** tier
- Nextcloud user files moved into the **Nextcloud** tier
- Secrets moved into Docker secret files under `config/hermes/opt/hermes/keys/`

The legacy scripts have no awareness of any of this. They will not capture Authelia or Nextcloud databases (which did not exist in the bare-metal era), they will not correctly stop containers before snapshotting their volumes, and the legacy restore script will overwrite directories on the Docker host that have completely different semantics from where the backup data originally lived. **Running them on a Docker install is unsafe.**

The Docker-aware replacements are the work tracked by [#219](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219) and [#220](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220). They will land in a future release. Until they do, treat the admin page (System > Backup/Restore) as a placeholder and use the interim strategy below.

## Recommended interim strategy

**Hypervisor / VM snapshots.** Take a snapshot of the entire Hermes host VM via your virtualization platform's native snapshot mechanism.

| Platform | Snapshot mechanism |
|---|---|
| Proxmox VE | Datacenter > Backup, or Snapshot from the VM's right-click menu |
| VMware vSphere / ESXi | VM > Snapshots > Take Snapshot |
| KVM / libvirt | `virsh snapshot-create-as <domain> <name> --disk-only --atomic` (or `virt-manager` UI) |
| AWS EC2 | EBS volume snapshot (or AMI for a full image) |
| Azure VMs | Disk snapshot, or Recovery Services Vault for scheduled backups |
| Google Compute Engine | Disk snapshot |
| Hyper-V | Checkpoint (right-click VM > Checkpoint) |

**Take the snapshot with the VM either:**

1. **Powered off** — the safest option. The Hermes mail gateway is offline during this window, so plan around your mail-flow tolerances.
2. **Quiesced through guest tools** — VMware Tools, qemu-guest-agent, Hyper-V Integration Services, etc. all support filesystem-quiesce snapshots that pause writes long enough to capture a consistent image without a full shutdown. Verify your hypervisor's quiesce behavior on your specific guest OS before relying on it for production data.

A whole-VM snapshot captures every storage tier, every database, every container's state, and the Docker daemon's own metadata in one consistent point-in-time image. Restoration is your hypervisor's standard "revert to snapshot" workflow — no Hermes-specific tooling needed.

This is the only backup strategy we currently recommend for Docker installs.

## What you should NOT do

### Do NOT run the legacy CLI scripts

The legacy bare-metal scripts still exist in the repository at `config/hermes/opt/hermes/scripts/system_backup.sh` and `system_restore.sh`. They are kept for reference and for the legacy-to-Docker migration path. **Do not run them on a Docker install.** Specifically:

- The legacy `system_restore.sh` does `cd / && tar -xvzf <backup-file>` — extracting the backup tarball relative to the host filesystem root. On a bare-metal install where the backup was made from the same paths, this is fine. On a Docker host, it will overwrite the host's `/etc/`, `/opt/`, and `/var/` with files from a layout that does not match the Docker host's reality. Hermes services will fail to start; the host's own OS may become unbootable.
- The legacy `system_backup.sh` does not know about the Authelia, Nextcloud, OpenDMARC, Syslog, or CipherMail databases, does not coordinate with running containers, and produces backups that will not restore on a Docker install even with the Docker-aware restore script (when it ships).

### Do NOT tar a running storage tier

`/mnt/data`, `/mnt/vmail`, `/mnt/files`, and `/mnt/archive` all contain files that running containers are actively writing to. Specifically:

- `/mnt/data` contains MariaDB's tablespace files — tar'ing them while `hermes_db_server` is running produces a backup that mariadb-backup or MariaDB itself will reject as inconsistent on restore.
- `/mnt/vmail` contains Dovecot mailboxes — tar'ing them while `hermes_dovecot` has them open captures torn writes mid-delivery.
- `/mnt/files` contains Nextcloud user files plus the NC Redis cache state — file-level copies break NC's `oc_filecache` table's consistency with the underlying filesystem.
- `/mnt/archive` is more tolerant (mostly append-only Amavis quarantine), but still subject to torn writes if Amavis is mid-archive.

If you need file-level rather than VM-level backups while waiting for [#219](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219) / [#220](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220), stop the stack (`docker compose down`), perform the tar, then restart (`docker compose up -d`). That is the cold-backup pattern the Docker-aware tooling will eventually wrap into a single command — but for now it is a manual procedure, with no automated restore counterpart.

### Do NOT trust an untested restore procedure

Whatever interim strategy you adopt, **practice the restore at least once on a non-production system before you rely on it.** A backup procedure that has never been restored from is not a backup procedure — it is wishful thinking. Spin up a second VM, take a snapshot of your live Hermes host, restore it onto the second VM, and verify you can log into the admin console and send a test message before considering the backup viable.

## Migrating from a legacy bare-metal install

A separate migration tool exists at [`scripts/migrate_legacy_to_docker.sh`](../../../scripts/migrate_legacy_to_docker.sh) for operators on a legacy bare-metal install who want to move to the Docker install. That tool consumes a backup produced by the legacy `system_backup.sh` (which is correct in the bare-metal context where it was made) and restores it into the Docker layout via a translation step — not the same as running the legacy restore script directly.

That migration tool is itself early-stage; see the [Migrating from legacy](https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases/tag/v260119) section of the v260119 release notes for current scope and limitations.

## What will land in #219 / #220

The Docker-aware tooling will offer at minimum:

- **Scoped backups** across the five storage tiers (Config, Data, Archive, Vmail, Nextcloud) plus all six MariaDB databases, with `--scope=system|archive|vmail|nextcloud|all` selectors
- **Coordinated quiesce**: optional hot-mode that uses `mariadb-backup` for the databases and Nextcloud `occ maintenance:mode --on` for the file store, so backups can be taken without a full shutdown
- **Topology-aware restore** that refuses to restore a backup made on a 5-tier-split layout onto a single-mount host without an explicit `--remap-tiers` flag
- **Manifest emission + verification**: backups carry a manifest with per-tarball SHA256 sums; restore verifies before extracting
- **Retention pruning** and **Ofelia-scheduled** automatic backups
- **Admin-page integration**: System > Backup/Restore will gain a launch button and a list of past backups with restore actions

Track [#219](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219) and [#220](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220) for progress. Subscribe to release announcements on the [GitHub releases page](https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases) to be notified when the tooling ships.

## Cross-references

- [Storage Topology](../../install/storage-topology.md) — what each of the five tiers contains, which is what backup/restore needs to operate against
- [Release & Update Methodology](../../install/release-and-update-methodology.md) — recommends taking a hypervisor snapshot before running `system_update_docker.sh`
- [scripts/migrate_legacy_to_docker.sh](../../../scripts/migrate_legacy_to_docker.sh) — separate from backup/restore; for one-time bare-metal-to-Docker migration only
