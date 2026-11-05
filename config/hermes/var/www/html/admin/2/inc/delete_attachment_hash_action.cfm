<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

DELETE ATTACHMENT HASH ACTION HANDLER (#386)
--->

<cfif NOT StructKeyExists(form, "delete_hash_id") OR NOT IsNumeric(form.delete_hash_id)>
    <cfset session.m = 20>
    <cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
</cfif>

<cfquery name="getHash" datasource="hermes">
    SELECT id FROM attachment_hash_blocklist WHERE id = <cfqueryparam value="#form.delete_hash_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getHash.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
</cfif>

<cfquery datasource="hermes">
    DELETE FROM attachment_hash_blocklist WHERE id = <cfqueryparam value="#form.delete_hash_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfinclude template="generate_attachment_hash_blocklist.cfm">

<cfset session.m = Len(request.hashBlocklistError) ? 30 : 3>
<cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
