
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
ADD MAILBOX ACTION HANDLER
Creates a new mailbox user across all required systems:
1. recipients table (SVF policy, encryption flags, auth_type)
2. mailboxes table (Dovecot userdb: username, quota, active)
3. user_settings table (quarantine notifications, bayes, download)
4. LDAP (user entry + cn=mailboxes group)
5. Ciphermail (CLITool registration + encryption properties)
6. cert_generation_queue (async S/MIME + PGP cert gen)

Requires form variables:
- username, domain_id, display_name, quota_gb
- policy, reports, train_bayes, download_msg
- auth_type, remoteauth_domain (if remote)
- pdf_enabled, smime_enabled, pgp_enabled, sign
- ca, validity, cert_encryption, cert_algorithm (if S/MIME)
- pgp_encryption (if PGP)
--->

<!--- DEBUG: log form values at entry --->
<cfscript>
    fileWrite("/opt/hermes/tmp/nc_mail_debug_entry.log",
        "ENTRY DEBUG " & Now() & chr(10) &
        "form.nextcloud_enabled: [" & (structKeyExists(form, "nextcloud_enabled") ? form.nextcloud_enabled : "NOT SET") & "]" & chr(10) &
        "form.password exists: [" & structKeyExists(form, "password") & "]" & chr(10) &
        "form.password length: [" & (structKeyExists(form, "password") ? Len(form.password) : "N/A") & "]" & chr(10) &
        "form.auth_type: [" & (structKeyExists(form, "auth_type") ? form.auth_type : "NOT SET") & "]" & chr(10),
        "utf-8");
</cfscript>

<cfinclude template="generate_customtrans.cfm">

<!--- VALIDATE REQUIRED FIELDS --->
<cfif NOT StructKeyExists(form, "username") OR trim(form.username) EQ "">
    <cfset session.m = 10>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "domain_id") OR NOT IsNumeric(form.domain_id)>
    <cfset session.m = 11>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- VALIDATE USERNAME FORMAT (alphanumeric + dots + hyphens + underscores) --->
<cfset cleanUsername = LCase(trim(form.username))>
<cfif NOT REFind("^[a-z0-9._-]+$", cleanUsername)>
    <cfset session.m = 12>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- LOOK UP THE DOMAIN --->
<cfquery name="getDomain" datasource="hermes">
    SELECT id, domain, default_quota_mb FROM domains
    WHERE id = <cfqueryparam value="#form.domain_id#" cfsqltype="cf_sql_integer">
    AND type = 'mailbox'
</cfquery>

<cfif getDomain.recordcount LT 1>
    <cfset session.m = 13>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- CONSTRUCT FULL EMAIL ADDRESS --->
<cfset recipientEmail = cleanUsername & "@" & getDomain.domain>

<!--- CHECK FOR DUPLICATE IN RECIPIENTS TABLE --->
<cfquery name="checkDuplicate" datasource="hermes">
    SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif checkDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- CHECK FOR DUPLICATE IN MAILBOXES TABLE --->
<cfquery name="checkMailboxDuplicate" datasource="hermes">
    SELECT id FROM mailboxes WHERE username = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif checkMailboxDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- CHECK FOR DUPLICATE IN MAILBOX ALIASES --->
<cfquery name="checkAliasDuplicate" datasource="hermes">
    SELECT id FROM mailbox_aliases WHERE alias_address = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif checkAliasDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- CHECK FOR DUPLICATE IN VIRTUAL RECIPIENTS --->
<cfquery name="checkVirtualDuplicate" datasource="hermes">
    SELECT id FROM virtual_recipients WHERE virtual_address = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif checkVirtualDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<cfif checkMailboxDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>

<!--- VALIDATE QUOTA --->
<cfparam name="form.quota_gb" default="5">
<cfif NOT IsNumeric(form.quota_gb) OR form.quota_gb LTE 0>
    <cfset session.m = 15>
    <cflocation url="add_mailbox.cfm" addtoken="no">
</cfif>
<cfset quotaBytes = Round(form.quota_gb * 1024 * 1024 * 1024)>

<!--- VALIDATE DISPLAY NAME --->
<cfparam name="form.display_name" default="#cleanUsername#">
<cfset displayName = trim(form.display_name)>
<cfif displayName EQ "">
    <cfset displayName = cleanUsername>
</cfif>

<!--- VALIDATE POLICY --->
<cfparam name="form.policy" default="">
<cfif form.policy NEQ "">
    <cfquery name="checkPolicy" datasource="hermes">
        SELECT policy_id FROM spam_policies WHERE policy_id = <cfqueryparam value="#form.policy#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkPolicy.recordcount LT 1>
        <cfset m="Add Mailbox: invalid policy">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfif>

<!--- VALIDATE REPORTS --->
<cfparam name="form.reports" default="YES">
<cfif NOT ListFindNoCase("YES,NO", form.reports)>
    <cfset m="Add Mailbox: invalid reports value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE TRAIN BAYES --->
<cfparam name="form.train_bayes" default="0">
<cfif form.train_bayes NEQ "0" AND form.train_bayes NEQ "1">
    <cfset m="Add Mailbox: invalid train_bayes value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE DOWNLOAD MSG --->
<cfparam name="form.download_msg" default="0">
<cfif form.download_msg NEQ "0" AND form.download_msg NEQ "1">
    <cfset m="Add Mailbox: invalid download_msg value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE PDF ENABLED --->
<cfparam name="form.pdf_enabled" default="2">
<cfif form.pdf_enabled NEQ "1" AND form.pdf_enabled NEQ "2">
    <cfset m="Add Mailbox: invalid pdf_enabled value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE SMIME ENABLED --->
<cfparam name="form.smime_enabled" default="2">
<cfif form.smime_enabled NEQ "1" AND form.smime_enabled NEQ "2">
    <cfset m="Add Mailbox: invalid smime_enabled value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE SIGN --->
<cfparam name="form.sign" default="2">
<cfif form.sign NEQ "1" AND form.sign NEQ "2">
    <cfset m="Add Mailbox: invalid sign value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE PGP ENABLED --->
<cfparam name="form.pgp_enabled" default="2">
<cfif form.pgp_enabled NEQ "1" AND form.pgp_enabled NEQ "2">
    <cfset m="Add Mailbox: invalid pgp_enabled value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE AUTH TYPE --->
<cfparam name="form.auth_type" default="local">
<cfif form.auth_type NEQ "local" AND form.auth_type NEQ "remote">
    <cfset m="Add Mailbox: invalid auth_type value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- PRO GATE: RemoteAuth is a Pro feature. Defense in depth against a
     direct POST bypassing the disabled UI on Community Edition. --->
<cfif form.auth_type EQ "remote">
    <cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">
    <cfif NOT isPro>
        <cfset m="Add Mailbox: Remote Authentication requires a Pro License.">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfif>

<!--- VALIDATE REMOTEAUTH DOMAIN (required if auth_type is remote) --->
<cfparam name="form.remoteauth_domain" default="">
<cfparam name="form.remote_first_name" default="">
<cfparam name="form.remote_last_name" default="">
<cfset remoteFirstName = "">
<cfset remoteLastName = "">
<cfif form.auth_type EQ "remote">
    <cfif form.remoteauth_domain EQ "">
        <cfset m="Add Mailbox: RemoteAuth domain is required when auth type is Remote">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
    <cfquery name="checkRemoteauthDomain" datasource="hermes">
        SELECT id, remote_dn_pattern FROM remoteauth_mappings
        WHERE domain_name = <cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar">
        AND enabled = 1
    </cfquery>
    <cfif checkRemoteauthDomain.recordcount LT 1>
        <cfset m="Add Mailbox: invalid RemoteAuth domain">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>

    <!--- When the DN pattern references {firstname}/{lastname}, the admin must
         supply the real AD values so the seeAlso DN resolves correctly. --->
    <cfif FindNoCase("{firstname}", checkRemoteauthDomain.remote_dn_pattern) GT 0>
        <cfif Trim(form.remote_first_name) EQ "">
            <cfset session.m = 17>
            <cflocation url="add_mailbox.cfm" addtoken="no">
        </cfif>
        <cfset remoteFirstName = Trim(form.remote_first_name)>
    </cfif>
    <cfif FindNoCase("{lastname}", checkRemoteauthDomain.remote_dn_pattern) GT 0>
        <cfif Trim(form.remote_last_name) EQ "">
            <cfset session.m = 18>
            <cflocation url="add_mailbox.cfm" addtoken="no">
        </cfif>
        <cfset remoteLastName = Trim(form.remote_last_name)>
    </cfif>
</cfif>

<!--- VALIDATE PASSWORD (required for local auth) --->
<cfparam name="form.password" default="">
<cfif form.auth_type EQ "local">
    <cfif trim(form.password) EQ "">
        <cfset session.m = 16>
        <cflocation url="add_mailbox.cfm" addtoken="no">
    </cfif>
    <cfif Len(trim(form.password)) LT 12>
        <cfset session.m = 16>
        <cflocation url="add_mailbox.cfm" addtoken="no">
    </cfif>
    <!--- HIBP breach check --->
    <cfset nextstep = "hibp_done">
    <cfset hibpRedirectUrl = "add_mailbox.cfm">
    <cfinclude template="check_hibp.cfm">
</cfif>

<!--- VALIDATE NEXTCLOUD TOGGLE --->
<cfparam name="form.nextcloud_enabled" default="0">
<cfif form.nextcloud_enabled NEQ "0" AND form.nextcloud_enabled NEQ "1">
    <cfset form.nextcloud_enabled = 0>
</cfif>

<!--- VALIDATE 2FA ENFORCEMENT FLAG (#225).
     Stored on recipients.enforce_mfa as the admin-policy bit. Does NOT
     touch LDAP at create time — new users always go into cn=one_factor.
     The bootstrap problem (Authelia's 2FA enrollment requires email
     verification, but a fresh mailbox has no working mail client yet)
     is solved by app-layer restriction instead: when enforce_mfa=1 and
     the user is not yet in cn=two_factor, the user portal limits them
     to the bootstrap surfaces (Account Settings, My App Passwords,
     Set Up Your Devices, Webmail) so they can mint an app password,
     read the welcome email in their mail client, then come back and
     click Enable 2FA themselves. See
     /users/2/inc/check_enforce_mfa_restriction.cfm. --->
<cfparam name="form.enforce_mfa" default="0">
<cfif form.enforce_mfa NEQ "0" AND form.enforce_mfa NEQ "1">
    <cfset form.enforce_mfa = 0>
</cfif>
<cfset ldapAccessControl = "one_factor">

<!--- VALIDATE S/MIME OPTIONS (if enabled) --->
<cfparam name="form.ca" default="">
<cfparam name="form.validity" default="1825">
<cfparam name="form.cert_encryption" default="2048">
<cfparam name="form.cert_algorithm" default="sha256">

<cfif form.smime_enabled EQ "1" AND form.ca NEQ "">
    <cfquery name="checkCA" datasource="hermes">
        SELECT id FROM ca_settings WHERE id = <cfqueryparam value="#form.ca#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkCA.recordcount LT 1>
        <cfset m="Add Mailbox: invalid CA">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
    <cfif NOT ListFind("365,730,1095,1460,1825", form.validity)>
        <cfset m="Add Mailbox: invalid validity period">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
    <cfif form.cert_encryption NEQ "2048" AND form.cert_encryption NEQ "4096">
        <cfset m="Add Mailbox: invalid certificate key length">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
    <cfif NOT ListFind("sha256,sha512", form.cert_algorithm)>
        <cfset m="Add Mailbox: invalid certificate hash algorithm">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfif>

<!--- VALIDATE PGP OPTIONS (if enabled) --->
<cfparam name="form.pgp_encryption" default="2048">
<cfif form.pgp_enabled EQ "1">
    <cfif form.pgp_encryption NEQ "2048" AND form.pgp_encryption NEQ "4096">
        <cfset m="Add Mailbox: invalid PGP key size">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfif>

<!--- ====================================================================
     ALL VALIDATION PASSED - BEGIN CREATION
     ==================================================================== --->

<!--- 1. INSERT INTO RECIPIENTS TABLE --->
<cfquery name="insertRecipient" datasource="hermes" result="recipientResult">
    INSERT INTO recipients
    (policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled,
     smime_mode, digital_sign, validity, encryption, algorithm,
     auth_type, remoteauth_domain, recipient_type, enforce_mfa)
    VALUES
    (<cfqueryparam value="#form.policy#" cfsqltype="cf_sql_integer">,
     <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
     'OK', '2',
     <cfqueryparam value="#form.pdf_enabled#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.smime_enabled#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.pgp_enabled#" cfsqltype="cf_sql_varchar">,
     '1',
     <cfqueryparam value="#form.sign#" cfsqltype="cf_sql_varchar">,
     '1825', '4096', 'sha512',
     <cfqueryparam value="#form.auth_type#" cfsqltype="cf_sql_varchar">,
     <cfif form.remoteauth_domain NEQ ""><cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
     'mailbox',
     <cfqueryparam value="#form.enforce_mfa#" cfsqltype="cf_sql_tinyint">)
</cfquery>

<!--- 1b. INSERT INTO MADDR TABLE (Amavis address tracking, required for user portal session) --->
<cfset domainParts = ListToArray(getDomain.domain, ".")>
<cfset reversedDomain = ArrayReverse(domainParts)>
<cfset maddrdomain = ArrayToList(reversedDomain, ".")>
<cfquery datasource="hermes">
    INSERT IGNORE INTO maddr (partition_tag, email, domain)
    VALUES (
      0,
      <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#maddrdomain#" cfsqltype="cf_sql_varchar">
    )
</cfquery>

<!--- 2. INSERT INTO USER_SETTINGS TABLE --->
<cfquery name="insertUserSettings" datasource="hermes">
    INSERT INTO user_settings
    (email, report_enabled, train_bayes, download_msg, timezone)
    VALUES
    (<cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.reports#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.train_bayes#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.download_msg#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#trim(form.timezone)#" cfsqltype="cf_sql_varchar" null="#(NOT StructKeyExists(form, 'timezone') OR trim(form.timezone) IS '')#">)
</cfquery>

<!--- 3. INSERT INTO MAILBOXES TABLE (Dovecot userdb).
     enforce_mfa lives on recipients (see step 1 above), not mailboxes,
     because the same column drives both mailbox and relay flows. --->
<cfquery name="insertMailbox" datasource="hermes">
    INSERT INTO mailboxes
    (domain_id, username, name, quota, active, nextcloud_enabled, created, modified)
    VALUES
    (<cfqueryparam value="#getDomain.id#" cfsqltype="cf_sql_integer">,
     <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#displayName#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#quotaBytes#" cfsqltype="cf_sql_bigint">,
     1,
     <cfqueryparam value="#form.nextcloud_enabled#" cfsqltype="cf_sql_tinyint">,
     NOW(),
     NOW())
</cfquery>

<!--- 3b. INSERT INTO SENDER_LOGIN_MAPS (allows user to send as their own address) --->
<cfquery datasource="hermes">
    INSERT IGNORE INTO sender_login_maps (sender, login_user)
    VALUES (
      <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
    )
</cfquery>

<!--- 4. CREATE LDAP USER --->
<cfif form.auth_type EQ "remote">
    <!--- Remote Auth: creates LDAP user with seeAlso/associatedDomain, no password --->
    <cfset remoteauthDomain = form.remoteauth_domain>
    <cfinclude template="ldap_add_user_mailbox_remoteauth.cfm">
<cfelse>
    <!--- Local Auth: creates LDAP user with random password, user must reset --->
    <cfinclude template="ldap_add_user_mailbox.cfm">
</cfif>

<!--- 4b. NEXTCLOUD ACCESS GROUP. The mailboxes.nextcloud_enabled toggle on
     this form controls whether the user is added to cn=nextcloud, which
     Authelia checks before permitting access to the /nc endpoint. Without
     this group membership the user can still log into the user portal but
     gets denied at /nc. --->
<cfif form.nextcloud_enabled EQ "1" AND ldapUsername NEQ "">
    <cftry>
        <cfinclude template="ldap_add_user_groups_nextcloud.cfm">
    <cfcatch type="any">
        <!--- Non-fatal: mailbox creation succeeds even if group add fails.
             Admin can re-toggle in Edit Mailbox to retry. --->
    </cfcatch>
    </cftry>
</cfif>

<!--- 4c. NEXTCLOUD PRE-PROVISION USER. Create a local NC user with a
     RANDOM local password that nobody knows (#197 Phase 1).
     Previously this was set to the org password, which created a silent
     back-channel: NC's DAV endpoint would have accepted the org password
     for CalDAV/CardDAV, defeating the point of app passwords. Setting it
     random eliminates that. The local NC password isn't used for anything
     a user holds — they reach NC via OIDC (Authelia), and DAV/IMAP go
     through their app passwords. The "Rotate NC Internal Password" admin
     action regenerates this value as defense-in-depth.
     See docs/admin/authentication/01-credential-model.md. --->
<cfif form.nextcloud_enabled EQ "1">
    <cftry>
        <cfset ncProvisionAction = "create">
        <cfset ncProvisionUser = recipientEmail>
        <cfset ncProvisionDisplayName = displayName>
        <cfset ncProvisionEmail = recipientEmail>

        <!--- Generate a 30-char random NC local password (never disclosed,
             never reused). --->
        <cfset _ncLocalAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789">
        <cfset _ncLocalAlphabetLen = Len(_ncLocalAlphabet)>
        <cfset ncProvisionPassword = "">
        <cfloop from="1" to="30" index="_ncLocalIdx">
            <cfset ncProvisionPassword &= Mid(_ncLocalAlphabet, RandRange(1, _ncLocalAlphabetLen, "SHA1PRNG"), 1)>
        </cfloop>
        <!--- Branch on auth type: local uses occ user:add (password required
             for DAV), remote uses user_oidc REST API pre-provisioning (no
             local password — user is OIDC-backed, DAV not available). --->
        <cfset ncProvisionAuthType = form.auth_type>
        <cfinclude template="nextcloud_provision_user.cfm">
    <cfcatch type="any">
        <!--- Non-fatal: NC features will be set up on first OIDC login --->
        <cfscript>
            fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                "OUTER CATCH in add_mailbox_action" & chr(10) &
                "Message: " & cfcatch.message & chr(10) &
                "Detail: " & cfcatch.detail & chr(10) &
                "---" & chr(10),
                "utf-8");
        </cfscript>
    </cfcatch>
    </cftry>
</cfif>

<!--- 4d / 4d-bis: NC group membership + default DAV resources, both
     verified by independent SQL post-flight. Don't trust occ exit code
     or stdout — verify the side effects landed in the database.
     Failures here aren't aborts (mailbox itself is provisioned), but
     are surfaced via session.ncProvisionError so the admin sees them. --->
<cfif form.nextcloud_enabled EQ "1">
    <cftry>
        <cfinclude template="generate_customtrans.cfm">

        <!--- Read NC DB creds once for all post-flight checks below. --->
        <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="_ncDbUser4d" charset="utf-8">
        <cfset _ncDbUser4d = Trim(_ncDbUser4d)>
        <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="_ncDbPass4d" charset="utf-8">
        <cfset _ncDbPass4d = Trim(_ncDbPass4d)>

        <cfset _ncProvisionWarnings = "">

        <!--- ===== 4d. DOMAIN GROUP MEMBERSHIP =====
             Add user to NC group for their domain (cross-domain isolation
             relies on this). Verify by SELECT on oc_group_user. --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ group:adduser #getDomain.domain# #recipientEmail#"
            variable="ncGroupAddResult"
            errorVariable="ncGroupAddError"
            timeout="30" />

        <cfset _groupCheckScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_group_check.sh">
        <cfscript>
            fileWrite(_groupCheckScript,
                chr(35) & "!/bin/bash" & chr(10) &
                "docker exec hermes_db_server mariadb -u """ & _ncDbUser4d & """ -p""" & _ncDbPass4d & """ nextcloud -se """ &
                "SELECT COUNT(*) FROM oc_group_user WHERE gid='" & getDomain.domain & "' AND uid='" & recipientEmail & "';" &
                """ 2>&1" & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #_groupCheckScript#" timeout="10" />
        <cfset _groupCheckResult = "">
        <cfexecute name="#_groupCheckScript#" variable="_groupCheckResult" timeout="30" />
        <cftry><cffile action="delete" file="#_groupCheckScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfset _groupCheckCount = -1>
        <cfloop array="#ListToArray(Trim(_groupCheckResult), chr(10), false)#" index="_gLine">
            <cfset _gLine = Trim(_gLine)>
            <cfif IsNumeric(_gLine)><cfset _groupCheckCount = _gLine><cfbreak></cfif>
        </cfloop>
        <cfif _groupCheckCount NEQ 1>
            <cfset _ncProvisionWarnings &= "Group membership not verified (SELECT count=" & _groupCheckCount & ", expected 1) for " & recipientEmail & " in " & getDomain.domain & ". occ STDOUT: " & Left(ncGroupAddResult, 200) & ". Cross-domain isolation may not be enforced for this user. ">
        </cfif>

        <!--- ===== 4d-bis. DEFAULT NC DAV RESOURCES =====
             Pre-create default "personal" calendar and "contacts"
             address book so TB autoconfig + RFC 6764 SRV discovery
             finds them on day 1. NC otherwise creates them lazily on
             first web login. Verify via oc_calendars and oc_addressbooks.

             Note: NC stores these with principaluri =
             'principals/users/<email>'. The URI segment matches what we
             passed to occ ("personal" / "contacts"). --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ dav:create-calendar #recipientEmail# personal"
            variable="_calCreateResult"
            errorVariable="_calCreateError"
            timeout="30" />

        <cfset _calCheckScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_cal_check.sh">
        <cfscript>
            fileWrite(_calCheckScript,
                chr(35) & "!/bin/bash" & chr(10) &
                "docker exec hermes_db_server mariadb -u """ & _ncDbUser4d & """ -p""" & _ncDbPass4d & """ nextcloud -se """ &
                "SELECT COUNT(*) FROM oc_calendars WHERE principaluri='principals/users/" & recipientEmail & "' AND uri='personal';" &
                """ 2>&1" & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #_calCheckScript#" timeout="10" />
        <cfset _calCheckResult = "">
        <cfexecute name="#_calCheckScript#" variable="_calCheckResult" timeout="30" />
        <cftry><cffile action="delete" file="#_calCheckScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfset _calCheckCount = -1>
        <cfloop array="#ListToArray(Trim(_calCheckResult), chr(10), false)#" index="_cLine">
            <cfset _cLine = Trim(_cLine)>
            <cfif IsNumeric(_cLine)><cfset _calCheckCount = _cLine><cfbreak></cfif>
        </cfloop>
        <cfif _calCheckCount LT 1>
            <cfset _ncProvisionWarnings &= "Default 'personal' calendar not verified (SELECT count=" & _calCheckCount & ") for " & recipientEmail & ". TB autoconfig will fall back to NC's lazy create on first web login. occ STDOUT: " & Left(_calCreateResult, 200) & ". ">
        </cfif>

        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ dav:create-addressbook #recipientEmail# contacts"
            variable="_abCreateResult"
            errorVariable="_abCreateError"
            timeout="30" />

        <cfset _abCheckScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_ab_check.sh">
        <cfscript>
            fileWrite(_abCheckScript,
                chr(35) & "!/bin/bash" & chr(10) &
                "docker exec hermes_db_server mariadb -u """ & _ncDbUser4d & """ -p""" & _ncDbPass4d & """ nextcloud -se """ &
                "SELECT COUNT(*) FROM oc_addressbooks WHERE principaluri='principals/users/" & recipientEmail & "' AND uri='contacts';" &
                """ 2>&1" & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #_abCheckScript#" timeout="10" />
        <cfset _abCheckResult = "">
        <cfexecute name="#_abCheckScript#" variable="_abCheckResult" timeout="30" />
        <cftry><cffile action="delete" file="#_abCheckScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfset _abCheckCount = -1>
        <cfloop array="#ListToArray(Trim(_abCheckResult), chr(10), false)#" index="_aLine">
            <cfset _aLine = Trim(_aLine)>
            <cfif IsNumeric(_aLine)><cfset _abCheckCount = _aLine><cfbreak></cfif>
        </cfloop>
        <cfif _abCheckCount LT 1>
            <cfset _ncProvisionWarnings &= "Default 'contacts' address book not verified (SELECT count=" & _abCheckCount & ") for " & recipientEmail & ". TB autoconfig will fall back to NC's lazy create on first web login. occ STDOUT: " & Left(_abCreateResult, 200) & ". ">
        </cfif>

        <cfif Len(_ncProvisionWarnings) GT 0>
            <cfset session.ncProvisionWarnings = _ncProvisionWarnings>
        </cfif>
    <cfcatch type="any">
        <cfset session.ncProvisionWarnings = "NC group/DAV provisioning threw: " & cfcatch.message & " / " & cfcatch.detail>
    </cfcatch>
    </cftry>
</cfif>

<!--- 4h. HERMES SYSTEM APP PASSWORD (#197 Phase 1).
     Mint a system app password (is_system=1, label "Hermes System").
     Used by NC Mail as the IMAP credential to talk to Dovecot — step
     4f below provisions an oc_mail_accounts row using this plaintext.
     The user never sees it; the welcome email does NOT carry it
     (welcome email under Phase 1 carries no credentials at all — see
     send_mailbox_welcome_email.cfm and the credential model doc).
     Hidden from the user portal via the is_system flag so users can't
     accidentally revoke it and break webmail.
     Applies to both local- and remote-auth mailboxes (both need a
     Dovecot-readable credential for NC Mail to authenticate IMAP). --->
<cfset initialAppPasswordPlain = "">
<cftry>
    <cfset _appPwAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789">
    <cfset _appPwLen = Len(_appPwAlphabet)>
    <cfset initialAppPasswordPlain = "">
    <cfloop from="1" to="30" index="_appPwIdx">
        <cfset initialAppPasswordPlain &= Mid(_appPwAlphabet, RandRange(1, _appPwLen, "SHA1PRNG"), 1)>
    </cfloop>

    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot doveadm pw -s ARGON2ID -p #initialAppPasswordPlain#"
        variable="initialAppPasswordHash"
        timeout="60" />
    <cfset initialAppPasswordHash = Trim(initialAppPasswordHash)>

    <cfif initialAppPasswordHash EQ "" OR NOT FindNoCase("{ARGON2ID}", initialAppPasswordHash)>
        <cfthrow message="doveadm pw returned unexpected output: #initialAppPasswordHash#">
    </cfif>

    <cfquery datasource="hermes">
        INSERT INTO app_passwords (username, label, password, is_system)
        VALUES (
            <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="Hermes System" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#initialAppPasswordHash#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="1" cfsqltype="cf_sql_tinyint">
        )
    </cfquery>
<cfcatch type="any">
    <!--- Non-fatal: mailbox creation succeeds even if app pw mint fails.
         Admin can mint manually from the per-mailbox app password page.
         Empty plain text disables NC Mail provisioning below. --->
    <cfset initialAppPasswordPlain = "">
</cfcatch>
</cftry>

<!--- 4f. NEXTCLOUD MAIL ACCOUNT. Create an email account in the Nextcloud
     Mail app so the user can send/receive through webmail. Uses Docker
     internal networking (IMAP: hermes_dovecot:143, SMTP:
     hermes_postfix_dkim:25, no TLS - traffic stays on Docker network).
     Password is the "Hermes System" app password minted in step 4h —
     NOT the org password (which Dovecot's lua passdb no longer accepts).
     Applies to both local- and remote-auth (drops the form.password
     check so remote-auth users now also get NC Mail provisioned). --->
<cfif form.nextcloud_enabled EQ "1" AND initialAppPasswordPlain NEQ "">
    <cftry>
        <cfset ncMailAction = "create">
        <cfset ncMailUser = recipientEmail>
        <cfset ncMailName = displayName>
        <cfset ncMailEmail = recipientEmail>
        <cfset ncMailPassword = initialAppPasswordPlain>
        <cfinclude template="nextcloud_mail_account.cfm">
    <cfcatch type="any">
        <!--- Non-fatal: mailbox works without webmail profile.
             Admin can troubleshoot via NC admin panel. --->
    </cfcatch>
    </cftry>
</cfif>

<!--- 5. SEND WELCOME EMAIL
     - Local auth: full welcome email with credentials section (admin
       set the password, which was communicated out-of-band).
     - Remote auth: minimal reference email (no credentials — admin
       handles username handoff, user uses their AD password). Useful
       as a client-settings + portal-URL reference after first login. --->
<cfset recipientName = displayName>
<cftry>
    <cfif form.auth_type EQ "remote">
        <!--- Pass the DAV app password generated during NC provisioning
             through to the welcome email. Only populated for remote-auth
             + NC-enabled; empty otherwise (welcome email skips the DAV
             block when empty). --->
        <cfset recipientAppPassword = (IsDefined("ncProvisionAppPassword")) ? ncProvisionAppPassword : "">
        <cfinclude template="send_mailbox_welcome_email_remoteauth.cfm">
    <cfelse>
        <cfinclude template="send_mailbox_welcome_email.cfm">
    </cfif>
<cfcatch type="any">
    <!--- Welcome email failure is non-critical --->
</cfcatch>
</cftry>

<!--- 6. CIPHERMAIL ENCRYPTION SETUP --->
<cfif form.pdf_enabled EQ "1" OR form.smime_enabled EQ "1" OR form.pgp_enabled EQ "1">
    <!--- Reuse relay recipient Ciphermail setup --->
    <cfset recipient = recipientEmail>
    <cfset show_pdf_enabled = form.pdf_enabled>
    <cfset show_smime_enabled = form.smime_enabled>
    <cfset show_pgp_enabled = form.pgp_enabled>
    <cfset show_sign = form.sign>
    <cfset djigzonotadded = 0>
    <cfset djigzonotaddedrecipient = "">
    <cfinclude template="add_internal_recipients_djigzo.cfm">
</cfif>

<!--- 7. QUEUE S/MIME CERTIFICATE GENERATION (background) --->
<cfif form.smime_enabled EQ "1" AND form.ca NEQ "">
    <cfquery name="getNewRecipientId" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getNewRecipientId.recordcount GTE 1>
        <cfquery name="existingSmimeCert" datasource="hermes">
            SELECT id FROM recipient_certificates
            WHERE user_id = <cfqueryparam value="#getNewRecipientId.id#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>
        <cfif existingSmimeCert.recordcount LT 1>
            <cfinclude template="generate_random_password.cfm">
            <cfquery datasource="hermes">
                INSERT INTO cert_generation_queue
                (recipient_id, recipient_email, job_type, ca_id, validity, encryption, algorithm, password)
                VALUES
                (<cfqueryparam value="#getNewRecipientId.id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                 'smime',
                 <cfqueryparam value="#form.ca#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.validity#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.cert_encryption#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.cert_algorithm#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<!--- 8. QUEUE PGP KEYRING GENERATION (background) --->
<cfif form.pgp_enabled EQ "1">
    <cfquery name="getNewRecipientId2" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getNewRecipientId2.recordcount GTE 1>
        <cfquery name="existingPgpKeyring" datasource="hermes">
            SELECT id FROM recipient_keystores
            WHERE user_id = <cfqueryparam value="#getNewRecipientId2.id#" cfsqltype="cf_sql_integer">
            AND master = '1'
            LIMIT 1
        </cfquery>
        <cfif existingPgpKeyring.recordcount LT 1>
            <cfinclude template="generate_random_password.cfm">
            <cfset pgpNameReal = ListFirst(recipientEmail, "@")>
            <cfquery datasource="hermes">
                INSERT INTO cert_generation_queue
                (recipient_id, recipient_email, job_type, pgp_key_length, pgp_name_real, password)
                VALUES
                (<cfqueryparam value="#getNewRecipientId2.id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                 'pgp',
                 <cfqueryparam value="#form.pgp_encryption#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#pgpNameReal#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<!--- SUCCESS --->
<cfset session.m = 1>
<cflocation url="view_mailboxes.cfm" addtoken="no">
