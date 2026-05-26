# `updates/v260901/` — TEST RELEASE (to be deleted)

**This is not a real release.** It exists temporarily to validate the `scripts/system_update_docker.sh` orchestrator end-to-end on the Test box (Session G of the [#218 phased plan](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/218)).

## Why v260901

The calendar versioning format `vYYMMDD` requires a real-looking date. `v260901` (September 1, 2026) was picked because:

- It's far enough in the future that it won't collide with the realistic next-real-release date
- It still satisfies the orchestrator's strict `v[0-9]{6}` glob pattern in `find_pending_releases`
- It sorts after every existing or near-term real release

## What this release applies

A single harmless seed row + the standard release stamp:

```sql
INSERT IGNORE INTO system_settings (parameter, value)
VALUES ('orchestrator_test_marker', 'v260901 applied');

UPDATE system_settings SET value = 'v260901' WHERE parameter = 'build_no';
UPDATE system_settings SET value = 'Docker'  WHERE parameter = 'version_no';
```

No CFML migrations, no bash scripts, no `.env` changes (images stay at `v260119`). Phase 2 of the orchestrator (`docker compose pull`) becomes a no-op since image tags don't change.

## Cleanup expected

Once Session G validates the orchestrator works end-to-end, this directory + the tag + the test marker row + the build_no advancement get reverted in a follow-up cleanup commit. The tag should also be deleted from GitLab (`git push origin :v260901`).
