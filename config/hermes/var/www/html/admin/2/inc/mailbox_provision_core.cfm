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
MAILBOX PROVISION CORE

Everything it takes to bring a mailbox into existence, lifted out of
add_mailbox_action.cfm so that more than one flow can provision a mailbox
without a second copy of these steps drifting away from the first:

1.  recipients        SVF policy, encryption flags, auth_type, recipient_type
1b. maddr             Amavis address tracking, required for the portal session
2.  user_settings     quarantine notifications, bayes, download, timezone
3.  mailboxes         Dovecot userdb row (username, quota, active)
3b. sender_login_maps lets the user send as their own address
4.  LDAP              user entry plus cn=mailboxes, Nextcloud group, NC user,
                      DAV resources, app passwords, NC Mail account
5.  welcome email
6.  Ciphermail        CLITool registration and encryption properties
7.  cert_generation_queue   S/MIME, queued for the background worker
8.  cert_generation_queue   PGP keyring, queued for the background worker

This file performs no validation and never redirects. The caller validates
first and decides what to do afterwards, which is what lets a bulk flow run
it in a loop.

Caller contract. Every variable add_mailbox_action.cfm had in scope at the
point this used to begin is required here, notably: form.* as documented in
add_mailbox_action.cfm, recipientEmail, displayName, quotaBytes, getDomain
(id, domain), customtrans* from generate_customtrans.cfm.

Optional:

  provisionMode       "create"  (default) the address is new, insert its rows
                      "convert" the address already exists as a relay
                                recipient, so work with what is there

  resolvedFirstName   from resolve_recipient_display_name.cfm, else NULL
  resolvedLastName    from resolve_recipient_display_name.cfm, else NULL
  ldapAccessControl   "one_factor" (default) or "two_factor"

Four steps differ between the two modes and no others, which is the entire
reason this file exists: recipients (update, not insert), user_settings
(update when the row is there, since email has no unique key), mailboxes
(carries the resolved names), and LDAP (change the role, never the
credential). Everything else is the same work in the same order.
--->

<cfparam name="provisionMode" default="create">

<!--- Filled in by resolve_recipient_display_name.cfm when the caller has run
     it. Left empty they write NULL, which is what the mailboxes columns held
     before anything populated them. --->
<cfparam name="resolvedFirstName" default="">
<cfparam name="resolvedLastName"  default="">

<!--- 1. RECIPIENTS TABLE.

     On convert the row is already there, put there by hand or by auto
     provisioning, and it is the row Postfix already accepts mail for. A
     second row for the same address would be ambiguous at best, so the
     existing one is updated in place and recipient_type carries it from
     relay to mailbox.

     The backend_* routing columns are deliberately not touched here. What a
     converted address should do about delivery is the caller's decision, not
     this file's: a mailbox on a relay domain needs an explicit override
     pointing at the built in server, because the domain's own transport
     points at the provider it is being moved away from. --->
<cfif provisionMode EQ "convert">
<cfquery name="insertRecipient" datasource="hermes" result="recipientResult">
    UPDATE recipients SET
      policy_id         = <cfqueryparam value="#form.policy#" cfsqltype="cf_sql_integer">,
      status            = 'OK',
      configured        = '2',
      pdf_enabled       = <cfqueryparam value="#form.pdf_enabled#" cfsqltype="cf_sql_varchar">,
      smime_enabled     = <cfqueryparam value="#form.smime_enabled#" cfsqltype="cf_sql_varchar">,
      pgp_enabled       = <cfqueryparam value="#form.pgp_enabled#" cfsqltype="cf_sql_varchar">,
      smime_mode        = '1',
      digital_sign      = <cfqueryparam value="#form.sign#" cfsqltype="cf_sql_varchar">,
      validity          = '1825',
      encryption        = '4096',
      algorithm         = 'sha512',
      auth_type         = <cfqueryparam value="#form.auth_type#" cfsqltype="cf_sql_varchar">,
      remoteauth_domain = <cfif form.remoteauth_domain NEQ ""><cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
      recipient_type    = 'mailbox',
      enforce_mfa       = <cfqueryparam value="#form.enforce_mfa#" cfsqltype="cf_sql_tinyint">
    WHERE recipient = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfelse>
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
</cfif>

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

<!--- 2. USER_SETTINGS TABLE.

     On convert the address may already have a row: add_internal_recipients_manual.cfm
     writes one when a relay recipient is added by hand, while auto provisioned
     recipients arrive without one. user_settings.email carries no unique key,
     so a plain insert would not fail on the first case, it would quietly leave
     two rows for one address and whichever the next reader picked would be a
     coin toss. Update when the row is there, insert when it is not. --->
<cfif provisionMode EQ "convert">
    <cfquery name="existingUserSettings" datasource="hermes">
        SELECT id FROM user_settings
        WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cfif>

<cfif provisionMode EQ "convert" AND existingUserSettings.recordcount GTE 1>
<cfquery name="insertUserSettings" datasource="hermes">
    UPDATE user_settings SET
      report_enabled = <cfqueryparam value="#form.reports#" cfsqltype="cf_sql_varchar">,
      train_bayes    = <cfqueryparam value="#form.train_bayes#" cfsqltype="cf_sql_varchar">,
      download_msg   = <cfqueryparam value="#form.download_msg#" cfsqltype="cf_sql_varchar">,
      timezone       = <cfqueryparam value="#trim(form.timezone)#" cfsqltype="cf_sql_varchar" null="#(NOT StructKeyExists(form, 'timezone') OR trim(form.timezone) IS '')#">
    WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfelse>
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
</cfif>

<!--- 3. INSERT INTO MAILBOXES TABLE (Dovecot userdb).
     enforce_mfa lives on recipients (see step 1 above), not mailboxes,
     because the same column drives both mailbox and relay flows. --->
<cfquery name="insertMailbox" datasource="hermes">
    INSERT INTO mailboxes
    (domain_id, username, name, first_name, last_name, quota, active,
     nextcloud_enabled, created, modified)
    VALUES
    (<cfqueryparam value="#getDomain.id#" cfsqltype="cf_sql_integer">,
     <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#displayName#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#Trim(resolvedFirstName)#" cfsqltype="cf_sql_varchar" null="#(Trim(resolvedFirstName) EQ '')#">,
     <cfqueryparam value="#Trim(resolvedLastName)#" cfsqltype="cf_sql_varchar" null="#(Trim(resolvedLastName) EQ '')#">,
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

<!--- 4. LDAP.

     On convert there is nothing to create and, above all, no password to set.
     The entry exists and carries a credential the user is already using: a
     remote auth recipient authenticates against the provider, and a local one
     has had an LDAP password since the relay recipient was added. So this
     changes the account's role and leaves the credential alone. Converting
     forty people must not reset forty passwords.

     ldap_add_user_mailbox.cfm would mostly cope, since ldap_add_user.cfm
     reports "Already exists" and declines to modify, but it would still shell
     out to slappasswd once per user to build a hash that nothing then uses.
     The four things that do need doing are done directly:

       1. leave cn=relays, or the account holds both roles at once
       2. join cn=mailboxes and the access control group
       3. replace displayName, which for a relay entry is the email local part
          followed by the literal word "User" and is what Authelia's OIDC name
          claim and Nextcloud both read
       4. record ldap_username on user_settings --->
<cfif provisionMode EQ "convert">

    <cfparam name="ldapAccessControl" type="string" default="one_factor">
    <cfif ldapAccessControl NEQ "one_factor" AND ldapAccessControl NEQ "two_factor">
        <cfset ldapAccessControl = "one_factor">
    </cfif>

    <cfset ldapUsername = LCase(recipientEmail)>

    <cfinclude template="ldap_remove_user_groups_relay.cfm">
    <cfinclude template="ldap_add_user_groups_mailbox.cfm">

    <cfif IsDefined("displayName") AND Len(Trim(displayName))>
        <cfset ldapDisplayName = Trim(displayName)>
        <cfinclude template="ldap_modify_user_displayname.cfm">
    </cfif>

    <cfquery name="convertLdapUsername" datasource="hermes">
        UPDATE user_settings
           SET ldap_username = <cfqueryparam value="#ldapUsername#" cfsqltype="cf_sql_varchar">
         WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfset ldapUserCreated = true>

<cfelseif form.auth_type EQ "remote">
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
    <!--- Welcome email failure is non-critical to provisioning: the mailbox
         works whether or not its owner was told about it, so this must not
         abort. It was silent as well as non-fatal though, which meant a
         welcome email that never arrived left nothing at all to look at, and
         the only way to tell the difference between "not sent" and "sent and
         lost in transit" was to guess. Record it and carry on. --->
    <cftry>
        <cffile action="append"
            file="/opt/hermes/tmp/welcome_email_errors.log"
            output="#DateTimeFormat(Now(), 'yyyy-mm-dd HH:nn:ss')# #recipientEmail# auth=#form.auth_type# #cfcatch.message# | #cfcatch.detail#"
            addnewline="yes"
            charset="utf-8">
    <cfcatch type="any"></cfcatch>
    </cftry>
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

<!--- #226 Phase 2B: refresh body milter map + sender_data so the new
     mailbox picks up domain-default Org Sig (or department Org Sig)
     immediately. Soft-fail if the body milter dirs aren't mounted on
     this host so add-mailbox stays usable in non-mail environments. --->
<cftry>
    <cfset signatureRegenSilent = true>
    <cfinclude template="signature_regen_map.cfm">
<cfcatch type="any"></cfcatch>
</cftry>

