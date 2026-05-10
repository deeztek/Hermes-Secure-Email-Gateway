# Handoff: Multi-instance OpenDKIM (#232)

Session date: 2026-05-10. Picking this up next session — read this first, then check #232 on GitHub for the diagnostic trail.

## What's decided and locked in

- **Outbound `:10026` fix** (`no_milters` token removed from `master.cf`) is **validated on DEV and ready in git**. Sign-after-CipherMail at the re-injection port works. Confirmed via Gmail accepting reply-to-banner outbound from tina@getwithme.com after today's fix.
- **SQL `order1` fix** (body_milter from 0.5 → 3.1 in `smtpd_milters` and `non_smtpd_milters` parameters) is **applied to DEV and committed**. Schema migration file includes both the corrected INSERT (3.1 for fresh installs) and an idempotent UPDATE retro-fix for existing installs.
- **Multi-instance OpenDKIM is the chosen path** for the inbound `dkim=fail` issue at `:10026`. We exhaustively researched alternatives (per-port mode in OpenDKIM, MTA macro + InternalHosts, ExternalIgnoreList, PeerList, etc.) — none can suppress verification while allowing signing on the same port. Confirmed via OpenDKIM's own project recommendation in their support thread, plus Perplexity's analysis.
- **Body banner stays disabled on inbound** until the architecture is fully resolved. Toggling it back ON re-introduces the inbound `dkim=fail` cascade.

## What's done in git

Three commits today:
1. `master.cf`: removed `no_milters` token at `:10026` to enable OpenDKIM signing post-CipherMail
2. `schema_updates.sql`: corrected `order1` for body_milter from 0.5 to 3.1 + added idempotent retro-fix UPDATE for existing installs
3. New `opendkim-sign.conf`: skeleton config for the sign-only secondary OpenDKIM instance (Mode=s, socket :8892). **NOT YET WIRED UP** — see "Pick up here" below.

## Pick up here — wire up the multi-instance OpenDKIM

Three files to change to complete the multi-instance work:

### 1. `Docker/postfix_dkim/entrypoints/postfix_dkim/entrypoint.sh`

After the existing `service opendkim start` line, launch the second instance:

```bash
echo "Starting OpenDKIM (sign-only secondary instance for :10026)"
/usr/sbin/opendkim -x /etc/opendkim-sign.conf
```

Verify the binary path matches the container — `which opendkim` should be `/usr/sbin/opendkim` based on the apt package layout. The `-x` flag tells OpenDKIM to use a non-default config file.

### 2. `docker-compose.yml`

In the `hermes_postfix_dkim` service's `volumes:` section, add:

```yaml
- ./config/postfix-dkim/etc/opendkim-sign.conf:/etc/opendkim-sign.conf
```

Pattern matches the existing `opendkim.conf` mount style (single-file mount).

### 3. `config/postfix-dkim/etc/postfix/master.cf`

On the `:10026` service definition, change the milter port from 8891 to 8892:

```diff
-            -o smtpd_milters=inet:localhost:8891
+            -o smtpd_milters=inet:localhost:8892
```

This points `:10026` at the new sign-only OpenDKIM instance instead of the primary verifying instance.

### Image rebuild required

Entrypoint changes are baked into the image (only entrypoint.sh has a `COPY` directive in the Dockerfile per today's audit — `master.cf` and `opendkim.conf` are volume-mounted and live-editable). So:

1. Build new `hermes-postfix-dkim` image with version tag `v260119-dkim-fix` (or whatever scheme you prefer)
2. Push to `hub.deeztek.com/dedwards/hermes-seg-docker-gl/hermes-postfix-dkim:v260119-dkim-fix`
3. On DEV: `docker compose pull hermes_postfix_dkim && docker compose up -d hermes_postfix_dkim`
4. Validate (test plan below)
5. If clean, tag as `latest` and push

## Test plan after multi-instance is wired up

1. **Both OpenDKIM processes running:**
   ```bash
   docker exec hermes_postfix_dkim ps aux | grep opendkim
   ```
   Expect two processes — primary (port 8891) and sign-only (port 8892).

2. **Sign-only instance listening:**
   ```bash
   docker exec hermes_postfix_dkim ss -tlnp | grep 889
   ```
   Both `127.0.0.1:8891` and `127.0.0.1:8892` should be listening.

3. **`:10026` master.cf points to new milter:**
   ```bash
   docker exec hermes_postfix_dkim postconf -M | grep "^10026" | grep -o "smtpd_milters=[^ ]*"
   ```
   Should show `inet:localhost:8892`.

4. **Re-enable External Banner for getwithme.com via admin UI** (was disabled during today's diagnostic).

5. **Inbound test** — send fresh mail from your personal Gmail → `tina@getwithme.com`. View source. Expected:
   - Banner injected at top of body
   - `Authentication-Results: ... dkim=pass` (was `dkim=fail` before this work). May not have an explicit `dkim=` line if the `:25` Auth-Results was stripped by cleanup before re-injection — that's also acceptable (no claim is better than a wrong claim).

6. **Outbound regression** — reply to a banner-bearing inbound from tina (sig + disclaimer ON) → `ru2n4m@gmail.com`. Should pass DKIM at Gmail (validation already done today; this just confirms the multi-instance change didn't regress).

7. **Outbound submission test from another local mailbox** (any local user → external) — confirms primary OpenDKIM still signs at submission.

If 1-7 all pass, multi-instance work is complete. Commit final wiring + image rebuild + push, then unblock #228 banner re-enable.

## What's STILL not addressed (separate problems)

The multi-instance OpenDKIM only fixes the **visible Authentication-Results header** on inbound. Two related problems remain unaddressed:

### Amavis SpamAssassin DKIM scoring

`amavis` runs SpamAssassin AFTER body_milter modification. SpamAssassin does its own DKIM verification on the body it sees (the modified one). For banner-injected inbound, SpamAssassin scores `DKIM_INVALID=+0.1` and triggers `NML_ADSP_CUSTOM_MED=+0.9` instead of the `DKIM_VALID*` rules (-0.3 total). **Net ~1.3 spam-score point penalty per banner-injected message.** Borderline messages may flip to spam.

Multi-instance OpenDKIM does NOT fix this — the problem is inside amavis's own SpamAssassin instance, not OpenDKIM.

Real options:
- **A**: restructure pipeline so body_milter runs AFTER amavis (new postfix re-injection port between amavis and CipherMail; body_milter wired to that port; amavis re-injects there instead of forwarding to CipherMail directly)
- **B**: configure SpamAssassin to skip its DKIM check rules (loses spam-protection signal generally)
- **C**: bump spam thresholds to compensate (~+1.3 to all thresholds)

Option A is architecturally clean but a real surgery. Option B/C are hacks. File as separate issue when you decide.

### Downstream forwarding (#229 ARC)

When tina forwards a Hermes-modified inbound to another DMARC-strict gateway (e.g., gmail account she uses as backup), the downstream verifier re-checks gmail's original DKIM signature against the (modified) body and gets `dkim=fail`. DMARC alignment via DKIM fails. SPF alignment may save delivery if forwarding doesn't break SPF chain (often does).

The fix is ARC sealing (#229) — record the original verdict cryptographically at Hermes' perimeter so downstream forwarders can trust it.

#229 is filed and should be elevated to a release blocker for the same window as #228 banner re-enable.

## Other followups noted today

- **getwithme.com SPF DNS** — domain has TWO SPF records (`v=spf1 include:mx.ovh.ca ~all` and `v=spf1 mx a a:smtp-dev.deeztek.com ~all`). Per RFC 7208 only one is allowed. Gmail's SPF result flips between `pass` and `softfail` depending on which record it resolves first. Consolidate into one. This is DNS-side cleanup, not Hermes.

- **Dead-weight Docker/ config files** — audit found ~85 files in `Docker/postfix_dkim/config/`, `Docker/mail_filter/config/`, `Docker/opendmarc/config/` that are never used at runtime (volume mounts shadow them, Dockerfile COPY is commented out or absent). Followup cleanup: delete or relocate to a `templates/` directory that install scripts can reference unambiguously. See research output from the dead-weight audit agent in this session for the full list.

- **Source-of-truth consolidation for postfix configs** — three places where postfix config currently lives: `config/postfix-dkim/etc/postfix/` (active, volume-mounted), `Docker/postfix_dkim/config/postfix-dkim/etc/postfix/` (dead weight per audit), `config/hermes/opt/hermes/conf_files/` (install templates referenced by `generate_postfix_configuration.cfm` for `main.cf.HERMES`). Decision: `config/postfix-dkim/.../master.cf` is the source of truth for master.cf; main.cf is generated from `conf_files/main.cf.HERMES` template + parameters DB table. Documented in #232 history but not yet implemented as a cleanup commit.

## Reference: forensic proof captured today

If anyone questions the diagnostics, the receipts:

- **CipherMail body mutation** — bounced outbound message `.eml` had `bh=z0XbXxEYIysWky3tSjcgZntyM6pn+X3xQvoRlUlt5M4=` in the DKIM signature header but body bytes computed to `bh=vJCSPksfS3zPZBz5evXCAn05rNxEaGNGnanUEoE4jBY=`. Different hashes = body was mutated between OpenDKIM signing at `:587` and SMTP egress to Gmail.

- **body_milter = root cause of inbound dkim=fail** — same gmail → tina test ran twice today: with banner enabled showed `dkim=fail`; with banner disabled showed `dkim=pass`. CipherMail and other components held constant. Only variable: body_milter modifying the body.

- **amavis SpamAssassin scoring impact** — confirmed via comparing X-Spam-Status headers between banner-enabled and banner-disabled tests. Banner-enabled showed `DKIM_INVALID=0.1` + `NML_ADSP_CUSTOM_MED=0.9`; banner-disabled showed `DKIM_VALID=-0.1` + `DKIM_VALID_AU=-0.1` + `DKIM_VALID_EF=-0.1`. ~1.3 point delta.

## Files touched today

In this commit (DKIM #232 work):
- `config/postfix-dkim/etc/postfix/master.cf` — `no_milters` token removed from `:10026`
- `updates/hermes-260119/sql/schema_updates.sql` — body_milter `order1` 0.5 → 3.1 + retro-fix UPDATE
- `config/postfix-dkim/etc/opendkim-sign.conf` — NEW, sign-only OpenDKIM config (not yet wired up)
- `RELEASE-NOTES.md` — entry for today's outbound DKIM fix
- `docs/handoff-#232-multi-instance-opendkim.md` — this doc

NOT in this commit (still uncommitted, related to #228 banner work which is blocked):
- `Docker/body_milter/config/usr/local/bin/hermes-body-milter` (base64 fix)
- `Docker/body_milter/entrypoints/body_milter/entrypoint.sh` (banner dir creation)
- `config/hermes/var/www/html/admin/2/inc/main_sidebar.cfm`
- `config/hermes/var/www/html/admin/2/edit_external_banner.cfm` and other `external_banner_*.cfm` files
- `config/hermes/var/www/html/admin/2/inc/external_banner_templates/`
- `config/body_milter/etc/hermes/body_milter/banners/`
- `external_banners` table schema in `schema_updates.sql` (after the position where the #232 retro-fix UPDATE is)

These stay uncommitted until the architecture decisions resolve.

## DEV state at handoff

- Outbound `:10026` no_milters removed → live on DEV
- SQL UPDATE for body_milter order1 → applied to DEV's parameters table; main.cf regenerated
- External Banner for getwithme.com → DISABLED via admin UI (do not re-enable until multi-instance OpenDKIM ships)
- Body milter container → running with the base64 fix loaded (uncommitted code)
- All other features per pre-session state
