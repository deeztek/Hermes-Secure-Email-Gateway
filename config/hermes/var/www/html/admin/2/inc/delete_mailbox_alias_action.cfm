
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
DELETE MAILBOX ALIAS ACTION HANDLER
Removes the alias from mailbox_aliases, the recipients entry for Amavis,
and any sender_login_maps entries.
--->

<!--- VALIDATE ALIAS ID --->
<cfif NOT StructKeyExists(form, "delete_alias_id") OR NOT IsNumeric(form.delete_alias_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- GET ALIAS DETAILS --->
<cfquery name="getAlias" datasource="hermes">
    SELECT id, alias_address, delivers_to FROM mailbox_aliases
    WHERE id = <cfqueryparam value="#form.delete_alias_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getAlias.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<cfset aliasAddress = getAlias.alias_address>

<!--- 1. DELETE SENDER_LOGIN_MAPS ENTRY --->
<cfquery datasource="hermes">
    DELETE FROM sender_login_maps
    WHERE sender = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- 2. DELETE FROM MAILBOX_ALIASES --->
<cfquery datasource="hermes">
    DELETE FROM mailbox_aliases
    WHERE id = <cfqueryparam value="#form.delete_alias_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- SUCCESS --->
<cfset session.m = 3>
<cflocation url="view_mailbox_aliases.cfm" addtoken="no">
