
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfquery name="console_mode" datasource="hermes">
select value2 from parameters2 where module = 'console' and parameter = 'console.mode'
</cfquery>
      
<cfif #console_mode.value2# is "ip">

  <!--- GET SYSTEM IP --->
  <cfinclude template="get_system_ip.cfm">
  
  <cfquery name="update" datasource="hermes">
  update parameters2 set value2='#theIpAddress#', applied='2' where parameter='console.host'
  </cfquery>  

<!--- /CFIF #console_mode.value2# is "ip" --->
</cfif>