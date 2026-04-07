
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
EDIT MAILBOX ACCESS CONTROL ACTION HANDLER
Changes the LDAP access control group (one_factor/two_factor) for a mailbox user.
Optionally deletes TOTP and WebAuthn devices via Authelia CLI.
--->

<!--- VALIDATE MAILBOX ID --->
<cfif NOT StructKeyExists(form, "mailbox_id") OR NOT IsNumeric(form.mailbox_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- VALIDATE RECIPIENT EMAIL --->
<cfif NOT StructKeyExists(form, "recipient_email") OR trim(form.recipient_email) EQ "">
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- VALIDATE ACCESS CONTROL --->
<cfparam name="form.access_control" default="one_factor">
<cfif form.access_control NEQ "one_factor" AND form.access_control NEQ "two_factor">
    <cfset m="Edit Mailbox Access Control: invalid access_control value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<cfset recipientEmail = trim(form.recipient_email)>

<!--- VERIFY MAILBOX EXISTS --->
<cfquery name="getMailbox" datasource="hermes">
    SELECT m.id, m.username FROM mailboxes m
    WHERE m.id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getMailbox.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- GET LDAP USERNAME --->
<cfparam name="form.ldap_username" default="">
<cfset ldapUsername = form.ldap_username>
<cfif ldapUsername EQ "">
    <cfset ldapUsername = LCase(recipientEmail)>
</cfif>

<!--- DETERMINE CURRENT ACCESS CONTROL BY CHECKING LDAP GROUP MEMBERSHIP --->
<!--- Default to one_factor if we can't determine --->
<cfset ldapOldAccessControl = "one_factor">

<!--- Try to check if user is in two_factor group --->
<cftry>
    <cfinclude template="generate_customtrans.cfm">
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b cn=two_factor,ou=groups,dc=hermes,dc=local -LLL member"
        variable="ldapSearchResult"
        errorVariable="ldapSearchError"
        timeout="30">
    </cfexecute>
    <cfif ldapSearchResult CONTAINS "cn=#ldapUsername#,ou=users">
        <cfset ldapOldAccessControl = "two_factor">
    </cfif>
<cfcatch type="any">
    <!--- Can't determine current group, default to one_factor --->
</cfcatch>
</cftry>

<!--- CHANGE LDAP ACCESS CONTROL GROUP --->
<cfset ldapNewAccessControl = form.access_control>
<cfinclude template="ldap_change_user_access_control.cfm">

<!--- DELETE 2FA DEVICES IF REQUESTED --->
<cfparam name="form.delete_2fa_devices" default="0">
<cfif form.delete_2fa_devices EQ "1">

    <!--- Delete TOTP devices via Authelia CLI --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_authelia authelia storage user totp delete #ldapUsername# --config /etc/authelia/configuration.yml"
            variable="totpResult"
            errorVariable="totpError"
            timeout="30">
        </cfexecute>
    <cfcatch type="any">
        <!--- TOTP deletion failure is non-critical --->
    </cfcatch>
    </cftry>

    <!--- Delete WebAuthn devices via Authelia CLI --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_authelia authelia storage user webauthn delete #ldapUsername# --all --config /etc/authelia/configuration.yml"
            variable="webauthnResult"
            errorVariable="webauthnError"
            timeout="30">
        </cfexecute>
    <cfcatch type="any">
        <!--- WebAuthn deletion failure is non-critical --->
    </cfcatch>
    </cftry>

</cfif>

<!--- SUCCESS --->
<cfset session.m = 5>
<cflocation url="view_mailboxes.cfm" addtoken="no">
