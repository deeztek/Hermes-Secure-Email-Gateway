# Hermes SEG v260722

> ## Upgrade impact: low — no manual step required
>
> This release adds a small, idempotent schema change (the **Pause Outbound
> Delivery** control) that the update orchestrator applies automatically. There is
> **no Console Settings / nginx regeneration step** and **no new container or image**.
> Existing installs upgrade with the normal command and are done.

This release follows [v260630](../v260630/README.md).

## What's new

### Pause / Resume Outbound Delivery (Mail Queue)

The **Mail Queue** page gains an **Outbound Delivery** card showing **ACTIVE** or
**PAUSED**, with **Pause** / **Resume** buttons. Pausing holds all outbound mail in
the queue; resuming releases the hold and flushes the queue.

- The hold is a first-class `defer_transports` **parameters** directive (not a bare
  `postconf`), so it survives every subsequent *Save & Apply* — including the SPF/
  DKIM/DMARC saves — instead of being silently un-paused by the next config render.
- **Default is normal delivery** (`enabled=0`); existing behavior is unchanged until
  an administrator explicitly pauses.

## Fixes

### Legacy → Docker migration hardening (#150)

`scripts/migrate_legacy_to_docker.sh` was hardened extensively against real
`build-240815` backups. Each of these was a live failure found by running the
migration end-to-end:

- **Safe-cutover hold** — a freshly migrated box now comes up with outbound
  **HELD**, so it cannot blast the restored quarantine's stale notifications to real
  recipients. A completion banner and a *Release Outbound Delivery* checklist step
  make the hold explicit. (This is the migration side of the Pause control above.)
- **Postfix directives resolved after restore** — backfills `parameters.parent_name`
  and merges in the baseline `parameters` seed rows the legacy DB predates, so
  SPF/DKIM/DMARC *Save & Apply* no longer fails with `bad numerical configuration`.
- **Mail flows after restore** — compiles the postfix `hash:` maps the live config
  references (was smtpd-451-rejecting every message) and chowns the restored
  quarantine to the container's amavis uid (was deferring on *Permission denied*).
- **Strict-mode safe & fail-loud** — the schema-forward step runs cleanly under
  MariaDB 11.4 strict `sql_mode` and reports a clear error instead of aborting
  silently on failure.

### DKIM key generation on fresh installs (#285)

Fresh installs of v260612 / v260628 / v260630 failed to generate DKIM keys
(`opendkim-genkey … chdir(): No such file`) because `dkim/keys/` was absent in a
fresh clone. Fixed for fresh clones, fresh installs, and already-deployed hosts.

### Postfix `master.cf` re-injection (public snapshot drift)

The public repo's `master.cf` snapshot predated **#232** (loopback-bound `:10026`,
`no_milters`), which broke CipherMail cross-container re-injection and disabled
post-MIME-rebuild DKIM re-signing on fresh installs / migrations. Restored to the
`#232` design (matches production). Installs built before the public repo already
had the correct file and are unaffected.

### Repository / tooling

- Removed hardcoded install-root paths repo-wide (scripts self-locate; admin pages
  use the live Docker directory), so installs rooted at any path work — including two
  admin pages that had printed a wrong path in copy-pasteable instructions.
- Added a pre-commit guard (Layer 4) that blocks hardcoded install roots in staged
  code, plus a fresh-install smoke-test path fix (#284).

## Upgrading

1. **Update the code.** Git-based (e.g. Test): `git fetch && git reset --hard v260722`,
   or run the standard orchestrator (`scripts/system_update_docker.sh v260722`).
2. **Schema applies automatically** — `updates/v260722/sql/schema_updates.sql` adds the
   `defer_transports` directive rows (idempotent) and advances `build_no`.
3. **Verify:** *Mail Queue* → the **Outbound Delivery** card shows **ACTIVE**.

---

*Issues: [#150](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/150),
[#284](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/284),
[#285](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/285). For how Hermes
is released and upgraded, see
[`docs/install/release-and-update-methodology.md`](../../docs/install/release-and-update-methodology.md).*
