# Hermes SEG v261006

Security release. Upgrade as soon as possible.

Fixes a critical vulnerability affecting v260929 and earlier.
See advisory [GHSA-4p63-cq8w-q87g](https://github.com/deeztek/Hermes-Secure-Email-Gateway/security/advisories/GHSA-4p63-cq8w-q87g).

## Upgrading

```bash
cd /path/to/your/hermes/install
sudo ./scripts/system_update_docker.sh v261006
```

Take a backup or snapshot first. No manual steps.

The upgrade edits the web server configuration in place and keeps a copy of
the original under `config/nginx/etc/nginx/`.
