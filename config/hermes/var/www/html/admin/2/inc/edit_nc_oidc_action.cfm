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

<!--- POST handler for view_nextcloud_admin.cfm. Enables or disables the
      Nextcloud user_oidc app via occ. #262.
      Expects form.action = "disable" or "enable". --->

<cfif NOT isDefined("form.action") OR (form.action NEQ "disable" AND form.action NEQ "enable")>
    <cfset session.m = "61">
    <cflocation url="../view_email_server_settings.cfm##nc-maintenance" addtoken="no">
    <cfabort>
</cfif>

<cfset occCommand = "exec hermes_nextcloud php occ app:" & form.action & " user_oidc">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="#occCommand#"
        variable="occResult"
        timeout="30" />
    <cfif form.action EQ "disable">
        <cfset session.m = "62">
    <cfelse>
        <cfset session.m = "63">
    </cfif>
    <cfcatch type="any">
        <cfset session.m = "64">
    </cfcatch>
</cftry>

<cflocation url="../view_email_server_settings.cfm##nc-maintenance" addtoken="no">
