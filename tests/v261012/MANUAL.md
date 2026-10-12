# v261012 manual checks

| Check | Pass |
| --- | --- |
| **Content Checks → DKIM Settings → Save & Apply** | Ends on the success message; no "the Postfix mail system is not running" (#351) |
| **Content Checks → Antispam Settings → Save & Apply** | Saves; `docker exec hermes_mail_filter spamassassin --lint` prints nothing (#352) |
| **Message Rules:** edit a body-type rule and save | Saves; no "key [EDIT_HEADER] doesn't exist" (#352) |
| **Message Rules:** add a body rule with regex `/(abc/` | Red "SpamAssassin Rejected the Rule" box naming the error; the rule is not in the list (#352) |
| **Message Rules:** edit an existing rule's regex to `/(abc/` | Red box; the rule keeps its previous regex (#352) |
| `docker exec hermes_mail_filter mv /var/lib/clamav/local.ign2 /var/lib/clamav/local.ign2.test`, then **Antivirus Settings → Save & Apply** | Saves and recreates `local.ign2`; then remove `local.ign2.test` (#352) |
| **Dashboard → Messages Processed:** every range from 15 minutes to 30 days | Shows current traffic; one line per type, Clean on the right axis (#355) |
| During the upgrade, send a test message | Delivered while the `msgs` table rebuilds (#353) |
| **Email Server → Domains:** delete a mailbox domain that has no mailboxes or recipients but has an alias | Refused: "This domain has N alias(es)" (#320) |
| Send to an internal-only (Reachable By) address from outside, then `docker logs --since 5m hermes_postfix_dkim 2>&1 \| grep -c "backwards-compatible default"` | The rejection is logged; the count is `0` (#318) |
| Upgrade log (`install-logs/`): the `Provisioning storage directories` step | Ran without a warning (#348) |
| `sudo bash scripts/hermes_smoke_test.sh` | Lists 19 containers including `hermes_linkguard` (#281) |
| `sudo ./scripts/system_update_docker.sh --dry-run --no-prune` | Phase 6 reports it is skipping image cleanup (#340) |
