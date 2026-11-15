<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.
Distributed under the GNU AGPL v3 (or later). See https://www.gnu.org/licenses/agpl.html.
--->

<!---
GET DOMAIN MAILBOXES - AJAX endpoint for the redirect / forward-to address
suggestions (Mail Filters, Forwarding). Returns the mailboxes on the
signed-in user's OWN domain, excluding the user. The same list is already
visible to the user in Nextcloud, which limits user enumeration to the
user's own domain group (#316); other domains are never returned.
The server-side checks on save (own domain, existing mailbox) still apply.
Direct requests are allowed by users/Application.cfc's /users/2/inc/ list.
--->

<cfcontent type="application/json" reset="true">

<cfif NOT StructKeyExists(session, "email") OR ListLen(session.email, "@") NEQ 2>
    <cfoutput>{"mailboxes":[]}</cfoutput>
    <cfabort>
</cfif>

<cfset me = LCase(Trim(session.email))>
<cfset myDomain = ListLast(me, "@")>

<cfquery name="getDomainMailboxes" datasource="hermes">
    SELECT username, name
    FROM mailboxes
    WHERE LOWER(SUBSTRING_INDEX(username, '@', -1)) = <cfqueryparam value="#myDomain#" cfsqltype="cf_sql_varchar">
      AND LOWER(username) <> <cfqueryparam value="#me#" cfsqltype="cf_sql_varchar">
    ORDER BY username
    LIMIT 2000
</cfquery>

<cfset out = []>
<cfloop query="getDomainMailboxes">
    <cfset ArrayAppend(out, {"email": LCase(getDomainMailboxes.username), "name": getDomainMailboxes.name})>
</cfloop>
<cfoutput>#SerializeJSON({"mailboxes": out})#</cfoutput>
<cfabort>
