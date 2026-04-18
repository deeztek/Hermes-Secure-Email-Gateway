
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
GET SHARED MAILBOX PERMISSIONS JSON
Returns JSON array of permissions for a shared mailbox.
Used by the Manage Permissions modal via AJAX.
--->

<cfcontent type="application/json">

<cfif NOT StructKeyExists(form, "shared_mailbox_id") OR NOT IsNumeric(form.shared_mailbox_id)>
    <cfoutput>[]</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getPerms" datasource="hermes">
    SELECT smp.id, smp.username, smp.can_read, smp.can_write, smp.can_delete,
           smp.can_insert, smp.can_post, smp.can_admin, smp.send_as
    FROM shared_mailbox_permissions smp
    WHERE smp.shared_mailbox_id = <cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">
    ORDER BY smp.username ASC
</cfquery>

<cfset result = []>
<cfloop query="getPerms">
    <cfset perm = {
        "id": getPerms.id,
        "username": getPerms.username,
        "can_read": getPerms.can_read,
        "can_write": getPerms.can_write,
        "can_delete": getPerms.can_delete,
        "can_insert": getPerms.can_insert,
        "can_post": getPerms.can_post,
        "can_admin": getPerms.can_admin,
        "send_as": getPerms.send_as
    }>
    <cfset ArrayAppend(result, perm)>
</cfloop>

<cfoutput>#SerializeJSON(result)#</cfoutput>
