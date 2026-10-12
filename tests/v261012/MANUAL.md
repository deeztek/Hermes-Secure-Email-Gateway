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
