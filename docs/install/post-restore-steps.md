# Post-Restore Steps

Run after `scripts/system_restore.sh` completes. The restore replaces databases,
LDAP, and the storage tiers, but a few things must be reconciled **by hand**
depending on whether you restored onto the **same host** or a **different host**
(cross-host disaster recovery). The restore script prints a pointer to this page
at the end of its run.

## Same-host restore

You restored a backup onto the **same** machine it came from (e.g. rolling back).

1. **Log into the admin console** — `https://<console-host>/admin/`.
2. **Verify mail flow** — send and receive a test message.
3. **Check the log** — `install-logs/system_restore_*.log` for any `WARN` lines.

Nothing else is usually required: `.env`, `creds/`, and host identity already
match this machine.

## Cross-host restore (restore to new hardware)

You restored a backup taken on host **A** onto a different host **B** (DR to new
hardware, migration, etc.). The restored data carries host A's identity and
credentials, so **B serves A's configuration until you reconcile it**. Do these
in order:

### 1. Rewire host identity — `system_rehost.sh` (REQUIRED)

The restored `.env`, `parameters2` rows, nginx vhost, Authelia cookie domain, and
Postfix hostname all reference host A. Until you rewire them, the console is
**unreachable** at host B's address.

```bash
sudo /opt/hermes-seg/scripts/system_rehost.sh
```

It auto-detects this host's IP/hostname (pass `--to-hostname=` / `--to-ip=` to
override) and rewrites identity across `.env`, the database, and the rendered
configs. See `system_rehost.sh --help`. The restore script prints this reminder
automatically when it detects a host-identity mismatch.

> **Note:** `system_rehost.sh` also reconciles cross-host DB credentials for
> Nextcloud (its `config.php` rides in the restored data tier). All other
> services use install-generated configs that hold this host's credentials.

### 2. Re-activate the Pro license

Hermes **Pro** licenses are bound to a hardware-derived UUID. On new hardware the
UUID changes, so the license reads `INVALID` / `VIOLATION` on the next validation
and the console drops to **Community Edition**.

- Re-activate the license, or contact Hermes support to re-bind your serial to
  this host.
- **Community Edition installs are unaffected.**

### 3. Re-save Content Checks (re-apply the milter chain)

`smtpd_milters` (the DKIM / DMARC / ARC / SPF milter chain) is **not** restored —
it is dynamic config applied by the Content Checks settings pages, not part of the
restored `main.cf`. After a cross-host restore the database still records which
checks are enabled, but the live Postfix config does not reflect them, so
**outbound mail is not DKIM-signed and inbound is not DMARC/ARC-checked** until you
re-apply them.

For each **enabled** Content Checks page, open it in the admin console and click
**Save** (no changes needed) to re-apply its Postfix config:

- Content Checks → **DKIM**
- Content Checks → **DMARC**
- Content Checks → **SPF**
- Content Checks → **ARC** (if used)

Verify afterward:

```bash
docker exec hermes_postfix_dkim postconf smtpd_milters
```

It should list the milter sockets (e.g. `inet:hermes_dmarc:54321`, OpenDKIM,
OpenARC, body_milter), not be empty.

> This re-save step is an interim workaround. Automatic re-application of the
> milter chain on restore is tracked as a follow-up enhancement
> ([#268](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/268)).

### 4. Clear Nextcloud maintenance mode (if needed)

The restore clears it automatically, but if Nextcloud still shows maintenance mode:

```bash
docker exec -u www-data hermes_nextcloud php occ maintenance:mode --off
```

### 5. Verify

- Admin console login at host B's address.
- Mail flow (send + receive).
- Nextcloud login.
- `docker exec hermes_postfix_dkim postconf smtpd_milters` is populated (step 3).

## Health check

After either path, run the smoke test to confirm container health, per-service DB
authentication, and the mail chain:

```bash
bash /opt/hermes-seg/scripts/hermes_smoke_test.sh
```

A `WARN` on `smtpd_milters is empty` after a cross-host restore is the symptom that
step 3 has not been completed yet.
