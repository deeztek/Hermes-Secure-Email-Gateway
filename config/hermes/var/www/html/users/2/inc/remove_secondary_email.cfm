
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
REMOVE SECONDARY EMAIL
Removes the secondary email address from user settings.
--->

<cfquery datasource="hermes">
    UPDATE user_settings
    SET secondary_email = NULL,
        secondary_email_verified = 0,
        secondary_email_token = NULL,
        secondary_email_token_expires = NULL
    WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
</cfquery>

<!--- Update session variables --->
<cfset session.secondary_email = "">
<cfset session.secondary_email_verified = 0>

<cfset session.message = "Your recovery email has been removed.">
<cfset session.messageType = "success">

<cflocation url="user_settings.cfm" addtoken="no">
