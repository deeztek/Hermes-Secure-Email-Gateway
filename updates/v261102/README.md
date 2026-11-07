# Hermes SEG v261102

## Synopsis

This release adds **VERIFY** recipient delivery, which refuses mail for unknown
recipients during the SMTP conversation instead of accepting it and bouncing it
later. It also stops the Dovecot authentication crash after idle periods, stops
Nextcloud Mail from adding its "Important" label, and fixes large messages
bouncing after Hermes had accepted them. Upgrading is recommended.

## New features

- **Recipient Delivery: VERIFY (#393).** Hermes now asks the destination server
  whether a recipient exists and refuses unknown recipients with `550`, without
  keeping a recipient list. This stops backscatter from catch-all relay domains.
  It is the new default for added domains. Existing domains keep their setting;
  change them under **Email Relay > Domains**. A refused address stays refused
  for **10 minutes**, so a mailbox created just after a failed attempt receives
  no mail until then. See [Recipient Delivery: VERIFY](https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/main/docs/admin/02-email-relay/domains.md#recipient-delivery-verify).

- **Google Web Risk for Link Guard (Pro, #385).** Link Guard can now use Google
  Web Risk, Google's option for commercial use, for click-time URL checks: 100,000
  lookups a month free, then paid, with Google Cloud billing enabled. Add a key
  under **Email Policies > Link Guard > Reputation sources**. The console and docs
  now also show each provider's limits and terms: Google Safe Browsing and the
  free VirusTotal key are not licensed for business use, and abuse.ch may need a
  paid subscription for it. Which keys you use, and following their terms, is your
  responsibility.

- **Attachment Hash Blocklist (#386).** Block a known-bad attachment by its
  SHA-256 hash under **Content Checks > Hash Blocklist**, including
  inside archives. Matches follow your **Virus Messages** setting.

- **Nextcloud file scanning (#384).** Files uploaded to Nextcloud, including Talk
  attachments, are now scanned by the ClamAV engine Hermes already runs, and
  infected uploads are refused. Infected files already in storage are logged, not
  deleted, and uploads are refused while ClamAV is unreachable. You can change
  both in `security.conf`. Files over 25 MB are not fully scanned. See
  [Nextcloud File Scanning](https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/main/docs/admin/03-email-server/nextcloud-file-scanning.md).

- **Mail Import (#356).** Copy mail from another IMAP server into a Hermes
  mailbox under **Email Server > Mail Import**, once or repeatedly until cutover.
  Mail already in the Hermes mailbox is kept. A new **Sync Nextcloud Mail** action
  under **Email Server > Mailboxes** shows imported folders in Nextcloud Mail
  straight away. See
  [Mail Import](https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/main/docs/admin/03-email-server/mail-import.md).

- **Quota usage on the Mailboxes page (#398).** The **Quota** column now shows
  usage, limit and percentage for each mailbox, and turns red at 90%.

- **Amavis destinies default to Quarantine Only (#395).** New installs quarantine
  virus, banned-file, spam and bad-header mail without sending a notice to the
  sender, and the console warns about backscatter under **Message Handling
  Policies**. Existing installs keep their settings; see Upgrading.

## Bug fixes

- **Mailbox quotas were not being enforced (#397).** The limit set on a mailbox
  stopped reaching Dovecot when Hermes moved to Dovecot 2.4, so mailboxes could
  grow past it and quota warnings were not sent. Limits now apply again. The
  quota warning e-mails also no longer show a sample address or a plus sign in
  the percentage.

- **Dovecot authentication could crash after being idle (#342).**

- **Nextcloud Mail kept adding the "Important" label (#379).** The label is now
  turned off for each mail account, and the upgrade removes it from existing mail.

- **Large messages could bounce after Hermes accepted them (#396).** Internal
  mail hops had smaller size limits than the edge. The limit in Perimeter Checks
  now applies once, at the edge.

- **The admin console showed a raw error when the login header was missing.** It
  now shows an error page.

- **The network alias refresh could fail when a DNS lookup returned nothing.**

## Upgrading

Back up first, then run the standard upgrade:

```bash
sudo ./scripts/system_update_docker.sh v261102
```

- The upgrade does not change your Message Handling Policies. If any are set to
  **Quarantine & Send DSN**, we recommend **Quarantine Only**: go to **Content
  Checks > Antispam Settings > Message Handling Policies** and set **Virus
  Messages**, **Banned File Messages**, **Spam Messages** and **Bad-Header
  Messages** to **Quarantine Only**. Messages are quarantined either way, and
  Hermes stops sending notices to forged senders.
- **Mailbox quotas are enforced again after the upgrade (#397).** A mailbox
  already over its limit stops accepting new mail. Before upgrading, run
  `docker exec hermes_dovecot doveadm quota get -A` to list each mailbox's usage
  in KB, compare it with the **Quota** column under **Email Server > Mailboxes**,
  and raise any quota that is too low.
- **Publish an SPF record on your mail hostname if it does not have one.** With
  quotas enforced, mail to a full mailbox is bounced to the sender, and Gmail
  refuses bounces from a hostname with no SPF record. See
  [DNS for Mail Flow](https://github.com/deeztek/Hermes-Secure-Email-Gateway/blob/main/docs/install/get-started-docker.md#dns-for-mail-flow-all-topologies).
- The upgrade installs the Nextcloud **Antivirus for files** app. Its background
  scan then works through existing files, which adds some load on ClamAV at first.
- No domain changes to VERIFY during the upgrade. Before you switch a domain,
  confirm its destination server refuses unknown recipients at `RCPT TO`.
- Senders in Relay Networks skip VERIFY, and a catch-all on the domain makes
  every address pass.
