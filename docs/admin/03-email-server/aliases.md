# Aliases

Admin path: **Email Server > Aliases** (`view_mailbox_aliases.cfm`,
`inc/add_mailbox_alias_action.cfm`, `inc/edit_mailbox_alias_action.cfm`,
`inc/delete_mailbox_alias_action.cfm`, `inc/get_mailbox_alias_json.cfm`).

This page manages **alternate email addresses for local mailboxes** on
the Email Server topology. Each row in the `mailbox_aliases` table maps
one inbound address (e.g., `sales@company.com`) to either an existing
local mailbox or to Postfix's discard transport for silent disposal.
The destination must be local — to an existing Dovecot mailbox on this
server. For forwarding to external addresses or for relay-topology
domains, use [Email Relay > Virtual Recipients](../02-email-relay/virtual-recipients.md)
instead.

Aliases have **no SMTP authentication, no IMAP/POP3 access, and no
password of their own**. They are rewrite rules consumed by Postfix
before content filtering. The optional **Send-As** flag adds a row to
`sender_login_maps` so the destination mailbox owner can send mail
under the alias address from their existing IMAP/Submission session.

## Not the same as Virtual Recipients

Email Server aliases and Email Relay virtual recipients share the same
underlying Postfix lookup but enforce different topology rules. See
[Virtual Recipients](../02-email-relay/virtual-recipients.md) for the
full distinction; the short version:

| | Mailbox Aliases (this page) | Virtual Recipients |
|---|---|---|
| Table | `mailbox_aliases` | `virtual_recipients` |
| Domain type | Mailbox domains (`domains.type = 'mailbox'`) | Relay domains (`domains.type = 'relay'` or NULL) |
| Delivery target | A local Dovecot mailbox, or `discard:silently` | Anywhere — internal or external |
| UNIQUE on address | Yes (one delivery per alias) | No (fan-out via multiple rows) |
| Send-As | Optional, surfaced as a toggle | Schema flag, not yet wired through |
| Catch-all (`@domain`) | Not supported | Supported |
| Discard transport | Supported (silent drop) | Not supported |
| Typical use | `support@company.com → alice@company.com` (both local) | `info@company.com → admin@externalpartner.example` |

Both tables feed the same `virtual_alias_maps` lookup via a single
UNION query in `mysql-virtual.cf`:

```sql
SELECT maps        FROM virtual_recipients WHERE virtual_address = '%s'
UNION
SELECT delivers_to FROM mailbox_aliases    WHERE alias_address   = '%s'
```

The add handlers in each page enforce the topology gate: trying to
create a mailbox alias for a relay domain is rejected with error 12,
and the Virtual Recipients add handler rejects mailbox-domain rows
with a pointer back to this page.

## Storage and lookup path

```
inbound SMTP (port 25) ──► hermes_postfix_dkim
                                  │
                                  │  smtpd: helo, sender, recipient checks
                                  │  virtual_alias_maps  ◄── mysql:/etc/postfix/mysql-virtual.cf
                                  │                          │
                                  │                          ▼
                                  │      ┌──────────────────────────────────┐
                                  │      │ hermes_db_server                  │
                                  │      │  UNION across virtual_recipients  │
                                  │      │   and mailbox_aliases             │
                                  │      └──────────────────────────────────┘
                                  │
                                  ▼
                          rewritten recipient
                                  │
                  ┌───────────────┴────────────────┐
                  │                                │
       forward (delivers_to =          discard (delivers_to =
       a local mailbox username)       'discard:silently')
                  │                                │
                  ▼                                ▼
       amavis (10024)                   discard(8) transport
                  │                                │
                  ▼                                ▼
       LMTP → hermes_dovecot         message silently dropped
       Maildir for target mailbox      no bounce, no DSN, no log entry
                                       beyond the queue acceptance
```

The MySQL lookup is live — adding a row in this page takes effect on
the next inbound message, with no Postfix reload, no `postmap`, and
no template regeneration.

## The `mailbox_aliases` table

| Column | Type | Role |
|---|---|---|
| `id` | INT PK | Surrogate key |
| `alias_address` | VARCHAR(255), **UNIQUE** | The address being rewritten. Full email only — no catch-all syntax. The UNIQUE constraint enforces one delivery target per alias address. |
| `delivers_to` | VARCHAR(255) | Destination. For `alias_type = 'forward'` this is the local mailbox username; for `alias_type = 'discard'` this is hardcoded to the literal string `discard:silently`, which Postfix routes through the discard(8) transport. |
| `alias_type` | VARCHAR(20) | `forward` (default) or `discard` |
| `send_as` | TINYINT(3) | `1` if the destination mailbox is allowed to send mail as the alias address. Wired into `sender_login_maps` on insert/update. |
| `domain_id` | INT | FK to `domains.id`; set on insert from the parsed domain part of `alias_address`. Used to filter the page by domain and to enforce the mailbox-topology gate. |
| `created_at` | DATETIME | Audit timestamp |

The UNIQUE key on `alias_address` is the reason fan-out isn't supported
here — one inbound address resolves to exactly one destination. To
deliver one inbound address to several mailboxes, use a
[shared mailbox](shared-mailboxes.md) (which gives multiple users
access to a single inbox) or, for true fan-out, use the relay topology
with virtual recipients.

## The two alias types

### Forward

Delivers mail to an existing local mailbox. The mailbox must exist in
the `mailboxes` table — the add handler verifies this with `error 16`
on failure. The `Delivers To` dropdown is sourced from the live
mailbox list (`mailbox_type = 'user'`), so you can only pick a real
target.

```
sales@company.com    →   alice@company.com
support@company.com  →   helpdesk@company.com
```

Both addresses must be on a mailbox domain that this server hosts.
Cross-domain forwards are allowed as long as both sides are local
mailbox domains.

### Discard

Silently drops all mail with no bounce, no DSN, and no error returned
to the sender. The handler hardcodes `delivers_to = 'discard:silently'`,
which Postfix interprets as the discard(8) transport with the literal
nexthop `silently`. Useful for addresses like `noreply@` or
`donotreply@` where bounces would invite spam-mining attempts.

```
noreply@company.com      →   discarded
donotreply@company.com   →   discarded
unsubscribe@company.com  →   discarded
```

> **Operational consequence.** Discard is irrecoverable — there is no
> queue entry, no quarantine, no recovery. The message is accepted by
> Postfix and immediately dropped. Use discard for addresses that
> should never receive replies; do not use it as a quiet alternative
> to bouncing mail you actually want to reject (use Postfix recipient
> restrictions for that).

## Fields on the page

### Add Alias modal

| Field | Notes |
|---|---|
| **Alias Address** | Full email. Must validate as an email, must be on a mailbox domain (`domains.type = 'mailbox'`), and must not already exist as a mailbox, an alias, or a virtual recipient. Conflicts produce errors 12 / 13 / 14 / 17 respectively. |
| **Type** | `Forward (deliver to mailbox)` (default) or `Discard (silently drop all mail)`. JS toggles the Delivers To and Send-As fields based on selection. |
| **Delivers To** | Tom Select typeahead populated from `mailboxes WHERE mailbox_type = 'user'`. Required for forward type, ignored for discard. The handler verifies the target mailbox exists at submit time. |
| **Allow Send-As** | `No` (default) or `Yes`. Only applies to forward type. When `Yes`, an `INSERT IGNORE` into `sender_login_maps` allows the destination mailbox owner to send under the alias address from their existing Submission session. |

### Aliases table

DataTables surface — searchable, sortable, paginated, `stateSave: true`.
Columns:

| Column | Source |
|---|---|
| Actions | Edit (opens modal) / Delete (opens confirmation modal) |
| Alias | `mailbox_aliases.alias_address` |
| Domain | `domains.domain` (joined via `domain_id`) |
| Type | Badge — `Forward` (blue) or `Discard` (dark) |
| Delivers To | `mailbox_aliases.delivers_to` for forwards; `Silently dropped` for discards |
| Send-As | Badge — `YES` / `NO` for forwards; em-dash for discards |

A Domain filter dropdown above the table narrows the visible rows to a
single mailbox domain. The dropdown only lists domains that currently
have at least one alias.

### Edit modal

Address is read-only after creation — changing the local-part would
break any send-as mappings that already reference it. Type, Delivers
To, and Send-As are all editable, with the same forward/discard
toggle behavior as the Add modal. The handler diffs the old send-as
state against the new one and adds or removes the
`sender_login_maps` row accordingly so the change to send-as is
reflected without rewriting unrelated maps.

### Delete

Per-row delete with a confirmation modal. The handler removes the
alias row and any `sender_login_maps` entries for the alias address.
Because aliases don't own a Maildir or any on-disk state, deletion is
instant and reversible only by re-creating the alias.

## Send-As — what it actually does

When Send-As is enabled on a forward alias, the handler inserts:

```sql
INSERT IGNORE INTO sender_login_maps (sender, login_user)
VALUES ('sales@company.com', 'alice@company.com');
```

That row participates in Postfix's `smtpd_sender_login_maps` lookup
on the submission port. The effect: when `alice@company.com` authenticates
to Submission (587) and tries to send a message with `From:
sales@company.com`, Postfix accepts the From: because the
`(sender, login_user)` pair exists in the map. Without Send-As,
Postfix's `reject_sender_login_mismatch` would reject the submission
because `alice@` is not the canonical owner of `sales@`.

This makes Send-As a true alternate-identity grant, not just a "vanity
From:". The user typically configures the alias as a secondary
identity in their mail client (Outlook → Account Settings → multiple
email addresses; Apple Mail → Edit Email Addresses; Thunderbird →
Manage Identities) and picks it from the From: dropdown when composing.

The deletion handler removes the matching `sender_login_maps` row
when the alias is deleted; the edit handler removes the old row and
inserts the new one when Send-As is toggled or Delivers To changes.

## Conflict checks at insert time

The add handler runs four duplicate checks before the INSERT:

| Check | Error | What it prevents |
|---|---|---|
| `mailboxes WHERE username = alias_address` | 13 | Alias collides with an actual mailbox. The mailbox itself would always win the lookup, so the alias would be dead weight. |
| `mailbox_aliases WHERE alias_address = alias_address` | 14 | Duplicate alias row (also enforced by the UNIQUE key, but caught earlier with a friendlier message). |
| `virtual_recipients WHERE virtual_address = alias_address` | 17 | Alias collides with a relay-topology virtual recipient. The UNION lookup would return both rows and the resulting fan-out is almost never the intent — the error tells the admin to remove the relay-side row first. |
| `domains WHERE domain = X AND type = 'mailbox'` | 12 | Alias's domain isn't on the mailbox-topology side. Use Virtual Recipients for relay domains. |

All four checks are advisory in the UI sense but enforced server-side
so a forged form post can't bypass them.

## Domain-delete dependency

There is no explicit dependency check on mailbox-domain deletion for
aliases — but mailbox domains are typically not removed unless every
mailbox under them is also being removed, and the alias rows become
orphaned (`domain_id` no longer resolves) rather than actively
harmful. Stale `mailbox_aliases` rows whose `domain_id` no longer
exists are skipped by the page query because of the
`INNER JOIN domains ... AND d.type = 'mailbox'`. Operational best
practice: delete aliases first, then mailboxes, then the domain.

## Failure semantics

| What breaks | What happens |
|---|---|
| Blank alias address in Add | error 10 banner, no DB write |
| Invalid email format | error 11 |
| Domain not in `domains` or not mailbox-type | error 12 |
| Address already exists as a mailbox | error 13 |
| Address already exists as an alias | error 14 |
| Address already exists as a virtual recipient | error 17 |
| Forward type with blank Delivers To | error 15 |
| Delivers To target mailbox doesn't exist | error 16 |
| Edit with missing alias_id | error 20 |
| Edit / delete with stale alias_id | error 21 |
| MySQL `hermes_db_server` down | Postfix `virtual_alias_maps` lookups fail. Default behavior is to defer affected mail with a temporary error and retry — legitimate mail is held, not bounced. |

## Files and containers touched

| Path | Owner | Role |
|---|---|---|
| `config/hermes/var/www/html/admin/2/view_mailbox_aliases.cfm` | `hermes_commandbox` | Page + table + Add / Edit / Delete modals |
| `config/hermes/var/www/html/admin/2/inc/add_mailbox_alias_action.cfm` | `hermes_commandbox` | Add handler with the four-way conflict check |
| `config/hermes/var/www/html/admin/2/inc/edit_mailbox_alias_action.cfm` | `hermes_commandbox` | Edit handler — toggles `sender_login_maps` on send-as changes |
| `config/hermes/var/www/html/admin/2/inc/delete_mailbox_alias_action.cfm` | `hermes_commandbox` | Delete handler — removes alias row + any send-as map entry |
| `config/hermes/var/www/html/admin/2/inc/get_mailbox_alias_json.cfm` | `hermes_commandbox` | AJAX endpoint that hydrates the Edit modal |
| `/etc/postfix/mysql-virtual.cf` | `hermes_postfix_dkim` (volume-mounted) | The UNION lookup definition shared with `virtual_recipients` |
| `mailbox_aliases`, `sender_login_maps`, `mailboxes`, `domains`, `virtual_recipients` | `hermes_db_server` | Storage and conflict-detection tables |

Nothing on this page shells out to Postfix — no `postmap`, no
`postfix reload`, no template regeneration. The MySQL lookup picks up
new rows on the next inbound message.

## Related

- [Email Relay > Virtual Recipients](../02-email-relay/virtual-recipients.md)
  — the relay-topology equivalent. Use that page when the destination
  is external (Gmail, partner domain) or when fan-out to multiple
  destinations from one address is needed.
- [Domains](domains.md) — the mailbox-domain list this page filters
  against. An alias's domain must exist there with `type = 'mailbox'`.
- [Mailboxes](mailboxes.md) — the destination mailbox list. The
  Delivers To dropdown is populated from active user mailboxes.
- [Shared Mailboxes](shared-mailboxes.md) — when several users need
  to read the same incoming mail (rather than one user receiving
  forwards), use a shared mailbox instead of a forward alias.
- [Mailbox Rules](mailbox-rules.md) — Sieve-based filtering that runs
  on the destination mailbox after alias rewrite. Aliases route mail
  to a mailbox; Sieve rules then sort it within that mailbox.
- [Settings](settings.md) — the global Email Server toggles. Aliases
  work regardless of the Mailbox Sharing master switch — they have no
  Dovecot-side configuration to be gated on.
- [Authentication Settings](../01-system/authentication-settings.md)
  — Submission-port authentication that the Send-As flag piggybacks
  on. A user must be able to authenticate to Submission as their
  primary address before Send-As lets them switch identities.
