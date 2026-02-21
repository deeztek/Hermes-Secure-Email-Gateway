
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
DELETE RELAY USER FROM LDAP
Requires the following variables to be set before including:
- ldapUsername: The username (cn) to delete

This will:
1. Remove user from relays group (if member)
2. Remove user from one_factor group (if member)
3. Remove user from two_factor group (if member)
4. Delete the user entry
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE ERROR VARIABLES --->
<cfset ldapResult = "">
<cfset ldapError = "">
<cfset ldapDeleteResult = "">
<cfset ldapDeleteError = "">

<!--- READ THE LDAP REMOVEUSERGROUP RELAY TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/ldap_removeusergroup_relay.ldif" variable="ldapRemoveGroupTemplate">

<!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
<cfset ldapRemoveLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveLdif = REReplace(ldapRemoveLdif, "THE_USERNAME", ldapUsername, "ALL")>

<!--- WRITE THE POPULATED LDIF TO THE CUSTOM DIRECTORY --->
<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removeusergroup_relay.ldif"
    output="#ldapRemoveLdif#"
    addNewLine="no">

<!--- EXECUTE LDAPMODIFY TO REMOVE FROM GROUPS (ignore errors - user may not be in all groups) --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -c -f /opt/hermes/tmp/#customtrans3#_removeusergroup_relay.ldif"
        variable="ldapResult"
        errorVariable="ldapError"
        timeout="60">
    </cfexecute>
<cfcatch type="any">
    <!--- Ignore errors - user may not be in all groups --->
</cfcatch>
</cftry>

<!--- CLEANUP TEMP FILE --->
<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeusergroup_relay.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- NOW DELETE THE USER ENTRY --->
<cftry>
    <cffile action="read" file="/opt/hermes/templates/ldap_deleteuser.ldif" variable="ldapDeleteTemplate">

    <cfset ldapDeleteLdif = ldapDeleteTemplate>
    <cfset ldapDeleteLdif = REReplace(ldapDeleteLdif, "THE_USERNAME", ldapUsername, "ALL")>

    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_deleteuser_relay.ldif"
        output="#ldapDeleteLdif#"
        addNewLine="no">

    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_deleteuser_relay.ldif"
        variable="ldapDeleteResult"
        errorVariable="ldapDeleteError"
        timeout="60">
    </cfexecute>

    <!--- CLEANUP TEMP FILE --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_deleteuser_relay.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- CHECK FOR LDAP ERRORS - "No such object" is OK (user doesn't exist) --->
    <cfif ldapDeleteError CONTAINS "No such object">
        <!--- User doesn't exist in LDAP, that's OK --->
    <cfelseif ldapDeleteError CONTAINS "ldap_delete:" OR ldapDeleteError CONTAINS "ldap_modify:">
        <!--- Real error --->
        <cfset m="LDAP Delete Relay User Failed: #ldapDeleteError#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_deleteuser_relay.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- Safely get ldapDeleteError if it exists --->
    <cfset errorDetail = "">
    <cfif isDefined("ldapDeleteError")>
        <cfset errorDetail = ldapDeleteError>
    </cfif>

    <!--- "No such object" is not an error - user doesn't exist --->
    <cfif errorDetail CONTAINS "No such object">
        <!--- User doesn't exist in LDAP, that's OK --->
    <cfelse>
        <cfset m="LDAP Delete Relay User: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfcatch>
</cftry>
