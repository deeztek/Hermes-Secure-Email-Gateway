
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

After #197 Phase 1, this email no longer carries any credential.
The "Hermes System" app password is internal plumbing for NC Mail and
is never disclosed. Users generate their own per-device app passwords
from the user portal on demand. The web login uses their organization
(AD/LDAP) password, communicated by the admin out-of-band.
--->

<cfparam name="recipientName" default="#recipientEmail#">

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

<div style="background-color: ##fff8e6; border: 1px solid ##ffe09a; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h3 style="margin-top: 0; color: ##805500;">Setting Up Email on Your Phone or Computer</h3>
    <p style="margin: 0 0 10px 0;">Your organization (AD/LDAP) password works for the website only. For your email apps (phone, tablet, Thunderbird, Outlook, Apple Mail, etc.), you need an <strong>app password</strong>.</p>

    <p style="margin: 0 0 10px 0;"><strong>Easy path &mdash; the Setup wizard.</strong> Sign in to the user portal at <a href="#loginUrl#">#loginUrl#</a>, then click <strong>Set Up Your Devices</strong> in the sidebar. The wizard walks you through each device type with the right values pre-filled, and gives Apple devices a one-click downloadable setup file.</p>

    <p style="margin: 0 0 10px 0;"><strong>Manual path &mdash; My App Passwords.</strong> Already comfortable setting up clients yourself? Use <strong>My App Passwords</strong> in the sidebar to generate per-device credentials directly:</p>
    <ol style="margin: 0 0 10px 18px; padding: 0;">
        <li style="margin: 4px 0;">Click <strong>Create App Password</strong>, label it for the device (&ldquo;iPhone&rdquo;, &ldquo;Thunderbird&rdquo;, etc.)</li>
        <li style="margin: 4px 0;">Copy the password it shows you (it's shown only once)</li>
        <li style="margin: 4px 0;">Paste it into your email app along with your full email address</li>
    </ol>
    <p style="margin: 0; font-size: 13px; color: ##555;">It's recommended that each app password be device-specific, so if a device is lost or stolen you can revoke just that one without affecting any of your other devices or your website login.</p>
</div>

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
