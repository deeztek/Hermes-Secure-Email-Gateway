# System Notifications

Admin path: **System > System Notifications** (`view_system_notifications.cfm`,
`inc/ofelia_generate_config.cfm`, `schedule/health_check_mailqueue.cfm`).

This page configures **how the gateway tells the operator that
something needs attention** when no admin is at the console. There are
two delivery channels (Pushover and e-mail) and a per-event toggle
list that decides which scheduled checks fire alerts on which channel.

The page itself is small — one settings card, one toggle list — but
its outputs land in three different places: a row in `system_settings`
(Pushover credentials), `active` flags on rows in `ofelia_jobs` (which
container-side scheduled jobs run), and a regenerated Ofelia config
file (`config.ini` on `hermes_ofelia`).

## What this page is — and isn't

| Is | Isn't |
|---|---|
| The configuration page for **outbound** operator alerts: Pushover push notifications + e-mail to `admin_email` | The **on-screen** dashboard alerts under the navbar (those come from `inc/system_alerts.cfm` and render at every page load — they are not configurable here) |
| A toggle list of which scheduled health checks send Pushover alerts when they fire | A free-form "send me this event" rule builder. The set of supported events is fixed and lives in the `pushover_notifications` table. |
| The owner of the Pushover API token + user/group key for the whole install | A per-user setting. There is one Pushover endpoint per gateway; use a **Pushover Group Key** if you need to fan out to multiple admins. |

> **Dashboard alerts vs. notifications.** The yellow / red callout
> banners that appear under the top navbar (license expiring, mail
> queue backed up, certificate near expiry, etc.) are rendered by
> `inc/system_alerts.cfm` and are not configurable. They fire whenever
> their underlying condition is true, every page load, no matter
> who is logged in. This page is for **emailed / pushed** alerts when
> nobody is looking at the console. Both systems can fire on the same
> underlying event (a mail queue spike will show as a callout AND
> trigger a Pushover push) but they are independent code paths.

## Where the values live

| Setting | Table.column | Default |
|---|---|---|
| Pushover master toggle | `system_settings.pushover_enabled` | `0` |
| Pushover API token (Application Token) | `system_settings.pushover_api_token` | empty |
| Pushover user / group key | `system_settings.pushover_user_key` | empty |
| Per-notification enable flag | `pushover_notifications.enabled` | `2` (disabled) — `1` = enabled |
| Per-notification Ofelia binding | `pushover_notifications.ofelia_job_name` | seeded |
| Ofelia job active flag | `ofelia_jobs.active` | per-job |
| Admin destination address | `system_settings.admin_email` | `someone@otherdomain.tld` |
| Notification `From:` envelope | `system_settings.postmaster` | `postmaster@domain.tld` |

The last two rows live on the [System Settings](system-settings.md)
page, not here. This page **reads** them but does not write them — set
those first, then come back here.

`pushover_notifications` is the canonical registry of every alert that
*can* be sent. Each row pairs a display name + description (shown in
the toggle list) with an Ofelia job name that drives the actual check.
The current seed has one row:

| `name` | `display_name` | `ofelia_job_name` | `category` |
|---|---|---|---|
| `mailqueue_check` | Mail Queue Health Check | `[job-exec "hermes-health-check-mailqueue"]` | `health` |

New notification types are added by inserting a row in this table
(plus the matching row in `ofelia_jobs`) — no code change to the page
itself is needed.

## Pushover Settings card

Sets the per-install Pushover endpoint. Three fields:

| Field | Validation in `save_pushover` |
|---|---|
| Pushover Notifications (Enabled / Disabled) | Must be `0` or `1` |
| API Token (Application Token) | Required when enabled; must match `^[a-zA-Z0-9]{30}$` |
| User / Group Key | Required when enabled; must match `^[a-zA-Z0-9]{30}$` |

Get the values from [pushover.net](https://pushover.net): create an
**Application** to mint the API Token, and either use your own User
Key or create a **Group** to fan out to multiple admins.

After a successful save the form re-displays with a **Send Test
Notification** button that POSTs `action = test_pushover`. The test
sends a real Pushover message at priority `0` (default sound `pushover`)
and surfaces the HTTP status — anything non-200 reports the
`fileContent` as the error detail. Use this to confirm the token + key
pair is good before relying on the channel for real alerts.

## Save flow

```
POST action=save_pushover
   │
   ▼
 Validate pushover_enabled in {0,1}
 If enabled, validate token + key length + alphanumeric pattern
   │
   ▼
 UPDATE system_settings SET value=<x> WHERE parameter IN
   ('pushover_enabled','pushover_api_token','pushover_user_key')
   │
   ▼
 Sync ofelia_jobs.active per the rules below
   │
   ▼
 ofelia_generate_config.cfm  ──►  hermes_ofelia /config/config.ini
                                 (Ofelia re-reads on file change)
   │
   ▼
 cflocation back to view_system_notifications.cfm with session.m=1
```

The Ofelia sync rules are the moving part. The page wants two
conditions to BOTH be true before a notification job actually runs:

1. The **per-notification** toggle in the Available Notifications list
   is on (`pushover_notifications.enabled = 1`)
2. The **master** Pushover toggle is on (`system_settings.pushover_enabled = 1`)

| Master toggle | Per-notification toggle | `ofelia_jobs.active` becomes |
|---|---|---|
| `1` (on) | `1` (on) | `1` (job runs on schedule) |
| `1` (on) | `2` (off) | `2` (job dormant) |
| `0` (off) | any | `2` (all `type='pushover'` jobs dormant) |

So disabling the master Pushover toggle is a safe global kill switch
— every individual notification job stops scheduling. Re-enabling
restores only the per-notification rows that were previously on, not
all of them.

## Toggling a single notification

The Available Notifications card renders one row per
`pushover_notifications` entry, with a clickable toggle pill. Clicking
the pill POSTs `form_action = toggle_notification` with the
notification's row ID. The handler flips
`pushover_notifications.enabled` between `1` and `2`, applies the same
two-condition rule above to `ofelia_jobs.active`, regenerates the
Ofelia config, and redirects back with `session.m = 9`.

The card is **only rendered when the master Pushover toggle is on** —
if Pushover is off there is nothing to toggle per-event, so the list
is hidden.

## Ofelia is the scheduler

Hermes runs all of its recurring checks under [Ofelia](https://github.com/mcuadros/ofelia)
in the `hermes_ofelia` container. The `ofelia_jobs` table holds the
authoritative job definitions; `inc/ofelia_generate_config.cfm`
re-renders `config.ini` from the table and Ofelia hot-reloads. The
notification-side toggles on this page write `ofelia_jobs.active` for
rows where `type = 'pushover'`; other Ofelia jobs (DKIM cron,
certificate renewal, DMARC report processing, etc.) are managed by
their own pages or by [Scheduled Tasks](scheduled-tasks.md).

The seeded mailqueue job runs every 15 minutes:

| Field | Value |
|---|---|
| `job_name` | `[job-exec "hermes-health-check-mailqueue"]` |
| `schedule` | `@every 15m` |
| `command` | `/usr/bin/curl --silent http://localhost:8888/schedule/health_check_mailqueue.cfm` |
| `container` | `hermes_commandbox` |
| `type` | `pushover` |

The CFM target (`schedule/health_check_mailqueue.cfm`) is the real
worker — Ofelia just curls it. The CFM reads
`system_settings.pushover_*`, runs `health_check_mailqueue.sh` to
count the Postfix queue, and on `count > 20` sends both a Pushover
warning AND an e-mail to `admin_email`. The Pushover path is wrapped
in `<cftry>` so a Pushover outage falls through to e-mail — both
channels fire for the same event by design, so the admin gets the
alert even if one channel is broken.

## E-mail delivery path

Notification e-mails are sent via `<cfmail server="hermes_postfix_dkim"
port="10026">`. Port `10026` is Postfix's **post-Amavis re-injection**
listener, which means:

| Property | Behaviour |
|---|---|
| `From:` | `system_settings.postmaster` |
| `To:` | `system_settings.admin_email` |
| Content filtering | **Skipped.** 10026 is post-Amavis — these messages never go through SpamAssassin or ClamAV. |
| DKIM signing | Applied normally (OpenDKIM milter on the post-Amavis path) |
| Transport | Normal SMTP from `hermes_postfix_dkim` to the destination MX |

Skipping content filtering is by design — if Amavis itself is the
thing that's broken, the notification still has to reach the admin.
The trade-off is that a hostile actor with write access to the
gateway could in principle use this same path to inject mail; the
mitigation is that only the gateway's own CFML scheduled jobs target
this port (it is not exposed to the world).

## Adding a new notification type

The page is data-driven — adding a new alert requires no UI change.
Three artefacts need to land together in a schema-update script:

1. A new row in `pushover_notifications` (`name`, `display_name`,
   `description`, `ofelia_job_name`, `category = 'health' | 'security' | ...`)
2. A matching row in `ofelia_jobs` (`type = 'pushover'`,
   pointing at the worker URL)
3. The worker CFM under `config/hermes/var/www/html/schedule/` that
   does the actual check and `cfhttp`-POSTs Pushover + `cfmail`s the
   admin

The Available Notifications card will pick up the new row at the next
page load. The master/per-event toggle rules above apply automatically.

## Pro-vs-Community

System Notifications is a **Community-tier** page. The Pushover
integration, e-mail alerts, and toggle list all work on Community
installs. The Pro license check on the page header (the small comment
block in the include's CFML preamble) is part of the file-fingerprint
manifest — it doesn't gate functionality, only proves the file is
unmodified.

## Failure semantics

| What breaks | What happens |
|---|---|
| Pushover credentials wrong | Save succeeds (no live validation), but Test Notification returns non-200; `session.m = 8` surfaces the API response in the error banner |
| API Token / User Key format wrong (not 30 alphanumeric chars) | Save rejected (`session.m = 4` / `5`); no DB write |
| Master Pushover toggle off | All `type='pushover'` Ofelia jobs flipped to `active = 2`; e-mail path still runs from `health_check_mailqueue.cfm` |
| Ofelia config regen errors | The toggle save still commits to the DB; the `cftry` wrapper around `ofelia_generate_config.cfm` swallows the error. Re-save to retry. |
| `admin_email` empty | `cfmail` will accept an empty `to=` and produce an undeliverable message in the queue; set `admin_email` on [System Settings](system-settings.md) first |
| `pushover.net` unreachable | `health_check_mailqueue.cfm` falls through to e-mail; admin still gets the alert |
| `hermes_postfix_dkim:10026` listener down | E-mail path fails too. The on-screen dashboard alerts (from `inc/system_alerts.cfm`) are the last line of defence — they need no transport. |

## Files and tables touched

| Path / table | Role |
|---|---|
| `system_settings` (rows `pushover_enabled`, `pushover_api_token`, `pushover_user_key`, `admin_email`, `postmaster`) | Channel config + addresses |
| `pushover_notifications` | Registry of every alert type the page can toggle |
| `ofelia_jobs` (`type = 'pushover'` rows) | Per-notification scheduler entries |
| `config/hermes/var/www/html/admin/2/view_system_notifications.cfm` | Page |
| `config/hermes/var/www/html/admin/2/inc/ofelia_generate_config.cfm` | Re-renders `hermes_ofelia /config/config.ini` from `ofelia_jobs` |
| `config/hermes/var/www/html/schedule/health_check_mailqueue.cfm` | The mail queue worker; reads Pushover creds, sends push + e-mail |
| `https://api.pushover.net/1/messages.json` | Outbound HTTPS endpoint for every Pushover send (Test + live alerts) |

## Related

- [System Settings](system-settings.md) — sets `admin_email` and `postmaster` (the addresses this page delivers to / from)
- [System Status](system-status.md) — the dashboard-callout side of the alert system (`inc/system_alerts.cfm`)
- [Scheduled Tasks](scheduled-tasks.md) — admin view of the full `ofelia_jobs` table; the same Ofelia container drives every recurring task on the gateway
- [Mail Queue](mail-queue.md) — the page the mail queue alert is asking you to look at when it fires
