# Hermes SEG v261115

## Synopsis

<!-- TODO at release cut: 2-3 sentences on what this release is and whether to upgrade. -->

## Bug fixes

- **Converting a relay recipient with PGP enabled to a mailbox no longer fails (#410).**
  The conversion stopped with "key [PGP_ENCRYPTION] doesn't exist" and left
  the recipient half-converted, missing from both Relay Recipients and
  Mailboxes. A conversion now leaves PGP keys as they are, the same as S/MIME
  certificates; a keyring can be generated afterwards as usual. To finish a
  recipient that hit this, open its Edit Mail Delivery page and save it with
  Built-in Email Server again.

- **The console comes back on its own after a reboot (#409).** If the web
  server started before the console was ready, it stopped but its container
  still showed as running, so the console and user portal stayed unreachable
  until it was restarted by hand. It now retries until the console is up.

## Upgrading

<!-- TODO at release cut. -->
