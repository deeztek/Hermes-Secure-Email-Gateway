# Hermes SEG v261123

> **Security update: upgrade soon.** This release rebuilds the container
> images with the latest operating system security updates, including fixes
> for the web server and for Java, and moves Nextcloud to a release with
> patched PHP. There are no feature or configuration changes.

## Synopsis

Images-only security update on top of v261115. Every image is rebuilt with
current security updates. Notable fixes:

- **Web server (nginx):** the fixes from the nginx security release of
  2026-11-18. The default Hermes configuration does not enable HTTP/2, so the
  critical HTTP/2 issues do not apply to it; a denial-of-service issue in the
  same release does.
- **Java (OpenJDK 21 and 11)**, used by the admin console and CipherMail: the
  fixes from the OpenJDK security advisory of 2026-11-17 (#420).
- **Nextcloud 34.0.6** (from 34.0.5), which ships PHP 8.5.13 with the PHP
  security fixes of 2026-11-19. Installs still on Nextcloud 33 move to
  33.0.11 (PHP 8.4.28).

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
- The upgrade raises `NCVERSION` in your `.env` to the patched Nextcloud point
  release of the major you run (a copy of the old file is kept as
  `.env.pre-v261123`) and runs the Nextcloud upgrade step.
