
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
DELETE DOMAIN MAPPING FROM REMOTEAUTH OVERLAY
Requires the following variables to be set before including:
- remoteauthMappingDomain: Domain name (e.g., 'example')
- remoteauthMappingServer: Server address (e.g., 'dc01.example.com')

Sets:
- remoteauthDeleteMappingResult: Result from ldapmodify command
- remoteauthDeleteMappingError: Any error message
- remoteauthDeleteMappingSuccess: Boolean indicating success
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- GET OVERLAY INFO --->
<cfinclude template="ldap_remoteauth_get_overlay.cfm">

<!--- INITIALIZE OUTPUT VARIABLES --->
<cfset remoteauthDeleteMappingResult = "">
<cfset remoteauthDeleteMappingError = "">
<cfset remoteauthDeleteMappingSuccess = false>

<cftry>

<!--- CHECK IF OVERLAY EXISTS --->
<cfif NOT remoteauthOverlayExists>
    <cfset remoteauthDeleteMappingError = "RemoteAuth overlay does not exist">
    <cfset remoteauthDeleteMappingSuccess = false>
<cfelse>

    <!--- READ THE LDAP TEMPLATE --->
    <cffile action="read" file="/opt/hermes/templates/ldap_remoteauth_delete_mapping.ldif" variable="ldapTemplate">

    <!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
    <cfset ldapLdif = ldapTemplate>
    <cfset ldapLdif = REReplace(ldapLdif, "THE_OVERLAY_INDEX", remoteauthOverlayIndex, "ALL")>
    <cfset ldapLdif = REReplace(ldapLdif, "THE_MDB_INDEX", remoteauthMdbIndex, "ALL")>
    <cfset ldapLdif = REReplace(ldapLdif, "THE_DOMAIN", remoteauthMappingDomain, "ALL")>
    <cfset ldapLdif = REReplace(ldapLdif, "THE_SERVER", remoteauthMappingServer, "ALL")>

    <!--- WRITE THE POPULATED LDIF TO TEMP DIRECTORY --->
    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_remoteauth_delete_mapping.ldif"
        output="#ldapLdif#"
        addNewLine="no">

    <!--- EXECUTE LDAPMODIFY IN THE LDAP CONTAINER --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_remoteauth_delete_mapping.ldif"
        variable="remoteauthDeleteMappingResult"
        errorVariable="remoteauthDeleteMappingError"
        timeout="60">
    </cfexecute>

    <!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_remoteauth_delete_mapping.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- CHECK FOR SUCCESS --->
    <cfif remoteauthDeleteMappingError EQ "" OR remoteauthDeleteMappingResult CONTAINS "modifying entry">
        <cfset remoteauthDeleteMappingSuccess = true>
    </cfif>

</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_remoteauth_delete_mapping.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <cfset remoteauthDeleteMappingError = "Error deleting mapping: #cfcatch.message#">
    <cfset remoteauthDeleteMappingSuccess = false>
</cfcatch>

</cftry>
