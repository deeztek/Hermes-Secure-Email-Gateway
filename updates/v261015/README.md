# Hermes SEG v261015

## Synopsis

A fix release with one new feature. The main fix: legitimate mail from senders
whose domain publishes a strict DMARC policy (banks, credit bureaus, large
retailers) could be tagged as spam even though it passed DMARC. Relay
Recipients can now be given user-portal accounts and a welcome email in bulk,
which matters most for installs migrated from the legacy version. Upgrade
recommended for all installs.

## New features

- **Provision Portal Accounts and Send Welcome Email on Relay Recipients.**
  Recipients that have no user-portal account (every recipient on an install
  migrated from legacy) can be given one, optionally with a welcome email that
  explains how to set a password, plus a message of your own. A banner shows
  how many recipients have no account and provisions them all in one step;
  the toolbar buttons act on the selected recipients. Existing accounts are
  left alone and not emailed, so it is safe to run again (#359).
- **Portal Account column on Relay Recipients** (Yes / No) (#359).
- **Filter drop-downs on Relay Recipients and Mailboxes.** Relay Recipients
  filters by Domain, Portal Account, Auth, 2FA, Backend, Policy and Quarantine
  Notifications. Mailboxes adds Auth, 2FA, Policy, Notifications, Nextcloud
  and Status to its existing Domain and Delivery filters. Reset filters clears
  them all (#359).

- **Certificate and keyring generation failures say which recipient and
  why.** The Generation Failures banner on Relay Recipients now lists each
  failed recipient with its error, the same banner appears on Mailboxes, the
  affected rows show a red **Failed** badge (the error is in its tooltip), and
  failures can be dismissed without retrying (#364).

- **`scripts/audit_legacy_migration.sh`** checks an install migrated from
  legacy against the legacy system backup and reports what did not come
  across: files, cron jobs, tables, rows and incompatible columns. It changes
  nothing. Run it with `-B <legacy hermes-system backup>`.

## Bug fixes

- **Legitimate mail from domains with a strict DMARC policy was tagged as
  spam.** SpamAssassin's DMARC check depends on its own DKIM and SPF checks,
  which Hermes turns off because OpenDKIM and the SPF service already do that
  work earlier in the pipeline. With nothing to go on, it judged every message
  from a `p=reject` or `p=quarantine` domain to have failed DMARC. It is now
  turned off; OpenDMARC remains the DMARC check (#360).
- **OpenDMARC did not apply a parent domain's DMARC policy to its
  subdomains.** Mail from a subdomain without its own DMARC record (for
  example `e.example.com` under `example.com`) was evaluated as having no
  policy, so forged mail from such subdomains was not rejected. It now
  inherits the parent domain's policy, as DMARC specifies (#360).
- **Saving Score Overrides or Antispam Settings took minutes.** Each save
  validated the SpamAssassin configuration twice and restarted the mail filter
  twice; it now does each once, so saves are about twice as fast and incoming
  mail is paused once instead of twice.

### Installs migrated from legacy

- **Adding a relay recipient or a mailbox failed** with "Field 'id' doesn't
  have a default value". A column left over from the legacy database blocked
  the new recipient's settings from being saved. The upgrade removes it. A
  recipient whose add failed this way was only partly created: delete it and
  add it again after upgrading (#362).

## Upgrading

**Upgrade.** Run from your Hermes install directory
(`/opt/Hermes-Secure-Email-Gateway` here; replace it with your own if you
cloned elsewhere):

```bash
cd /opt/Hermes-Secure-Email-Gateway
sudo ./scripts/system_update_docker.sh v261015
```

**After, only if it applies to you:**

- **Your install was migrated from legacy and you added Score Overrides for
  `DMARC_REJECT` or `DMARC_QUAR`.** On the legacy version these rules never
  ran, so the overrides had no effect; on earlier Docker releases they made
  the false spam tagging above worse. After this upgrade they have no effect
  again, and you can delete them under **Antispam > Score Overrides**.
- **Behaviour change with Reject Failures on.** Because OpenDMARC now applies
  parent domain policies, mail from a subdomain that genuinely fails DMARC
  under a parent with `p=reject` is now rejected, as it should have been.

Everyone else has nothing to do after the upgrade.
