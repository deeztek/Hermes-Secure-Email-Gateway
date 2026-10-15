# v261015 manual checks

Leave **Send the welcome email** unticked unless the recipients are test addresses.

| Check | Pass |
| --- | --- |
| **Content Checks → DMARC Settings → Save & Apply** after the upgrade | Saves; `grep PublicSuffixList config/opendmarc/etc/opendmarc/opendmarc.conf` ends in `public_suffix_list.dat` (#360, #361) |
| A message from a subdomain sender whose parent domain has `p=reject` | No `DMARC_*` in `X-Spam-Status`; OpenDMARC header reads `dmarc=pass` (#360) |
| In DBeaver: `INSERT INTO recipients (recipient) VALUES ('bannertest@<relayed-domain>');`, then **Relay Recipients** | Banner counts 1 without an account; the row's Portal Account is **No** (#359) |
| Banner → **Provision them** | "1 account(s) created"; the row reads **Yes**; then delete `bannertest@…` (#359) |
| **Provision Portal Accounts** / **Send Welcome Email** with nothing ticked | Asks you to select recipients first (#359) |
| Relay Recipients and Mailboxes filter rows: each filter, then **Reset filters**; leave the page and return | Rows filter; drop-downs match what is applied; no DataTables warning (#359) |
| In DBeaver: `INSERT INTO cert_generation_queue (recipient_id, recipient_email, job_type, status, error_message) VALUES (0, '<recipient>', 'smime', 'failed', 'test failure');` | Banner names it on Relay Recipients and Mailboxes; red **Failed** badge with the error as tooltip; **Dismiss** clears it (#364) |
| **Antispam → Score Overrides:** add, edit and delete a test override | Each save restarts `hermes_mail_filter` once (`docker ps` uptime) |
