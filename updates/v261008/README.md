# Hermes SEG v261008

Fixes and hardening. Upgrade recommended.

- **Intrusion Prevention now blocks banned addresses on hosts using nftables.**
  On those hosts, bans were not being applied.
- **Quota warnings, ban logging and the user portal's breached-password check
  work on fresh installations.** Internal notifications no longer depend on API
  tokens, which fresh installations never had (#349).
- **Releasing and downloading quarantined messages from the user portal works.**
- Further hardening in the user portal and password reset.

The breached-password check on portal password changes now runs whenever the
user leaves it enabled. Previously it was silently skipped on most installations.

## Upgrading

```bash
cd /path/to/your/hermes/install
sudo ./scripts/system_update_docker.sh v261008
```

Take a backup or snapshot first. No manual steps.

The upgrade recreates the mail server and Intrusion Prevention containers. Mail
clients reconnect on their own.
