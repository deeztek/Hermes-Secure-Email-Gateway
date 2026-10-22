# Hermes SEG v261026

## Synopsis

Domains that host both relayed recipients and local mailboxes (hybrid
domains) are now handled like mailbox domains where it matters: their
mailbox settings can be edited, and their mail clients can configure
themselves automatically.

## Bug fixes

### All installs

- **Hybrid domains had no place for their mailbox settings (#371).** A
  domain becomes hybrid when relay recipients on it are converted to
  mailboxes. It stayed listed only on Relay Domains, so its organization
  details (used by organizational signatures), user signatures setting,
  default quota, Nextcloud and MFA defaults, and certificate could not be
  set. **Email Server > Domains** now lists hybrid domains, marked
  **Hybrid**, and edits them. Delete is not offered there (a hybrid domain
  still relays mail and is removed from Relay Domains), and neither is a
  catch-all mailbox, which would capture the relayed users' mail too. Relay
  Domains links each hybrid domain to its mailbox settings.
- **Mail clients could not configure themselves for converted mailboxes
  (#371).** Converting relay recipients to mailboxes did not create the
  domain's certificate binding, so the domain never got its `autoconfig.`
  and `autodiscover.` host names. Conversion now creates it, the way adding
  a mailbox domain does, and the upgrade creates it for domains converted
  earlier. Once DNS for those names points at Hermes, the scheduled
  certificate check verifies them, issues the certificate and serves them,
  as for any mailbox domain.

## Upgrading

**Before.** Take a backup or snapshot.

**Upgrade.** Run from your Hermes install directory
(`/opt/Hermes-Secure-Email-Gateway` here; replace it with your own if you
cloned elsewhere):

```bash
cd /opt/Hermes-Secure-Email-Gateway
sudo ./scripts/system_update_docker.sh v261026
```

**After.** If you have hybrid domains, open **Email Server > Domains**:
each is listed with the **Hybrid** badge. Fill in its organization details
if you use organizational signatures. For automatic mail client setup,
create DNS records for `autoconfig.<domain>` and `autodiscover.<domain>`
pointing at Hermes, as for any mailbox domain.
