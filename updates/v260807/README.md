# Hermes SEG v260807

First-run provisioning fixes. Every defect below has been present since the Docker
edition shipped, and each one is invisible on any gateway where an administrator
happened to save the relevant settings page.

## Read this first

### This upgrade clears your SpamAssassin Bayes database

Hermes has been shipping a pre-trained Bayes corpus in the repository: roughly 470
spam and 540 ham messages trained on unrelated mail between 2020 and 2025. Every
install has been scoring your mail partly against that foreign training.

SpamAssassin merges all learning into a single token store, so anything you trained
locally is inseparable from the shipped data. There is no way to remove one and keep
the other. **The upgrade clears the database once**, and your gateway relearns from
its own traffic.

You do not need to do anything. Mail filtering continues via the rule set, RBLs,
ClamAV and the malware feeds. Bayes contributes no score until it has learned roughly
200 spam and 200 ham, which you build with **Train as Spam** and **Train as Ham** in
Quarantine and Message History.

This applies even if you have trained the gateway yourself. A corpus that contains
the seeded data is not worth keeping at any ratio, and there is no way to separate
the two, so the database is cleared outright rather than preserved in a compromised
state. Restoring a backup of it afterwards would reintroduce the foreign training
permanently: the upgrade records the clearing as done, so nothing would ever remove
it again.

### Spam was getting a 5 point discount on every message

SpamAssassin ships three rules querying Validity, the sender-reputation service
formerly known as Return Path. Two of them are **allowlists** with large negative
scores, meant for the small number of senders who pay Validity to be certified.

Validity refuses queries from unregistered resolvers and answers
`127.255.255.255`. SpamAssassin matches that as a hit, so both allowlist rules
fire on **every** message and award it `-5`. Every Hermes install resolves through
its own recursive Unbound instance, so the query always comes from an
unregistered address and there is no configuration in which a stock install
avoids this.

The practical effect is that your configured thresholds have been behaving five
points higher than they read. On the default policy, a message needed to score 7
to be quarantined rather than 2.

The three rules are now scored `0`. They still evaluate and still appear in
`X-Spam-Status`, so nothing becomes harder to diagnose. If you are registered
with Validity and want them back, set the scores through **Score Overrides**;
those render after these defaults and SpamAssassin honours the last one.

**Expect more mail to be caught after upgrading.** That is the intended
correction, but if you had tuned thresholds around the old behaviour, review
them.

### Mail clients could not send: SMTP submission was never enabled

`master.cf` shipped with the `submission` (587) and `smtps` (465) listeners commented
out, in every variant in the repository. Docker published those ports and the mailbox
domain page told you to advertise them over SRV, but Postfix was not listening on
either.

On a mailbox or hybrid install this means **no user could send mail from Thunderbird,
a phone, or any other client**. Receiving worked, and webmail worked, because
Nextcloud Mail reaches Postfix on port 25 across the Docker network rather than
through submission. That is why the gap survived: the two paths most people test
first were both unaffected.

Both listeners are now enabled, with SASL answered by Dovecot and
`reject_sender_login_mismatch` so an authenticated user cannot send as somebody else.

> **If you enabled submission by hand**, the upgrade replaces `master.cf` with the
> repository version and your edit is lost. The shipped configuration is a superset
> of the usual manual fix, so submission keeps working, but check the file afterwards
> if you customised anything else in it.

### Amavis quarantine directories were never created

The installer creates the quarantine root but not the five subdirectories that
`50-user` writes to: `clean`, `virus`, `spam`, `banned` and `bad_header`. Whether this
surfaces depends on your quarantine configuration. When it does, Amavis rejects mail
outright because it has nowhere to write. The upgrade creates all five and corrects
their ownership.

### Mailbox encryption was switched on against empty keys

The installer wrote a Dovecot configuration that enabled mailbox encryption
regardless of the database setting, which defaults to off, pointing at empty
placeholder key files. On affected gateways this breaks IMAP and SMTP
authentication. The upgrade re-renders the configuration from your database, so
whatever you actually chose is what you get.

### Collaborative spam checks are now opt-in

Razor and Pyzor each transmit a digest of every scanned message to a third-party
network. That is a decision for the operator, so new installs now ship with them
disabled.

**Your existing settings are not changed by this upgrade.** If you had them enabled,
they stay enabled. Two things are worth knowing:

- **Razor has never been registered on any Hermes install**, so it has been returning
  no result whether or not it was switched on. Register it once under
  **Content Checks > Antispam Settings > Initialize Razor**. Two separate faults
  were in the way, and both are fixed: registration was writing to `/root/.razor`
  while SpamAssassin reads `/etc/razor`, and the files it writes there were owned by
  root while SpamAssassin runs as `amavis`. Razor writes its home directory at scan
  time, not just at registration, so ownership had to be corrected too. Registering
  now also removes the stale `/root/.razor` identity left behind by earlier attempts.

### Nextcloud Mail was not provisioned when Nextcloud was enabled after the fact

Enabling Nextcloud on a mailbox that was created without it provisioned the account
and `/nc` access, but never the Mail profile, and the failure was silently discarded.
Affected users get a working Nextcloud login with an empty Mail app.

The upgrade repairs affected mailboxes automatically. **If you configured an account
in Nextcloud Mail by hand to work around this, delete it first.** A hand-made account
looks like a working one, so the repair will skip that mailbox.

### Nextcloud rejected the console address on fresh installs

The trusted-domain list was written comma-separated where Nextcloud expects it space
separated, producing one unusable entry. Reaching the console by IP, which is what the
installer configures before DNS exists, returned "Access through untrusted domain".
The upgrade re-renders it.

### Changing the console address locked you out of the console

This one hit every new install, because the installer deliberately sets the console
address to the host IP (there is no DNS yet) and expects you to change it to your real
hostname afterwards. That change was the operation that broke.

Saving a new address restarted Authelia, whose session cookie is scoped to a single
hostname, so it instantly had no session for the address your browser was still on. The
save then handed your browser a redirect to the page that performs the Nginx restart, and
that page is itself behind authentication. It could not load, so Nginx was never
restarted and kept redirecting you to the **old** address with "unable to determine user
state". The configuration files on disk were correct the whole time. The only way back in
was restarting Nginx by hand:

```bash
docker container restart hermes_nginx
```

A console address change now performs the restart from the save itself, the last request
that is still authenticated, and shows you a page that waits for Nginx to come back
before moving you to the new address. Your next sign-in happens after the restart rather
than during it. Certificate, HSTS, OCSP and DH-parameter changes leave your session
intact and are unaffected.

If you are mid-change and locked out right now, run the command above, then open the
console at your new address.

### Four block lists were counting refusals as listings

Four seeded entries shipped with no return-code filter: `bl.spamcop.net`,
`bl.suomispam.net`, `bl.spameatingmonkey.net` and `backscatter.spameatingmonkey.net`.
Without one, postscreen counts **any** answer in `127.0.0.0/8` as a listing, and that
range includes the `127.255.255.0/24` codes these lists return for "query refused" and
"over quota". A gateway whose DNS resolver is being refused therefore scored the
refusals as listings. Each of these carries a weight of 2 against a
`postscreen_dnsbl_threshold` of 3, so two of them answering with error codes reject
legitimate mail on their own.

The upgrade adds `=127.0.0.[2..11]` to all four, preserving whatever weight you had set.
No list is removed and no weight changes.

Related, and worth checking on your own gateway: the **Test** button under
**Content Checks > RBL Configuration** used to report any `127.x` answer as healthy, including
those refusal codes, and reported a list with a live SOA record as healthy even when it
returned no data at all. It now distinguishes three outcomes: data returned, zone
present but silent, and refused or wildcarded. If your lists come back yellow after
this upgrade, they were never contributing, and the old button was telling you they
were fine.

### Check whether your gateway receives block list answers at all

This is worth two minutes on every existing install. Ordinary DNS resolving normally
tells you nothing here, because reputation answers live in `127.0.0.0/8` and that is
exactly what upstream resolvers treat specially.

```bash
docker exec hermes_postfix_dkim dig +short 2.0.0.127.zen.spamhaus.org
```

| Answer | Meaning |
| --- | --- |
| `127.0.0.2` and similar | Working. Nothing to do |
| nothing at all | Your forwarder is discarding the answer, usually DNS rebinding protection refusing to relay loopback addresses |
| `127.255.255.254` | The list is refusing your resolver, which it treats as public or shared |

In the last two cases **no reputation data is reaching the gateway**: postscreen adds no
weight, SpamAssassin's `RCVD_IN_*` rules stay silent, and allowlists such as
`list.dnswl.org` stop applying, so every sender scores as though no reputation data
exists. Spam that should be quarantined gets delivered.

The fix is to switch to recursive resolution under **System > DNS Resolver**, then
re-test with **Test All** under **Content Checks > RBL Configuration**. Forward mode remains the
install default because it works on networks that block outbound port 53, and recursive
requires that port be open to the DNS root servers. New installs now run this same check
automatically and report the result.

### Two default block lists changed

`b.barracudacentral.org` is **no longer seeded on new installs.** It only answers once
the querying IP is registered with Barracuda, so on a stock gateway it returned nothing
while carrying a weight of 7, which is above the rejection threshold of 3 on its own.
**Your existing entry is left alone**, on the same principle as your spam settings. If
you have not registered, remove it under **Content Checks > RBL Configuration**. If you have,
keep it.

Fresh installs also stop shipping `dnsbl.sorbs.net`, `ix.dnsbl.manitu.net` and
`bl.mailspike.net` in the Postfix template. SORBS was retired in 2024, and the other two
were already absent from the database, so a fresh install was filtering against a list
that differed from the one shown in the admin console. The two lists now match.

### Authenticated users were rejected by your own DMARC policy

If your domain publishes `p=reject`, your own users could not send from a mail client. They
authenticated successfully and were then rejected at the end of the message with
`550 5.7.1 rejected by DMARC policy`.

The submission listeners inherited the global milter chain, which includes OpenDMARC. That
made DMARC evaluate authenticated outbound mail as though it had arrived from the internet,
where it fails by construction: the sending address is a laptop or a phone, which is never in
your SPF record, and the signing OpenDKIM instance on that path does not verify, so there is
no DKIM result either. With `RejectFailures` on, a `p=reject` policy then rejected the mail.

DMARC is an inbound check and no longer runs on submission. Port 25 is unchanged.

This was invisible before this release only because submission itself was never enabled.

### The malware feed from URLhaus had silently stopped updating

The URLhaus signature set was capped at 2MB and the feed has grown past 3MB, so fangfrisch
refused it on every run. It exited successfully while doing so, which means the scheduler
recorded the job as fine and nothing surfaced. The ClamAV third-party URLhaus signatures were
simply never refreshed.

The limit is now 10MB. If you have tuned this yourself the upgrade leaves your value alone.

### The scheduler could not deliver its own failure notifications

`hermes_ofelia` was not attached to the mail network, so the address it uses to send job
failure alerts could not be resolved or reached. Jobs ran correctly, which is why this went
unnoticed: the only broken part was the alerting, and alerting is only exercised when
something fails.

### Local DNS records could take DNS down

Adding any record under **System > DNS Resolver > Local DNS Records** wrote a configuration
file that Unbound refused to parse when forwarding is enabled, which is the default. Unbound
then failed to start and crash-looped, taking DNS down for every container. Because the
console needs DNS, the admin UI could not be used to undo it.

The same page also rejected hostnames containing an underscore, which excluded `_dmarc`,
`_domainkey` and the `_submission._tcp` records this product tells you to publish, and could
not store a TXT value containing a semicolon, which is every real SPF, DKIM and DMARC record.

All three are fixed.

### CipherMail logged and stamped mail in UTC

The CipherMail container had no timezone database, so it ran on UTC regardless of your
configured timezone and wrote `+0000 (America)` into the `Received:` header of every message
it handled. Its log lines were also offset from every other container, which makes tracing a
message across the pipeline misleading. The same omission affected the LDAP container.

### Other fixes

- Amavis shipped a default trusted network that was not the Docker subnet, so a fresh install
  trusted an unrelated private range until an administrator saved a Postfix settings page.
- Four administrative pages showed a raw error instead of the normal error page when they hit
  a validation failure.
- `system_update_docker.sh --remote` now selects the container registry and image tag as well
  as the code, so one flag means one source. The per-release image tag is applied only if the
  registry actually has it, so an upgrade that works today cannot start failing.

## What to do

```bash
cd <install-root>
sudo ./scripts/system_update_docker.sh
```

Then, **once**, do this to finish applying the malware feed fix:

1. Open **Content Checks > Malware Feeds**.
2. Save the page without changing anything.

The size limit lands in the database during the upgrade, but the fangfrisch configuration file
is rendered from the database, and saving is what re-renders it. Until then the old limit
stays in effect and URLhaus keeps failing quietly. Confirm with:

```bash
docker logs hermes_ofelia 2>&1 | grep urlhaus | tail -2
```

You want `INFO: ... updated`, not `ERROR: ... size exceeds defined limit`.

Then, **once**, do this to finish applying the block list fix:

1. Open **Content Checks > RBL Configuration**.
2. Click the blue **Edit** (pencil) button on any entry.
3. Save it without changing anything.

That looks odd, and it is: the return-code fix lands in the database during the upgrade,
but Postfix only picks up a changed `postscreen_dnsbl_sites` when that directive is
re-rendered, and saving an entry is what triggers the re-render and the Postfix reload.
Saving any other Postfix-backed settings page, such as **System > Server Setup**, does the
same thing. Until one of those happens, `main.cf` keeps the old unfiltered list.

Confirm it applied. This should print nothing, meaning every entry now carries a return
code:

```bash
docker exec hermes_postfix_dkim postconf -h postscreen_dnsbl_sites | tr ',' '\n' | grep -v '='
```

Everything else in this upgrade applies on its own: the affected configuration is
re-rendered from your database, missing directories are created, ownership is corrected,
and the two one-time repairs run.

## How to confirm it worked

```bash
# Quarantine directories exist and belong to amavis
docker exec hermes_mail_filter ls -ln /mnt/data/amavis

# SpamAssassin configuration has no unsubstituted placeholders
docker exec hermes_mail_filter grep -c 'USE-' /etc/spamassassin/local.cf   # expect 0

# Bayes has been reset and is ready to learn
docker exec hermes_mail_filter sa-learn --dump magic | grep -E 'nspam|nham'

# Nextcloud trusts your console address as its own entry
docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:get trusted_domains
```

Mailbox encryption should be absent from the Dovecot configuration unless you enabled
it under **Email Server > Settings**:

```bash
grep crypt_write_algorithm config/dovecot-2.4/conf/dovecot.conf
```

Every block list carries a return-code filter, and none is left bare. After clicking
Apply, the running configuration should agree with the database:

```bash
# No entry without an '=' return code
docker exec hermes_postfix_dkim postconf -h postscreen_dnsbl_sites | tr ',' '\n' | grep -v '='
```

If Razor is enabled, confirm registration landed where SpamAssassin reads it and that
`amavis` can use it. An identity file in `/etc/razor` owned by `amavis`, and nothing
left in `/root/.razor`, is the correct end state:

```bash
docker exec hermes_mail_filter ls -la /etc/razor
docker exec -u amavis hermes_mail_filter sh -c 'touch /etc/razor/.t && rm -f /etc/razor/.t && echo WRITABLE || echo NOT-WRITABLE'
```

## Why it happened

The installer renders Dovecot and SpamAssassin configuration **before the database
exists**, so it can only mirror the seeded defaults. Where it wrote something the
database disagreed with, the file stayed wrong until an administrator saved the
relevant settings page, at which point the application layer silently corrected it.
Any gateway that had ever been configured through the console looked healthy.

Fresh installs are tested, but that testing verified containers were running and the
database was populated. It never authenticated to IMAP or pushed a message through
Amavis, so every one of these defects sat in the gap between those two things.

The quarantine directories and the ownership pass both existed in the pre-Docker
installer and were dropped during the Docker rewrite.

## What changed

- `scripts/install_hermes_docker.sh`: trusted-domain list is space separated; mailbox
  encryption mirrors the database default; SpamAssassin configuration is rendered
  rather than copied; the five quarantine subdirectories are created; new
  post-container ownership pass for the quarantine tier and the Bayes corpus.
- `config/database/hermes_install.sql`: network checks and Bayes auto-learning seed
  disabled for new installs; both v260807 repairs pre-seeded as complete so a fresh
  install never runs them.
- `schedule/post_upgrade.cfm`: idempotent config re-renders that run on every upgrade,
  plus the two one-time repairs.
- `inc/edit_mailbox_action.cfm`: Nextcloud Mail is provisioned with a purpose-minted
  system app password instead of the account's login password, which Dovecot could
  never have accepted. Provisioning failures are now reported instead of discarded, and
  saving a mailbox again is a valid repair.
- Documentation: getting started and antispam settings pages rewritten around what a
  fresh install actually looks like.

## Known follow-up

- Bayes needs roughly 200 spam and 200 ham before it contributes any score. On a quiet
  gateway that takes a while. This is SpamAssassin's own safety threshold.
- Automatic Bayes learning stays off by default. It trains on the rule set's verdicts,
  so it reinforces their mistakes as readily as their successes.
