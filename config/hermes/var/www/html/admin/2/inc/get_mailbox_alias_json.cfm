
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET MAILBOX ALIAS JSON - AJAX endpoint for edit modal
Returns alias data as JSON. Expects: form.id
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid alias ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getAlias" datasource="hermes">
    SELECT id, alias_address, delivers_to, alias_type, internal_only, send_as
    FROM mailbox_aliases
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getAlias.recordcount LT 1>
    <cfoutput>{"error": "Alias not found"}</cfoutput>
    <cfabort>
</cfif>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #getAlias.id#,
    "alias_address": "#JSStringFormat(getAlias.alias_address)#",
    "delivers_to": "#JSStringFormat(getAlias.delivers_to)#",
    "alias_type": "#JSStringFormat(getAlias.alias_type)#",
    "internal_only": #Val(getAlias.internal_only)#,
    "send_as": #getAlias.send_as#
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
