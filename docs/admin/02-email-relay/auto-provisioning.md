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

### First, if your mail domain is not already in the tenant

You will usually want the tenant to know about the domain your recipients
actually use, so that `mail` and the aliases come back as real addresses rather
than `@yourtenant.onmicrosoft.com`.

🔴 **Verify ownership only. Do not let Microsoft change your DNS.**

Adding a domain to a tenant is a TXT record and is completely harmless. What is
not harmless is the setup wizard's offer to manage DNS for you, or its "update
your DNS records" step: those rewrite your **MX** records to
`*.mail.protection.outlook.com` and your live mail stops being delivered
wherever it goes today. Decline every DNS step except the ownership TXT.

A licensed mailbox can exist in Exchange Online for an address whose MX points
somewhere else entirely. Nothing breaks. External mail continues to follow MX.

### In the Entra admin center

| # | |
|---|---|
| 1 | **App registrations > New registration**. Single tenant is fine, and no redirect URI is needed: the client credentials grant never redirects |
| 2 | From the app's **Overview**, note the **Directory (tenant) ID** and the **Application (client) ID** |
| 3 | **Certificates and secrets > New client secret**. Copy the **Value** column immediately |
| 4 | **API permissions > Add a permission > Microsoft Graph > Application permissions > `User.Read.All`** |
| 5 | **Grant admin consent.** The permission does nothing until this is done |

Step 4 must be an **Application** permission, not a Delegated one. Delegated
permissions act on behalf of a signed-in user, and nobody is signed in when the
scheduled sync runs.

### The three values, and the two that look like them

Hermes needs exactly three things. Two of the values on those Entra pages are
near-identical twins of the ones you want, and picking the twin produces an
error that does not obviously say so.

| Hermes field | Entra label | Looks like | Confused with |
|---|---|---|---|
| Directory (tenant) ID | Directory (tenant) ID | GUID | nothing |
| Application (client) ID | Application (client) ID | GUID | **Object ID**, which sits directly beneath it on the same page and is also a GUID |
| Client Secret | the secret's **Value** | ~40 characters with tildes and dots, **not** a GUID | **Secret ID**, the adjacent column, which is a GUID |

🔴 **The Secret ID is never used by anything.** It is not sent in the request and
Hermes has no field for it. It exists only so you can tell two secrets apart in
the portal. The request Hermes makes is:

```
POST https://login.microsoftonline.com/<Directory (tenant) ID>/oauth2/v2.0/token

grant_type    = client_credentials
client_id     = <Application (client) ID>
client_secret = <the secret Value>
scope         = https://graph.microsoft.com/.default
```

The secret **Value** is shown once, at creation. Navigate away and it is masked
forever, and there is no way to reveal it: create a new secret instead.

### In Hermes

Add a directory, Type **Microsoft 365**, and enter the three values. The LDAP
connection fields disappear when you choose the type, because Graph has no
server address, base DN or bind account.

### If it fails

The run message leads with what to do and puts Microsoft's own text in
parentheses after it. Hovering the message in the directories table shows the
untruncated version.

| Message contains | Cause |
| --- | --- |
| `AADSTS7000215` | The **Secret ID** was pasted instead of the secret **Value**. By far the most common setup mistake |
| `AADSTS7000222` | The client secret has expired |
| `AADSTS700016` | No app with that client ID in this tenant. Commonly the **Object ID** pasted instead of the Application (client) ID |
| `AADSTS90002` | Wrong tenant |
| `Authorization_RequestDenied` | Step 4 or step 5 was not done, or a Delegated permission was added instead of an Application one |
| "throttling requests" | Graph rate-limited the tenant. Nothing was changed and the next scheduled sync retries |
| "returned no accounts at all" | The credentials were accepted. The tenant really did return nobody |

### Licences are not optional for this

An account with no licence has **no mailbox**, which has three consequences:

1. `mail` comes back empty, so the address is taken from the **UPN** instead.
   That is usually `@yourtenant.onmicrosoft.com`, which rule 3 then discards.
2. The alias UI is hidden for that user, so you cannot give them one.
3. Nothing about that account is wrong, it simply is not a mail recipient.

If a sync stages `@...onmicrosoft.com` addresses, or stages nothing at all from a
tenant you know has users, check licensing first.

### Aliases

Aliases are the reason to bother with `proxyAddresses`, and they are worth
testing deliberately because they exercise a code path the primary address does
not.

**Microsoft 365 admin center:** Users > Active users > click the user > the
**Aliases** section > **Manage username and email**.

The label has changed over time and older guides call it "Manage email aliases".
Two things hide the option entirely:

- the user has **no licence** assigned
- your own role is not Exchange-based. Exchange Administrator or Global
  Administrator is required

**Exchange admin center** is the more direct route if the admin center is being
awkward: `admin.exchange.microsoft.com` > Recipients > Mailboxes > select the
mailbox > **Manage email address types**. This writes `proxyAddresses`, which is
exactly what the connector reads.

Allow a few minutes before syncing. Microsoft documents up to 24 hours for alias
propagation, though in practice it is usually a minute or two.

### What gets enumerated

The primary address, plus every `smtp:` entry in `proxyAddresses`, for each
account. Each address is staged as its own row, so a mailbox with two aliases
produces three rows. Then rule 3 applies: anything outside your relay domains is
discarded.

`proxyAddresses` mixes schemes. Only the `smtp:` ones are mail addresses;
`x500:`, `sip:` and `SPO:` entries are ignored. The `SMTP:` / `smtp:` case
distinction marks primary versus alias and is not meaningful here, because the
primary is already in the list.

- **Guests are skipped.** Their UPN carries the `#EXT#` marker and they belong to
  another organisation. They are skipped by shape rather than left to rule 3,
  because a guest invited from a domain you do relay for would otherwise be
  provisioned as though they were staff.
- **Disabled accounts are kept.** `accountEnabled = false` blocks sign-in, not
  delivery. The mailbox still exists and still receives mail, which is precisely
  when quarantine matters.
- Accounts with no `mail` value fall back to their UPN. See the licensing note
  above.
- **Addresses already in Hermes stage as `existing`**, not as additions, so
  re-running a sync over a roster you have already imported offers nothing new.

There is no delta endpoint in use. Graph offers one, but a delta token that
expires or is lost turns into a silent partial sync, and for a mail gateway that
means someone quietly has no portal access. A full list every run with a local
diff cannot drift.

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
