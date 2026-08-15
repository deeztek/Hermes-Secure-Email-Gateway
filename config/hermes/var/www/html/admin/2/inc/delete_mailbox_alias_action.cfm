
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

<!--- Two scopes, because an alias now holds one row per destination:

     "destination" removes a single member and leaves the alias standing as
     long as it still has others. This is the x on a destination chip.

     "alias" removes the address and every destination it has. This is the
     bin on the grouped row.

     Send-as grants are revoked in BOTH cases only when the alias is going
     away entirely. Removing one member from a list has nothing to do with
     who is allowed to send from the address, so revoking then would be
     wrong. --->
<cfparam name="form.delete_scope" default="destination">

<cfif form.delete_scope IS "alias">

    <cfif NOT StructKeyExists(form, "delete_alias_address") OR Trim(form.delete_alias_address) IS "">
        <cfset session.m = 20>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>
    <cfset aliasAddress = LCase(Trim(form.delete_alias_address))>

    <cfquery name="getAlias" datasource="hermes">
        SELECT id FROM mailbox_aliases
        WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getAlias.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
        DELETE FROM sender_login_maps
        WHERE sender = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfquery datasource="hermes">
        DELETE FROM mailbox_aliases
        WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>

<cfelse>

    <cfif NOT StructKeyExists(form, "delete_alias_id") OR NOT IsNumeric(form.delete_alias_id)>
        <cfset session.m = 20>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>

    <cfquery name="getAlias" datasource="hermes">
        SELECT id, alias_address, delivers_to FROM mailbox_aliases
        WHERE id = <cfqueryparam value="#form.delete_alias_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getAlias.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>

    <cfset aliasAddress = getAlias.alias_address>

    <cfquery datasource="hermes">
        DELETE FROM mailbox_aliases
        WHERE id = <cfqueryparam value="#form.delete_alias_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- If that was the alias's last destination the address no longer
         exists, so its send-as grants have nothing left to point at. --->
    <cfquery name="countRemaining" datasource="hermes">
        SELECT COUNT(*) AS remaining FROM mailbox_aliases
        WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif countRemaining.remaining EQ 0>
        <cfquery datasource="hermes">
            DELETE FROM sender_login_maps
            WHERE sender = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>
    </cfif>

</cfif>

<!--- SUCCESS --->
<cfset session.m = 3>
<cflocation url="view_mailbox_aliases.cfm" addtoken="no">
