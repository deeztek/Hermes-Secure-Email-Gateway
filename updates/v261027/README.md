# Hermes SEG v261027

## Synopsis

> **Upgrade now if you have hybrid domains.** Since v261026, mail to relay
> recipients on a hybrid domain (a domain with both relayed recipients and
> local mailboxes) is rejected. Mailboxes on the domain are not affected.

This release fixes that, and adds the organization name to the
organizational signature templates.

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

### Pro

- **Organizational signatures had no organization name (#375).** The
  organization name entered on **Email Server > Domains** was never shown,
  because no signature template had a field for it. Every template now has a
  **Company name** field, filled in automatically and shown under the
  person's name and title. The domain's help text no longer lists
  `{{org.logo}}`, which was never filled in; a logo is added through each
  signature's own **Logo** field, as before.

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
  notes: re-save Link Guard and add the URLhaus Auth-Key.
