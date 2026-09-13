
<!---
Hermes Secure Email Gateway - RBL Cancel Changes Action Handler
Cancels pending additions or deletions for RBL entries.
Scopes by parent_name = postscreen_dnsbl_sites; no id lookup needed.
--->

<!--- Cancel pending additions --->
<cfif action is "cancel_add">
  <cfquery datasource="hermes">
    DELETE FROM parameters WHERE action = 'insert' AND applied = '2'
      AND parent_name = <cfqueryparam value="postscreen_dnsbl_sites" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfset session.m = 6>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>

<!--- Cancel pending deletions --->
<cfif action is "cancel_delete">
  <cfquery datasource="hermes">
    UPDATE parameters SET action = 'NONE', applied = '1'
    WHERE action = 'delete' AND applied = '2'
      AND parent_name = <cfqueryparam value="postscreen_dnsbl_sites" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfset session.m = 7>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>
