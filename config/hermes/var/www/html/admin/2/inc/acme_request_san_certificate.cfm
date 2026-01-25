
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

 
  <cfinclude template="docker_get_directory.cfm">
   <cfinclude template="generate_customtrans.cfm">


  <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_request_cert"
        output = "/usr/local/bin/docker run --rm --name hermes_certbot -v #DockerDir#/config/hermes/var/www/html:/var/www/certbot -v #DockerDir#/config/certbot/conf:/etc/letsencrypt -v #DockerDir#/config/certbot/logs:/var/log certbot/certbot:latest certonly --webroot --webroot-path /var/www/certbot --cert-name #theCertname# --expand #theSan#" addnewline="no">


<cftry>
  
  <cfexecute name = "/usr/local/bin/docker"
  arguments="run --rm --name hermes_certbot -v #DockerDir#/config/hermes/var/www/html:/var/www/certbot -v #DockerDir#/config/certbot/conf:/etc/letsencrypt -v #DockerDir#/config/certbot/logs:/var/log certbot/certbot:latest certonly --webroot --webroot-path /var/www/certbot --cert-name #theCertname# --expand #theSan#"
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

<!--- SEND EMAIL TO POSTMASTER WITH ERROR --->

      <cfquery name="getpostmaster" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>
      
      <cfquery name="getadmin" datasource="hermes">
        select parameter, value from system_settings where parameter='admin_email'
        </cfquery>

<cfquery name="getconsolehost" datasource="hermes">
  select parameter, value2 from parameters2 where parameter='console.host' and module='console'
  </cfquery>


      <cfmail from="#getpostmaster.value#" to="#getadmin.value#" server="hermes_postfix_dkim" subject="[Hermes SEG] Error Notification: Request SAN Certificate Failed" port="10026" type="html">

        <div align="center">

    <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
        
       <h2>Hermes SEG Error Notification</h2>
       
       Hermes SEG encountered an error while attempting to request an Acme SAN certificate. The error reported is: #cfcatch.detail#<br><br>
       
       Please contact Hermes SEG Support.
        </div>
        
        
        </cfmail>

  <cfabort>


</cfcatch>

</cftry>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_acme_output" variable="acmeOutput">


<!---

    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_acme_output">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
  --->


    
  
  