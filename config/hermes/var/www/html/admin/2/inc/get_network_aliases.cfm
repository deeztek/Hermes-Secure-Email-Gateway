<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
  Data for view_network_aliases.cfm (#324).

  An alias is a named set of CIDR ranges. `static` is a hand-entered list;
  `spf` carries a hostname that the scheduled resolver expands.

  usable_count is what consumers would actually write: v_alias_ranges applies
  enabled, included and the address-family policy in one place. stored_count is
  every row. The difference is ranges that exist but are not being rendered,
  because they were unchecked or because their family is not enabled on this
  deployment. The page shows both rather than a total that will not match what
  lands on disk.
--->

<cfquery name="get_aliases" datasource="hermes">
SELECT a.id,
       a.name,
       a.description,
       a.source_type,
       a.source_value,
       a.enabled,
       a.last_resolved,
       a.last_status,
       a.last_message,
       (SELECT COUNT(*) FROM v_alias_ranges v
         WHERE v.alias_id = a.id) AS usable_count,
       (SELECT COUNT(*) FROM network_alias_entries e
         WHERE e.alias_id = a.id) AS stored_count
FROM network_aliases a
ORDER BY a.name ASC
</cfquery>

<!---
  Consumer references per alias, so the page can say where an alias is used and the
  admin knows which page to apply after a change. One clause per consumer: Relay
  Networks, Network Block-Allow, and the Intrusion Prevention whitelist. A new
  consumer adds a clause here, a branch in aliasReferenceCount() on
  view_network_aliases.cfm, and a branch in aliasConsumers() on
  schedule/refresh_network_aliases.cfm, or it is invisible to the delete guard and
  to the change email.
--->
<cfquery name="get_alias_consumers" datasource="hermes">
SELECT a.name AS alias_name, 'Relay Networks' AS consumer, 'view_relay_networks.cfm' AS page
FROM parameters p JOIN network_aliases a ON a.name = p.parameter
WHERE p.parent_name = 'mynetworks' AND p.child = '1' AND p.network_entry = '2'
GROUP BY a.name
UNION ALL
SELECT a.name, 'Network Block-Allow', 'view_network_block_allow.cfm'
FROM postscreen_access s JOIN network_aliases a ON a.name = s.sender
WHERE s.entry_type = 'alias'
GROUP BY a.name
UNION ALL
SELECT a.name, 'Intrusion Prevention', 'view_intrusion_prevention.cfm'
FROM intrusion_prevention_whitelist w JOIN network_aliases a ON a.name = w.ip_cidr
WHERE w.entry_type = 'alias'
GROUP BY a.name
</cfquery>

<!--- An alias can be used by several consumers, so collect a list per alias. --->
<cfset aliasConsumerList = StructNew()>
<cfloop query="get_alias_consumers">
  <cfif NOT StructKeyExists(aliasConsumerList, get_alias_consumers.alias_name)>
    <cfset aliasConsumerList[get_alias_consumers.alias_name] = []>
  </cfif>
  <cfset ArrayAppend(aliasConsumerList[get_alias_consumers.alias_name], {
    text = get_alias_consumers.consumer,
    page = get_alias_consumers.page
  })>
</cfloop>

<!---
  Entries for the alias the operator opened, if any. Ordered by family then the
  text of the range, which is not numeric ordering but is stable and readable;
  these lists are tens of rows, not thousands.
--->
<cfparam name="detail_alias_id" default="0">
<cfif IsNumeric(detail_alias_id) AND detail_alias_id GT 0>
  <cfquery name="get_alias_entries" datasource="hermes">
  SELECT id, alias_id, cidr, family, origin, included, first_seen, last_seen
  FROM network_alias_entries
  WHERE alias_id = <cfqueryparam value="#detail_alias_id#" cfsqltype="cf_sql_integer">
  ORDER BY family ASC, cidr ASC
  </cfquery>

  <cfquery name="get_detail_alias" datasource="hermes">
  SELECT id, name, source_type, source_value, enabled, last_resolved, last_status, last_message
  FROM network_aliases
  WHERE id = <cfqueryparam value="#detail_alias_id#" cfsqltype="cf_sql_integer">
  </cfquery>
</cfif>

<!---
  Alias changes that have not been applied yet.

  An alias is pending on a consumer when its ranges moved after that consumer
  last rendered it. ranges_changed_at is stamped by every path that changes
  ranges; network_alias_applied is stamped by each generator when it writes its
  file. A missing applied row means never applied, which is why the join is a
  LEFT JOIN.

  Scoped to consumers that actually reference the alias, so an alias nobody uses
  never nags. Nothing here applies anything: this is the persistent version of
  what the resolver says once by email.
--->
<cfquery name="get_alias_pending" datasource="hermes">
SELECT a.name AS alias_name, a.ranges_changed_at, c.consumer, c.page
FROM network_aliases a
JOIN (
  SELECT a1.name AS alias_name, 'Relay Networks' AS consumer, 'view_relay_networks.cfm' AS page
    FROM parameters p JOIN network_aliases a1 ON a1.name = p.parameter
   WHERE p.parent_name = 'mynetworks' AND p.child = '1' AND p.network_entry = '2'
   GROUP BY a1.name
  UNION ALL
  SELECT a2.name, 'Network Block-Allow', 'view_network_block_allow.cfm'
    FROM postscreen_access s JOIN network_aliases a2 ON a2.name = s.sender
   WHERE s.entry_type = 'alias'
   GROUP BY a2.name
  UNION ALL
  SELECT a3.name, 'Intrusion Prevention', 'view_intrusion_prevention.cfm'
    FROM intrusion_prevention_whitelist w JOIN network_aliases a3 ON a3.name = w.ip_cidr
   WHERE w.entry_type = 'alias'
   GROUP BY a3.name
) c ON c.alias_name = a.name
LEFT JOIN network_alias_applied ap ON ap.alias_id = a.id AND ap.consumer = c.consumer
WHERE a.ranges_changed_at IS NOT NULL
  AND (ap.applied_at IS NULL OR ap.applied_at < a.ranges_changed_at)
ORDER BY a.name ASC, c.consumer ASC
</cfquery>

<cfset aliasPending = StructNew()>
<cfloop query="get_alias_pending">
  <cfif NOT StructKeyExists(aliasPending, get_alias_pending.alias_name)>
    <cfset aliasPending[get_alias_pending.alias_name] = {
      changed = get_alias_pending.ranges_changed_at,
      pages   = []
    }>
  </cfif>
  <cfset ArrayAppend(aliasPending[get_alias_pending.alias_name].pages, {
    text = get_alias_pending.consumer,
    page = get_alias_pending.page
  })>
</cfloop>
