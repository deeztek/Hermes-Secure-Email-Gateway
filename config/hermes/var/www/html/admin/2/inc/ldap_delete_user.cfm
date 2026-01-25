
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
DELETE USER FROM LDAP
Requires the following variables to be set before including:
- ldapUsername: The username (cn) to delete

This will:
1. Remove user from admins group (if member)
2. Remove user from mailboxes group (if member)
3. Remove user from one_factor group (if member)
4. Remove user from two_factor group (if member)
5. Remove user from relays group (if member)
6. Delete the user entry
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE ERROR VARIABLES --->
<cfset ldapResult = "">
<cfset ldapError = "">
<cfset ldapDeleteResult = "">
<cfset ldapDeleteError = "">

<!--- FIRST REMOVE USER FROM ALL GROUPS --->
<!--- Read the remove user group template --->
<cffile action="read" file="/opt/hermes/templates/ldap_removeusergroup.ldif" variable="ldapRemoveGroupTemplate">

<!--- Remove from admins group (ignore errors - user may not be member) --->
<cfset ldapRemoveAdminsLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveAdminsLdif = REReplace(ldapRemoveAdminsLdif, "THE_GROUP", "admins", "ALL")>
<cfset ldapRemoveAdminsLdif = REReplace(ldapRemoveAdminsLdif, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removeadmins.ldif"
    output="#ldapRemoveAdminsLdif#"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removeadmins.ldif"
        variable="ldapResult"
        errorVariable="ldapError"
        timeout="60">
    </cfexecute>
<cfcatch type="any">
    <!--- Ignore cfexecute errors - user may not be in this group --->
</cfcatch>
</cftry>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeadmins.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- Remove from mailboxes group (ignore errors - user may not be member) --->
<cfset ldapRemoveMailboxesLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveMailboxesLdif = REReplace(ldapRemoveMailboxesLdif, "THE_GROUP", "mailboxes", "ALL")>
<cfset ldapRemoveMailboxesLdif = REReplace(ldapRemoveMailboxesLdif, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removemailboxes.ldif"
    output="#ldapRemoveMailboxesLdif#"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removemailboxes.ldif"
        variable="ldapResult"
        errorVariable="ldapError"
        timeout="60">
    </cfexecute>
<cfcatch type="any">
    <!--- Ignore cfexecute errors - user may not be in this group --->
</cfcatch>
</cftry>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removemailboxes.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- Remove from one_factor group (ignore errors - user may not be member) --->
<cfset ldapRemoveOneFactorLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveOneFactorLdif = REReplace(ldapRemoveOneFactorLdif, "THE_GROUP", "one_factor", "ALL")>
<cfset ldapRemoveOneFactorLdif = REReplace(ldapRemoveOneFactorLdif, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removeonefactor.ldif"
    output="#ldapRemoveOneFactorLdif#"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removeonefactor.ldif"
        variable="ldapResult"
        errorVariable="ldapError"
        timeout="60">
    </cfexecute>
<cfcatch type="any">
    <!--- Ignore cfexecute errors - user may not be in this group --->
</cfcatch>
</cftry>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removeonefactor.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- Remove from two_factor group (ignore errors - user may not be member) --->
<cfset ldapRemoveTwoFactorLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveTwoFactorLdif = REReplace(ldapRemoveTwoFactorLdif, "THE_GROUP", "two_factor", "ALL")>
<cfset ldapRemoveTwoFactorLdif = REReplace(ldapRemoveTwoFactorLdif, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removetwofactor.ldif"
    output="#ldapRemoveTwoFactorLdif#"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removetwofactor.ldif"
        variable="ldapResult"
        errorVariable="ldapError"
        timeout="60">
    </cfexecute>
<cfcatch type="any">
    <!--- Ignore cfexecute errors - user may not be in this group --->
</cfcatch>
</cftry>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removetwofactor.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- Remove from relays group (ignore errors - user may not be member) --->
<cfset ldapRemoveRelaysLdif = ldapRemoveGroupTemplate>
<cfset ldapRemoveRelaysLdif = REReplace(ldapRemoveRelaysLdif, "THE_GROUP", "relays", "ALL")>
<cfset ldapRemoveRelaysLdif = REReplace(ldapRemoveRelaysLdif, "THE_USERNAME", ldapUsername, "ALL")>

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_removerelays.ldif"
    output="#ldapRemoveRelaysLdif#"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_removerelays.ldif"
        variable="ldapResult"
        errorVariable="ldapError"
        timeout="60">
    </cfexecute>
<cfcatch type="any">
    <!--- Ignore cfexecute errors - user may not be in this group --->
</cfcatch>
</cftry>

<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_removerelays.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- NOW DELETE THE USER ENTRY - This one should NOT fail silently --->
<cftry>
    <cffile action="read" file="/opt/hermes/templates/ldap_deleteuser.ldif" variable="ldapDeleteTemplate">

    <cfset ldapDeleteLdif = ldapDeleteTemplate>
    <cfset ldapDeleteLdif = REReplace(ldapDeleteLdif, "THE_USERNAME", ldapUsername, "ALL")>

    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_deleteuser.ldif"
        output="#ldapDeleteLdif#"
        addNewLine="no">

    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_deleteuser.ldif"
        variable="ldapDeleteResult"
        errorVariable="ldapDeleteError"
        timeout="60">
    </cfexecute>

    <!--- CLEANUP TEMP FILE --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_deleteuser.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- CHECK FOR LDAP ERRORS - cfexecute may not throw exception on LDAP failure --->
    <!--- Note: ldapDeleteError will contain auth info on success, so check for specific error patterns --->
    <cfif ldapDeleteError CONTAINS "No such object" OR ldapDeleteError CONTAINS "ldap_delete:" OR ldapDeleteError CONTAINS "ldap_modify:" OR (ldapDeleteError CONTAINS "error" AND NOT ldapDeleteError CONTAINS "SASL")>
        <cfset m="LDAP Delete User Failed: #ldapDeleteError#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_deleteuser.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- Safely get ldapDeleteError if it exists --->
    <cfset errorDetail = "">
    <cfif isDefined("ldapDeleteError")>
        <cfset errorDetail = ldapDeleteError>
    </cfif>

    <cfset m="LDAP Delete User: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>
