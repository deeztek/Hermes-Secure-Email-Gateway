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
    <cftry>
      <cfinclude template="delete_smime_certificate.cfm">
      <cfcatch type="any"></cfcatch>
    </cftry>
  </cfloop>

  <!--- Delete all PGP keyrings --->
  <cfquery name="getRecKeys" datasource="hermes">
    SELECT * FROM recipient_keystores WHERE user_id = <cfqueryparam value="#getExtRec.id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfloop query="getRecKeys">
    <cfset getkeys = getRecKeys>
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

<!--- Delete from djigzo --->
<cftry>
  <cfquery datasource="djigzo">
    DELETE FROM cm_properties WHERE cm_email = <cfqueryparam value="#delete_email#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfquery datasource="djigzo">
    DELETE FROM cm_users WHERE cm_email = <cfqueryparam value="#delete_email#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfcatch type="any"></cfcatch>
</cftry>
