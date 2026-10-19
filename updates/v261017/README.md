# Hermes SEG v261017

## Synopsis

Upgrades no longer undo your settings. Until now, every upgrade put a set of
admin-managed settings back to their defaults (DNS Resolver overrides, DMARC,
banners, the IPS whitelist, antispam and antivirus settings and more) until
each page was saved again. This release keeps them. Link Guard (Pro) also
gets improved detection and can show where any protected link really goes.
Upgrade recommended for all installs.

**This release needs Docker Engine 25.0 or newer.** See Upgrading.

## New features

- **Improved Link Guard detection (Pro).** Link Guard catches more phishing
  links.
- **Decode a link (Pro).** A new card on the Link Guard page: paste a
  protected link from an email, even one wrapped by another mail scanner, to
  see the original address it leads to. Nothing is fetched, and expired links
  can still be decoded. A **Check this URL** button then shows how Link Guard
  treats it.
- **Refresh feeds now (Pro).** The Link Guard page can pull the URLhaus and
  OpenPhish lists immediately instead of waiting for the refresh interval.

## Bug fixes

### All installs

- **Upgrades reset admin settings to their defaults.** Affected: DNS Resolver
  local records and forwarders, DMARC Settings, external banners, disclaimers
  and signatures, IPS (including the whitelist), Antispam and Antivirus
  Settings, malware feeds, ARC, DKIM and SPF settings, Dovecot, scheduled
  tasks, `security.conf` and the LDAP configuration. They are now kept,
  starting with this upgrade. If a release has to change one of these files
  in the same place you did, the release's version is kept and the upgrade
  log names the page to save again (#361).
- **The LDAP health check wrote about 60,000 log lines a day** into the
  System Logs database. It now runs every minute instead of every 10 seconds,
  without slowing startup (#367).
- **Releasing a message from a quarantine notification showed both "Message
  Released" and "Release Failed".** The message was released; the error came
  from displaying the sender's address afterwards. The page now shows only
  the real outcome.
- **The release link in a quarantine notification released the message as
  soon as it was opened.** Mail-security services in front of some mailboxes
  open links in incoming mail automatically to scan them, which could release
  a message nobody chose to release. The link now shows the message's subject
  and sender with a **Release message** button; only the button releases it.
- **Pro features could stay off after a one-time license check failure
  (Pro).** A single failed license check turns off Link Guard, disclaimers
  and organizational signatures, and they stayed off even after the next
  check succeeded, until each page was saved again. They now come back by
  themselves on the next successful check, including on installs where this
  already happened.
- **A quarantine notification could offer a release link for a message that
  was never kept.** Some blocked messages (for example spam from your own
  network scoring far above the threshold) are dropped without a quarantine
  copy; the link then wrongly said "Already Released". Those messages no
  longer get a notification, and an older link says the message was not
  kept.
- **Upgrades did not clean up old Postfix, mail filter and body milter
  images.** The image cleanup added in an earlier release missed these three,
  so they kept a copy for every release. This upgrade removes all but the
  newest two (#340).
- **Telemetry improvements.** Reports now go to a dedicated server,
  `telemetry.hermesseg.io`. A report that cannot be sent is written to the
  Hermes log, the report file is always deleted afterwards, and the domain
  count in the report is corrected. The System Settings page, the
  documentation and the installer's final summary now say exactly what is
  sent and how to turn it off.
- **The mail filter's daily maintenance logged "cannot write to
  .../bayes_journal: Permission denied".** Spam filtering and learning were
  not affected; the maintenance job can now do its part (#357).
- **The Dovecot container replayed old log lines at every start,** so errors
  from days earlier appeared in `docker logs` as if they had just happened
  (#315).
- **OpenDMARC and the mail filter logged an rsyslog parsing warning at
  startup.** Their log lines were reaching System Logs regardless (#365).
- **RBL Configuration now points to where a trusted server is exempted.**
  The legacy "RBL whitelist" (IP & Network Override) lives on as **Network
  Block/Allow**; the RBL page now says so and links to it.
- The unused quarantine digest pages, replaced by real-time quarantine
  notifications in an earlier release, are removed (#180).

### Installs migrated from legacy

- **Old portal password data is removed.** The legacy version stored each
  user's portal password as a hash, along with password-reset codes, in a
  table Hermes no longer uses. The upgrade deletes those columns, so they no
  longer sit in the database and its backups.

## Upgrading

**Before.** Check your Docker version:

```bash
docker version --format '{{.Server.Version}}'
```

If it is below 25.0, upgrade Docker first. If you upgrade Hermes anyway, the
update stops before changing any container and asks you to upgrade Docker;
run it again afterwards.

Take a backup or snapshot.

**Upgrade.** Run from your Hermes install directory
(`/opt/Hermes-Secure-Email-Gateway` here; replace it with your own if you
cloned elsewhere):

```bash
cd /opt/Hermes-Secure-Email-Gateway
sudo ./scripts/system_update_docker.sh v261017
```

**After.** Nothing to re-save. The upgrade log has a **Restore admin-owned
settings** section: if it lists a file as kept at the release default, save
the page it names once.

**Link Guard (Pro), only if it applies to you:** with **Follow redirects**
on, Link Guard now opens each link's page once while checking it, the way
other link scanners do. If users report that a one-time link (a password
reset or sign-in link) says it was already used, add that sender's domain to
the Link Guard allowlist.
