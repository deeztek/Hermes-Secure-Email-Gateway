
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
REPLACE A USER'S LDAP displayName AND NOTHING ELSE

ldap_modify_user.cfm cannot be used for this. Its template writes
displayName as "THE_FIRSTNAME THE_LASTNAME" and replaces givenName and sn on
the way past, and those two are deliberately derived from the email address
rather than from a real name: the remoteauth overlay substitutes them into
the seeAlso DN pattern, so a deployment whose remote_dn_pattern references
{firstname} or {lastname} would stop authenticating. See the note in
ldap_add_user_mailbox.cfm.

displayName has no such constraint. It feeds the Authelia OIDC name claim and
the Nextcloud display name, which is exactly what wants correcting when a
relay recipient becomes a mailbox: relay entries carry the default from
ldap_add_user.cfm, the email local part followed by the literal word "User".

Requires:
- ldapUsername
- ldapDisplayName

Sets:
- displayNameModified: boolean

Not fatal on failure. A wrong display name is cosmetic next to a half
provisioned mailbox, so the caller carries on.
--->

<cfinclude template="generate_customtrans.cfm">

<cfset displayNameModified = false>
<cfset ldapDnModifyResult  = "">
<cfset ldapDnModifyError   = "">

<cftry>

    <cffile action="read"
        file="/opt/hermes/templates/ldap_modifyuser_displayname.ldif"
        variable="ldapDnTemplate"
        charset="utf-8">

    <cfset ldapDnLdif = REReplace(ldapDnTemplate, "THE_USERNAME", ldapUsername, "ALL")>
    <cfset ldapDnLdif = REReplace(ldapDnLdif, "THE_DISPLAYNAME", ldapDisplayName, "ALL")>

    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_modifyuser_displayname.ldif"
        output="#ldapDnLdif#"
        addNewLine="no">

    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_modifyuser_displayname.ldif"
        variable="ldapDnModifyResult"
        errorVariable="ldapDnModifyError"
        timeout="60">
    </cfexecute>

    <cfif FindNoCase("modifying entry", ldapDnModifyResult) GT 0>
        <cfset displayNameModified = true>
    </cfif>

    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuser_displayname.ldif">
    <cfif FileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

<cfcatch type="any">
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuser_displayname.ldif">
    <cfif FileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>
    <cfset displayNameModified = false>
</cfcatch>

</cftry>
