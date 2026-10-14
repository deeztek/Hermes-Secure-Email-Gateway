# Hermes SEG v261012

## Synopsis

A fix release. Most fixes affect **every install**: several admin pages could
not be saved, some mail was missing from Message History, and Global Sender
Rules "Allow" entries could defer mail. A few apply only to installs created
before this release or migrated from the legacy (non-Docker) version; those are
listed separately below. Upgrade recommended for all installs.

## New features

- **Messages Processed chart on the dashboard.** It is now a line chart with
  one line per message type, adds **Past 7, 14, 21 and 30 Days**, and
  counts every message in the period. It previously sampled at most the
  newest 10,000, so busy gateways saw `10,000+` and skewed proportions
  (#355).

## Bug fixes

### All installs

- **Messages with an emoji in the subject or sender name were missing from
  Message History.** The mail was delivered, but its record could not be
  stored. The upgrade converts two columns of the message log (#353).
- **Global Sender Rules "Allow" entries pointed at an address that only
  existed on the legacy single-server install,** so mail from an allowed
  sender could be deferred (and retried by the sender) instead of skipping
  the filters. Only installs with Allow entries are affected. The upgrade
  corrects existing entries and the live mail routing (#358).
- **Antispam Settings could not be saved.** Since v260807 the save failed with
  "There was an error running /usr/bin/spamassassin --lint" because the
  configuration still referred to DCC, which the standard image does not
  include (#352).
- **A rejected SpamAssassin configuration no longer replaces a working one.**
  If SpamAssassin refuses a change, the previous configuration is kept and the
  page shows SpamAssassin's own explanation. A message rule or score override
  it rejects is not saved (#352).
- **Message rules containing non-ASCII characters were written incorrectly,**
  which made SpamAssassin reject them (#352).
- **Editing a body-type message rule failed** with "key [EDIT_HEADER] doesn't
  exist" (#352).
- **Saving DKIM Settings could end on "the Postfix mail system is not
  running".** The settings were saved, but Postfix kept its previous
  configuration until reloaded (#351).
- **The dashboard's shorter Messages Processed periods showed the wrong time
  window,** several hours in the past depending on the server's time zone, so
  recent mail often appeared as none (#355).
- **Mailbox domain names could be left off certificates** after an earlier
  upgrade's cleanup removed them. The scheduled certificate check now rebuilds
  that list before it runs (#319).
- **Deleting a mailbox domain is refused while it still has aliases.**
  Leftover aliases came back to life if the domain was added again (#320).
- **Postfix no longer logs a "backwards-compatible default setting" notice**
  on every rejected recipient (#318).
- **Upgrades now create storage directories for new volumes.** Previously only
  a fresh install did, so the first release to add a volume would have failed
  to start its containers (#348).
- **`system_update_docker.sh --no-prune`** keeps superseded images instead of
  removing them after an upgrade (#340).
- **The smoke test checks all 19 containers,** including Link Guard (#281).
- The install guide explains how to whitelist your own addresses in IPS and
  how to unban an address (#312).

### Installs created with an earlier release

- **The CipherMail console could not be logged into.** The installer never
  created CipherMail's admin account, so the documented `admin` / `admin` did
  not exist. New installs now create `admin` with a random password, shown at
  the end of the install and in `INSTALL_SUMMARY.txt`. Upgrading creates the
  account on installs that have none (see Upgrading); installs that already
  have a CipherMail admin are left alone (#306).
- **Antivirus Settings could not be saved** on installs where
  `/var/lib/clamav/local.ign2` had never existed, failing with "There was an
  error copying /var/lib/clamav/local.ign2" (#352).

### Installs migrated from legacy

- **Global Sender Rules entries migrated from legacy were hidden and not
  applied** (the page looked empty, yet adding an address said it already
  existed). The upgrade activates them; write them out once afterwards (see
  Upgrading) (#358).
- **Restoring the email archive no longer holds up incoming mail** while it
  extracts, and can now be done after upgrading past v260912 (#354).

## Upgrading

**Before.** Take a backup or snapshot. The upgrade rebuilds the message log
table (#353): it runs online and mail keeps flowing, but on a large install it
can take a few minutes and needs free space on the data disk roughly equal to
the table's size. To see that size:

```bash
docker exec hermes_db_server mariadb -u root -e "SELECT ROUND((data_length+index_length)/1024/1024) AS msgs_mb FROM information_schema.tables WHERE table_schema='hermes' AND table_name='msgs';"
```

**Upgrade.** Run from your Hermes install directory
(`/opt/Hermes-Secure-Email-Gateway` here; replace it with your own if you
cloned elsewhere):

```bash
cd /opt/Hermes-Secure-Email-Gateway
sudo ./scripts/system_update_docker.sh v261012
```

**After, only if it applies to you:**

- **The upgrade printed "Created CipherMail admin account".** Your install had
  no CipherMail admin. See its password with the command below (from the
  install directory), then sign in at `https://<console-address>/ciphermail`,
  replacing `<console-address>` with your Hermes console's address, as `admin`
  with that password, and change it:

  ```bash
  sudo cat config/hermes/opt/hermes/creds/ciphermail_admin_password; echo
  ```

- **Your install was migrated from legacy.** Write out the Global Sender Rules
  entries the upgrade activated: under **Content Checks → Global Sender
  Rules**, add a temporary entry such as `nobody@example.invalid` with
  **Action** set to **Block**, then delete it.

Everyone else has nothing to do after the upgrade.
