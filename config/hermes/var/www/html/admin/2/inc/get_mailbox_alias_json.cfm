
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET MAILBOX ALIAS JSON - AJAX endpoint for the edit modal
Expects: form.id (any row id belonging to the alias)

Returns the alias and ALL of its destinations, not just the row that was
clicked. The edit modal shows every destination as a removable chip, the same
way the list view renders them, so it needs the whole set.

JSON is built by hand with lowercase keys. SerializeJSON would uppercase them
and force a normaliser on the JS side.
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid alias ID"}</cfoutput>
    <cfabort>
</cfif>

<!--- The clicked row identifies the alias; everything else is keyed off the
     address it belongs to. --->
<cfquery name="getAliasRow" datasource="hermes">
    SELECT alias_address FROM mailbox_aliases
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getAliasRow.recordcount LT 1>
    <cfoutput>{"error": "Alias not found"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getAliasAll" datasource="hermes">
    SELECT id, alias_address, delivers_to, alias_type, internal_only
    FROM mailbox_aliases
    WHERE alias_address = <cfqueryparam value="#getAliasRow.alias_address#" cfsqltype="cf_sql_varchar">
    ORDER BY delivers_to ASC
</cfquery>

<!--- A discard alias has one row whose destination is the pseudo-value
     "discard:silently". That is machinery rather than an address, so it is
     not offered to the admin as a chip. --->
<cfset destJson = "">
<cfoutput query="getAliasAll">
    <cfif alias_type NEQ "discard" AND delivers_to NEQ "discard:silently">
        <cfset destJson = ListAppend(destJson, '"' & JSStringFormat(delivers_to) & '"')>
    </cfif>
</cfoutput>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #form.id#,
    "alias_address": "#JSStringFormat(getAliasAll.alias_address)#",
    "alias_type": "#JSStringFormat(getAliasAll.alias_type)#",
    "internal_only": #Val(getAliasAll.internal_only)#,
    "destinations": [#destJson#]
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
