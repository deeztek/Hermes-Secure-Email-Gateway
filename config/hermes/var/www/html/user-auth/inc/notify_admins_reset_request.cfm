
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
NOTIFY ADMINS OF PASSWORD RESET REQUEST
Sends email notifications to all admins about a password reset request.

Requires the following variables to be set before including:
- userEmail: The email address of the user requesting the reset
- ldapUsername: The LDAP username
- userType: The type of user (relay, mailbox, admin)

This is used when:
1. A mailbox user selects "admin reset" option
2. Any user type requests a reset and admin notification is configured
--->

<!--- GET POSTMASTER EMAIL FOR FROM ADDRESS --->
<cfquery name="getPostmaster" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
</cfquery>

<!--- GET CONSOLE HOST FOR ADMIN PANEL LINK --->
<cfquery name="getConsoleHost" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfset consoleHost = getConsoleHost.value2>
<cfset adminPanelLink = "https://#consoleHost#/admin/2/view_password_reset_requests.cfm">

<!--- GET ALL ADMINS --->
<cfquery name="getAdmins" datasource="hermes">
    SELECT email
    FROM system_users
    WHERE applied = '1'
    AND email IS NOT NULL
    AND email != ''
</cfquery>

<!--- FORMAT USER TYPE FOR DISPLAY --->
<cfswitch expression="#userType#">
    <cfcase value="relay">
        <cfset userTypeDisplay = "Relay Recipient">
    </cfcase>
    <cfcase value="mailbox">
        <cfset userTypeDisplay = "Mailbox User">
    </cfcase>
    <cfcase value="admin">
        <cfset userTypeDisplay = "Administrator">
    </cfcase>
    <cfdefaultcase>
        <cfset userTypeDisplay = "User">
    </cfdefaultcase>
</cfswitch>

<!--- NOTIFY EACH ADMIN --->
<cfloop query="getAdmins">

    <!--- SEND EMAIL NOTIFICATION --->
    <cfmail from="#getPostmaster.value#" to="#getAdmins.email#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Password Reset Request Pending" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Password Reset Request</h2>

<p>A <strong>#userTypeDisplay#</strong> has requested a password reset and requires administrator assistance.</p>

<table border="0" cellpadding="8" style="background-color: ##f8f9fa; border-radius: 5px; margin: 20px 0;">
<tr><td><strong>User Email:</strong></td><td>#userEmail#</td></tr>
<tr><td><strong>LDAP Username:</strong></td><td>#ldapUsername#</td></tr>
<tr><td><strong>User Type:</strong></td><td>#userTypeDisplay#</td></tr>
<tr><td><strong>Requested At:</strong></td><td>#DateFormat(Now(), "yyyy-mm-dd")# #TimeFormat(Now(), "HH:mm:ss")#</td></tr>
</table>

<div style="margin: 20px 0;">
    <a href="#adminPanelLink#" style="background-color: ##007bff; color: ##ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;">View Password Reset Requests</a>
</div>

<p style="color: ##6c757d; font-size: 12px;">
You can process this request from the Admin Console by navigating to:<br>
Users &gt; Password Reset Requests
</p>

<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">
This is an automated message from Hermes SEG.
</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
    </cfmail>

</cfloop>
