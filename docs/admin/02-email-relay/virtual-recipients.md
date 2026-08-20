# Virtual Recipients

Admin path: **Email Relay > Virtual Recipients** (`view_virtual_recipients.cfm`,
`inc/addvirtualrecipients.cfm`, `inc/editvirtualrecipient.cfm`,
`inc/delete_virtual_recipients.cfm`).

This page manages **forward-only address aliases** on the relay-topology
domains configured under [Domains](domains.md). Each row in the
`virtual_recipients` table maps one inbound address (or a domain-wide
catch-all) to one delivery address, and an address that delivers to
several destinations simply has several rows. The delivery target can be
internal to Hermes, on another relay domain, on a mailbox domain, or
anywhere on the public Internet. The rows are consumed by Postfix's
`virtual_alias_maps`, which concatenates every row it gets back into a
single recipient list, so one inbound message fans out to all of them and
the forward stays transparent to the original sender.

Virtual recipients have **no SMTP authentication, no IMAP/POP3 access,
and no password**. They are not user accounts. They are rewrite rules.

## Not the same as Mailbox Aliases

The Email Server topology has its own alias page — [Email Server >
Aliases](../03-email-server/aliases.md), backed by the `mailbox_aliases`
table — and it serves a different need. The add handler enforces the
separation explicitly: trying to add a virtual recipient for a domain
flagged as `mailbox` is rejected with the "use Email Server > Aliases"
hint.

| | Virtual Recipients | Mailbox Aliases |
|---|---|---|
| Table | `virtual_recipients` | `mailbox_aliases` |
| Domain type | Relay domains (`domains.type = 'relay'` or NULL) | Mailbox domains (`mailbox_domains.*`) |
| Delivery target | Anywhere — internal or external | A local Dovecot mailbox |
| Resolved by | Postfix `virtual_alias_maps` (MySQL lookup) | Postfix `virtual_alias_maps` (same query, different table) |
| Auth, IMAP, password | No | No (the resolved mailbox owns those) |
| Typical use | `info@company.com → admin@company.com, info@externalpartner.example` | `support@company.com → user1@company.com` (where `user1@` is a local mailbox) |

The shared `mysql-virtual.cf` lookup is a `UNION` across both tables:

```sql
SELECT maps          FROM virtual_recipients WHERE virtual_address = '%s'
UNION
SELECT delivers_to   FROM mailbox_aliases    WHERE alias_address   = '%s'
```

Postfix doesn't care which table the answer comes from — but the admin
UI separates them so the rule for each topology stays focused.

## Storage and lookup path

The order of these steps matters, and it is not the obvious one. The
**rewrite is deferred until after content filtering**, because `main.cf`
sets `receive_override_options = no_address_mappings` globally, which
disables virtual alias expansion in the cleanup that runs for mail arriving
on port 25. The map is still consulted at `smtpd` to decide whether the
recipient exists, but the envelope keeps the original address through the
filter.

```
inbound SMTP (port 25) ──► hermes_postfix_dkim
                                  │
                                  │  smtpd checks: helo, sender, recipient
                                  │  recipient VALIDATED against
                                  │  relay_recipient_maps / virtual_alias_maps
                                  │       ◄── mysql:/etc/postfix/mysql-virtual.cf
                                  │            │
                                  │            ▼
                                  │  ┌────────────────────────────────────┐
                                  │  │ hermes_db_server                   │
                                  │  │  SELECT maps FROM virtual_recipients│
                                  │  │   UNION                            │
                                  │  │  SELECT delivers_to FROM           │
                                  │  │   mailbox_aliases                  │
                                  │  └────────────────────────────────────┘
                                  │
                                  │  cleanup runs with no_address_mappings,
                                  │  so the recipient is NOT rewritten yet
                                  ▼
              content filter (amavis on 10021)
              policy keyed on the ORIGINAL virtual address
                                  │
                                  ▼
                         hermes_ciphermail
                                  │
                                  ▼
              reinjection on :10026, which overrides
              receive_override_options and therefore DOES
              expand virtual_alias_maps
                                  │
                                  ▼
                          rewritten recipient(s)
                                  │
                                  ▼
                       outbound or local delivery
```

No file regeneration is required when virtual recipients change. The
MySQL lookup is live — adding a row in the admin UI takes effect on
the next inbound message, with zero Postfix restart or postmap step.
This is the operational reason virtual aliases are stored in MySQL
rather than a hash file.

## The `virtual_recipients` table

| Column | Type | Role |
|---|---|---|
| `id` | INT PK | Surrogate key for the row |
| `virtual_address` | VARCHAR(255) | The address being rewritten. Full email (`info@example.com`) **or** a catch-all token (`@example.com`). |
| `maps` | VARCHAR(255) | Destination address. One per row; an address delivering to several destinations has one row each, and Postfix concatenates them. |
| `alias_type` | VARCHAR(20) | Defaults to `forward`. Reserved for future per-alias behavior flags; not surfaced in the UI today. |
| `send_as` | TINYINT(3) | Reserved for outbound "send-as" support (allow the destination to send mail as the virtual address). Not wired through Postfix yet. |
| `policy_id` | INT | Reserved for per-alias Amavis policy attachment. Not surfaced today. |
| `system` | INT | Provenance marker — `1` = seeded by the install/system-addresses flow (postmaster/abuse/root), `2` = admin-created via this page. The system rows are managed by `update_system_email_addresses.cfm` and recreated when the admin email or postmaster changes. |

There is no UNIQUE constraint on `virtual_address`, because a single
inbound address fans out to several destinations by holding one row each.

There is deliberately no unique key on the `(virtual_address, maps)` pair
either, even though `mailbox_aliases` gained one in v260815. Existing
installs may already hold exact duplicates, and `ADD UNIQUE` would abort
the whole schema upgrade on the first one it met. The console is the guard
instead: **Add refuses an address that already exists**, so a duplicate
pair cannot be created through the UI.

## Two address shapes — specific and catch-all

### Specific aliases

A regular forward of one address to one destination:

```
info@company.com       →   owner@company.com
sales@company.com      →   sales-team@externalcrm.example
legal@company.com      →   external-counsel@lawfirm.example
```

The local-part is rewritten by Postfix **after** content filtering, at the
`:10026` reinjection listener. The recipient never sees the original
`info@`/`sales@`/`legal@` address unless the destination mail system
surfaces the original envelope.

### Catch-alls

A single row starting with `@` matches every local-part on the domain
that is **not** already a more specific virtual recipient or a mailbox:

```
@company.com           →   admin@company.com
```

With the catch-all row above, mail to `jdoe@company.com`,
`random-string@company.com`, and `does-not-exist@company.com` all
forward to `admin@company.com`. Specific aliases on the same domain
(`info@company.com → owner@company.com`) win over the catch-all because
they match the more specific lookup key first.

Catch-alls are useful for sunset domains, migration phases, or small
domains where one mailbox owner is willing to receive everything. They
are not appropriate for high-volume domains: every spam attempt against
a random local-part lands in the catch-all destination.

### Catch-all visibility in the user portal

A user whose mailbox is the **destination** of a catch-all (e.g.,
`admin@company.com` above) has a special branch in the user portal's
Quarantined Messages, Total Messages, and Message History queries.
`config/hermes/var/www/html/users/2/index.cfm`,
`view_message.cfm`, and `view_message_history.cfm` all consult
`virtual_recipients` for catch-all entries that explicitly map TO the
logged-in user, then widen the query with a `LIKE '%@domain.tld'`
clause so the user sees the messages that were swept up by the
catch-all. Specific aliases do **not** get this treatment yet — a
known parity gap for the rare case where one user owns many specific
aliases and wants the same widened visibility.

## Fields on the page

### Add Virtual Recipient modal

Opened by the **Add Virtual Recipient** button above the table. One
address per submission, matching
[Email Server > Aliases](../03-email-server/aliases.md).

| Field | Notes |
|---|---|
| **Virtual Address** | One full email address or a `@domain.com` catch-all. Lowercased and trimmed. |
| **Delivers To** | One or more destinations, entered as removable chips. Typing searches existing relay recipients through `inc/getintrecipients.cfm`; any other address can be typed in and accepted on Enter. One row is written per chip. |

Because a submission carries exactly one address, it produces exactly one
verdict, reported as a single message rather than a tally:

| Condition | Message |
|---|---|
| Virtual Address blank | 1 |
| Delivers To empty | 2 |
| A destination is not a valid email | 3 |
| Address is neither a valid email nor a `@domain` catch-all | 4 |
| Domain not configured in the system | 5 |
| Domain is a mailbox domain (use Email Server > Aliases) | 6 |
| Address already exists as a mailbox alias | 7 |
| Address already exists as a virtual recipient (use Edit) | 8 |

Until v260815 this was a newline-delimited textarea creating many
addresses at once. That shape forced every outcome to be an accumulating
per-row tally across four separate callouts, and it meant an address that
already existed could only be reported rather than refused, because other
rows in the same batch still had to process. The trade for the simpler
model is that creating several addresses now takes several submissions.

### Virtual Recipients table

Standard DataTables surface: searchable, sortable, exportable
(copy / CSV / Excel / PDF / print), `stateSave: true` so column order
and page size persist across reloads. Rows are **grouped by address**, so
an entry with twenty destinations is one row with twenty chips.

| Index | Column | Source |
|---|---|---|
| 0 | Actions | Edit and Delete. Not sortable or searchable |
| 1 | Recipient | `virtual_recipients.virtual_address` |
| 2 | Delivers To | Display-only chips, one per destination, external ones badged |

Actions sits on the left to match Aliases. Note for anyone changing this
table: `order` and `columnDefs` are index-based and `stateSave` persists
the sort by index, so inserting or removing a column requires updating
both plus the `stateLoadParams` guard.

### Edit modal

Edits the whole entry, keyed on the address rather than a row id. The
destination set opens as removable chips and the save is a **diff**:
insert what is new, delete what was taken off, leave the rest untouched.
Diffing rather than delete-then-reinsert means there is never a moment
when the address has no destinations. Re-runs the same domain validation
and catch-all detection as Add, including the rejection of mailbox-domain
rows.

Adding and removing destinations happens here and only here. Add creates.

### Delete

One Delete button per row, confirmed in a modal that names the address and
its destination count. The row carries `dest_ids`, every underlying row id
for that address comma-joined by the grouped query, and the handler
(`delete_virtual_recipients.cfm`) runs `DELETE FROM virtual_recipients
WHERE id = ?` per id, so one click removes the address and all of its
destinations together. There is no dependency check, because nothing else
in the schema points back at a virtual recipient row.

The select-all checkbox column and its bulk **Delete Selected** button were
removed in v260815. They existed because the pre-grouping table rendered
one row per destination, so an address with a large destination set filled
the screen and needed bulk selection to clear.

## Virtual recipients are content filtered

They are filtered exactly like any other inbound mail. This section
previously claimed the opposite, and the page carried a callout saying
mail through a virtual recipient was delivered "while bypassing ALL
content checking (spam, virus, banned files)". Both were wrong. The
wording traced back to `build-220203` and described no part of this
pipeline. Removed in v260815.

Three independent reasons it was never true:

1. **`content_filter` is global.** `main.cf` sets
   `content_filter = amavis:[hermes_mail_filter]:10021` with no
   per-recipient exception. The only bypass lane in the system is
   `:10030`, the `BYPASSALLCHECKS` policy bank, and it is reachable only
   through a `FILTER` action set by
   [Global Sender Block/Allow](../04-content-checks/global-sender-rules.md),
   which is keyed on the **sender**.
2. **Amavis sees the original address.** Because
   `receive_override_options = no_address_mappings` defers expansion past
   the filter, the envelope recipient reaching Amavis is the virtual
   address itself, not the destination. There is no "post-rewrite
   recipient" for policy to key on at that point.
3. **A domain-scoped policy always matches.** Adding a domain inserts an
   `@domain` row into `recipients` carrying the default policy, and
   Amavis's recipient lookup falls back from `user@domain` to `@domain`.
   The code that does it says so: "ensures Amavis applies SVF filtering to
   all mail for this domain."

Amavis also classifies the mail correctly as inbound, because
`@local_domains_maps` reads `/etc/postfix/relay_domains` and the virtual
address is on one by definition, since the Add handler refuses any domain
that is not configured.

The real caveat with virtual recipients is not filtering, it is
**forwarding**. Mail leaves with the original sender's address, so SPF
fails at the receiving end, and if the message was modified on the way
through, by an External Banner or LinkGuard, the original DKIM signature
no longer validates either. Senders publishing a strict DMARC policy can
therefore have mail to external destinations rejected. That warning lives
in the Add modal, beside the field it applies to.

## Domain-delete dependency

Deleting a relay domain via [Domains](domains.md) is blocked when virtual
recipients reference it. `deletedomain.cfm` runs:

```sql
SELECT * FROM virtual_recipients WHERE virtual_address LIKE '%<domain>%'
```

Any match aborts the domain delete with error code 2 and the admin must
clear the matching rows from this page before the domain can be removed.
The same back-pressure protects against silently stranding a forward
when its destination domain disappears.

## System-managed rows

A few rows in `virtual_recipients` are created and managed by the
**System > Server Setup** flow, not by this page directly:

| Pattern | Created by |
|---|---|
| `postmaster@<every-domain>` → admin email | `inc/update_system_email_addresses.cfm` on every Server Setup save |
| `root@<every-domain>` → admin email | Same |
| `abuse@<every-domain>` → admin email | Same |

These rows are marked `system = '1'` (the install/system flow) versus
admin-created rows which are marked `system = '2'`. Editing or
deleting a system-managed row from this page works mechanically, but
the row will be recreated on the next Server Setup save. Edit the
admin email there if you want a different destination for these
reserved local-parts; do not maintain them by hand here.

## Failure semantics

| What breaks | What happens |
|---|---|
| Virtual address blank in Add | error 1 banner, no DB write |
| Delivers To blank or invalid email in Add | error 2/3 banner, no DB write |
| Edit virtual address fails email or catch-all format | `session.m = 10`, redirect, no DB write |
| Edit Delivers To blank or invalid | `session.m = 11`/`12`, redirect, no DB write |
| Domain not in `domains` table | `session.m = 13` on edit; `errormessage = 5` on add, nothing written |
| Domain is a mailbox domain | `errormessage = 6` on add, with the "use Email Server > Aliases" hint |
| Address already exists in `mailbox_aliases` | `errormessage = 7` on add |
| Address already exists in `virtual_recipients` | `errormessage = 8` on add, pointing at Edit; `session.m = 14` on edit |
| Delete request carries no id | `session.m = 1` banner, no DB write |
| MySQL `hermes_db_server` down | Postfix `virtual_alias_maps` lookups fail. By default Postfix defers mail to the affected recipients with a temporary error and retries on the next queue run; legitimate mail is held, not bounced. |

## Bulk import

There is no bulk path. Add creates one address per submission.

Until v260815 the Add card was a newline-delimited textarea and pasting
many addresses at once was the practical bulk route. It was removed
because a submission carrying many addresses can only report a per-row
tally, which is what forced the page's four accumulating callouts and
made it impossible to simply refuse an address that already existed.
Fan-out in the other direction, one address to many destinations, is
unaffected and is entered as chips.

If a bulk path is wanted again it should be a real import with its own
report, not a shared text field whose failure mode is a tally.

## Files and containers touched

| Path | Owner | Role |
|---|---|---|
| `config/hermes/var/www/html/admin/2/view_virtual_recipients.cfm` | `hermes_commandbox` | Page + Add card + table + modals |
| `config/hermes/var/www/html/admin/2/inc/addvirtualrecipients.cfm` | `hermes_commandbox` | Add handler with per-line validation |
| `config/hermes/var/www/html/admin/2/inc/editvirtualrecipient.cfm` | `hermes_commandbox` | Edit handler |
| `config/hermes/var/www/html/admin/2/inc/delete_virtual_recipients.cfm` | `hermes_commandbox` | Delete handler (per selected id) |
| `config/hermes/var/www/html/admin/2/inc/getintrecipients.cfm` | `hermes_commandbox` | Autocomplete source for the Delivers To field |
| `config/hermes/var/www/html/admin/2/inc/update_system_email_addresses.cfm` | `hermes_commandbox` | Manages the `system = '1'` rows (postmaster/root/abuse) |
| `/etc/postfix/mysql-virtual.cf` | `hermes_postfix_dkim` (volume-mounted) | Postfix MySQL lookup definition for `virtual_alias_maps` |
| `virtual_recipients`, `mailbox_aliases`, `domains` | `hermes_db_server` | The lookup tables and the domain-type gate |

Nothing on this page shells out to Postfix — there is no postmap, no
`postfix reload`, no template regeneration. The MySQL lookup is the
only integration surface.

## Related

- [Domains](domains.md) — the relay-topology domain list these aliases
  attach to. Domain deletes are blocked when virtual recipients still
  reference the domain.
- [Relay Recipients](relay-recipients.md) — recipient validation for
  domains with Recipient Delivery = SPECIFIED. A specific relay
  recipient and a virtual recipient can coexist for the same address;
  the relay recipient wins for recipient-list validation, the virtual
  recipient still rewrites at delivery.
- [Email Server > Aliases](../03-email-server/aliases.md) — the mailbox-
  topology equivalent. Aliases for domains where Hermes is the
  destination MTA live there.
- [Email Server > Shared Mailboxes](../03-email-server/shared-mailboxes.md)
  — when several users need to read the same incoming mail (not just
  one user receiving forwards), use a shared mailbox instead of a
  fan-out virtual recipient.
- [Server Setup](../01-system/server-setup.md) — manages the
  `system = '1'` postmaster/root/abuse forwards. Change the admin email
  there to retarget those reserved local-parts.
