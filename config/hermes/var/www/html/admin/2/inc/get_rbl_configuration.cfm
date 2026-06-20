<!---
Hermes Secure Email Gateway - RBL Configuration Data Include
Queries the parameters table for RBL (Block) and DNSWL (Allow) entries.
RBL entries are children of postscreen_dnsbl_sites parent.
Block entries have positive weight, Allow entries have negative weight.
--->

<!--- Get parent ID --->
<cfquery name="get_dnsbl_sites_id" datasource="hermes">
  SELECT id FROM parameters WHERE parameter = <cfqueryparam value="postscreen_dnsbl_sites" cfsqltype="cf_sql_varchar"> AND child = '2'
</cfquery>

<!--- All active entries --->
<cfquery name="get_active_all" datasource="hermes">
  SELECT id, parameter, weight, order1
  FROM parameters
  WHERE parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    AND child = '1' AND applied = '1'
  ORDER BY order1 ASC
</cfquery>
