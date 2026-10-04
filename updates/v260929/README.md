# Hermes SEG v260929

**Per-recipient mail routing.** A setting that has been storable since early 2026
and never affected delivery now works, and it is available on mailboxes as well as
relay recipients.

No schema change. No image rebuild.

## Read this first

Two things change behaviour on upgrade. Both are narrow, and both are easy to
check before you start.

**Existing backend overrides start working.** If anyone has ever set a per-recipient
backend override, it has had no effect on delivery until now. After this upgrade it
is honoured, so that recipient's mail goes where the setting says rather than where
it has actually been going. Review them under **Email Relay > Relay Recipients**,
where the Backend column shows each one.

**Auto-provisioning stops targeting mailbox domains.** It only ever creates relay
recipients, which a mailbox domain rejects, so this corrects a configuration that
could not work. Nothing already provisioned is removed.

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
then on. Anything already in it stays where it is. Clearing the override sends new
mail back to the local mailbox again.

### Seeing which mailboxes are affected

A mailbox whose mail goes elsewhere looks identical to every other mailbox in every
other column, so the Mailboxes list gained a **Mail Delivery** column showing where
each one's mail actually goes, and a **Delivery** filter for narrowing the list to
those routed away.

A mailbox with no recipient record reads **Unknown** rather than Local, because no
routing record is not the same thing as delivering locally.

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

Two things worth knowing in a mail client:

There is no "Inbox" underneath the shared mailbox. The shared mailbox entry
itself is the inbox.

The subfolders are reachable but are not advertised when a client asks for the
folder list, so they may need adding by name, as `Shared/<address>/Sent` and so
on. This is how Dovecot handles shared mailboxes rather than something specific
to Hermes.

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

## Dovecot's log files are no longer unbounded

Dovecot wrote three log files and nothing ever rotated them. On a server where
debug logging had been switched on at some point, one of them had reached
1.5 GB. A full disk defers all mail, so this was a real risk rather than
untidiness.

They are now rotated nightly, compressed, and kept for 30 days, the same as
the Authelia logs already were.

The first rotation after upgrading will compress whatever has accumulated,
which on a long-running server can take a few minutes at 02:15 and is a
one-off.

## Also in this release

**The Getting Started guide now starts with first-login security.** Logging in,
pointing the admin account at a mailbox someone reads, enabling MFA, and changing
the CipherMail console password. That last one ships as `admin` / `admin` and is
the only stock credential in Hermes; it used to be documented under "optional".

The guide also gained sections on backups, on how you would notice a full disk,
and on the fact that fail2ban protects every edition.

**The Relay Recipients documentation** described the backend override as working.
Corrected, and now accurate either way.

## Upgrading

Standard procedure. No manual steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260929
```

Take a backup or a snapshot first, as always.

One file is rewritten in place during the upgrade: the Postfix transport lookup,
so that it consults recipient overrides. Your database credentials are read out
of the existing file and carried across, and a timestamped copy is kept beside
it. If the upgrade cannot read those credentials it leaves the file alone and
says so, in which case overrides stay inert and nothing else is affected.
