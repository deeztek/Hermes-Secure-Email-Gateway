<!---
Hermes Secure Email Gateway - Global Sender Block/Allow Cancel Pending Additions Handler
Removes all entries staged for addition (applied='2', action='add') without applying them.
--->

<cfquery datasource="hermes">
  DELETE FROM amavis_sender_bypass WHERE action = 'add' AND applied = '2'
</cfquery>
<cfset session.m = 6>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
