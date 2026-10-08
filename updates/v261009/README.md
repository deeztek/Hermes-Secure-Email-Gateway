# Hermes SEG v261009

## Synopsis

A small fix release for the password reset page. Upgrade recommended.

## Bug fixes

- **The password reset page ran a browser-side breached-password check that
  could not complete.** It is removed; the server-side check, which rejects
  breached passwords, is unchanged (#350).

## Upgrading

```bash
cd /path/to/your/hermes/install
sudo ./scripts/system_update_docker.sh v261009
```

Take a backup or snapshot first. No manual steps.
