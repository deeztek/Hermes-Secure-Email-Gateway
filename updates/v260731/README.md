# Hermes SEG v260731

## Read this first

**Apply this update even if your system looks fine.** The problems it fixes are
silent — nothing on your dashboard reported them, and that was part of the fault.

### Four scheduled jobs have not been running

On affected systems these were never started. There was no error, no alert, and
no indication in the console:

| Job | What it does | Consequence while stopped |
|---|---|---|
| `hermes-fangfrisch-refresh` | Refreshes ClamAV **third-party malware signatures** | Supplementary virus signatures went stale |
| `hermes-dmarc-report` | Generates DMARC aggregate reports | No reports sent to domains you receive mail from |
| `hermes-health-check-mailqueue` | Watches the mail queue, alerts on backlog | A growing queue raised no alarm |
| `hermes-authelia-log-rotate` | Rotates Authelia logs | Logs grew unbounded |

**Core mail flow was not affected.** Filtering, spam scanning, virus scanning
against ClamAV's own official signature feed, encryption and delivery all
continued working normally throughout.

### Your update checker has been dead

The job that checks for new Hermes SEG releases was calling a script removed
several releases ago. It failed silently every night and never wrote its result,
so:

- *System Info → Hermes Update* showed **UPDATE CHECK PENDING** permanently
- **No update notification e-mails were ever sent**
- You were never told that v260628, v260630, v260722 or v260723 existed

This is why you are reading this in a direct message rather than seeing a prompt
in your console.

### Your version number was probably wrong

Any system **installed fresh** (rather than upgraded into) reported the version
of the installer baseline instead of its own. A fresh v260723 install displayed
**v260612** on the dashboard and in the footer. The software was correct; only
the reported number was wrong.

---

## What to do

On your Hermes SEG host:

```bash
cd /path/to/hermes-seg          # the directory you installed into
sudo ./scripts/system_update_docker.sh
```

Confirm the prompt. **One run catches you up through every release you missed** —
you do not need to run it repeatedly or apply releases in order. Mail flow is not
interrupted. No manual database step, no image rebuild.

## How to confirm it worked

```bash
sudo ./scripts/hermes_smoke_test.sh
```

Look for these three lines, and no failures:

```
OK    ofelia_jobs: 10 active job(s)
OK    config.ini matches ofelia_jobs (10 job(s) scheduled)
OK    hermes-update-check calls check_for_update.cfm
```

Then check *System Info* in the console: the **Build** should match the release
you are on, and **Hermes Update** should no longer read PENDING.

To see the update check work immediately rather than waiting for the nightly run:

```bash
docker exec hermes_commandbox curl -s http://localhost:8888/schedule/check_for_update.cfm
```

---

## Why it happened

`config/ofelia/config.ini` — the file that tells the scheduler which jobs to run —
is **generated** from the `ofelia_jobs` database table by the admin console. It was
also, mistakenly, committed to the repository as a fixed copy taken from one machine
at the v260612 release, and Docker mounts that copy directly over the live file.

Nothing regenerated it at install time, and the upgrade process overwrote the live
file with the repository copy on every run. A system that had accidentally repaired
itself (by saving any SPF, DKIM, DMARC or certificate settings page, which triggers
a regeneration) was silently returned to the broken state at its next upgrade.

That frozen copy predated four of the ten scheduled jobs and still referenced the
old update-check script.

Separately, the installer wrote a fixed version number into new databases, and only
the *upgrade* process ever advanced it — so fresh installs kept the baseline value.

## What changed

- **The schedule is now generated, not shipped.** A new headless endpoint renders
  `config.ini` from `ofelia_jobs`; the installer runs it at the end of setup and the
  update orchestrator runs it during **every** upgrade, which also permanently closes
  the overwrite problem. Available standalone as
  `./scripts/install_hermes_docker.sh --render-ofelia`.
- **The version number is derived**, not hardcoded — taken from the release in the
  installed source tree, so it cannot drift again.
- **The system checks itself.** `hermes_smoke_test.sh` now fails when the scheduled
  jobs disagree with the database, naming the jobs that are not running, and verifies
  the update check points somewhere real. It previously reported *"All critical checks
  passed"* on a system with four dead jobs, because it counted database rows rather
  than what was actually scheduled.
- **The dashboard tells the truth.** An unverified update reading now carries a warning
  and an explanation, plus a **Check now** action. Previously `UPDATE CHECK PENDING`
  looked identical in weight to a healthy `LATEST VERSION`.
- **Upgrade fixes** — for existing systems, the database is repaired before the
  schedule is generated from it, so a system missing job entries gets them back.
- Also fixed: an installer version check that had silently returned nothing since
  v260612, and an update-orchestrator bug where command-line options (`--dry-run`,
  `--yes`, `--remote`, an explicit target version) were discarded partway through
  the run.

## Known follow-up

- `config/ofelia/config.ini` is still tracked in the repository so the scheduler is
  valid at first container start. The upgrade now corrects it immediately afterwards;
  removing it entirely is the cleaner end state.
- Container images are published only as `:latest` — no per-release image tags exist,
  so a release cannot be pinned or rolled back at the image level. Version resolution
  is guarded against this, and installs continue to work.

---

*Issue [#288](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/288). For
how Hermes SEG is released and upgraded, see
[`docs/install/release-and-update-methodology.md`](../../docs/install/release-and-update-methodology.md).*
