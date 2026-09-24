# Hermes SEG v260918

**Recipient auto-provisioning.** Relay recipients can now be read from your
directory on a schedule instead of being typed or pasted in. Plus the RemoteAuth
transport work that makes LDAPS reachable at all, and a set of fixes.

This release changes the database schema. Upgrading is still a single command.

## Read this first

Nothing in this release changes how your gateway currently authenticates or
delivers mail. Auto-provisioning is new and switched off until you configure a
directory. Every existing RemoteAuth mapping keeps the exact transport it has
today.

**One thing does change for your recipients.** The key behind quarantine release
links is rotated during the upgrade, so release links already sitting in people's
inboxes stop working. Links are valid for 72 hours, so that is at most 72 hours of
notices whose Release button now reports the link as invalid. Anything older had
already expired. Recipients can still release those messages from the User Portal.
See [Quarantine release links are rotated](#quarantine-release-links-are-rotated).

## Auto-provisioning

Relay recipients have always been entered by hand, or pasted in as CSV exported
from a directory. That included gateways where RemoteAuth was already pointed at
that same directory, authenticating those same people. Nothing ever asked the
directory who its users were.

**Email Relay > Auto-Provisioning** adds a directory Hermes can read. It runs on
a schedule, finds addresses in your relay domains, and either stages them for you
to review or creates them unattended.

Available in Community edition. Provisioning recipients who authenticate against
your own directory requires Pro, as RemoteAuth always has.

### Three kinds of directory

| Type | Reads from | Needs |
| --- | --- | --- |
| LDAP | Active Directory, OpenLDAP, FreeIPA, 389 DS, or Google Secure LDAP | Server address, base DN, a read-only bind account |
| Google Workspace | The Admin SDK Directory API | A service account with domain-wide delegation, and a super administrator to impersonate |
| Microsoft 365 | Microsoft Graph | An app registration with `User.Read.All` application permission and admin consent |

The two cloud connectors read over HTTPS and have no server address, base DN or
bind account to fill in.

**Google Workspace works on every Workspace edition.** Secure LDAP needs Business
Plus, but reading the user list does not, so a Starter or Standard tenant can
have its recipients provisioned without paying to move up a plan. Enumeration and
sign-in are separate questions here throughout: the directory Hermes reads its
recipient list from is not necessarily the one it authenticates them against, and
a tenant enumerated from Google or Microsoft 365 while authenticating against
on-prem AD is an ordinary configuration, not a workaround.

**Microsoft 365 has no LDAP option at all.** Entra ID exposes no LDAP endpoint,
and Entra Domain Services is a separate product needing an Azure virtual network
and a password change for every cloud-only user. Graph is the only route, which
is why the Microsoft connector is not optional the way the Google one is.

### It is additive, and it never deletes

A relay domain set to **ANY** already accepts mail for every address in the
domain. Recipients exist so that per-recipient features work: encryption, the
user portal, block and allow lists. So provisioning does not gate delivery, and
a missed address is a feature gap rather than bounced mail.

The same reasoning is why a recipient who disappears from the directory is
**reported and never removed**. Their mail still flows through the domain
wildcard, and deleting them would strip portal access and encryption from a live
user. If you want them gone, remove them from Relay Recipients yourself.

A sync that fails, or one whose search matches nothing, leaves the previous
results untouched. A directory that is briefly unreachable must not read as
"everyone has left".

### Review first, automatic later

A new directory starts in **Stage for review**, so the first run is inspectable:
you see what came back before anything is created. Switch it to **Create
automatically** once the filter is doing what you expect.

Automatic creation is capped at 25 recipients per run and drains across
successive runs, so a first import of a large directory does not run for an hour
inside one job. Raise the job frequency in Scheduled Tasks if you want it faster.

### Defaults, set per directory

Each directory carries the settings applied to every recipient it creates:
authentication type, SVF policy, quarantine notifications, portal message
download, Bayes training, and 2FA.

Two worth calling out:

- **Send welcome e-mail.** Turn it off for a first bulk import. Those people
  already have mail flowing and have never heard of Hermes; several hundred
  welcome notices arriving at once is not the introduction you want.
- **Encryption is deliberately not here.** Turn S/MIME or PGP on afterwards from
  Relay Recipients using Bulk Edit, which queues certificate and keyring
  generation in the background as it always has.

### Accounts whose directory username is not their e-mail address

Provisioned recipients are located by the DN the directory itself returned, so a
directory where the account name differs from the e-mail local part works
correctly. Adding those recipients by hand relies on a DN pattern instead, which
cannot express that difference.

## LDAPS for RemoteAuth

RemoteAuth could only ever connect over plain LDAP. The URI was fixed in code, so
LDAPS was unreachable regardless of what the TLS settings said.

Transport is now chosen **per mapping**, and mappings can differ: an existing
plain connection is unaffected by adding an LDAPS one beside it.

Existing mappings keep plain LDAP. Nothing changes until you choose otherwise.

### Simpler TLS settings

The **Use STARTTLS** and **TLS Certificate Requirement** dropdowns are gone.
Transport now says everything:

| | |
|---|---|
| **Plain LDAP** | Not encrypted |
| **LDAPS** | Encrypted, and the directory's certificate is verified |

STARTTLS offered nothing LDAPS does not, and cannot be combined with it.
"Encrypted but unverified" was never a setting worth choosing when what it leaves
exposed is the user's own password. Global TLS Settings is now the CA bundle and
the retry count.

If you switch a mapping to LDAPS, the directory must listen on the LDAPS port and
present a certificate that validates against your CA bundle, with a hostname
matching the address you entered. An IP address will not match a certificate
issued to a hostname.

**If you use STARTTLS today, read this before adding an LDAPS mapping.**

Upgrading changes nothing: a gateway using STARTTLS keeps using it, because that
setting is preserved and no existing mapping is switched to LDAPS for you.

The one thing to know is what happens *later*. STARTTLS and LDAPS cannot coexist,
because the overlay holds a single TLS configuration for every mapping and
STARTTLS cannot run on a connection that is already encrypted. So the first time
you add an LDAPS mapping, STARTTLS is switched off for the whole overlay, and any
mapping still on plain LDAP goes from STARTTLS-encrypted to unencrypted.

That matters because what crosses the wire on those connections is the user's own
password. If you have STARTTLS mappings and want to introduce LDAPS, move them all
to LDAPS rather than leaving some behind on plain.

### Client certificates, for directories that require them

Some directories will not accept a connection unless the client proves its own
identity as well, Google Secure LDAP being the notable one. Both the RemoteAuth
page and each auto-provisioning directory now take a client certificate and key
alongside the CA bundle.

Only needed if your directory demands it. An ordinary Active Directory does not,
and leaving these empty changes nothing.

This has now been exercised end to end against Google Secure LDAP: certificate
upload, the generated overlay configuration, the mutual-TLS handshake, and a
Workspace user signing into the portal with their Google password. Other
directories that require mutual TLS should work the same way, but Google is the
one that has actually been run.

## What is fixed

### Quarantine release links are rotated

The key used to sign quarantine release links was derived from inputs that carried
far less randomness than their length suggested. Hashing a weak input does not
enlarge the space behind it, it only makes the result look random. The key is now
generated properly.

**This was not remotely exploitable on its own.** Forging a working link also
requires a message identifier that is not guessable from outside the gateway. It
was still not a property worth keeping.

Because the old key is read back from disk whenever it exists, fixing the
generation alone would have left every existing gateway on its old key
permanently. Only rotating it reaches them, and that is what the upgrade does.

**What you will see.** Release links issued in the last 72 hours stop working, and
a recipient clicking one is told the link is not valid. Links older than that had
already expired. Nothing is lost: those messages are still in quarantine and can
be released from the User Portal, or by an administrator from Message History.

Nothing to do. The next quarantine notice mints the new key automatically.

Reported by @quietvw.

### The database filled its own disk until mail stopped

Two defects in the database container, together, would eventually stop your
gateway accepting mail. The symptom gave no hint of the cause:

```
452 4.3.1 Insufficient system storage
```

Postfix refuses to accept a message when free disk falls below a threshold. Mail
is deferred rather than lost and senders retry, but delivery halts, and nothing in
that message points at a database.

**Binary logs were never deleted.** A ten day retention was configured and
correct, and never once executed. Every automatic purge in MariaDB waits for a
replica to consume the log first, and Hermes has no replicas, so the wait never
ended. On a gateway running since early 2025 this had reached **fifteen months of
logs, around 51 GB**, against a database of 6 GB. Nothing read them. They exist
for replication and point-in-time recovery, neither of which Hermes uses, since
backups are taken as dumps.

This is now corrected, and it repairs itself. The retention that was always
configured simply starts working, and the accumulated backlog is cleared
automatically at the next log rotation. **You do not need to delete anything by
hand**, and you should not: MariaDB tracks these files in an index and removing
them directly corrupts it.

**The database healthcheck reported healthy no matter what.** It connected without
credentials, and the command it used treats a refused login as a successful
response, so it passed on every probe while writing an access denied warning each
time. At one probe every ten seconds that reached a **17 GB** error log on the
same install.

The worse half was silent: other services wait for that healthcheck before
starting, and it could not tell a working database from one refusing every
connection. The probe now authenticates, which stops the log growth at source and
makes the check mean something.

The error log is the one thing that does not clean itself, because the fix stops
it growing rather than shrinking what is there. If yours is large, empty it in
place rather than deleting it, since the file is open:

```bash
docker exec hermes_db_server sh -c ': > /config/log/mysql/mariadb-error.log'
```

Worth checking your disk after upgrading if you have been running a while. On the
affected install these two accounted for **68 GB**.

### Uploaded RemoteAuth CA certificates were never readable

The certificate was stored correctly and the console showed it as present, but no
container mounted the directory it was written to, so `slapd` could not open it.
Harmless while certificate verification was off, which was the default. It now
mounts read-only.

### The Test Connection button could report success when nothing happened

The check accepted an empty error stream as a pass, so a command that produced no
output at all reported a healthy directory. It now requires the directory to
actually confirm the identity it bound as, and says specifically what failed:
no listener on the port, or a certificate that did not validate.

It also now tests with the same transport and verification the live connection
uses. Previously it could pass against a directory the gateway itself could not
reach.

### A failed CA certificate upload destroyed the existing one

The old bundle was deleted before the new one was accepted, so a rejected upload
left no certificate at all. With verification switched on that breaks
authentication as the result of a failed attempt to *add* a certificate. It now
uploads first and replaces only on success.

### RemoteAuth sync reported an internal error instead of the real one

When the underlying command wrote nothing to its error stream, the sync failed
with a variable error and the actual LDAP message was never shown.

### The portal sign-in username is now stated plainly

Recipients sign in with their **e-mail address**, whatever their username is in
your directory. The welcome e-mail previously said an administrator would supply
the username separately, which sent people asking for something they were already
looking at. The RemoteAuth pages now say the same thing, since the DN pattern
there is not a username field and has been read as one.

### Row buttons in the Mailboxes and RemoteAuth tables were misaligned

Cosmetic, but visible on every row: action buttons sat at inconsistent heights
because each was wrapped in its own form inside the table cell. They now use the
same pattern as the rest of the console.

## New documentation

| | |
|---|---|
| [Auto-Provisioning](../../docs/admin/02-email-relay/auto-provisioning.md) | The three directory types, the Google and Microsoft 365 setup steps including which misstep produces which error, and what is guaranteed never to happen to your recipient list |
| [LDAP RemoteAuth](../../docs/admin/01-system/ldap-remoteauth.md) | Rewritten around Google Secure LDAP: the edition requirement, the setup step everyone misses, and why a wrong DN pattern looks exactly like a wrong password |
| [Nextcloud Talk and the High-Performance Backend](../../docs/general/nextcloud-talk-hpb-deployment.md) | Optional. Chat, calls and meetings on the Nextcloud that already ships with Hermes |

## Upgrading

Standard procedure. The schema change is applied for you and there are no manual
steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260918
```

Take a backup or a snapshot first, as always. On a hypervisor a VM snapshot is the
quickest way back. Otherwise run `./scripts/system_backup.sh` from the host.

This release changes how the database container reports its health, and every
other service waits for that before starting. It has been verified on two
gateways, but if an upgrade ever stalls with services not coming up, check that
container first:

```bash
docker ps --filter name=hermes_db_server --format '{{.Names}}\t{{.Status}}'
docker inspect hermes_db_server --format '{{json .State.Health}}'
```

It should reach `healthy` within about ninety seconds of starting.
