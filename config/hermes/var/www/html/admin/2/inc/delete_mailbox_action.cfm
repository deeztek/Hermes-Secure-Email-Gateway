
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
DELETE MAILBOX ACTION HANDLER
Removes a mailbox user from all systems:
1. Ciphermail (CLITool --delete-user + cert/keystore cleanup)
2. LDAP (remove from mailbox groups + delete user entry)
3. Cancel pending password reset requests
4. recipients table + related tables (wblist, mailaddr, recipients_temp)
5. user_settings table
6. recipient_certificates + files
7. recipient_keystores + PGP keys
8. cert_generation_queue (pending jobs)
9. mailboxes table (Dovecot userdb)
--->

<!--- VALIDATE MAILBOX ID --->
<cfif NOT StructKeyExists(form, "delete_mailbox_id") OR NOT IsNumeric(form.delete_mailbox_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- GET MAILBOX DETAILS --->
<cfquery name="getMailbox" datasource="hermes">
    SELECT m.id, m.username, m.domain_id
    FROM mailboxes m
    WHERE m.id = <cfqueryparam value="#form.delete_mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailbox.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset recipient = getMailbox.username>

<!--- GET RECIPIENT ID FROM RECIPIENTS TABLE --->
<cfquery name="getRecipientId" datasource="hermes">
    SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset delete_id = "">
<cfif getRecipientId.recordcount GTE 1>
    <cfset delete_id = getRecipientId.id>
</cfif>

<!--- 1. REMOVE FROM LDAP MAILBOX GROUPS FIRST --->
<!--- Must run BEFORE delete_internal_recipients.cfm because that include
     calls ldap_delete_user_relay.cfm (which removes from relay groups).
     We remove from mailbox groups here; the relay removal inside
     delete_internal_recipients.cfm will get "No such object" (harmless). --->
<cfquery name="getLdapUsernameForMailbox" datasource="hermes">
    SELECT ldap_username FROM user_settings WHERE email = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getLdapUsernameForMailbox.recordcount GTE 1 AND getLdapUsernameForMailbox.ldap_username NEQ "">
    <cftry>
        <cfset ldapUsername = getLdapUsernameForMailbox.ldap_username>
        <!--- Remove from cn=mailboxes group (ldap_delete_user_mailbox.cfm also
             deletes the user entry, but delete_internal_recipients.cfm will
             attempt it again via relay - "No such object" is handled gracefully) --->
        <cfinclude template="generate_customtrans.cfm">
        <cffile action="read" file="/opt/hermes/templates/ldap_removeusergroup_mailbox.ldif" variable="ldapRemoveGroupTemplate">
        <cfset ldapRemoveLdif = REReplace(ldapRemoveGroupTemplate, "THE_USERNAME", ldapUsername, "ALL")>
        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif"
            output="#ldapRemoveLdif#"
            addNewLine="no">
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -c -f /opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif"
            variable="ldapResult"
            errorVariable="ldapError"
            timeout="60">
        </cfexecute>
        <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif">
        <cfif fileExists(fileToDelete)>
            <cffile action="delete" file="#fileToDelete#">
        </cfif>

        <!--- Also remove from cn=nextcloud group (idempotent - the include
             handles "No such object" / "No such attribute" gracefully if
             the user wasn't in the group). --->
        <cftry>
            <cfinclude template="ldap_remove_user_groups_nextcloud.cfm">
        <cfcatch type="any"></cfcatch>
        </cftry>
    <cfcatch type="any">
        <!--- Mailbox group removal is non-critical - continue with deletion --->
    </cfcatch>
    </cftry>
</cfif>

<!--- 2. CIPHERMAIL + CERTS + KEYSTORES + LDAP USER DELETE + DB CLEANUP --->
<!--- Reuse the relay recipient delete include which handles:
     - Ciphermail CLITool --delete-user
     - Cert/keystore cleanup from djigzo DB
     - LDAP user delete (via ldap_delete_user_relay.cfm - will remove
       from relay groups if applicable, then delete user entry)
     - Cancel password reset requests
     - DELETE from recipients, recipients_temp, wblist, user_settings, mailaddr
     - DELETE cert files + PGP keystores --->
<cfif delete_id NEQ "">
    <cfinclude template="delete_internal_recipients.cfm">
<cfelse>
    <!--- No recipient row - still need basic cleanup --->
    <cfif getLdapUsernameForMailbox.recordcount GTE 1 AND getLdapUsernameForMailbox.ldap_username NEQ "">
        <cftry>
            <cfset ldapUsername = getLdapUsernameForMailbox.ldap_username>
            <cfinclude template="ldap_delete_user_mailbox.cfm">
        <cfcatch type="any">
            <!--- LDAP cleanup is non-critical --->
        </cfcatch>
        </cftry>
    </cfif>

    <cfquery datasource="hermes">
        UPDATE password_reset_requests
        SET status = 'cancelled', completed_at = NOW(), completed_by = 'system'
        WHERE email = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
        AND status = 'pending'
    </cfquery>

    <cfquery datasource="hermes">
        DELETE FROM user_settings WHERE email = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cfif>

<!--- 2. CANCEL PENDING CERT GENERATION JOBS --->
<cfif delete_id NEQ "">
    <cfquery datasource="hermes">
        DELETE FROM cert_generation_queue
        WHERE recipient_id = <cfqueryparam value="#delete_id#" cfsqltype="cf_sql_integer">
        AND status = 'pending'
    </cfquery>
</cfif>

<!--- 3. DELETE SENDER LOGIN MAPS (own address + any aliases) --->
<cfquery datasource="hermes">
    DELETE FROM sender_login_maps
    WHERE login_user = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- 4. DELETE MAILBOX ALIASES pointing to this mailbox --->
<cfquery datasource="hermes">
    DELETE FROM mailbox_aliases
    WHERE delivers_to = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- 4b. DELETE BCC MAP ENTRIES referencing this mailbox (as watched address
     OR as BCC destination). Postfix reads bcc_maps via MySQL lookup tables
     (mysql-*-bcc-maps.cf) so no postmap regeneration is required - lookups
     hit the live DB on every message. --->
<cfquery datasource="hermes">
    DELETE FROM bcc_maps
    WHERE address = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
       OR bcc_to  = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- 4c. INVALIDATE USER SESSIONS (force immediate logout) --->
<cftry>
    <cfset targetSessionUser = recipient>
    <cfinclude template="invalidate_user_sessions.cfm">
<cfcatch type="any"></cfcatch>
</cftry>

<!--- 4d. DELETE NEXTCLOUD APP PASSWORD ("Hermes System" token) --->
<cftry>
    <cfset ncAppPasswordAction = "delete">
    <cfset ncAppPasswordUser = recipient>
    <cfset ncAppPasswordValue = "">
    <cfinclude template="nextcloud_app_password.cfm">
<cfcatch type="any">
    <!--- Non-fatal --->
</cfcatch>
</cftry>

<!--- 4d. DELETE VACATION AUTO-REPLY config (one row per user) --->
<cfquery datasource="hermes">
    DELETE FROM user_vacation
    WHERE username = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- 5. DELETE USER SIEVE RULES + ON-DISK SCRIPT FILES.
     ON DELETE CASCADE on sieve_rule_conditions/sieve_rule_actions handles
     the child rows automatically when the parent sieve_rules row is deleted. --->
<cfquery datasource="hermes">
    DELETE FROM sieve_rules
    WHERE scope = 'user'
    AND username = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
</cfquery>

<cftry>
    <cfset sieveSrcFile = "/mnt/data/sieve/users/" & recipient & ".sieve">
    <cfset sieveBinFile = "/mnt/data/sieve/users/" & recipient & ".svbin">
    <cfif FileExists(sieveSrcFile)>
        <cffile action="delete" file="#sieveSrcFile#">
    </cfif>
    <cfif FileExists(sieveBinFile)>
        <cffile action="delete" file="#sieveBinFile#">
    </cfif>
<cfcatch type="any">
    <!--- File cleanup is non-critical --->
</cfcatch>
</cftry>

<!--- 6. DELETE FROM MAILBOXES TABLE (Dovecot userdb) --->
<cfquery datasource="hermes">
    DELETE FROM mailboxes WHERE id = <cfqueryparam value="#getMailbox.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- SUCCESS --->
<cfset session.m = 3>
<cflocation url="view_mailboxes.cfm" addtoken="no">
