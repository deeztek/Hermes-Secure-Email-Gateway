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

### Add creates, Edit changes

On both Aliases and Virtual Recipients, entering an address that already exists
is now refused, with the error pointing at that row's Edit button.

Previously you could re-enter an existing address to add members to it. That gave
two ways to do one thing, and it produced an answer you could not act on: if
everything you entered was already stored, the only honest report was that
nothing had changed, which reads as a failure for what was arguably a no-op.

Everything about an existing entry, including adding and removing destinations,
happens in Edit, where the whole set is shown as chips and the save is a diff.

### Virtual Recipients now takes one address at a time

The Add form was a box you could paste many addresses into at once. It is now a
single address, entered in a modal, matching the Aliases page.

**This removes a capability.** Creating ten addresses is now ten submissions.

The bulk form is what forced every outcome to be a per-row tally across four
separate result banners, and what made it impossible to refuse an address that
already existed rather than merely mention it in a list. Fan-out in the direction
that matters, one address to many destinations, is unaffected and is what the
chips are for.

If a bulk path is wanted again it should be a real import with its own report,
not a shared text box whose failure mode is a tally.

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

### Granting Send-As is not enough on its own

Worth knowing before the first support ticket: **the grant alone changes nothing
the user can see.** No mail protocol exposes send-as permissions to a client, so
the user must also add the address as an identity in whatever they read mail
with:

| Client | Where |
| --- | --- |
| Webmail (Nextcloud Mail) | Mail, Account settings, Aliases, Add alias |
| Thunderbird | Account Settings, Manage Identities, Add |
| Outlook | Account Settings, additional email addresses |
| Apple Mail | Account settings, Edit Email Addresses |

Until they do, the From field stays a plain label and the alias is nowhere to be
found, which looks exactly like the grant not working. In every client the From
field only becomes a dropdown once the account has more than one identity.

The reverse also holds and is useful for checking the grant is real: a client
will happily let a user add an identity they have **not** been granted, and the
message is refused at submission with `Sender address rejected: not owned by
user ...`.

Documented for users in `docs/users/set-up-your-devices.md`.

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

### Dropdowns that looked like text boxes

Reported from testing, with the TLS certificate field named as the example: some
fields holding a list of options had no arrow or any other sign that a list
existed, so they read as ordinary text boxes.

The Console Certificate, SMTP TLS Certificate, Dovecot Certificate and Timezone
fields were exactly that. Worse, the list only attached itself once you started
typing, so clicking did nothing and the first character you typed was swallowed
setting it up. All four are proper dropdowns now, with a chevron, and they open
on click.

The destination pickers on Aliases and Virtual Recipients had a milder version of
the same problem in their Edit modals and now open on click as well.

One further fix found on the way: selecting a timezone had always thrown a
JavaScript error, because the handler looked for a field that has never existed
on that page. Saving worked regardless, which is why it went unnoticed.

### If you imported your own certificate, its chain was not being served

Importing a third-party certificate writes the leaf, the CA chain you pasted,
and the two concatenated as a bundle. Nginx read the bundle. **Dovecot and
Postfix read the leaf on its own**, so IMAP, POP and SMTP presented a
certificate with no path back to a trust anchor.

Browsers hide this by fetching the missing intermediate themselves, which is why
a console that looked perfectly healthy on 443 sat alongside mail clients
refusing to connect and sending servers declining TLS. Nothing was wrong with
the import: it verifies the leaf against the chain you supply before accepting
it, so an incomplete chain is rejected at that point.

You can see it in one command. One certificate means the chain is missing:

```bash
echo | openssl s_client -connect <your-host>:465 -showcerts 2>/dev/null \
  | grep -c "BEGIN CERTIFICATE"
```

**The upgrade repairs all three services and needs nothing from you.** Nginx and
Dovecot recompute their certificate path whenever their config is generated, so
both correct themselves as this upgrade runs. Postfix stores its path instead,
so a phase script rewrites it, but only where the chain file is genuinely
present: serving a leaf without its chain is degraded, while naming a file that
does not exist would stop Postfix serving TLS at all, and the repair must not
turn the first into the second.

Certificates issued through ACME were never affected on Nginx or Dovecot, and
are corrected on Postfix by the same script.

After upgrading, that same command should return 2 or more on ports 25, 465, 587
and 993. If any still returns 1, re-import the certificate with its CA chain and
save SMTP TLS Settings.

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

### Per-domain SMTP certificates could stop inbound mail entirely

If a certificate's files went missing while its SAN rows still read validated,
Postfix was told to consult a certificate map that had been deleted. Every TLS
handshake offering SNI then failed and **inbound mail stopped**, with nothing to
show for it but a warning in the log:

```
warning: hash:/etc/postfix/sni_maps is unavailable
warning: tls_server_sni_maps: <host> map lookup problem
SSL_accept error from <sender>
```

Two conditions had to agree and did not. The console enabled the directive by
counting validated SAN rows in the database; the map itself was only written for
certificates whose files were actually present. The directive is now decided by
whether the map exists, so the two cannot diverge. Being wrong now leaves SNI
disabled and mail flowing on the default certificate, rather than refusing mail.

Three situations produced the mismatch, all seen in practice: a certificate that
was deleted, one still Pending because it was requested but never issued, and one
imported without its chain so no bundle file was ever created. The first of those
is the certificate-delete bug fixed in this same release.

**This upgrade repairs it.** SAN rows for a certificate whose files are absent are
removed, and a dangling directive is taken out of the live Postfix config. Nothing
you configured is lost: those rows are rebuilt from your SAN prefixes on the next
sync, and they re-validate once a certificate is genuinely issued. A healthy
install is left untouched.

It also reports, without changing, any of the console, SMTP or mail certificate
bindings pointing at files that are not there. Which certificate to use is your
decision, so the upgrade names the problem rather than reassigning it.

Related, and the same failure in a different place: **selecting an SMTP TLS
certificate whose files are missing is now refused** rather than accepted. A
certificate can appear in that picker before it has finished issuing. Nginx and
Dovecot fall back to the bootstrap certificate in that situation; Postfix does
not, and binding one that is not on disk stops mail being accepted over TLS. The
save is declined, the missing path is named, and the certificate already in use
stays in use.

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
docker exec hermes_db_server mariadb -u root hermes \
  -e "SELECT value FROM system_settings WHERE parameter = 'build_no';"
# expect: v260815

# No SAN rows left pointing at a certificate that no longer exists
docker exec hermes_db_server mariadb -u root hermes -e \
  "SELECT COUNT(*) AS orphans FROM mailbox_sans
    WHERE certificate IS NOT NULL
      AND certificate NOT IN (SELECT id FROM system_certificates);"
# expect: 0

# The new lookup map exists
ls -l config/postfix-dkim/etc/postfix/mysql-internal-only-recipients.cf

# Sharing is restricted to your own group members
docker exec -u www-data hermes_nextcloud php /var/www/html/occ \
  config:app:get core shareapi_only_share_with_group_members
# expect: yes
```

Note there is no `-p`: `hermes_db_server` authenticates root over a unix socket,
so running as root inside the container needs no password.

Then in the console:

- Create an alias with two destinations and confirm it renders as one row with
  two chips.
- Open **System, Console Settings** and click the Certificate field without
  typing. It should drop down a list.

**Reachable By needs one extra step on an upgraded install.** The recipient
restriction that enforces it is written into `main.cf` from a template, so it
stays inert until you save Postfix settings once. Until then the setting shows in
the interface and has no effect.

## What changed

| Area | Change | Issue |
| --- | --- | --- |
| Aliases | Several destinations per alias, grouped display, per-destination edit and remove | `#311` |
| Virtual Recipients | Same, plus a fix to a validator that would have rejected a list outright | `#311` |
| Aliases | External destinations allowed on mailbox domains, badged wherever shown | `#311` |
| Aliases | Reachable By, enforced by a new Postfix recipient restriction. Mailbox domains only | `#311` |
| Aliases, Virtual Recipients | Add creates only; an existing address is refused and points at Edit | `#311` |
| Virtual Recipients | One address per submission, in a modal, replacing the bulk paste box | `#311` |
| Mailboxes | Send-As granted per mailbox instead of per alias, and shown as a column on the list | |
| Nextcloud | Shares restricted to your own group members, closing a cross-tenant name disclosure | `#316` |
| Console | Certificate and timezone fields are real dropdowns that open on click | `#310` |
| Certificates | Deleting one no longer fails after having deleted it; stranded SAN rows cleaned up | |
| SMTP TLS | A missing per-domain certificate map no longer stops inbound mail; stale validation flags reset on upgrade | |
| TLS, all services | Imported certificates now serve their full chain on IMAP, POP and SMTP, not just the leaf | |
| Schema | Unique key traded for a lookup index and a pair-unique; `virtual_recipients` indexed; orphaned `mailbox_sans` rows removed | |
| Cleanup | Four unreachable files removed: two duplicate Virtual Recipient pages, two dead scheduler scripts | |

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
