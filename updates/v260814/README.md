# Hermes SEG v260814

A fresh-install release. Two defects that could strand a new gateway partway through
its first install are fixed, plus one dashboard failure that affects gateways already
running.

Neither install defect is a v260807 regression. Both have been present since the
Docker edition's first commit and were found by running the fresh-install gate that
v260807 shipped without.

## Read this first

### If your gateway is already running, one thing here affects you

The dashboard fix. Everything else in this release is installer work that only
executes while a gateway is being built for the first time, and there is no schema
change at all. Upgrading is quick and low risk.

### The admin console could be taken down by a missing disk probe

The dashboard draws five storage rings, one per tier. Each ran a probe script inside
a `cftry` whose `cfcatch` rendered an error page and aborted. So if a probe script was
absent, or its path was not mounted, the **entire dashboard** died with a
page-specific error rather than losing a single ring.

This was reachable on any gateway installed before the archive tier was added in
`#260`, because those installs have no `disk_space_usage_archive.sh`. Observed in the
field: `index.cfm` completely unreachable, with the rest of the console fine.

The catch now leaves the ring's default in place and returns. Every other panel
renders and the affected ring reads zero.

A related defect was fixed in v260807: `cfexecute` only creates its output variable
when the command actually produces output, so a probe that returned nothing left the
variable undefined and killed the page the same way. Both halves are now closed.

### Nextcloud got one install attempt and could never recover from failing it

The `nextcloud:apache` entrypoint runs `occ maintenance:install` exactly once, on
first boot. If MariaDB has not finished creating the Nextcloud database user by the
time that runs, the attempt fails and leaves a **partial** `config.php` behind: it
carries `dbname` and `dbhost`, but no `dbuser`, no `dbpassword`, and no `installed`
key.

On every later boot the entrypoint reads that file, concludes Nextcloud is already
configured, and never tries again. The container sits there up and healthy, and
uninstalled, indefinitely.

This is why it was not a timeout. The installer waited two minutes and then advised
re-running `--init-db`, but that advice **could not work**: the re-run reached the
same already-configured short circuit, so the loop never terminated. Widening the
wait would not have helped either, because nothing was still running to wait for.

The installer now drives the install itself when it finds Nextcloud reporting
`installed: false`. It preserves the partial `config.php` under a date-stamped name,
confirms the database user can actually open the database, then runs
`maintenance:install` with the credentials it already generated. The two-minute poll
is kept as the fast path, so a healthy install behaves exactly as before.

Tracked in `#313`.

### A wrong host clock took DNS down and the installer blamed your forwarders

Hermes runs its own Unbound resolver with DNSSEC validation enabled. Validation
happens **locally**, against the host clock, on every answer Unbound receives.
Forwarding does not hand that job to your upstream resolver: Unbound still checks the
signatures itself.

So when the host clock is wrong, every signature reads as invalid. Because the
failing signature is on the root zone, Unbound cannot establish trust for anything
beneath it, and **all** name resolution stops, not just signed zones. Unbound then
caches the invalid key, so correcting the clock alone does not restore service. And
because NTP server hostnames no longer resolve, the clock cannot fix itself.

The installer's DNS preflight reported this as a forwarder problem, which is the one
thing it is not. Reverting a virtual machine snapshot is the ordinary way to end up
here.

The preflight now recognises the signature. When DNS fails it checks Unbound's log
for `signature before inception`, `signature expired` and
`key for validation ... marked as invalid`, and separately checks whether the host
clock is behind the commit being installed, which proves the clock is wrong without
needing any network access. If either fires it names the clock, shows the evidence,
and gives the fix including the Unbound restart that the cached state requires.

This is diagnosis only. **No new check gates a healthy install**, and nothing new
runs unless DNS has already failed. A correct clock that happens not to be managed by
`systemd` will not be flagged.

Tracked in `#314`.

### The release workflow could not run its own drift check

`scripts/check_ofelia_seed_drift.sh` was committed non-executable, so the
release-images workflow failed at "Verify generated artifacts" with permission
denied and skipped the retag job. Same class as the pre-push hook in `#296`: a script
that only ever runs from a fresh checkout, where the git file mode is the only mode
that counts.

No effect on v260807, whose images were promoted by hand from the tested artifacts.

## What to do

Run the standard upgrade:

```bash
cd /opt/hermes-seg-docker-gl
sudo ./scripts/system_update_docker.sh
```

There is nothing to do by hand. No schema change, no config template change, and no
page that needs re-saving.

## How to confirm it worked

```bash
# Build stamp advanced
docker exec hermes_db_server mysql -u root hermes \
  -e "SELECT value FROM system_settings WHERE parameter = 'build_no';"
# expect: v260814
```

Then open the admin console dashboard. All five storage rings should render. A tier
you have not provisioned reads zero instead of taking the page down with it.

## Why it happened

The two installer defects are the same story told twice: **a first-run path that
nothing exercised**. Both date to the Docker edition's root commit and both survived
every release because upgrade testing never touches them, and until v260807 there was
no fresh-install gate to catch them. `git log -S` confirms neither was introduced by
a recent change.

The dashboard defect is a different shape. It is the cost of a `cfcatch` that aborts:
a handler written to make one failure loud made every failure fatal. The fix is to
degrade the ring, not the page.

## What changed

| Area | Change | Issue |
| --- | --- | --- |
| Installer | Nextcloud install recovered rather than abandoned | `#313` |
| Installer | DNS failure names the clock instead of the forwarders | `#314` |
| Dashboard | A failed disk probe loses one ring, not the console | |
| CI | `check_ofelia_seed_drift.sh` committed executable | |
| Schema | Version stamp only, no changes | |

## Known follow-up

- `#311` Distribution lists. One address expanding to many recipients.
- `#312` The Fail2Ban whitelist is not discoverable until after you have locked
  yourself out.
- `#306` The CipherMail console still has its own unmanaged administrator account.
