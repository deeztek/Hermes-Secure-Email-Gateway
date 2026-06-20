<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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
Deletes an external encryption recipient from both hermes and djigzo.
Expects: delete_email - The email address to delete
--->

<!--- Delete all S/MIME certificates for this recipient --->
<cfquery name="getExtRec" datasource="hermes">
  SELECT id FROM external_recipients WHERE email = <cfqueryparam value="#delete_email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getExtRec.recordcount GTE 1>
  <!--- Delete all recipient certificates --->
  <cfquery name="getRecCerts" datasource="hermes">
    SELECT * FROM recipient_certificates WHERE user_id = <cfqueryparam value="#getExtRec.id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfloop query="getRecCerts">
    <cfset getcerts = getRecCerts>
    <cfset form.certificate_id = getRecCerts.id>
    <cftry>
      <cfinclude template="delete_smime_certificate.cfm">
      <cfcatch type="any"></cfcatch>
    </cftry>
  </cfloop>

  <!--- Delete all PGP keyrings --->
  <cfquery name="getRecKeys" datasource="hermes">
    SELECT * FROM recipient_keystores WHERE user_id = <cfqueryparam value="#getExtRec.id#" cfsqltype="cf_sql_integer"> AND master = '1'
  </cfquery>
  <cfset url.type = "2">
  <cfloop query="getRecKeys">
    <cfset getkeys = getRecKeys>
    <cfset form.keyring_id = getRecKeys.id>
    <cftry>
      <cfinclude template="delete_pgp_keyring.cfm">
      <cfcatch type="any"></cfcatch>
    </cftry>
  </cfloop>

  <!--- Delete from hermes --->
  <cfquery datasource="hermes">
    DELETE FROM external_recipients WHERE id = <cfqueryparam value="#getExtRec.id#" cfsqltype="cf_sql_integer">
  </cfquery>
</cfif>

<!--- Delete user from Ciphermail via CLITool (handles all FK cascades) --->
<cftry>
  <cfinclude template="generate_customtrans.cfm">
  <cfset scriptContent = "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --delete-user " & delete_email & chr(10)>
  <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_delete_ext_recipient.sh">
  <cffile action="write" file="#scriptPath#" output="#scriptContent#">
  <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="60"></cfexecute>
  <cfexecute name="#scriptPath#" timeout="240" outputfile="/dev/null" arguments=""></cfexecute>
  <cfif fileExists(scriptPath)>
    <cffile action="delete" file="#scriptPath#">
  </cfif>
  <cfcatch type="any"></cfcatch>
</cftry>
