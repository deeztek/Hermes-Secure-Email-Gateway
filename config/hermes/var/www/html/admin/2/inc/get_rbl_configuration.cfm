<!---
Hermes Secure Email Gateway - RBL Configuration Data Include
Queries the parameters table for RBL (Block) and DNSWL (Allow) entries.
RBL entries are children of postscreen_dnsbl_sites parent.
Block entries have positive weight, Allow entries have negative weight.
--->

<!--- Get parent IDs --->
<cfquery name="get_dnsbl_sites_id" datasource="hermes">
  SELECT id FROM parameters WHERE parameter = <cfqueryparam value="postscreen_dnsbl_sites" cfsqltype="cf_sql_varchar"> AND child = '2'
</cfquery>

<!--- All active entries (applied=1, not pending deletion) --->
<cfquery name="get_active_all" datasource="hermes">
  SELECT id, parameter, weight, order1
  FROM parameters
  WHERE parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    AND child = '1' AND applied = '1'
    AND (action IS NULL OR action != 'delete')
  ORDER BY order1 ASC
</cfquery>

<!--- Pending additions --->
<cfquery name="get_pending_adds" datasource="hermes">
  SELECT id, parameter, weight, order1
  FROM parameters
  WHERE parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    AND child = '1' AND action = 'insert' AND applied = '2'
  ORDER BY parameter ASC
</cfquery>

<!--- Pending deletions --->
<cfquery name="get_pending_deletes" datasource="hermes">
  SELECT id, parameter, weight, order1
  FROM parameters
  WHERE parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    AND child = '1' AND action = 'delete' AND applied = '2'
  ORDER BY parameter ASC
</cfquery>

<!--- Check for any pending changes --->
<cfquery name="get_pending_changes" datasource="hermes">
  SELECT COUNT(*) as cnt FROM parameters
  WHERE parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer"> AND applied = '2'
</cfquery>

<cfset has_pending_changes = get_pending_changes.cnt GT 0>
