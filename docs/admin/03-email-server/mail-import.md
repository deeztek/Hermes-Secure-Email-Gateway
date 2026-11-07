# Mail Import

Admin path: **Email Server > Mail Import**
(`view_mail_import.cfm`, `inc/mail_import_actions.cfm`,
`schedule/mail_import.cfm`, `scripts/mail_import_run.sh` in `hermes_dovecot`).

This page copies mail from another IMAP server into a Hermes mailbox, including
folders and subscriptions. Use it when you move a mailbox to Hermes.

- The source server is only read. Nothing on it changes.
- Mail already in the Hermes mailbox is kept.
- Running an import again copies only what is new.
- Each import fills one mailbox. To move several, add one import for each.

Sieve rules, contacts and calendars are not imported.

## Before you start

1. Create the mailbox under **Email Server > Mailboxes**.
2. Check that its quota can hold the source account. An import that would not
   fit stops before copying anything.
3. Get the source server's IMAP host, port and encryption, plus the username and
   password. Gmail and similar providers need an app password.

**Important:** Microsoft 365 no longer accepts passwords over IMAP, so it cannot
be imported from this page.

## Add an import

1. Go to **Email Server > Mail Import**.
2. Click **Add Import**.
3. In **Hermes Mailbox**, select the mailbox to fill.
4. Enter the **Source Host**.
5. Select the **Encryption**, then check the **Port**. The usual pairs are
   **SSL/TLS** on 993 and **STARTTLS** on 143.
6. Leave **Verify the server certificate** on unless the source server uses a
   self-signed certificate.
7. Enter the **Source Username** and **Source Password**.
8. In **Mode**, select one of these:
   - **Once** copies the mail one time, then deletes the source password.
   - **Keep syncing until stopped** repeats at the **Sync Interval**, so mail
     that arrives before your cutover is copied too.
9. Check **Exclude Folders**, with one folder per line. The Gmail folders listed
   by default hold copies of mail in other folders.
10. Click **Add Import**.

The import starts within a minute. Progress and results are under **Recent
Runs**. If an import fails, the administrator receives an e-mail.

**Important:** with **Encryption** set to **None**, the password and all mail
cross the network in clear text.

## Advanced Options

| Option | Use |
|---|---|
| **Skip Mail Older Than (days)** | Copy only recent mail. 0 copies everything |
| **Skip Mail Larger Than (MB)** | Leave out very large messages. 0 copies everything |
| **Timeout (seconds)** | How long to wait for a stalled server |
| **Folder Prefix** | Use if the source keeps all folders under a prefix such as `INBOX.` |
| **Compatibility Switches** | Leave off unless an import fails against a specific server |

## Finish a cutover

1. Point your MX records at Hermes.
2. Wait until mail stops arriving at the old server.
3. On the import, click **Actions > Run Now** for a final sync.
4. When the run ends, click **Actions > Stop**. This deletes the source password.

## Follow a running import

While an import runs, **Status** shows how many messages have been copied and
about how many the source account holds. The status updates by itself every
30 seconds and the counts change once a minute. Mail already in the Hermes mailbox
is not copied again, so the two numbers do not have to meet.

## Actions

| Action | Result |
|---|---|
| **Edit** | Changes the import and runs it within a minute. Leave the password blank to keep the stored one. A finished or stopped import no longer has one, so enter it again. Not available while the import is running |
| **Run Now** | Runs a queued or failed import within a minute |
| **Stop** | Ends the import and deletes the source password. Copied mail is kept |
| **Delete** | Removes the import and its history. Copied mail is kept |

Two imports run at a time. Others wait their turn. A failed import keeps its
source password so that **Run Now** can retry it, until you stop or delete it.

## See imported folders in Nextcloud Mail

Nextcloud Mail picks up new folders on its own, usually within 15 minutes for
someone who has used it in the last day, and within a few hours otherwise.

To do it now, go to **Email Server > Mailboxes** and click **Actions > Sync
Nextcloud Mail** on the mailbox. It runs in the background, so reload Nextcloud
Mail after a few minutes.

## How the source password is handled

The password is stored encrypted and deleted when an import finishes or is
stopped. It is passed to Dovecot over standard input and a temporary file that
only root can read, never on a command line. That file is deleted when the run
ends.
