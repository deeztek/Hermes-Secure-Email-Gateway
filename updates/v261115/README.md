# Hermes SEG v261115

> **Security release: upgrade immediately.** This release fixes critical
> vulnerabilities, some of which can be exploited without signing in. Every
> version up to and including v261107 is affected. If you cannot upgrade
> right away, contact support.

## Synopsis

Security release. It fixes several vulnerabilities in the password reset
pages, the user console and the admin console, and hardens the web server
configuration. It also adds Forwarding and an All messages / Keep option to
Mail Filters in the user console, and makes SpamAssassin rules update again.

## Security fixes

- **Critical:** issues in the password reset pages that could be exploited
  without signing in.
- **Critical:** issues that let a signed-in user, or the content of an
  incoming message, run commands on the gateway.
- **Medium and lower:** further hardening of the password pages, the message
  viewer, Mail Filters, quarantine release and the console sign-in checks.

Security advisories will be published on the project's GitHub Security page
once installations have had time to upgrade. Thanks to furkank1337 for
reporting several of these issues responsibly.

## New features

- **Forwarding in the user console (#411).** A new **Forwarding** page lets
  users send every message they receive to another mailbox on their domain,
  keeping a copy in their own mailbox by default. Turning the copy off sends
  mail to the other mailbox instead, and the page warns before saving that.
  Forwards to a mailbox that is later deleted are removed automatically.
  It is also on the dashboard's Quick Links. Forwarded copies pass through
  unchanged, without a second signature, disclaimer or external-sender
  banner, and keep their Link Guard links.
  Administrators can do the same under Content Checks > BCC Maps.
- **Mail Filters: All messages and Keep (#411).** Filters in the user
  console now have an **All messages** condition and a **Keep (deliver
  normally)** action, so a filter can redirect a copy and still deliver here.
  The console warns before saving a filter that would take all mail out of
  the mailbox. A Redirect action has a **Keep a copy in this mailbox** box,
  ticked by default.
- **Address suggestions (#411).** The Mail Filters redirect address and the
  Forwarding page suggest the mailboxes on the user's own domain as they
  type.

## Bug fixes

- **Converting a relay recipient with PGP enabled to a mailbox no longer fails (#410).**
  The conversion stopped with "key [PGP_ENCRYPTION] doesn't exist" and left
  the recipient half-converted, missing from both Relay Recipients and
  Mailboxes. A conversion now leaves PGP keys as they are, the same as S/MIME
  certificates; a keyring can be generated afterwards as usual. To finish a
  recipient that hit this, open its Edit Mail Delivery page and save it with
  Built-in Email Server again.
- **SpamAssassin rules now update (#412).** The daily rule update never ran
  in the content filter container, so spam scoring has used the rules that
  shipped with SpamAssassin itself. Rules now update daily and when the
  container starts, and Amavis switches to them straight away.
- **A deleted mailbox that was converted from a relay recipient can be added
  again.** Deleting it left behind the entry that kept the address out of the
  domain catch-all, so Add Mailbox reported that the address already
  existed, and mail for it still skipped the catch-all.
- **Reverting a mailbox to a relay recipient now removes its vacation
  auto-reply setting.** It was left behind.

- **The Mail Queue shows QUEUED instead of N/A** for messages waiting to be
  delivered.
- **The console comes back on its own after a reboot (#409).** If the web
  server started before the console was ready, it stopped but its container
  still showed as running, so the console and user portal stayed unreachable
  until it was restarted by hand. It now retries until the console is up.

## Upgrading

Back up first, then run the standard upgrade:

```bash
sudo ./scripts/system_update_docker.sh v261115
```

- **Spam scores will change.** Within a few minutes of the upgrade the content
  filter moves to the current SpamAssassin ruleset (#412). Watch the
  quarantine and spam tagging for the first days, and adjust policy
  thresholds if needed.
- **A password reset link now opens a page without the token in the address
  bar**, and a link can be used once. Users who open an old link see "Link
  Already Used" or "Link No Longer Valid" and can request a new one.
- **"Password changed" notices** now go to the account address and, if set
  and verified, to the recovery address, after a reset and after a change in
  the user console.
