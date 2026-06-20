
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

DELETE BCC MAP ACTION HANDLER
--->

<cfif NOT StructKeyExists(form, "delete_bcc_id") OR NOT IsNumeric(form.delete_bcc_id)>
    <cfset session.m = 20>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<cfquery name="getBcc" datasource="hermes">
    SELECT id FROM bcc_maps WHERE id = <cfqueryparam value="#form.delete_bcc_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getBcc.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<cfquery datasource="hermes">
    DELETE FROM bcc_maps WHERE id = <cfqueryparam value="#form.delete_bcc_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset session.m = 3>
<cflocation url="view_bcc_maps.cfm" addtoken="no">
