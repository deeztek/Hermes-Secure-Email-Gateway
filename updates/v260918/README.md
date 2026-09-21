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

## What is fixed

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

## Upgrading

Standard procedure. The schema change is applied for you and there are no manual
steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260918
```

Take a backup or a snapshot first, as always. On a hypervisor a VM snapshot is the
quickest way back. Otherwise run `./scripts/system_backup.sh` from the host.
