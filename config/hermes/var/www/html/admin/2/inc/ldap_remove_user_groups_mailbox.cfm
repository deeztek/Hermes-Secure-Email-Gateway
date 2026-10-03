
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
DROP A USER'S MAILBOX GROUP MEMBERSHIP, KEEPING THE AUTH GROUPS

For reverting a converted mailbox back to a relay recipient, where the LDAP entry
stays and only its role changes. The user leaves cn=mailboxes and nothing else.

delete_mailbox_action.cfm uses ldap_removeusergroup_mailbox.ldif, which also
strips cn=one_factor and cn=two_factor. That is right when the account is
going away and wrong here: the account is staying and still has to be able to
log in, so this uses a template that touches cn=mailboxes alone.

Requires:
- ldapUsername

Sets:
- mailboxGroupRemoved: boolean

Not fatal on failure. A user who was never in cn=mailboxes makes ldapmodify
report "no such attribute", which means the end state is already what was
wanted, so the caller carries on either way.
--->

<cfinclude template="generate_customtrans.cfm">

<cfset mailboxGroupRemoved = false>
<cfset ldapMailboxRemoveResult = "">
<cfset ldapMailboxRemoveError  = "">

<cftry>

    <cffile action="read"
        file="/opt/hermes/templates/ldap_removeusergroup_mailbox_keepauth.ldif"
        variable="ldapMailboxGroupTemplate"
        charset="utf-8">

    <cfset ldapMailboxGroupLdif = REReplace(ldapMailboxGroupTemplate, "THE_USERNAME", ldapUsername, "ALL")>

    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif"
        output="#ldapMailboxGroupLdif#"
        addNewLine="no">

    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif"
        variable="ldapMailboxRemoveResult"
        errorVariable="ldapMailboxRemoveError"
        timeout="60">
    </cfexecute>

    <cfif FindNoCase("modifying entry", ldapMailboxRemoveResult) GT 0>
        <cfset mailboxGroupRemoved = true>
    </cfif>

    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif">
    <cfif FileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

<cfcatch type="any">
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeusergroup_mailbox.ldif">
    <cfif FileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>
    <cfset mailboxGroupRemoved = false>
</cfcatch>

</cftry>
