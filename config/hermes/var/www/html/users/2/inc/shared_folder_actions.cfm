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

<!--- FEATURE GUARD: block creation of new shares when sharing is disabled.
     unshare_folder is allowed so users can clean up existing shares. --->
<cfif form.action EQ "share_folder">
    <cfquery name="checkSharingEnabledForAction" datasource="hermes">
        SELECT value2 FROM parameters2
        WHERE module = 'dovecot' AND parameter = 'sharing.enabled'
    </cfquery>
    <cfif checkSharingEnabledForAction.recordcount EQ 0 OR checkSharingEnabledForAction.value2 NEQ "yes">
        <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Folder sharing is currently disabled. Please contact your administrator.">
        <cfset session.sfMessageType = "danger">
        <cflocation url="view_shared_folders.cfm" addtoken="no">
    </cfif>
</cfif>

<!--- SHARE FOLDER ACTION --->
<cfif form.action EQ "share_folder">
    <cftry>

        <!--- Validate folder_path --->
        <cfif NOT StructKeyExists(form, "folder_path") OR Trim(form.folder_path) EQ "">
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Folder path cannot be blank.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <!--- Validate shared_with_username --->
        <cfif NOT StructKeyExists(form, "shared_with_username") OR Trim(form.shared_with_username) EQ "">
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>You must select a user to share with.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <cfset folderPath = Trim(form.folder_path)>
        <cfset sharedWith = Trim(form.shared_with_username)>

        <!--- Cannot share with yourself --->
        <cfif sharedWith EQ session.email>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>You cannot share a folder with yourself.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <!--- Validate shared_with user exists in same domain, is active mailbox --->
        <cfquery name="getOwnerDomain" datasource="hermes">
            SELECT domain_id FROM mailboxes
            WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
            AND mailbox_type = 'user' AND active = 1
        </cfquery>

        <cfif getOwnerDomain.recordcount EQ 0>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Your mailbox could not be found.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <cfquery name="validateTarget" datasource="hermes">
            SELECT id, username FROM mailboxes
            WHERE username = <cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">
            AND domain_id = <cfqueryparam value="#getOwnerDomain.domain_id#" cfsqltype="cf_sql_integer">
            AND mailbox_type = 'user' AND active = 1
        </cfquery>

        <cfif validateTarget.recordcount EQ 0>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The selected user is not a valid mailbox user in your domain.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <!--- Get permission checkboxes (default: read only) --->
        <cfparam name="form.can_read" default="0">
        <cfparam name="form.can_write" default="0">
        <cfparam name="form.can_delete" default="0">

        <cfset canRead = (form.can_read EQ "1") ? 1 : 0>
        <cfset canWrite = (form.can_write EQ "1") ? 1 : 0>
        <cfset canDelete = (form.can_delete EQ "1") ? 1 : 0>
        <!--- can_insert follows can_write --->
        <cfset canInsert = canWrite>

        <!--- At least read must be granted --->
        <cfif canRead EQ 0 AND canWrite EQ 0 AND canDelete EQ 0>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>You must grant at least one permission (Read is required).">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <!--- Insert into user_folder_shares --->
        <cfquery datasource="hermes">
            INSERT INTO user_folder_shares (owner_username, shared_with_username, folder_path, can_read, can_write, can_delete, can_insert)
            VALUES (
                <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#folderPath#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#canRead#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#canWrite#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#canDelete#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#canInsert#" cfsqltype="cf_sql_integer">
            )
        </cfquery>

        <!--- Build the Dovecot ACL mailbox identifier: owner's shared namespace --->
        <!--- Dovecot uses "user/owner/folder" format for shared namespace --->
        <cfset aclMailbox = folderPath>

        <!--- Populate dovecot_acl rights --->
        <!--- can_read: lookup, read, write-seen --->
        <cfif canRead EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'lookup', '1')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'read', '1')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'write-seen', '1')
            </cfquery>
        </cfif>

        <!--- can_write: write, write-deleted, insert --->
        <cfif canWrite EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'write', '1')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'write-deleted', '1')
            </cfquery>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'insert', '1')
            </cfquery>
        </cfif>

        <!--- can_delete: expunge --->
        <cfif canDelete EQ 1>
            <cfquery datasource="hermes">
                INSERT IGNORE INTO dovecot_acl (username, mailbox, right_name, value)
                VALUES
                (<cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">,
                 'expunge', '1')
            </cfquery>
        </cfif>

        <!--- Insert into dovecot_acl_shared (enables shared namespace visibility) --->
        <cfquery datasource="hermes">
            INSERT IGNORE INTO dovecot_acl_shared (from_user, to_user, dummy)
            VALUES (
                <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">,
                '1'
            )
        </cfquery>

        <!--- Write the per-folder vfile dovecot-acl file. Dovecot 2.4 only
             enforces rights via these files; the dovecot_acl SQL rows
             above are dead data in 2.4 (kept for audit / back-compat). --->
        <cfset ownerUser = session.email>
        <cfinclude template="sync_user_folder_acl_file.cfm">

        <cfset session.sfMessage = "<h4><i class='icon fa fa-check'></i> Success!</h4>Folder shared successfully with #encodeForHTML(sharedWith)#.">
        <cfset session.sfMessageType = "success">
        <cflocation url="view_shared_folders.cfm" addtoken="no">

    <cfcatch type="any">
        <!--- Check for duplicate key --->
        <cfif cfcatch.message CONTAINS "Duplicate" OR cfcatch.detail CONTAINS "Duplicate">
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>This folder is already shared with that user.">
            <cfset session.sfMessageType = "danger">
        <cfelse>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>An error occurred while sharing the folder. Please try again.">
            <cfset session.sfMessageType = "danger">
        </cfif>
        <cflocation url="view_shared_folders.cfm" addtoken="no">
    </cfcatch>
    </cftry>
</cfif>

<!--- UNSHARE FOLDER ACTION --->
<cfif form.action EQ "unshare_folder">
    <cftry>

        <!--- Validate share_id --->
        <cfif NOT StructKeyExists(form, "share_id") OR NOT IsValid("integer", form.share_id)>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Invalid share ID.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <!--- Get the share record and verify ownership --->
        <cfquery name="getShare" datasource="hermes">
            SELECT id, owner_username, shared_with_username, folder_path
            FROM user_folder_shares
            WHERE id = <cfqueryparam value="#form.share_id#" cfsqltype="cf_sql_integer">
            AND owner_username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif getShare.recordcount EQ 0>
            <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Share not found or you do not have permission to revoke it.">
            <cfset session.sfMessageType = "danger">
            <cflocation url="view_shared_folders.cfm" addtoken="no">
        </cfif>

        <cfset aclMailbox = getShare.folder_path>
        <cfset sharedWith = getShare.shared_with_username>

        <!--- Delete from user_folder_shares --->
        <cfquery datasource="hermes">
            DELETE FROM user_folder_shares
            WHERE id = <cfqueryparam value="#form.share_id#" cfsqltype="cf_sql_integer">
            AND owner_username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- Delete from dovecot_acl for this user+mailbox combination --->
        <cfquery datasource="hermes">
            DELETE FROM dovecot_acl
            WHERE username = <cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">
            AND mailbox = <cfqueryparam value="#session.email#/#aclMailbox#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- Check if there are any remaining shares from this owner to this user --->
        <cfquery name="checkRemainingShares" datasource="hermes">
            SELECT COUNT(*) AS cnt FROM user_folder_shares
            WHERE owner_username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
            AND shared_with_username = <cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- Only remove dovecot_acl_shared if no more folders shared with this user --->
        <cfif checkRemainingShares.cnt EQ 0>
            <cfquery datasource="hermes">
                DELETE FROM dovecot_acl_shared
                WHERE from_user = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
                AND to_user = <cfqueryparam value="#sharedWith#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>

        <!--- Rebuild the per-folder dovecot-acl file without the removed
             share. After the DELETE above the sync will either shrink
             the file to the remaining shares or produce an empty file
             (which denies everyone except the owner). --->
        <cfset ownerUser = session.email>
        <cfset folderPath = getShare.folder_path>
        <cfinclude template="sync_user_folder_acl_file.cfm">

        <cfset session.sfMessage = "<h4><i class='icon fa fa-check'></i> Success!</h4>Folder share revoked successfully.">
        <cfset session.sfMessageType = "success">
        <cflocation url="view_shared_folders.cfm" addtoken="no">

    <cfcatch type="any">
        <cfset session.sfMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>An error occurred while revoking the share. Please try again.">
        <cfset session.sfMessageType = "danger">
        <cflocation url="view_shared_folders.cfm" addtoken="no">
    </cfcatch>
    </cftry>
</cfif>
