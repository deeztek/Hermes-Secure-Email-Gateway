# Hermes SEG v260912

A migration-path release. Everything that changed is in how a legacy build 240815
gateway is brought across to Docker, plus a console fix.

There is no schema change for an existing Docker install. Upgrading is quick and
low risk.

## Read this first

### If your gateway is already running

Nothing in this release changes how a running gateway processes mail. The
migration work only executes when `migrate_legacy_to_docker.sh` is run against a
legacy backup, which is not part of an upgrade.

### If you are about to migrate a legacy gateway

Use this release, not an earlier one. Three defects in the migration path are
fixed here, and one of them left every migrated gateway carrying a known
mail-rejecting configuration.

## What changed

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

Standard procedure. No schema change, no manual steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260912
```

Take a hypervisor snapshot first, as always.
