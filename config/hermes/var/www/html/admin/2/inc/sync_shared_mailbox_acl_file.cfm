
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
SYNC SHARED MAILBOX DOVECOT-ACL FILE (vfile driver, Dovecot 2.4+)

Rebuilds /srv/mail/<domain>/<local>/dovecot-acl from the authoritative
shared_mailbox_permissions table. Dovecot 2.4 removed the non-upstream
SQL rights driver; vfile (per-Maildir dovecot-acl files) is the only
shipped driver for per-mailbox rights.

The dovecot_acl_shared SQL table is still used (via acl_sharing_map) for
the namespace listing — that's handled elsewhere. This include only
touches the filesystem ACL file used for rights enforcement.

Required input variable:
- sharedAddress: The shared mailbox address (e.g. "info@deeztek.org")

Behavior:
- Non-fatal on failure. Callers should not depend on the sync succeeding
  to consider their DB change committed. If the sync fails the DB rows
  remain correct and a subsequent permission change will re-attempt.
--->

<cfparam name="sharedAddress" type="string">

<cfset aclMailDomain   = LCase(ListLast(sharedAddress, "@"))>
<cfset aclMailLocal    = LCase(ListFirst(sharedAddress, "@"))>
<cfset aclMailDirPath  = "/srv/mail/" & aclMailDomain & "/" & aclMailLocal>
<cfset aclFilePath     = aclMailDirPath & "/dovecot-acl">

<!--- Authoritative source: shared_mailbox_permissions --->
<cfquery name="qAclPerms" datasource="hermes">
    SELECT smp.username,
           smp.can_read, smp.can_write, smp.can_delete,
           smp.can_insert, smp.can_post, smp.can_admin
    FROM shared_mailbox_permissions smp
    INNER JOIN shared_mailboxes sm ON sm.id = smp.shared_mailbox_id
    WHERE sm.address = <cfqueryparam value="#sharedAddress#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- Build dovecot-acl file content. Each row: "user=<email> <rights>" --->
<cfset aclFileContent = "">
<cfloop query="qAclPerms">
    <cfset userRights = "">
    <cfif qAclPerms.can_read EQ 1>
        <cfset userRights = ListAppend(userRights, "lookup read write-seen", " ")>
    </cfif>
    <cfif qAclPerms.can_write EQ 1>
        <cfset userRights = ListAppend(userRights, "write write-deleted", " ")>
    </cfif>
    <cfif qAclPerms.can_delete EQ 1>
        <cfset userRights = ListAppend(userRights, "expunge", " ")>
    </cfif>
    <cfif qAclPerms.can_insert EQ 1>
        <cfset userRights = ListAppend(userRights, "insert", " ")>
    </cfif>
    <cfif qAclPerms.can_post EQ 1>
        <cfset userRights = ListAppend(userRights, "post", " ")>
    </cfif>
    <cfif qAclPerms.can_admin EQ 1>
        <cfset userRights = ListAppend(userRights, "admin", " ")>
    </cfif>
    <cfif Len(userRights) GT 0>
        <cfset aclFileContent = aclFileContent & "user=" & qAclPerms.username & " " & userRights & chr(10)>
    </cfif>
</cfloop>

<cfinclude template="generate_customtrans.cfm">

<cftry>
    <cfset aclScriptPath = "/opt/hermes/tmp/" & customtrans3 & "_sync_shared_acl.sh">

    <!--- Wrap the payload in a heredoc so embedded newlines are safe. The
         EOF is single-quoted to prevent shell $-expansion on the content.
         cfexecute runs the wrapper shell script; the shell handles the
         heredoc + docker exec -i pipe, sidestepping Lucee's cfexecute
         argument-quoting quirks. --->
    <cfsavecontent variable="aclScript"><cfoutput>#chr(35)#!/bin/bash
set -e
docker exec -i hermes_dovecot sh -c "mkdir -p '#aclMailDirPath#' && cat > '#aclFilePath#' && chown vmail:vmail '#aclFilePath#' && chmod 0660 '#aclFilePath#'" <<'HERMES_ACL_EOF'
#aclFileContent#HERMES_ACL_EOF
</cfoutput></cfsavecontent>

    <cffile action="write" file="#aclScriptPath#" output="#aclScript#" charset="utf-8" addnewline="no">
    <cfexecute name="/bin/chmod" arguments="+x #aclScriptPath#" timeout="10" />
    <cfexecute name="#aclScriptPath#"
        variable="aclSyncResult"
        errorVariable="aclSyncError"
        timeout="30" />

    <cftry>
        <cffile action="delete" file="#aclScriptPath#">
    <cfcatch type="any"></cfcatch>
    </cftry>

<cfcatch type="any">
    <!--- Non-fatal: DB state remains the source of truth. Next permission
         change on this shared mailbox will retry the sync. --->
</cfcatch>
</cftry>
