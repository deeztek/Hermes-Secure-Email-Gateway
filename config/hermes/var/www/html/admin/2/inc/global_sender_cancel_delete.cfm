<!---
Hermes Secure Email Gateway - Global Sender Block/Allow Cancel Pending Deletions Handler
Restores entries staged for deletion back to active status.
--->

<cfquery datasource="hermes">
  UPDATE amavis_sender_bypass SET action = 'NONE', applied = '1'
  WHERE action = 'delete' AND applied = '2'
</cfquery>
<cfset session.m = 7>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
