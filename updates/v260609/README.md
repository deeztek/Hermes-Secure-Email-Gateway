# Hermes SEG v260609

Release notes and per-release update artifacts for **v260609**. This file is the canonical
v260609 upgrade document and doubles as the GitHub Release body
(`gh release create v260609 --notes-file updates/v260609/README.md`).

## What's new in v260609

v260609 is a **backup, disaster-recovery, and upgrade-tooling** release on top of the v260119
baseline. Highlights:

- **Docker-aware backup & restore.** A rebuilt `system_backup.sh` and `system_restore.sh` —
  hot (zero-downtime) backups, scoped/slim storage tiers, a directory-style backup format,
  streamed restore (no double-staging), disk-space pre-checks, and email notifications
  (`--notify-email`, `--notify-on-success`). (#219)
- **Cross-host disaster recovery + re-host.** Restore a backup onto fresh hardware:
  `system_restore.sh` auto-remaps the storage topology when it differs from the source, and a
  new `system_rehost.sh` rewires host identity after a restore-to-new-hardware. A version-match
  gate guards against accidental cross-version restores. (#220)
- **Smoother in-place upgrades.** The `system_update_docker.sh` orchestrator gains a
  pre-container `pre-scripts/` hook and self-re-exec, so upgrades that must migrate files or
  credentials *before* containers restart now work cleanly. (#221)
- **Authelia credential cleanup.** Authelia DB credentials moved from `keys/` to `creds/`
  (alongside the other service-account credentials). **This upgrade migrates them for you
  automatically** — see the required procedure below.
- **Install-script reliability fixes.** All bundled scripts are now marked executable (fixes a
  *"There was an error executing …"* failure on some admin disk-usage panels), clearer install
  progress output, corrected install-summary paths, and removal of a misleading console-host
  prompt.
- **Documentation.** README rewrite with logo + screenshots, full end-user portal docs
  (11 pages), an expanded backup/restore admin guide, and a BookStack documentation-sync
  pipeline. (#259)

> **Note:** Email Policies (Disclaimers, External Sender Banner), Organizational/Personal
> Signatures, ARC, two-factor enforcement, the device-setup wizard, and the certificate UX
> all shipped in **v260119** — they are not new here.

## Bugs fixed

- [#266](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/266) — repo `.sh` scripts
  shipped non-executable (`100644`), so CFML admin panels that shell out failed with *"There was an
  error executing …"* (e.g. the dashboard disk-usage panel via `disk_space_usage_archive.sh`). Now
  `chmod +x` at build time and re-applied on install/restore via `ensure_scripts_executable`.
- [#267](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/267) — `hermes_smoke_test.sh`
  hardcoded `build_no=v260119`, so the post-install smoke test falsely failed on every release after
  v260119. Now version-agnostic (reports `build_no`; optional `EXPECTED_BUILD=vYYMMDD` to assert).

## ⚠️ REQUIRED — upgrading from v260119 to v260609

**Do not run the normal `system_update_docker.sh v260609` command for this upgrade.** It
will fail when containers restart (`docker compose up` → *"bind source path does not exist"*
for a new Authelia storage secret).

v260609 is the first release to add the orchestrator's `pre-scripts/` hook and self-re-exec.
The **v260119** orchestrator predates both, so it cannot run this release's pre-container
Authelia credential migration before restarting containers. Because the fix ships *inside*
v260609, it can't bootstrap itself onto a v260119 box — you must run v260609's orchestrator
directly, via the one-time bridge below.

**Recommended — one command** (from your install directory):

```bash
cd /opt/hermes-seg                 # your Hermes install directory
git fetch --tags origin
sudo bash <(git show v260609:updates/v260609/upgrade-to-v260609.sh)
```

**Manual equivalent** (same steps, if you prefer to run them yourself):

```bash
cd /opt/hermes-seg
git stash                          # set aside install-time config drift
git fetch --tags origin
git checkout v260609
sudo ./scripts/system_update_docker.sh --skip-git v260609
```

This procedure is required **only** for the v260119 → v260609 hop. Every later upgrade uses
the normal `system_update_docker.sh <tag>` command, because v260609+ self-re-execs.

Already ran the normal command and hit the error? No harm done — run the procedure above and
the upgrade completes cleanly.

## What this release ships

| Path | Phase | Purpose |
|---|---|---|
| `pre-scripts/01-migrate-authelia-creds.sh` | 2 (pre) | Moves Authelia DB creds `keys/ → creds/` **before** compose up (new `AUTHELIA_STORAGE_USERNAME`/`PASSWORD` secrets) |
| `scripts/01-regen-authelia-config.sh` | 3 | Regenerates Authelia `configuration.yml` for the MySQL storage backend + restarts the container |
| `sql/schema_updates.sql` | 3 | Schema deltas + the `build_no` version stamp |
| `upgrade-to-v260609.sh` | — | The one-time bridge above (wraps stash → fetch → checkout → `--skip-git`) |

## Why two issues compound on this one hop

1. **Bootstrap gap.** v260119's orchestrator has no `pre-scripts/` handling and no
   self-re-exec, so it never runs `pre-scripts/01-migrate-authelia-creds.sh`. The Authelia
   creds stay in `keys/`, while v260609's `docker-compose.yml` references `creds/authelia_*`
   → `docker compose up` fails on the missing secret. The bridge runs v260609's orchestrator
   instead (`git checkout v260609` + `--skip-git`), so the pre-script fires.
2. **#256 dirty tree.** A fresh v260119 install mutates tracked files (fail2ban defaults,
   SpamAssassin bayes DB, slapd ldif, install-substituted templates), so the orchestrator
   preflight (`git diff --quiet`) aborts with "uncommitted changes." The bridge's `git stash`
   clears it. (The forward fix — gitignore + `git rm --cached` the runtime-mutable files — is
   tracked separately and does not help this hop, since the v260119 preflight is already shipped.)

## Apply order (once v260609's orchestrator is running)

Per the standard orchestrator flow (`system_update_docker.sh`, #221):

1. **Phase 2 pre-scripts** — `pre-scripts/*.sh` run BEFORE `docker compose pull && up -d`
2. **Phase 2** — `docker compose pull` + `up -d`
3. **Phase 3** — `sql/*.sql`, then `cfml/*.cfm` (none this release), then `scripts/*.sh`
4. **Phase 4 / 5** — standard finalize + post-upgrade hook

Each artifact is idempotent; re-running is a no-op.

See [`docs/install/release-and-update-methodology.md`](https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/v260609/docs/install/release-and-update-methodology.md)
for the full release/upgrade methodology.
