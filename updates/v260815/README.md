# Hermes SEG v260815

Distribution lists, a cross-tenant disclosure fix, and the first-run fixes that
landed just after v260815's predecessor was tagged.

## Read this first

### Distribution lists, as aliases with more than one destination

An alias can now deliver to several addresses. There is no new page and no new
concept: a distribution list is an alias with more than one destination, so the
pages you already use gained the capability.

- Relay domains: **Email Relay → Relay Recipients → Virtual Recipients**
- Mailbox domains: **Email Server → Mailboxes → Aliases**

Both pages now group by address. An alias with twenty destinations shows as one
row with twenty chips rather than twenty near-identical lines. **Edit** opens the
whole set as removable chips: take one off with its **x**, add one by typing, save
once. Nothing is deleted by editing except what you remove, and the bin on the row
removes the alias entirely.

Relay domains could always express this, because that table never stopped an
address appearing on several rows and Postfix concatenates the rows it gets back
into one recipient list. If you built lists by hand that way, they are already in
the right shape and will simply display grouped. Nothing to redo.

### Destinations outside your own domains are allowed, with a real caveat

Both pages accept external destinations, and flag them wherever they appear.

Forwarded mail leaves with the **original sender's** address, so SPF fails at the
receiving end. If the message was modified on the way through, by an External
Banner or LinkGuard rewriting links, the original DKIM signature no longer
validates either. A sender whose domain publishes a strict DMARC policy can
therefore have mail to your external members rejected. Local destinations are
unaffected by any of this.

This is not new behaviour on relay domains, where external destinations have
always been permitted. It is new on mailbox domains, which previously required
every destination to be an existing local mailbox.

### Reachable By, and why it matters if you use external destinations

Aliases on **mailbox domains** now carry a **Reachable By** setting controlling
who may send *to* them, which is a different question from where they deliver.

Left at **Anyone**, an alias behaves exactly as before. Set to **Only senders in
your own domains**, mail from outside is rejected.

This is what makes external destinations defensible. Without it, an alias fanning
out to twenty external addresses is reachable by anyone on the internet, so one
message in becomes twenty out with your gateway doing the relaying. Worth setting
on any list with external members.

**Not offered on relay domains, deliberately.** A relay domain exists so the
internet can send to it, and the customer's own users never traverse the gateway
for same-domain mail, since their own server is authoritative and resolves it
locally. Restricting a relay address to internal senders would reject the only
traffic that reaches it while permitting traffic that never arrives. A list that
needs restricting belongs on a mailbox domain.

Two limitations: catch-all entries cannot be restricted this way, and on an
**existing** install the setting is stored but not enforced until Postfix
regenerates its configuration. See "What to do" below.

### Send-As moved from the alias to the mailbox

Permission to send using an address is now granted per mailbox, under
**Email Server → Mailboxes → Actions → Send As**, rather than by a Yes/No on the
alias.

It had to move. A single toggle on an alias worked while an alias had one
destination and stopped making sense the moment it could have twenty: it would
have granted send-as to every member of a list at once, with no way to say
"these three may, the others may not".

Membership and send-as are now independent. Adding somebody to a list grants them
nothing, and granting send-as does not require them to be a member.

**Existing grants are unchanged.** One behaviour change worth knowing: editing an
alias's destination no longer moves the grant along with it. That is deliberate,
since the grant now means "this mailbox may send from this address" and has
nothing to do with where the address delivers.

### Nextcloud sharing now stays inside your own domain by default

Two things, and the second is the one that prompted it.

**Isolation.** A gateway can host unrelated organisations side by side. Sharing is
now restricted to members of your own domain, so a user cannot share a file into
another organisation on the same gateway.

**A group-name disclosure, now closed.** Nextcloud Mail's recipient autocomplete
suggested **every group on the instance**, unfiltered by who was asking. Since
Hermes names its Nextcloud groups after domains, a user at one customer could type
part of another customer's domain and have it suggested by name. The
infrastructure groups were visible to every mailbox user too: `admins`,
`mailboxes`, `one_factor`, `two_factor`, `nc_local_admins_2fa`. The installer
already restricted enumeration of **users** for exactly this reason; groups take a
separate path, so that protection had a hole its setting name gave no hint of.

**Sharing with a whole group still works**, within a domain. Only sharing *across*
domains is restricted.

### If you run one organisation across several domains, change this back

This is a default, not a policy. If your gateway serves a single organisation that
happens to use several domains, cross-domain sharing is entirely legitimate and you
will want it back.

Turn it off in Nextcloud under **Administration settings → Sharing → "Restrict
users to only share with users in their groups"**.

Hermes deliberately adds no setting of its own for this, since Nextcloud already
exposes it. Be aware that turning it off also restores the group-name visibility
described above.

Applied automatically to both new and existing installs.

### Two indexes that should have existed

`virtual_recipients` had no index on the column Postfix looks it up by, so every
message caused a full table scan of that table. Unnoticed at a handful of rows,
and about to matter a great deal more now that operators can build twenty-member
lists there. Indexed.

`mailbox_aliases` needed its unique key dropped to allow several destinations, and
that key was doing double duty as the lookup index. Replaced rather than simply
removed, so alias lookups do not degrade.

Tracked in `#311` and `#316`.

### Deleting a certificate always failed, after deleting it

Deleting any certificate ended on a Lucee error page rather than a success
message. The certificate was nonetheless gone: the handler removed it, then
tried to remove its SAN rows from a table that has never existed in this
schema, and threw only after the first statement had committed.

So the operation half happened every time. The certificate and its acme files
were removed, the SAN rows for it were left behind pointing at an id that no
longer resolves, and the admin was shown a stack trace suggesting nothing had
worked.

The handler now uses the real table and column, and deletes the SAN rows before
the certificate rather than after, so any future failure leaves the certificate
intact and the operation retryable.

**This upgrade also cleans up after the bug.** The schema update removes SAN
rows whose certificate no longer exists. If you have ever deleted a certificate
on this install, you have some. Nothing else references them and no
configuration is generated from them, so the cleanup is safe and needs no
action from you. SAN rows not yet attached to a certificate are left alone.

## What to do

Run the standard upgrade:

```bash
cd /opt/hermes-seg-docker-gl
sudo ./scripts/system_update_docker.sh
```

**Then, if you intend to use Reachable By, save Postfix settings once.** Open any
page under **System** that writes Postfix configuration and save it. That
regenerates `main.cf` from its template and picks up the new recipient
restriction.

Until you do, the setting is recorded but not enforced. This is deliberate: an
unattended upgrade that rewrites a live `main.cf` is a good way to stop a gateway
accepting mail, and there is nothing to enforce anyway until you turn the setting
on somewhere.

Nothing else is required. Everything else applies automatically.

## How to confirm it worked

```bash
# Build stamp advanced
docker exec hermes_db_server mysql -u root hermes \
  -e "SELECT value FROM system_settings WHERE parameter = 'build_no';"
# expect: v260815

# The new lookup map exists
ls -l config/postfix-dkim/etc/postfix/mysql-internal-only-recipients.cf

# Sharing is restricted to the same domain
docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
  config:app:get core shareapi_only_share_with_group_members
# expect: yes
```

Then create an alias with two destinations and confirm it renders as one row with
two chips.

## What changed

| Area | Change | Issue |
| --- | --- | --- |
| Aliases | Several destinations per alias, grouped display, per-destination edit and remove | `#311` |
| Virtual Recipients | Same, plus a fix to a validator that would have rejected a list outright | `#311` |
| Aliases | External destinations allowed on mailbox domains, badged wherever shown | `#311` |
| Aliases | Reachable By, enforced by a new Postfix recipient restriction. Mailbox domains only | `#311` |
| Mailboxes | Send-As granted per mailbox instead of per alias | |
| Nextcloud | Group sharing disabled, closing a cross-tenant name disclosure | `#316` |
| Schema | Unique key traded for a lookup index and a pair-unique; `virtual_recipients` indexed | |

## Known follow-up

- Catch-all entries cannot be set to internal-only, because of how Postfix probes
  an access map by bare domain.
- Per-destination Send-As granularity. The grant is per mailbox and per address;
  there is no way to say "may send as this list, but only these members may".
- `mailbox_aliases.send_as` is now vestigial. Nothing reads it. Dropping the
  column is a later cleanup.
- Making list addresses appear in users' address books, so people can find
  `people@domain.tld` when composing rather than having to know it exists. Proven
  workable in testing; not yet built.
