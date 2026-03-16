<!---
Hermes Secure Email Gateway - Sender/Recipient Block/Allow Data Include
Queries the mailaddr_temp table for sender-to-recipient block/allow mappings.
--->

<!--- Active entries (applied, no pending action) --->
<cfquery name="get_active_all" datasource="hermes">
  SELECT id, recipient_id, mailaddr_id, sender, wb, receiver
  FROM mailaddr_temp
  WHERE applied = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
    AND action = <cfqueryparam value="NONE" cfsqltype="cf_sql_varchar">
  ORDER BY sender ASC
</cfquery>

<!--- Pending additions --->
<cfquery name="get_pending_adds" datasource="hermes">
  SELECT id, recipient_id, mailaddr_id, sender, wb, receiver
  FROM mailaddr_temp
  WHERE applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
    AND action = <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">
  ORDER BY sender ASC
</cfquery>

<!--- Pending deletions --->
<cfquery name="get_pending_deletes" datasource="hermes">
  SELECT id, recipient_id, mailaddr_id, sender, wb, receiver
  FROM mailaddr_temp
  WHERE applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
    AND action = <cfqueryparam value="delete" cfsqltype="cf_sql_varchar">
  ORDER BY sender ASC
</cfquery>

<!--- Count of pending changes --->
<cfquery name="get_pending_changes" datasource="hermes">
  SELECT COUNT(*) as cnt FROM mailaddr_temp
  WHERE applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset has_pending_changes = get_pending_changes.cnt GT 0>
