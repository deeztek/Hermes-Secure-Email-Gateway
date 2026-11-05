# Nextcloud File Scanning

Files uploaded to Nextcloud are scanned by the same ClamAV engine that scans
mail, including your [Malware Feeds](../04-content-checks/malware-feeds.md) and
[Hash Blocklist](../04-content-checks/attachment-hash-blocklist.md). This covers
the web interface, desktop and mobile clients, WebDAV, public share uploads and
Talk attachments. Hermes sets this up on install and on upgrade through the
Nextcloud **Antivirus for files** app.

## What happens to an infected file

| Situation | Result |
|---|---|
| Infected file uploaded | Refused and not stored |
| Infected file found in storage by the background scan | Logged and shown in the user's activity feed, or deleted if you choose that below |
| ClamAV unreachable, for example while the mail filter restarts | Uploads are refused until ClamAV is back, or accepted unscanned if you choose that below |

The background scan checks files that have not been scanned yet, and rescans
files every 28 days, so a file can be flagged later when new signatures arrive.

**Important:** saving **Antivirus Settings** restarts the mail filter, so uploads
fail for the short time that takes.

## Limits

- Files larger than the ClamAV **MaxFileSize** setting (25 MB by default) are not fully scanned. Large uploads are passed through in 25 MB pieces, so do not rely on this scan for large files.
- Password-protected archives can't be scanned.

## Change the settings

These settings are command-line only. `security.conf` is in the Hermes install
folder, for example `/opt/Hermes-Secure-Email-Gateway`.

1. SSH into the Docker host and go to the Hermes install folder.
2. Edit `config/hermes/opt/hermes/config/security.conf`:

   | Setting | Values | Default |
   |---|---|---|
   | `NEXTCLOUD_AV_INFECTED_ACTION` | `only_log` or `delete` | `only_log` |
   | `NEXTCLOUD_AV_BLOCK_UNREACHABLE` | `yes` or `no` | `yes` |

3. Apply the change. Unlike the other settings in this file, these do not take effect by themselves:

   ```bash
   bash config/hermes/opt/hermes/scripts/nextcloud_antivirus_apply.sh
   ```

**Important:** `delete` also removes a file on a false positive, and Nextcloud
does not ask first. ClamAV's third-party signatures are tuned for mail, so
review the logs under `only_log` before you switch to `delete`.

## Check that it works

Run this to send a test request to ClamAV from Nextcloud:

```bash
docker exec -u www-data hermes_nextcloud php /var/www/html/occ files_antivirus:test
```
