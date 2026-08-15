<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET MAILBOX SEND-AS JSON - AJAX endpoint for the Send As modal
Returns the addresses this mailbox may currently send as, and the full set
it is allowed to be granted. Expects: form.id (mailbox id)

"available" is scoped to aliases on the MAILBOX'S OWN DOMAIN. The action
handler re-derives the same set server-side and rejects anything outside
it, so this endpoint is a convenience for the picker rather than the
security boundary.

JSON is built by hand with lowercase keys. SerializeJSON would uppercase
them and force a normaliser on the JS side.
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid mailbox ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getSaMailbox" datasource="hermes">
    SELECT id, username, domain_id
    FROM mailboxes
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getSaMailbox.recordcount LT 1>
    <cfoutput>{"error": "Mailbox not found"}</cfoutput>
    <cfabort>
</cfif>

<!--- Addresses grantable to this mailbox: aliases on its own domain.
     Discard aliases are excluded, there is nothing to send as. --->
<cfquery name="getSaAvailable" datasource="hermes">
    SELECT DISTINCT alias_address
    FROM mailbox_aliases
    WHERE domain_id = <cfqueryparam value="#getSaMailbox.domain_id#" cfsqltype="cf_sql_integer">
      AND alias_type <> <cfqueryparam value="discard" cfsqltype="cf_sql_varchar">
    ORDER BY alias_address ASC
</cfquery>

<!--- Currently granted. Intersected with the available set on render so a
     grant left behind by an older build, or by an alias that has since
     moved domain, does not show as a selected value the admin cannot
     explain. --->
<cfquery name="getSaGranted" datasource="hermes">
    SELECT sender
    FROM sender_login_maps
    WHERE login_user = <cfqueryparam value="#LCase(Trim(getSaMailbox.username))#" cfsqltype="cf_sql_varchar">
    ORDER BY sender ASC
</cfquery>

<cfset availableJson = "">
<cfoutput query="getSaAvailable">
    <cfset availableJson = ListAppend(availableJson, '"' & JSStringFormat(LCase(Trim(alias_address))) & '"')>
</cfoutput>

<cfset grantedJson = "">
<cfoutput query="getSaGranted">
    <cfset grantedJson = ListAppend(grantedJson, '"' & JSStringFormat(LCase(Trim(sender))) & '"')>
</cfoutput>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #getSaMailbox.id#,
    "username": "#JSStringFormat(getSaMailbox.username)#",
    "available": [#availableJson#],
    "granted": [#grantedJson#]
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
