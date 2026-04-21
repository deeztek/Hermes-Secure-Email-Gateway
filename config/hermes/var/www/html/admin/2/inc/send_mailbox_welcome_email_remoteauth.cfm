
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
SEND WELCOME EMAIL TO NEW MAILBOX USER (REMOTE AUTH)
Minimal reference email for remote-auth mailboxes. Intentionally omits
any username/password instructions because:
  - The Hermes mailbox username (full email) differs from the user's
    AD/LDAP username, which would confuse them
  - The admin is the right channel for first-time credential handoff;
    we just note that the password is their organization password

Focus is on reference info the user will want AFTER they're logged in:
email client settings, user portal URL, webmail URL, help contact.

Requires the following variables to be set before including:
- recipientEmail: The recipient's email address
- recipientName: The recipient's display name (optional, defaults to email)
- recipientAppPassword: "Hermes System" NC app password for DAV clients
                       (optional — if set, a DAV credentials block is
                       added to the email). This is the only chance to
                       deliver the token, since NC won't show it again.
--->

<cfparam name="recipientName" default="#recipientEmail#">
<cfparam name="recipientAppPassword" default="">

<!--- GET POSTMASTER EMAIL FOR FROM ADDRESS --->
<cfquery name="getPostmaster" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
</cfquery>

<!--- GET CONSOLE HOST FOR LINKS --->
<cfquery name="getConsoleHost" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfset consoleHost = getConsoleHost.value2>
<cfset loginUrl = "https://#consoleHost#/users">
<cfset webmailUrl = "https://#consoleHost#/nc">
<cfset davUrl = "https://#consoleHost#/nc/remote.php/dav">

<!--- SEND WELCOME EMAIL --->
<cfmail from="#getPostmaster.value#" to="#recipientEmail#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Welcome - Mailbox Created" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Welcome to Hermes SEG</h2>

<p>Hello <strong>#recipientName#</strong>,</p>

<p>Your mailbox has been created on Hermes SEG. Your email address is: <strong>#recipientEmail#</strong></p>

<div style="background-color: ##fff8e6; border: 1px solid ##ffe09a; padding: 15px; margin: 20px 0; border-radius: 5px;">
    <p style="margin: 0;">Your mailbox uses your <strong>organization (AD/LDAP) password</strong> for authentication. Your administrator will provide your login username separately. If you need help, contact them directly.</p>
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

<cfif Len(Trim(recipientAppPassword)) GT 0>
<div style="background-color: ##fff0f0; border: 1px solid ##f5a8a8; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##842029;">Calendar &amp; Contacts Sync Password (DAV)</h3>
    <p>If you plan to sync your <strong>calendar, contacts, or files</strong> from Hermes to a desktop or mobile app (Thunderbird/Lightning, Apple Calendar, Apple Contacts, iOS Accounts, DAVx5 on Android, etc.), use the app-specific password below. It is NOT used for email (IMAP/SMTP) or for logging in to the website &mdash; those use your organization password.</p>
    <table style="text-align: left; width: 100%; border-collapse: collapse;">
        <tr><td style="padding: 4px 8px; vertical-align: top;"><strong>Username:</strong></td><td style="padding: 4px 8px;">#recipientEmail#</td></tr>
        <tr><td style="padding: 4px 8px; vertical-align: top;"><strong>App Password:</strong></td><td style="padding: 4px 8px; font-family: monospace; word-break: break-all; background: ##fff; padding: 6px 8px; border: 1px dashed ##f5a8a8;">#recipientAppPassword#</td></tr>
        <tr><td style="padding: 4px 8px; vertical-align: top;"><strong>Server URL:</strong></td><td style="padding: 4px 8px; font-family: monospace; word-break: break-all;">#davUrl#</td></tr>
    </table>
    <p style="margin-bottom: 0; margin-top: 12px; font-size: 13px; color: ##842029;"><strong>Please save this password somewhere safe.</strong> Hermes will not display it again. If you lose it, ask your administrator to reset your DAV password, or generate a new one yourself from Webmail &rarr; Personal Settings &rarr; Security &rarr; Devices &amp; sessions. You can safely delete this welcome email once your sync clients are configured.</p>
</div>
</cfif>

<div style="background-color: ##f8f9fa; border: 1px solid ##dee2e6; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##495057;">User Portal &amp; Webmail</h3>
    <p><strong>User Portal</strong> &mdash; manage settings, quarantine, and held messages:<br>
    <a href="#loginUrl#">#loginUrl#</a></p>
    <p style="margin-bottom: 0;"><strong>Webmail</strong> &mdash; mail, calendar, contacts, files:<br>
    <a href="#webmailUrl#">#webmailUrl#</a></p>
</div>

<p>Once logged in, you can:</p>
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
