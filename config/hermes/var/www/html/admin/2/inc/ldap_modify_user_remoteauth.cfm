
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
MODIFY REMOTE AUTH USER IN LDAP (non-password attributes + remoteauth attributes)
Requires the following variables to be set before including:
- ldapUsername: The username (cn) - used to identify the user
- ldapFirstName: User's first name (givenName)
- ldapLastName: User's last name (sn)
- ldapEmail: User's email address (mail)
- ldapRemoteauthDomain: The remoteauth domain for seeAlso/associatedDomain
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE ERROR VARIABLES --->
<cfset ldapModifyResult = "">
<cfset ldapModifyError = "">

<!--- GET THE REMOTE DN PATTERN FOR THIS DOMAIN --->
<cfquery name="getRemoteMapping" datasource="hermes">
    SELECT server_address, remote_dn_pattern FROM remoteauth_mappings WHERE domain_name = <cfqueryparam value="#ldapRemoteauthDomain#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- BUILD THE SEEALSO DN - This points to the remote user DN --->
<!--- Replace placeholders in the DN pattern with actual user values --->
<cfset ldapSeeAlso = getRemoteMapping.remote_dn_pattern>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{username}", ldapUsername, "ALL")>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{firstname}", ldapFirstName, "ALL")>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{lastname}", ldapLastName, "ALL")>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{email}", ldapEmail, "ALL")>

<cftry>

<!--- READ THE LDAP MODIFYUSER REMOTEAUTH TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/ldap_modifyuser_remoteauth.ldif" variable="ldapModifyTemplate">

<!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
<cfset ldapModifyLdif = ldapModifyTemplate>
<cfset ldapModifyLdif = REReplace(ldapModifyLdif, "THE_USERNAME", ldapUsername, "ALL")>
<cfset ldapModifyLdif = REReplace(ldapModifyLdif, "THE_FIRSTNAME", ldapFirstName, "ALL")>
<cfset ldapModifyLdif = REReplace(ldapModifyLdif, "THE_LASTNAME", ldapLastName, "ALL")>
<cfset ldapModifyLdif = REReplace(ldapModifyLdif, "THE_EMAIL", ldapEmail, "ALL")>
<cfset ldapModifyLdif = REReplace(ldapModifyLdif, "THE_SEEALSO", ldapSeeAlso, "ALL")>
<cfset ldapModifyLdif = REReplace(ldapModifyLdif, "THE_DOMAIN", ldapRemoteauthDomain, "ALL")>

<!--- WRITE THE POPULATED LDIF TO THE CUSTOM DIRECTORY (MOUNTED IN LDAP CONTAINER) --->
<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_modifyuser_remoteauth.ldif"
    output="#ldapModifyLdif#"
    addNewLine="no">

<!--- EXECUTE LDAPMODIFY IN THE LDAP CONTAINER --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_modifyuser_remoteauth.ldif"
    variable="ldapModifyResult"
    errorVariable="ldapModifyError"
    timeout="60">
</cfexecute>

<!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuser_remoteauth.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuser_remoteauth.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- Safely get ldapModifyError if it exists --->
    <cfset errorDetail = "">
    <cfif isDefined("ldapModifyError")>
        <cfset errorDetail = ldapModifyError>
    </cfif>

    <cfset m="LDAP Modify User RemoteAuth: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>

</cftry>
