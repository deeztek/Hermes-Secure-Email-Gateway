# Hermes SEG v261022

## Synopsis

Security release. **Upgrade all installs as soon as possible.**

On October 21, 2026, CISA warned of critical vulnerabilities in PHP that
allow unauthenticated remote code execution on any PHP installation serving
web requests. In Hermes, PHP runs inside the bundled Nextcloud, which is
reachable from the internet at `/nc/` and handles requests before any sign-in.
This release moves Nextcloud to an image with the fixed PHP.

It also fixes Nextcloud on installs migrated from the legacy version, where
Nextcloud could not read its own database and cache credentials.

## Bug fixes

### All installs

- **Nextcloud runs on a PHP with the critical remote code execution fix.**
  Nextcloud 33 moves to 33.0.10 (PHP 8.4.27). Installs already on Nextcloud
  34 move to 34.0.5 (PHP 8.5.12). These are maintenance releases within the
  same Nextcloud version, upgraded automatically during the Hermes upgrade.

### Installs migrated from legacy

- **Nextcloud could not reach its database and cache.** The legacy migration
  made Nextcloud's credential files readable by root only, so Nextcloud failed
  as soon as its container was recreated (for example, creating a mailbox's
  Nextcloud account reported "NOAUTH Authentication required"). The upgrade
  makes those files readable again, and the migration no longer restricts
  them.

## Upgrading

**Before.** Take a backup or snapshot.

**Upgrade.** Run from your Hermes install directory
(`/opt/Hermes-Secure-Email-Gateway` here; replace it with your own if you
cloned elsewhere):

```bash
cd /opt/Hermes-Secure-Email-Gateway
sudo ./scripts/system_update_docker.sh v261022
```

The upgrade pulls the new Nextcloud image and runs Nextcloud's own upgrade
step. Nextcloud shows a maintenance page for a minute or two meanwhile.

**After.** Confirm the PHP version Nextcloud runs:

```bash
docker exec hermes_nextcloud php -v | head -1
```

It should report PHP 8.4.27 or later (Nextcloud 33) or PHP 8.5.12 or later
(Nextcloud 34). If Nextcloud's pages look broken in the browser afterwards,
force a full reload (Ctrl+Shift+R) to clear cached files.
