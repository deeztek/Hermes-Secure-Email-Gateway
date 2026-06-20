
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
- sharedAddress: The shared mailbox address (e.g. "info@domain.tld")

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

<!--- Build dovecot-acl file content. Each row: "user=<email> <rights>".
     Rights are a SINGLE CONCATENATED STRING of single-letter abbreviations
     (RFC 4314 IMAP ACL). Space-separated full names (lookup, read, etc.)
     are NOT accepted by Dovecot's vfile parser — it reads each letter of a
     token as a separate right and chokes on 'o' in "lookup", for example.
       l = lookup       r = read         s = write-seen  (\Seen flag)
       w = write (flags except \Seen/\Deleted)           t = write-deleted
       i = insert       p = post         e = expunge
       k = create       x = delete (mbx) a = admin --->
<cfset aclFileContent = "">
<cfloop query="qAclPerms">
    <cfset userRights = "">
    <cfif qAclPerms.can_read EQ 1>
        <cfset userRights = userRights & "lrs">
    </cfif>
    <cfif qAclPerms.can_write EQ 1>
        <cfset userRights = userRights & "wt">
    </cfif>
    <cfif qAclPerms.can_delete EQ 1>
        <cfset userRights = userRights & "e">
    </cfif>
    <cfif qAclPerms.can_insert EQ 1>
        <cfset userRights = userRights & "i">
    </cfif>
    <cfif qAclPerms.can_post EQ 1>
        <cfset userRights = userRights & "p">
    </cfif>
    <cfif qAclPerms.can_admin EQ 1>
        <cfset userRights = userRights & "a">
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
