
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
PROCESS PASSWORD RESET REQUEST
Generates a reset token and sends it via the appropriate method.

Requires:
- userEmail: The user's primary email address
- ldapUsername: The user's LDAP cn
- userType: 'relay', 'mailbox', or 'admin'
- notificationMethod: 'email', 'pushover', or 'admin'
- tokenRecipient: Email address to send token to (for email method)
- pushoverUserKey: Pushover user key (for pushover method)
--->

<!--- CHECK FOR RECENT PENDING REQUEST (rate limiting) --->
<cfquery name="checkRecentRequest" datasource="hermes">
    SELECT id, requested_at
    FROM password_reset_requests
    WHERE email = '#userEmail#'
    AND status = 'pending'
    AND requested_at > DATE_SUB(NOW(), INTERVAL 15 MINUTE)
    ORDER BY requested_at DESC
    LIMIT 1
</cfquery>

<cfif checkRecentRequest.recordcount GTE 1>
    <cfset session.reason = 8>
    <cflocation url="forgot_password.cfm" addtoken="no">
</cfif>

<!--- GENERATE SECURE TOKEN (64 characters) --->
<cfset _transLength = 64>
<cfinclude template="generate_customtrans.cfm">
<cfset resetToken = customtrans3>

<!--- SET EXPIRATION --->
<!--- Admin method: no expiration (admin will handle in their own time) --->
<!--- Email/Pushover methods: 15 minutes (user-initiated token link) --->
<cfif notificationMethod EQ "admin">
    <cfset expiresAtFormatted = "">
<cfelse>
    <cfset expiresAt = DateAdd("n", 15, Now())>
    <cfset expiresAtFormatted = DateFormat(expiresAt, "yyyy-mm-dd") & " " & TimeFormat(expiresAt, "HH:mm:ss")>
</cfif>

<!--- INSERT PASSWORD RESET REQUEST --->
<cfquery name="insertRequest" datasource="hermes">
    INSERT INTO password_reset_requests
    (email, ldap_username, user_type, token, notification_method, status, expires_at)
    VALUES
    ('#userEmail#', '#ldapUsername#', '#userType#', '#resetToken#', '#notificationMethod#', 'pending',
    <cfif notificationMethod EQ "admin">
        NULL
    <cfelse>
        '#expiresAtFormatted#'
    </cfif>)
</cfquery>

<!--- GET CONSOLE HOST FOR RESET LINK --->
<cfquery name="getConsoleHost" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfset consoleHost = getConsoleHost.value2>

<!--- BUILD RESET LINK --->
<cfset resetLink = "https://#consoleHost#/user-auth/reset_password.cfm?token=#resetToken#">

<!--- SEND NOTIFICATION BASED ON METHOD --->
<cfswitch expression="#notificationMethod#">

    <cfcase value="email">
        <!--- SEND EMAIL WITH RESET LINK --->
        <cfquery name="getPostmaster" datasource="hermes">
            SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
        </cfquery>

        <cftry>
        <cfmail from="#getPostmaster.value#" to="#tokenRecipient#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Password Reset Request" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Password Reset Request</h2>

<p>Someone, presumably you, has requested to reset your password.</p>

<p>If you did <strong>NOT</strong> initiate this request, you can safely ignore this message and no action will be taken.</p>

<p>If you did initiate this request, please click the button below to reset your password:</p>

<div style="margin: 20px 0;">
    <a href="#resetLink#" style="background-color: ##007bff; color: ##ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;">Reset Password</a>
</div>

<p style="color: ##6c757d; font-size: 12px;">If the button above doesn't work, copy and paste this URL into your browser:</p>
<p style="color: ##6c757d; font-size: 12px; word-break: break-all;">#resetLink#</p>

<p style="margin-top: 20px;"><b>*** This link is only valid for 15 minutes ***</b></p>

<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">
This is an automated message from Hermes SEG.
</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
        </cfmail>

        <cfset session.reason = 3>
        <cflocation url="forgot_password.cfm" addtoken="no">

        <cfcatch type="any">
            <!--- Email failed to send - update request status and show error --->
            <cfquery datasource="hermes">
                UPDATE password_reset_requests
                SET status = 'failed'
                WHERE token = '#resetToken#'
            </cfquery>
            <cfset session.reason = 6>
            <cflocation url="forgot_password.cfm" addtoken="no">
        </cfcatch>
        </cftry>
    </cfcase>

    <cfcase value="pushover">
        <!--- SEND PUSHOVER NOTIFICATION --->
        <cfinclude template="send_reset_token_pushover.cfm">

        <cfset session.reason = 4>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfcase>

    <cfcase value="admin">
        <!--- NOTIFY ADMINS --->
        <cfinclude template="notify_admins_reset_request.cfm">

        <cfset session.reason = 5>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfcase>

</cfswitch>
