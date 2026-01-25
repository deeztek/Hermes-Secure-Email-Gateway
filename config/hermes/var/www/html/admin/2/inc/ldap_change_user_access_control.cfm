
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
CHANGE USER ACCESS CONTROL GROUP IN LDAP
Requires the following variables to be set before including:
- ldapUsername: The username (cn)
- ldapOldAccessControl: Previous access control ("one_factor" or "two_factor")
- ldapNewAccessControl: New access control ("one_factor" or "two_factor")

This will:
1. Remove user from old access control group
2. Add user to new access control group
--->

<!--- Only proceed if access control has actually changed --->
<cfif ldapOldAccessControl NEQ ldapNewAccessControl>

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE ERROR VARIABLES --->
<cfset ldapResult = "">
<cfset ldapError = "">

<cftry>

<!--- REMOVE FROM OLD GROUP --->
<cffile action="read" file="/opt/hermes/templates/ldap_removeusergroup.ldif" variable="ldapRemoveGroupTemplate">

<cfset ldapRemoveOldLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveOldLdif = REReplace(ldapRemoveOldLdif, "THE_GROUP", ldapOldAccessControl, "ALL")>
<cfset ldapRemoveOldLdif = REReplace(ldapRemoveOldLdif, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removeoldgroup.ldif"
    output="#ldapRemoveOldLdif#"
    addNewLine="no">

<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removeoldgroup.ldif"
    variable="ldapResult"
    errorVariable="ldapError"
    timeout="60">
</cfexecute>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeoldgroup.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- ADD TO NEW GROUP --->
<cffile action="read" file="/opt/hermes/templates/ldap_addusergroup.ldif" variable="ldapAddGroupTemplate">

<!--- We only need to add to the new access control group, not admins again --->
<cfset ldapAddNewLdif = "dn: cn=#ldapNewAccessControl#,ou=groups,dc=hermes,dc=local#Chr(10)#changetype: modify#Chr(10)#add: member#Chr(10)#member: cn=#ldapUsername#,ou=users,dc=hermes,dc=local#Chr(10)#">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_addnewgroup.ldif"
    output="#ldapAddNewLdif#"
    addNewLine="no">

<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_addnewgroup.ldif"
    variable="ldapResult"
    errorVariable="ldapError"
    timeout="60">
</cfexecute>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_addnewgroup.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeoldgroup.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_addnewgroup.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- Safely get ldapError if it exists --->
    <cfset errorDetail = "">
    <cfif isDefined("ldapError")>
        <cfset errorDetail = ldapError>
    </cfif>

    <cfset m="LDAP Change Access Control: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>

</cftry>

<!--- /CFIF access control changed --->
</cfif>
