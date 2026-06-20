
<!---
Hermes Secure Email Gateway - Network Block/Allow Cancel Changes Action Handler
Cancels pending additions or deletions.
--->

<!--- Cancel pending additions --->
<cfif action is "cancel_add">
  <cfquery datasource="hermes">
    DELETE FROM postscreen_access WHERE action2 = 'insert' AND applied = '2'
  </cfquery>
  <cfset session.m = 6>
  <cflocation url="view_network_block_allow.cfm" addtoken="no">
</cfif>

<!--- Cancel pending deletions --->
<cfif action is "cancel_delete">
  <cfquery datasource="hermes">
    UPDATE postscreen_access SET action2 = 'NONE', applied = '1'
    WHERE action2 = 'delete' AND applied = '2'
  </cfquery>
  <cfset session.m = 7>
  <cflocation url="view_network_block_allow.cfm" addtoken="no">
</cfif>
