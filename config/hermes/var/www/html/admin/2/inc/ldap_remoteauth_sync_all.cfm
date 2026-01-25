
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
SYNC ALL REMOTEAUTH CONFIGURATION TO LDAP
Full sync strategy:
1. Delete the existing remoteauth overlay (if it exists)
2. If enabled, create ONE new overlay with ALL mappings included at creation time
3. Update ldap_synced flags in database

Note: OpenLDAP remoteauth is a singleton overlay - only ONE overlay allowed.
Multiple domain mappings are added as multi-valued olcRemoteAuthMapping attributes.
TLS settings are global for all mappings (per OpenLDAP design).

IMPORTANT: The olcRemoteAuthMapping attribute does not have an equality matching rule,
so all mappings MUST be included when creating the overlay. You cannot add mappings
to an existing overlay using ldapmodify add operation.

Sets:
- remoteauthSyncSuccess: Boolean indicating overall success
- remoteauthSyncError: Any error message
--->

<!--- INITIALIZE OUTPUT VARIABLES --->
<cfset remoteauthSyncSuccess = false>
<cfset remoteauthSyncError = "">

<cftry>

<!--- GET SETTINGS FROM DATABASE (includes global TLS settings) --->
<cfquery name="getSettings" datasource="hermes">
    SELECT setting_name, setting_value
    FROM remoteauth_settings
</cfquery>

<!--- BUILD SETTINGS STRUCTURE --->
<cfset settings = {}>
<cfloop query="getSettings">
    <cfset settings[getSettings.setting_name] = getSettings.setting_value>
</cfloop>

<!--- SET DEFAULTS FOR GLOBAL TLS SETTINGS IF NOT PRESENT --->
<cfif NOT structKeyExists(settings, "tls_starttls")>
    <cfset settings.tls_starttls = "no">
</cfif>
<cfif NOT structKeyExists(settings, "tls_reqcert")>
    <cfset settings.tls_reqcert = "never">
</cfif>
<cfif NOT structKeyExists(settings, "ca_cert_file")>
    <cfset settings.ca_cert_file = "">
</cfif>
<cfif NOT structKeyExists(settings, "retry_count")>
    <cfset settings.retry_count = "3">
</cfif>

<!--- GET ENABLED MAPPINGS FROM DATABASE --->
<cfquery name="getMappings" datasource="hermes">
    SELECT id, domain_name, server_address, server_port
    FROM remoteauth_mappings
    WHERE enabled = 1
    ORDER BY domain_name
</cfquery>

<!--- STEP 1: DELETE ALL EXISTING OVERLAYS --->
<cfinclude template="ldap_remoteauth_delete_overlay.cfm">

<!--- Check if delete was successful (or no overlays existed) --->
<cfif NOT remoteauthDeleteSuccess AND remoteauthDeleteError NEQ "">
    <cfset remoteauthSyncError = "Failed to delete existing overlays: #remoteauthDeleteError#">
    <cfthrow message="#remoteauthSyncError#">
</cfif>

<!--- STEP 2: IF ENABLED AND HAS MAPPINGS, CREATE OVERLAY WITH ALL MAPPINGS --->
<cfif structKeyExists(settings, "enabled") AND settings.enabled EQ "1" AND getMappings.recordcount GT 0>

    <!--- Get fresh overlay info after deletion --->
    <cfinclude template="ldap_remoteauth_get_overlay.cfm">

    <!--- BUILD ARRAY OF ALL MAPPINGS --->
    <!--- All mappings must be included at overlay creation time because --->
    <!--- olcRemoteAuthMapping lacks an equality matching rule for modify/add --->
    <cfset remoteauthMappingsArray = []>
    <cfloop query="getMappings">
        <cfset mappingStruct = {
            "domain_name": getMappings.domain_name,
            "server_address": "ldap://#getMappings.server_address#:#getMappings.server_port#"
        }>
        <cfset arrayAppend(remoteauthMappingsArray, mappingStruct)>
    </cfloop>

    <!--- Set variables for ldap_remoteauth_add_overlay.cfm --->
    <!--- Use GLOBAL TLS settings from remoteauth_settings table --->
    <cfset remoteauthDefaultDomain = getMappings.domain_name[1]>
    <cfset remoteauthStarttls = settings.tls_starttls>
    <cfset remoteauthTlsReqcert = settings.tls_reqcert>
    <cfset remoteauthCaCertFile = settings.ca_cert_file>
    <cfset remoteauthRetryCount = settings.retry_count>
    <!--- remoteauthNextOverlayIndex and remoteauthMdbIndex set by ldap_remoteauth_get_overlay.cfm --->

    <!--- Create the overlay with ALL mappings included --->
    <cfinclude template="ldap_remoteauth_add_overlay.cfm">

    <!--- Check if add was successful --->
    <cfif NOT remoteauthAddSuccess>
        <cfset remoteauthSyncError = "Failed to create overlay: #remoteauthAddError#">
        <cfthrow message="#remoteauthSyncError#">
    </cfif>

</cfif>

<!--- STEP 3: UPDATE DATABASE - Mark all as synced --->
<cfquery name="updateSettingsSync" datasource="hermes">
    UPDATE remoteauth_settings
    SET setting_value = '1'
    WHERE setting_name = 'ldap_synced'
</cfquery>

<cfquery name="updateMappingsSync" datasource="hermes">
    UPDATE remoteauth_mappings
    SET ldap_synced = 1
</cfquery>

<!--- SUCCESS --->
<cfset remoteauthSyncSuccess = true>

<cfcatch type="any">
    <cfset remoteauthSyncSuccess = false>
    <cfif remoteauthSyncError EQ "">
        <cfset remoteauthSyncError = "Sync failed: #cfcatch.message#">
    </cfif>
</cfcatch>

</cftry>
