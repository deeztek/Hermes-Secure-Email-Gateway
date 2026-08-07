# Hermes SEG v260807

First-run provisioning fixes. Every defect below has been present since the Docker
edition shipped, and each one is invisible on any gateway where an administrator
happened to save the relevant settings page.

## Read this first

### This upgrade clears your SpamAssassin Bayes database

Hermes has been shipping a pre-trained Bayes corpus in the repository: roughly 470
spam and 540 ham messages trained on unrelated mail between 2020 and 2025. Every
install has been scoring your mail partly against that foreign training.

SpamAssassin merges all learning into a single token store, so anything you trained
locally is inseparable from the shipped data. There is no way to remove one and keep
the other. **The upgrade clears the database once**, and your gateway relearns from
its own traffic.

You do not need to do anything. Mail filtering continues via the rule set, RBLs,
ClamAV and the malware feeds. Bayes contributes no score until it has learned roughly
200 spam and 200 ham, which you build with **Train as Spam** and **Train as Ham** in
Quarantine and Message History.

This applies even if you have trained the gateway yourself. A corpus that contains
the seeded data is not worth keeping at any ratio, and there is no way to separate
the two, so the database is cleared outright rather than preserved in a compromised
state. Restoring a backup of it afterwards would reintroduce the foreign training
permanently: the upgrade records the clearing as done, so nothing would ever remove
it again.

### Amavis quarantine directories were never created

The installer creates the quarantine root but not the five subdirectories that
`50-user` writes to: `clean`, `virus`, `spam`, `banned` and `bad_header`. Whether this
surfaces depends on your quarantine configuration. When it does, Amavis rejects mail
outright because it has nowhere to write. The upgrade creates all five and corrects
their ownership.

### Mailbox encryption was switched on against empty keys

The installer wrote a Dovecot configuration that enabled mailbox encryption
regardless of the database setting, which defaults to off, pointing at empty
placeholder key files. On affected gateways this breaks IMAP and SMTP
authentication. The upgrade re-renders the configuration from your database, so
whatever you actually chose is what you get.

### Collaborative spam checks are now opt-in

Razor, Pyzor and DCC each transmit a digest of every scanned message to a third-party
network. That is a decision for the operator, so new installs now ship with them
disabled.

**Your existing settings are not changed by this upgrade.** If you had them enabled,
they stay enabled. Two things are worth knowing:

- **Razor has never been registered on any Hermes install**, so it has been returning
  no result whether or not it was switched on. Register it once under
  **Content Checks > Antispam Maintenance > Initialize Razor**.
- **DCC is no longer in the published image.** Its licence is free only to
  organisations that do not sell filtering devices or services except to their own
  users, and it does not permit redistributing binaries. Most self-hosted operators
  qualify; we sell Hermes Pro and do not, so we cannot ship it on your behalf.
  `docker-compose.yml` now carries a commented build block that rebuilds the mail
  filter with DCC included, fetching it from Rhyolite directly.

### Nextcloud Mail was not provisioned when Nextcloud was enabled after the fact

Enabling Nextcloud on a mailbox that was created without it provisioned the account
and `/nc` access, but never the Mail profile, and the failure was silently discarded.
Affected users get a working Nextcloud login with an empty Mail app.

The upgrade repairs affected mailboxes automatically. **If you configured an account
in Nextcloud Mail by hand to work around this, delete it first.** A hand-made account
looks like a working one, so the repair will skip that mailbox.

### Nextcloud rejected the console address on fresh installs

The trusted-domain list was written comma-separated where Nextcloud expects it space
separated, producing one unusable entry. Reaching the console by IP, which is what the
installer configures before DNS exists, returned "Access through untrusted domain".
The upgrade re-renders it.

## What to do

```bash
cd <install-root>
sudo ./scripts/system_update_docker.sh
```

Nothing else is required. The upgrade re-renders the affected configuration from your
database, creates the missing directories, corrects ownership, and runs the two
one-time repairs.

## How to confirm it worked

```bash
# Quarantine directories exist and belong to amavis
docker exec hermes_mail_filter ls -ln /mnt/data/amavis

# SpamAssassin configuration has no unsubstituted placeholders
docker exec hermes_mail_filter grep -c 'USE-' /etc/spamassassin/local.cf   # expect 0

# Bayes has been reset and is ready to learn
docker exec hermes_mail_filter sa-learn --dump magic | grep -E 'nspam|nham'

# Nextcloud trusts your console address as its own entry
docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:get trusted_domains
```

Mailbox encryption should be absent from the Dovecot configuration unless you enabled
it under **Email Server > Settings**:

```bash
grep crypt_write_algorithm config/dovecot-2.4/conf/dovecot.conf
```

## Why it happened

The installer renders Dovecot and SpamAssassin configuration **before the database
exists**, so it can only mirror the seeded defaults. Where it wrote something the
database disagreed with, the file stayed wrong until an administrator saved the
relevant settings page, at which point the application layer silently corrected it.
Any gateway that had ever been configured through the console looked healthy.

Fresh installs are tested, but that testing verified containers were running and the
database was populated. It never authenticated to IMAP or pushed a message through
Amavis, so every one of these defects sat in the gap between those two things.

The quarantine directories and the ownership pass both existed in the pre-Docker
installer and were dropped during the Docker rewrite.

## What changed

- `scripts/install_hermes_docker.sh`: trusted-domain list is space separated; mailbox
  encryption mirrors the database default; SpamAssassin configuration is rendered
  rather than copied; the five quarantine subdirectories are created; new
  post-container ownership pass for the quarantine tier and the Bayes corpus.
- `config/database/hermes_install.sql`: network checks and Bayes auto-learning seed
  disabled for new installs; both v260807 repairs pre-seeded as complete so a fresh
  install never runs them.
- `schedule/post_upgrade.cfm`: idempotent config re-renders that run on every upgrade,
  plus the two one-time repairs.
- `inc/edit_mailbox_action.cfm`: Nextcloud Mail is provisioned with a purpose-minted
  system app password instead of the account's login password, which Dovecot could
  never have accepted. Provisioning failures are now reported instead of discarded, and
  saving a mailbox again is a valid repair.
- `Docker/mail_filter`: DCC moved behind a build argument and removed from the
  published image.
- Documentation: getting started and antispam settings pages rewritten around what a
  fresh install actually looks like.

## Known follow-up

- Bayes needs roughly 200 spam and 200 ham before it contributes any score. On a quiet
  gateway that takes a while. This is SpamAssassin's own safety threshold.
- Automatic Bayes learning stays off by default. It trains on the rule set's verdicts,
  so it reinforces their mistakes as readily as their successes.
