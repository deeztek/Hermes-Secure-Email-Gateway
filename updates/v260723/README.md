# Hermes SEG v260723

> ## Upgrade impact: low — no manual step required
>
> This is a small patch on top of [v260722](../v260722/README.md). It ships a
> code-only fix to the quarantine notifier — **no schema change**, **no new
> container or image**, **no Console Settings / nginx regeneration**. The update
> orchestrator deploys the new file and advances `build_no` automatically.

This release follows [v260722](../v260722/README.md).

## Fixes

### Quarantine notifier no longer floods the queue after a migration/restore (#287)

The near-real-time quarantine notifier (`schedule/quarantine_notify.cfm`, #180)
runs every 60s and selected messages to notify about using **only**
`msgrcpt.notification_sent = 0` — it had **no age filter**. Because that column is
a Docker-era addition the legacy database predates, the v260722 legacy→Docker
migration's additive schema-forward added it `DEFAULT 0`, stamping **every restored
historical quarantine row** as "never notified." The notifier then treated the
entire quarantine history as brand-new and drained it at 100/min — observed as
**49,000+ `[Quarantine Notice]` messages** piling up in the queue. (The v260722
outbound-delivery pause contained the blast so nothing left the box, but the queue
still filled.)

Fixed in two layers so the whole class of bug is closed, not just this migration:

- **Systemic backstop** — `schedule/quarantine_notify.cfm` gained a **7-day recency
  guard** (`msgs.time_num`, using the existing `msgs_idx_time_num` index). The
  notifier can no longer notify on messages older than the window **regardless of
  the flag**, so any path that reintroduces old `msgrcpt` rows at `0` (cross-host
  restore/DR rehost, manual DB import, a future migration build) can never flood.
- **Fix at the source** — `scripts/migrate_legacy_to_docker.sh` now marks restored
  historical quarantine as already-handled (`notification_sent = 1`) right after the
  schema-forward step, so a fresh migration never generates the backlog in the first
  place. Idempotent; warns rather than aborts on failure.

Trade-off of the recency guard: if the notifier (or the box) is down longer than the
window, quarantines that age past 7 days are silently skipped — acceptable for a
courtesy notice.

**Already-flooded box?** Mark the history handled and clear the stale queue:

```bash
docker exec -i hermes_db_server mariadb -u root hermes \
  -e "UPDATE msgrcpt SET notification_sent = 1 WHERE ds IN ('B','D') AND notification_sent = 0;"
# Confirm the queue is the quarantine notices, then delete ONLY those (by postmaster
# sender — NOT postsuper -d ALL):
docker exec hermes_postfix_dkim postqueue -p | head
```

## Upgrading

1. **Update the code.** Git-based (e.g. Test): `git fetch && git reset --hard v260723`,
   or run the standard orchestrator (`scripts/system_update_docker.sh v260723`).
2. **No schema change** — `updates/v260723/sql/schema_updates.sql` only advances
   `build_no` (the orchestrator's version stamp). The notifier fix takes effect as
   soon as the new `.cfm` is in place.
3. **Verify:** *Mail Queue* still shows the **Outbound Delivery** card; the every-60s
   quarantine notifier no longer regenerates notices for old quarantined mail.

---

*Issue: [#287](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/287)
(related: [#180](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/180),
[#150](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/150)). For how
Hermes is released and upgraded, see
[`docs/install/release-and-update-methodology.md`](../../docs/install/release-and-update-methodology.md).*
