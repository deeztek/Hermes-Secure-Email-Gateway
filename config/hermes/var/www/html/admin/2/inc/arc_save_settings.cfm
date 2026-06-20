<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- Save the ARC global settings (master toggle / AuthservID / Mode),
      regenerate openarc.conf, and reload the openarc container.
      Called by view_arc_settings.cfm when form.action is 'save_settings'.

      Note: no KeyTable/SigningTable regeneration step — OpenARC is
      single-identity per RFC 8617 §4.2.2 industry pattern; the active
      Domain/Selector/KeyFile are baked directly into openarc.conf by
      arc_generate_config_file.cfm. --->

<cfif IsDefined("form.arc_signing_enabled") AND form.arc_signing_enabled IS NOT "">
    <cfquery name="update_arc_signing_enabled" datasource="hermes">
        UPDATE system_settings
        SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arc_signing_enabled#">
        WHERE parameter = 'arc_signing_enabled'
    </cfquery>
</cfif>

<cfif IsDefined("form.arc_authserv_id")>
    <cfquery name="update_arc_authserv_id" datasource="hermes">
        UPDATE system_settings
        SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arc_authserv_id#">
        WHERE parameter = 'arc_authserv_id'
    </cfquery>
</cfif>

<cfif IsDefined("form.arc_mode") AND form.arc_mode IS NOT "">
    <cfquery name="update_arc_mode" datasource="hermes">
        UPDATE system_settings
        SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arc_mode#">
        WHERE parameter = 'arc_mode'
    </cfquery>
</cfif>

<!--- Regenerate openarc.conf + reload openarc --->
<cfinclude template="arc_generate_config_file.cfm">
<cfinclude template="restart_openarc.cfm">

<!--- Mark the active row as applied --->
<cfquery name="markarcapplied" datasource="hermes">
    UPDATE arc_sign SET applied = '1' WHERE enabled = '1'
</cfquery>

<cfset session.m = 9>
