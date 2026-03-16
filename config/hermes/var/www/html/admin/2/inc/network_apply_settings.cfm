
<!---
Hermes Secure Email Gateway - Network Block/Allow Apply Settings Action Handler
Commits all pending changes and regenerates Postfix configuration.
--->

<cfquery datasource="hermes">
  DELETE FROM postscreen_access WHERE action2 = 'delete' AND applied = '2'
</cfquery>
<cfquery datasource="hermes">
  UPDATE postscreen_access SET action2 = 'NONE', applied = '1' WHERE applied = '2'
</cfquery>
<cftry>
  <cfinclude template="generate_postfix_configuration.cfm">
  <cfset session.m = 3>
  <cfcatch type="any">
    <cfset session.m = 4>
  </cfcatch>
</cftry>
<cflocation url="view_network_block_allow.cfm" addtoken="no">
