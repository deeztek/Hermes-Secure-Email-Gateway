
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
Generates /etc/postfix/sasl_passwd with ALL SASL credentials:
  1. Relay host credentials (from parameters table, if relay auth is enabled)
  2. Per-domain transport credentials (from transport table, if authentication = YES)
Then postmaps the file via docker exec.
--->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<cfset FileSasl = "">

<!--- 1. Relay host credentials (encrypted in system_settings) --->
<cfquery name="getRelayHostId" datasource="hermes">
  SELECT id FROM parameters WHERE parameter = 'relayhost' AND child = '2'
</cfquery>

<cfquery name="getRelayHost" datasource="hermes">
  SELECT parameter FROM parameters WHERE parent = '#getRelayHostId.id#' AND child = '1' AND enabled = '1'
</cfquery>

<cfquery name="getRelayAuthEnabled" datasource="hermes">
  SELECT id FROM parameters WHERE parameter = 'smtp_sasl_auth_enable' AND child = '2' AND enabled = '1'
</cfquery>

<cfquery name="getRelayCreds" datasource="hermes">
  SELECT parameter, value FROM system_settings
  WHERE parameter IN ('relay_host_username', 'relay_host_password')
</cfquery>

<cfset relayUsername = "">
<cfset relayPassword = "">
<cfloop query="getRelayCreds">
  <cfif parameter EQ "relay_host_username" AND value is not "">
    <cftry>
      <cfset relayUsername = decrypt(value, hermeskey, "AES", "Base64")>
      <cfcatch><cfset relayUsername = ""></cfcatch>
    </cftry>
  </cfif>
  <cfif parameter EQ "relay_host_password" AND value is not "">
    <cftry>
      <cfset relayPassword = decrypt(value, hermeskey, "AES", "Base64")>
      <cfcatch><cfset relayPassword = ""></cfcatch>
    </cftry>
  </cfif>
</cfloop>

<!--- If relay host auth is enabled and has credentials --->
<cfif getRelayAuthEnabled.recordcount GTE 1 AND relayUsername is not "" AND relayPassword is not "" AND getRelayHost.recordcount GTE 1 AND getRelayHost.parameter is not "">
  <cfset relayHostVal = getRelayHost.parameter>
  <cfset FileSasl = FileSasl & relayHostVal & Chr(9) & relayUsername & ":" & relayPassword & Chr(10)>
</cfif>

<!--- 2. Per-domain transport credentials --->
<cfquery name="gettransportauth" datasource="hermes">
  SELECT domain, destination, port, authentication_username, authentication_password
  FROM transport WHERE authentication = 'YES'
</cfquery>

<cfloop query="gettransportauth">
  <cfif authentication_username is not "" AND authentication_password is not "">
    <cfset DecryptedUsername = decrypt(authentication_username, hermeskey, "AES", "Base64")>
    <cfset DecryptedPassword = decrypt(authentication_password, hermeskey, "AES", "Base64")>
    <cfset FileSasl = FileSasl & "[" & destination & "]:" & port & Chr(9) & DecryptedUsername & ":" & DecryptedPassword & Chr(10)>
  </cfif>
</cfloop>

<!--- Write sasl_passwd file --->
<cffile action="write" file="/etc/postfix/sasl_passwd" output="#FileSasl#" addnewline="no">

<!--- Postmap sasl_passwd via Docker exec --->
<cfexecute name="/usr/local/bin/docker"
  arguments="exec hermes_postfix_dkim /usr/sbin/postmap /etc/postfix/sasl_passwd"
  timeout="240"
  variable="postmapOutput"
  errorVariable="postmapError" />
