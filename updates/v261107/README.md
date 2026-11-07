# Hermes SEG v261107

## Synopsis

A maintenance release. The Mailboxes page shows small mailboxes' usage in MB
instead of 0.00 GB.

## New features

None yet.

## Bug fixes

- **Mailboxes: small mailboxes no longer show 0.00 GB.** The **Quota** column
  under **Email Server > Mailboxes** shows usage below 1 GB in MB, for example
  `0.3 MB of 5 GB (0%)`. From 1 GB up it shows GB as before.

## Upgrading

Back up first, then run the standard upgrade:

```bash
sudo ./scripts/system_update_docker.sh v261107
```
