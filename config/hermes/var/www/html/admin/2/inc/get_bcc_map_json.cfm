
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET BCC MAP JSON - AJAX endpoint for edit modal
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid BCC map ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getBcc" datasource="hermes">
    SELECT id, address, bcc_to, bcc_type, enabled, description
    FROM bcc_maps
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getBcc.recordcount LT 1>
    <cfoutput>{"error": "BCC map entry not found"}</cfoutput>
    <cfabort>
</cfif>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #getBcc.id#,
    "address": "#JSStringFormat(getBcc.address)#",
    "bcc_to": "#JSStringFormat(getBcc.bcc_to)#",
    "bcc_type": "#JSStringFormat(getBcc.bcc_type)#",
    "enabled": #getBcc.enabled#,
    "description": "#JSStringFormat(getBcc.description)#"
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
