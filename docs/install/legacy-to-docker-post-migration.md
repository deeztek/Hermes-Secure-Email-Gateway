# Post-Migration Checklist: Legacy → Docker

Run these steps **after** `scripts/migrate_legacy_to_docker.sh` completes. The
migration restores the databases and portable data (encryption key, TLS certs,
DKIM signing keys), migrates admin users to LDAP, and — at the end of its run —
invokes `system_rehost.sh` to rewire the host identity and re-render the
Docker-managed service configs. This checklist covers what remains.

> **Scope:** validated for migrating from legacy build **240815** (relay
> topology) to **v260912**. The migration script rejects any other source build.
>
> **v260912 is the final release that supports this migration.** Install and
> migrate to that tag specifically, not to whatever the latest release is, then
> upgrade forward afterwards. See
> [Legacy to Docker: the whole path](legacy-to-docker.md).

---

> ## ⚠️ Outbound email is PAUSED until you release it
>
> The migration deliberately brings the gateway up with **all outbound delivery
> held**. A freshly migrated box has the restored quarantine and its
> notification schedule live. The migration marks restored quarantine as
> already notified, so this should not happen, but if anything slipped through
> it would send **stale quarantine notifications to real recipients** in the
> restored data. The hold is the safety net: nothing leaves the box, and
> outgoing mail parks in the queue until you have reviewed it.
>
> Work through this checklist, then **[release outbound](#11-release-outbound-delivery)**
> after you've reviewed the queue and deleted anything you don't want sent.
> Two things must wait until outbound is released: enabling **two-factor** for
> admins (step 6.3, because enrollment e-mails a verification code) and the
> upgrade (step 12).
> Inbound mail and filtering run normally the whole time; only egress is held.

---

## What the migration already did for you

- Restored `hermes` (schema-forwarded to the current baseline), `djigzo`,
  `opendmarc`, `Syslog`; created `authelia` and `nextcloud`.
- Copied portable data: `hermes.key` (DB-secret encryption key), Let's Encrypt
  certs, DKIM signing keys.
- Migrated Authelia users into LDAP as **one-factor** admins.
- Ran **`system_rehost.sh`**, which rewired host identity (server_ip,
  console.host, Postfix myhostname/myorigin, nginx server_name, Authelia cookie
  domain) and **re-rendered postfix, amavis, authelia, nginx, and mailname**
  from the restored database, then restarted those containers.

Settings Postfix reads through **MySQL maps** — **Domains**, **Relay
Recipients**, **Virtual Recipients**, sender/recipient rules — are live directly
from the restored database and need no action.

The exceptions are lookup files that only an admin page writes, which the
migration leaves empty: **domain transports** (the server each domain's mail is
delivered to), per-domain **TLS policy** and **smarthost credentials**, the
**Global Sender Rules** allow/block list, and the **Network Block/Allow** list.
Until each page is saved once, those settings are silently not applied. See
step 2.

> **If you skipped host rewiring** during the migration, run it now:
> `sudo scripts/system_rehost.sh --force` (auto-detects this host's IP/hostname;
> override with `--to-hostname=` / `--to-ip=` if needed).

---

## 1. Verify the migration before anything else

Run the database verifier. It is read-only, takes seconds, and answers the
question the migration log cannot: whether the schema bridge landed what it
claimed.

```bash
sudo ./scripts/verify_legacy_migration.sh
```

It checks the release stamps, the DNSBL return-code filters, that no seeded
table sits below the baseline, that join-table foreign ids resolve, and that
nothing was duplicated beyond what the baseline itself carries. It exits
non-zero on failure.

Do this **before** restoring the email archive (step 9). The archive restore can
take a long time and there is no reason to sit through it only to discover the
database half did not work.

A `NOTE` is for your judgement rather than a failure. Duplicate natural keys, for
instance, are usually rows the legacy gateway already had; the migration is
additive and never rewrites operator data.

## 2. Log in and sanity-check

> ### ⚠️ Before you log in: disable the legacy Console Firewall and Duo from the command line
>
> Two legacy settings come across in the database but stay dormant at first.
> They take effect the first time you save a settings page in the console
> (for example Console Settings or Authentication Settings), and either one
> then locks you out:
>
> - **Console Firewall.** If legacy had it enabled, the console starts
>   refusing every address not on the legacy allow-list (HTTP 403). Your
>   workstation is probably not on it. The firewall cannot be changed in the
>   console until the Pro license is reactivated (step 7), so there is no way
>   back from the UI.
> - **Duo.** If legacy used Duo, the Duo keys did not come across. The first
>   save re-enables Duo without keys, the authentication service refuses to
>   start, and the console returns a 500 error.
>
> Disable both before you do anything else in the console. This is safe to
> run whether or not legacy used them:
>
> ```bash
> docker exec hermes_db_server mariadb -u root hermes -e "UPDATE parameters2 SET value2='disabled' WHERE parameter='firewall_status' AND module='firewall'; UPDATE parameters2 SET value2='true' WHERE module='authelia' AND parameter='duo.disable';"
> ```
>
> Confirm it printed nothing (no error), then check:
>
> ```bash
> docker exec hermes_db_server mariadb -u root hermes -e "SELECT parameter, value2 FROM parameters2 WHERE parameter IN ('firewall_status','duo.disable');"
> ```
>
> Expect `firewall_status | disabled` and `duo.disable | true`. Turn them
> back on later, from the console:
>
> - **Console Firewall** (Sidebar → **System → Console Firewall**): after
>   the license is reactivated in step 7. Add the address you browse from
>   **before** enabling it, and remove legacy entries that no longer apply.
> - **Duo** (Sidebar → **System → Authentication Settings**): enter the Duo
>   **Integration Key** and **Secret Key** (from the Duo Admin Panel), then
>   enable Duo in the same save.

#### Already locked out?

If you saved a settings page before running the command above, run the
command above first, then the recovery for your symptom. Run these from your
Hermes install directory (`/opt/hermes-seg` if you followed the migration
guide; replace it with your path if you cloned elsewhere).

**HTTP 403 on every console page (Console Firewall):** remove the firewall
rules from the live web server configuration and reload it. The first command
keeps a backup copy.

```bash
cd /opt/hermes-seg
cp config/nginx/etc/nginx/sites-available/hermes-ssl.conf config/nginx/etc/nginx/sites-available/hermes-ssl.conf.pre-fw-fix
sed -i -E '/^\s*allow [0-9a-fA-F.:\/]+;$/d; /^\s*deny all;$/d' config/nginx/etc/nginx/sites-available/hermes-ssl.conf
docker exec hermes_nginx nginx -t && docker exec hermes_nginx nginx -s reload
```

**HTTP 500, and `docker logs hermes_authelia` shows `duo_api: option
'integration_key' is required`:** switch Duo off in the live authentication
configuration and restart the service. The first command keeps a backup copy.

```bash
cd /opt/hermes-seg
cp config/authelia/configuration.yml config/authelia/configuration.yml.pre-duo-fix
sed -i '/^duo_api:/,/^[a-z]/ s/^  disable: false/  disable: true/' config/authelia/configuration.yml
docker restart hermes_authelia
```

Then reload the console. If the browser still shows an error, open it in a
private window so an old login session is not reused.

> ### ⚠️ Some migrated settings are NOT applied until you save their page
>
> Several pages write a configuration file only when something on them is
> saved, and the migration does not write those files. Until you do, the
> settings are **silently ignored**: mail for relay domains loops back to this
> gateway and defers, and allow/block lists let blocked senders through. No
> error tells you.
>
> Where a step says to save a page, use its **Apply** / **Save** button if it
> has one. Otherwise edit any one entry and save it unchanged, or, if the page
> has no entries, add a temporary entry and then delete it. Any of these
> rewrites the whole file from the restored database.

1. Log into the admin console (see step 6 if all admins show as one-factor).
2. Sidebar → **Email Relay → Domains** and **Email Relay → Relay Recipients**:
   confirm the migrated data.
3. Sidebar → **Email Relay → Domains**: open any one relay domain and click **Save** without
   changing anything. This writes the delivery route for **every** domain from
   the restored database. Skip it and Postfix has no route, falls back to each
   domain's public MX (usually this gateway itself), and mail defers with
   `Connection timed out`. Confirm by replacing `<your-domain>` with one of
   the relay domains listed on that page, spelled exactly as shown:

   ```bash
   docker exec hermes_postfix_dkim postmap -q <your-domain> hash:/etc/postfix/transport
   ```

   It should print that domain's next-hop server, for example
   `smtp:[mail.example.com]:25`. No output means a typo in the domain or a
   route that was not written. `cat config/postfix-dkim/etc/postfix/transport`
   (from the install directory) lists every route. The same save also writes the
   per-domain TLS policy and smarthost credentials.
4. Sidebar → **Content Checks → Global Sender Rules** and **Content Checks →
   Network Block/Allow**: on each page, open any one entry and click **Save**
   without changing anything. If a page has no entries, add a temporary entry
   and then delete it. Skip this and the migrated allow/block entries are
   ignored: blocked senders and networks get through and nothing reports it.
   Upgrading in step 12 does **not** do this for you.
5. Sidebar → **System → System Status**: confirm all containers are healthy.
6. Sidebar → **System → System Settings**. Confirm the **postmaster address** and
   **admin email** are real addresses, not the `@domain.tld` placeholders. These
   are where system alerts and scheduled-job failure notifications go; a
   placeholder means those are never delivered and nothing tells you.

## 3. Regenerate mail authentication (DKIM, SPF, DMARC)

`system_rehost.sh` does **not** cover these. Each regenerates its own service
config from the database; their `TrustedHosts` lists must carry the Docker
subnet. The DKIM signing keys are already migrated (`opt/hermes/dkim/keys`).

All three live under the **Content Checks** section of the sidebar.

1. **Content Checks → DKIM Settings** → **Save & Apply Settings** — regenerates
   OpenDKIM KeyTable / SigningTable / TrustedHosts referencing the migrated keys.
   Confirm each domain's published DNS TXT record still matches.
2. **Content Checks → SPF Settings** → **Save & Apply Settings** — regenerates policyd-spf.
3. **Content Checks → DMARC Settings** → **Save & Apply Settings** — regenerates OpenDMARC.

## 4. Review the DNSBL list

The migration adds return-code filters to the legacy DNSBL entries that lacked
them, which stops postscreen counting an unrelated answer as a listing. It does
**not** remove or disable any list, because which lists a gateway should use is
the operator's decision.

One needs a deliberate choice:

- Sidebar → **Content Checks → RBL Configuration**. If **`b.barracudacentral.org`** is
  enabled, note that it answers only for querying IPs registered with them. On
  an unregistered host it can score mail it should not. The migration leaves it
  enabled and flags it; disable it unless this host's IP is registered.
- Whether or not you changed anything, click **Apply** in the page toolbar.
  This regenerates the Postfix block-list configuration from the restored
  database.

## 5. Verify Relay Networks (mynetworks)

1. Sidebar → **Email Relay → Relay Networks**: confirm the customer's allowed
   sending networks carried over **and** the Docker subnet is present. Then
   click **Apply Settings**, even if you changed nothing, so the relay network
   lists are regenerated from the restored database.
2. Sidebar → **Email Relay → Relay Host**: verify the upstream smarthost and
   credentials; re-enter the relay password if the field is blank. Then click
   **Save Settings**, even if you changed nothing, so the smarthost credentials
   file is rewritten.

## 6. Reconfigure admin two-factor authentication

> ### ⚠️ Every migrated admin is password-only, even if the UI says Two Factor
>
> All migrated admins are in the **one-factor** group, and legacy TOTP /
> WebAuthn devices were not carried over (Authelia moved SQLite → MySQL). The
> **Access Control** shown in System Users is the legacy setting, not what is
> enforced. Review **every** admin account.
>
> **Do not switch anyone to two-factor before outbound mail works (step 11).**
> Enrollment e-mails a verification code; an admin who cannot receive it is
> locked out of the console. Keep at least one admin on **One Factor** until
> another has enrolled successfully.

1. Verify each admin can log in with their **existing (legacy) password**.
2. Sidebar → **System → System Users**. The **Access Control** shown for a migrated admin
   is the legacy setting, **not** what is enforced. An admin showing **Two
   Factor** is still password-only. Editing a migrated admin also shows a
   "not yet synchronized to LDAP" warning; the account is already in LDAP, and
   the steps below clear it.
3. **Wait until outbound mail works.** Enrolling an authenticator sends the
   admin a verification code by e-mail. Outbound is held until step 11, so a
   two-factor admin who cannot receive that e-mail cannot enroll and is locked
   out of the console. Do this step only after step 11, once a test message
   has reached that admin's address. Keep at least one admin on **One Factor**
   until another admin has enrolled successfully.

   For each admin who should use two-factor, do **two separate saves**:
   1. Edit the user. Set **Set User Password** to **YES**, enter a password,
      set **Access Control** to **One Factor**, and **Save**.
   2. Edit the user again. Set **Access Control** to **Two Factor** and
      **Save** (no password this time).

   A single save with **Two Factor** already selected changes nothing, and a
   save without a password on a not-yet-synchronized account does not change
   groups either. Confirm the result. Replace `<username>` with the admin's
   username exactly as it appears in **System Users** (for example, if the
   user is `jsmith`, the filter reads `member=cn=jsmith,ou=users,...`):

   ```bash
   docker exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -LLL \
     -b ou=groups,dc=hermes,dc=local "(member=cn=<username>,ou=users,dc=hermes,dc=local)" cn
   ```

   It should list `admins` and `two_factor`. The admin enrolls an
   authenticator on their next login.
4. Admins who should stay password-only need no group change. Do step 3.1 only
   if you want to clear the warning.

## 7. Reactivate the Pro license (Pro editions)

The Pro license is bound to the server's hardware UUID, which changed on the new
Docker host, so it shows **invalid / pending**.

1. Email support with the license **serial number** to request reactivation.
2. Support deactivates the old activation so it can re-bind to the new host.
3. Reactivate, then log out and back in to re-validate.

**Important:** until reactivated, the system runs as Community Edition.

Once the license is active, you can re-enable the **Console Firewall** you
disabled in step 2 (Sidebar → **System → Console Firewall**). Add the address
you browse from **before** you enable it.

## 8. Re-establish TLS certificates

The migration copies the legacy certificates (Let's Encrypt and imported) and
they keep serving, but three things need fixing:

- The legacy self-signed certificate row points at Ubuntu files that do not
  exist in Docker. It shows **Pending** on the certificates page, and
  assigning it to the console would stop nginx from starting.
- The legacy Let's Encrypt renewal configuration may not renew on Docker.
- **Webmail** is new and has no certificate assigned.

Certificates are assigned on three separate pages, one per service (see 8.2,
step 1).

> ### ⚠️ Before you touch Console Settings, make sure the console address reaches this host
>
> Saving Console Settings restarts the web server and sends your
> browser back to the console address. Login sessions are tied to that
> address, so you must be browsing the console *at* it. If the address is a
> name (FQDN) that still resolves to the **legacy** server, you will end up on
> the old box or be unable to log back in.
>
> Sidebar → **System → Console Settings** shows the address in **Console
> Address (IP or FQDN)**. If it is a name, check where it resolves. In the
> command below, replace `<console-address>` with that name (for example
> `console.example.com`). Run it on the computer you are browsing from:
>
> ```bash
> nslookup <console-address>
> ```
>
> The address it prints must be this Docker host's IP (on the Docker host,
> `hostname -I` lists it). If it still shows the legacy server's IP, either
> update DNS first or, for testing, add a line to your computer's hosts file
> mapping the name to the new host's IP. Then open the console using that
> name, not the IP, before continuing.

### 8.1 Restore the system self-signed certificate

Point the legacy self-signed row at the Docker bootstrap certificate files,
which the Docker install already created:

```bash
docker exec hermes_db_server mariadb -u root hermes -e "UPDATE system_certificates SET file_name='bootstrap', friendly_name='System Bootstrap Certificate', \`system\`=1 WHERE file_name='ssl-cert-snakeoil';"
```

Sidebar → **System → System Certificates**: the row must now read **System
Bootstrap Certificate** with a grey **SYSTEM** badge next to the name, and show
real details (subject `CN=localhost`) instead of **Pending**. Do not continue
until it does.

### 8.2 Let's Encrypt: request a fresh certificate (recommended)

Requires the certificate's DNS name to resolve to **this** host and TCP 80/443
to be open from the Internet. If DNS still points at the legacy server, keep
the migrated certificate for now and do this right after cutover.

1. Assign **System Bootstrap Certificate** to each service. Each certificate
   field is a picker: click it and choose the certificate, or type part of its
   name to search.
   1. **Console:** Sidebar → **System → Console Settings**. In **Console
      Certificate**, choose **System Bootstrap Certificate**. In the same
      save, set **HTTP Strict Transport Security (HSTS)** to **Disable**: a
      legacy install usually had it enabled, and Hermes refuses to save the
      self-signed certificate with HSTS on, so otherwise nothing is saved.
      Then click **Apply Settings**. Nginx restarts, and the console is
      unavailable for a few seconds. Your browser will warn about the
      self-signed certificate until step 5; accept it to continue.
   2. **SMTP:** Sidebar → **System → SMTP TLS Settings**. In **SMTP TLS
      Certificate**, choose **System Bootstrap Certificate**, then click
      **Save & Apply Settings**.
   3. **Webmail:** Sidebar → **Email Server → Settings**. In **Mail Server
      Certificate**, choose **System Bootstrap Certificate**, then click
      **Save Settings**. The mail server restarts.

   On **System → System Certificates**, the Console, SMTP and Webmail columns
   should now all point at **System Bootstrap Certificate**.
2. Sidebar → **System → System Certificates**: delete the migrated Let's
   Encrypt certificate. Deletion is refused while it is assigned, which is why
   step 1 comes first.
3. Request an ACME certificate with **Staging (Testing)** selected. When it
   succeeds, delete the staging certificate.
4. Request the same certificate again with **Production** selected.
5. Assign the new Let's Encrypt certificate to each service:
   1. **Console:** Sidebar → **System → Console Settings**. In **Console
      Certificate**, choose the new certificate, then click **Apply
      Settings**. Nginx restarts; reload the page and the browser warning is
      gone. Once the console loads at its address without any warning, you
      can set **HTTP Strict Transport Security (HSTS)** back to **Enable** and
      click **Apply Settings** again.
   2. **SMTP:** Sidebar → **System → SMTP TLS Settings**. In **SMTP TLS
      Certificate**, choose the new certificate, then click **Save & Apply
      Settings**.
   3. **Webmail:** Sidebar → **Email Server → Settings**. In **Mail Server
      Certificate**, choose the new certificate, then click **Save
      Settings**.

   Assign it to Mailbox SAN as well if you use it. On **System → System
   Certificates**, the Console, SMTP and Webmail columns should now all point
   at the new certificate.

If you request more than one Let's Encrypt certificate (for example a separate
name for webmail), repeat steps 3 to 5 for each one, assigning each
certificate to the service that uses its name.

A certificate requested on this host renews automatically. A migrated one may
not, because its renewal configuration was written for the legacy server.

### 8.3 Imported certificate (no Let's Encrypt)

Go to each of the three pages below, choose the imported certificate, and
save. Do this on every page **even if the imported certificate already shows
as selected**: the save is what rewrites the service's configuration. Webmail
is new, so it has never had a certificate assigned.

1. **Console:** Sidebar → **System → Console Settings**. In **Console
   Certificate**, choose the imported certificate, then click **Apply
   Settings**. Nginx restarts, and the console is unavailable for a few
   seconds.
2. **SMTP:** Sidebar → **System → SMTP TLS Settings**. In **SMTP TLS
   Certificate**, choose the imported certificate, then click **Save & Apply
   Settings**. This also makes Postfix send the full certificate chain
   instead of only the server certificate.
3. **Webmail:** Sidebar → **Email Server → Settings**. In **Mail Server
   Certificate**, choose the imported certificate, then click **Save
   Settings**. The mail server restarts.

On **System → System Certificates**, the Console, SMTP and Webmail columns
should all point at the imported certificate.

### 8.4 Verify

1. Open the console at its console address. With a Let's Encrypt or other
   CA-signed certificate it loads without a certificate warning. That only
   holds when the console address is a name (FQDN) included in the
   certificate. If the console address is an IP address, or you browse to the
   IP, the browser warns regardless of the certificate.
2. SMTP presents the full chain (expect 2 or more):

   ```bash
   openssl s_client -starttls smtp -connect localhost:25 -showcerts </dev/null 2>/dev/null | grep -c 'BEGIN CERT'
   ```

## 9. Email archive (deferred)

Message History **metadata** is restored, but message **bodies** live in the
separate archive backup (`hermes-archive-<build>-<date>.tar.gz`, where
`<build>` and `<date>` are the legacy build number and backup date in the
actual file name). Restore it when
convenient — it needs no gateway downtime.

- Sidebar → **Content Checks → Message History** — entries appear; bodies are
  viewable only after the archive is restored.

## 10. Final end-to-end test

1. Send a test message **inbound** and **outbound**.
2. Verify: DKIM = pass, spam scoring, and TLS on both legs.

> Outbound is still **paused** at this point, so an outbound test message
> **parks in the queue** rather than delivering. That's expected — you confirm
> actual outbound delivery in step 9 after releasing.

## 11. Release outbound delivery

**Do this only after everything above checks out, except step 6.3
(two-factor), which needs outbound mail and comes right after this step.**

While migrating, outbound has been held so the box could not mail real
recipients (see the notice at the top). Now release it, deliberately, after
reviewing what's queued.

> ### ⚠️ Review the queue and delete anything stale BEFORE you resume
>
> The queue **may** hold quarantine notifications generated from the restored
> quarantine. The migration prevents this, so normally there are few or none,
> but check anyway. Resuming sends everything in the queue at once, so
> anything you do not delete goes to **real recipients** and cannot be
> recalled.

1. Sidebar → **System → Mail Queue**. At the top, the **Outbound Delivery** card shows
   **PAUSED**.
2. **Review the queued mail.** Look for quarantine-notification messages
   (`from postmaster@…`) generated from the restored quarantine. There should
   be few or none. If there are any, **select and delete** them: they are
   stale and should not go out. Keep any genuine mail you want delivered.
3. Click **Resume Outbound Delivery**. This clears the hold and flushes the
   queue; the **Outbound Delivery** card flips to **ACTIVE**.
4. Confirm the outbound test from step 10 now delivers, and watch the mail log
   to be sure only the mail you kept goes out.

> The **Outbound Delivery** control (Mail Queue page) is a permanent pause/resume
> switch — useful for maintenance windows too. Pausing holds all outgoing mail
> in the queue without affecting inbound or filtering.

5. With mail flowing, go back and finish **step 6.3** (two-factor for admins).

---

## 12. Upgrade to the current release

The gateway is now an ordinary **v260912** install. It is not the newest
release, because migration is only supported into that specific one, so bring it
forward.

Do this only once everything above checks out and mail is flowing, so that if an
upgrade turns something up you know it was the upgrade rather than the
migration.

Run this from your Hermes install directory. `/opt/hermes-seg` is the path the
migration guide uses; if you cloned the repository somewhere else, replace it
with that path.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh
```

With no version argument it resolves the latest release and applies every
release directory between here and there, in order. Take a hypervisor snapshot
first, as with any upgrade.

Nothing about this is migration-specific any more. The gateway reports
`build_no = v260912`, so the update orchestrator treats it exactly like a
gateway that had been installed at v260912 and never migrated at all. That is
the point of the version stamp, and the reason migration can end at this
release.
