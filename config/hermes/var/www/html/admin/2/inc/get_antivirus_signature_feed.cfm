
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfquery name="getantivirusfeed" datasource="hermes">
select name, enabled, update_int from malware_feeds where id = '#theID#'
</cfquery>

<cfquery name="getantivirusfeedurl" datasource="hermes">
  select name, value, feed, type from malware_databases where feed = '#theID#' and type = 'feedurl'
  </cfquery>

<cfquery name="getantivirusfeedvariables" datasource="hermes">
select name, value, active, feed, type from malware_databases where feed = '#theID#' and active = 'true' and type = 'variable'
</cfquery>

<cfquery name="getantivirusfeeddatabases" datasource="hermes">
select name, filename, value, active, feed, type  from malware_databases where feed = '#theID#' and active = 'true' and type = 'database'
</cfquery>
  


