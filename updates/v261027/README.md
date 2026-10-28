# Hermes SEG v261027

## Synopsis

> **Upgrade now if you have hybrid domains.** Since v261026, mail to relay
> recipients on a hybrid domain (a domain with both relayed recipients and
> local mailboxes) is rejected. Mailboxes on the domain are not affected.

This release fixes that, stops Nextcloud Mail from tagging mail as
"Important", and shows the full HTML signature on mail sent as plain text
(for example from iPhone Mail). For Pro it also adds a **Test** button for
Link Guard's API keys and the organization name to organizational
signatures, and the upgrade refreshes Link Guard without a manual save.

## New features

- **Test a Link Guard API key (Pro, #377).** Saving a Google Safe Browsing or
  VirusTotal key did not check it, and a wrong key went unnoticed because
  Link Guard skips a provider whose lookups fail. **Email Policies > Link
  Guard > Reputation sources** now has a **Test** button on each provider
  with a key. It sends one request and reports whether the key works, was
  refused, is over its quota, or the provider could not be reached.

- **Signatures in mail sent as plain text (#378).** Phone mail apps such as iPhone
  Mail send plain text unless formatting is used, so recipients saw the
  plain-text version of the signature: no logo, colors or buttons. When a
  signature is added to a plain-text message, Hermes now also gives the
  message an HTML version, so the full signature is shown. The plain-text
  version is kept for clients that prefer it. Signed and encrypted messages
  are left unchanged. The plain-text signature now also keeps link targets,
  for example "Book a meeting: https://...".

## Bug fixes

### All installs

- **Relay recipients on hybrid domains were rejected (#376).** v261026 gave
  each hybrid domain the certificate binding a mailbox domain has (#371). As a
  side effect, Postfix started treating the domain as mailbox-only and
  rejected every relay recipient on it with "550 5.1.1 User unknown in
  virtual mailbox table". Postfix now leaves hybrid domains out of its
  mailbox-only list, and the upgrade applies this to existing installs. The
  certificate binding stays, so mail clients still configure themselves
  automatically.

- **Mailboxes added on a hybrid domain received nothing (#381).** Add
  Mailbox never gave a mailbox on a hybrid domain its route to this server,
  so its mail went to the domain's provider ("Not delivered here"), and
  **Email Delivery > Built-in** refused to fix it. In v261026 such mailboxes
  worked only as a side effect of the problem fixed above. Add Mailbox now
  routes them, including an exemption from a domain catch-all; Built-in
  routes an existing one; and the upgrade routes the ones already created.

- **Users locked themselves out when enabling 2FA (#380).** Clicking **Enable 2FA**
  in the user portal signed the user out at once, and finishing enrollment
  needs a verification email. Users who had not opened their email first
  could not read it and were locked out. The button now opens a warning
  that says so, and only **Enable 2FA and sign out** in that window enables
  2FA, confirming that the user's email is already open elsewhere.
- **Mail marked "Important" in mail clients (#379).** Nextcloud Mail's automatic
  importance classification, on by default, tagged most incoming mail with
  the IMAP keyword Thunderbird and other clients show as "Important". Hermes
  now turns it off for new mailboxes, and the upgrade turns it off for
  existing ones (unless a user chose a setting) and removes the tags it
  already set, from every folder. Thunderbird drops the red tags after it
  resyncs a folder; **Folder Properties > Repair Folder** forces it.

### Pro

- **New Link Guard entries waited for a manual save (#374).** Link Guard
  only picked up entries an upgrade added (such as the v261026 remote-access
  tool hosts) after an admin clicked **Save & Reload**. The upgrade now
  refreshes Link Guard itself whenever Link Guard is in use.
- **Organizational signatures had no organization name (#375).** The
  organization name entered on **Email Server > Domains** was never shown,
  because no signature template had a field for it. Every template now has a
  **Company name** field, filled in automatically and shown under the
  person's name and title. The domain's help text no longer lists
  `{{org.logo}}`, which was never filled in; a logo is added through each
  signature's own **Logo** field, as before.
- **An org signature could be filled in before choosing its domain (#382).**
  The save was then refused with "A domain is required". Templates can now
  only be chosen once a domain is selected.

## Upgrading

**Before.** Take a backup or snapshot.

**If hybrid-domain mail is being rejected now** and you cannot upgrade yet,
replace the `query =` line in
`config/postfix-dkim/etc/postfix/mysql-virtual-mailbox-domains.cf` (in your
Hermes install directory) with:

```text
query = SELECT 1 FROM mailbox_domains md WHERE md.domain='%s' AND NOT EXISTS (SELECT 1 FROM domains d WHERE d.domain = md.domain AND d.type = 'hybrid')
```

then run `docker exec hermes_postfix_dkim postfix reload`. The upgrade makes
the same change, so leave it in place.

**Upgrade.** Run from your Hermes install directory
(`/opt/Hermes-Secure-Email-Gateway` here; replace it with your own if you
cloned elsewhere):

```bash
cd /opt/Hermes-Secure-Email-Gateway
sudo ./scripts/system_update_docker.sh v261027
```

**After.**

- If you use organizational signatures (Pro), open each one under **Email
  Policies > Org Signatures** and click **Save**. A signature
  shows the company name only after it is saved again.
- If you upgrade from a release before v261026, also follow the v261026
  notes: add the URLhaus Auth-Key. Link Guard no longer needs the manual
  save.
