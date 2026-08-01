# Hermes SEG v260731

> ## Upgrade impact: low — no manual step required
>
> A repair release on top of [v260723](../v260723/README.md). It fixes the
> **scheduler**, which on many installs has been running a job list frozen at the
> v260612 release — silently, with four jobs missing. **No new container or
> image**, **no Console Settings / nginx regeneration**. The orchestrator
> backfills the job table, re-renders the schedule and advances `build_no`
> automatically.
>
> **Every install should take this one**, including boxes that look healthy: the
> missing jobs fail quietly, and one of them is the ClamAV malware-feed refresh.

This release follows [v260723](../v260723/README.md).

## Fixes

### Scheduler ran a stale job list; malware feeds and the update check were dead (#288)

`config/ofelia/config.ini` is a **generated** file — the admin console renders it
from the `ofelia_jobs` table whenever a scheduled task is toggled or an SPF /
DMARC / ACME / malware-feeds page is saved. It was nonetheless committed to the
repo as a snapshot taken off a host, and `docker-compose.yml` bind-mounts
`./config/ofelia` straight onto `/etc/ofelia`. Nothing re-rendered it at install
or upgrade, so that frozen snapshot *was* the live schedule.

Worse, the upgrade orchestrator's `git checkout -f` **overwrites** the live
rendered schedule with the repo's snapshot on every upgrade — so an install that
had self-healed (via any admin save) silently regressed on its next update.

What the snapshot was missing, against the seeded job table:

| Job | Should be | Shipped snapshot |
|---|---|---|
| `hermes-update-check` | `curl .../check_for_update.cfm` | pre-#218 `update_check.sh` |
| `acme-validate-ip` | `@every 30m` | `@every 1h` |
| `hermes-health-check-mailqueue` | `@every 15m` | **missing** |
| `hermes-dmarc-report` | `0 30 02 * * *` | **missing** |
| `hermes-authelia-log-rotate` | `0 0 02 * * *` | **missing** |
| `hermes-fangfrisch-refresh` | `@every 10m` | **missing** |

Consequences on an affected box:

- **ClamAV third-party malware signature feeds never refreshed** — `fangfrisch`
  was not scheduled at all. This is the one to care about.
- **Update check permanently stuck.** The job ran the pre-#218 wrapper, which
  shells out for an API token and POSTs through the since-removed `/hermes-api/`
  endpoint. It can never write the cache file the dashboard reads, so *System
  Info → Hermes Update* showed **UPDATE CHECK PENDING** forever — not just on
  the first day.
- DMARC aggregate reports, mail-queue health alerts and Authelia log rotation
  never ran.
- Ofelia's own failure notifications went to the placeholder address, so none of
  the above announced itself.

Fixed at three levels:

- **The render now happens.** New `schedule/regen_ofelia_config.cfm` (a headless
  counterpart to the existing `regen_nginx_config.cfm`) rebuilds `config.ini`
  from `ofelia_jobs` and restarts `hermes_ofelia`. The update orchestrator runs
  it in phase 4 of **every** upgrade, which also permanently closes the
  `checkout -f` clobber above. Fresh installs run it at the end of setup.
- **The table it renders from is repaired first.** `schema_updates.sql` below
  backfills any missing job rows (idempotent, keyed on job name) and retires the
  legacy `update_check.sh` command.
- **Standalone recovery:** `./scripts/install_hermes_docker.sh --render-ofelia`.
- **It can no longer go unnoticed.** `scripts/hermes_smoke_test.sh` now compares
  the rendered `config.ini` against the active `ofelia_jobs` rows and **fails**
  on divergence, naming the jobs that are in the database but not actually
  scheduled. It separately asserts that `hermes-update-check` calls
  `check_for_update.cfm` — a job that looks scheduled but points at a dead
  target is worse than a missing one, and that is precisely what hid this for
  four releases.

### The dashboard now says when the update reading cannot be trusted (#288)

The *Hermes Update* cell rendered `UPDATE CHECK PENDING` and `UPDATE CHECK
UNAVAILABLE` as plain text, identical in weight to a healthy `LATEST VERSION`.
A scheduler that had stopped feeding that cell therefore looked like a normal
state and went unnoticed indefinitely — which is exactly how the stale job list
above stayed invisible.

Unverified readings are now flagged with a warning icon, carry a tooltip saying
*why* (never checked / last successful check was `<date>` / could not reach the
GitHub API), and offer a **Check now** link that runs the poll on demand and
returns to the dashboard. A cache file older than 3 days is treated as stale
even if it parsed cleanly.

This matters beyond cosmetics: the update check is the **only** channel that
announces a new release — the dashboard cell and the notification e-mail are
both fed by the cache file that job writes. When it is dead, an install has no
way to learn an update exists.

### Dashboard reported the wrong build on fresh installs (#288)

`config/database/hermes_install.sql` carried a hardcoded `build_no`, and the
per-release `schema_updates.sql` that advances it runs on **upgrades only**. A
fresh install imported the baseline and stopped there — so fresh installs of
**v260628, v260630, v260722 and v260723 all reported `v260612`** on the
dashboard and in the footer.

`install_hermes_docker.sh` now derives the stamp from the newest
`updates/v<YYMMDD>/` directory in the checkout, so it stays correct with no
per-release step to forget. Such a box will replay every intervening release
directory on its first upgrade — all idempotent, and it lands correctly stamped.

### Install pulled `:latest` images instead of the release's own tag (#288)

`derive_install_version()` still matched the `hermes-NNNNNN/` release-directory
naming that was replaced by `v<YYMMDD>/` at the #218 release-engineering pivot,
so it returned an empty string. The installer banner printed *"Version
unknown"*, and `HERMES_DOCKER_IMG_VERSION` was never substituted into `.env` —
leaving the install on the `latest` tag rather than the one matching the cloned
source tree. Latent so far only because `latest` has been promoted every
release.

## Upgrading

1. **Update the code.** Standard orchestrator: `scripts/system_update_docker.sh v260731`.
   Git-based (e.g. Test): `git fetch && git reset --hard v260731`.
2. **Schema:** `updates/v260731/sql/schema_updates.sql` backfills missing
   `ofelia_jobs` rows and advances `build_no`. Idempotent, applied automatically.
3. **If you upgraded with `--skip-git` or by hand**, render the schedule
   explicitly once: `./scripts/install_hermes_docker.sh --render-ofelia`.
4. **Verify:**
   - *System Info → Hermes Update* reads **LATEST VERSION** (not PENDING) after
     the next 04:30 run, or immediately via
     `docker exec hermes_commandbox curl -s http://localhost:8888/schedule/check_for_update.cfm`
   - *System Info → Build* matches the release you are on.
   - `docker exec hermes_ofelia cat /etc/ofelia/config.ini` lists **10** jobs,
     including `hermes-fangfrisch-refresh`.

## Known follow-up

**`config/ofelia/config.ini` remains a generated artifact tracked in git.**
Shipping it keeps the scheduler valid at first container boot before the app is
up, and the phase-4 render now corrects it immediately afterwards — but the
cleaner end state is to untrack it and render it from the DB before
`docker compose up`.

**ghcr.io carries only `:latest` — no versioned image tags exist.** Verified
across `hermes-commandbox`, `hermes-nginx`, `hermes-mail-filter` and
`hermes-postfix-dkim`: `:latest` resolves, `:v260722` and `:v260723` do not.
This went unnoticed precisely because `derive_install_version()` was returning
empty, so installs silently fell back to `latest` and never asked for a
versioned tag. Repairing the derivation is therefore gated behind a registry
existence probe (above), and a fresh install still resolves to `latest` today.
Until versioned tags are actually published, the documented "build with version
tag → test on DEV → promote to latest" workflow is not reproducible from the
registry, and `--image-version=<tag>` has nothing to pin to. Both items tracked
on [#288](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/288).

---

*Issue: [#288](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/288)
(related: [#218](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/218),
[#221](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/221)). For how
Hermes is released and upgraded, see
[`docs/install/release-and-update-methodology.md`](../../docs/install/release-and-update-methodology.md).*
