# Auto-Provisioning

Admin path: **Email Relay > Auto-Provisioning**
(`view_directory_connections.cfm`, `inc/directory_connection_actions.cfm`,
`inc/directory_import_apply.cfm`, `inc/directory_google_enumerate.cfm`,
`inc/directory_graph_enumerate.cfm`, `schedule/directory_sync.cfm`).

Reads a user list out of a directory and turns the addresses in your relay
domains into [relay recipients](relay-recipients.md), on a schedule.

Relay recipients have always been entered by hand or pasted in as CSV. That
included gateways where [RemoteAuth](../01-system/ldap-remoteauth.md) was already
pointed at the same directory, authenticating the same people. Nothing ever asked
the directory who its users were. This page does.

Community edition. Provisioning recipients who authenticate against your own
directory requires Pro, because that is RemoteAuth.

## Enumeration and authentication are separate questions

This is the idea the whole page is built on, and the one worth getting straight
before configuring anything.

| | Question | Answer lives in |
| --- | --- | --- |
| Enumeration | Where does the list of people come from? | The directory's **Type** and its connection settings |
| Authentication | What password do those people sign in with? | The directory's **Authentication** setting, and the RemoteAuth mapping it names |

They are commonly the same directory and need not be. A tenant enumerated from
Google Workspace while authenticating against on-prem Active Directory is an
ordinary hybrid configuration, not a workaround. So is enumerating from Microsoft
365 and having recipients sign in with Hermes passwords they set themselves.

The practical payoff: **enumeration never costs a directory upgrade.** Google
Secure LDAP needs Business Plus, but reading the user list through the Admin SDK
does not, so a Starter tenant can have its recipients provisioned and only pays
more if it wants single sign-on.

## Directory types

| Type | Reads from | Credentials needed |
| --- | --- | --- |
| **LDAP** | Active Directory, OpenLDAP, FreeIPA, 389 DS, Google Secure LDAP | Server address, base DN, read-only bind account |
| **Google Workspace** | Admin SDK Directory API | Service account key with domain-wide delegation, plus a super administrator to impersonate |
| **Microsoft 365** | Microsoft Graph | App registration: tenant ID, client ID, client secret |

The two cloud types read over HTTPS. They have no server address, base DN or bind
account, and the console hides those fields when you pick one.

**Microsoft 365 has no LDAP option.** Entra ID exposes no LDAP endpoint at all,
and Entra Domain Services is a separate product requiring an Azure virtual
network and a password change for every cloud-only user. Graph is the only route.

## Four rules that never change

These hold for every directory type and every setting on the page.

1. **A failed or empty enumeration stages nothing.** If the directory is
   unreachable, the credentials are wrong, or the query returns no one, the
   previous results are left exactly as they were. A directory that answers
   "nobody" can never empty your recipient list.
2. **Nothing is ever deleted.** A recipient who disappears upstream is reported
   as `vanished` and left alone. Removing them is a decision you make on the
   Relay Recipients page. A relay domain set to ANY still delivers their mail, so
   a bad or partial sync must not be able to strip portal access and encryption
   from live users.
3. **Addresses outside your relay domains are discarded.** Not filed under the
   wrong domain, not stored for later. Cloud tenants routinely carry addresses
   the gateway does not relay for.
4. **The bind password never reaches the filesystem as a command argument.** It
   is written to a file readable only by the process that needs it, and that file
   is removed afterwards. The legacy AD sync substituted it into a `.cfm` under
   the web root; this does not.

## Setting up Google Workspace

In the **Google Cloud console**:

| # | |
|---|---|
| 1 | Create a project, or use an existing one |
| 2 | Enable the **Admin SDK API** |
| 3 | Create a **service account**, then create a **JSON key** for it and download the file |
| 4 | Note the service account's **Client ID** (a long number, on the service account's details page) |

In the **Google Admin console**:

| # | |
|---|---|
| 5 | **Security > Access and data control > API controls > Domain-wide delegation** |
| 6 | **Add new**, paste the Client ID from step 4, and grant the scope `https://www.googleapis.com/auth/admin.directory.user.readonly` |

Your organisation may require a second super administrator to approve the
delegation.

In **Hermes**:

| # | |
|---|---|
| 7 | Add a directory, Type **Google Workspace** |
| 8 | Upload the JSON key from step 3 |
| 9 | Enter a **super administrator** address to impersonate. The Directory API will not answer without one |

### If it fails

| Message contains | Cause |
| --- | --- |
| `unauthorized_client` | Step 5 or 6 was not done, or the scope does not match exactly |
| `invalid_grant` | The impersonated account is not a real super administrator in that Workspace. A clock skew of more than a few minutes on the gateway will also do it |
| "not a service account key" | The uploaded file is the OAuth client JSON, not the service account key. Download it from the service account itself |

## Setting up Microsoft 365

In the **Entra admin center**:

| # | |
|---|---|
| 1 | **App registrations > New registration**. Single tenant is fine; no redirect URI is needed |
| 2 | From the app's **Overview**, note the **Directory (tenant) ID** and the **Application (client) ID**. Not the Object ID, which looks identical and will not work |
| 3 | **Certificates and secrets > New client secret**. Copy the **Value** column immediately: Entra shows it once and never again. The Secret ID is not the secret |
| 4 | **API permissions > Add a permission > Microsoft Graph > Application permissions > `User.Read.All`** |
| 5 | **Grant admin consent.** The permission does nothing until this is done |

Step 4 must be an **Application** permission, not a Delegated one. Delegated
permissions act on behalf of a signed-in user, and nobody is signed in when the
scheduled sync runs.

In **Hermes**: add a directory, Type **Microsoft 365**, and enter the three
values from steps 2 and 3.

### If it fails

| Message contains | Cause |
| --- | --- |
| `AADSTS7000215` | Wrong client secret, commonly the Secret ID pasted instead of the Value |
| `AADSTS7000222` | The client secret has expired |
| `AADSTS700016` | No app with that client ID in this tenant |
| `AADSTS90002` | Wrong tenant |
| `Authorization_RequestDenied` | Step 4 or step 5 was not done |
| "throttling requests" | Graph rate-limited the tenant. Nothing was changed; the next scheduled sync retries |

### What gets enumerated

The primary address, plus every `smtp:` entry in `proxyAddresses`, for each
account. Then rule 3 applies: anything outside your relay domains is discarded.

- **Guests are skipped.** Their UPN carries the `#EXT#` marker and they belong to
  another organisation.
- **Disabled accounts are kept.** `accountEnabled = false` blocks sign-in, not
  delivery. The mailbox still exists and still receives mail, which is precisely
  when quarantine matters.
- Accounts with no `mail` value fall back to their UPN.

## Provisioning defaults

Set per directory and applied to every recipient it creates. These are the same
settings the Relay Recipients page offers when adding someone by hand.

| Setting | Notes |
| --- | --- |
| Authentication | **Local** (recipient sets a Hermes password via the reset e-mail) or **Remote** (RemoteAuth, Pro) |
| RemoteAuth mapping | Required when Authentication is Remote. Supplies `recipients.remoteauth_domain` |
| SVF policy | The spam/virus/filter policy the recipient lands on |
| Quarantine notifications | On or off |
| Download messages from portal | |
| Train Bayes from portal | |
| 2FA enforcement | Policy only. New users always land in `cn=one_factor`; the recipient enables it themselves |
| Welcome e-mail | Off for a first bulk import of people who have never heard of Hermes. On for steady state, when a new hire appears |

Encryption is deliberately **not** set here. Certificate and PGP key generation
is a separate background job with its own queue, and turning it on for an entire
directory in one action is not something that should happen as a side effect of a
sync.

### Welcome e-mails

Local authentication gets password reset instructions. Remote authentication gets
a shorter note saying to sign in with the organisation password. Both are
delivered to the recipient's real inbox through the relay chain, so they can be
read without signing in first.

## Review, then automatic

A new directory starts in **review** mode, so the first run is inspectable.

| Mode | Behaviour |
| --- | --- |
| Review (`auto_apply = 0`) | Results are staged. You look at them and click Apply |
| Automatic (`auto_apply = 1`) | Additions are provisioned unattended, up to 25 per run |

The 25 is a budget, not a limit on the directory size. It drains across
successive runs; raise the job frequency in **Scheduled Tasks** to drain a large
first backfill faster. Deletions are never automatic at either setting (rule 2).

## Scheduling

One shared job in **Scheduled Tasks** drains every enabled directory, not a
schedule per directory. The legacy AD sync wrote a cron file and a generated
`.cfm` per connection; under Docker that collapses to a single `ofelia_jobs` row
driving one parameterised page.

## The DN a remote-auth recipient gets

Only relevant when Authentication is Remote.

| Directory type | `seeAlso` comes from |
| --- | --- |
| LDAP | The user's **real DN**, as read from the directory. The mapping's DN pattern is not used |
| Google Workspace | The mapping's **DN pattern** |
| Microsoft 365 | The mapping's **DN pattern** |

The cloud connectors are REST APIs and have no DN to report, so the pattern on
the RemoteAuth mapping is what builds the entry. Get it right before importing:
for Google that is `uid={username},ou=Users,dc=yourdomain,dc=com`, using the
local part of the address and not the whole thing. See
[LDAP RemoteAuth](../01-system/ldap-remoteauth.md).

## Related

- [Relay Recipients](relay-recipients.md) - where provisioned recipients land
- [Domains](domains.md) - rule 3 filters against this list
- [LDAP RemoteAuth](../01-system/ldap-remoteauth.md) - the Authentication half
- [Scheduled Tasks](../01-system/scheduled-tasks.md) - sync frequency
