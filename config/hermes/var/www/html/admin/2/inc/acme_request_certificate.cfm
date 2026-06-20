
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cfinclude template="generate_customtrans.cfm">
  
  <cfinclude template="docker_get_directory.cfm">


  
  <cfif #form.acmeserver# is "staging"> 

  <cftry>

  <cfexecute name = "/usr/local/bin/docker"
  arguments="run --rm --name hermes_certbot --network host --dns 8.8.8.8 --dns 8.8.4.4 -v #DockerDir#/config/hermes/var/www/html:/var/www/certbot -v #DockerDir#/config/certbot/conf:/etc/letsencrypt -v #DockerDir#/config/certbot/logs:/var/log certbot/certbot:latest certonly --webroot --webroot-path /var/www/certbot --email #form.email# --agree-tos --no-eff-email --dry-run -d #form.domainname#"
  outputFile="/opt/hermes/tmp/#customtrans3#_acme_output"
  timeout = "120">
  </cfexecute>

<cfcatch type="any">

    <!--- DEBUG --->
  <!---
  <cfdump var="#cfcatch#">
    --->

  <!---  
    <cffile action = "append"
    file = "/opt/hermes/tmp/acme_error.log"
    output = "#cfcatch.detail#">
  --->

<cfset step=0>
<cfset session.m="#cfcatch.detail#">
<cfset session.alerttype="error">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>
  
  </cfcatch>

</cftry>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_acme_output" variable="acmeOutput">


    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_acme_output">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>

<cfif FindNoCase("The dry run was successful", acmeOutput)>

<cfset step=0>
<cfset session.m="Staging Acme Certificate Requested successfully">
<cfset session.alerttype="success">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>

<cfelse>

<cfset step=0>
<cfset session.m="#acmeOutput#">
<cfset session.alerttype="error">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>

<!--- /CFIF FindNoCase --->
</cfif>



<cfelseif #form.acmeserver# is "production">

  <cftry>
  
  <cfexecute name = "/usr/local/bin/docker"
  arguments="run --rm --name hermes_certbot --network host --dns 8.8.8.8 --dns 8.8.4.4 -v #DockerDir#/config/hermes/var/www/html:/var/www/certbot -v #DockerDir#/config/certbot/conf:/etc/letsencrypt -v #DockerDir#/config/certbot/logs:/var/log certbot/certbot:latest certonly --webroot --webroot-path /var/www/certbot --email #form.email# --agree-tos --no-eff-email -d #form.domainname#"
  outputFile="/opt/hermes/tmp/#customtrans3#_acme_output"
  timeout = "120">
  </cfexecute>

  
  <cfcatch type="any">

    <!--- DEBUG --->
  <!---
  <cfdump var="#cfcatch#">
    --->

  <!---  
    <cffile action = "append"
    file = "/opt/hermes/tmp/acme_error.log"
    output = "#cfcatch.detail#">
  --->

<cfset step=0>
<cfset session.m="#cfcatch.detail#">
<cfset session.alerttype="error">
  
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput> 
    
  </cfcatch>

</cftry>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_acme_output" variable="acmeOutput">


    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_acme_output">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>


<cfif FindNoCase("Successfully received certificate", acmeOutput)>

<!--- PARSE CERTIFICATE DETAILS --->
<cfset path = "/etc/letsencrypt/live/#form.domainname#/fullchain.pem">
<cfinclude template="parse_certificate_details.cfm">
  
  
  <cfquery name="insertcert" datasource="hermes">
    INSERT INTO system_certificates
    (type, subject, issuer, serial, fingerprint, file_name, friendly_name, domain_name, san)
    VALUES
    ('Acme',
     <cfqueryparam value="#subject#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#issuer#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#serial#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#fingerprint#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.domainname#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.certificate_name#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.domainname#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#san#" cfsqltype="cf_sql_varchar">)
  </cfquery>

  <cfinclude template="acme_enable_tasks.cfm">
  <cfinclude template="ofelia_generate_config.cfm">



<cfset step=0>
<cfset session.m="Production Acme Certificate Requested successfully">
<cfset session.alerttype="success">


<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>   


<cfelseif FindNoCase("Certificate not yet due for renewal", acmeOutput)>

<cfset step=0>
<cfset session.m="There was an error while attempting to request Acme Certificate. The certificate already exists and is not yet due for renewal">
<cfset session.alerttype="error">


<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>    

<cfelse>

<cfset step=0>
<cfset session.m="#acmeOutput#">
<cfset session.alerttype="error">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>
 

  <!--- /CFIF FindNoCase --->
</cfif>

<!--- /CFIF #form.acmeserver# is --->
</cfif>




    