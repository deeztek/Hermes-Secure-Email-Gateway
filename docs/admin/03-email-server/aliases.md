# Aliases

Admin path: **Email Server > Aliases** (`view_mailbox_aliases.cfm`,
`inc/add_mailbox_alias_action.cfm`, `inc/edit_mailbox_alias_action.cfm`,
`inc/delete_mailbox_alias_action.cfm`, `inc/get_mailbox_alias_json.cfm`).

This page manages **alternate email addresses for local mailboxes** on
the Email Server topology. Each row in the `mailbox_aliases` table maps
one inbound address (e.g., `sales@company.com`) to one destination, or
to Postfix's discard transport for silent disposal.

An alias may have **several destinations**, one row each, in which case
Postfix concatenates them into a single recipient list and one inbound
message fans out to all of them. That is what a distribution list is
here: an alias with more than one destination, not a separate concept
with its own page. Destinations do not have to be local mailboxes; any
valid address is accepted, including addresses outside your own domains,
with the forwarding caveats described under
[External destinations](#external-destinations).

Aliases have **no SMTP authentication, no IMAP/POP3 access, and no
password of their own**. They are rewrite rules consumed by Postfix.

Two capabilities that used to live on this page have moved:

- **Send-As** is granted per mailbox, under
  [Mailboxes](mailboxes.md) > Actions > Send As. See
  [Send-As moved to the mailbox](#send-as-moved-to-the-mailbox).
- **Adding destinations to an existing alias** happens in the Edit
  modal. Add creates an alias and refuses an address that already
  exists.

## Not the same as Virtual Recipients

Email Server aliases and Email Relay virtual recipients share the same
underlying Postfix lookup but enforce different topology rules. See
[Virtual Recipients](../02-email-relay/virtual-recipients.md) for the
full distinction; the short version:

| | Mailbox Aliases (this page) | Virtual Recipients |
|---|---|---|
| Table | `mailbox_aliases` | `virtual_recipients` |
| Domain type | Mailbox domains (`domains.type = 'mailbox'`) | Relay domains (`domains.type = 'relay'` or NULL) |
| Delivery target | Anywhere: a local Dovecot mailbox, any other address, or `discard:silently` | Anywhere, internal or external |
| Several destinations | Yes, one row each | Yes, one row each |
| UNIQUE constraint | `uq_alias_dest` on the `(alias_address, delivers_to)` pair | None; the console is the guard |
| Reachable By (`internal_only`) | Supported | Not supported, and deliberately so |
| Send-As | Granted per mailbox, not here | Vestigial schema flag, nothing reads it |
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

The order here is not the obvious one. `main.cf` sets
`receive_override_options = no_address_mappings` globally, which disables
virtual alias expansion in the cleanup that runs for mail arriving on port
25. The map is still consulted at `smtpd` to decide whether the recipient
exists, but the **rewrite is deferred until after content filtering**, at
the `:10026` reinjection listener which overrides that setting.

```
inbound SMTP (port 25) ──► hermes_postfix_dkim
                                  │
                                  │  smtpd: helo, sender, recipient checks
                                  │  recipient VALIDATED against
                                  │  virtual_alias_maps
                                  │     ◄── mysql:/etc/postfix/mysql-virtual.cf
                                  │          │
                                  │          ▼
                                  │  ┌──────────────────────────────────┐
                                  │  │ hermes_db_server                 │
                                  │  │  UNION across virtual_recipients │
                                  │  │   and mailbox_aliases            │
                                  │  └──────────────────────────────────┘
                                  │
                                  │  check_recipient_access on the
                                  │  internal-only map may REJECT here
                                  │
                                  │  cleanup runs with no_address_mappings,
                                  │  so the recipient is NOT rewritten yet
                                  ▼
                       amavis (10021), then hermes_ciphermail
                                  │
                                  ▼
                    reinjection on :10026, which DOES
                    expand virtual_alias_maps
                                  │
                                  ▼
                     rewritten recipient(s), one per row
                                  │
                  ┌───────────────┴────────────────┐
                  │                                │
       forward (delivers_to =          discard (delivers_to =
       one or more destinations)       'discard:silently')
                  │                                │
                  ▼                                ▼
       LMTP → hermes_dovecot            discard(8) transport
       for local destinations,                    │
       onward SMTP for external                   ▼
                                       message silently dropped
                                       no bounce, no DSN, no log entry
                                       beyond the queue acceptance
```

The MySQL lookup is live: adding a row in this page takes effect on
the next inbound message, with no Postfix reload, no `postmap`, and
no template regeneration.

**Reachable By is the exception.** The `check_recipient_access` map that
enforces it is referenced from `smtpd_recipient_restrictions` in
`main.cf`, so on an install upgraded from an earlier release the setting
is inert until Postfix settings are saved once, which regenerates
`main.cf` from its template.

## The `mailbox_aliases` table

| Column | Type | Role |
|---|---|---|
| `id` | INT PK | Surrogate key |
| `alias_address` | VARCHAR(255) | The address being rewritten. Full email only, no catch-all syntax. Indexed by `idx_alias_address`, which is what Postfix looks it up by. Repeats across rows when an alias has several destinations. |
| `delivers_to` | VARCHAR(255) | One destination. For `alias_type = 'forward'` this is any valid address, local or external; for `alias_type = 'discard'` it is hardcoded to the literal string `discard:silently`, which Postfix routes through the discard(8) transport. |
| `alias_type` | VARCHAR(20) | `forward` (default) or `discard`. Belongs to the **address**, so every row for one alias carries the same value. |
| `internal_only` | TINYINT(3) | `1` if only senders inside your own domains may mail this address. Also a property of the address, written across every row for it. Defaults to `0`. |
| `send_as` | TINYINT(3) | **Vestigial.** Nothing reads it. Send-As is granted per mailbox now. The column is still written on insert so existing rows keep their value; dropping it is a later cleanup with no urgency. |
| `domain_id` | INT | FK to `domains.id`; set on insert from the parsed domain part of `alias_address`. Used to filter the page by domain and to enforce the mailbox-topology gate. |
| `created_at` | DATETIME | Audit timestamp. Survives an edit on rows that did not change, because the save is a diff rather than a rewrite. |

### Why the UNIQUE key changed

Until v260815, `uq_alias_address` made `alias_address` unique, which
pinned an alias to exactly one row and therefore one destination.
Dropping that key is what allows several destinations, and it is the only
schema change the feature needed.

It was also the index Postfix used for every lookup, since
`mysql-virtual.cf` queries `WHERE alias_address = '%s'` on each message.
Dropping it without a replacement would have turned every alias lookup
into a full table scan, so `idx_alias_address` took its place.

The rule that replaced "one row per address" is "no exact duplicate
pair", enforced by `uq_alias_dest` on `(alias_address, delivers_to)`.
Existing data satisfied it by construction, since `alias_address` was
unique until the moment the key was dropped.

Note that the equivalent key was deliberately **not** added to
`virtual_recipients`. Existing installs may already hold exact duplicates
there, and `ADD UNIQUE` would abort the whole schema upgrade on the first
one it met.

## The two alias types

### Forward

Delivers mail to one or more destinations. The `Delivers To` picker is
populated from the live mailbox list (`mailbox_type = 'user'`) so a real
target can be chosen from a list, but any valid address can be typed in
instead.

```
sales@company.com    →   alice@company.com
support@company.com  →   helpdesk@company.com, alice@company.com,
                         oncall@partner.example
```

The **alias address** must be on a mailbox domain that this server hosts.
Destinations have no such restriction: cross-domain and external
destinations are both allowed.

The old requirement that every destination already exist in the
`mailboxes` table (`error 16`) is gone. It made external forwarding
impossible on mailbox domains while relay domains allowed it freely,
which was an inconsistency rather than a policy.

### Distribution lists

A distribution list is an alias with more than one destination. There is
no separate page, no separate table, and no separate concept to learn.

Add accepts several destinations at once; Edit shows the whole set as
removable chips and diffs the save. The table groups by address, so a
twenty-member list is one row with twenty chips rather than twenty
near-identical lines.

Consider setting **Reachable By** to internal-only on any list with
external destinations. Without it, one message from anyone on the
internet becomes twenty outbound messages relayed by this gateway.

### External destinations

Any valid address is accepted as a destination, and external ones are
badged wherever they appear, both in the table and in the Add and Edit
modals. The badge is deliberate: the person auditing an alias in six
months is not the person who created it.

The caveats are real and worth stating to whoever asks for the forward:

- Forwarded mail leaves with the **original sender's address**, so SPF
  fails at the receiving end.
- If the message was modified on the way through, by an External Banner
  or LinkGuard for instance, the **original DKIM signature no longer
  validates** either.
- Senders whose domain publishes a strict DMARC policy can therefore have
  mail to those destinations rejected.

Local destinations are unaffected by all three.

### Reachable By (internal-only addresses)

Controls who may send **to** an address, which is a different question
from where that address delivers. `Anyone` is the default and matches the
behaviour every alias had before v260815. `Only senders in your own
domains` rejects mail from outside.

Enforced by a `check_recipient_access mysql:` map in
`smtpd_recipient_restrictions`, following the discard-recipients map
already in that chain. `permit_mynetworks` short-circuits ahead of it, so
anything reaching the map arrived from outside and a plain `REJECT` is
correct. No sender-domain test is used, because trusting an
unauthenticated claim to be from your own domain would be worse than
useless on a gateway.

The map uses `SELECT DISTINCT`. A twenty-member alias matches twenty rows,
and without it Postfix would concatenate twenty `REJECT` strings into one
malformed action.

Two limits worth knowing:

- **Catch-alls cannot be internal-only.** Postfix probes access maps by
  bare domain, and this page does not support catch-all syntax anyway.
- **Relay domains do not have this setting at all**, deliberately. A relay
  domain exists so the internet can send to it, and the customer's own
  users never traverse this gateway for same-domain mail because their
  server is authoritative and resolves it locally. Internal-only there
  would reject the only traffic that arrives and permit traffic that never
  does.

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
| **Alias Address** | Full email. Must validate as an email, must be on a mailbox domain (`domains.type = 'mailbox'`), and must not already exist as a mailbox, an alias, or a virtual recipient. Conflicts produce errors 13 / 14 / 17, and a non-mailbox domain produces 12. |
| **Type** | `Forward (deliver to mailbox)` (default) or `Discard (silently drop all mail)`. JS toggles the Delivers To field based on selection. |
| **Delivers To** | Tom Select chips, **one or more**. The option list comes from `mailboxes WHERE mailbox_type = 'user'`, so clicking the field offers real targets, and any other address can be typed and accepted on Enter. Splits on comma, semicolon, whitespace and newline so a pasted list works. One row is written per chip. Required for forward, ignored for discard. |
| **Reachable By** | `Anyone` (default) or `Only senders in your own domains`. See [Reachable By](#reachable-by-internal-only-addresses). |

Add **creates**. An alias address that already exists is refused with
error 14, pointing at that row's Edit button. Routing both operations
through Add gave two ways to do one thing and produced an answer nobody
could act on: submitting an existing address whose destinations were all
already stored could only report that nothing had changed.

### Aliases table

DataTables surface: searchable, sortable, paginated, `stateSave: true`.
Rows are **grouped by address**, so an alias with twenty destinations is
one row with twenty chips.

| Column | Source |
|---|---|
| Actions | Edit and Delete, both operating on the whole alias |
| Alias | `mailbox_aliases.alias_address` |
| Domain | `domains.domain` (joined via `domain_id`) |
| Type | Badge, `Forward` (blue) or `Discard` (dark), plus a count badge when there is more than one destination |
| Delivers To | Display-only chips, one per destination, external ones badged |
| Reachable By | Badge, `Internal only` or `Open`. Read with `MAX(internal_only)` so a mixed state, which should not arise, reads as restricted rather than open |

A Domain filter dropdown above the table narrows the visible rows to a
single mailbox domain. The dropdown only lists domains that currently
have at least one alias.

Note for anyone changing this table: `order` and `columnDefs` are
index-based and `stateSave` persists the sort by index, so inserting or
removing a column means updating both.

### Edit modal

Owns the alias's **whole destination set**. The modal shows every
destination as a removable chip and submits the set you want to end up
with, so the save is a **diff**: insert what is new, delete what was
taken off, leave the rest untouched.

Diffing rather than delete-then-reinsert matters for three reasons. There
is never a moment when the alias has no destinations and mail would
bounce, `created_at` survives on members that did not change, and a
failure partway through cannot leave the alias empty.

Adding and removing destinations happens here and only here.

The address is read-only after creation, so an edit can never split a
grouped alias by renaming one row out of it. Type belongs to the address:
converting to Discard deletes every real destination and replaces them
with the single pseudo-destination, which cannot be done with an `UPDATE`
because setting them all to `discard:silently` would collide with
`uq_alias_dest` as soon as there was more than one row. The page warns
before a conversion discards a multi-destination list.

`send_as` is deliberately **not** written by this handler. Its control is
gone from the modal, so a `cfparam` default of `0` would silently zero the
column on every edit.

### Delete

Per-row delete with a confirmation modal, naming the alias and its
destination count. Removes every row for the address, plus any
`sender_login_maps` entries for it. Because aliases don't own a Maildir or
any on-disk state, deletion is instant and reversible only by re-creating
the alias.

## Send-As moved to the mailbox

Send-As is granted under [Mailboxes](mailboxes.md) > Actions > Send As,
not on this page. There is no Send-As control in the Add or Edit modal.

**Why it moved.** A single Yes/No toggle on an alias worked while an alias
had exactly one destination. It stopped making sense the moment an alias
could have twenty, because one toggle would have granted send-as to every
member of a list at once, with no way to say "these three may, the other
seventeen may not". Membership and identity are separate questions.
`sender_login_maps` now has exactly one writer.

The grant itself is unchanged. Selecting an alias for a mailbox inserts:

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
From:".

### Granting is necessary but not sufficient

**The grant alone changes nothing the user can see.** No mail protocol
exposes send-as permissions to a client, so the user must also add the
address as an identity in whatever they read mail with. Until they do,
the From: field stays a plain label and the alias is nowhere to be
found.

This is the single most common support question after a grant, and it
looks exactly like the grant not working:

| Client | Where the user adds it |
|---|---|
| Webmail (Nextcloud Mail) | **Mail > Account settings > Aliases > Add alias** |
| Thunderbird | **Account Settings > Manage Identities > Add** |
| Outlook | Account Settings, additional email addresses |
| Apple Mail | Account settings, Edit Email Addresses |

In every case the From: field only becomes a dropdown once the account
has more than one identity.

Worth knowing about the failure mode in the other direction: a user can
add an identity for an address they have **not** been granted. The client
accepts it happily and Postfix refuses the message at submission with
`Sender address rejected: not owned by user ...`. That is
`reject_sender_login_mismatch` doing its job, and it is also a clean way
to verify the grant is genuinely being enforced rather than submission
being open to any From: address.

The user-facing version of this is in
[Set Up Your Devices](../../users/set-up-your-devices.md), under
"Sending from an alias".

Grants are scoped to aliases on the mailbox's own domain, re-derived
server-side rather than trusted from the form.

**Consequence worth knowing:** changing an alias's destination no longer
moves the send-as grant with it. That is intentional. The grant says
"this mailbox may send from this address", which has nothing to do with
where the address happens to deliver, so silently transferring it on a
destination change would be wrong. Deleting the alias still revokes the
grant.

## Conflict checks at insert time

The add handler runs four duplicate checks before the INSERT:

| Check | Error | What it prevents |
|---|---|---|
| `mailboxes WHERE username = alias_address` | 13 | Alias collides with an actual mailbox. The mailbox itself would always win the lookup, so the alias would be dead weight. |
| `mailbox_aliases WHERE alias_address = alias_address` | 14 | The alias already exists. Add creates; changing an existing alias, including adding and removing destinations, is the Edit modal's job, and the message says so. Note the database no longer backs this check: v260815 dropped the UNIQUE key on `alias_address` (that is what allows several destinations) and replaced it with `uq_alias_dest` on the `(alias_address, delivers_to)` pair, so this handler check is the only thing preventing a second alias row for an address that already has one. |
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
| Forward type with blank Delivers To, or a list that deduplicates to nothing | error 15 |
| Any destination is not a valid email address | error 16. Fails the whole submission on the first bad entry rather than silently dropping it and reporting partial success. No longer means "target mailbox doesn't exist"; external destinations are allowed |
| Edit with missing alias_id | error 20 |
| Edit / delete with stale alias_id | error 21 |
| MySQL `hermes_db_server` down | Postfix `virtual_alias_maps` lookups fail. Default behavior is to defer affected mail with a temporary error and retry — legitimate mail is held, not bounced. |

## Files and containers touched

| Path | Owner | Role |
|---|---|---|
| `config/hermes/var/www/html/admin/2/view_mailbox_aliases.cfm` | `hermes_commandbox` | Page + table + Add / Edit / Delete modals |
| `config/hermes/var/www/html/admin/2/inc/add_mailbox_alias_action.cfm` | `hermes_commandbox` | Add handler with the four-way conflict check; writes one row per destination |
| `config/hermes/var/www/html/admin/2/inc/edit_mailbox_alias_action.cfm` | `hermes_commandbox` | Edit handler; diffs the submitted destination set against what is stored |
| `config/hermes/var/www/html/admin/2/inc/delete_mailbox_alias_action.cfm` | `hermes_commandbox` | Delete handler; removes every row for the address plus any send-as map entry |
| `config/hermes/var/www/html/admin/2/inc/get_mailbox_alias_json.cfm` | `hermes_commandbox` | AJAX endpoint that hydrates the Edit modal with the whole destination set |
| `config/hermes/var/www/html/admin/2/inc/edit_mailbox_send_as_action.cfm` | `hermes_commandbox` | The only writer of `sender_login_maps`. Reached from the Mailboxes page |
| `config/hermes/var/www/html/admin/2/inc/get_mailbox_send_as_json.cfm` | `hermes_commandbox` | AJAX endpoint listing aliases on the mailbox's own domain |
| `/etc/postfix/mysql-virtual.cf` | `hermes_postfix_dkim` (volume-mounted) | The UNION lookup definition shared with `virtual_recipients` |
| `/etc/postfix/mysql-internal-only-recipients.cf` | `hermes_postfix_dkim` (volume-mounted) | The `check_recipient_access` map behind Reachable By. Uses `SELECT DISTINCT` |
| `mailbox_aliases`, `sender_login_maps`, `mailboxes`, `domains`, `virtual_recipients` | `hermes_db_server` | Storage and conflict-detection tables |

Nothing on this page shells out to Postfix — no `postmap`, no
`postfix reload`, no template regeneration. The MySQL lookup picks up
new rows on the next inbound message.

## Related

- [Email Relay > Virtual Recipients](../02-email-relay/virtual-recipients.md):
  the relay-topology equivalent. Pick the page by the **alias address's own
  domain**, not by the destination. Both pages now support external
  destinations and fan-out to several destinations, so those are no longer
  the deciding factor. Relay domains additionally support catch-alls;
  mailbox domains additionally support Reachable By and the discard
  transport.
- [Domains](domains.md) — the mailbox-domain list this page filters
  against. An alias's domain must exist there with `type = 'mailbox'`.
- [Mailboxes](mailboxes.md) — the destination mailbox list. The
  Delivers To dropdown is populated from active user mailboxes.
- [Shared Mailboxes](shared-mailboxes.md): when several users need to read
  the same incoming mail, use a shared mailbox rather than an alias. The
  distinction is one copy or many. A shared mailbox is a single inbox
  several people open, so a message read by one is read by all and replies
  come from a common address. A distribution list delivers a separate copy
  into each member's own mailbox, and each acts on it independently.
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
