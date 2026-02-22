
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
SEND WELCOME EMAIL TO NEW RECIPIENT
Sends a welcome email to a newly created internal recipient with instructions
to reset their password before logging in.

NOTE: This email does NOT contain a password reset link with a token.
Instead, it instructs the user to use the "Reset password?" link on the login page.

Requires the following variables to be set before including:
- recipientEmail: The recipient's email address
- recipientName: The recipient's display name (optional, defaults to email)
--->

<cfparam name="recipientName" default="#recipientEmail#">

<!--- GET POSTMASTER EMAIL FOR FROM ADDRESS --->
<cfquery name="getPostmaster" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
</cfquery>

<!--- GET CONSOLE HOST FOR LOGIN LINK --->
<cfquery name="getConsoleHost" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfset consoleHost = getConsoleHost.value2>
<cfset loginUrl = "https://#consoleHost#/users">

<!--- SEND WELCOME EMAIL --->
<cfmail from="#getPostmaster.value#" to="#recipientEmail#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Welcome - Account Created" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Welcome to Hermes SEG</h2>

<p>Hello <strong>#recipientName#</strong>,</p>

<p>An account has been created for you on Hermes SEG.</p>

<div style="background-color: ##f8f9fa; border: 1px solid ##dee2e6; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##495057;">Before You Can Login</h3>
    <p>For security purposes, you must set your password before you can access your account.</p>
    <p><strong>To set your password:</strong></p>
    <ol style="text-align: left;">
        <li>Go to the login page: <a href="#loginUrl#">#loginUrl#</a></li>
        <li>Click the <strong>"Reset password?"</strong> link</li>
        <li>Enter your email address: <strong>#recipientEmail#</strong></li>
        <li>Follow the instructions sent to your email</li>
    </ol>
</div>

<p>Once you have set your password, you will be able to:</p>
<ul style="text-align: left;">
    <li>View your message quarantine</li>
    <li>Manage your email settings</li>
    <li>Review and release held messages</li>
</ul>

<div style="margin-top: 30px; padding: 15px; background-color: ##e9ecef; border-radius: 5px;">
    <p style="margin: 0;"><strong>Need Help?</strong></p>
    <p style="margin: 5px 0 0 0;">If you have any questions or need assistance, please contact your system administrator.</p>
</div>

<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">
This is an automated message from Hermes SEG.
</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
</cfmail>
