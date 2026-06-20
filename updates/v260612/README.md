# Hermes SEG v260612 — Initial Public Docker Release

> **Early-adopter release.** v260612 is the first public release of Hermes SEG's
> Docker era — feature-complete and validated end-to-end on our DEV and Test
> environments. If you run a production gateway, **stand v260612 up in parallel and
> put it through your own acceptance tests before cutting over** — send and receive
> mail through it, exercise your relay flows, quarantine release, DKIM/SPF/DMARC
> alignment, and your backup/restore plan. Field feedback from early adopters
> directly shapes the next release.

This is the first tagged public release of Hermes SEG as a Docker product. Hermes
shipped for years as a bare-metal Ubuntu install — a custom installer, host-level
Postfix / Amavis / Dovecot / Lucee / OpenLDAP, host-managed systemd services.
v260612 marks the Dockerized rewrite as a coherent, shipping product: a 19-container
stack orchestrated by Docker Compose, a five-tier storage topology, a single-command
update orchestrator, Authelia SSO across the admin console + user portal + Nextcloud,
time-of-click link protection, Docker-aware backup / disaster-recovery tooling, and a
release pipeline built on GitHub Releases and `ghcr.io`.

This release is **fresh-install only** — legacy-to-Docker migration tooling exists in
skeletal form but is not yet end-to-end Docker-aware (see [Migrating from legacy](#migrating-from-legacy)).

## Summary

- **Early-adopter release** — feature-complete and validated on our infrastructure;
  exercise your real mail flow in parallel before cutting a production gateway over.
- **Full Docker stack**: 19 containers, single `docker compose up -d`, all services run
  in containers (no host-level mail stack). Replaces the legacy bare-metal installer.
- **Time-of-click Link Guard** (Pro): inbound links are rewritten through a Hermes
  redirect and checked for reputation **at click time** — closing the gap where a link
  is weaponized after delivery.
- **Docker-aware backup, disaster recovery & re-host**: hot backups, cross-host restore
  with storage-topology remap and credential reconciliation, and a host-identity rewire.
- **Five-tier storage topology**: Config / Data / Archive / Vmail / Nextcloud, each
  independently mountable so you put each tier on the right kind of disk.
- **Single-command update orchestrator**: `scripts/system_update_docker.sh` runs a
  5-phase pipeline (git pull → image pull → per-release artifacts → finalize →
  post-upgrade hook), auto-resolves the latest tag via the GitHub Releases API, and
  auto-runs `occ upgrade` + rehydrates Nextcloud apps on `NCVERSION` bumps.
- **Authelia SSO**: unified MFA (TOTP / WebAuthn / Duo Push) across admin console, user
  portal, and Nextcloud (via OIDC).
- **Nextcloud integrated**: webmail, file sync, calendars (CalDAV), and contacts
  (CardDAV) ship with the stack, pre-provisioned on first OIDC login.
- **GitHub-distributed**: images at `ghcr.io/deeztek/hermes-<service>:<tag>`; releases on
  GitHub; code on GitLab for dev.

---

## What's included

### Link Guard — time-of-click safe links (Pro Edition)

Inbound email links are rewritten to route through a Hermes-hosted redirect, and the
destination's reputation is checked **at the moment the user clicks** — closing the gap
where a link is weaponized *after* delivery.

- **Dedicated container** `hermes_linkguard` (self-contained Python service) runs in the
  compose stack. The body milter rewrites links to a UI-configured base URL pointing at
  the in-stack `/lg/` endpoint. (Running the container off-box on a separate host is
  deferred to a later release.)
- **Layered verdict pipeline**: heuristics (lookalike / punycode / IP-literal / `@` /
  URL-shortener / excess-subdomain) + open-redirect detection + free local feeds
  (URLhaus, OpenPhish) + an operator-managed list of abused cloud-storage / redirector
  hosts + optional Google Safe Browsing / VirusTotal + optional guarded
  redirect-chain following — each reputation source individually enabled/disabled from
  one toggle list, behind a verdict cache.
- **Admin-configured per-tier actions**: clean → redirect; suspicious → warn / allow /
  block; malicious → block / block-with-override / warn.
- **Protected-domain picker**: choose from the recipient domains the box actually hosts
  (or `_default` for all); **URL allow/block** rules with input validation.
- **Outbound restoration (default ON)**: when a user replies to or forwards a protected
  message, the wrappers are unwrapped on the way out, so external recipients get clean
  original links.
- **Rotatable HMAC signing key** with a current+previous overlap window, so links already
  in mailboxes keep working through a rotation.
- **Every link is protected regardless of length** — rewritten links use a compact
  server-side reference, so no link is skipped for being too long.
- **Diagnostics in the admin UI**: a **Check a URL** tool shows the verdict, *which* layer
  decided it, and the resolved host; a **Recent activity** view lists recent click
  evaluations (host only, for privacy).
- New Pro-gated admin page: **Email Policies → Link Guard**.

### Mail flow

- **Outbound disclaimers** (Pro): per-domain / per-address disclaimer templates, applied
  by the dedicated `hermes_body_milter` Python container in the Postfix milter chain.
- **Personal signatures** (Community): rich-HTML per-user signatures with a Quill editor,
  template gallery, tables, and social-media icons, rendered on every outbound message.
- **Organizational signatures** (Pro): admin-managed per-domain signature templates with
  placeholder substitution (name / title / phone / email / department / org).
- **External Sender Banner** (Community): inbound mail from outside the org gets a visual
  banner injected by `hermes_body_milter`.
- **CID inline image support** in body modifiers: signatures and disclaimers can embed
  inline images that survive multipart/related wrapping and DKIM signing.
- **OpenARC integration**: `hermes_openarc` does ARC chain signing on outbound and
  verification on inbound for forwarding-trust preservation.
- **Multi-instance OpenDKIM**: separate signer and verifier instances so outbound-sign and
  inbound-verify behave independently without config bleed.

### Mailbox hosting

- **Email Server section** — Domains / Mailboxes / Aliases / Mailbox Rules with a full
  admin UI on top of Dovecot 2.4.
- **Dovecot 2.4** custom Ubuntu-based image, replacing 2.3.x (breaking config/plugin/ACL
  changes absorbed).
- **Shared mailboxes + user-managed folder sharing** (Dovecot ACL / vfile), admin and user
  UIs, Rebuild ACL Files action.
- **Sieve rules**: admin global rules + per-user filters, on an isolated `dovecot_sieve`
  volume.
- **Vacation auto-reply** with per-user date scoping and per-mailbox timezone.
- **BCC Maps UI**: sender-BCC and recipient-BCC management.
- **Mobile device setup wizard**: "Set Up Your Devices" walkthroughs, signed iOS
  `.mobileconfig` (IMAP/SMTP/CalDAV/CardDAV), QR-gated download.
- **App Passwords**: unified credential system for Dovecot IMAP/SMTP + Nextcloud DAV.
- **Email autoconfiguration**: autodiscover + autoconfig endpoints from SNI certificates;
  CalDAV/CardDAV autodiscovery.

### Nextcloud integration

- **Webmail + Files + Calendar + Contacts** out of the box, SSO via Authelia OIDC.
- **`user_oidc`-based** integration with a pre-provisioning pipeline that creates NC
  accounts on first login, plus NC Mail profiles so users land in working webmail.
- **External Sites integration**: a "User Console" link in the NC top menu points back to
  the Hermes user portal, kept in sync with console-hostname changes.
- **Vendor-driven version management**: `NCVERSION` is Hermes-release-managed; each bump
  ships only after passing the NC integration check on a Test box.
- **Maintenance Mode card** in System Settings for NC-native admin access (local
  username/password + TOTP) independent of SSO.

### Operations: backup, disaster recovery & upgrades

- **Docker-aware backup & restore**: hot (zero-downtime) backups, scoped/slim storage
  tiers, a directory-style backup format, streamed restore, disk-space pre-checks, and
  email notifications (`--notify-email`, `--notify-on-success`).
- **Cross-host disaster recovery + re-host**: restore a backup onto fresh hardware —
  `system_restore.sh` auto-remaps the storage topology when it differs from the source,
  reconciles per-service DB credentials (including Nextcloud's `config.php`) to the
  target host's own `creds/`, and detects a cross-host restore and offers to run
  `system_rehost.sh`, which rewires host identity (console hostname, regenerated service
  configs, Nextcloud OIDC discovery + end-session URLs). A version-match gate guards
  against accidental cross-version restores. After any restore, follow the
  [Post-Restore Steps](https://docs.deeztek.com/books/installation-reference/page/post-restore-steps).
- **Self-healing update orchestrator**: `system_update_docker.sh` self-heals tracked-file
  runtime/restore drift (saves a recovery patch, then `git checkout -f`) instead of
  refusing, has a pre-container `pre-scripts/` hook + self-re-exec, and only restarts what
  changed.
- **Let's Encrypt cert store in backups**: ACME certs (`config/certbot/conf/`,
  symlink-preserving) survive a cross-host restore; the nginx vhost generator falls back
  to the bootstrap cert when a domain's LE cert isn't present, so a config regen can't
  emit a missing-cert path and crash nginx.

### Security & administration

- **Authelia SSO** with an LDAP backend; TOTP / WebAuthn / Duo Push across console,
  portal, and Nextcloud.
- **Per-domain MFA enforcement** with per-mailbox override; app passwords for clients that
  can't do MFA.
- **Pro Edition licensing**: Pro features require a valid license to remain active; if a
  license expires or is revoked, Pro functionality is disabled until restored, and free
  (Community) functionality is unaffected. Validation hits `validate.hermesseg.io` over
  HTTPS and is cached locally so Pro stays available during brief network outages.
- **Content filtering**: Amavis + SpamAssassin + ClamAV, custom message rules, per-rule
  score overrides, custom file-type rules, quarantine + release.
- **Encryption**: CipherMail-based S/MIME + PGP, PDF encryption / portal reply.

---

## Editions: Community vs Pro

Community Edition is fully functional and needs no license. Pro Edition unlocks **seven**
advanced features:

| Pro Feature | What it does |
|---|---|
| Let's Encrypt (ACME) automation | Automated issuance + renewal of free Let's Encrypt certs for the console and per-domain. Community can still request/use LE certs manually. |
| Email disclaimers | Per-domain outbound disclaimer templates at the milter level. |
| Organizational signatures | Centrally-managed per-domain employee signatures with placeholder substitution. Community has Personal Signatures (per-user) only. |
| Intrusion Prevention (IPS) | Web UI for Fail2ban jails, ban thresholds, whitelists, and a real-time view of active bans. The `hermes_fail2ban` container runs on all editions; Pro gates the UI + which jails are active. |
| Console firewall | Web UI for the host firewall protecting the admin console (port allowlisting, source-IP restriction). |
| LDAP RemoteAuth | Per-domain pass-through authentication to external LDAP / Active Directory; auto-provisions mailboxes on first successful login; supports STARTTLS and LDAPS. |
| Link Guard (safe links) | Time-of-click URL protection for inbound mail (see above). |

---

## Installing

```bash
sudo git clone https://github.com/deeztek/Hermes-Secure-Email-Gateway.git
cd Hermes-Secure-Email-Gateway
sudo ./scripts/install_hermes_docker.sh
```

The installer runs in a single session, 10–30 minutes (mostly image downloads). It will:

1. Display the Pro EULA and ask for acceptance.
2. Prompt for mail server hostname (FQDN), console address, host IP, upstream DNS
   forwarders, and the four storage mount paths.
3. Generate all secrets and per-service config files (LDAP secrets, DB passwords, Authelia
   session keys, OIDC keypair, self-signed bootstrap cert, Docker secret files).
4. Write `DATA_MOUNT` / `ARCHIVE_MOUNT` / `VMAIL_MOUNT` / `FILES_MOUNT` into `.env`.
5. Run `docker compose up -d --build` to pull images and start the stack.
6. Initialize all databases (Hermes, Authelia, Nextcloud, OpenDMARC, CipherMail, Syslog),
   populate the LDAP base structure, create the initial admin user, and pre-provision the
   Nextcloud admin.
7. Print an installation summary with the admin console URL and one-time admin credentials.

The installer is **idempotent** — re-running it on an already-installed system skips
completed work via state guards. Run `--help` for the full flag list.

After install you have:

- **Admin Console**: `https://<console-host>/admin/`
- **User Portal**: `https://<console-host>/users/`
- **Nextcloud**: `https://<console-host>/nc/`

The bootstrap admin lands you in a working console, but **mail won't flow** until you
complete the minimum first-run config in
[`docs/install/get-started-docker.md`](docs/install/get-started-docker.md) — first domain,
relay networks, first recipient or mailbox, DNS records. The dashboard surfaces two nudges
(`Placeholder hostname`, `Self-signed cert`) that auto-clear when satisfied.

### Configuring Link Guard (optional, Pro)

Link Guard is **dormant until enabled** — safe to install ahead of configuring it.

1. **Email Policies → Link Guard** (Pro Edition).
2. Set the **Redirect base URL** (e.g. `https://<console-host>/lg/`).
3. Add **protected recipient domains** (or `_default` for all).
4. Choose **per-tier actions**; toggle **reputation sources** (URLhaus/OpenPhish free;
   Google Safe Browsing / VirusTotal need API keys); optionally add **URL allow/block**
   rules.
5. **Enable Link Guard** and **Save & Reload**. The first save generates the signing keys
   and pushes config to the milter and the container.
6. Send a test inbound message and confirm links resolve correctly at click time.

---

## System requirements

| Resource | Requirement |
|---|---|
| CPU | 4 vCPUs minimum; more for higher mail volume |
| RAM | 8 GB minimum, 16 GB+ recommended for production |
| Disk | See below |

Hermes splits storage across **five independent tiers**, so disk sizing depends on your
layout:

- **Production (each tier on its own disk):** ~120 GB for the OS / Config disk (OS, Docker
  engine, the full Hermes image set + running containers, the repo, install/service logs),
  plus a dedicated disk per data tier — **Data**, **Archive**, **Vmail**, **Nextcloud** —
  each sized to your mail and file storage needs. The tiers have deliberately different I/O
  and growth profiles, so isolating them lets you match disk to workload and expand each
  independently.
- **Small or test (everything on one disk):** point Archive, Vmail, and Nextcloud at the
  same path as Data; ~275 GB total (thin-provisioned) is a comfortable starting point.

See [`docs/install/storage-topology.md`](docs/install/storage-topology.md) for the
canonical reference.

| Tier | Default path | Contents | Profile |
|---|---|---|---|
| 1. Config | install root (implicit) | Repo working tree, `config/` subtrees, secrets, `.env` | Fast SSD, modest size |
| 2. Data | `/mnt/data` | All databases, Amavis state, ClamAV signatures, Lucee home, Sieve scripts, all logs, OpenDMARC, Postfix queue | Fast SSD; DB growth + log retention |
| 3. Archive | `/mnt/archive` | Amavis quarantine archive | Cheap bulk; retention × inflow |
| 4. Vmail | `/mnt/vmail` | Dovecot mailboxes | Cheap bulk; users × quota |
| 5. Nextcloud | `/mnt/files` | Nextcloud app + user files + NC Redis cache | Cheap bulk; user file storage |

---

## Migrating from legacy

**Honest status:** a skeletal migration script exists at
[`scripts/migrate_legacy_to_docker.sh`](scripts/migrate_legacy_to_docker.sh) (restores
legacy DBs into the Docker MariaDB, creates the Docker-only DBs, copies legacy config
trees). It does **not** yet auto-detect the legacy 3-tier storage layout or migrate
Authelia users to LDAP automatically. **Recommendation:** treat v260612 as fresh-install
only. If you run a production legacy install, run a parallel Docker install on a second
host and evaluate before cutting over by hand. The legacy bare-metal `system_backup.sh` /
`system_restore.sh` scripts are **not safe** to run against a Docker install.

## Known limitations / things you'll want to know

- **Post-upgrade browser hard-refresh.** After an upgrade that bumps `NCVERSION` or changes
  admin web assets, hard-refresh open admin/Nextcloud tabs (Ctrl-Shift-R / Cmd-Shift-R) —
  the browser often serves the pre-upgrade CSS/JS bundle.
- **No CLI recovery path for admin lockout yet.** If you misconfigure the console hostname
  or host IP and lock yourself out of the admin UI, recover from a hypervisor/VM snapshot;
  a menu-driven `scripts/hermes-cli.sh` recovery tool is planned for a future release.
- **Docker subnet is pinned.** `IPV4SUBNET` (default `172.16.32`) is referenced across 15+
  config files; **do not change it after install** — there is no current template path to
  propagate the change everywhere. Dynamic subnet support is on the backlog.
- **Vendored CipherMail binary.** The vendored CipherMail `.deb` / `.tar.xz` files exceed
  GitHub's 50 MB size-warning threshold. Functional, flagged for cleanup.
- **Nextcloud admin via Maintenance Mode.** NC admin tasks needing local-NC auth go through
  **System → Settings → Nextcloud Maintenance Mode**, not the SSO path.

## Repository / distribution

- **Code**: GitLab — `https://gitlab.deeztek.com/dedwards/hermes-seg-docker-gl.git`
- **Distribution**: GitHub — `https://github.com/deeztek/Hermes-Secure-Email-Gateway`
- **Container images**: GitHub Container Registry — `ghcr.io/deeztek/hermes-<service>:<tag>`
- **Issues + Releases**: GitHub
- **Documentation**: [docs.deeztek.com](https://docs.deeztek.com/shelves/hermes-seg-docker)

See [`docs/install/release-and-update-methodology.md`](docs/install/release-and-update-methodology.md)
for the full release/upgrade methodology.

---

Welcome to the Docker era of Hermes SEG.
