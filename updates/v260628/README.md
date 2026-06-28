# Hermes SEG v260628

> **Maintenance + feature release.** Headline change: **Let's Encrypt / ACME
> certificate management is now available in Community Edition** — automated
> issuance and renewal are no longer Pro-gated. Plus documentation refinements
> and a published project changelog. No schema changes; no mandatory action for
> existing installs.

This release follows [v260612](../v260612/README.md), the initial public Docker
release. It is a small, low-risk update — primarily an edition-gating change for
Let's Encrypt and a batch of documentation improvements.

## What's new

### Let's Encrypt / ACME is now Community (#282)

The entire Let's Encrypt / ACME certificate gate has moved to **all editions**:

- **System Certificates → Request ACME Certificate** — issue and auto-renew a free
  Let's Encrypt certificate for the console / mail host. Previously Pro-only.
- **Email Server → Domains → Auto-managed (Let's Encrypt)** — per-mailbox-domain
  SAN certificates with automatic DNS/IP validation, issuance, and renewal.
  Previously Pro-only.

Free, automated TLS is table-stakes for a self-hosted mail platform, so it now ships
to everyone. The certbot engine, SAN validator, and SMTP-SNI generator all run on
Community. The manual CSR + import path remains for those who prefer a commercial CA.

**Existing Pro installations are unaffected** — they already had this functionality;
nothing is removed or downgraded.

### Documentation & housekeeping

- Added [`CHANGELOG.md`](../../CHANGELOG.md) in Keep a Changelog format.
- README refinements: corrected container count, refreshed hero descriptor and the
  Link Guard row, removed the Pro pricing badge.
- Get-started guide: added admin-email review, Antispam Maintenance (Pyzor / Razor /
  Bayes), Barracuda registration, and CipherMail console-password steps.
- Fixed the System Users edit-modal Access-Control-Policy documentation link.

## Upgrading

This is a **drop-in update** — there are no schema changes and no new containers.

- **Docker (git-based, e.g. Test):** `git fetch && git reset --hard <tag>` then redeploy
  the web files, or run the standard update orchestrator
  (`scripts/system_update_docker.sh`).
- **Pro Edition:** the Pro template fingerprint changed in this release (two
  fingerprinted templates were edited for the ACME gating). The validation server's
  manifest for v260628 has been published, so upgrading Pro boxes validate normally —
  **no action required**. Boxes that stay on v260612 also continue to validate against
  their existing manifest.

## Edition matrix (certificates)

| Capability | Community | Pro |
| --- | :---: | :---: |
| Import 3rd-party certificate / Generate CSR | ✅ | ✅ |
| **Request ACME (Let's Encrypt) — console cert** | ✅ *(new)* | ✅ |
| **Auto-managed SAN certs per mailbox domain** | ✅ *(new)* | ✅ |

---

*Issue: [#282](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/282).
For how Hermes is released and upgraded, see
[`docs/install/release-and-update-methodology.md`](../../docs/install/release-and-update-methodology.md).*
