# v261017 manual checks

## Before upgrading (upgrade VM only)

Change these so the upgrade has something to keep (#361):

| Page | Set |
| --- | --- |
| System > DNS Resolver | a local record `survive-test.example.invalid` -> `10.9.9.9`, Apply |
| Content Checks > DMARC Settings | flip **Failure Reports**, Save & Apply |
| System > IPS | add `203.0.113.77` to the whitelist, save |
| Content Checks > External Banner | enable a banner for one domain, save |

## After upgrading

| Check | Pass |
| --- | --- |
| The four settings above | `grep -c survive-test.example.invalid config/unbound/conf.d/local.conf` is 1+, `grep ^FailureReports config/opendmarc/etc/opendmarc/opendmarc.conf` shows the flipped value, `grep -c 203.0.113.77 config/fail2ban/config/fail2ban/jail.local` is 1+, the banner still appears on a test message (#361) |
| Live DNS, not just the file | `docker exec hermes_unbound drill @127.0.0.1 survive-test.example.invalid` answers `10.9.9.9` (#361) |
| Upgrade log, **Restore admin-owned settings** section | Lists restored/merged counts; none of the four files listed as kept at the release default (#361) |
| Upgrade log, Phase 6 (image cleanup) | Only the newest two releases' Hermes images remain: `docker images --format '{{.Repository}}:{{.Tag}}' \| grep hermes- \| sort` (#340) |
| SAN rebuild: delete one row from `mailbox_sans` (DBeaver or `docker exec hermes_db_server mariadb`), then `docker exec hermes_commandbox curl -s http://localhost:8888/schedule/acme_validate_ip.cfm` | The row is back (#319; needs a mailbox domain) |
| Link Guard: **Check a URL** with the in-page-redirect test link from the internal runbook | malicious / block, Decided by: Redirect destination |
| Link Guard: **Decode a link** with a protected link from a test message | Shows the original address |
| Link Guard: **Refresh feeds now** | "Feed refresh started"; two fresh `feed ... refreshed` lines in `docker logs hermes_linkguard` |
| Link Guard: click a link that redirects (e.g. a marketing click-tracking link) | Its Recent activity row's Detail reads `redirects to <host>` |
| `docker logs hermes_dmarc 2>&1 \| grep -c 'error during parsing'` after a restart | 0 (#365) |
| Sign in to the Hermes admin console and to `/ciphermail` | Both reach their dashboards |
| `sudo HERMES_TEST_HOST=1 tests/run.sh` | All releases' checks pass |

Then undo the four test settings.
