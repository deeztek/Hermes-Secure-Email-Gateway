<h1 align="center"> Hermes Secure Email Gateway and Email Server</h1> <br>
<p align="center">
  <a href="https://www.hermesseg.io">
    <img alt="Hermes Secure Email Gateway" title="Hermes Secure Email Gateway" src="https://imgur.com/Qfzv1iZ.png" width="auto">
  </a>
</p>

<p align="center">
  Open Source Secure Email Gateway and Email Server &mdash; Docker Edition
</p>

## Table of Contents

- [About](#about)
- [Editions](#editions)
- [Features](#features)
- [Architecture](#architecture)
- [Storage Topology](#storage-topology)
- [Requirements](#requirements)
- [Installation](#installation)
- [Updating](#updating)
- [Configuration](#configuration)
- [Recovery and Maintenance Tools](#recovery-and-maintenance-tools)
- [Documentation](#documentation)
- [Support](#support)
- [Bugs](#bugs)
- [License](#license)

## About

Hermes Secure Email Gateway is a Free Open Source Secure Email Gateway **and** Email Server. It provides Spam, Virus, and Malware protection through Apache SpamAssassin, ClamAV, and Amavisd-new; full in-transit and at-rest email encryption via SMTP TLS, S/MIME, PGP, encrypted PDF, and Dovecot mail-crypt (powered by CipherMail); email archiving; integrated mailbox hosting on Dovecot with per-user quotas, aliases, shared folders, Sieve rules, vacation auto-reply, and mobile device autoconfiguration; file sync, webmail, calendars (CalDAV), and contacts (CardDAV) through Nextcloud; a local user directory and single sign-on via OpenLDAP and Authelia &mdash; with multifactor authentication via TOTP, WebAuthn, and Duo Push; and modern email authentication standards including SPF, DKIM signing and verification, DMARC, and ARC through OpenDKIM, OpenDMARC, and OpenARC.

Hermes combines these Open Source technologies under one unified web-based administration console for easy management of your organization's inbound and outbound email, mailbox users, encryption keys, and authentication policies. End users get a self-service portal for managing their own signatures, sieve rules, vacation messages, app passwords, and mobile device profiles.

Hermes can be deployed three ways:

- **As a gateway** in front of an existing mail solution (in-house Exchange/Postfix, Google Workspace, Microsoft 365). Hermes scans, filters, encrypts, and relays mail to your backend.
- **As a full mail server** with built-in mailbox hosting, webmail, file sync, calendars, and contacts. No external mail backend required.
- **As a hybrid** &mdash; gateway for some domains AND mail server for others on the same install. Relay (gateway) domains and mailbox (mail server) domains coexist in a single Hermes deployment.

This Docker Edition packages the entire stack as a set of containers managed by Docker Compose, replacing the legacy bare-metal Ubuntu installer with a portable, reproducible deployment.

## Editions

Hermes ships in two editions:

| Edition | License | What you get |
|---|---|---|
| **Community** | [AGPL v3](https://www.gnu.org/licenses/agpl.html) &mdash; free, open source | The entire mail gateway and email server stack. All core security, encryption, mailbox hosting, and administration features. |
| **Pro** | Commercial &mdash; see [EULA](https://docs.hermesseg.io/books/hermes-secure-email-gateway-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula) | Everything in Community plus 6 advanced features (see [Pro Features](#pro-features) below). |

A Pro license is purchased separately. Community Edition needs no license file and works fully without one.

## Features

### Mail Security (Community)

- Spam protection (Apache SpamAssassin, postscreen, RBL configuration, sender/recipient/network block-allow lists, global sender filters)
- Anti-virus protection (ClamAV via Amavisd-new, with built-in feeds: ClamAV official + URLhaus)
- Malware Feeds management (managed via Fangfrisch) &mdash; configure additional 3rd-party signature feeds including SaneSecurity, MalwarePatrol, SecuriteInfo, TwinWave, ClamPunch, RFXN, InterServer, Ditekshen, and more
- Per-recipient Spam/Virus/File policies
- Custom message rules, score overrides, custom file expressions/extensions/rules
- Quarantine, message history search, queue management, train as spam/ham, release to recipient, download messages
- ARC (Authenticated Received Chain) integration via OpenARC
- Multi-instance OpenDKIM for differential outbound-sign vs inbound-verify behavior

### Encryption and Authentication (Community)

- In-transit email encryption: SMTP TLS, S/MIME, PGP (via CipherMail)
- At-rest encryption: Dovecot mail crypt
- Encrypted PDF email for recipients without S/MIME or PGP
- Multifactor authentication (Authelia): TOTP, WebAuthn, Duo Push
- Local LDAP user store (built-in OpenLDAP) for admins, mailbox users, and relay users
- App passwords for SMTP/IMAP/DAV clients (separate from main account password)
- 3rd-party SSL certificate support
- haveibeenpwned password check integration

### Email Standards (Community)

- SPF check, DKIM check + sign, DMARC verification (OpenDMARC)
- DKIM key generation and management (UI)
- DMARC report aggregation and reporting

### Email Server / Mailbox Hosting (Community)

- Local mailbox hosting (Dovecot 2.4) with IMAPS / POP3S / Submission (587/465) / LMTP
- Per-domain and per-mailbox quotas
- Mailbox aliases and forwarders
- Shared mailboxes and shared folders
- User-defined Sieve rules
- Vacation auto-reply with date scoping and per-address filtering
- Mobile device autoconfiguration via signed `.mobileconfig` profiles (iOS) and CalDAV/CardDAV autodiscovery
- Personal email signatures (rich HTML, with template gallery)
- External Sender Banner (inbound mail from outside-the-org gets a visual banner)

### Nextcloud Integration (Community)

- File sync (Nextcloud Files)
- Webmail (Nextcloud Mail)
- Calendars (CalDAV) and contacts (CardDAV)
- Single sign-on via Authelia OIDC
- Pre-provisioning of Nextcloud user accounts on first login

### Admin and User Experience (Community)

- Modern AdminLTE 4 / Bootstrap 5 administrator console
- User self-service portal (per-mailbox)
- Real-time dashboard with system resource monitoring
- Message statistics with visual charts
- Scheduled tasks UI (DB-backed Ofelia job management)
- Searchable system event logs
- Internal CA management (S/MIME)
- DNS resolver (Unbound, local-recursive)
- Console host and domain management
- Console firewall settings UI

### Pro Features

Pro Edition adds the following capabilities on top of everything in Community:

| Pro Feature | What it does |
|---|---|
| **Let's Encrypt (ACME) Automation** | Automated issuance and renewal of free Let's Encrypt SSL certificates for the console and per-domain. Community Edition can still request and use Let's Encrypt certificates, but the issuance and renewal automation is Pro-only. |
| **Email Disclaimers** | Per-domain outbound disclaimer templates, applied at the milter level. Form-based template renderer with reusable templates. |
| **Organizational Signatures** | Centrally-managed per-domain employee signature templates with placeholder substitution (employee name, title, phone, email, department, organization info). Renders on every outbound message. Community Edition has Personal Signatures (per-user, free-form) only. |
| **Intrusion Prevention (IPS)** | Web UI for managing Fail2ban jails, ban thresholds, ban duration, whitelists. Real-time view of active bans. |
| **Console Firewall** | Web UI for managing the host firewall protecting the admin console (port allowlisting, source IP restriction). |
| **LDAP RemoteAuth** | Per-domain pass-through authentication to one or more external LDAP servers (including Microsoft Active Directory). End users authenticate against your existing directory; Hermes provisions mailboxes on first successful login. Supports STARTTLS and LDAPS. |

## Architecture

Hermes SEG Docker Edition runs as **18 containers** orchestrated by Docker Compose:

| Container | Purpose |
|---|---|
| `hermes_unbound` | Recursive DNS resolver for the stack |
| `hermes_db_server` | MariaDB &mdash; Hermes, Authelia, Nextcloud, OpenDMARC, CipherMail, Syslog databases |
| `hermes_ofelia` | Scheduled task runner (cron replacement) |
| `hermes_nginx` | Reverse proxy + SSL termination (admin console, user portal, Nextcloud, CipherMail UI) |
| `hermes_authelia` | SSO portal with MFA (TOTP / WebAuthn / Duo Push) |
| `hermes_authelia_redis` | Session store for Authelia |
| `hermes_commandbox` | CFML application server (Lucee) &mdash; hosts admin console + user portal |
| `hermes_postfix_dkim` | Postfix MTA + OpenDKIM signer/verifier |
| `hermes_dmarc` | OpenDMARC verifier + report aggregator |
| `hermes_openarc` | OpenARC chain signer/verifier |
| `hermes_mail_filter` | Amavisd-new + SpamAssassin + ClamAV content filter |
| `hermes_body_milter` | Outbound body modification milter (signatures, disclaimers, banners) |
| `hermes_ciphermail` | S/MIME, PGP, encrypted-PDF encryption gateway |
| `hermes_fail2ban` | Brute-force prevention (Dovecot, Authelia jails) |
| `hermes_dovecot` | IMAP / POP3 / Submission / LMTP / Sieve server |
| `hermes_ldap` | OpenLDAP &mdash; local user directory (admins, mailboxes, relay users) |
| `hermes_nextcloud` | File sync, webmail, CalDAV, CardDAV |
| `hermes_nextcloud_redis` | Cache + locking backend for Nextcloud |

## Storage Topology

Hermes splits storage across **four independent tiers** so each can live on the right type of disk for its workload:

| Tier | Default path | Contents | Storage profile |
|---|---|---|---|
| **Config** | install root (implicit) | Repo working tree, generated config, secrets, `.env` | Fast SSD; chosen by where the repo lives |
| **Data** | `/mnt/data` | Databases, all service logs, quarantine, OpenDMARC reports, mail queue | Fast SSD; sized for DB growth and log retention |
| **Vmail** | `/mnt/vmail` | Dovecot mailboxes | Cheap bulk; sized for users &times; quota |
| **Nextcloud** | `/mnt/files` | Nextcloud app + user files + Redis cache | Cheap bulk; sized for user file storage |

Smaller deployments can collapse tiers &mdash; set Vmail and Nextcloud to the same path as Data, or leave any tier on the default Docker named volume. The installer prompts for each path during phase 1.

See [`docs/install/storage-topology.md`](docs/install/storage-topology.md) for the canonical reference covering all four tiers, sub-directory layout, and the install flow.

## Requirements

| Item | Recommendation |
|---|---|
| OS | **Ubuntu 24.04 Server** (tested). Other modern Linux distributions with Docker support should work but are not officially tested. |
| Docker | Engine 24.0+ |
| Docker Compose | v2 |
| CPU | 4 cores minimum, more for higher mail volume |
| RAM | 4 GB minimum, 8 GB+ recommended for production |
| Disk | 50 GB minimum for the install root and Data tier on the primary disk |
| Network | Static IP or DHCP reservation; outbound 80/443 reachable for image pulls; inbound 25/80/443/465/587/993/995 as needed |

### Optional but recommended

A separate physical or virtual disk for the **Data** tier (databases, logs, quarantine) is **not strictly required** but is **highly recommended** for performance reasons. Database write patterns and log churn benefit from being isolated from the OS disk. The same applies to the Vmail and Nextcloud tiers if you expect significant mailbox or file storage growth &mdash; commodity bulk storage works well for these.

If you don't want to use a secondary drive for any tier, simply create the directory on your primary disk (e.g., `mkdir /mnt/data`) and point the installer at it.

## Installation

### 1. Clone the repository

Clone the repository wherever you'd like Hermes installed:

```bash
sudo git clone https://github.com/deeztek/Hermes-Secure-Email-Gateway.git
cd Hermes-Secure-Email-Gateway
```

### 2. Run the installer

```bash
sudo ./scripts/install_hermes_docker.sh
```

The installer runs the full install in a single session and takes 10&ndash;30 minutes on a fresh host (mostly image downloads and fail2ban container build).

The installer will:

1. Display the Pro EULA and ask for acceptance (Community Edition users can accept; the EULA only takes effect if a Pro license is later activated)
2. Prompt for mail server hostname (FQDN), console address, host IP, upstream DNS forwarders, and the three storage mount paths
3. Generate all secrets and per-service config files (LDAP secrets, DB passwords, Authelia session keys, OIDC keypair, self-signed bootstrap cert, etc.)
4. Render `docker-compose.override.yml` to bind the tier paths into the right containers
5. Run `docker compose up -d --build` to pull images and start the stack
6. Initialize all databases (Hermes, Authelia, Nextcloud, OpenDMARC, CipherMail, Syslog), populate the LDAP base structure, create the initial admin user, and pre-provision the Nextcloud admin
7. Print an installation summary with the admin console URL and one-time admin credentials

### 3. Access the consoles

After install completes:

- **Admin Console**: `https://<console-host>/admin/`
- **User Portal**: `https://<console-host>/users/`
- **Nextcloud**: `https://<console-host>/nc/`

The installer prints the initial admin username and password on completion. Change the password on first login.

## Updating

Hermes SEG ships a single-command update orchestrator that handles git pull, image refresh, schema migrations, service restarts, and post-upgrade hooks in one go.

### Update to the latest release

```bash
cd /opt/hermes-seg-docker-gl
sudo ./scripts/system_update_docker.sh
```

This polls GitHub for the latest release, fetches the new tag, pulls updated images, applies any per-release schema/CFML/script artifacts, restarts services that need to be restarted, and runs the post-upgrade hook.

### Update to a specific release

```bash
sudo ./scripts/system_update_docker.sh v260601
```

### Preview without applying changes

```bash
sudo ./scripts/system_update_docker.sh --dry-run
```

### Other flags

| Flag | Purpose |
|---|---|
| `--skip-git` | Don't pull new code (containers + artifacts only) |
| `--skip-compose` | Don't touch docker images (git + artifacts only) |
| `--yes` | Skip the interactive confirmation prompt |
| `--help` | Show full usage |

For the full release and update methodology &mdash; including how artifacts are organized, idempotency rules, and the orchestrator's five-phase pipeline &mdash; see [`docs/install/release-and-update-methodology.md`](docs/install/release-and-update-methodology.md).

## Configuration

After the installer completes, the admin will be guided through first-run configuration tasks in the admin console:

1. **Confirm console host** &mdash; the install captures this at prompt time; admins can change it later under System &gt; Console Settings.
2. **Configure DNS records** &mdash; install summary prints the recommended SPF, DKIM, DMARC, and MX records to add. Use a real DNS-resolvable hostname before requesting any production Let's Encrypt certificate.
3. **Add domains** &mdash; under Email Server &gt; Domains (mailbox hosting) or Email Relay &gt; Domains (gateway / relay mode).
4. **Create mailboxes or relay recipients** &mdash; under Email Server &gt; Mailboxes or Email Relay &gt; Recipients.
5. **Set up SSL** &mdash; either upload a 3rd-party certificate (System &gt; System Certificates) or, on Pro, request a Let's Encrypt certificate via the same page.

Detailed configuration walkthroughs &mdash; including SPF/DKIM/DMARC setup, mailbox provisioning, relay vs. mail-server modes, and the encryption gateway &mdash; live in the [Documentation](#documentation) section.

## Recovery and Maintenance Tools

The install script also provides a set of recovery and maintenance flags:

| Command | Purpose |
|---|---|
| `sudo ./scripts/install_hermes_docker.sh --show-config` | Display current storage paths and configuration |
| `sudo ./scripts/install_hermes_docker.sh --show-summary` | Reprint the post-install summary (admin URL, credentials reminder) |
| `sudo ./scripts/install_hermes_docker.sh --apply-schema` | Lower-level schema-only update (the canonical update path is `system_update_docker.sh`) |
| `sudo ./scripts/install_hermes_docker.sh --init-db` | Re-run phase 2 (post-container) initialization only &mdash; recovery flag for partial installs |
| `sudo ./scripts/install_hermes_docker.sh --generate-secrets` | Regenerate per-service secrets and re-render derived configs |
| `sudo ./scripts/install_hermes_docker.sh --configure-storage` | Re-prompt for storage mount paths and regenerate the override file |
| `sudo ./scripts/install_hermes_docker.sh --wipe` | **Destructive.** Tear down everything (containers, volumes, credentials, install state) for a fresh start. Requires double confirmation. |

Run any of the above with `--help` for full usage. The installer is **idempotent**: re-running it (or any of its sub-steps) on an already-installed system skips already-completed work via state guards.

## Documentation

### In-repo documentation

- [`docs/install/release-and-update-methodology.md`](docs/install/release-and-update-methodology.md) &mdash; canonical reference for how Hermes is released, distributed, and upgraded
- [`docs/install/storage-topology.md`](docs/install/storage-topology.md) &mdash; the four-tier storage model
- [RELEASE-NOTES.md](RELEASE-NOTES.md) &mdash; per-release change log

### Online documentation

Online documentation for the Docker Edition is in progress and will be available as soon as possible.

## Support

Post your questions at:
[github.com/deeztek/Hermes-Secure-Email-Gateway/discussions](https://github.com/deeztek/Hermes-Secure-Email-Gateway/discussions)

Chat with us on Matrix:
[matrix.to/#/#hermesseg:matrix.org](https://matrix.to/#/#hermesseg:matrix.org)

## Bugs

Bugs and feature requests go on GitHub Issues:
[github.com/deeztek/Hermes-Secure-Email-Gateway/issues](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues)

## License

Hermes Secure Email Gateway Community Edition is free software licensed under the [GNU Affero General Public License v3.0](https://www.gnu.org/licenses/agpl.html).

Hermes Secure Email Gateway Pro Edition is **not** free software. It is covered by the [Hermes Secure Email Gateway Pro End-User License Agreement](https://docs.hermesseg.io/books/hermes-secure-email-gateway-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula).

Copyright Dionyssios Edwards 2011&ndash;2026. All Rights Reserved.
