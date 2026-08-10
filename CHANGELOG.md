# Changelog

All notable changes to **Hermes Secure Email Gateway** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Hermes uses **calendar versioning**: release tags are `vYYMMDD`, where the digits are a
planning label named for a target date — **not** necessarily the ship date. The date shown
beside each release below is the **actual release date**.

## Unreleased

### Fixed

- **First-run provisioning defects on fresh installs** (#292). Reported by an outside
  user on a clean install. Each has been present since the Docker edition shipped and
  is invisible on any gateway where an administrator saved the relevant settings page,
  because the application layer silently corrects the installer's output.
  - **SMTP submission was never enabled.** `master.cf` shipped with the `submission`
    (587) and `smtps` (465) listeners commented out in every variant, while Docker
    published both ports and the mailbox domain page advertised them over SRV. On a
    mailbox or hybrid install no user could send mail from any client. Receiving and
    webmail were unaffected, because Nextcloud Mail reaches Postfix on port 25 over
    the Docker network, which is why the gap went unnoticed. Both listeners are now
    enabled with Dovecot SASL and `reject_sender_login_mismatch`.
  - The update orchestrator restarted only `hermes_commandbox`, so a release that
    changed `master.cf` or `main.cf` without also rebuilding images would not have
    applied it: Postfix reads both at startup, and Compose recreates a container when
    its definition changes, not when a bind-mounted file's contents change. Phase 4
    now restarts `hermes_postfix_dkim` as well.
  - Amavis quarantine subdirectories (`clean`, `virus`, `spam`, `banned`, `bad_header`)
    were never created, so Amavis could reject mail outright. The pre-Docker installer
    created all five and the Docker rewrite dropped the step, along with the ownership
    pass that let amavis write the quarantine tier and the Bayes corpus.
  - The installer enabled mailbox encryption against empty placeholder keys regardless
    of the database setting, which defaults to off, breaking IMAP and SMTP
    authentication.
  - SpamAssassin's `local.cf` was copied rather than rendered, so nine placeholders
    reached SpamAssassin verbatim. It discarded them and fell back to built-in
    defaults, which enable the collaborative network checks and automatic Bayes
    learning.
  - `NEXTCLOUD_TRUSTED_DOMAINS` was written comma-separated where a space-separated
    list is expected, so Nextcloud rejected the console address the installer
    configures before DNS exists.
  - Enabling Nextcloud on an existing mailbox never provisioned the Nextcloud Mail
    profile, and the failure was silently discarded. It was built from the account's
    login password, which Dovecot cannot accept: IMAP and SMTP authenticate only
    against app passwords.

### Changed

- **Collaborative spam checks now ship disabled** (#292). Razor, Pyzor and DCC each
  transmit a digest of every scanned message to a third-party network, so new installs
  leave that decision to the operator. Existing installs keep their current settings.
  Razor had never been registered on any install and so returned no result regardless.
- **Bayes ships untrained, and automatic learning is off by default** (#292). Hermes
  had been shipping a pre-trained corpus built from unrelated mail; upgrading clears it
  once so each gateway learns from its own traffic. Auto-learning trains on the rule
  set's own verdicts, reinforcing its mistakes as readily as its successes.
- **DCC is no longer in the published mail filter image** (#292). Its licence is free
  only to organisations that do not sell filtering devices or services except to their
  own users, and does not permit redistributing binaries. Most self-hosted operators
  qualify; Deeztek does not. `docker-compose.yml` carries a commented build block for
  operators who want it, fetching DCC from Rhyolite directly.
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

Before the Docker era, Hermes shipped as a bare-metal Ubuntu install under the `build-YYMMDD`
tag line: `build-240815` (Aug 2024) back through `build-211207` and `build-211019` (2021). This
repository was created 2017-12-21 and the project has been public on GitHub since. Those releases
predate the Dockerized rewrite and the move to GitHub Releases, and are not itemized here.

The full pre-Docker history, **186 commits spanning 2017 to 2025**, is preserved on the
[`legacy`](https://github.com/deeztek/Hermes-Secure-Email-Gateway/tree/legacy) branch, along with
its seven `build-*` releases.

`legacy` is a **separate codebase** from `main`, not an earlier stage of it. The Docker Edition is
a ground-up rewrite of the bare-metal monolith rather than a continuation, which is why `main`
carries none of those commits. See [Project history](README.md#project-history) in the README.

[v260612]: https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases/tag/v260612
