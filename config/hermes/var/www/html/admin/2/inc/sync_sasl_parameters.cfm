<!---
Hermes Secure Email Gateway - Sync SASL Parameters
Checks if any domain has authentication enabled or relay host has auth.
Enables/disables smtp_sasl_auth_enable and smtp_sasl_password_maps accordingly.
Call this after changing domain auth settings or relay host auth.
--->

<!--- Check if any domain uses SASL auth --->
<cfquery name="checkDomainAuth" datasource="hermes">
  SELECT COUNT(*) AS cnt FROM transport WHERE authentication = 'YES'
</cfquery>

<!--- Check if relay host uses SASL auth --->
<cfquery name="checkRelayAuth" datasource="hermes">
  SELECT p.name FROM parameters p
  WHERE p.parameter = 'smtp_sasl_password_maps' AND p.child = '2' AND p.name IS NOT NULL AND p.name <> ''
</cfquery>

<cfset saslNeeded = (checkDomainAuth.cnt GT 0 OR checkRelayAuth.recordcount GT 0)>

<cfif saslNeeded>
  <!--- Enable SASL parameters --->
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '1', applied = '2', action = 'APPLY'
    WHERE parameter = 'smtp_sasl_auth_enable' AND child = '2'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '1', applied = '2', action = 'APPLY'
    WHERE parent_name = 'smtp_sasl_auth_enable' AND child = '1'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '1', applied = '2', action = 'APPLY'
    WHERE parameter = 'smtp_sasl_password_maps' AND child = '2'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '1', applied = '2', action = 'APPLY'
    WHERE parent_name = 'smtp_sasl_password_maps' AND child = '1'
  </cfquery>
<cfelse>
  <!--- No SASL auth needed anywhere — disable parameters --->
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '0', applied = '2', action = 'APPLY'
    WHERE parameter = 'smtp_sasl_auth_enable' AND child = '2'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '0', applied = '2', action = 'APPLY'
    WHERE parent_name = 'smtp_sasl_auth_enable' AND child = '1'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '0', applied = '2', action = 'APPLY'
    WHERE parameter = 'smtp_sasl_password_maps' AND child = '2'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '0', applied = '2', action = 'APPLY'
    WHERE parent_name = 'smtp_sasl_password_maps' AND child = '1'
  </cfquery>
</cfif>
