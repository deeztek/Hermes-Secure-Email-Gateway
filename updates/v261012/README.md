# Hermes SEG v261012

## Synopsis

A fix release found while migrating a production legacy gateway to Docker.
Several admin pages could not save, and some mail was missing from Message
History. Upgrade recommended for every install, not only migrated ones.

## New features

- **Messages Processed chart on the dashboard.** It is now a line chart with
  one line per message type, adds **Past 7, 14, 21 and 30 Days**, and
  counts every message in the period. It previously sampled at most the
  newest 10,000, so busy gateways saw `10,000+` and skewed proportions
  (#355).

## Bug fixes

- **The dashboard's shorter Messages Processed periods showed the wrong
  time window,** several hours in the past depending on the server's time
  zone, so recent mail often appeared as none (#355).
- **Messages with an emoji in the subject or sender name were missing from
  Message History.** The mail was delivered, but its record could not be
  stored. The upgrade converts two columns of the message log; see Upgrading
  (#353).
- **Antispam Settings could not be saved on the standard image.** Since
  v260807 the save failed with "There was an error running
  /usr/bin/spamassassin --lint" because the configuration still referred to
  DCC, which the standard image does not include (#352).
- **A rejected SpamAssassin configuration no longer replaces a working one.**
  If SpamAssassin refuses the new configuration, the previous one is put
  back and the page shows SpamAssassin's own explanation (#352).
- **Message rules containing non-ASCII characters were written incorrectly,**
  which made SpamAssassin reject them (#352).
- **Editing a body-type message rule failed** with "key [EDIT_HEADER] doesn't
  exist" (#352).
- **Antivirus Settings could not be saved on a new install,** failing with
  "There was an error copying /var/lib/clamav/local.ign2" (#352).
- **Saving DKIM Settings could end on "the Postfix mail system is not
  running".** The settings were saved, but Postfix kept its previous
  configuration until reloaded (#351).
- **Legacy migration:** the email archive can now be restored after
  upgrading past v260912 (#354).

## Upgrading

```bash
cd /path/to/your/hermes/install
sudo ./scripts/system_update_docker.sh v261012
```

Take a backup or snapshot first. No manual steps.

The upgrade rebuilds the message log table to fix #353. It runs online and
mail keeps flowing, but on a large install it can take a few minutes and
needs free space on the data disk roughly equal to the table's size. To see
the size beforehand:

```bash
docker exec hermes_db_server mariadb -u root -e "SELECT ROUND((data_length+index_length)/1024/1024) AS msgs_mb FROM information_schema.tables WHERE table_schema='hermes' AND table_name='msgs';"
```
