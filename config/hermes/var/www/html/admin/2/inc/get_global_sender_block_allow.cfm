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
Hermes Secure Email Gateway - Global Sender Block/Allow Data Include
Queries the amavis_sender_bypass table for sender-level whitelist/blacklist entries.

Table: amavis_sender_bypass
Columns: id, sender, transport, action, type, applied
  - sender: email address or domain
  - transport: Amavis filter string (e.g. 'FILTER amavis:[127.0.0.1]:10030')
  - action: workflow state ('NONE' = active, 'add' = pending add, 'delete' = pending delete)
  - type: 'block' or 'allow'
  - applied: '1' = applied, '2' = pending
--->

<!--- Active Allow entries --->
<cfquery name="get_active_allows" datasource="hermes">
  SELECT id, sender, type, action, applied
  FROM amavis_sender_bypass
  WHERE type = <cfqueryparam value="allow" cfsqltype="cf_sql_varchar">
    AND applied = '1' AND action = 'NONE'
  ORDER BY sender ASC
</cfquery>

<!--- Active Block entries --->
<cfquery name="get_active_blocks" datasource="hermes">
  SELECT id, sender, type, action, applied
  FROM amavis_sender_bypass
  WHERE type = <cfqueryparam value="block" cfsqltype="cf_sql_varchar">
    AND applied = '1' AND action = 'NONE'
  ORDER BY sender ASC
</cfquery>

<!--- All active entries --->
<cfquery name="get_active_all" datasource="hermes">
  SELECT id, sender, type, action, applied
  FROM amavis_sender_bypass
  WHERE applied = '1' AND action = 'NONE'
  ORDER BY sender ASC
</cfquery>

<!--- Pending additions --->
<cfquery name="get_pending_adds" datasource="hermes">
  SELECT id, sender, type
  FROM amavis_sender_bypass
  WHERE action = 'add' AND applied = '2'
  ORDER BY sender ASC
</cfquery>

<!--- Pending deletions --->
<cfquery name="get_pending_deletes" datasource="hermes">
  SELECT id, sender, type
  FROM amavis_sender_bypass
  WHERE action = 'delete' AND applied = '2'
  ORDER BY sender ASC
</cfquery>

<!--- Check for any pending changes --->
<cfquery name="get_pending_changes" datasource="hermes">
  SELECT COUNT(*) as cnt FROM amavis_sender_bypass WHERE applied = '2'
</cfquery>

<cfset has_pending_changes = get_pending_changes.cnt GT 0>
