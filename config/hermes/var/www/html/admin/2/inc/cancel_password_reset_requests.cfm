
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
CANCEL PASSWORD RESET REQUESTS
Allows administrators to cancel pending password reset requests.
--->

<cfparam name="form.request_ids" default="">

<!--- Validate inputs --->
<cfif form.request_ids EQ "">
    <cfset session.message = "No requests selected.">
    <cfset session.messageType = "warning">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfif>

<!--- Get admin username for audit trail --->
<cfset adminUsername = "">
<cfif StructKeyExists(session, "username")>
    <cfset adminUsername = session.username>
<cfelseif StructKeyExists(request, "authelia_user")>
    <cfset adminUsername = request.authelia_user>
<cfelse>
    <cfset adminUsername = "admin">
</cfif>

<!--- Process each request ID --->
<cfset requestIdList = form.request_ids>
<cfset cancelCount = 0>

<cfloop list="#requestIdList#" index="requestId">
    <cfif IsNumeric(requestId)>
        <!--- Delete the request --->
        <cfquery name="deleteRequest" datasource="hermes">
            DELETE FROM password_reset_requests
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#requestId#">
            AND status = 'pending'
        </cfquery>
        <cfset cancelCount = cancelCount + 1>
    </cfif>
</cfloop>

<cfif cancelCount GT 0>
    <cfset session.message = "#cancelCount# password reset request(s) have been deleted.">
    <cfset session.messageType = "success">
<cfelse>
    <cfset session.message = "No requests were deleted. They may have already been processed.">
    <cfset session.messageType = "warning">
</cfif>

<cflocation url="view_password_reset_requests.cfm" addtoken="no">
