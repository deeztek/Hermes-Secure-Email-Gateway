
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
MODIFY USER PASSWORD IN LDAP
Requires the following variables to be set before including:
- ldapUsername: The username (cn) - used to identify the user
- ldapPassword: The Argon2 password hash from generate_ldap_password.cfm
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE ERROR VARIABLES --->
<cfset ldapModifyResult = "">
<cfset ldapModifyError = "">

<cftry>

<!--- READ THE LDAP MODIFYUSERPASSWORD TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/ldap_modifyuserpassword.ldif" variable="ldapModifyPwdTemplate">

<!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
<cfset ldapModifyPwdLdif = ldapModifyPwdTemplate>
<cfset ldapModifyPwdLdif = REReplace(ldapModifyPwdLdif, "THE_USERNAME", ldapUsername, "ALL")>
<cfset ldapModifyPwdLdif = REReplace(ldapModifyPwdLdif, "THE_PASSWORD", ldapPassword, "ALL")>

<!--- WRITE THE POPULATED LDIF TO THE CUSTOM DIRECTORY (MOUNTED IN LDAP CONTAINER) --->
<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif"
    output="#ldapModifyPwdLdif#"
    addNewLine="no">

<!--- EXECUTE LDAPMODIFY IN THE LDAP CONTAINER --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif"
    variable="ldapModifyResult"
    errorVariable="ldapModifyError"
    timeout="60">
</cfexecute>

<!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_modifyuserpassword.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- Safely get ldapModifyError if it exists --->
    <cfset errorDetail = "">
    <cfif isDefined("ldapModifyError")>
        <cfset errorDetail = ldapModifyError>
    </cfif>

    <cfset m="LDAP Modify User Password: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>

</cftry>
