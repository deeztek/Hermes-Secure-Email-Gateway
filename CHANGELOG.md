# Changelog

All notable changes to **Hermes Secure Email Gateway** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Hermes uses **calendar versioning**: release tags are `vYYMMDD`, where the digits are a
planning label named for a target date — **not** necessarily the ship date. The date shown
beside each release below is the **actual release date**.

## Unreleased

### Changed

- **Let's Encrypt / ACME certificate management is now available in all editions** (#282).
  The console-certificate **Request ACME Certificate** button and the mailbox-domain
  **Auto-managed (Let's Encrypt)** SAN certificate mode — automated issuance, SAN
  validation, and auto-renewal — are no longer restricted to Pro Edition. Existing Pro
  installations are unaffected.

## [v260612] — 2026-06-20

**Initial public Docker release.** The first tagged public release of Hermes SEG as a Docker
product, replacing the legacy bare-metal Ubuntu installer with a 19-container Docker Compose
stack. Early-adopter release — feature-complete and validated on our DEV/Test infrastructure;
run your own acceptance tests in parallel before cutting a production gateway over.
**Fresh-install only** (legacy-to-Docker migration tooling is still skeletal).

### Added

- Full Docker stack: 19 containers via a single `docker compose up -d`; no host-level mail services.
- **Link Guard (Pro Edition)** — time-of-click "safe links": inbound links are rewritten through
  a Hermes redirect and reputation-checked **at the moment the user clicks**. Dedicated
  `hermes_linkguard` container; layered verdicts (heuristics + URLhaus / OpenPhish feeds +
  optional Google Safe Browsing / VirusTotal), open-redirect detection, admin-configurable
  per-tier actions, and outbound link restoration.
- Five-tier storage topology (Config / Data / Archive / Vmail / Nextcloud), each independently
  mountable so each tier can live on the right kind of disk.
- Single-command update orchestrator (`scripts/system_update_docker.sh`): a 5-phase pipeline that
  auto-resolves the latest tag via the GitHub Releases API and runs `occ upgrade` on Nextcloud
  version bumps.
- Authelia SSO with unified MFA (TOTP / WebAuthn / Duo Push) across the admin console, user
  portal, and Nextcloud (via OIDC).
- Nextcloud integrated: webmail, file sync, calendars (CalDAV), and contacts (CardDAV) —
  pre-provisioned on first OIDC login.
- Docker-aware backup, cross-host disaster recovery, and re-host tooling (hot backups,
  storage-topology remap, credential reconciliation).
- GitHub-based release pipeline: container images published to
  `ghcr.io/deeztek/hermes-<service>:<tag>`.

Full release notes: [`updates/v260612/README.md`](updates/v260612/README.md).

## [v260609] — 2026-06-11

Backup, disaster-recovery, and upgrade-tooling release on top of the v260119 baseline.

### Added

- Docker-aware backup/restore (`system_backup.sh`, `system_restore.sh`) with hot
  (zero-downtime) backups, scoped storage tiers, and a directory-style format (#219).
- Cross-host disaster recovery plus `system_rehost.sh`, with storage-topology auto-remap and a
  version-match gate (#220).
- Update orchestrator: pre-container `pre-scripts/` hook + self-re-exec (#221).
- Authelia DB credentials relocated `keys/ → creds/` (migrated automatically on upgrade).

### Fixed

- #266 — repo `.sh` scripts shipped non-executable, breaking CFML panels that shell out (e.g. the
  dashboard disk-usage panel); now `chmod +x` at build time and re-applied on install/restore.
- #267 — `hermes_smoke_test.sh` hardcoded `build_no=v260119`, so the post-install smoke test
  falsely failed on every later release; now version-agnostic.

> **Upgrade note:** the v260119 → v260609 hop requires a one-time bridge
> (`updates/v260609/upgrade-to-v260609.sh`), not the normal updater. See `RELEASE-NOTES.md`.

## [v260119] — 2026-05-30

The first Docker-era release (labeled for January 2026, actually tagged 2026-05-30 after ~6 months
of development). Established the Dockerized rewrite as a coherent shipping product and completed
the `docs/admin/` operator-documentation buildout.

## Legacy releases (pre-Docker)

Before the Docker era, Hermes shipped for years as a bare-metal Ubuntu install under the
`build-YYMMDD` tag line — e.g. `build-240815` (Aug 2024) back through `build-211207` and
`build-211019` (2021). Those releases predate the Dockerized rewrite and the move to GitHub
Releases, and are not itemized here.

[v260612]: https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases/tag/v260612
