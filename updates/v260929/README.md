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

## The first message after a quiet period no longer gets delayed

Mail to a local mailbox could be refused on its first delivery attempt and
accepted on the retry a few minutes later, so messages arrived late rather
than not at all. On a lightly used server that was most messages.

Dovecot's auth-worker holds one database connection and was never retired, so
it kept that connection for as long as the container ran. Once the connection
had gone away, because the database closed it as idle or restarted, the worker
noticed on next use and crashed instead of reconnecting. It respawned
immediately and the retry then succeeded, which is why this looked
intermittent and why nobody saw lost mail.

The worker is now retired after a minute of inactivity, so it cannot be
holding a connection that has already gone.

Nothing was ever lost to this, and no action is needed. If you have wondered
why the occasional internal message showed up minutes late, this was it.

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
