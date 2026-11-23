# Hermes SEG v261123

> **Security update: upgrade soon.** This release rebuilds the container
> images with the latest operating system security updates, including fixes
> for the web server and for Java. There are no feature or configuration
> changes.

## Synopsis

Images-only security update on top of v261115. Every image is rebuilt with
current security updates. Notable fixes:

- **Web server (nginx):** the fixes from the nginx security release of
  2026-11-18. The default Hermes configuration does not enable HTTP/2, so the
  critical HTTP/2 issues do not apply to it; a denial-of-service issue in the
  same release does.
- **Java (OpenJDK 21 and 11)**, used by the admin console and CipherMail: the
  fixes from the OpenJDK security advisory of 2026-11-17 (#420).

## Bug fixes

- **The admin console and CipherMail images shipped an OpenJDK version
  affected by the 2026-11-17 advisory.** (#420)

## Upgrading

Back up first, then run the standard upgrade:

```bash
sudo ./scripts/system_update_docker.sh v261123
```

- Nothing behaves differently afterwards. Containers restart during the
  upgrade, so mail is briefly queued by the sending servers and retried.
