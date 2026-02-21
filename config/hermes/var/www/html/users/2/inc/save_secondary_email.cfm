
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
SAVE SECONDARY EMAIL
Saves the secondary email and sends a verification email.
--->

<cfparam name="form.secondary_email" default="">

<!--- Validate email format --->
<cfif NOT IsValid("email", form.secondary_email)>
    <cfset session.message = "Please enter a valid email address.">
    <cfset session.messageType = "danger">
    <cflocation url="user_settings.cfm" addtoken="no">
</cfif>

<!--- Cannot use primary email as secondary --->
<cfif LCase(Trim(form.secondary_email)) EQ LCase(Trim(session.email))>
    <cfset session.message = "Your recovery email cannot be the same as your primary email address.">
    <cfset session.messageType = "danger">
    <cflocation url="user_settings.cfm" addtoken="no">
</cfif>

<!--- Cannot use email address from a domain handled by this system --->
<cfset secondaryEmailDomain = ListLast(LCase(Trim(form.secondary_email)), "@")>
<cfquery name="checkInternalDomain" datasource="hermes">
    SELECT domain FROM domains WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#secondaryEmailDomain#">
</cfquery>

<cfif checkInternalDomain.recordcount GTE 1>
    <cfset session.message = "Your recovery email cannot be from a domain handled by this system (<strong>#HTMLEditFormat(secondaryEmailDomain)#</strong>). Please use an external email address that you can access independently.">
    <cfset session.messageType = "danger">
    <cflocation url="user_settings.cfm" addtoken="no">
</cfif>

<!--- GENERATE VERIFICATION TOKEN (64 characters) --->
<cfquery name="randomToken" datasource="hermes">
    SELECT random_letter as random FROM captcha_list_all2 ORDER BY RAND() LIMIT 64
</cfquery>

<cfquery name="insertToken" datasource="hermes" result="stResultToken">
    INSERT INTO salt (salt) VALUES ('<cfoutput query="randomToken">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getToken" datasource="hermes">
    SELECT salt as verifyToken FROM salt WHERE id='#stResultToken.GENERATED_KEY#'
</cfquery>

<cfset verifyToken = getToken.verifyToken>

<cfquery name="deleteToken" datasource="hermes">
    DELETE FROM salt WHERE id='#stResultToken.GENERATED_KEY#'
</cfquery>

<!--- SAVE TO DATABASE --->
<cfquery datasource="hermes">
    UPDATE user_settings
    SET secondary_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(Trim(form.secondary_email))#">,
        secondary_email_verified = 0,
        secondary_email_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#verifyToken#">,
        secondary_email_token_expires = DATE_ADD(NOW(), INTERVAL 24 HOUR)
    WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
</cfquery>

<!--- GET CONSOLE HOST FOR VERIFICATION LINK --->
<cfquery name="getConsoleHost" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfset consoleHost = getConsoleHost.value2>

<!--- BUILD VERIFICATION LINK --->
<cfset verifyLink = "https://#consoleHost#/users/2/verify_secondary_email.cfm?token=#verifyToken#">

<!--- GET POSTMASTER EMAIL --->
<cfquery name="getPostmaster" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
</cfquery>

<!--- SEND VERIFICATION EMAIL --->
<cftry>
    <cfmail from="#getPostmaster.value#" to="#form.secondary_email#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Verify Your Recovery Email" type="html">
<div align="center">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<p style="text-align: center; margin-bottom: 0px;"><img id="Picture1" src="cid:hermeslogo" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Mail Gateway"></p><br>

<h2>Verify Your Recovery Email</h2>

You have requested to add this email address as a recovery email for your Hermes SEG account (<cfoutput>#session.email#</cfoutput>).<br><br>

If you did <strong>NOT</strong> make this request, your account may be compromised. Please change your password immediately and contact your administrator.<br><br>

To verify this email address, please click the link below:<br><br>

<a href="<cfoutput>#verifyLink#</cfoutput>">Verify Email Address</a><br><br>

If you are unable to click on the link above, copy and paste the following address into your browser:<br><br>

<cfoutput>#verifyLink#</cfoutput><br><br>

<b>*** This link is valid for 24 hours ***</b>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
    </cfmail>

    <!--- Update session variable --->
    <cfset session.secondary_email = LCase(Trim(form.secondary_email))>
    <cfset session.secondary_email_verified = 0>

    <cfset session.message = "A verification email has been sent to <strong>#HTMLEditFormat(form.secondary_email)#</strong>. Please check your inbox and click the verification link.">
    <cfset session.messageType = "success">

<cfcatch type="any">
    <cfset session.message = "Failed to send verification email. Please try again later.">
    <cfset session.messageType = "danger">
</cfcatch>
</cftry>

<cflocation url="user_settings.cfm" addtoken="no">
