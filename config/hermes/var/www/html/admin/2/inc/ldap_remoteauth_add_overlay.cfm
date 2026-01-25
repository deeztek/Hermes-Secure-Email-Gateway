
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
ADD REMOTEAUTH OVERLAY TO LDAP
Creates a single overlay with ALL domain mappings included at creation time.

OpenLDAP remoteauth is a SINGLETON overlay - only ONE allowed per database.
The olcRemoteAuthMapping attribute is multi-valued but does not have an equality
matching rule, so all mappings MUST be included when creating the overlay.
You cannot add mappings to an existing overlay using ldapmodify add operation.

Requires the following variables to be set before including:
- remoteauthMappingsArray: Array of structs with keys: domain_name, server_address
  e.g., [{domain_name: "deeztek", server_address: "ldap://server1:389"}, ...]
- remoteauthDefaultDomain: Default domain (usually first domain)
- remoteauthStarttls: 'yes' or 'no'
- remoteauthTlsReqcert: 'never', 'allow', 'try', or 'demand'
- remoteauthCaCertFile: (Optional) CA certificate filename in /opt/hermes/certs/remoteauth/
- remoteauthRetryCount: Number of retries (e.g., '3')
- remoteauthNextOverlayIndex: Next available overlay index (from ldap_remoteauth_get_overlay.cfm)
- remoteauthMdbIndex: MDB database index (from ldap_remoteauth_get_overlay.cfm)

Sets:
- remoteauthAddResult: Result from ldapadd command
- remoteauthAddError: Any error message
- remoteauthAddSuccess: Boolean indicating success
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE OUTPUT VARIABLES --->
<cfset remoteauthAddResult = "">
<cfset remoteauthAddError = "">
<cfset remoteauthAddSuccess = false>

<cftry>

<!--- Verify required variables are defined --->
<cfif NOT isDefined("remoteauthMappingsArray") OR NOT isArray(remoteauthMappingsArray) OR arrayLen(remoteauthMappingsArray) EQ 0>
    <cfthrow message="Missing or empty required variable: remoteauthMappingsArray">
</cfif>
<cfif NOT isDefined("remoteauthMdbIndex")>
    <cfthrow message="Missing required variable: remoteauthMdbIndex">
</cfif>
<cfif NOT isDefined("remoteauthNextOverlayIndex")>
    <cfthrow message="Missing required variable: remoteauthNextOverlayIndex">
</cfif>
<cfif NOT isDefined("remoteauthDefaultDomain")>
    <!--- Use first mapping's domain as default --->
    <cfset remoteauthDefaultDomain = remoteauthMappingsArray[1].domain_name>
</cfif>
<cfif NOT isDefined("remoteauthStarttls")>
    <cfset remoteauthStarttls = "no">
</cfif>
<cfif NOT isDefined("remoteauthTlsReqcert")>
    <cfset remoteauthTlsReqcert = "never">
</cfif>
<cfif NOT isDefined("remoteauthRetryCount")>
    <cfset remoteauthRetryCount = "3">
</cfif>

<!--- BUILD MAPPING LINES --->
<!--- Each mapping becomes: olcRemoteAuthMapping: domain_name ldap://server:port --->
<cfset mappingLines = "">
<cfloop array="#remoteauthMappingsArray#" index="mapping">
    <cfset mappingLines = mappingLines & "olcRemoteAuthMapping: #mapping.domain_name# #mapping.server_address#" & chr(10)>
</cfloop>
<!--- Remove trailing newline --->
<cfset mappingLines = trim(mappingLines)>

<!--- READ THE LDAP TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/ldap_remoteauth_add_overlay.ldif" variable="ldapTemplate">

<!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
<cfset ldapLdif = ldapTemplate>
<cfset ldapLdif = REReplace(ldapLdif, "THE_OVERLAY_INDEX", remoteauthNextOverlayIndex, "ALL")>
<cfset ldapLdif = REReplace(ldapLdif, "THE_MDB_INDEX", remoteauthMdbIndex, "ALL")>
<cfset ldapLdif = REReplace(ldapLdif, "THE_DEFAULT_DOMAIN", remoteauthDefaultDomain, "ALL")>
<cfset ldapLdif = REReplace(ldapLdif, "THE_MAPPING_LINES", mappingLines, "ALL")>
<cfset ldapLdif = REReplace(ldapLdif, "THE_STARTTLS", remoteauthStarttls, "ALL")>
<cfset ldapLdif = REReplace(ldapLdif, "THE_TLS_REQCERT", remoteauthTlsReqcert, "ALL")>

<!--- Handle optional CA certificate - if provided, add tls_cacert option --->
<cfif isDefined("remoteauthCaCertFile") AND remoteauthCaCertFile NEQ "">
    <cfset ldapLdif = REReplace(ldapLdif, "THE_TLS_CACERT", "tls_cacert=/opt/hermes/certs/remoteauth/#remoteauthCaCertFile#", "ALL")>
<cfelse>
    <!--- No CA cert - remove placeholder --->
    <cfset ldapLdif = REReplace(ldapLdif, " THE_TLS_CACERT", "", "ALL")>
    <cfset ldapLdif = REReplace(ldapLdif, "THE_TLS_CACERT", "", "ALL")>
</cfif>

<cfset ldapLdif = REReplace(ldapLdif, "THE_RETRY_COUNT", remoteauthRetryCount, "ALL")>

<!--- WRITE THE POPULATED LDIF TO TEMP DIRECTORY --->
<cfset tempFile = "/opt/hermes/tmp/#customtrans3#_remoteauth_add_overlay.ldif">
<cffile action="write"
    file="#tempFile#"
    output="#ldapLdif#"
    addNewLine="no">

<!--- EXECUTE LDAPADD IN THE LDAP CONTAINER --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapadd -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f #tempFile#"
    variable="remoteauthAddResult"
    errorVariable="remoteauthAddError"
    timeout="60">
</cfexecute>

<!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
<cfif fileExists(tempFile)>
    <cffile action="delete" file="#tempFile#">
</cfif>

<!--- CHECK FOR SUCCESS --->
<!--- SASL messages go to stderr but are not errors --->
<cfset hasActualError = false>
<cfif len(trim(remoteauthAddError)) GT 0>
    <!--- Check for actual LDAP error keywords --->
    <cfif FindNoCase("ldap_add:", remoteauthAddError) OR
          FindNoCase("ldap_modify:", remoteauthAddError) OR
          FindNoCase("ldap_", remoteauthAddError) AND FindNoCase("error", remoteauthAddError) OR
          FindNoCase("invalid", remoteauthAddError) OR
          FindNoCase("constraint violation", remoteauthAddError)>
        <cfset hasActualError = true>
    </cfif>
</cfif>

<cfif NOT hasActualError>
    <cfset remoteauthAddSuccess = true>
<cfelse>
    <cfset remoteauthAddSuccess = false>
    <cfset remoteauthAddError = "LDAP error: #remoteauthAddError#">
</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfif isDefined("customtrans3") AND isDefined("tempFile")>
        <cfset fileToDelete = tempFile>
        <cfif fileExists(fileToDelete)>
            <cffile action="delete" file="#fileToDelete#">
        </cfif>
    </cfif>

    <!--- Build comprehensive error message --->
    <cfset remoteauthAddError = "Error adding overlay: #cfcatch.message#">
    <cfif isDefined("cfcatch.detail") AND len(trim(cfcatch.detail)) GT 0>
        <cfset remoteauthAddError = remoteauthAddError & " | Detail: #cfcatch.detail#">
    </cfif>
    <cfset remoteauthAddSuccess = false>
</cfcatch>

</cftry>
