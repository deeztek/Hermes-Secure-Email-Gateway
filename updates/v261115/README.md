# Hermes SEG v261115

## Synopsis

<!-- TODO at release cut: 2-3 sentences on what this release is and whether to upgrade. -->

## New features

- **Forwarding in the user console (#411).** A new **Forwarding** page lets
  users send every message they receive to another mailbox on their domain,
  keeping a copy in their own mailbox by default. Turning the copy off sends
  mail to the other mailbox instead, and the page warns before saving that.
  Forwards to a mailbox that is later deleted are removed automatically.
  Administrators can do the same under Content Checks > BCC Maps.
- **Mail Filters: All messages and Keep (#411).** Filters in the user
  console now have an **All messages** condition and a **Keep (deliver
  normally)** action, so a filter can redirect a copy and still deliver here.
  The console warns before saving a filter that would take all mail out of
  the mailbox.

## Bug fixes

- **Converting a relay recipient with PGP enabled to a mailbox no longer fails (#410).**
  The conversion stopped with "key [PGP_ENCRYPTION] doesn't exist" and left
  the recipient half-converted, missing from both Relay Recipients and
  Mailboxes. A conversion now leaves PGP keys as they are, the same as S/MIME
  certificates; a keyring can be generated afterwards as usual. To finish a
  recipient that hit this, open its Edit Mail Delivery page and save it with
  Built-in Email Server again.
- **Reverting a mailbox to a relay recipient now removes its vacation
  auto-reply setting.** It was left behind.

- **The console comes back on its own after a reboot (#409).** If the web
  server started before the console was ready, it stopped but its container
  still showed as running, so the console and user portal stayed unreachable
  until it was restarted by hand. It now retries until the console is up.

## Upgrading

<!-- TODO at release cut. -->
