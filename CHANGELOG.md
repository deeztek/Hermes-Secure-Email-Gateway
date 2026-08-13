# Changelog

All notable changes to **Hermes Secure Email Gateway** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Hermes uses **calendar versioning**: release tags are `vYYMMDD`, where the digits are a
planning label named for a target date — **not** necessarily the ship date. The date shown
beside each release below is the **actual release date**.

## Unreleased

### Fixed

- **OpenDMARC rejected a domain's own authenticated users** (#300). `submission` and `smtps`
  did not override `smtpd_milters`, so they inherited the global chain including OpenDMARC,
  which then evaluated authenticated outbound mail as though it were inbound. That fails by
  construction: the client address is never in the sending domain's SPF record, and the
  OpenDKIM instance on that path signs rather than verifies, so there is no DKIM result to
  consume either. With the shipped `RejectFailures true`, a domain publishing `p=reject` had
  its own users rejected at DATA with `550 5.7.1 rejected by DMARC policy`. Both listeners now
  carry an explicit chain that keeps OpenDKIM and body_milter and drops OpenDMARC, using the
  same per-service override pattern `:10026` and `:10027` already use. Port 25 is unchanged,
  which is where DMARC belongs. Invisible before this release only because submission itself
  was never bound (#292).
- **The URLhaus malware feed silently stopped updating** (#302). `malware_feeds_config` seeded
  `urlhaus` with `max_size = 2MB` and the feed has grown past 3MB, so fangfrisch refused the
  download on every run while still exiting 0. Ofelia recorded the job as successful and
  nothing surfaced, so the ClamAV third-party URLhaus signatures were never refreshed. Raised
  to 10MB in the baseline, the shipped configuration and an idempotent upgrade statement
  guarded on the old value, so a tuned setting is preserved.
- **Ofelia could never deliver its failure notifications** (#303). `hermes_ofelia` was the only
  service with no `networks:` block, so Compose attached it to an auto-created default bridge
  outside the Docker subnet. Its `[global] smtp-host` could not resolve `hermes_postfix_dkim`,
  `:10026` would have rejected it on `mynetworks` regardless, and its configured resolver was
  unreachable. Jobs ran correctly because they dispatch over the docker socket, so the only
  broken path was alerting, which `mail-only-on-error` means is exercised only when something
  has already gone wrong. Given a static address on `hermes_net_ext`.
- **Adding a Local DNS Record took DNS down for the whole gateway** (#304).
  `generate_unbound_local_conf.cfm` emitted bare `local-zone:` and `local-data:` lines, but
  `unbound.conf` includes `forward.conf` first, and when forwarding is enabled (the default
  install mode) its `forward-zone:` clause closes the `server:` clause. The generated entries
  then landed inside `forward-zone:`, where neither is valid, and unbound refused to start and
  crash-looped. Every container resolves through it, and the console needs DNS, so the admin UI
  could not undo it. The file now declares its own `server:` clause. Two further defects on the
  same page: the DNS lookup tool rejected underscore labels, excluding `_dmarc`,
  `_domainkey` and the `_submission._tcp` SRV records this product instructs admins to publish;
  and the generator could not express any TXT value containing a space or semicolon, so SPF,
  DKIM and DMARC records were silently truncated at the first semicolon. Hostname and value are
  now stripped of CR/LF before rendering, since both are admin-supplied and land in a config
  file.
- **CipherMail and OpenLDAP ran on UTC and stamped it into mail** (#305). Both images are built
  `FROM ubuntu:24.04` with `--no-install-recommends`, which never pulls `tzdata`. Without a zone
  database, glibc cannot resolve `TZ=America/New_York` as a zone path, falls back to parsing it
  as a POSIX string, takes `America` as the abbreviation and defaults the offset to zero. The
  result was UTC labelled `America`, four hours from every other container, written into the
  `Received:` header of every message CipherMail handled and into the slapd events that reach
  the Syslog database. `tzdata` is now installed explicitly in both, and `hermes_ldap`, which
  had no `TZ` at all, now receives one.
- **Amavis trusted a private range that was not the Docker subnet** (#297). The shipped
  `mynetworks` file was a stale snapshot carrying a development LAN, so a fresh install granted
  originating treatment to an unrelated `192.168.50.0/24` until an administrator saved a Postfix
  settings page and the file was re-rendered from the database. It now matches the seeded rows.
- **Four administrative pages rendered a raw error instead of the error page.** `create_new.cfm`,
  `deletedomain.cfm`, `edit_smtp_tls_settings.cfm` and `send_smime_certificate.cfm` included
  `./inc/error.cfm` from inside `inc/`, resolving to `inc/inc/error.cfm`, which does not exist.
- **`system_rehost.sh` pointed the rehosted console at an IP instead of its hostname**
  (#295).
  `CONSOLE_HOST` defaulted to the new IP when `--to-console` was not given, even though
  the script had already detected the FQDN and was using it as `trusted_domains[0]`. That
  value is written to `parameters2.console.host`, which is the console's identity: every
  generator reads it for the Nginx `server_name`, the `auth.conf` portal URL, Authelia's
  session cookie domain, Nextcloud's trusted domains, and the hostname
  autoconfig/autodiscover hand to mail clients as their IMAP and SMTP server. So a rehost
  broke Nextcloud OIDC (discovery fetched from the IP while Authelia's issuer is the FQDN,
  against a certificate covering neither), handed mail clients an IP no certificate
  covers, and left changing the console host as the operator's first task after a rehost.
  It now adopts the detected FQDN **only when DNS confirms that name points at the new
  host**, and otherwise falls back to the IP exactly as before, saying why. DNS decides
  rather than a warning, because `migrate_legacy_to_docker.sh` and `system_restore.sh` both
  invoke the script with `--force` and without `--to-console`, the migration script never
  sets `HERMES_HOSTNAME`, and `.env.template` ships a placeholder: trusting the hostname
  blindly there would have moved the console from "reachable at the IP" to unreachable. An
  explicit `--to-console` is always honoured and only warned about.
- **Changing the console host locked the administrator out of the console** (#294). This
  affected every new install, because `install_hermes_docker.sh` sets `console.host` to the
  host IP on purpose (no DNS yet) and expects the administrator to change it afterwards, so
  the broken operation was step one of every deployment. Saving a new
  console address restarted Authelia, whose session cookie is scoped to a single domain,
  so it immediately had no session configuration for the address the browser was still
  on. The save then handed the browser a redirect to `preload_restart_nginx.cfm` to
  perform the Nginx restart, but that page and the `inc/restart_nginx_post.cfm` its
  JavaScript calls both live under `/admin/2/` and are auth-protected. Neither could
  load, so the one thing that triggers the Nginx restart sat behind the auth flow the
  hostname change had just invalidated. Nginx kept serving the previous portal URL
  indefinitely, the browser was redirected to the old address with "unable to determine
  user state", and the only way back in was restarting `hermes_nginx` by hand from the
  Docker host. A host change now fires the restart from the save request itself, the
  last one that is still authenticated, and renders a page that waits out the restart
  before moving the operator to the new address, so their next sign-in happens after
  Nginx is back rather than during the restart. Certificate, HSTS, OCSP and DH-parameter
  changes leave the address and the session intact and keep the existing restart path.
- **DNSBL lookups could be silently dead, and the diagnostics said they were healthy**
  (#293). Found while verifying #292 on a test gateway whose Unbound forwards to a LAN
  router: ordinary DNS resolved normally while `zen.spamhaus.org` returned nothing at
  all for a test point that is guaranteed listed. Reputation scoring, both postscreen
  weights and the SpamAssassin `RCVD_IN_*` rules, contributes nothing in that state,
  and allowlists such as `list.dnswl.org` stop applying too.
  - **Four block lists counted refusals as listings.** `bl.spamcop.net`,
    `bl.suomispam.net`, `bl.spameatingmonkey.net` and
    `backscatter.spameatingmonkey.net` shipped with no `=returncode` filter, so
    postscreen counted any answer in `127.0.0.0/8` as a listing, including the
    `127.255.255.0/24` codes lists use for "refused" and "over quota". Each carries a
    weight of 2 against a threshold of 3, so two of them answering with error codes
    reject legitimate mail. All four now filter on `127.0.0.[2..11]`, and existing
    installs are corrected with their weights preserved.
  - **The RBL Test button never made a DNS query at all, and reported every list as
    healthy.** It shelled out to `docker exec hermes_postfix_dkim dig`, but the
    postfix-dkim image has never contained `dnsutils`, so every probe failed with an OCI
    "executable file not found" error. Neither probe captured stderr, so Lucee folded
    docker's error message into the output variable, and the SOA fallback only tested that
    the output was non-empty. An error message is not empty, so it read as a successful SOA
    lookup and every entry displayed green "Zone active (SOA)". The probe now runs `dig`
    locally in `hermes_commandbox`, which has `dnsutils` and is pointed at
    `hermes_unbound` by compose, so it goes through the same resolver postscreen uses.
    Every `cfexecute` captures stderr separately, no probe treats stderr as data, the SOA
    response is validated as an actual SOA record by its five timers rather than by being
    non-empty, and a missing `dig` is reported as its own verdict instead of being
    laundered into a DNS result. The same flaw was present in the new install-time DNSBL
    preflight and is fixed there too.
  - **System > RBL Configuration had no Apply button.** `inc/rbl_apply_settings.cfm` had
    existed since the page was written but nothing ever invoked it, so the only way to push
    a block list change into `main.cf` was to edit an entry and save it without changing
    anything. It is now wired to an Apply button, which confirms first because it
    regenerates the Postfix configuration from the database and reloads Postfix. The
    success message it sets also had no handler on the page, so even a successful apply
    would have reported nothing.
  - **The RBL Test button also mis-read the answers it did get.** It accepted
    any answer beginning `12` as success, so `127.255.255.254` displayed as live data,
    and its SOA fallback reported green for a zone that returned no data at all. It now
    runs a two-point probe and reports data returned, zone present but silent, or refused
    and wildcarded, which a single probe cannot distinguish from a healthy list. The
    wildcard test compares the two points as **sets** and requires them to be identical,
    rather than treating any answer at `1.0.0.127.` as a wildcard: reputation services
    return a verdict for every query, not only for listed senders, so
    `hostkarma.junkemailfilter.com` answers both points with different code sets and an
    "any answer" test marked a healthy service as broken. What makes a wildcarded or
    hijacked zone dangerous is that it returns the **same** answer to everything, so every
    connecting IP scores identically; a zone that discriminates is doing its job. A zone
    that answers the never-listed point while the always-listed point stays silent is
    reported as inverted rather than as either healthy or wildcarded.
  - **The Postfix template and the database shipped different block lists.** A fresh
    install filtered on the 27 entries hardcoded in `main.cf.HERMES`, including six
    retired `dnsbl.sorbs.net` entries at weights up to 8, while the admin console
    showed the 17 seeded in the database. The template only converged on the database
    when someone saved a settings page. Both lists now match exactly. This is the same
    root pattern as #292: generated config written before or independently of the
    database, with the file winning until an admin happens to save.
  - **`b.barracudacentral.org` is no longer seeded.** It answers only once the querying
    IP is registered with Barracuda, so on a stock gateway it returned nothing while
    carrying a weight of 7, above the rejection threshold of 3 on its own. Existing
    entries are left in place, since an operator may have registered.
  - **The installer now tests block list reachability.** Forward mode remains the
    install default for bootstrap reliability, and switching to recursive remains the
    operator's call, but the cost of forward mode was invisible: ordinary DNS resolving
    normally says nothing about whether reputation answers survive the trip. Routers
    commonly strip `127.0.0.0/8` replies as DNS rebinding protection, returning NOERROR
    with an empty ANSWER and empty AUTHORITY, and public resolvers are refused by the
    lists outright. The new preflight distinguishes reachable, refused, stripped,
    synthesised, and off-zone answers, and reports the remedy. It warns rather than
    aborting, since mail still flows in that state, it just filters badly. The DNS
    forwarder prompt now states the consequence instead of framing recursive mode as a
    privacy preference.
- **Razor could not work even once registration landed in the right place** (#292
  follow-up). `-home=/etc/razor` corrected where `razor-admin` writes, but `docker exec`
  runs as root, so the identity and server discovery files were created root-owned while
  SpamAssassin runs as `amavis`. Razor writes its home directory at scan time, refreshing
  `servers.*.lst` and the per-server configs, so root ownership left it mute. The
  ownership pass in the installer, the post-upgrade repair, and the Initialize Razor
  handler all now include `/etc/razor`, and registering removes the stale `/root/.razor`
  identity that earlier attempts left behind.

- **First-run provisioning defects on fresh installs** (#292). Reported by an outside
  user on a clean install. Each has been present since the Docker edition shipped and
  is invisible on any gateway where an administrator saved the relevant settings page,
  because the application layer silently corrects the installer's output.
  - **Every message received a 5 point spam-score discount.** SpamAssassin's
    `RCVD_IN_VALIDITY_CERTIFIED` and `RCVD_IN_VALIDITY_SAFE` rules are allowlists
    carrying `-3` and `-2`. Validity refuses queries from unregistered resolvers
    and answers `127.255.255.255`, which SpamAssassin matches as a hit, so both
    fired on every message. Hermes resolves through its own recursive Unbound
    instance, so the query always originates from an unregistered address and no
    stock install escaped it. Configured thresholds therefore behaved five points
    higher than they read. All three Validity rules now score `0`; operators
    registered with Validity can restore them through Score Overrides.
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

- **`system_update_docker.sh --remote` now selects code, images and tag from one source**
  (#298). Previously it chose only where the code came from, while images resolved from
  `IMAGE_REGISTRY` and `HERMES_DOCKER_IMG_VERSION` in `.env`, which the orchestrator never read
  or wrote. The upgrade path could therefore never advance the image version, so image-level
  fixes could not reach an existing install, and testing a release candidate meant hand-editing
  `.env` first. The remote now maps to a registry and the resolved tag is written before
  `docker compose pull`, guarded by a `docker manifest inspect` probe so the per-release tag is
  pinned only when the registry actually has it. An upgrade that works today cannot start
  failing, and the production path begins pinning automatically once per-release tags exist
  (#289). `--image-registry=` and `--image-tag=` override the mapping; `.env` is backed up
  before either key changes, and `--skip-compose` leaves it untouched.


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

### Documentation

- **The console FQDN and a real certificate are now documented as a hard prerequisite** (#299).
  Nextcloud login cannot work on a fresh install, because OIDC requires the Nextcloud container
  to make a server-side HTTPS call back to the console address, and the bootstrap certificate is
  self-signed with the common name `localhost`. Importing it into the container's trust store
  does not help, since trust and name are separate checks. Get Started gains a Step 2 covering
  both parts, and the mail-client half: **the Console Certificate and the SMTP TLS certificate
  are separate bindings**, and setting only the first leaves the console perfect in a browser
  while every mail client is offered `CN=localhost`, because `autoconfig` hands clients the
  console host as their SMTP server. The `Self-signed cert` dashboard nudge previously described
  this as producing only a client TLS warning, which understated it.
- **The CipherMail console's stock `admin` / `admin` credentials are now stated explicitly**
  (#306), rather than referred to obliquely as "its default administrator password".
- **`master.cf` has exactly one copy in the repository.** A duplicate under
  `conf_files/` drifted for three months onto the pre-#232 configuration that caused the
  `:10026` outage, because commit `9e90bc9a` fixed the real file and not the copy, and nothing
  read the copy so nothing detected it. Both it and an equally stale `master.cf.postscreen` are
  removed, and `docs/general/email-flow.md` records why a second copy must not be reintroduced.

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
