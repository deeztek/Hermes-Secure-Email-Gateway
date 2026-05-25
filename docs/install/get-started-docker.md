# Get Started (Docker)

This page is the **minimum config needed to get mail flowing** on a fresh Hermes SEG Docker install. The install script (`scripts/install_hermes_docker.sh`) does most of the heavy lifting — this page covers the handful of admin-UI steps that still need a human.

If you skip these, Postfix will silently bounce or reject incoming mail and the admin UI will surface red callout banners until the missing pieces are filled in (see [Dashboard nudges](#dashboard-nudges) at the bottom).

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

## Required configuration

### 1. System Identity {#system-identity}

**Page**: System → Server Setup

The install script sets `myhostname` from what you typed at the FQDN prompt, but you should double-check it matches your DNS A / MX records. Also set:

- **Postmaster address** — where bounce messages and admin notifications go
- **Admin email** — where alerts (license, system events) get delivered
- **Time zone** — affects log timestamps and report scheduling

> **Dashboard nudge**: an orange callout `Placeholder hostname` fires if `myhostname` still equals the seed default `hermes.domain.tld` or `console.host` equals `smtp.domain.tld`. Both should never appear on a Docker install (the install script overrides them), but if they do, this is the page to fix.

### 2. First Relay Domain {#first-domain}

**Page**: Email Relay → Domains

Add **at least one domain** so Hermes knows what mail to accept on the SMTP port. Without this, every inbound message gets rejected with `Relay access denied`.

For each domain you'll choose:

| Field | What it controls |
| --- | --- |
| Domain | The recipient domain (e.g. `@example.com`) |
| Recipient delivery mode | Where validated mail goes next — relay forwards to a downstream MX; local delivers to a Hermes-hosted mailbox |
| Destination address / port | The downstream MX (relay mode) or which mailbox-hosting-domain (local mode) |
| Policy | Encryption policy applied to outbound mail for this domain (Pro only) |

> **Dashboard nudge**: red callout `No relay domains configured` fires when `SELECT COUNT(*) FROM domains = 0`.

### 3. Relay Networks {#relay-networks}

**Page**: Email Relay → Relay Networks

Add the IP addresses or CIDR blocks of any **upstream MTA** (your customer's mail server, an application server that sends notification mail, etc.) that should be allowed to relay outbound mail through Hermes.

By default Hermes only trusts `127.0.0.1` and the Docker bridge subnet (`172.16.32.0/24`). Anything else needs to be added here.

> **Dashboard nudge**: red callout `No relay networks configured` fires when there are zero entries beyond the two install defaults.

### 4. First Recipient OR Mailbox {#first-recipient}

You need **at least one of these two** depending on topology:

#### Relay topology (Hermes forwards to a downstream MX)

**Page**: Email Relay → Relay Recipients

Add the individual recipients (or wildcards) that Hermes should accept mail for. The validated mail is then forwarded to the destination set on the domain row in step 2.

#### Hermes-hosted mailboxes topology

**Page**: Email Server → Mailboxes

Skip Relay Recipients entirely and create mailboxes on Hermes itself. Each mailbox row creates an LDAP user, a Dovecot maildir, and (optionally) a Nextcloud account.

> **Dashboard nudge**: red callout `No recipients or mailboxes` fires only when **both** the `recipients` table AND the `mailboxes` table are empty. Either one being populated satisfies the gate.

---

## Optional but recommended

### 5. Relay Host (Outbound Smarthost)

**Page**: Email Relay → Relay Host

If outbound mail should route through Gmail / M365 / SendGrid / etc. instead of being sent directly to recipient MXes, configure the smarthost here. Authentication credentials are encrypted at rest using the Hermes install's key material.

### 6. Pro License Activation

**Page**: System → Server Setup → License section

Enter your serial number to unlock Pro features (organizational signatures, encrypted mail, ACME / Let's Encrypt automation, ARC sealing, etc.). Validation hits `validate.hermesseg.io` over HTTPS; the result is cached locally so Pro stays available during brief network outages.

> See [License Validation flow in CLAUDE.md](../../CLAUDE.md#pro-edition-license-validation) for the detailed state machine.

### 7. Real TLS Certificate {#optional-tls-cert}

**Page**: System → System Certificates

Replace the bootstrap self-signed certificate with a real one before going live. Three paths:

| Path | Tier | Workflow |
| --- | --- | --- |
| **Request ACME** | Pro only | Click → enter domain → Let's Encrypt issues automatically, auto-renews |
| **Import Certificate** | Both tiers | Paste cert + key + chain from any CA you already have |
| **Generate CSR** | Both tiers | Generate signing request → submit to CA → import the result via _Import Certificate_ |

For mailbox hosting domains, see the in-app guide "Choosing the Right Certificate Type" panel on the System Certificates page — mailbox certs need SAN coverage for `autoconfig.<domain>` and `autodiscover.<domain>`.

> **Dashboard nudge**: blue informational callout `Self-signed cert` fires when the only row in `system_certificates` is the install-generated bootstrap (no real cert has been imported yet). Lower priority than the other nudges — Hermes still works on bootstrap, just produces a TLS warning in clients.

### 8. DNS for Mail Flow

Beyond the gateway itself, DNS is what makes mail actually arrive. The install script does **not** touch DNS — you do this at your registrar.

| Record | Where it points | Why |
| --- | --- | --- |
| `MX` for each relay domain | The Hermes mail hostname (e.g. `mail.example.com`) | Inbound mail routing |
| `A` for the mail hostname | Hermes public IP | Resolves the MX target |
| Reverse DNS (PTR) for the IP | The mail hostname | Outbound deliverability — most receivers reject mismatched PTR |
| `SPF` for each sending domain | Includes Hermes IP | Authenticates outbound; reduces spam-folder rate |
| `DKIM` selector → public key | Generated under Content Checks → DKIM | Cryptographic signing of outbound |
| `DMARC` policy | TXT at `_dmarc.example.com` | Defines what receivers do with SPF/DKIM failures |

---

## Dashboard nudges

After each install, the admin dashboard surfaces red / orange / blue callout banners under the navbar whenever any of the above gates aren't satisfied:

| Color | Priority | Trigger |
| --- | --- | --- |
| Red `Setup needed` | 1 | No relay domains, OR no relay networks, OR no recipients + no mailboxes |
| Orange `Placeholder hostname` | 2 | `myhostname` or `console.host` still at seed placeholder |
| Blue `Self-signed cert` | 3 | Only the bootstrap cert exists in System Certificates |

Each banner links directly to the page where you'd fix the underlying condition. There's no "hide forever" — the callout disappears automatically as soon as the underlying check passes (add a domain → "no relay domains" disappears, etc.).

---

## After you finish these steps

1. Send a **test message** from an external account to a recipient on one of your relay domains. Check Reports → Mail Log to confirm it arrived at Hermes and was handed off downstream.
2. Send a **test outbound message** from your customer MTA (the one whose IP you added to Relay Networks) to an external recipient. Confirm DKIM/SPF pass on the receiver side.
3. Visit **System → Dashboard** and confirm all priority-1/2/3 setup nudges are gone.
4. If you set up Pro features, verify `session.edition` reads "Pro" in the top-right corner of any admin page.

You're done. Welcome to Hermes SEG.
