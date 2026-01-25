
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cfquery name="console_host" datasource="hermes">
select value2 from parameters2 where module = 'console' and parameter = 'console.host'
</cfquery>

<cfquery name="console_certificate" datasource="hermes">
select value2 from parameters2 where module = 'console' and parameter = 'console.certificate'
</cfquery>

<cfquery name="console_dhparam" datasource="hermes">
  select value2 from parameters2 where module = 'console' and parameter = 'console.dhparam'
  </cfquery>

<cfquery name="console_hsts" datasource="hermes">
  select value2 from parameters2 where module = 'console' and parameter = 'console.hsts'
  </cfquery>
  
  <cfquery name="console_ssl_stapling" datasource="hermes">
    select value2 from parameters2 where module = 'console' and parameter = 'console.ssl_stapling'
    </cfquery>

<cfquery name="console_ssl_stapling_verify" datasource="hermes">
  select value2 from parameters2 where module = 'console' and parameter = 'console.ssl_stapling_verify'
  </cfquery>