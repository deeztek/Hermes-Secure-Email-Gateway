
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
SHARED MAILBOX ACTION HANDLER
Dispatches to the appropriate action based on form.action:
- add_shared_mailbox: Create a new shared mailbox
- delete_shared_mailbox: Remove a shared mailbox and all related data
- add_permission: Grant a user access to a shared mailbox
- remove_permission: Revoke a user's access to a shared mailbox
--->

<cfinclude template="generate_customtrans.cfm">

<!--- FEATURE GUARD: block creation/permission-add when sharing is disabled.
     Delete and remove-permission are allowed so admins can clean up. --->
<cfif action is "add_shared_mailbox" OR action is "add_permission" OR action is "edit_permission" OR action is "sync_all_acl_files">
    <cfquery name="checkSharingEnabledForAction" datasource="hermes">
        SELECT value2 FROM parameters2
        WHERE module = 'dovecot' AND parameter = 'sharing.enabled'
    </cfquery>
    <cfif checkSharingEnabledForAction.recordcount EQ 0 OR checkSharingEnabledForAction.value2 NEQ "yes">
        <cfset session.m = 31>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>
</cfif>

<!--- ====================================================================
     ADD SHARED MAILBOX
     ==================================================================== --->
<cfif action is "add_shared_mailbox">

    <!--- VALIDATE REQUIRED FIELDS --->
    <cfif NOT StructKeyExists(form, "address_prefix") OR trim(form.address_prefix) EQ "">
        <cfset session.m = 10>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "domain_id") OR NOT IsNumeric(form.domain_id)>
        <cfset session.m = 12>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- VALIDATE ADDRESS PREFIX FORMAT (alphanumeric + dots + hyphens + underscores) --->
    <cfset cleanPrefix = LCase(trim(form.address_prefix))>
    <cfif NOT REFind("^[a-z0-9._-]+$", cleanPrefix)>
        <cfset session.m = 11>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- VALIDATE DISPLAY NAME --->
    <cfparam name="form.display_name" default="">
    <cfset displayName = trim(form.display_name)>
    <cfif displayName EQ "">
        <cfset session.m = 15>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- LOOK UP THE DOMAIN --->
    <cfquery name="getDomain" datasource="hermes">
        SELECT id, domain FROM domains
        WHERE id = <cfqueryparam value="#form.domain_id#" cfsqltype="cf_sql_integer">
        AND type = 'mailbox'
    </cfquery>

    <cfif getDomain.recordcount LT 1>
        <cfset session.m = 12>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- CONSTRUCT FULL EMAIL ADDRESS --->
    <cfset sharedAddress = cleanPrefix & "@" & getDomain.domain>

    <!--- CHECK FOR DUPLICATE IN RECIPIENTS TABLE --->
    <cfquery name="checkRecipients" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkRecipients.recordcount GTE 1>
        <cfset session.m = 13>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- CHECK FOR DUPLICATE IN MAILBOXES TABLE --->
    <cfquery name="checkMailboxes" datasource="hermes">
        SELECT id FROM mailboxes WHERE username = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkMailboxes.recordcount GTE 1>
        <cfset session.m = 13>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- CHECK FOR DUPLICATE IN MAILBOX_ALIASES --->
    <cfquery name="checkAliases" datasource="hermes">
        SELECT id FROM mailbox_aliases WHERE alias_address = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkAliases.recordcount GTE 1>
        <cfset session.m = 13>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- CHECK FOR DUPLICATE IN VIRTUAL_RECIPIENTS --->
    <cfquery name="checkVirtual" datasource="hermes">
        SELECT id FROM virtual_recipients WHERE virtual_address = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkVirtual.recordcount GTE 1>
        <cfset session.m = 13>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- VALIDATE QUOTA --->
    <cfparam name="form.quota_gb" default="5">
    <cfif NOT IsNumeric(form.quota_gb) OR form.quota_gb LTE 0>
        <cfset session.m = 14>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>
    <cfset quotaBytes = Round(form.quota_gb * 1024 * 1024 * 1024)>

    <!--- VALIDATE AUTO SUBSCRIBE --->
    <cfparam name="form.auto_subscribe" default="1">
    <cfif form.auto_subscribe NEQ "0" AND form.auto_subscribe NEQ "1">
        <cfset form.auto_subscribe = 1>
    </cfif>

    <!--- ====================================================================
         ALL VALIDATION PASSED - BEGIN CREATION
         ==================================================================== --->
    <cftry>

        <!--- 1. INSERT INTO RECIPIENTS TABLE (Amavis SVF policy) --->
        <!--- Get default policy --->
        <cfquery name="getDefaultPolicy" datasource="hermes">
            SELECT policy_id FROM spam_policies WHERE default_policy = '1' LIMIT 1
        </cfquery>
        <cfset defaultPolicyId = getDefaultPolicy.policy_id>

        <cfquery name="insertRecipient" datasource="hermes" result="recipientResult">
            INSERT INTO recipients
            (policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled,
             smime_mode, digital_sign, validity, encryption, algorithm,
             auth_type, recipient_type)
            VALUES
            (<cfqueryparam value="#defaultPolicyId#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
             'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512',
             'local', 'shared')
        </cfquery>

        <!--- 1b. INSERT INTO MADDR TABLE (Amavis address tracking) --->
        <cfset domainParts = ListToArray(getDomain.domain, ".")>
        <cfset reversedDomain = ArrayReverse(domainParts)>
        <cfset maddrdomain = ArrayToList(reversedDomain, ".")>
        <cfquery datasource="hermes">
            INSERT IGNORE INTO maddr (partition_tag, email, domain)
            VALUES (
              0,
              <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#maddrdomain#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

        <!--- 2. INSERT INTO MAILBOXES TABLE (Dovecot userdb) --->
        <cfquery name="insertMailbox" datasource="hermes" result="mailboxResult">
            INSERT INTO mailboxes
            (domain_id, username, name, quota, active, mailbox_type, nextcloud_enabled, created, modified)
            VALUES
            (<cfqueryparam value="#getDomain.id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#displayName#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#quotaBytes#" cfsqltype="cf_sql_bigint">,
             1,
             'shared',
             0,
             NOW(),
             NOW())
        </cfquery>

        <!--- Get the mailbox ID we just inserted --->
        <cfset newMailboxId = mailboxResult.generatedKey>

        <!--- 3. INSERT INTO SHARED_MAILBOXES TABLE --->
        <cfquery datasource="hermes">
            INSERT INTO shared_mailboxes
            (mailbox_id, address, display_name, domain_id, auto_subscribe, created_at, modified_at)
            VALUES
            (<cfqueryparam value="#newMailboxId#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#displayName#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#getDomain.id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#form.auto_subscribe#" cfsqltype="cf_sql_tinyint">,
             NOW(),
             NOW())
        </cfquery>

        <!--- 4. INSERT INTO SENDER_LOGIN_MAPS (shared address with no login user initially) --->
        <!--- The shared address needs an entry so Postfix knows it's a valid sender.
             Members with send-as will be added as login_user entries separately. --->
        <cfquery datasource="hermes">
            INSERT IGNORE INTO sender_login_maps (sender, login_user)
            VALUES (
              <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

        <!--- 4b. BOOTSTRAP THE DOVECOT MAILDIR for the shared mailbox.
             Dovecot's shared namespace only surfaces mailboxes that exist on
             disk. New shared mailboxes have DB rows but no Maildir until mail
             is delivered or someone logs in as the shared address — neither of
             which happens automatically. Calling `doveadm mailbox create ...
             INBOX` pre-creates the physical mailbox structure so members with
             ACL rights can see it immediately in their IMAP clients. --->
        <cftry>
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec hermes_dovecot doveadm mailbox create -u #sharedAddress# INBOX"
                variable="doveadmCreateResult"
                errorVariable="doveadmCreateError"
                timeout="30" />
            <!--- Idempotent: doveadm returns non-zero if mailbox already exists,
                 which is fine — we just want to ensure it's there. --->
        <cfcatch type="any">
            <!--- Non-fatal: creation failure leaves DB rows intact; the
                 fallback (send an email to the shared address) will still
                 bootstrap the Maildir via LMTP. --->
        </cfcatch>
        </cftry>

        <!--- 5. GRANT DEFAULT PERMISSIONS TO INITIAL MEMBERS (if any were selected).
             Each selected member gets the same permission set chosen on the Add modal.
             Members must belong to the same domain as the shared mailbox. --->
        <cfparam name="form.initial_members" default="">
        <cfif Trim(form.initial_members) NEQ "">
            <!--- Parse default permission flags once --->
            <cfparam name="form.default_perm_read" default="0">
            <cfparam name="form.default_perm_write" default="0">
            <cfparam name="form.default_perm_delete" default="0">
            <cfparam name="form.default_perm_insert" default="0">
            <cfparam name="form.default_perm_post" default="0">
            <cfparam name="form.default_perm_admin" default="0">
            <cfparam name="form.default_perm_send_as" default="0">

            <cfset dpRead   = (form.default_perm_read EQ "1") ? 1 : 0>
            <cfset dpWrite  = (form.default_perm_write EQ "1") ? 1 : 0>
            <cfset dpDelete = (form.default_perm_delete EQ "1") ? 1 : 0>
            <cfset dpInsert = (form.default_perm_insert EQ "1") ? 1 : 0>
            <cfset dpPost   = (form.default_perm_post EQ "1") ? 1 : 0>
            <cfset dpAdmin  = (form.default_perm_admin EQ "1") ? 1 : 0>
            <cfset dpSendAs = (form.default_perm_send_as EQ "1") ? 1 : 0>

            <!--- Skip entirely if no permissions selected (nothing to grant) --->
            <cfif dpRead OR dpWrite OR dpDelete OR dpInsert OR dpPost OR dpAdmin OR dpSendAs>
                <cfloop list="#form.initial_members#" index="memberId">
                    <cfif IsNumeric(memberId)>
                        <!--- Validate member is an active user mailbox in the same domain --->
                        <cfquery name="getInitMember" datasource="hermes">
                            SELECT id, username FROM mailboxes
                            WHERE id = <cfqueryparam value="#memberId#" cfsqltype="cf_sql_integer">
                            AND domain_id = <cfqueryparam value="#getDomain.id#" cfsqltype="cf_sql_integer">
                            AND mailbox_type = 'user'
                            AND active = 1
                        </cfquery>

                        <cfif getInitMember.recordcount GTE 1>
                            <cfset initMemberName = getInitMember.username>

                            <!--- Look up the shared_mailbox row we just created --->
                            <cfquery name="getSharedId" datasource="hermes">
                                SELECT id FROM shared_mailboxes
                                WHERE mailbox_id = <cfqueryparam value="#newMailboxId#" cfsqltype="cf_sql_integer">
                            </cfquery>

                            <cfif getSharedId.recordcount GTE 1>
                                <cfquery datasource="hermes">
                                    INSERT INTO shared_mailbox_permissions
                                    (shared_mailbox_id, user_mailbox_id, username, can_read, can_write, can_delete, can_insert, can_post, can_admin, send_as, created_at)
                                    VALUES
                                    (<cfqueryparam value="#getSharedId.id#" cfsqltype="cf_sql_integer">,
                                     <cfqueryparam value="#getInitMember.id#" cfsqltype="cf_sql_integer">,
                                     <cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                     <cfqueryparam value="#dpRead#" cfsqltype="cf_sql_tinyint">,
                                     <cfqueryparam value="#dpWrite#" cfsqltype="cf_sql_tinyint">,
                                     <cfqueryparam value="#dpDelete#" cfsqltype="cf_sql_tinyint">,
                                     <cfqueryparam value="#dpInsert#" cfsqltype="cf_sql_tinyint">,
                                     <cfqueryparam value="#dpPost#" cfsqltype="cf_sql_tinyint">,
                                     <cfqueryparam value="#dpAdmin#" cfsqltype="cf_sql_tinyint">,
                                     <cfqueryparam value="#dpSendAs#" cfsqltype="cf_sql_tinyint">,
                                     NOW())
                                </cfquery>

                                <!--- Populate dovecot_acl rights matching the selected permissions.
                                     Mirrors the mapping used in the add_permission action. --->
                                <cfif dpRead EQ 1>
                                    <cfloop list="lookup,read,write-seen" index="rt">
                                        <cfquery datasource="hermes">
                                            INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                                            VALUES
                                            (<cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                             <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                             <cfqueryparam value="#rt#" cfsqltype="cf_sql_varchar">, 'yes')
                                        </cfquery>
                                    </cfloop>
                                </cfif>
                                <cfif dpWrite EQ 1>
                                    <cfloop list="write,write-deleted" index="rt">
                                        <cfquery datasource="hermes">
                                            INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                                            VALUES
                                            (<cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                             <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                             <cfqueryparam value="#rt#" cfsqltype="cf_sql_varchar">, 'yes')
                                        </cfquery>
                                    </cfloop>
                                </cfif>
                                <cfif dpDelete EQ 1>
                                    <cfquery datasource="hermes">
                                        INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                                        VALUES
                                        (<cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                         <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                         'expunge', 'yes')
                                    </cfquery>
                                </cfif>
                                <cfif dpInsert EQ 1>
                                    <cfquery datasource="hermes">
                                        INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                                        VALUES
                                        (<cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                         <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                         'insert', 'yes')
                                    </cfquery>
                                </cfif>
                                <cfif dpPost EQ 1>
                                    <cfquery datasource="hermes">
                                        INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                                        VALUES
                                        (<cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                         <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                         'post', 'yes')
                                    </cfquery>
                                </cfif>
                                <cfif dpAdmin EQ 1>
                                    <cfquery datasource="hermes">
                                        INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                                        VALUES
                                        (<cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                         <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                         'admin', 'yes')
                                    </cfquery>
                                </cfif>

                                <!--- Shared namespace visibility --->
                                <cfquery datasource="hermes">
                                    INSERT IGNORE INTO dovecot_acl_shared (from_user, to_user, dummy)
                                    VALUES (
                                      <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                      <cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">,
                                      ''
                                    )
                                </cfquery>

                                <!--- Send-As mapping --->
                                <cfif dpSendAs EQ 1>
                                    <cfquery datasource="hermes">
                                        INSERT IGNORE INTO sender_login_maps (sender, login_user)
                                        VALUES (
                                          <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                                          <cfqueryparam value="#initMemberName#" cfsqltype="cf_sql_varchar">
                                        )
                                    </cfquery>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>

        <!--- 6. SYNC DOVECOT-ACL FILE (Dovecot 2.4 vfile driver).
             Rebuilds /srv/mail/<domain>/<local>/dovecot-acl from the
             shared_mailbox_permissions rows inserted above. Safe to call
             even when no initial members were selected — produces an
             empty file, which gives no users explicit rights (owner
             still has implicit all rights). --->
        <cfinclude template="sync_shared_mailbox_acl_file.cfm">

        <!--- SUCCESS --->
        <cfset session.m = 1>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">

    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfcatch>
    </cftry>

<!--- ====================================================================
     DELETE SHARED MAILBOX
     ==================================================================== --->
<cfelseif action is "delete_shared_mailbox">

    <!--- VALIDATE SHARED MAILBOX ID --->
    <cfif NOT StructKeyExists(form, "shared_mailbox_id") OR NOT IsNumeric(form.shared_mailbox_id)>
        <cfset session.m = 20>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- GET SHARED MAILBOX DETAILS --->
    <cfquery name="getShared" datasource="hermes">
        SELECT sm.id, sm.mailbox_id, sm.address, sm.domain_id,
               d.domain
        FROM shared_mailboxes sm
        INNER JOIN domains d ON d.id = sm.domain_id
        WHERE sm.id = <cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif getShared.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <cfset sharedAddress = getShared.address>
    <cfset sharedMailboxId = getShared.mailbox_id>

    <cftry>

        <!--- 1. DELETE ALL PERMISSIONS --->
        <cfquery datasource="hermes">
            DELETE FROM shared_mailbox_permissions
            WHERE shared_mailbox_id = <cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- 2. DELETE FROM SHARED_MAILBOXES --->
        <cfquery datasource="hermes">
            DELETE FROM shared_mailboxes
            WHERE id = <cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- 3. DELETE FROM DOVECOT_ACL (all entries for this shared mailbox) --->
        <cfquery datasource="hermes">
            DELETE FROM dovecot_acl
            WHERE mailbox = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- 4. DELETE FROM DOVECOT_ACL_SHARED (all sharing records for this shared mailbox) --->
        <cfquery datasource="hermes">
            DELETE FROM dovecot_acl_shared
            WHERE from_user = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- 5. DELETE FROM SENDER_LOGIN_MAPS --->
        <cfquery datasource="hermes">
            DELETE FROM sender_login_maps
            WHERE sender = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- 6. DELETE FROM RECIPIENTS --->
        <cfquery datasource="hermes">
            DELETE FROM recipients
            WHERE recipient = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- 7. DELETE FROM MAILBOXES --->
        <cfquery datasource="hermes">
            DELETE FROM mailboxes
            WHERE id = <cfqueryparam value="#sharedMailboxId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- 8. DELETE MAILDIR FILES from Dovecot container --->
        <cfparam name="form.delete_maildir" default="0">
        <cfif form.delete_maildir EQ "1">
            <cftry>
                <cfset mailDomain = ListLast(sharedAddress, "@")>
                <cfset mailLocal = ListFirst(sharedAddress, "@")>
                <cfset mailDirPath = "/srv/mail/" & mailDomain & "/" & mailLocal>
                <cfexecute name="/usr/local/bin/docker"
                    arguments="exec hermes_dovecot rm -rf #mailDirPath#"
                    variable="rmResult"
                    errorVariable="rmError"
                    timeout="30" />
            <cfcatch type="any">
                <!--- Maildir deletion is non-critical --->
            </cfcatch>
            </cftry>
        </cfif>

        <!--- SUCCESS --->
        <cfset session.m = 2>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">

    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfcatch>
    </cftry>

<!--- ====================================================================
     ADD PERMISSION
     ==================================================================== --->
<cfelseif action is "add_permission">

    <!--- VALIDATE SHARED MAILBOX ID --->
    <cfif NOT StructKeyExists(form, "shared_mailbox_id") OR NOT IsNumeric(form.shared_mailbox_id)>
        <cfset session.m = 20>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- VALIDATE USER MAILBOX ID --->
    <cfif NOT StructKeyExists(form, "user_mailbox_id") OR NOT IsNumeric(form.user_mailbox_id)>
        <cfset session.m = 22>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- GET SHARED MAILBOX DETAILS --->
    <cfquery name="getShared" datasource="hermes">
        SELECT sm.id, sm.mailbox_id, sm.address, sm.domain_id
        FROM shared_mailboxes sm
        WHERE sm.id = <cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif getShared.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- GET USER MAILBOX DETAILS --->
    <cfquery name="getUserMailbox" datasource="hermes">
        SELECT m.id, m.username, m.domain_id
        FROM mailboxes m
        WHERE m.id = <cfqueryparam value="#form.user_mailbox_id#" cfsqltype="cf_sql_integer">
        AND m.mailbox_type = 'user'
        AND m.active = 1
    </cfquery>

    <cfif getUserMailbox.recordcount LT 1>
        <cfset session.m = 22>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- ENFORCE SAME-DOMAIN RULE (matches Add Shared Mailbox initial-member logic).
         Cross-domain sharing isn't supported — the Dovecot shared namespace
         query in acl_sharing_map looks up by username, not by domain, but the
         UX contract is that members belong to the same domain as the shared
         mailbox. Server-side check guards against stale/forged form posts. --->
    <cfif getUserMailbox.domain_id NEQ getShared.domain_id>
        <cfset session.m = 26>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- CHECK FOR DUPLICATE PERMISSION --->
    <cfquery name="checkDuplicatePerm" datasource="hermes">
        SELECT id FROM shared_mailbox_permissions
        WHERE shared_mailbox_id = <cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">
        AND user_mailbox_id = <cfqueryparam value="#form.user_mailbox_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif checkDuplicatePerm.recordcount GTE 1>
        <cfset session.m = 23>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- PARSE PERMISSION CHECKBOXES --->
    <cfparam name="form.perm_read" default="0">
    <cfparam name="form.perm_write" default="0">
    <cfparam name="form.perm_delete" default="0">
    <cfparam name="form.perm_insert" default="0">
    <cfparam name="form.perm_post" default="0">
    <cfparam name="form.perm_admin" default="0">
    <cfparam name="form.perm_send_as" default="0">

    <cfset canRead = (form.perm_read EQ "1") ? 1 : 0>
    <cfset canWrite = (form.perm_write EQ "1") ? 1 : 0>
    <cfset canDelete = (form.perm_delete EQ "1") ? 1 : 0>
    <cfset canInsert = (form.perm_insert EQ "1") ? 1 : 0>
    <cfset canPost = (form.perm_post EQ "1") ? 1 : 0>
    <cfset canAdmin = (form.perm_admin EQ "1") ? 1 : 0>
    <cfset sendAs = (form.perm_send_as EQ "1") ? 1 : 0>

    <!--- At least one permission must be selected --->
    <cfif canRead EQ 0 AND canWrite EQ 0 AND canDelete EQ 0 AND canInsert EQ 0 AND canPost EQ 0 AND canAdmin EQ 0 AND sendAs EQ 0>
        <cfset session.m = 25>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <cfset sharedAddress = getShared.address>
    <cfset grantedUser = getUserMailbox.username>

    <cftry>

        <!--- 1. INSERT INTO SHARED_MAILBOX_PERMISSIONS --->
        <cfquery datasource="hermes">
            INSERT INTO shared_mailbox_permissions
            (shared_mailbox_id, user_mailbox_id, username, can_read, can_write, can_delete, can_insert, can_post, can_admin, send_as, created_at)
            VALUES
            (<cfqueryparam value="#form.shared_mailbox_id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#form.user_mailbox_id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#canRead#" cfsqltype="cf_sql_tinyint">,
             <cfqueryparam value="#canWrite#" cfsqltype="cf_sql_tinyint">,
             <cfqueryparam value="#canDelete#" cfsqltype="cf_sql_tinyint">,
             <cfqueryparam value="#canInsert#" cfsqltype="cf_sql_tinyint">,
             <cfqueryparam value="#canPost#" cfsqltype="cf_sql_tinyint">,
             <cfqueryparam value="#canAdmin#" cfsqltype="cf_sql_tinyint">,
             <cfqueryparam value="#sendAs#" cfsqltype="cf_sql_tinyint">,
             NOW())
        </cfquery>

        <!--- 2. POPULATE DOVECOT_ACL with appropriate rights --->
        <!--- can_read: lookup, read, write-seen --->
        <cfif canRead EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'lookup', 'yes')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'read', 'yes')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'write-seen', 'yes')
            </cfquery>
        </cfif>

        <!--- can_write: write, write-deleted --->
        <cfif canWrite EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'write', 'yes')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'write-deleted', 'yes')
            </cfquery>
        </cfif>

        <!--- can_delete: expunge --->
        <cfif canDelete EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'expunge', 'yes')
            </cfquery>
        </cfif>

        <!--- can_insert: insert --->
        <cfif canInsert EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'insert', 'yes')
            </cfquery>
        </cfif>

        <!--- can_post: post --->
        <cfif canPost EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'post', 'yes')
            </cfquery>
        </cfif>

        <!--- can_admin: admin --->
        <cfif canAdmin EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                 'admin', 'yes')
            </cfquery>
        </cfif>

        <!--- 3. INSERT INTO DOVECOT_ACL_SHARED (sharing record) --->
        <cfquery datasource="hermes">
            INSERT IGNORE INTO dovecot_acl_shared (from_user, to_user, dummy)
            VALUES (
              <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
              ''
            )
        </cfquery>

        <!--- 4. INSERT SENDER_LOGIN_MAPS (if send-as enabled) --->
        <cfif sendAs EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO sender_login_maps (sender, login_user)
                VALUES (
                  <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
        </cfif>

        <!--- 5. SYNC DOVECOT-ACL FILE (Dovecot 2.4 vfile driver) --->
        <cfinclude template="sync_shared_mailbox_acl_file.cfm">

        <!--- SUCCESS --->
        <cfset session.m = 3>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">

    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfcatch>
    </cftry>

<!--- ====================================================================
     EDIT PERMISSION (update existing member's rights in place)
     ==================================================================== --->
<cfelseif action is "edit_permission">

    <!--- VALIDATE PERMISSION ID --->
    <cfif NOT StructKeyExists(form, "permission_id") OR NOT IsNumeric(form.permission_id)>
        <cfset session.m = 24>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- GET EXISTING PERMISSION ROW --->
    <cfquery name="getPermEdit" datasource="hermes">
        SELECT smp.id, smp.shared_mailbox_id, smp.user_mailbox_id,
               smp.username, smp.send_as,
               sm.address AS shared_address
        FROM shared_mailbox_permissions smp
        INNER JOIN shared_mailboxes sm ON sm.id = smp.shared_mailbox_id
        WHERE smp.id = <cfqueryparam value="#form.permission_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif getPermEdit.recordcount LT 1>
        <cfset session.m = 24>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- PARSE PERMISSION CHECKBOXES --->
    <cfparam name="form.perm_read" default="0">
    <cfparam name="form.perm_write" default="0">
    <cfparam name="form.perm_delete" default="0">
    <cfparam name="form.perm_insert" default="0">
    <cfparam name="form.perm_post" default="0">
    <cfparam name="form.perm_admin" default="0">
    <cfparam name="form.perm_send_as" default="0">

    <cfset canRead   = (form.perm_read EQ "1") ? 1 : 0>
    <cfset canWrite  = (form.perm_write EQ "1") ? 1 : 0>
    <cfset canDelete = (form.perm_delete EQ "1") ? 1 : 0>
    <cfset canInsert = (form.perm_insert EQ "1") ? 1 : 0>
    <cfset canPost   = (form.perm_post EQ "1") ? 1 : 0>
    <cfset canAdmin  = (form.perm_admin EQ "1") ? 1 : 0>
    <cfset sendAs    = (form.perm_send_as EQ "1") ? 1 : 0>

    <cfif canRead EQ 0 AND canWrite EQ 0 AND canDelete EQ 0 AND canInsert EQ 0 AND canPost EQ 0 AND canAdmin EQ 0 AND sendAs EQ 0>
        <cfset session.m = 25>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <cfset sharedAddress = getPermEdit.shared_address>
    <cfset grantedUser = getPermEdit.username>
    <cfset oldSendAs = getPermEdit.send_as>

    <cftry>
        <!--- 1. UPDATE shared_mailbox_permissions --->
        <cfquery datasource="hermes">
            UPDATE shared_mailbox_permissions
            SET can_read   = <cfqueryparam value="#canRead#"   cfsqltype="cf_sql_tinyint">,
                can_write  = <cfqueryparam value="#canWrite#"  cfsqltype="cf_sql_tinyint">,
                can_delete = <cfqueryparam value="#canDelete#" cfsqltype="cf_sql_tinyint">,
                can_insert = <cfqueryparam value="#canInsert#" cfsqltype="cf_sql_tinyint">,
                can_post   = <cfqueryparam value="#canPost#"   cfsqltype="cf_sql_tinyint">,
                can_admin  = <cfqueryparam value="#canAdmin#"  cfsqltype="cf_sql_tinyint">,
                send_as    = <cfqueryparam value="#sendAs#"    cfsqltype="cf_sql_tinyint">
            WHERE id = <cfqueryparam value="#form.permission_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- 2. REWRITE dovecot_acl rows (dead in 2.4 but keep for consistency).
             Simplest correct approach: delete all, re-insert per the new flags. --->
        <cfquery datasource="hermes">
            DELETE FROM dovecot_acl
            WHERE username = <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">
            AND mailbox = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif canRead EQ 1>
            <cfloop list="lookup,read,write-seen" index="rt">
                <cfquery datasource="hermes">
                    INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                    VALUES (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#rt#" cfsqltype="cf_sql_varchar">, 'yes')
                </cfquery>
            </cfloop>
        </cfif>
        <cfif canWrite EQ 1>
            <cfloop list="write,write-deleted" index="rt">
                <cfquery datasource="hermes">
                    INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                    VALUES (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#rt#" cfsqltype="cf_sql_varchar">, 'yes')
                </cfquery>
            </cfloop>
        </cfif>
        <cfif canDelete EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                        'expunge', 'yes')
            </cfquery>
        </cfif>
        <cfif canInsert EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                        'insert', 'yes')
            </cfquery>
        </cfif>
        <cfif canPost EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                        'post', 'yes')
            </cfquery>
        </cfif>
        <cfif canAdmin EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES (<cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                        'admin', 'yes')
            </cfquery>
        </cfif>

        <!--- 3. SYNC sender_login_maps based on new send_as flag.
             Toggle each direction independently so the change to
             send-as is reflected without touching unrelated maps. --->
        <cfif sendAs EQ 1 AND oldSendAs NEQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO sender_login_maps (sender, login_user)
                VALUES (<cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">)
            </cfquery>
        <cfelseif sendAs EQ 0 AND oldSendAs EQ 1>
            <cfquery datasource="hermes">
                DELETE FROM sender_login_maps
                WHERE sender = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
                AND login_user = <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>

        <!--- 4. SYNC DOVECOT-ACL FILE (Dovecot 2.4 vfile driver) --->
        <cfinclude template="sync_shared_mailbox_acl_file.cfm">

        <cfset session.m = 6>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">

    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfcatch>
    </cftry>

<!--- ====================================================================
     REMOVE PERMISSION
     ==================================================================== --->
<cfelseif action is "remove_permission">

    <!--- VALIDATE PERMISSION ID --->
    <cfif NOT StructKeyExists(form, "permission_id") OR NOT IsNumeric(form.permission_id)>
        <cfset session.m = 20>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <!--- GET PERMISSION DETAILS --->
    <cfquery name="getPerm" datasource="hermes">
        SELECT smp.id, smp.shared_mailbox_id, smp.user_mailbox_id, smp.username, smp.send_as,
               sm.address AS shared_address
        FROM shared_mailbox_permissions smp
        INNER JOIN shared_mailboxes sm ON sm.id = smp.shared_mailbox_id
        WHERE smp.id = <cfqueryparam value="#form.permission_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif getPerm.recordcount LT 1>
        <cfset session.m = 24>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfif>

    <cfset sharedAddress = getPerm.shared_address>
    <cfset grantedUser = getPerm.username>

    <cftry>

        <!--- 1. DELETE FROM SHARED_MAILBOX_PERMISSIONS --->
        <cfquery datasource="hermes">
            DELETE FROM shared_mailbox_permissions
            WHERE id = <cfqueryparam value="#form.permission_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- 2. DELETE FROM DOVECOT_ACL (all rights for this user on this mailbox) --->
        <cfquery datasource="hermes">
            DELETE FROM dovecot_acl
            WHERE username = <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">
            AND mailbox = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- 3. DELETE FROM DOVECOT_ACL_SHARED --->
        <cfquery datasource="hermes">
            DELETE FROM dovecot_acl_shared
            WHERE from_user = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
            AND to_user = <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- 4. DELETE SENDER_LOGIN_MAPS (if send-as was enabled) --->
        <cfif getPerm.send_as EQ 1>
            <cfquery datasource="hermes">
                DELETE FROM sender_login_maps
                WHERE sender = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
                AND login_user = <cfqueryparam value="#grantedUser#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>

        <!--- 5. SYNC DOVECOT-ACL FILE (Dovecot 2.4 vfile driver) --->
        <cfinclude template="sync_shared_mailbox_acl_file.cfm">

        <!--- SUCCESS --->
        <cfset session.m = 4>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">

    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="view_shared_mailboxes.cfm" addtoken="no">
    </cfcatch>
    </cftry>

<!--- ====================================================================
     SYNC ALL ACL FILES (one-shot migration / healing)
     Iterates BOTH admin-managed shared mailboxes AND user-managed
     folder shares and rebuilds each one's vfile dovecot-acl file from
     the DB. Used to backfill files after the 2.3→2.4 driver change, or
     to heal drift if a sync previously failed.
     ==================================================================== --->
<cfelseif action is "sync_all_acl_files">

    <!--- Pass 1: admin-managed shared mailboxes --->
    <cfquery name="getAllShared" datasource="hermes">
        SELECT address FROM shared_mailboxes ORDER BY address ASC
    </cfquery>

    <cfset aclSyncedCount = 0>
    <cfloop query="getAllShared">
        <cfset sharedAddress = getAllShared.address>
        <cftry>
            <cfinclude template="sync_shared_mailbox_acl_file.cfm">
            <cfset aclSyncedCount = aclSyncedCount + 1>
        <cfcatch type="any">
            <!--- Per-mailbox failure is non-fatal; continue with the rest --->
        </cfcatch>
        </cftry>
    </cfloop>

    <!--- Pass 2: user-managed folder shares. Distinct (owner, folder)
         pairs — multiple recipients of the same folder all share one
         vfile dovecot-acl file, so one sync call per pair is enough. --->
    <cfquery name="getAllUserFolderShares" datasource="hermes">
        SELECT DISTINCT owner_username, folder_path
        FROM user_folder_shares
        ORDER BY owner_username, folder_path
    </cfquery>

    <cfset userFolderSyncedCount = 0>
    <cfloop query="getAllUserFolderShares">
        <cfset ownerUser  = getAllUserFolderShares.owner_username>
        <cfset folderPath = getAllUserFolderShares.folder_path>
        <cftry>
            <cfinclude template="sync_user_folder_acl_file.cfm">
            <cfset userFolderSyncedCount = userFolderSyncedCount + 1>
        <cfcatch type="any">
            <!--- Per-folder failure is non-fatal; continue --->
        </cfcatch>
        </cftry>
    </cfloop>

    <cfset session.m = 5>
    <cfset session.acl_synced_count = aclSyncedCount>
    <cfset session.user_folder_synced_count = userFolderSyncedCount>
    <cflocation url="view_shared_mailboxes.cfm" addtoken="no">

</cfif>
