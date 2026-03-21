
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


<!--- CHECK SYSTEM UPDATE --->
<cfinclude template="check_system_update.cfm">

<cfquery name="updatedailycheck" datasource="hermes">
update system_settings set value='#form.update_check#' where parameter='daily_update_check'
</cfquery>

<!--- Enable/disable update check job in Ofelia --->
<cfif form.update_check is "1">
  <cfquery datasource="hermes">
    UPDATE ofelia_jobs SET active = '1' WHERE job_name = '[job-exec "hermes-update-check"]'
  </cfquery>
<cfelse>
  <cfquery datasource="hermes">
    UPDATE ofelia_jobs SET active = '2' WHERE job_name = '[job-exec "hermes-update-check"]'
  </cfquery>
</cfif>
<cfinclude template="ofelia_generate_config.cfm">



