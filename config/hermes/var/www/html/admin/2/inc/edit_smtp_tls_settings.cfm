
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

   <!--- VALIDATE PARAMETERS BELOW --->


<cfif NOT StructKeyExists(form, "tlsmode")>
  
  <cfset m="Set SMTP TLS Mode: form.tlsmode does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "tlsmode")>

<cfif #form.tlsmode# is "" OR #form.tlsmode# is "may" OR #form.tlsmode# is "encrypt">

<!--- PARENT ID NO LONGER USED
<cfquery name="smtpd_tls_security_level_id" datasource="hermes">
select id from parameters where parameter='smtpd_tls_security_level' and enabled='1'
</cfquery>
--->

<cfquery name="update" datasource="hermes">
update parameters set parameter = '#form.tlsmode#' where parent_name = 'smtpd_tls_security_level' and child='1' and enabled='1' 
</cfquery>

<!--- PARENT ID NO LONGER USED
<cfquery name="smtp_tls_security_level_id" datasource="hermes">
  select id from parameters where parameter='smtp_tls_security_level' and enabled='1'
  </cfquery>
--->

  <cfquery name="update" datasource="hermes">
  update parameters set parameter = '#form.tlsmode#' where parent_name = 'smtp_tls_security_level' and child='1' and enabled='1' 
  </cfquery>


<cfset step=1>

<cfelse>

  <cfset m="Set SMTP TLS Mode: form.tlsmode is not blank, may or encrypt">
  <cfinclude template="error.cfm">
  <cfabort>

<!--- /CFIF #form.tlsmode# is "" OR #form.tlsmode# is "may" OR #form.tlsmode# is "encrypt" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "tlsmode") --->  
</cfif>

  
<cfif #step# is "1">
    
<cfif NOT StructKeyExists(form, "certificateno_1")>
    
<cfset m="Edit Console Settings: certificateno_1 does not exist">
<cfinclude template="error.cfm">
<cfabort>
  
<cfelse>

<cfif #form.certificateno_1# is "">

<cfif #form.tlsmode# is "">

<cfset certpath = "">
<cfset keypath = "">
<cfset capath = "">

<cfset step=3>

<cfelse>

<cfset step=0>
<cfset session.m=1>
          
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>

<!--- /CFIF #form.tlsmode# --->
</cfif>
  
<cfelseif #form.certificateno_1# is "1">

<cfset step=0>
<cfset session.m=3>
          
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>

<cfelse>

<cfquery name="checkcertificate" datasource="hermes">
select type, file_name from system_certificates where id=<cfqueryparam value = #form.certificateno_1# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkcertificate.recordcount# LT 1>

<cfset step=0>
<cfset session.m=2>
          
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>

<cfelse>

<!--- UPDATE SMTP CERTIFICATE IN PARAMETERS2 --->
<cfquery name="update" datasource="hermes">
update parameters2 set value2='#form.certificateno_1#', applied='2' where parameter='smtp.certificate'
</cfquery>  


  <cfif #checkcertificate.type# is "Imported">
  
  <cfset certpath = "/opt/hermes/ssl/#checkcertificate.file_name#_hermes.pem">
  <cfset keypath = "/opt/hermes/ssl/#checkcertificate.file_name#_hermes.key">
  <cfset capath = "/opt/hermes/ssl/#checkcertificate.file_name#_hermes.chain.pem">

  <cfelseif #checkcertificate.type# is "Acme">
      
  <cfset certpath = "/etc/letsencrypt/live/#checkcertificate.file_name#/cert.pem">
  <cfset keypath = "/etc/letsencrypt/live/#checkcertificate.file_name#/privkey.pem">
  <cfset capath = "/etc/letsencrypt/live/#checkcertificate.file_name#/chain.pem">
      
  <!--- /CFIF #checkcertificate.type# is --->
  </cfif>
  
<cfset step=3>

<!--- /CFIF checkcertificate.recordcount --->
</cfif>
  
<!--- /CFIF form.certificateno_1 is  --->
</cfif>
    
<!--- /CFIF StructKeyExists(form, "certificateno_1") --->
</cfif>

<!--- /CFIF for step is 1 --->
</cfif>

 
<cfif #step# is "3">

<!--- PARENT ID NO LONGER USED
<cfquery name="smtpd_tls_CAfile_id" datasource="hermes">
  select id from parameters where parameter='smtpd_tls_CAfile' and enabled='1'
  </cfquery>

  --->
  
<!--- PARENT ID NO LONGER USED
<cfquery name="smtpd_tls_cert_file_id" datasource="hermes">
select id from parameters where parameter='smtpd_tls_cert_file' and enabled='1'
</cfquery>
--->

<!--- PARENT ID NO LONGER USED
<cfquery name="smtpd_tls_key_file_id" datasource="hermes">
select id from parameters where parameter='smtpd_tls_key_file' and enabled='1'
</cfquery>
--->

<!--- SET smtpd_tls_CAfile --->
<cfquery name="update_smtpd_tls_CAfile" datasource="hermes">
update parameters set parameter='#capath#' where parent_name = 'smtpd_tls_CAfile' and child='1' and enabled='1'
</cfquery>

<!--- SET smtpd_tls_cert_file --->
<cfquery name="update_smtpd_tls_cert_file" datasource="hermes">
update parameters set parameter='#certpath#' where parent_name = 'smtpd_tls_cert_file' and child='1' and enabled='1'
</cfquery>

<!--- SET smtpd_tls_key_file --->
<cfquery name="update_smtpd_tls_key_file" datasource="hermes">
update parameters set parameter='#keypath#' where parent_name = 'smtpd_tls_key_file' and child='1' and enabled='1'
</cfquery>


<!--- /CFIF for step 3 --->
</cfif>
