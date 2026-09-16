# Hermes SEG v260912

Two things: **network aliases**, a new way to keep cloud provider IP ranges
current without retyping them, and the remaining work on the legacy migration
path. Plus a set of fixes, one of which affects every gateway freshly installed
at v260815.

This release changes the database schema. Upgrading is still a single command.

## Read this first

### If your gateway is already running

Network aliases ship switched off. Two examples are pre-loaded, Google Workspace
and Microsoft 365, both disabled, and nothing uses them until you enable one and
add it somewhere. Mail flow does not change on upgrade.

If this gateway was **freshly installed** at v260815, see the Link Guard section
below. Link Guard, disclaimers, organizational signatures and external banners
have not been working, silently, and this release fixes that.

### If you are about to migrate a legacy gateway

Use this release, not an earlier one. Three defects in the migration path are
fixed here, and one of them left every migrated gateway carrying a known
mail-rejecting configuration.

## Network aliases

Cloud mail providers publish the IP ranges their servers send from, and those
ranges change. A range pasted in by hand goes stale silently: mail starts
failing and the cause is not obvious.

An alias is a named set of ranges that keeps itself current. Point it at a
provider's published SPF record and it re-resolves on a schedule. Three pages
can reference an alias instead of a pasted copy of its ranges:

| Page | What the ranges are used for |
| --- | --- |
| Email Relay / Relay Networks | Which networks may relay through this gateway |
| System / Network Block-Allow | Allowing a provider past the RBL checks, or blocking one |
| System / Intrusion Prevention | Keeping fail2ban from banning a provider's sending ranges |

When an alias's ranges change, the pages that reference it are regenerated
automatically, so the ranges in use stay current with nothing to retype. If one
of them fails to regenerate, that page is listed as not applied on the Network
Aliases page and on the dashboard until it succeeds.

The alias name is never written to a configuration file. It is replaced with the
current ranges each time the file is generated, so Postfix, Amavis and fail2ban
see exactly what they always did.

Other things worth knowing:

- **A failed or empty resolve never empties an alias.** The previous ranges stay
  in place and the failure is reported.
- **Ranges you type by hand are never removed by a resolve.**
- **Individual resolved ranges can be switched off** with the Include checkbox,
  and stay off across re-resolves. Use this when a provider publishes a range you
  do not want to trust.
- **An alias that is in use cannot be deleted, disabled or renamed** until the
  references are removed, since all three would quietly change what the
  referencing pages mean.
- IPv6 ranges are stored but not written to configuration files, because the mail
  containers run with IPv6 disabled.

### A caution on Relay Networks specifically

Adding any range to Relay Networks, alias or not, grants it unconditional trust:
it may relay to any destination and it bypasses the anti-spam checks. That is
correct for a mail server you own. It is **not** appropriate for a cloud
provider's shared outbound ranges, because those are shared with every other
customer of that provider. An alias makes such a configuration easier to
maintain; it does not make it safe. Scoped relay permission is tracked
separately and is not in this release.

## What is fixed

### Ranges that Postfix rejects can no longer be saved

A CIDR with host bits set, such as a /23 that starts on an odd third octet, looks
right and is not. Postfix does not skip just that entry: the whole lookup errors,
which for `mynetworks` means the postscreen access list stops being consulted
entirely and legitimate mail starts being deferred.

Every page that accepts an IP range now refuses these and tells you the address
you almost certainly meant. This applies to Relay Networks, Network Block-Allow,
the Intrusion Prevention whitelist, network aliases, and ranges read from a
published SPF record.

Existing entries are not changed. If a gateway already has one, it stays until
someone edits it.

### Console settings pages read configuration by name

The configuration table linked settings to their parent directive by a numeric
id, which is what required fixed row numbers in the database baseline, which is
what allowed the Link Guard defect below to happen. Everything now links by
name.

No visible change, but it removes the class of defect rather than the instance.

### Smaller fixes

- The sidebar keeps the current page's section open and marks the item active
  instead of collapsing on every page load.
- Network Block-Allow reported success and claimed it had applied a
  configuration when every entry had been rejected.
- Editing an entry on Network Block-Allow validated nothing at all.
- A failure while applying the Postfix configuration produced a raw error page
  instead of a readable message, and left the pending changes uncommitted with
  no explanation.
- Intrusion Prevention now has a permanent Apply Settings button, and no longer
  reports Synced after a failed write.

### Link Guard, disclaimers, signatures and banners were dead on fresh v260815 installs

If this gateway was **freshly installed** at v260815, the body milter was never in Postfix's
inbound milter chain, so none of those features did anything at all. There were no errors,
because Postfix is configured to accept mail when a milter is unreachable, and the failure was
silent at every other layer too.

A single line in the v260815 database seed caused it. One row was inserted without an id, took
the id the next row expected, and that next row was discarded without complaint. The discarded
row was the one that puts the body milter in the chain.

This release restores the row and pushes the corrected chain into the live Postfix
configuration. No action is needed.

Gateways that **upgraded** to v260815, rather than installing fresh, were never affected.

To confirm afterwards:

```bash
docker exec hermes_postfix_dkim postconf -n smtpd_milters
```

Three entries are expected, the last being `inet:hermes_body_milter:8893`.

### A migrated gateway reported the wrong version, indefinitely

The installer stamps the current release into `system_settings`, and then the
legacy database restore overwrote it with the source build. Nothing put it back.

The console reported build `240815` forever, backup and restore version checks
read that value, and `system_update_docker.sh` compared `v260731` as greater than
`240815`, so the operator's first update run treated every release directory as
pending and replayed all of them.

`version_no` had the same problem and was also never corrected: a legacy database
carries the Ubuntu release there, `20.04`, where the Docker baseline carries
`Docker`.

Both are now stamped at the end of the schema bridge. The build number is derived
from the newest `updates/v<YYMMDD>/` directory, the same source the installer
uses, so it stays correct per release with nothing to remember.

### Migrated gateways carried a postscreen defect that rejects legitimate mail

v260807 shipped a correctness fix for four seeded DNSBL entries that had no
`=returncode` filter, so postscreen counted any answer in `127.0.0.0/8` as a
listing, including the codes lists use for "refused" and "over quota". Two of the
four reach the rejection threshold on their own.

That fix ran on upgrade, so every existing install got it. It never reached a
migrated one, because the migration brings a legacy database forward additively
and an additive merge cannot correct a value that is already there. Those four
statements now run as part of the bridge.

`b.barracudacentral.org` is still not removed, matching what the upgrade path
does for a list an operator may have registered their IP for, but the migration
now says so when the row is enabled.

### Baseline seed rows were counted, not restored

The migration replaces every table that exists in both the legacy build and the
current baseline, so every row a release added since build 240815 was gone. Only
the `parameters` table was merged back. The other thirty-seven printed a row
count and stopped.

All thirty-seven are now merged on their natural key, additively, so an existing
row is left exactly as it is and operator customisation survives. Measured
against a real 240815 backup, that is 377 rows restored, including sixteen
`system_settings` keys, the ten scheduled job definitions, and the third-party
malware signature databases. On that same gateway the operator's own 103 custom
message rules were left untouched.

### Post-migration verification

`scripts/verify_legacy_migration.sh` is new. Run it on the gateway after a
migration and it checks the release stamps, the DNSBL filters, that no seeded
table sits below the baseline, that the join-table foreign ids resolve, and that
nothing was duplicated. It exits non-zero on failure, so a migration can be
gated on it.

Run it before restoring the email archive. It takes seconds and touches no
files, so there is no reason to wait out the archive restore to find out whether
the database half worked.

## Upgrading

Standard procedure. The schema change is applied for you and there are no manual
steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260912
```

Take a hypervisor snapshot first, as always.
