# Release tests

For **test machines only**. Some checks change state (a test ban, a real
notification email), so `run.sh` refuses to run unless `HERMES_TEST_HOST=1`
is set. Do not run these on a production gateway.

## Running

From the install root:

```bash
sudo HERMES_TEST_HOST=1 bash tests/run.sh            # every release's checks
sudo HERMES_TEST_HOST=1 bash tests/run.sh v<DATE>    # one release's checks
```

Then work through `tests/v<DATE>/MANUAL.md`, if the release has one: the
checks that need a browser.

## Layout

```
tests/
  lib.sh              shared helpers: install root, pass/fail/skip, db, wait_for
  run.sh              runner; exit code = number of failed checks
  v<DATE>/
    <check>.sh        one file per claim the release makes
    MANUAL.md         browser-only checks, if any
```

Running every version's checks on each release is the regression run: a fix
made in one release is re-checked in every later one.

## Writing a check

- One file per claim, 10 to 30 lines, starting with
  `source "$(dirname "$0")/../lib.sh"`.
- Use `pass` / `fail` for each assertion, `skip "reason"` when the check does
  not apply to this machine, and end with `done_check`.
  Exit codes: 0 pass, 1 fail, 2 skip.
- Read-only where possible. Anything the check changes, it undoes, including
  on failure (`trap ... EXIT`).
- Reserved values only: `192.0.2.x` for addresses, `domain.tld` for names.
  Everything else comes from the machine under test.
- Make it executable in git, not just on disk:
  `git update-index --chmod=+x tests/v<DATE>/<check>.sh`.
- When a feature is removed, delete its checks.
- A check for an unreleased security fix is written with the fix, in the
  advisory's private fork, and becomes public when the fix ships.
