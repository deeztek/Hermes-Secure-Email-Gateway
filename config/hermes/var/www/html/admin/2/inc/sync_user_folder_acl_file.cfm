
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
SYNC USER FOLDER ACL FILE (Dovecot 2.4 vfile driver) — ADMIN-PORTAL COPY

Byte-for-byte duplicate of users/2/inc/sync_user_folder_acl_file.cfm.
Lives in both locations because CFML includes are scoped to the
including page's directory tree and we don't have a shared include
path today. Keep these two files in sync — if you edit one, edit the
other. Logic, inputs, and outputs are identical.

Required inputs:
  - ownerUser : owner's email (full address, e.g. "user@domain.tld")
  - folderPath : folder path in IMAP form (e.g. "Work" or "Projects/Alpha").
                 Leading "INBOX/" is tolerated and stripped.

Rebuilds /srv/mail/<domain>/<local>/<.subfolder>/dovecot-acl from the
user_folder_shares table. Non-fatal on failure.
--->

<cfparam name="ownerUser"  type="string">
<cfparam name="folderPath" type="string">

<cfset aclOwnerDomain = LCase(ListLast(ownerUser, "@"))>
<cfset aclOwnerLocal  = LCase(ListFirst(ownerUser, "@"))>
<cfset aclMaildirRoot = "/srv/mail/" & aclOwnerDomain & "/" & aclOwnerLocal>

<cfset aclFolderNormalized = Trim(folderPath)>
<cfif Left(aclFolderNormalized, 1) EQ "/">
    <cfset aclFolderNormalized = Mid(aclFolderNormalized, 2, Len(aclFolderNormalized))>
</cfif>
<cfif REFindNoCase("^INBOX/", aclFolderNormalized) GT 0>
    <cfset aclFolderNormalized = Mid(aclFolderNormalized, 7, Len(aclFolderNormalized))>
</cfif>

<cfif aclFolderNormalized EQ "" OR aclFolderNormalized EQ "INBOX">
    <cfset aclMaildirSubdir = "">
<cfelse>
    <cfset aclMaildirSubdir = "." & Replace(aclFolderNormalized, "/", ".", "ALL")>
</cfif>

<cfif aclMaildirSubdir EQ "">
    <cfset aclMailDirPath = aclMaildirRoot>
<cfelse>
    <cfset aclMailDirPath = aclMaildirRoot & "/" & aclMaildirSubdir>
</cfif>
<cfset aclFilePath = aclMailDirPath & "/dovecot-acl">

<cfquery name="qUserAclPerms" datasource="hermes">
    SELECT shared_with_username, can_read, can_write, can_delete, can_insert
    FROM user_folder_shares
    WHERE owner_username = <cfqueryparam value="#ownerUser#"  cfsqltype="cf_sql_varchar">
    AND   folder_path    = <cfqueryparam value="#folderPath#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset aclFileContent = "">
<cfloop query="qUserAclPerms">
    <cfset userRights = "">
    <cfif qUserAclPerms.can_read EQ 1>
        <cfset userRights = userRights & "lrs">
    </cfif>
    <cfif qUserAclPerms.can_write EQ 1>
        <cfset userRights = userRights & "wt">
    </cfif>
    <cfif qUserAclPerms.can_insert EQ 1>
        <cfset userRights = userRights & "i">
    </cfif>
    <cfif qUserAclPerms.can_delete EQ 1>
        <cfset userRights = userRights & "e">
    </cfif>
    <cfif Len(userRights) GT 0>
        <cfset aclFileContent = aclFileContent & "user=" & qUserAclPerms.shared_with_username & " " & userRights & chr(10)>
    </cfif>
</cfloop>

<cfinclude template="generate_customtrans.cfm">

<cftry>
    <cfset aclScriptPath = "/opt/hermes/tmp/" & customtrans3 & "_sync_user_folder_acl.sh">

    <cfsavecontent variable="aclScript"><cfoutput>#chr(35)#!/bin/bash
set -e
docker exec -i hermes_dovecot sh -c "mkdir -p '#aclMailDirPath#' && cat > '#aclFilePath#' && chown vmail:vmail '#aclFilePath#' && chmod 0660 '#aclFilePath#'" <<'HERMES_USER_ACL_EOF'
#aclFileContent#HERMES_USER_ACL_EOF
</cfoutput></cfsavecontent>

    <cffile action="write" file="#aclScriptPath#" output="#aclScript#" charset="utf-8" addnewline="no">
    <cfexecute name="/bin/chmod" arguments="+x #aclScriptPath#" timeout="10" />
    <cfexecute name="#aclScriptPath#"
        variable="aclSyncResult"
        errorVariable="aclSyncError"
        timeout="30" />

    <cftry><cffile action="delete" file="#aclScriptPath#"><cfcatch type="any"></cfcatch></cftry>

<cfcatch type="any">
    <!--- Non-fatal: DB state remains correct. --->
</cfcatch>
</cftry>
