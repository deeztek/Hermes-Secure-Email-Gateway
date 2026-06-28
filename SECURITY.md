# Security Policy

Hermes Secure Email Gateway is a security product, and we take vulnerabilities in
it seriously. Thank you for helping keep Hermes and its users safe.

## Supported versions

Hermes uses calendar versioning (`vYYMMDD`). Security fixes are issued against the
**most recent published release**. Older releases are not maintained — if you are
running an older version, upgrade to the latest before reporting, where practical.

| Version | Supported |
| --- | :---: |
| Latest published [release](https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases) | ✅ |
| Any older release | ❌ (upgrade first) |

## Reporting a vulnerability

**Please do _not_ open a public GitHub issue for security vulnerabilities.** Public
issues are visible to everyone, including potential attackers, before a fix is
available.

Instead, report privately through either channel:

- **GitHub private vulnerability reporting** (preferred): use the **"Report a
  vulnerability"** button under this repository's **Security** tab. This opens a
  private advisory visible only to the maintainers.
- **Email:** <support@deeztek.com> with a subject line beginning `SECURITY:`.

Please include, where you can:

- A description of the vulnerability and its impact.
- The affected version(s) and component/container.
- Step-by-step reproduction (proof-of-concept if available).
- Any suggested remediation.

## What to expect

- **Acknowledgement** of your report, typically within **3 business days**.
- An assessment and, for confirmed issues, a remediation plan with a target
  timeline.
- **Coordinated disclosure:** we will work with you on timing and will credit you
  in the release notes / advisory unless you prefer to remain anonymous.

## Scope

This policy covers the Hermes Secure Email Gateway code in this repository. Bundled
third-party components (e.g. Postfix, Dovecot, Amavis, ClamAV, Lucee, Nextcloud,
Authelia) should be reported to their respective upstream projects; if a Hermes
default configuration exposes such a component insecurely, that **is** in scope.

## Non-vulnerability bugs

For ordinary bugs and feature requests (no security impact), please use
[GitHub Issues](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues).
