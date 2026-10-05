# Hermes SEG v260929

**Host some of a domain's mail yourself and relay the rest.** A company paying a
provider per mailbox can keep the few people who need that provider and host
everyone else on Hermes, on the same domain, without rebuilding anything. Fifty
seats become ten.

Around that: a mailbox can be converted to a shared one when its owner leaves,
a conversion can be undone, and scheduled tasks say what they are for.

This release also closes a class of problem rather than one instance of it.
Nothing in Hermes rotated most of its log files, upgrading never reclaimed the
disk the previous release's images were using, and a Nextcloud upgrade across
two major versions would fail partway through. All three end the same way, with
a full disk and mail being deferred, and none of them look like a disk problem
when they happen.

Schema changes, no image rebuild.

## Read this first

Four things change behaviour on upgrade. All are narrow, and all are easy to
check before you start.

**Existing backend overrides start working.** If anyone has ever set a
per-recipient backend override, it has had no effect on delivery until now.
After this upgrade it is honoured, so that recipient's mail goes where the
setting says rather than where it has actually been going. Review them under
**Email Relay > Relay Recipients**, where the Backend column shows each one.

**Auto-provisioning stops targeting mailbox domains.** It only ever creates
relay recipients, which a mailbox domain rejects, so this corrects a
configuration that could not work. Nothing already provisioned is removed.

**Directory sync runs every fifteen minutes instead of every six hours.** On
connections with auto-apply enabled, that interval is how long a new account at
the provider waits before it can receive mail here, so six hours was too long.
Only installations still on the shipped schedule are changed; if you set your
own, it is left alone.

**Deleting a mailbox no longer offers to keep the messages.** It offered that as
a checkbox, and unticking it deleted the mailbox, the account and the recipient
while leaving the messages on disk with nothing referencing them. The option is
replaced by converting the mailbox to a shared one, which keeps the mail
reachable instead of merely undeleted.

Everything else is unchanged.

## Per-recipient backend overrides now route

Relay Recipients has an **Edit Backend** page for sending one address to a
different server than the rest of its domain. It has been there since early 2026.
It stored the value, displayed it in the Backend column, and had no effect on
delivery whatsoever.

The mail went wherever the domain's transport said, and nothing indicated
otherwise.

**What changes.** Any recipient with an override set now actually goes to that
server, on that port, with that TLS mode.

**Check your existing overrides before upgrading.** If someone set one months ago
and mail kept flowing to the domain default, that is what everyone has come to
expect. After this upgrade it goes where the setting says. Review them under
**Email Relay > Relay Recipients**, where the Backend column shows each override,
and clear any that are stale.

Recipients with no override, which is almost certainly all of them, are
unaffected.

## Mailboxes can now be routed elsewhere too

The same control is now on **Email Server > Mailboxes**, under each row's Actions
menu as **Edit Mail Delivery**.

This matters more than it sounds. Until now, deciding at setup time that a domain
would host local mailboxes was effectively permanent. If you later wanted one
person's mail to go to Microsoft 365 or Google instead, there was no way to say so:
a mailbox domain cannot be converted to a relay domain, and it cannot be deleted
while mailboxes exist. The only route was to delete every mailbox on the domain,
delete the domain, recreate it as a relay domain, and rebuild everything.

Now it is one setting on one mailbox, and the mailbox itself is left alone.

**The mailbox is kept, not deleted.** Its mail simply arrives somewhere else from
then on. Anything already in it stays where it is, and on a mailbox domain
clearing the override sends new mail back to the local mailbox again.

### Seeing where a mailbox's mail goes

A mailbox whose mail goes elsewhere looks identical to every other mailbox in
every other column, so the Mailboxes list gained a **Mail Delivery** column and
a **Delivery** filter. The column says what is actually true rather than what
was configured:

| | |
| --- | --- |
| **Local** | Delivered to this mailbox |
| **Kept here (converted)** | Delivered here by an override of its own, while the rest of the domain relays elsewhere. This is a converted recipient |
| **Routed** | Sent to another server, naming it |
| **Not delivered here** | The domain sends this address elsewhere and the mailbox receives nothing. Shown in red, because it is broken rather than configured |
| **Unknown** | No routing record exists at all, which is not the same as delivering locally |

The filter offers only the states a mailbox is actually in, and does not appear
at all when every mailbox is in the same state.

That red state is worth knowing about. The column used to read "no override" as
"delivered locally", which is true on a mailbox domain and false on a domain
that relays, so a mailbox receiving nothing showed a healthy green badge.

## Keep the executives on Microsoft 365 and host everyone else here

The reason to run a split setup is cost. If you pay a provider per mailbox,
and only some of your people need what that provider gives them, the rest can
be hosted on Hermes and you stop paying for those seats.

That was not possible before. A domain was either a relay domain, where every
recipient's mail is passed on, or a mailbox domain, where every recipient's
mail is kept here. Mixing them meant running two domains or moving everyone.

**Email Relay > Relay Recipients > Edit Backend** now offers a third
destination: **Built-in Email Server**. Select the recipients you want to host
locally, choose it, set a quota, and each one gets a mailbox on this server.
Everyone you do not select carries on going to the provider exactly as before.

So a company paying for fifty mailboxes who needs ten of them keeps those ten
pointed at the provider and hosts the other forty here. Forty seats.

### What is kept

Their existing login still works. Nothing about how they authenticate changes:
if they sign in against Microsoft 365 or Google, they carry on doing that and
collect their mail from here with the same password. If they have a local
password, they keep it. **No passwords are reset and nobody has to be told
anything.**

Their spam policy, encryption settings, signing and MFA requirement all carry
over. Their name comes from what the directory told Hermes when the recipient
was created, so the mailbox is not called `jsmith`.

Nothing is minted that was not there before. No new certificates are issued by
a conversion, and existing ones are untouched.

### Addresses that are redirected elsewhere

Postfix rewrites a redirected recipient before it works out where to deliver, so
an address covered by a **Virtual Recipient** entry, or by a `@domain` catch-all,
would get a mailbox here and never receive anything. Every check would pass and
the mailbox would stay empty.

Converting now looks first.

Where the only thing redirecting an address is the domain's catch-all, the
conversion offers to create an entry pointing that address at itself, which
lifts it out of the catch-all. Postfix prefers a specific entry over a
catch-all, so the rest of the domain carries on being redirected exactly as
before. That is ticked by default and is what makes converting forty people
practical; without it you would be creating forty entries by hand.

Where an address has an entry of its own pointing somewhere else, the conversion
is refused and says which. Somebody deliberately forwards that address, and
quietly overwriting it would be wrong.

Reverting removes the entries the conversion created, and only those. An entry
you made by hand is never touched.

### Their domain becomes a hybrid domain

A domain hosting some mailboxes locally and relaying the rest is now a
recognised arrangement rather than an accident. Those mailboxes appear under
**Email Server > Mailboxes** and behave like any other: aliases, shared
mailboxes, organizational signatures, external banners, autodiscover and
certificate coverage all work.

It stays listed under Relay Domains, because that is what it still mostly is,
marked **Hybrid** so the arrangement is visible at a glance. It does not appear
under Mailbox Domains.

### When someone leaves

An address delivers in one place. It is hosted here or it relays to the
provider, not both, which makes this two choices rather than one.

**Keep their mail.** On the Mailboxes page, Delete now offers **Convert to a
shared mailbox** instead. Every message stays exactly where it is, at the same
address, and the address carries on receiving. Their login is removed, along
with their Nextcloud account. Nobody can open it until you add members under
**Email Server > Shared Mailboxes**, which the dialog says and the confirmation
repeats.

Members can now reach the whole mailbox, not just its inbox. Shared mailboxes
previously granted access to the inbox alone, which nobody noticed because a
shared mailbox created from scratch has no history to reach. A converted one
does, and when somebody leaves their **Sent** folder is often what colleagues
need most. Existing shared mailboxes pick this up the next time their
membership is changed.

Members are subscribed to those folders automatically, so they appear in a mail
client without anyone hunting for them. That is what the **Auto Subscribe**
setting on a shared mailbox has always said it did; until now nothing read it,
and it could be set either way with no effect. Turn it off and members are
given access without the folders being added to their client.

One thing worth knowing in a mail client: there is no "Inbox" underneath the
shared mailbox. The shared mailbox entry itself is the inbox.

This is the Microsoft 365 behaviour, and it is what the old "also delete all
email messages" checkbox was reaching for. Unticking that used to delete the
mailbox, the account and the recipient while leaving the messages on disk with
nothing referencing them: no row, no user, nothing listing it anywhere. That
option is gone.

**Put the address back on the provider.** **Edit Mail Delivery > Revert to
Relay Recipient** undoes the conversion. They become a relay recipient again
with the same login, and mail goes to the domain's backend.

This deletes the mailbox and everything in it. The confirmation says so and has
to be ticked, and it also names what else goes: any aliases delivering to that
mailbox, the Nextcloud account if they had one, and the catch-all exemption the
conversion created, so the domain's catch-all applies to that address again
exactly as it did before.

**What you cannot do is both.** There is no way to relay the address to the
provider while keeping its old mail here, because the mail lives at that
address. If you need the history and the address back on the provider, keep it
as a shared mailbox and relay under a different address.

## Auto-provisioning no longer targets mailbox domains

Auto-provisioning creates **relay** recipients, so a mailbox domain was never a
valid target for it. The domain filter did not enforce that, so pointing a directory
at a mailbox domain would enumerate its users and create recipients that were then
rejected at RCPT TO. They appeared in the console and could not receive mail.

The filter now matches Postfix's own rule. If you have been auto-provisioning onto a
mailbox domain, those recipients stop being created; the ones already there are left
alone, and you should remove them.

### Why it never worked

The override was designed against a database-backed `transport_maps` lookup that
was never switched on. Postfix was reading a static file instead, and that file
only ever contained one entry per domain.

Every other Postfix lookup in Hermes had already moved from a static file to the
database. Transport was the one left behind, so the query this feature needed had
nowhere to live.

### TLS on an override

The TLS mode on an override now applies too. One detail worth knowing: TLS policy
in Postfix attaches to the **destination server**, not to the recipient. Two
recipients pointed at the same backend therefore share one policy, and if they
disagree the stricter of the two is used for both. If that matters to you, send
them to different backends or give them the same setting.

## Scheduled tasks now say what they do

**System > Scheduled Tasks** listed a name, a schedule, a container and a
command. Working out whether a task was safe to turn off meant knowing what
the script behind it did.

Every task now carries a **Purpose**, written for someone deciding whether to
touch it. Two of them exist to stop the disk filling up, and they now say so
and ask for confirmation before being disabled.

### Applying a schedule change

Ofelia reads a rendered file, not the task table, so a change to a schedule did
nothing until something re-rendered it. The only ways to do that from the
console were side effects of unrelated work, and outside it meant a shell.

There is now an **Apply Schedule** button on the Scheduled Tasks page.

## Log files no longer grow forever

Hermes writes eight log volumes and rotated two of them. The other six grew
without limit: Postfix, the mail filter, DMARC, OpenARC, LDAP and Nginx. On a
long-running server the Postfix volume alone held two files of 10.4 GB each, and
one Dovecot log had reached 1.5 GB.

Two files of the same size because Postfix's logging was stored twice: the stock
rsyslog rules write everything to `syslog` and mail separately to `mail.log`, so
every line appeared in both.

**That now stops at the source for the Postfix container.** Mail is excluded
from its `syslog`, so the volume holds one copy rather than two and `mail.log`
is unchanged. Nothing read that second copy: the container's own output comes
from `mail.log`.

The mail filter, DMARC, ARC and encryption containers deliberately keep theirs,
because `syslog` is what their output reaches `docker logs` through. Theirs are
rotated rather than deduplicated.

The cause is the same for all of them and is not per-service. No Hermes
container image runs cron, so the `logrotate` configuration that the Ubuntu
packages install inside those images is present and never executed. Rotation
only ever happened where something scheduled it explicitly, and only one volume
had that.

All eight are now rotated nightly and compressed by a single task, replacing the
two that each handled one volume. Retention comes from the **Log Retention**
period under **System > System Logs**, which already controlled how long log
entries survive in the searchable database and now governs the files those
entries came from as well.

Authelia is the one exception, deliberately. It has its own retention setting on
the Authentication Settings page, so it keeps using that. Folding it into the
global value would have left a control in the console that silently did nothing.

Dovecot's logs gain something in the change: the task that used to rotate them
ran in a container with no database access and so had to hardcode 30 days,
which meant the Log Retention setting did not apply to them. It does now.

Nextcloud's log is included, and it was the worst of them. Nextcloud does have
its own rotation, so this looked like the one log already taken care of. It is a
background job, and nothing on Hermes runs Nextcloud's cron, so it had barely
run: one server had a 580 MB live log beside a six month old 496 MB archive,
about a gigabyte in total. Nextcloud's internal rotation is now switched off and
the nightly task takes it over, which also compresses and then ages out the
archive Nextcloud left behind.

## Nextcloud's background jobs now actually run

The log was the measurable symptom of something larger: **nothing ran
Nextcloud's background job queue at all.** No scheduled task, no cron inside the
container, and the mode left unset, so Nextcloud fell back to running one queued
job per page load. On a gateway whose Nextcloud is opened occasionally that means
the queue barely turns over. On one nobody opens, never.

That queue is not only logs. It carries trash and file version expiry, which is
why storage keeps growing, along with preview generation, notification delivery,
token cleanup and app repair. None of it could be assumed to be running.

A task now runs it every five minutes, which is what Nextcloud documents, and
Nextcloud is told so, which also makes its own admin overview report the truth.

If your install has a large trash or many old file versions, expect some
housekeeping to happen over the first few days after upgrading as a backlog that
has been building clears.

Two containers were also logging their own output without any size cap, which
accumulated outside the storage tiers you sized. Both are capped now, the same
as the other sixteen already were.

The first rotation after upgrading compresses whatever has accumulated, and on a
long-running server that is more than it sounds: one had a single 10.4 GB
Postfix log. It streams straight into the compressed archive rather than copying
first, so it needs only the free space the archive itself takes, roughly a
fifteenth of the log for mail logs. It runs at 02:00 at low priority and does not
interrupt mail, and if it cannot write the archive it leaves the log alone and
says so rather than truncating it.

## Upgrading no longer fills the disk by itself

Every release pulls a full set of images and nothing ever removed any. Twelve
images arrive per release and it accrued forever. A long-running install was
observed holding 157 images and 50 GB, 86% of it reclaimable, on the Docker root
rather than on any of the four storage tiers you size and watch.

Upgrading now reclaims that, after the upgrade has otherwise finished so a
failed run never deletes anything it may still need. It keeps the release you
just moved to **and the one before it**, because reverting to the previously
cached release is the documented way back and removing it would take away the
rollback. Images that are not Hermes images are never touched.

## A Nextcloud upgrade that cannot work now says so first

Nextcloud major versions have to be applied one at a time. The updater ran a
single upgrade step regardless, which is correct for one hop and wrong for
anything else, so an installation that had skipped a Hermes release could arrive
two majors behind and fail partway through, leaving Nextcloud half-upgraded.

It now checks first and refuses, before changing anything, naming what to do:
upgrade through the intervening releases one at a time. Nothing can be automated
here, because each hop needs that release's Nextcloud image and only one is
published per release. A clear refusal is the whole improvement.

This release does not change the bundled Nextcloud version, which is the point
of shipping the check now. It is in place and inert before the release that
needs it, rather than being new on the upgrade it has to catch.

Also in the same area: Nextcloud needs a temp directory that nothing created,
and the next major will not complete an upgrade without one. It is created and
configured now, on both fresh installs and upgrades, so it is already there.

## Also in this release

**The Getting Started guide now starts with first-login security.** Logging in,
pointing the admin account at a mailbox someone reads, enabling MFA, and changing
the CipherMail console password. That last one ships as `admin` / `admin` and is
the only stock credential in Hermes; it used to be documented under "optional".

The guide also gained sections on backups, on how you would notice a full disk,
and on the fact that fail2ban protects every edition.

**The Relay Recipients documentation** described the backend override as working.
Corrected, and now accurate either way.

**Directory sync was missing from the shipped scheduler config.** It is seeded
into the task table and was absent from the file the scheduler actually reads,
so there was a window on a fresh install where directory enumeration did not
run. The check that exists to catch exactly that could not see the job, because
it only understood one of the two ways a task is seeded. Both fixed.

**Disabling a critical task now says what will happen.** It recited the same
four reasons whatever you were disabling, which stopped being true as soon as
anything else was added to the list.

**Legacy migration now refuses to run from the wrong release.** v260912 is the
final release that supports migrating from a bare-metal installation, and the
script said so in a comment that nothing enforced. Run from a later checkout it
would have appeared to succeed while recording the gateway as a release it had
not actually been migrated to, marking every release in between as already
applied. It now refuses and names the two steps: migrate on v260912, then
upgrade normally.

**System Logs now says what it cannot show you.** The page searches the log
database, which carries Postfix, the mail filter, DMARC and LDAP. Everything
else writes to a file and was simply absent with no indication that it existed.
A new panel lists each of those twelve sources, what it covers, and the command
that reads it.

**Six configuration files that looked like working log rotation were deleted.**
They described rotating Dovecot's logs, were mounted nowhere, and sat in images
with no `logrotate` installed. Anyone auditing this for log rotation would have
found them and reasonably concluded it was handled.

## Upgrading

Standard procedure. No manual steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260929
```

Take a backup or a snapshot first, as always.

### What the upgrade changes

**Two columns are added.** `recipients.backend_transport` records whether a
routed recipient is reached over SMTP or delivered to the built-in server, which
cannot be inferred from an address. `ofelia_jobs.description` holds what each
scheduled task is for. Both are additive and empty means what it meant before.

**One file is rewritten in place:** the Postfix transport lookup, so that it
consults recipient overrides. Your database credentials are read out of the
existing file and carried across, and a timestamped copy is kept beside it. If
the upgrade cannot read those credentials it leaves the file alone and says so,
in which case overrides stay inert and nothing else is affected.

**The first log rotation runs at 02:00** the night after you upgrade. On a
server that has been running a while this may spend a few minutes compressing.
It runs at low priority and does not interrupt mail.

**Two scheduled tasks are replaced by one.** The separate Authelia and Dovecot
rotation tasks are removed and a single task covering all eight log volumes
takes their place. If you had disabled either of the old ones, that choice is
not carried over, because the new task is not the same job.

**Three containers are recreated rather than restarted.** The application
container gains the six log volumes so one task can rotate them all, and the
web server and directory containers gain a log size cap. A changed volume or
logging definition means Compose recreates the container rather than restarting
it, which is normal and takes seconds.

**Superseded images are removed at the end.** The release you upgrade from is
kept, so the rollback path is intact. Anything older than that is deleted.
