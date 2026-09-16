# Network Aliases

Maps to **System > Network Aliases** (`view_network_aliases.cfm`, `inc/get_network_aliases.cfm`, `inc/alias_apply_consumers.cfm`, `inc/alias_stamp_applied.cfm`, `inc/alias_covered_cidrs.cfm`, `inc/cidr_validate.cfm`, `schedule/refresh_network_aliases.cfm`).

Community and Pro. Added in v260912.

Cloud mail providers publish the IP ranges their servers send from, and those ranges change. A range pasted into Relay Networks or a block list by hand goes stale silently: mail starts failing weeks later and nothing points at the cause.

A **network alias** is a named set of CIDR ranges that keeps itself current. Point it at a provider's published SPF record and a scheduled job re-resolves it. Pages that need those ranges reference the alias by name instead of holding a copy.

Two aliases ship pre-loaded and **disabled**: Google Workspace and Microsoft 365. Nothing happens until you enable one and reference it somewhere.

## The indirection is resolved before anything is written

Postfix, Amavis and fail2ban never see an alias. The name is replaced with the alias's current ranges each time a configuration file is generated.

```
network_aliases            "Google Workspace"
        │
        └── network_alias_entries   209.85.128.0/17, 74.125.0.0/16, ...
                    │
                    ▼
            v_alias_ranges      (alias enabled? range included? family usable?)
                    │
        ┌───────────┼───────────────────────┐
        ▼           ▼                       ▼
  Relay Networks   Network Block-Allow   Intrusion Prevention
        │           │                       │
        ▼           ▼                       ▼
  main.cf           postscreen_access    jail.local
  mynetworks        .cidr                ignoreip
  +
  /etc/amavis/mynetworks
```

Three consumers, four files. Relay Networks writes two of them.

If you ever find an alias **name** inside a configuration file, expansion has failed. The check is:

```bash
docker exec hermes_postfix_dkim grep -rl "Google Workspace" /etc/postfix/
```

No output is the correct result.

## What decides whether a range is written

Three conditions, all held in the `v_alias_ranges` view so that every consumer applies the same rules:

| Condition | Set where |
| --- | --- |
| The alias is enabled | The alias row |
| The range is included | The Include checkbox on the range |
| The address family is usable on this deployment | `alias_ipv6_enabled` in System Settings |

The third exists because the mail containers run with `net.ipv6.conf.all.disable_ipv6=1`. IPv6 ranges are stored so the data stays correct, and filtered out when files are written. The Ranges column shows both numbers, for example `5 in use` with `6 IPv6, not rendered while IPv6 is disabled`.

## Source types

| Type | Behaviour |
| --- | --- |
| `spf` | Resolved from a DNS TXT record, for example `_spf.google.com`. Follows `include:` and `redirect=` within the SPF specification's ten-lookup limit |
| `static` | A hand-entered list. Nothing resolves it |

Enabling an SPF alias resolves it immediately. **Resolve Now** on a row resolves that one alias on demand.

## Changes apply themselves

When an alias's ranges change, by a resolve or by hand, the pages that reference it are regenerated straight away. There is nothing to retype and nothing to remember.

Each consumer is applied independently. If one fails, for example because a container is down, the other two still apply and the failed one is listed as **not applied** on this page and on the dashboard until it succeeds. That listing is driven by comparing when the ranges last changed against when each consumer last wrote its file, so it clears by itself once the page catches up.

### What this means for Relay Networks

Adding any range to Relay Networks grants it **unconditional trust**: it may relay to any destination and it bypasses the anti-spam checks. That is correct for a mail server you own.

It is not appropriate for a cloud provider's shared outbound ranges, because those ranges are shared with every other customer of that provider. Putting them in `mynetworks` does not trust the provider, it trusts everyone who uses the provider.

An alias makes such a configuration easier to maintain. It does not make it safe. If you need to accept mail from a provider on behalf of your own domains, that is a different mechanism and is not the same as adding the ranges here.

## Three rules the resolver will not break

1. **A failed or empty resolve never empties an alias.** The ranges from the last good resolve stay in place and the failure is reported. A DNS problem must not quietly remove every trusted network.
2. **Ranges you typed by hand are never removed by a resolve.** They carry `origin = manual` and are left alone.
3. **A range you switched off stays off.** Re-resolving does not switch it back on.

## Switching one range off

A resolved range cannot be deleted, because the resolver would put it straight back on its next run. Uncheck **Include** instead. The row stays visible and greyed, and is left out of every configuration file.

Use this when a provider publishes a range you do not want to trust.

Ranges you typed by hand work the other way round: they have a delete button and no checkbox, because nothing will bring them back and excluding one is the same as removing it.

## An alias in use cannot be changed out from under its consumers

While an alias is referenced anywhere, it cannot be deleted, disabled, or renamed. All three would silently change what the referencing pages mean:

- **Deleting or disabling** removes its ranges from every consumer on their next write.
- **Renaming** breaks every reference, because consumers store the name.

Remove the references first. The **Used by** column shows where they are.

## Ranges Postfix would reject are refused

A CIDR with host bits set, such as a /23 that starts on an odd third octet, looks correct and is not. Postfix does not skip such an entry: the whole lookup errors, and for `mynetworks` that means the postscreen access list stops being consulted entirely and legitimate mail starts being deferred.

Every page that accepts an IP range refuses these and names the address you almost certainly meant:

```
192.168.101.0/23: has host bits set, so Postfix will reject it.
Did you mean 192.168.100.0/23?
```

This applies to aliases, Relay Networks, Network Block-Allow, the Intrusion Prevention whitelist, and ranges read from a published SPF record. Entries that already exist are not changed, so a gateway upgraded from an earlier release keeps anything it already had until someone edits it.

## Already covered by an alias

On a page that references an alias, a hand-typed row whose range the alias also supplies is marked **Also in alias**. The duplicate is harmless, since Postfix, Amavis and fail2ban all ignore repeats, and the configuration file is left showing exactly what is configured. The marker is there so you can remove the redundant row and see the duplicate disappear for the right reason.

This is the normal state while moving from pasted ranges to an alias.

## The scheduled resolver

An `ofelia_jobs` row runs `schedule/refresh_network_aliases.cfm` daily at 03:30. It resolves every enabled SPF alias, applies the consumers of any alias whose ranges moved, and emails `admin_email` a record of what changed and what was applied.

The email is sent on change only. A clean resolve where nothing moved sends nothing, so the one that matters is not buried in daily noise.

The email is a one-shot. The signal that persists is the **not applied** callout on this page and the dashboard alert, which stay until every consumer has written the current ranges.

## Database schema

| Object | Purpose |
| --- | --- |
| `network_aliases` | Name, description, source type and value, enabled, last resolve status, `ranges_changed_at` |
| `network_alias_entries` | One row per range: `cidr`, `family`, `origin` (`resolved` or `manual`), `included`, first and last seen |
| `network_alias_applied` | When each consumer last wrote a given alias. Drives the not-applied warning |
| `v_alias_ranges` | The view every consumer reads. Holds the enabled, included and family rules in one place |

`v_alias_ranges` reads `system_settings`, so in `hermes_install.sql` it must be defined after the tables it references. Views are kept at the end of that file for this reason.

## Files and containers touched

| Path | Written by |
| --- | --- |
| `/etc/postfix/main.cf` (`mynetworks`) | Relay Networks apply |
| `/etc/amavis/mynetworks` | Relay Networks apply |
| `/etc/postfix/postscreen_access.cidr` | Network Block-Allow apply |
| `/config/fail2ban/jail.local` (`ignoreip`) | Intrusion Prevention apply |

Reloads, not restarts: `postfix reload`, `amavis force-reload`, `fail2ban-client reload`.

`ignoreip` is written as indented continuation lines, so `grep ignoreip` shows only the first. Read the block:

```bash
docker exec hermes_fail2ban sed -n '1,8p' /config/fail2ban/jail.local
```

## Related

- [Relay Networks](../02-email-relay/relay-networks.md) for what `mynetworks` actually grants, and why that matters before you point an alias at it.
- [Network Block-Allow](../04-content-checks/network-block-allow.md) for the postscreen access list.
- [IPS](intrusion-prevention.md) for the fail2ban whitelist.
- [Scheduled Tasks](scheduled-tasks.md) for the resolver job.
