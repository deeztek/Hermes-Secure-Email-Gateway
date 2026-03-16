<!---
Hermes Secure Email Gateway - Network Block/Allow Data Include
Queries the postscreen_access table for IP/network overrides.
--->

<!--- Active Allow entries --->
<cfquery name="get_active_allows" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE action = <cfqueryparam value="permit" cfsqltype="cf_sql_varchar">
    AND applied = '1' AND action2 = 'NONE'
  ORDER BY sender ASC
</cfquery>

<!--- Active Block entries --->
<cfquery name="get_active_blocks" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE action = <cfqueryparam value="reject" cfsqltype="cf_sql_varchar">
    AND applied = '1' AND action2 = 'NONE'
  ORDER BY sender ASC
</cfquery>

<!--- All active entries --->
<cfquery name="get_active_all" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE applied = '1' AND action2 = 'NONE'
  ORDER BY sender ASC
</cfquery>

<!--- Pending additions --->
<cfquery name="get_pending_adds" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE action2 = 'insert' AND applied = '2'
  ORDER BY sender ASC
</cfquery>

<!--- Pending deletions --->
<cfquery name="get_pending_deletes" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE action2 = 'delete' AND applied = '2'
  ORDER BY sender ASC
</cfquery>

<!--- Pending edits --->
<cfquery name="get_pending_edits" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE action2 = 'APPLY' AND applied = '2'
  ORDER BY sender ASC
</cfquery>

<!--- Check for any pending changes --->
<cfquery name="get_pending_changes" datasource="hermes">
  SELECT COUNT(*) as cnt FROM postscreen_access WHERE applied = '2'
</cfquery>

<cfset has_pending_changes = get_pending_changes.cnt GT 0>
