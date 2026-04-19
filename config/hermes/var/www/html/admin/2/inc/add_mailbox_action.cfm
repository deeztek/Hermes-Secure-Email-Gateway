
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
     auth_type, remoteauth_domain, recipient_type)
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
     'mailbox')
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

<!--- 3. INSERT INTO MAILBOXES TABLE (Dovecot userdb) --->
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

<!--- 4c. NEXTCLOUD PRE-PROVISION USER. Create a local NC user with the same
     password as the mailbox. DAV auth (CalDAV/CardDAV) works with the
     email password directly — no app passwords needed. When the user
     logs in via OIDC, user_oidc takes over the existing account
     (soft_auto_provision=true). --->
<cfif form.nextcloud_enabled EQ "1">
    <cftry>
        <cfset ncProvisionAction = "create">
        <cfset ncProvisionUser = recipientEmail>
        <cfset ncProvisionDisplayName = displayName>
        <cfset ncProvisionEmail = recipientEmail>
        <cfset ncProvisionPassword = trim(form.password)>
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

<!--- 4d. NEXTCLOUD DOMAIN GROUP. Add the user to the NC group for their
     domain (e.g., deeztek.com). The group was created when the mailbox
     domain was added. --->
<cfif form.nextcloud_enabled EQ "1">
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ group:adduser #getDomain.domain# #recipientEmail#"
            variable="ncGroupAddResult"
            errorVariable="ncGroupAddError"
            timeout="30" />
    <cfcatch type="any">
        <!--- Non-fatal --->
    </cfcatch>
    </cftry>
</cfif>

<!--- 4e. (App password removed — DAV auth uses the local NC password
     created in step 4c via occ user:add. No separate app password needed.) --->

<!--- 4f. NEXTCLOUD MAIL ACCOUNT. Create an email account in the Nextcloud
     Mail app so the user can send/receive through webmail. Uses Docker
     internal networking (IMAP: hermes_dovecot:143, SMTP:
     hermes_postfix_dkim:25, no TLS - traffic stays on Docker network). --->
<cfif form.nextcloud_enabled EQ "1" AND trim(form.password) NEQ "">
    <cftry>
        <cfset ncMailAction = "create">
        <cfset ncMailUser = recipientEmail>
        <cfset ncMailName = displayName>
        <cfset ncMailEmail = recipientEmail>
        <cfset ncMailPassword = trim(form.password)>
        <cfinclude template="nextcloud_mail_account.cfm">
    <cfcatch type="any">
        <!--- Non-fatal: mailbox works without webmail profile.
             Admin can troubleshoot via NC admin panel. --->
    </cfcatch>
    </cftry>
</cfif>

<!--- 5. SEND WELCOME EMAIL --->
<cfset recipientName = displayName>
<cftry>
    <cfif form.auth_type EQ "remote">
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
