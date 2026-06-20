
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
PROCESS ADMIN PASSWORD RESET
Allows administrators to reset a user's password from the admin panel.
--->

<cfparam name="form.request_id" default="">
<cfparam name="form.new_password" default="">
<cfparam name="form.confirm_password" default="">
<cfparam name="form.notify_user" default="0">
<cfparam name="form.check_hibp" default="0">

<!--- Validate inputs --->
<cfif form.request_id EQ "">
    <cfset session.message = "No request selected.">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfif>

<cfif form.new_password EQ "" OR form.confirm_password EQ "">
    <cfset session.message = "Please enter and confirm the new password.">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfif>

<cfif form.new_password NEQ form.confirm_password>
    <cfset session.message = "Passwords do not match.">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfif>

<cfif Len(form.new_password) LT 8>
    <cfset session.message = "Password must be at least 8 characters long.">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfif>

<!--- HIBP CHECK (server-side defense in depth) --->
<cfif form.check_hibp EQ "1">
    <cftry>
        <cfset theHash = hash(form.new_password, "SHA", "UTF-8")>
        <cfset leftHash = left(theHash, 5)>
        <cfset rightHash = right(theHash, 35)>

        <cfhttp result="hibpResult" method="GET" charset="utf-8" throwonerror="false"
                url="https://api.pwnedpasswords.com/range/#leftHash#" timeout="10" />

        <cfif hibpResult.status_code EQ "200">
            <cfif hibpResult.filecontent CONTAINS rightHash>
                <cfset session.message = "The password has appeared in a data breach. Please choose a different password. Password was checked by <a href='https://haveibeenpwned.com/Passwords' target='_blank'>haveibeenpwned.com</a>">
                <cfset session.messageType = "danger">
                <cflocation url="view_password_reset_requests.cfm" addtoken="no">
            </cfif>
        </cfif>
        <!--- If HIBP is unreachable, we continue anyway since JavaScript should have warned the user --->
    <cfcatch type="any">
        <!--- HIBP check failed, continue anyway - user was warned by JavaScript --->
    </cfcatch>
    </cftry>
</cfif>

<!--- Get the request details --->
<cfquery name="getRequest" datasource="hermes">
    SELECT id, email, ldap_username, user_type, status
    FROM password_reset_requests
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.request_id#">
    AND status = 'pending'
</cfquery>

<cfif getRequest.recordcount EQ 0>
    <cfset session.message = "Request not found or already processed.">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfif>

<!--- UPDATE PASSWORD IN LDAP --->
<cfset ldapUsername = getRequest.ldap_username>

<!--- Generate Argon2 password hash --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap slappasswd -o module-load=argon2.la -h {ARGON2} -s #form.new_password#"
        variable="ldapPassword"
        timeout="60">
    </cfexecute>
    <cfset ldapPassword = TRIM(ldapPassword)>

<cfcatch type="any">
    <cfset session.message = "Error generating password hash: #cfcatch.message#">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfcatch>
</cftry>

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- READ THE LDAP MODIFYUSERPASSWORD TEMPLATE --->
<cftry>
    <cffile action="read" file="/opt/hermes/templates/ldap_modifyuserpassword.ldif" variable="ldapModifyPwdTemplate">

    <!--- All users are in ou=users - role is determined by group membership --->
    <cfset ldapOU = "users">

    <!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
    <cfset ldapModifyPwdLdif = ldapModifyPwdTemplate>
    <cfset ldapModifyPwdLdif = REReplace(ldapModifyPwdLdif, "THE_USERNAME", ldapUsername, "ALL")>
    <cfset ldapModifyPwdLdif = REReplace(ldapModifyPwdLdif, "THE_OU", ldapOU, "ALL")>
    <cfset ldapModifyPwdLdif = REReplace(ldapModifyPwdLdif, "THE_PASSWORD", ldapPassword, "ALL")>

    <!--- WRITE THE POPULATED LDIF TO THE CUSTOM DIRECTORY --->
    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif"
        output="#ldapModifyPwdLdif#"
        addNewLine="no">

    <!--- EXECUTE LDAPMODIFY IN THE LDAP CONTAINER --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif"
        variable="ldapModifyResult"
        errorVariable="ldapModifyError"
        timeout="60">
    </cfexecute>

    <!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <cfset session.message = "Error updating LDAP password: #cfcatch.message#">
    <cfset session.messageType = "danger">
    <cflocation url="view_password_reset_requests.cfm" addtoken="no">
</cfcatch>
</cftry>

<!--- Get admin username for audit trail --->
<cfset adminUsername = "">
<cfif StructKeyExists(session, "username")>
    <cfset adminUsername = session.username>
<cfelseif StructKeyExists(request, "authelia_user")>
    <cfset adminUsername = request.authelia_user>
<cfelse>
    <cfset adminUsername = "admin">
</cfif>

<!--- Sync NC local password for DAV auth --->
<cfquery name="checkNcEnabledAdminReset" datasource="hermes">
    SELECT nextcloud_enabled FROM mailboxes
    WHERE username = <cfqueryparam value="#getRequest.email#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif checkNcEnabledAdminReset.recordcount GTE 1 AND Val(checkNcEnabledAdminReset.nextcloud_enabled) EQ 1>
    <cftry>
        <cfinclude template="generate_customtrans.cfm">
        <cfset ncPwdScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_pwd_update.sh">
        <cfscript>
            fileWrite(ncPwdScript,
                chr(35) & "!/bin/bash" & chr(10) &
                'docker exec -e OC_PASS="' & trim(form.new_password) & '" -u www-data hermes_nextcloud php /var/www/html/occ user:resetpassword --password-from-env "' & getRequest.email & '" 2>&1' & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #ncPwdScript#" timeout="10" />
        <cfexecute name="#ncPwdScript#" variable="ncPwdResult" errorVariable="ncPwdError" timeout="30" />
        <cftry><cffile action="delete" file="#ncPwdScript#"><cfcatch type="any"></cfcatch></cftry>
    <cfcatch type="any"><!--- Non-fatal ---></cfcatch>
    </cftry>
</cfif>

<!--- Mark request as completed --->
<cfquery name="markCompleted" datasource="hermes">
    UPDATE password_reset_requests
    SET status = 'completed',
        completed_at = NOW(),
        completed_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#adminUsername#">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.request_id#">
</cfquery>

<!--- Expire any other pending requests for this user --->
<cfquery name="expireOthers" datasource="hermes">
    UPDATE password_reset_requests
    SET status = 'expired'
    WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getRequest.email#">
    AND status = 'pending'
    AND id != <cfqueryparam cfsqltype="cf_sql_integer" value="#form.request_id#">
</cfquery>

<!--- Send notification email if requested --->
<cfif form.notify_user EQ "1">
    <!--- GET POSTMASTER EMAIL --->
    <cfquery name="getPostmaster" datasource="hermes">
        SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
    </cfquery>

    <!--- GET CONSOLE HOST FOR LOGIN LINK --->
    <cfquery name="getConsoleHost" datasource="hermes">
        SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
    </cfquery>

    <cfset consoleHost = getConsoleHost.value2>
    <cfset loginUrl = "https://#consoleHost#/users">

    <cfmail from="#getPostmaster.value#" to="#getRequest.email#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Your Password Has Been Reset" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Password Reset Complete</h2>

<p>Your password has been reset by an administrator.</p>

<p>You can now log in with your new password at:</p>

<div style="margin: 20px 0;">
    <a href="#loginUrl#" style="background-color: ##007bff; color: ##ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;">Login to Hermes SEG</a>
</div>

<p style="color: ##6c757d; font-size: 12px;">Or visit: #loginUrl#</p>

<p style="margin-top: 20px;">If you did not request this password reset, please contact your administrator immediately.</p>

<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">
This is an automated message from Hermes SEG.
</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
    </cfmail>
</cfif>

<cfset session.message = "Password for #getRequest.email# has been reset successfully.">
<cfset session.messageType = "success">
<cflocation url="view_password_reset_requests.cfm" addtoken="no">
