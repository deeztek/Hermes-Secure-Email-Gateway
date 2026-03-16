
<!---
Hermes Secure Email Gateway - RBL Apply Settings Action Handler
Commits all pending RBL changes and regenerates Postfix configuration.
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<!--- Commit pending changes --->
<cfquery datasource="hermes">
  DELETE FROM parameters WHERE action = 'delete' AND applied = '2'
    AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery datasource="hermes">
  UPDATE parameters SET action = 'NONE', applied = '1'
  WHERE applied = '2' AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Generate and apply postfix configuration --->
<cftry>
  <cfinclude template="generate_postfix_configuration.cfm">
  <cfset session.m = 3>
  <cfcatch type="any">
    <cfset session.m = 4>
  </cfcatch>
</cftry>
<cflocation url="view_rbl_configuration.cfm" addtoken="no">
