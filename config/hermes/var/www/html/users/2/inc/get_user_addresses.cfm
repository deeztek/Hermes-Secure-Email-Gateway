
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET USER ADDRESSES - AJAX endpoint that returns the logged-in user's
primary email plus any mailbox aliases that deliver to it. Used by the
vacation auto-reply page to populate the :addresses dropdown so users
can restrict the auto-reply to specific identities.
--->

<cfcontent type="application/json" reset="true">

<cfif NOT StructKeyExists(session, "email") OR session.email EQ "">
    <cfoutput>{"error":"Not logged in","addresses":[]}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getAliases" datasource="hermes">
    SELECT alias_address
    FROM mailbox_aliases
    WHERE delivers_to = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    ORDER BY alias_address
</cfquery>

<cfset addrList = [session.email]>
<cfloop query="getAliases">
    <cfif NOT ArrayFindNoCase(addrList, getAliases.alias_address)>
        <cfset ArrayAppend(addrList, getAliases.alias_address)>
    </cfif>
</cfloop>

<cfoutput>#SerializeJSON({"addresses": addrList})#</cfoutput>
<cfabort>
