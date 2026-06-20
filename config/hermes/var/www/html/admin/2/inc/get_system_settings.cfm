

 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


<cfquery name="get_admin_email" datasource="hermes">
  select parameter, value from system_settings where parameter='admin_email'
  </cfquery>
  
  <cfquery name="get_postmaster" datasource="hermes">
  select parameter, value from system_settings where parameter='postmaster'
  </cfquery>
  

<cfquery name="get_serial" datasource="hermes">
  select parameter, value from system_settings where parameter='serial'
  </cfquery>
  
  <cfquery name="get_accepted" datasource="hermes">
  select parameter, value from system_settings where parameter='accepted'
  </cfquery>
  
  <cfquery name="get_users" datasource="hermes">
  select parameter, value from system_settings where parameter='users'
  </cfquery>

<cfquery name="get_update" datasource="hermes">
  select parameter, value from system_settings where parameter='daily_update_check'
  </cfquery>

<cfquery name="get_timezone" datasource="hermes">
  select parameter, value from system_settings where parameter='timezone'
  </cfquery>

<cfquery name="get_telemetry" datasource="hermes">
  select parameter, value from system_settings where parameter='telemetry'
  </cfquery>

