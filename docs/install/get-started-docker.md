# Get Started (Docker)

This page is the **minimum config needed to get mail flowing** on a fresh Hermes SEG Docker install. The install script (`scripts/install_hermes_docker.sh`) does most of the heavy lifting — this page covers the handful of admin-UI steps that still need a human.

Skip these and Postfix will silently bounce or reject mail. The admin dashboard also surfaces two universal nudges (placeholder hostname, self-signed cert) until those are addressed (see [Dashboard nudges](#dashboard-nudges) at the bottom).

## Which steps apply to you?

Hermes supports three deployment topologies. **Step 1 (System Identity) and the Optional/DNS sections apply to everyone** — the middle of this guide then splits into a **Relay** path and a **Mail server** path. Follow only the one(s) for your topology:

| Topology | What it is | Follow |
| --- | --- | --- |
| **Relay-only** | Hermes filters mail and forwards it to a downstream mail server (MX) | Step 1 → **Relay configuration** |
| **Mail-server-only** | Hermes hosts the mailboxes itself (Dovecot + webmail) | Step 1 → **Mail server configuration** |
| **Hybrid** | Both — some domains relay out, others have local mailboxes | Step 1 → **Relay configuration** → **Mail server configuration** |

> **Legacy reference**: this page replaces the [pre-Docker 16-step page](https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/getting-started). The Docker install script absorbs ~6 of those steps, so the list below is shorter.

---

## What the install script already did

You don't need to redo any of this — `install_hermes_docker.sh` handled it during the install run:

| Component | Result |
| --- | --- |
| Containers | All Hermes containers running (`docker compose ps`) |
| Bootstrap admin | LDAP user in `cn=admins` + `cn=one_factor`, password in `INSTALL_SUMMARY` |
| TLS | Self-signed bootstrap cert in System Certificates, bound to Console / SMTP / Webmail roles |
| Databases | MariaDB schemas (hermes, djigzo, opendmarc, syslog, authelia, nextcloud) created + seeded |
| Console settings | `parameters2.console.host` set to the FQDN you entered at install time |
| Postfix identity | `myhostname` / `myorigin` set from the install-time mail-hostname prompt |
| Authelia | LDAP backend wired up; 2FA enrollment available on first login |
| Mail filtering | Amavis + SpamAssassin + ClamAV all initialized and listening |

So **after the install you can log in, but mail won't actually flow** until you complete the steps below.

---

## Step 1 — System Identity (all topologies)

**Page**: System → Server Setup

The install script sets `myhostname` from what you typed at the FQDN prompt, but you should double-check it matches your DNS A / MX records. Also set:

- **Postmaster address** — where bounce messages and admin notifications go
- **Admin email** — where alerts (license, system events) get delivered
- **Time zone** — affects log timestamps and report scheduling

> **Dashboard nudge**: an orange callout `Placeholder hostname` fires (any topology) if `myhostname` still equals the seed default `hermes.domain.tld` or `console.host` equals `smtp.domain.tld`. Both should never appear on a Docker install (the install script overrides them), but if they do, this is the page to fix.

---

## Relay configuration

*For **relay-only** and **hybrid** deployments. If Hermes hosts your mailboxes and never forwards to a downstream MX, skip this whole section and follow **Mail server configuration** below.*

### A. Relay Domains

**Page**: Email Relay → Domains

Add **at least one domain** so Hermes knows what mail to accept on the SMTP port. Without this, every inbound message gets rejected with `Relay access denied`.

For each domain you'll choose:

| Field | What it controls |
| --- | --- |
| Domain | The recipient domain (e.g. `example.com`) |
| Recipient delivery mode | Where validated mail goes next — **relay** forwards to a downstream MX (the usual relay-topology choice) |
| Destination address / port | The downstream MX host + port that accepts the forwarded mail |
| Policy | Encryption policy applied to outbound mail for this domain (Pro only) |

### B. Relay Networks

**Page**: Email Relay → Relay Networks

Add the IP addresses or CIDR blocks of any **upstream MTA** (your customer's mail server, an application server that sends notification mail, etc.) that should be allowed to relay outbound mail through Hermes.

By default Hermes only trusts `127.0.0.1` and the Docker bridge subnet (`172.16.32.0/24`). Anything else needs to be added here.

### C. Relay Recipients

**Page**: Email Relay → Relay Recipients

Add the individual recipients (or wildcards) that Hermes should accept mail for. Validated mail is then forwarded to the destination set on the domain row in step A. Without at least one recipient, mail for the domain is rejected as unknown.

---

## Mail server configuration

*For **mail-server-only** and **hybrid** deployments. If Hermes only relays to a downstream MX and hosts no mailboxes, skip this whole section.*

### A. Mailbox Domains

**Page**: Email Server → Domains

Add **at least one mailbox domain** — the domain Hermes will host mailboxes for. This is a *different* page from Email Relay → Domains: it provisions the local-delivery side (Dovecot, autoconfig/autodiscover, webmail), not relay forwarding.

When you add a mailbox domain Hermes sets up the per-domain mail-client autoconfiguration. For TLS, mailbox domains need a certificate that also covers `autoconfig.<domain>` and `autodiscover.<domain>` — see **Real TLS Certificate** below.

### B. Mailboxes

**Page**: Email Server → Mailboxes

Create the individual mailboxes under your mailbox domain(s). Each mailbox row creates an LDAP user, a Dovecot maildir, and (optionally) a Nextcloud account for webmail/file access. Users log in to webmail via Authelia SSO at `https://<console-host>/nc/`.

---

## Optional but recommended

### Relay Host (Outbound Smarthost) — *relay / hybrid*

**Page**: Email Relay → Relay Host

If outbound mail should route through an upstream provider (Gmail, Microsoft 365, SendGrid, etc.) instead of being sent directly to recipient MXes, configure the smarthost here. Authentication credentials are encrypted at rest using the Hermes install's key material.

### Pro License Activation — *all topologies*

**Page**: System → Server Setup → License section

Enter your serial number to unlock Pro features (organizational signatures, encrypted mail, ACME / Let's Encrypt automation, ARC sealing, Link Guard, etc.). Validation hits `validate.hermesseg.io` over HTTPS; the result is cached locally so Pro stays available during brief network outages.

### Real TLS Certificate — *all topologies*

**Page**: System → System Certificates

Replace the bootstrap self-signed certificate with a real one before going live. Three paths:

| Path | Tier | Workflow |
| --- | --- | --- |
| **Request ACME** | Pro only | Click → enter domain → Let's Encrypt issues automatically, auto-renews |
| **Import Certificate** | Both tiers | Paste cert + key + chain from any CA you already have |
| **Generate CSR** | Both tiers | Generate signing request → submit to CA → import the result via the **Import Certificate** path |

For mailbox-hosting domains, see the in-app "Choosing the Right Certificate Type" panel on the System Certificates page — mailbox certs need SAN coverage for `autoconfig.<domain>` and `autodiscover.<domain>`.

> **Dashboard nudge**: blue informational callout `Self-signed cert` fires when the only row in `system_certificates` is the install-generated bootstrap (no real cert has been imported yet). Lower priority than the other nudges — Hermes still works on bootstrap, just produces a TLS warning in clients.

### DNS for Mail Flow — *all topologies*

Beyond the gateway itself, DNS is what makes mail actually arrive. The install script does **not** touch DNS — you do this at your registrar. "Your domains" below means relay domains, mailbox domains, or both — whichever you configured above.

| Record | Where it points | Why |
| --- | --- | --- |
| `MX` for each domain | The Hermes mail hostname (e.g. `mail.example.com`) | Inbound mail routing |
| `A` for the mail hostname | Hermes public IP | Resolves the MX target |
| Reverse DNS (PTR) for the IP | The mail hostname | Outbound deliverability — most receivers reject mismatched PTR |
| `SPF` for each sending domain | Includes Hermes IP | Authenticates outbound; reduces spam-folder rate |
| `DKIM` selector → public key | Generated under Content Checks → DKIM | Cryptographic signing of outbound |
| `DMARC` policy | TXT at `_dmarc.example.com` | Defines what receivers do with SPF/DKIM failures |

### Review the Admin Account Email — *all topologies*

**Page**: System → System Users (edit the admin user) — or your **My Profile** link (top of the sidebar)

The install created the admin account with a generated email of the form `<admin-username>@<your-mail-domain>` (e.g. `apologise4567@example.com`). That address is where Hermes sends **admin notifications and password-reset mail**, so unless it maps to a real, monitored mailbox, change it to one that does.

### Antispam Maintenance (Pyzor / Razor / Bayes) — *all topologies*

**Page**: Content Checks → Antispam Maintenance

- **Initialize Pyzor** and **Initialize Razor** — register with the Pyzor and Vipul's Razor collaborative spam-detection networks (one-time; requires outbound internet). SpamAssassin has both enabled, but they don't contribute scores until initialized.
- **Clear Bayes** — on a fresh install, reset the Bayesian classifier so it learns on *your* mail rather than any seeded training.

### Barracuda Central Registration — *all topologies*

Hermes' Postfix `postscreen` DNSBL list includes **`b.barracudacentral.org`**, and Barracuda Central only answers queries from **registered** IPs. Register your gateway's sending IP (free) at the Barracuda Reputation Block List site so those lookups return results instead of being silently ignored.

### CipherMail Console Admin Password — *all topologies (encryption)*

**Page**: the CipherMail console at `/ciphermail` (behind Authelia SSO)

The CipherMail encryption console has its **own** administrator account, separate from the Hermes/Authelia admin login. After install, sign in to the CipherMail console and change its default administrator password.

---

## Dashboard nudges

The admin dashboard surfaces two universal callout banners under the navbar — these apply regardless of topology:

| Color | Priority | Trigger |
| --- | --- | --- |
| Orange `Placeholder hostname` | 2 | `myhostname` or `console.host` still at the seed placeholder (`hermes.domain.tld` / `smtp.domain.tld`) |
| Blue `Self-signed cert` | 3 | Only the bootstrap cert exists in System Certificates — no real cert imported yet |

Each banner links directly to the page where you'd fix the underlying condition and disappears automatically as soon as the check passes. The topology-specific steps (relay domains, networks, recipients, mailbox domains, mailboxes) intentionally don't have dashboard nudges — they depend on which topology you're using and the guidance above covers them.

---

## After you finish these steps

1. **Inbound test** — send a message from an external account to a recipient on one of your domains. Check Reports → Mail Log to confirm it reached Hermes and was handed off (relay) or delivered to the mailbox (mail server).
2. **Outbound test** *(relay / hybrid)* — send a message from your customer MTA (the one whose IP you added to Relay Networks) to an external recipient. Confirm DKIM/SPF pass on the receiver side.
3. **Webmail test** *(mail server / hybrid)* — log in to `https://<console-host>/nc/` as one of your new mailbox users (Authelia SSO) and confirm send/receive.
4. Visit **System → Dashboard** and confirm both setup nudges are gone (placeholder hostname + self-signed cert).
5. If you set up Pro features, verify `session.edition` reads "Pro" in the top-right corner of any admin page.

You're done. Welcome to Hermes SEG.
