
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
DELETE ALL REMOTEAUTH OVERLAYS FROM LDAP
Removes ALL remoteauth overlays (there can be multiple - one per domain mapping).
Must delete from highest index to lowest to avoid renumbering issues.

Sets:
- remoteauthDeleteResult: Result from ldapmodify commands
- remoteauthDeleteError: Any error message
- remoteauthDeleteSuccess: Boolean indicating success
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- GET ALL OVERLAY INFO (MDB index and all existing overlay indexes) --->
<cfinclude template="ldap_remoteauth_get_overlay.cfm">

<!--- INITIALIZE OUTPUT VARIABLES --->
<cfset remoteauthDeleteResult = "">
<cfset remoteauthDeleteError = "">
<cfset remoteauthDeleteSuccess = false>

<cftry>

<!--- CHECK IF ANY OVERLAYS EXIST --->
<cfif arrayLen(remoteauthExistingOverlays) EQ 0>
    <!--- No overlays exist, consider this success --->
    <cfset remoteauthDeleteSuccess = true>
<cfelse>

    <!--- READ THE LDAP TEMPLATE --->
    <cffile action="read" file="/opt/hermes/templates/ldap_remoteauth_delete_overlay.ldif" variable="ldapTemplate">

    <!--- DELETE EACH OVERLAY FROM HIGHEST INDEX TO LOWEST --->
    <!--- remoteauthExistingOverlays is already sorted descending by ldap_remoteauth_get_overlay.cfm --->
    <cfset deleteResults = []>

    <cfloop array="#remoteauthExistingOverlays#" index="overlayIndex">

        <!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
        <cfset ldapLdif = ldapTemplate>
        <cfset ldapLdif = REReplace(ldapLdif, "THE_OVERLAY_INDEX", overlayIndex, "ALL")>
        <cfset ldapLdif = REReplace(ldapLdif, "THE_MDB_INDEX", remoteauthMdbIndex, "ALL")>

        <!--- WRITE THE POPULATED LDIF TO TEMP DIRECTORY --->
        <cfset tempFile = "/opt/hermes/tmp/#customtrans3#_remoteauth_delete_overlay_#overlayIndex#.ldif">
        <cffile action="write"
            file="#tempFile#"
            output="#ldapLdif#"
            addNewLine="no">

        <!--- EXECUTE LDAPMODIFY IN THE LDAP CONTAINER --->
        <cfset deleteResultItem = "">
        <cfset deleteErrorItem = "">
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f #tempFile#"
            variable="deleteResultItem"
            errorVariable="deleteErrorItem"
            timeout="60">
        </cfexecute>

        <!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
        <cfif fileExists(tempFile)>
            <cffile action="delete" file="#tempFile#">
        </cfif>

        <!--- CHECK FOR ERRORS --->
        <!--- Note: SASL authentication messages go to stderr but are not errors --->
        <!--- Only fail if stderr contains actual error indicators like "ldap_" errors --->
        <cfif deleteErrorItem CONTAINS "ldap_delete" OR deleteErrorItem CONTAINS "ldap_modify" OR
              (deleteErrorItem CONTAINS "error" AND NOT deleteErrorItem CONTAINS "SASL")>
            <cfset remoteauthDeleteError = "Failed to delete overlay index #overlayIndex#: #deleteErrorItem#">
            <cfthrow message="#remoteauthDeleteError#">
        </cfif>

        <cfset arrayAppend(deleteResults, "Deleted overlay {#overlayIndex#}remoteauth")>
    </cfloop>

    <!--- ALL OVERLAYS DELETED SUCCESSFULLY --->
    <cfset remoteauthDeleteResult = arrayToList(deleteResults, "; ")>
    <cfset remoteauthDeleteSuccess = true>

</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfloop array="#remoteauthExistingOverlays#" index="overlayIndex">
        <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_remoteauth_delete_overlay_#overlayIndex#.ldif">
        <cfif fileExists(fileToDelete)>
            <cffile action="delete" file="#fileToDelete#">
        </cfif>
    </cfloop>

    <cfif remoteauthDeleteError EQ "">
        <cfset remoteauthDeleteError = "Error deleting overlays: #cfcatch.message#">
    </cfif>
    <cfset remoteauthDeleteSuccess = false>
</cfcatch>

</cftry>
