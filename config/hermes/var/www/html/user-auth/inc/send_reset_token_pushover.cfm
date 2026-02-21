
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
SEND RESET TOKEN VIA PUSHOVER
Sends a password reset notification to the user's Pushover app.

Requires the following variables to be set before including:
- pushoverUserKey: The user's Pushover user key
- pushoverApiToken: The user's Pushover API token (from their own Pushover app)
- resetLink: The full password reset URL

Each user must have their own Pushover account (one-time $5 fee per platform)
and create their own Pushover application to get an API token.

Returns:
- pushoverSent: Boolean indicating success/failure
--->

<cfset pushoverSent = false>

<!--- Verify required variables are set --->
<cfif NOT IsDefined("pushoverUserKey") OR pushoverUserKey EQ "" OR NOT IsDefined("pushoverApiToken") OR pushoverApiToken EQ "">
    <!--- Pushover not configured for this user --->
    <cfset pushoverSent = false>
<cfelse>

    <cftry>

    <!--- SEND PUSHOVER NOTIFICATION --->
    <cfhttp url="https://api.pushover.net/1/messages.json" method="POST" result="pushoverResult">
        <cfhttpparam type="formfield" name="token" value="#pushoverApiToken#">
        <cfhttpparam type="formfield" name="user" value="#pushoverUserKey#">
        <cfhttpparam type="formfield" name="title" value="Hermes SEG: Password Reset">
        <cfhttpparam type="formfield" name="message" value="A password reset has been requested for your account. Click the link below to reset your password. This link expires in 15 minutes.">
        <cfhttpparam type="formfield" name="url" value="#resetLink#">
        <cfhttpparam type="formfield" name="url_title" value="Reset Password">
        <cfhttpparam type="formfield" name="priority" value="1">
        <cfhttpparam type="formfield" name="sound" value="pushover">
    </cfhttp>

    <!--- Check if the request was successful --->
    <cfif pushoverResult.statusCode CONTAINS "200">
        <cfset pushoverSent = true>
    <cfelse>
        <cfset pushoverSent = false>
    </cfif>

    <cfcatch type="any">
        <cfset pushoverSent = false>
    </cfcatch>

    </cftry>

</cfif>
