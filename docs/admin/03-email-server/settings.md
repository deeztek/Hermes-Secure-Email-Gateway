# Settings

Admin path: **Email Server > Settings** (`view_email_server_settings.cfm`,
`inc/email_server_settings_action.cfm`,
`inc/generate_dovecot_configuration.cfm`,
`inc/generate_mail_crypt_keys.cfm`).

This page is the **global configuration surface for the Email Server
topology** — the half of Hermes where Hermes is itself the destination
MTA, delivering inbound mail into Dovecot mailboxes on `/mnt/vmail` and
serving IMAP/POP3/Submission/Sieve back to end users. Per-domain
addressing lives on [Email Server > Domains](domains.md), per-mailbox
quotas and personal info on [Mailboxes](mailboxes.md), and aliases on
[Aliases](aliases.md); this page handles everything that applies
across all mailboxes regardless of domain — the Dovecot TLS profile,
mail compression and encryption-at-rest, which protocols are exposed,
quota warning thresholds, connection limits, debug logging, the
Nextcloud login-form mode that gates webmail SSO, and the master
toggle for shared mailboxes and folder sharing.

Most pages save and run a small handful of `docker exec` commands.
This page saves and re-renders the entire Dovecot configuration from
a template; the next inbound LMTP delivery sees the new settings.

## What this page does — and what it doesn't

| This page configures | This page does NOT configure |
|---|---|
| Dovecot TLS certificate, profile, ciphers, min protocol | LDAP authentication backend (hard-coded against `hermes_ldap`) |
| Mail compression (LZ4 / Zstd / Zlib) | Per-mailbox quota size (set on [Mailboxes](mailboxes.md)) |
| Mail encryption at rest (mail_crypt plugin + ECC key pair) | Per-domain delivery / acceptance (handled by [Domains](domains.md)) |
| IMAP and POP3 enable/disable | Submission, Sieve, LMTP enable (always on — required for core operation) |
| Quota warning thresholds (medium / high / critical / trash overage) | Default new-mailbox size (set per-mailbox; see [Mailboxes](mailboxes.md)) |
| Per-service client limit + per-user-per-IP connection cap | Postfix-side recipient validation (handled by Postfix `relay_recipient_maps`) |
| Dovecot debug logging | Authelia session timing, MFA enrollment, SMTP notifier ([Authentication Settings](../01-system/authentication-settings.md)) |
| Mailbox sharing master toggle (Shared/ namespace + user folder shares) | Per-user shared mailbox access (handled by [Shared Mailboxes](shared-mailboxes.md)) |
| Nextcloud login form mode (auto-redirect / SSO-only / full form) | Nextcloud OIDC client itself ([Authentication Settings](../01-system/authentication-settings.md)) |

## Configuration storage

Almost every setting on this page is keyed into `parameters2` under
`module = 'dovecot'` and read back by both the page and
`generate_dovecot_configuration.cfm` at render time. A handful of
adjacent concerns live in sibling modules:

| Settings group | Storage |
|---|---|
| All Dovecot directives (compression, encryption, protocols, quota, connections, logging, sharing, TLS profile/ciphers) | `parameters2` rows where `module = 'dovecot'`, keyed by dotted names like `mail.compression_algorithm`, `quota.warning_critical`, `ssl.min_protocol` |
| TLS certificate selection | `parameters2` row `module = 'certificates'`, `parameter = 'mail.certificate'`, value = `system_certificates.id` |
| Nextcloud login-form mode | `parameters2` row `module = 'nextcloud'`, `parameter = 'oidc.auto_redirect'`, value = `auto_redirect` / `sso_only` / `full_form` (legacy `true`/`false` strings normalized on read) |
| Mail encryption key pair | Files at `/opt/hermes/keys/ecprivkey.pem` and `/opt/hermes/keys/ecpubkey.pem` on the Docker host |
| Live Dovecot config | `/etc/dovecot/dovecot.conf` (regenerated from `/opt/hermes/templates/dovecot.conf` on every save) |

`parameters2` is keyed by the `module + parameter` pair. The action
handler uses an upsert pattern (`checkDovParam` → UPDATE-or-INSERT) so
fresh installs that haven't yet had the schema seeded with every row
land cleanly on first save.

## How a save propagates

```
form submit  ──► email_server_settings_action.cfm
                       │
                       │  1. validate + sanitize (whitelist enums,
                       │     clamp numeric ranges, normalize booleans)
                       │
                       │  2. Nextcloud login-form mode
                       │     - UPDATE/INSERT parameters2 (oidc.auto_redirect)
                       │     - docker exec hermes_nextcloud occ
                       │         config:app:set user_oidc
                       │         allow_multiple_user_backends = 0|1
                       │     - docker exec hermes_nextcloud occ
                       │         config:system:set/delete hide_login_form
                       │
                       │  3. Dovecot TLS cert
                       │     - verify system_certificates row exists
                       │     - UPDATE/INSERT parameters2 (mail.certificate)
                       │
                       │  4. Mail encryption key generation (if enabled
                       │     AND keys missing OR zero-byte)
                       │     - cfinclude generate_mail_crypt_keys.cfm
                       │     - openssl ecparam + ec via docker exec
                       │     - writes /opt/hermes/keys/ecprivkey.pem
                       │             /opt/hermes/keys/ecpubkey.pem
                       │
                       │  5. Dovecot settings batch upsert
                       │     - loop the dovSettings struct
                       │     - UPDATE-or-INSERT each parameters2 row
                       │
                       │  6. cfinclude generate_dovecot_configuration.cfm
                       │     - reads /opt/hermes/templates/dovecot.conf
                       │     - substitutes placeholders from parameters2
                       │     - writes /etc/dovecot/dovecot.conf
                       │     - docker exec hermes_dovecot dovecot reload
                       │
                       v
            cflocation → session.m = 1 (success) or 10 (per-step errors)
```

Validation lives entirely in the action handler. Each step is wrapped
in its own `cftry` so a failure in (e.g.) the Nextcloud `occ` step
accumulates into `session.saveErrors` but doesn't abort the Dovecot
save. Step 6 — the Dovecot regen — gates on `NOT saveError` so a
broken upstream step doesn't push a half-rendered config file.

## Cards on the page

### Nextcloud Webmail Settings

Single dropdown that controls the Nextcloud login page behavior.
Three modes — chosen because two underlying Nextcloud knobs
(`user_oidc.allow_multiple_user_backends` and the system-wide
`hide_login_form`) compose into three meaningful states:

| Mode | `allow_multiple_user_backends` | `hide_login_form` | User experience |
|---|---|---|---|
| **Auto-redirect to SSO** (default) | `0` | (unset) | Clicking "Login to Webmail" silently bounces through Authelia OIDC and lands the user in Nextcloud already authenticated. True SSO — no Nextcloud login page is ever shown. |
| **SSO button only** | `1` | `true` | The Nextcloud login page is shown but with the username/password fields hidden — only the SSO button is visible. Good when you want users to know SSO is required but don't want to auto-redirect. |
| **Show full form** | `1` | (unset) | Both the username/password form and the SSO button are shown. Use temporarily for local Nextcloud admin maintenance. |

The legacy storage key `oidc.auto_redirect` is reused as the slot for
this three-way value so existing installs don't need a migration. The
read path in `view_email_server_settings.cfm` normalizes legacy
`true`/`false` strings to `auto_redirect` / `full_form`.

## Nextcloud Maintenance Mode card

Below the Webmail Settings card sits a second card that controls the local-admin escape hatch. As of [#262](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/262) there is **no permanent bypass URL** &mdash; the operator toggles OIDC on/off from this card when they need to administer Nextcloud as the local admin (separate identity from the Authelia/LDAP users that normally SSO in).

| State | What it means |
| --- | --- |
| `OIDC ENABLED` (green) | Normal operation. Mailbox users SSO into Nextcloud via Authelia. The local NC admin **cannot** log in. |
| `MAINTENANCE MODE` (yellow) | Click "Enter Maintenance Mode" ran `occ app:disable user_oidc`. Mailbox-user SSO is offline. The local NC admin can now log in via Nextcloud's own form at `/nc/`. |

**Maintenance procedure:**

1. Click **Enter Maintenance Mode**. The card status flips to yellow, mailbox-user SSO goes offline, and a success banner appears at the top of the page.
2. Click the **Open Nextcloud** button that appears below the toggle &mdash; it opens `https://<console-host>/nc/` in a new tab (`target="_blank"`) so the Hermes admin tab stays put for step 7.
3. In the Nextcloud tab, log in as the NC local admin. Username is shown on the card; password is also in `/opt/hermes-seg-container-gl/INSTALL_SUMMARY.txt` on the host.
4. On first login Nextcloud prompts for TOTP enrollment via its own UI &mdash; scan the QR code with any TOTP authenticator app.
5. **First login only &mdash; generate backup codes immediately**. Click your avatar (top-right) &rarr; **Personal settings** &rarr; **Security**, scroll to **Two-Factor backup codes**, click **Generate backup codes**. Save the 10 single-use codes somewhere safe (password manager, printed copy in a safe, etc.). These codes are the ONLY recovery path if you lose your TOTP authenticator &mdash; without them, recovery requires shell access. Done once per admin; codes persist across sessions until used.
6. Do your admin work in Nextcloud.
7. Switch back to the Hermes admin tab and click **Exit Maintenance Mode**. SSO is restored for mailbox users.

The button uses `fetch()` to call `inc/edit_nc_oidc_action.cfm` (`occ app:disable user_oidc` or `enable`), bypassing the outer settings form so the toggle doesn't collide with a normal Save submission. `redirect: 'manual'` on the fetch prevents the action handler's `cflocation` from being auto-followed and consuming the `session.m` flash before the page can render it.

Operators who need to use this often can ignore step 2's helper link and just type `/nc/` &mdash; the helper link exists to make first-time use obvious.

**Why the toggle pattern and not a permanent bypass URL:**

Earlier attempts at a permanent local-admin URL (the `/nc-admin-login` path) were architecturally infeasible. The Authelia session created by gating that URL fueled `user_oidc` silent OIDC re-auth on every post-form `/nc/` request, overriding whatever local-admin session the form submission had just established. Removing the Authelia gate didn't help either because `user_oidc` itself force-redirects `/login?direct=1` to OIDC under several conditions. The toggle is the only path that reliably wins against `user_oidc`, and it's what most NC operators in OIDC-fronted deployments use anyway. See #262 for the full diagnostic trace.

**Recovery if the NC local admin loses their TOTP authenticator:**

1. **Preferred &mdash; backup codes** (generated at TOTP enrollment time per step 5 of the maintenance procedure above). At the TOTP prompt during login, click **"Use backup code"** (or **"Try another method"**, wording varies by NC version), paste one of the saved codes. Each code is single-use, so re-generate a new set after recovery via Personal &rarr; Security &rarr; Two-Factor backup codes.

2. **Fallback &mdash; disable enforcement via shell** (only if backup codes are also lost or were never generated):

   ```bash
   docker exec hermes_nextcloud php occ twofactorauth:enforce --off
   # log in, re-enroll TOTP via NC UI, generate fresh backup codes, then:
   docker exec hermes_nextcloud php occ twofactorauth:enforce --on
   ```

   This requires shell access to the Hermes host. If you don't have shell access, the only recovery is restoring `/mnt/data/dbase/` from a backup taken when the admin still had TOTP access, which is a significantly more disruptive operation. Generating backup codes at enrollment time is much cheaper.

### Mailbox Sharing

Single dropdown — Enabled or Disabled. Stored as `sharing.enabled` in
`parameters2`.

| State | Dovecot effect |
|---|---|
| **Enabled** | Shared mailbox support is compiled into the Dovecot config (`acl`, `imap_acl`, `imap_quota` plugins and the `Shared/` namespace). Per-mailbox shares are then managed under [Shared Mailboxes](shared-mailboxes.md). Folder-level user-managed shares work in IMAP clients that support them. |
| **Disabled** | The shared namespace is not declared in the Dovecot config and IMAP clients won't see a `Shared/` folder. Existing per-mailbox ACL entries are preserved in their backing files but are inactive until sharing is re-enabled. |

Toggling this is the master switch. The per-mailbox setup work happens
on [Shared Mailboxes](shared-mailboxes.md).

### TLS / SSL Settings

The cert that Dovecot presents on every IMAPS / POP3S / submission
connection. Driven by:

| Field | Notes |
|---|---|
| **Mail Server Certificate** | Autocomplete against `system_certificates` (via `inc/getcertificates.cfm`). Selecting a row populates the four read-only fields below and writes the cert `id` into `parameters2`. Manage certificates on [System Certificates](../01-system/system-certificates.md). |
| **TLS Security Profile** | `Modern` (TLS 1.3 only) / `Intermediate` (TLS 1.2+, recommended) / `Legacy` (TLS 1.2+, broad compatibility) / `Custom`. Presets follow [Mozilla Server Side TLS](https://ssl-config.mozilla.org/) guidance. |
| **Minimum TLS Version** | Auto-set by profile (read-only) when a preset is selected; editable in Custom mode. |
| **SSL Cipher List** | Auto-set by profile (read-only) when a preset is selected; editable in Custom mode. The page's JS form-submit hook re-enables disabled fields before submit so their values are POSTed. The action handler's `cfswitch` then re-derives the canonical preset values defensively so the saved values always match the named profile. |

`Intermediate` is the default and the only profile that ships with a
non-empty cipher list. `Modern` deliberately leaves the cipher field
empty because OpenSSL picks TLS 1.3 ciphers automatically.

### Mail Storage — Compression

| Field | Notes |
|---|---|
| **Mail Compression** | Enabled / Disabled. When Disabled, the algorithm and level fields are JS-disabled. |
| **Algorithm** | `LZ4` (fastest, good compression) / `Zstandard` (balanced) / `Zlib/Deflate` (best ratio, slowest). LZ4 is the default. |
| **Compression Level** | Numeric. Hidden for LZ4 (no level knob). 1–22 for Zstandard (default 3), 1–9 for Zlib (default 6). The handler enforces the Zlib ceiling — Zlib with level > 9 is clamped to 6. |

Compression is mailbox-format aware: only newly delivered or saved
messages are compressed, existing messages remain readable, and Dovecot
auto-detects the format per message on read. Changing or disabling
compression never breaks existing mail; mailboxes safely contain a mix
of uncompressed, LZ4, and Zstandard messages.

### Mail Storage — Encryption at Rest

Dovecot's `mail_crypt` plugin with an EC-curve key pair stored on the
Docker host. **This is irreversible-ish — back up the keys.**

| Field | Behavior |
|---|---|
| **Encryption at Rest** | Disabled (default) / Enabled. Saving with Enabled and no key pair triggers `generate_mail_crypt_keys.cfm`, which runs `openssl ecparam` + `openssl ec` via `docker exec hermes_dovecot` to write `/opt/hermes/keys/ecprivkey.pem` and `ecpubkey.pem`. |
| **Elliptic Curve** | `prime256v1` / `secp384r1` / `secp521r1`. Selectable only when no keys exist yet — once keys are generated the field is rendered as a read-only display because changing curves with mismatched keys would render existing encrypted mail unreadable. |
| **Algorithm** | Always `AES-256-GCM`. Not configurable. |
| **Key Status** | Badge: `Keys Present` (green), `Keys Empty` (red — files exist but zero-byte from a failed previous attempt; delete from the host to regenerate), or `No Keys` (gray — auto-generated on enable). |

> **Operational consequence.** Only newly delivered mail is encrypted.
> Disabling encryption later does not affect existing encrypted
> messages — they remain readable as long as the keys are present.
> If the keys are lost there is no recovery mechanism; encrypted mail
> becomes permanently unreadable. The two PEM files belong in every
> system backup. The system-backup script collects `/opt/hermes/keys/`
> automatically, but operators running off-Hermes backup tooling must
> include this directory explicitly.

### Protocols & Connections — Protocols

Per-protocol enable/disable for the end-user-facing services.
**Submission, Sieve, and LMTP are always enabled** — Submission for
authenticated outbound and vacation responder, Sieve for mail filter
rules, LMTP for Postfix-to-Dovecot delivery — and surface in the UI
as read-only `Always Enabled` fields.

| Protocol | Ports | Knob |
|---|---|---|
| IMAP | 993 / 143 | `protocol.imap` — Enabled / Disabled |
| POP3 | 995 / 110 | `protocol.pop3` — Enabled / Disabled |
| Submission | 587 | Always on |
| Sieve / LMTP | 4190 / 24 | Always on |

Disabling IMAP or POP3 takes effect on the next Dovecot reload — the
service is dropped from `protocols = ...` in `dovecot.conf` and the
listener stops.

### Protocols & Connections — Connection Limits

| Field | Default | Notes |
|---|---|---|
| **Login Service Client Limit** | `1000` | Max concurrent connections per login service (IMAP, POP3, Submission, ManageSieve). Clamped 100–10000. Increase for installs with many simultaneous users. |
| **Max Connections per User per IP** | `20` | Per-user-per-source-IP cap. Stops a runaway client from consuming the global pool. Clamped 1–1000. Bump for users with many devices / many open folders. |

### Quota Settings — Warning Thresholds

When a mailbox crosses these usage thresholds, Dovecot's quota-warn
hook sends an email notification. A "back under quota" notice is
always sent when usage drops below 100% — that one is not configurable.
**Per-mailbox quota sizes are set per-mailbox** on
[Mailboxes](mailboxes.md); this card only controls the warning bands.

| Field | Default | Range |
|---|---|---|
| Critical Warning | `99` % | 1–100. Triggers the "Mailbox Full" notification. |
| High Warning | `95` % | 1–100. Triggers the "Nearly Full" notification. |
| Medium Warning | `80` % | 1–100. Triggers the first warning notification. |
| Trash Quota Overage | `110` % | 100–200. The Trash folder is allowed this percentage of the user's quota so users can still delete messages when they're at 100%. Default leaves 10% headroom in Trash. |

### Logging

| Field | Notes |
|---|---|
| **Debug Logging** | Disabled (production, default) / Enabled (troubleshooting). When Enabled, Dovecot's `mail_debug = yes` and `auth_debug = yes` are emitted. Output lands in `/logs/dovecot-debug.log` inside the container. Significant log volume — leave off in production. |

## Failure semantics

| What breaks | What happens |
|---|---|
| Nextcloud `occ` step fails (container down, OIDC app not installed) | Per-error message appended to `session.saveErrors`, banner shown at top of page, **other steps still run** |
| TLS cert id doesn't match a `system_certificates` row | `parameters2 mail.certificate` is not updated; Dovecot keeps using whatever cert was previously selected |
| `generate_mail_crypt_keys.cfm` fails | Per-error message appended; encryption may be enabled in DB but keys missing — admin sees the Keys Empty badge on the next page load, must clear the partial files and retry |
| Dovecot config regen fails (template missing, substitution error) | `session.m = 10`, error banner with the cfcatch message; **the previous `dovecot.conf` is still on disk** because the template renderer writes to a temp path and atomically moves only on success |
| `dovecot reload` fails | The new config is on disk but the running Dovecot is still on the old config. Recovery is `docker exec hermes_dovecot dovecot reload` from the host or a container restart. |
| Encryption keys deleted from host while encryption is enabled | New incoming mail cannot be encrypted; Dovecot logs the failure and the LMTP delivery is deferred. Existing encrypted mail remains unreadable until the keys are restored from backup. |

## Files and containers touched

| Path | Owner | Role |
|---|---|---|
| `config/hermes/var/www/html/admin/2/view_email_server_settings.cfm` | `hermes_commandbox` | Page + cards |
| `config/hermes/var/www/html/admin/2/inc/email_server_settings_action.cfm` | `hermes_commandbox` | Save handler |
| `config/hermes/var/www/html/admin/2/inc/generate_dovecot_configuration.cfm` | `hermes_commandbox` | Template-to-`dovecot.conf` renderer + `dovecot reload` |
| `config/hermes/var/www/html/admin/2/inc/generate_mail_crypt_keys.cfm` | `hermes_commandbox` | EC key pair generator |
| `config/hermes/var/www/html/admin/2/inc/getcertificates.cfm` | `hermes_commandbox` | Autocomplete for the Mail Server Certificate field |
| `/opt/hermes/templates/dovecot.conf` | `hermes_commandbox` | Dovecot template |
| `/etc/dovecot/dovecot.conf` | `hermes_dovecot` (volume-mounted) | Live Dovecot config (regen target) |
| `/opt/hermes/keys/ecprivkey.pem`, `ecpubkey.pem` | `hermes_dovecot` (volume-mounted) | mail_crypt key pair |
| `parameters2` rows where `module IN ('dovecot','certificates','nextcloud')` | `hermes_db_server` | Settings storage |
| `system_certificates` | `hermes_db_server` | TLS certificate lookup |
| `hermes_nextcloud` container | — | `occ config:app:set user_oidc allow_multiple_user_backends`, `occ config:system:set/delete hide_login_form` |

Every shell-out uses `docker exec hermes_dovecot ...` or
`docker exec hermes_nextcloud ...` per the standard Hermes pattern.

## Related

- [Domains](domains.md) — per-domain configuration for the mailbox
  topology. Add a domain there first; this page's settings then apply
  to every mailbox on every domain.
- [Mailboxes](mailboxes.md) — per-mailbox quota size, personal info,
  encryption opt-in. The quota size set per-mailbox is what the
  warning thresholds on this page measure against.
- [Aliases](aliases.md) — alias addresses that resolve to local
  mailboxes. The Email Server alternative to
  [Email Relay > Virtual Recipients](../02-email-relay/virtual-recipients.md).
- [Shared Mailboxes](shared-mailboxes.md) — per-mailbox shared-access
  configuration. The master switch on this page must be on for any
  shared mailbox to function.
- [Mailbox Rules](mailbox-rules.md) — server-side Sieve rules per
  mailbox; Sieve is always-on at the protocol level via this page.
- [SAN Management](san-management.md) — Subject Alternative Names on
  the Dovecot TLS certificate. The cert selected on this page is the
  one SAN Management edits.
- [System Certificates](../01-system/system-certificates.md) —
  managing the certificate inventory that the Mail Server Certificate
  autocomplete draws from.
- [Authentication Settings](../01-system/authentication-settings.md)
  — Authelia, the OIDC client, and the Nextcloud-side session-lifetime
  knobs that complement the login-form mode dropdown on this page.
