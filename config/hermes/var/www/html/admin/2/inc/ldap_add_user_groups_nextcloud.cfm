
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
ADD MAILBOX USER TO LDAP NEXTCLOUD GROUP
Requires the following variable to be set before including:
- ldapUsername: The username (cn)

Adds the user to cn=nextcloud,ou=groups,dc=hermes,dc=local. Authelia uses
this group membership to permit access to /nc (the Nextcloud webmail
endpoint). A mailbox user without this group membership will be denied
by Authelia even though they can still log in to the user portal.

Idempotent: "already a member" errors are caught and treated as success.
--->

<cfinclude template="generate_customtrans.cfm">

<cfset ldapModifyResult = "">
<cfset ldapModifyError = "">

<cftry>

<cffile action="read" file="/opt/hermes/templates/ldap_addusergroup_nextcloud.ldif" variable="ldapGroupTemplate">

<cfset ldapGroupLdif = REReplace(ldapGroupTemplate, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_addusergroup_nextcloud.ldif"
    output="#ldapGroupLdif#"
    addNewLine="no">

<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_addusergroup_nextcloud.ldif"
    variable="ldapModifyResult"
    errorVariable="ldapModifyError"
    timeout="60">
</cfexecute>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_addusergroup_nextcloud.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<cfcatch type="any">
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_addusergroup_nextcloud.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <cfset errorDetail = "">
    <cfif isDefined("ldapModifyError")>
        <cfset errorDetail = ldapModifyError>
    </cfif>

    <!--- Idempotent: "already a member" is not fatal --->
    <cfif errorDetail CONTAINS "already exists" OR errorDetail CONTAINS "Type or value exists">
        <!--- User is already in nextcloud group, that's fine --->
    <cfelse>
        <cfset m="LDAP Add Nextcloud Group: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfcatch>

</cftry>
