# Hermes SEG v261107

## Synopsis

A maintenance release. A password change no longer weakens Nextcloud's account
protection, and the upgrade repairs accounts already affected. Nextcloud Mail
stops filling its log with errors about a missing "Important" tag, and the
Mailboxes page shows small mailboxes' usage in MB instead of 0.00 GB.
Upgrading is recommended.

## New features

None yet.

## Bug fixes

- **Password changes no longer weaken Nextcloud's account protection (#401).**
  Changing or resetting a mailbox password also updated a Nextcloud credential
  that is meant to stay random. The upgrade sets it back to a random value for
  every Nextcloud-enabled mailbox. Nextcloud Mail, app passwords and the
  Nextcloud login are unaffected, and users do not need to do anything.
- **Nextcloud Mail: no more "Could not find important tag" errors (#400).**
  Mail accounts that Hermes created had none of Nextcloud Mail's default tags
  (Important, Work, Personal, To Do, Later), so every sync that found new mail
  logged an error. New accounts now get the tags when they are created, and the
  upgrade adds them to existing accounts.
- **Mailboxes: small mailboxes no longer show 0.00 GB.** The **Quota** column
  under **Email Server > Mailboxes** shows usage below 1 GB in MB, for example
  `0.3 MB of 5 GB (0%)`. From 1 GB up it shows GB as before.

## Upgrading

Back up first, then run the standard upgrade:

```bash
sudo ./scripts/system_update_docker.sh v261107
```
