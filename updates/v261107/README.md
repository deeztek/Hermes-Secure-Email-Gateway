# Hermes SEG v261107

## Synopsis

This release moves the console to Lucee 6.2 on Java 21 and Authentication to
Authelia 4.39.28. A password change no longer weakens Nextcloud's account
protection, and the upgrade repairs accounts already affected. Nextcloud Mail
stops filling its log with errors about a missing "Important" tag, and the
Mailboxes page shows small mailboxes' usage in MB instead of 0.00 GB.
Upgrading is recommended.

## New features

- **Lucee 6.2 on Java 21 (#402).** The admin console and user portal now run on
  Lucee 6.2, the current long-term-support release, on Java 21. The engine
  and its database driver are now part of the image, so the console no longer
  downloads anything when it starts. The upgrade also adjusts the format of
  the key file that protects stored credentials, so relay host, domain and
  malware feed credentials and other saved secrets stay readable on the new
  engine. A copy of the original is kept as `keys/hermes.key.pre-v261107`.

- **Authelia 4.39.28.** Authentication moves from 4.39.16 to 4.39.28, the
  latest patch release of 4.39.

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
- **Mail Import: source passwords containing % now work (#356).** The import
  changed every `%` in the source mailbox password before sending it, so the
  source server rejected the login. Passwords with any special characters now
  arrive exactly as entered. Jobs that failed this way can be started again
  with no changes.
- **Mail Import: importing into a mailbox that already has mail now copies
  everything (#356).** When the mailbox already held mail imported from another
  account, folders that existed on both sides (Inbox, Sent, Trash and so on)
  were skipped, so only folders new to the mailbox were copied. Imports now
  merge into existing folders, and repeat runs copy only new mail without
  duplicating anything or bringing back messages deleted in Hermes. Run an
  affected job again to copy what it missed; mail already there is not copied
  twice.
- **Relay host: authentication credentials are saved on older installs (#404).** On
  installs that started before v260612, saving a relay host with
  authentication kept the username but dropped the password, so outgoing mail
  through the relay went without credentials. The upgrade adds what was
  missing. If you use a relay host with authentication, open **Relay Host**
  after upgrading, enter the password again and save.
- **Updater no longer stops partway when Nextcloud apps need upgrading (#403).** If
  Nextcloud's own version was already current but one of its apps (such as
  Mail) still needed upgrading, the updater could end without an error after
  "Applying Nextcloud settings", skipping its remaining steps. It now runs the
  Nextcloud upgrade in that case and carries on to the end.
- **Relay Recipients: no false "without a portal account" warning (#406).**
  The warning counted mailboxes as relay recipients, so it reported
  recipients without a portal account when every relay recipient had one.
  **Provision them** used the same list. Both now cover relay recipients only.
  The upgrade also removes the relay role from mailboxes that were converted
  from relay recipients before v260929 and still had it.
- **Mailboxes: small mailboxes no longer show 0.00 GB.** The **Quota** column
  under **Email Server > Mailboxes** shows usage below 1 GB in MB, for example
  `0.3 MB of 5 GB (0%)`. From 1 GB up it shows GB as before.

## Upgrading

Back up first, then run the standard upgrade:

```bash
sudo ./scripts/system_update_docker.sh v261107
```

- The console's application server moves to Lucee 6.2. Its first start after
  the upgrade deploys the new engine, so the admin console and user portal take
  a few minutes longer than usual to come up. The previous server files are
  kept beside the new ones as `commandbox/serverhome.pre-lucee_6.2.9+4` under
  your data mount; you can delete that folder once the console works.
