# Hermes SEG Email Flow

Reference diagram for the inbound, outbound, and CipherMail-originated mail
paths inside the Docker stack. Includes every listening port, every container,
the milter chain at each smtpd service, and where body modifications occur
relative to DKIM signing.

Companion to [`docs/handoff-#232-multi-instance-opendkim.md`](../handoff-#232-multi-instance-opendkim.md).

---

## Container + port map (at a glance)

| Container | Service / Daemon | Port(s) | Role |
|-----------|------------------|---------|------|
| `hermes_postfix_dkim` | postfix smtpd (`:25`) | 25 | Inbound MX |
| `hermes_postfix_dkim` | postfix smtpd (`submission`) | 587 | Authenticated outbound (STARTTLS) |
| `hermes_postfix_dkim` | postfix smtpd (`smtps`) | 465 | Authenticated outbound (implicit TLS) |
| `hermes_postfix_dkim` | postfix smtpd (`:10026`) | 10026 | Re-injection (post-CipherMail) |
| `hermes_postfix_dkim` | postfix smtpd (`:10027`) | 10027 | CipherMail web-GUI originated mail |
| `hermes_postfix_dkim` | OpenDKIM **primary** (sv mode) | 8891 | Verify inbound / sign outbound at `:25`/`:587`/`:465` |
| `hermes_postfix_dkim` | OpenDKIM **sign-only** (s mode) — #232 | 8892 | Sign post-CipherMail egress at `:10026` only |
| `hermes_mail_filter` | amavisd-new (filter) | 10021 | SpamAssassin + ClamAV + policy |
| `hermes_mail_filter` | amavisd-new (pickup / bypass) | 10030 | `BYPASSALLCHECKS` lane |
| `hermes_body_milter` | Python pymilter (#214/#226/#228/#230) | 8893 | Disclaimer + signature + banner + CID inline |
| `hermes_dmarc` | OpenDMARC | 54321 | DMARC verify / SPF alignment header |
| `hermes_ciphermail` | CipherMail SMTP | 25 | Encryption decisions + MIME rebuild |
| `hermes_dovecot` | LMTP | 24 | Local mailbox delivery |

Milter listening side: the OpenDKIM/OpenDMARC/body_milter daemons listen on
TCP and postfix smtpd connects to them per the `smtpd_milters` line in effect
for each port.

---

## Milter chains by smtpd port

The `smtpd_milters` chain order is set globally in `main.cf` (built from the
`parameters` DB table by `generate_postfix_configuration.cfm`) and overridden
per-service in `master.cf` for `:10026` and `:10027`.

| smtpd port | Milter chain (in order) | Why |
|------------|-------------------------|-----|
| `:25` (inbound) | OpenDKIM **:8891** → OpenDMARC **:54321** → body_milter **:8893** | Verify DKIM, verify DMARC, then inject External Banner / disclaimer |
| `:587` `:465` (submission) | OpenDKIM **:8891** → OpenDMARC **:54321** → body_milter **:8893** | Sign DKIM first (before body mods), then disclaimer/signature inject — **wrong order; see #232 outbound fix history** |
| `:10026` (re-inject) | OpenDKIM **:8892** sign-only | Re-sign body that CipherMail mutated; do NOT verify (it would `dkim=fail` on the body-modified inbound) |
| `:10027` (CipherMail GUI) | OpenDKIM **:8891** | Sign GUI-originated mail; no body mods on this path |

> The body_milter ordering is recorded in `parameters` as `order1=3.1` so it
> sits AFTER OpenDKIM signer (`0.5`) and OpenDMARC. The retro-fix `UPDATE` in
> `updates/hermes-260119/sql/schema_updates.sql` corrects existing installs
> that had `0.5` for body_milter (which placed body mods BEFORE signing, the
> root cause of #232 outbound DKIM failures).

---

## Inbound flow

External MTA → local mailbox.

```
                  ┌─────────────────────────────────────────────────────────────────────┐
                  │ External Internet                                                   │
                  └─────────────────────────────────────────────────────────────────────┘
                                                  │
                                                  │ SMTP / DKIM-signed by sender
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_postfix_dkim  ▸  :25  (postfix smtpd, inbound MX)                    │
            │   ▸ smtpd_milters chain:                                                    │
            │       1. OpenDKIM primary  inet:127.0.0.1:8891   (verify sender's DKIM)    │
            │       2. OpenDMARC         inet:hermes_dmarc:54321 (verify DMARC alignment)│
            │       3. body_milter       inet:hermes_body_milter:8893 (External Banner)  │
            │   ▸ content_filter = amavis:[hermes_mail_filter]:10021                     │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_mail_filter   ▸  :10021  (amavisd-new — main filter lane)           │
            │   ▸ SpamAssassin scoring     (sees body, computes its own DKIM_INVALID     │
            │                               since body_milter already injected banner)   │
            │   ▸ ClamAV virus scan                                                       │
            │   ▸ Policy / quarantine decisions                                           │
            │   ▸ $forward_method = smtp:hermes_ciphermail:25                            │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_ciphermail    ▸  :25     (encryption gateway)                        │
            │   ▸ Encryption-mode decisions                                               │
            │   ▸ MIME rebuild  (always — not byte-stable across this hop)               │
            │   ▸ Re-injects to → smtp:hermes_postfix_dkim:10026                         │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_postfix_dkim  ▸  :10026  (postfix smtpd, re-injection)               │
            │   ▸ smtpd_milters = inet:localhost:8892  (OpenDKIM sign-only, s mode) #232  │
            │                                                                             │
            │   For INBOUND mail, the From: domain is NOT in the local KeyTable.         │
            │   → sign-only instance does nothing (no key match → no header added)       │
            │   → critically: it also does NOT verify, so no Authentication-Results      │
            │     "dkim=fail" header gets written against the body-modified message.     │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  transport_maps lookup
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_dovecot       ▸  :24  (LMTP)                                         │
            │   ▸ Sieve filtering (vacation, redirect, file-into)                         │
            │   ▸ Local mailbox delivery → /mnt/data/vmail                                │
            └─────────────────────────────────────────────────────────────────────────────┘
```

### Inbound paths that diverge

- **Relay-only domains** (in `transport_maps`) skip Dovecot and `smtp:`-forward
  to the next-hop MX listed in `/etc/postfix/transport`.
- **Quarantined / virus / bad-header** mail is held by amavis at `:10021`
  (final destinies: `D_BOUNCE` virus/banned, `D_DISCARD` spam/bad_header per
  `50-user` config).
- **Whitelisted senders** bypass via `BYPASSALLCHECKS` at `:10030`.

---

## Outbound flow

Authenticated local user → external recipient.

```
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ Mail Client (Outlook / Thunderbird / iOS Mail / Roundcube / NC Mail)        │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  SMTP submission
                                                  │  (SASL AUTH via Dovecot SASL :9587)
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_postfix_dkim  ▸  :587 (submission)  OR  :465 (smtps)                 │
            │   ▸ smtpd_milters chain (same as :25):                                      │
            │       1. OpenDKIM primary :8891   ◀─── signs DKIM here                     │
            │       2. OpenDMARC :54321         (record verify; outbound mostly noop)     │
            │       3. body_milter :8893        ◀─── injects disclaimer/signature        │
            │   ▸ content_filter = amavis:[hermes_mail_filter]:10021                     │
            │                                                                             │
            │   ⚠ #232 historical bug: with body_milter at order1=0.5 (before OpenDKIM),  │
            │     body_milter ran BEFORE signing, so DKIM signed the pre-modified body.   │
            │     Fixed by raising body_milter to order1=3.1 (after OpenDKIM signer).     │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_mail_filter   ▸  :10021  (amavisd-new)                              │
            │   ▸ MYNETS policy_bank (originating=1, higher spam_kill threshold)         │
            │   ▸ Virus / banned-file scan                                                │
            │   ▸ $forward_method = smtp:hermes_ciphermail:25                            │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_ciphermail    ▸  :25     (S/MIME / PGP encryption)                   │
            │   ▸ Encryption-mode lookup per recipient                                    │
            │   ▸ MIME rebuild (BREAKS the original DKIM bh= hash — receipt below)        │
            │   ▸ Re-injects to → smtp:hermes_postfix_dkim:10026                         │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_postfix_dkim  ▸  :10026  (re-injection)                              │
            │   ▸ smtpd_milters = inet:localhost:8892  (OpenDKIM sign-only) #232          │
            │                                                                             │
            │   For OUTBOUND mail, the From: domain IS in the local KeyTable.            │
            │   → sign-only instance signs the post-CipherMail body.                     │
            │   → fresh DKIM header replaces (or oversigns) the stale one from :587.     │
            │                                                                             │
            │   ⚠ Historical bug: master.cf had `no_milters` in receive_override_options │
            │     at :10026 → suppressed all milters → no re-sign → Gmail rejected.      │
            │     Fixed by removing `no_milters` token (commit 7014285).                  │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp (smtp_milters chain on egress)
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ External MX (recipient gateway)                                             │
            │   → DKIM verify against `From:` domain key (DNS TXT)                        │
            │   → DMARC alignment                                                          │
            │   → Deliver                                                                 │
            └─────────────────────────────────────────────────────────────────────────────┘
```

---

## CipherMail web-GUI originated mail

When admins send mail directly from CipherMail's web GUI (rare), it enters
postfix at `:10027`, bypasses amavis content filtering entirely, and is signed
by the **primary** OpenDKIM (`:8891`) — not the sign-only instance — because
this path doesn't traverse any body-modification hop and the standard sv-mode
instance is appropriate.

```
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ CipherMail web GUI (admin compose)                                          │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp
                                                  ▼
            ┌─────────────────────────────────────────────────────────────────────────────┐
            │ hermes_postfix_dkim  ▸  :10027                                              │
            │   ▸ smtpd_milters = inet:localhost:8891  (OpenDKIM primary, sv mode)        │
            │   ▸ No content_filter — bypasses amavis                                     │
            └─────────────────────────────────────────────────────────────────────────────┘
                                                  │  smtp egress
                                                  ▼
                                    External MX (recipient gateway)
```

---

## Why two OpenDKIM instances? (#232 architecture decision)

A single OpenDKIM instance in sv mode (verify + sign) cannot satisfy both
requirements at `:10026`:

| Requirement | Default sv instance at :8891 | Sign-only instance at :8892 |
|-------------|------------------------------|------------------------------|
| Verify inbound at `:25` | ✅ does this | ❌ wouldn't (correctly) |
| Sign outbound at `:587`/`:465` | ✅ does this | ❌ wouldn't (correctly) |
| Sign outbound re-inject at `:10026` (post-CipherMail body rebuild) | ✅ would sign | ✅ signs |
| Skip verify on inbound re-inject at `:10026` (post-body-milter banner) | ❌ verifies → `dkim=fail` Authentication-Results | ✅ never verifies |

OpenDKIM has no per-port mode override, and `InternalHosts` / `ExternalIgnoreList`
control signing-vs-verification only by sender IP — not by smtpd inet service.
Per OpenDKIM's own project guidance, running a second daemon with a different
config file is the supported way to get differential behavior on a single host.

The sign-only instance ignores inbound mail naturally: its `KeyTable` and
`SigningTable` only contain entries for local domains, so inbound mail (where
the From: domain matches no local key) is a no-op pass-through — it neither
signs nor adds Authentication-Results.

---

## Receipts (forensic proof captured during #232 diagnosis)

| Symptom | Evidence | Root cause |
|---------|----------|------------|
| Gmail rejected outbound from `tina@getwithme.com` | bounced `.eml` had `bh=z0Xb...` in DKIM header but body hashed to `bh=vJCS...` | CipherMail MIME rebuild after `:587` DKIM sign; `:10026` had `no_milters` so no re-sign |
| Inbound `dkim=fail` only when External Banner enabled | Same gmail→tina test: banner-on `dkim=fail`, banner-off `dkim=pass`. CipherMail held constant. | body_milter modifying body before the next milter hop saw it; primary OpenDKIM at `:10026` re-verified the modified body |
| Spam score ~+1.3 on banner-injected inbound | `DKIM_INVALID=0.1` + `NML_ADSP_CUSTOM_MED=0.9` when banner on; `DKIM_VALID*=-0.3` when banner off | amavis runs its own SpamAssassin DKIM check on the post-body-milter body. **Not fixed by multi-instance OpenDKIM** — separate problem |
| Downstream forwarder DMARC fail | Recipient forwards to gmail; gmail re-verifies original sender DKIM against modified body → fail | Solved by ARC sealing (#229) |

---

## Open follow-ups that touch this flow

- **#228** External Sender Banner re-enable — blocked on this diagram's
  `:10026` sign-only wiring landing.
- **#229** ARC sealing at perimeter — required so downstream forwarders trust
  Hermes' original-sender verdict.
- **amavis SpamAssassin DKIM scoring** (separate issue, not yet filed) —
  options A/B/C documented in the #232 handoff doc.
- **Dead-weight config-file audit** — `Docker/postfix_dkim/config/`,
  `Docker/mail_filter/config/`, `Docker/opendmarc/config/` are shadowed by
  volume mounts at runtime; ~85 files to consolidate or relocate.
- **Install-template drift** — `config/hermes/opt/hermes/conf_files/master.cf`
  and `Docker/common/opt/hermes/conf_files/master.cf` still have the
  pre-#232 `no_milters` token on `:10026` and `smtpd_milters=:8891` for
  `:10026`. Fresh installs would regress until these templates are
  brought into line with the active runtime config.
