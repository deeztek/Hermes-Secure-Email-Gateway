
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfquery name="smtpd_tls_security_level_id" datasource="hermes">
select id from parameters where parameter='smtpd_tls_security_level' and enabled='1'
</cfquery>
      
<cfquery name="smtpd_tls_security_level" datasource="hermes">
select parameter from parameters where parent='#smtpd_tls_security_level_id.id#' and child='1' and enabled='1' order by order1 asc
</cfquery>

<cfquery name="smtpd_tls_certificate" datasource="hermes">
select value2 from parameters2 where module = 'certificates' and parameter = 'smtp.certificate'
</cfquery>

<cfquery name = "getcertdetails" datasource="hermes">
select id, subject, issuer, serial, type, friendly_name from system_certificates where id = '#smtpd_tls_certificate.value2#'
</cfquery>