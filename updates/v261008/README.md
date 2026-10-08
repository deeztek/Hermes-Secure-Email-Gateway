# Hermes SEG v261008

## Synopsis

A fix release. Intrusion Prevention now blocks banned addresses on hosts that
use nftables, and quota warnings, ban logging and the breached-password check
work on fresh installations. Upgrade recommended.

## Bug fixes

- **Intrusion Prevention did not block banned addresses on hosts using
  nftables.** Bans were neither applied nor recorded.
- **Quota warnings, ban logging and the user portal's breached-password check
  did not work on fresh installations.** They depended on API tokens that fresh
  installations never had. They no longer need them (#349).
- **Releasing a quarantined message from the user portal failed.**
- **Downloading a message from the user portal left the page loading.**
- Hardening in the user portal and password reset.

## Upgrading

```bash
cd /path/to/your/hermes/install
sudo ./scripts/system_update_docker.sh v261008
```

Take a backup or snapshot first. No manual steps.

- The upgrade recreates the mail server and Intrusion Prevention containers.
  Mail clients reconnect on their own.
- The breached-password check on portal password changes now runs whenever the
  user leaves it enabled. It was previously skipped on most installations.
