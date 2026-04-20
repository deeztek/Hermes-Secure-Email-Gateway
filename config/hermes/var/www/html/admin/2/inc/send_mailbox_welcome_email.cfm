
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
SEND WELCOME EMAIL TO NEW MAILBOX USER
Sends a welcome email to a newly created mailbox user with instructions
to reset their password and configure their email client.

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
<cfmail from="#getPostmaster.value#" to="#recipientEmail#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Welcome - Mailbox Created" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Welcome to Hermes SEG</h2>

<p>Hello <strong>#recipientName#</strong>,</p>

<p>A mailbox has been created for you on Hermes SEG. Your email address is: <strong>#recipientEmail#</strong></p>

<div style="background-color: ##fff8e6; border: 1px solid ##ffe09a; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##805500;">Your Login Credentials</h3>
    <p style="margin: 0 0 8px 0;"><strong>Username:</strong> Your full email address &mdash; <code>#recipientEmail#</code> &mdash; for <em>all</em> login methods (webmail, user portal, email clients).</p>
    <p style="margin: 0;"><strong>Password:</strong> Provided to you separately by your administrator.</p>
</div>

<div style="background-color: ##f0f7ff; border: 1px solid ##b8daff; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##004085;">Email Client Settings</h3>
    <p>Most modern email clients (Thunderbird, Outlook, iOS Mail) will auto-configure when you enter your email address. If manual setup is needed:</p>
    <table style="text-align: left; width: 100%; border-collapse: collapse;">
        <tr><td style="padding: 4px 8px;"><strong>Incoming (IMAP):</strong></td><td style="padding: 4px 8px;">#consoleHost# - Port 993 (SSL/TLS)</td></tr>
        <tr><td style="padding: 4px 8px;"><strong>Outgoing (SMTP):</strong></td><td style="padding: 4px 8px;">#consoleHost# - Port 587 (STARTTLS) or Port 465 (SSL/TLS)</td></tr>
        <tr><td style="padding: 4px 8px;"><strong>Username:</strong></td><td style="padding: 4px 8px;">#recipientEmail# <em>(your full email address)</em></td></tr>
    </table>
</div>

<div style="background-color: ##f8f9fa; border: 1px solid ##dee2e6; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##495057;">User Portal</h3>
    <p>You can manage your email settings, view quarantined messages, and release held messages from the user portal:</p>
    <p><a href="#loginUrl#">#loginUrl#</a></p>
</div>

<p>With your account, you can:</p>
<ul style="text-align: left;">
    <li>Send and receive email via your email client or webmail</li>
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
