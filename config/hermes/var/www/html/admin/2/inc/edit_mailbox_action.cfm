
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
EDIT MAILBOX ACTION HANDLER
Updates mailbox settings:
- mailboxes table: name, quota, active
- recipients table: policy_id
- user_settings table: report_enabled, train_bayes, download_msg

Does NOT change: email address (immutable), domain, auth_type, encryption settings
--->

<!--- VALIDATE MAILBOX ID --->
<cfif NOT StructKeyExists(form, "mailbox_id") OR NOT IsNumeric(form.mailbox_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- GET EXISTING MAILBOX --->
<cfquery name="getMailbox" datasource="hermes">
    SELECT m.id, m.username, m.domain_id, m.nextcloud_enabled AS prev_nextcloud_enabled, d.domain
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id
    WHERE m.id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailbox.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- VALIDATE DISPLAY NAME --->
<cfparam name="form.edit_display_name" default="">
<cfset editDisplayName = trim(form.edit_display_name)>
<cfif editDisplayName EQ "">
    <cfset editDisplayName = ListFirst(getMailbox.username, "@")>
</cfif>

<!--- VALIDATE QUOTA --->
<cfparam name="form.edit_quota_gb" default="5">
<cfif NOT IsNumeric(form.edit_quota_gb) OR form.edit_quota_gb LTE 0>
    <cfset session.m = 15>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>
<cfset editQuotaBytes = Round(form.edit_quota_gb * 1024 * 1024 * 1024)>

<!--- VALIDATE ACTIVE --->
<cfparam name="form.edit_active" default="1">
<cfif form.edit_active NEQ "0" AND form.edit_active NEQ "1">
    <cfset form.edit_active = 1>
</cfif>

<!--- VALIDATE POLICY --->
<cfparam name="form.edit_policy" default="">
<cfif form.edit_policy NEQ "">
    <cfquery name="checkPolicy" datasource="hermes">
        SELECT policy_id FROM spam_policies WHERE policy_id = <cfqueryparam value="#form.edit_policy#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkPolicy.recordcount LT 1>
        <cfset m="Edit Mailbox: invalid policy">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfif>

<!--- VALIDATE REPORTS --->
<cfparam name="form.edit_reports" default="YES">
<cfif NOT ListFindNoCase("YES,NO", form.edit_reports)>
    <cfset m="Edit Mailbox: invalid reports value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE TRAIN BAYES --->
<cfparam name="form.edit_train_bayes" default="0">
<cfif form.edit_train_bayes NEQ "0" AND form.edit_train_bayes NEQ "1">
    <cfset m="Edit Mailbox: invalid train_bayes value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE DOWNLOAD MSG --->
<cfparam name="form.edit_download_msg" default="0">
<cfif form.edit_download_msg NEQ "0" AND form.edit_download_msg NEQ "1">
    <cfset m="Edit Mailbox: invalid download_msg value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE NEXTCLOUD --->
<cfparam name="form.edit_nextcloud_enabled" default="0">
<cfif form.edit_nextcloud_enabled NEQ "0" AND form.edit_nextcloud_enabled NEQ "1">
    <cfset form.edit_nextcloud_enabled = 0>
</cfif>

<!--- UPDATE MAILBOXES TABLE --->
<cfquery datasource="hermes">
    UPDATE mailboxes
    SET name = <cfqueryparam value="#editDisplayName#" cfsqltype="cf_sql_varchar">,
        quota = <cfqueryparam value="#editQuotaBytes#" cfsqltype="cf_sql_bigint">,
        active = <cfqueryparam value="#form.edit_active#" cfsqltype="cf_sql_integer">,
        nextcloud_enabled = <cfqueryparam value="#form.edit_nextcloud_enabled#" cfsqltype="cf_sql_tinyint">,
        modified = NOW()
    WHERE id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- UPDATE RECIPIENTS TABLE --->
<cfquery datasource="hermes">
    UPDATE recipients
    SET policy_id = <cfqueryparam value="#form.edit_policy#" cfsqltype="cf_sql_integer">
    WHERE recipient = <cfqueryparam value="#getMailbox.username#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- UPDATE USER_SETTINGS TABLE --->
<cfparam name="form.edit_timezone" default="">
<cfquery datasource="hermes">
    UPDATE user_settings
    SET report_enabled = <cfqueryparam value="#form.edit_reports#" cfsqltype="cf_sql_varchar">,
        train_bayes = <cfqueryparam value="#form.edit_train_bayes#" cfsqltype="cf_sql_varchar">,
        download_msg = <cfqueryparam value="#form.edit_download_msg#" cfsqltype="cf_sql_varchar">
        <cfif trim(form.edit_timezone) NEQ "">
        , timezone = <cfqueryparam value="#trim(form.edit_timezone)#" cfsqltype="cf_sql_varchar">
        </cfif>
    WHERE email = <cfqueryparam value="#getMailbox.username#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- If timezone changed, regenerate the sieve script so vacation date
     comparisons pick up the new TZ immediately --->
<cfif trim(form.edit_timezone) NEQ "">
    <cftry>
        <cfset sieveUsername = getMailbox.username>
        <cfinclude template="generate_sieve_user.cfm">
    <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<!--- NEXTCLOUD ACCESS GROUP TOGGLE.
     If the admin flipped Nextcloud Webmail on or off, sync LDAP group
     membership accordingly. Authelia checks cn=nextcloud on every request
     to /nc, so this takes effect immediately on the next page load.
     Idempotent: the include scripts catch "already a member" / "no such
     attribute" errors. --->
<cfif Val(form.edit_nextcloud_enabled) NEQ Val(getMailbox.prev_nextcloud_enabled)>
    <cftry>
        <!--- Look up the LDAP username (may not be the same as the email) --->
        <cfquery name="getLdapUsernameForNc" datasource="hermes">
            SELECT ldap_username FROM user_settings
            WHERE email = <cfqueryparam value="#getMailbox.username#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif getLdapUsernameForNc.recordcount GTE 1 AND getLdapUsernameForNc.ldap_username NEQ "">
            <cfset ldapUsername = getLdapUsernameForNc.ldap_username>
        <cfelse>
            <cfset ldapUsername = LCase(getMailbox.username)>
        </cfif>

        <cfif Val(form.edit_nextcloud_enabled) EQ 1>
            <cfinclude template="ldap_add_user_groups_nextcloud.cfm">
        <cfelse>
            <cfinclude template="ldap_remove_user_groups_nextcloud.cfm">
        </cfif>
    <cfcatch type="any">
        <!--- Non-fatal: the mailbox row was already updated, admin can
             retry by re-toggling. --->
    </cfcatch>
    </cftry>
</cfif>

<!--- CHANGE PASSWORD (if provided, local auth only) --->
<cfparam name="form.edit_password" default="">
<cfset session.passwordChanged = false>

<cfif trim(form.edit_password) NEQ "">
    <!--- Check auth type - only allow password change for local auth --->
    <cfquery name="checkAuthType" datasource="hermes">
        SELECT auth_type FROM recipients WHERE recipient = <cfqueryparam value="#getMailbox.username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkAuthType.recordcount GTE 1 AND checkAuthType.auth_type EQ "local">
        <!--- Validate minimum length --->
        <cfif Len(trim(form.edit_password)) LT 12>
            <cfset session.m = 22>
            <cflocation url="view_mailboxes.cfm" addtoken="no">
        </cfif>

        <!--- HIBP breach check --->
        <cfset form.password = form.edit_password>
        <cfset nextstep = "hibp_done">
        <cfset hibpRedirectUrl = "view_mailboxes.cfm">
        <cfinclude template="check_hibp.cfm">

        <!--- Generate LDAP password hash --->
        <cfinclude template="generate_ldap_password.cfm">

        <!--- Get LDAP username --->
        <cfquery name="getLdapUser" datasource="hermes">
            SELECT ldap_username FROM user_settings WHERE email = <cfqueryparam value="#getMailbox.username#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset ldapUsername = getLdapUser.ldap_username>
        <cfif ldapUsername EQ "">
            <cfset ldapUsername = LCase(getMailbox.username)>
        </cfif>

        <!--- Update LDAP password --->
        <cfinclude template="generate_customtrans.cfm">
        <cffile action="read" file="/opt/hermes/templates/ldap_modifyuserpassword.ldif" variable="ldapPwdTemplate">
        <cfset ldapPwdLdif = REReplace(ldapPwdTemplate, "THE_USERNAME", ldapUsername, "ALL")>
        <cfset ldapPwdLdif = REReplace(ldapPwdLdif, "THE_OU", "users", "ALL")>
        <cfset ldapPwdLdif = REReplace(ldapPwdLdif, "THE_PASSWORD", ldapPassword, "ALL")>

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_modifypassword.ldif"
            output="#ldapPwdLdif#"
            addNewLine="no">

        <cftry>
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_modifypassword.ldif"
                variable="ldapPwdResult"
                errorVariable="ldapPwdError"
                timeout="60">
            </cfexecute>
        <cfcatch type="any">
            <!--- Password change failed --->
        </cfcatch>
        </cftry>

        <!--- Cleanup temp file --->
        <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifypassword.ldif">
        <cfif fileExists(fileToDelete)>
            <cffile action="delete" file="#fileToDelete#">
        </cfif>

        <cfset session.passwordChanged = true>

        <!--- Sync the Nextcloud app password with the new LDAP password.
             Regenerates the "Hermes System" token so DAV clients continue
             working with the updated credentials. --->
        <cfquery name="checkNcEnabled" datasource="hermes">
            SELECT nextcloud_enabled FROM mailboxes
            WHERE username = <cfqueryparam value="#getMailbox.username#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif checkNcEnabled.recordcount GTE 1 AND Val(checkNcEnabled.nextcloud_enabled) EQ 1>
            <cftry>
                <cfset ncAppPasswordAction = "regenerate">
                <cfset ncAppPasswordUser = getMailbox.username>
                <cfset ncAppPasswordValue = trim(form.edit_password)>
                <cfinclude template="nextcloud_app_password.cfm">
            <cfcatch type="any"></cfcatch>
            </cftry>
        </cfif>
    </cfif>
</cfif>

<!--- INVALIDATE USER SESSIONS if password was changed or account was
     deactivated. This forces the user to re-authenticate with the new
     credentials on their next request. Without this, the old session
     continues working until it naturally expires. --->
<cfif session.passwordChanged OR Val(form.edit_active) EQ 0>
    <cftry>
        <cfset targetSessionUser = getMailbox.username>
        <cfinclude template="invalidate_user_sessions.cfm">
    <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<!--- SUCCESS --->
<cfset session.m = 2>
<cflocation url="view_mailboxes.cfm" addtoken="no">
