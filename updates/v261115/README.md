# Hermes SEG v261115

## Synopsis

Security release. Upgrade as soon as possible. It fixes four reported
vulnerabilities, two of them reachable without signing in, and hardens the
password pages, the message viewer and Mail Filters further. It also adds
Forwarding and an All messages / Keep option to Mail Filters in the user
console, and makes SpamAssassin rules update again.

## Security fixes

Fixes vulnerabilities affecting v261107 and earlier, reported by
furkank1337. Details are in the advisories.

- **Critical:** unauthenticated LDAP password change through the password
  reset pages
  ([GHSA-wwxm-p5f2-q6xm](https://github.com/deeztek/Hermes-Secure-Email-Gateway/security/advisories/GHSA-wwxm-p5f2-q6xm)).
- **Critical:** unauthenticated password reset tokens for other accounts
  ([GHSA-rgx7-j3qv-h2gm](https://github.com/deeztek/Hermes-Secure-Email-Gateway/security/advisories/GHSA-rgx7-j3qv-h2gm)).
- **Critical:** a signed-in mailbox user could run commands through a shared
  folder name
  ([GHSA-jcj6-qrjh-qp2m](https://github.com/deeztek/Hermes-Secure-Email-Gateway/security/advisories/GHSA-jcj6-qrjh-qp2m)).
- **Medium:** HTML injection into the password reset notice sent to
  administrators
  ([GHSA-h2c7-jjqq-j49j](https://github.com/deeztek/Hermes-Secure-Email-Gateway/security/advisories/GHSA-h2c7-jjqq-j49j)).

- **Hardening.** Password reset and change now run outside the web root, with
  single-use forms and a "password changed" notice to the account and its
  recovery address. Message subjects, senders and bodies can no longer run
  script in the portal or console, and filter names and sizes can no longer
  alter the generated Sieve script.

<!-- GHSA-jmx7-r446-76pg (Nextcloud password script) was already fixed in
     v261107 by #401; credit it in that advisory, not here. -->

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
