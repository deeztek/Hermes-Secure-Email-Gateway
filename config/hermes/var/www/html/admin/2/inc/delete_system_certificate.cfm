
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfquery name="checkweb" datasource="hermes">
  select parameter, value2 from parameters2 where parameter = 'console.certificate' and value2 =<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER"> and module = 'console'
  </cfquery>

<cfif #checkweb.recordcount# GTE 1>

<cfset step=0>
<cfset session.m="The Certificate you are attempting to delete is assigned to the Web Service">
<cfset session.alerttype="error">

  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>

<!--- /CFIF checkweb.recordcount --->
</cfif>


<cfquery name="checksmtp" datasource="hermes">
  select parameter, value2 from parameters2 where parameter = 'smtp.certificate' and value2 =<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER"> and module = 'certificates'
  </cfquery>

<cfif #checksmtp.recordcount# GTE 1>


  <cfset step=0>
<cfset session.m="The Certificate you are attempting to delete is assigned to the SMTP Service">
<cfset session.alerttype="error">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>

  <!--- /CFIF checksmtp.recordcount --->
</cfif>

<cfquery name="checkmail" datasource="hermes">
  select parameter, value2 from parameters2 where parameter = 'mail.certificate' and value2 =<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER"> and module = 'certificates'
  </cfquery>

<cfif #checkmail.recordcount# GTE 1>


  <cfset step=0>
<cfset session.m="The Certificate you are attempting to delete is assigned to the Mail Service">
<cfset session.alerttype="error">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>

  <!--- /CFIF checksmtp.recordcount --->
</cfif>

<cfquery name="getcertdetails" datasource="hermes">
select id, type, file_name from system_certificates where id=<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getcertdetails.recordcount# GTE 1>

  <cfinclude template="generate_customtrans.cfm">

<cfif #getcertdetails.type# is "Imported">

  <!--- DELETE BUNDLE --->
      <!--- Delete File --->
      <cfset FiletoDelete="/opt/hermes/ssl/#getcertdetails.file_name#_hermes.bundle.pem">
      <cfif fileExists(FiletoDelete)> 
      <cffile action="delete" 
      file = "#FiletoDelete#">
      
      <!--- /CFIF FiletoDelete --->
      </cfif>

  <!--- DELETE CHAIN --->
      <!--- Delete File --->
      <cfset FiletoDelete="/opt/hermes/ssl/#getcertdetails.file_name#_hermes.chain.pem">
      <cfif fileExists(FiletoDelete)> 
      <cffile action="delete" 
      file = "#FiletoDelete#">
      
      <!--- /CFIF FiletoDelete --->
      </cfif>

  <!--- DELETE KEY --->
      <!--- Delete File --->
      <cfset FiletoDelete="/opt/hermes/ssl/#getcertdetails.file_name#_hermes.key">
      <cfif fileExists(FiletoDelete)> 
      <cffile action="delete" 
      file = "#FiletoDelete#">
      
      <!--- /CFIF FiletoDelete --->
      </cfif>

  <!--- DELETE PEM --->
      <!--- Delete File --->
      <cfset FiletoDelete="/opt/hermes/ssl/#getcertdetails.file_name#_hermes.pem">
      <cfif fileExists(FiletoDelete)> 
      <cffile action="delete" 
      file = "#FiletoDelete#">
      
      <!--- /CFIF FiletoDelete --->
      </cfif>

<cfquery name = "deletecert" datasource="hermes">
delete from system_certificates where id=<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>


<cfset step=0>
<cfset session.m="Certificate Deleted successfully">
<cfset session.alerttype="success">

<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>

<cfelseif #getcertdetails.type# is "Acme">

  <cftry>
  
    <!---
    <cfexecute name = "/usr/bin/certbot"
    arguments="delete --non-interactive --cert-name #getcertdetails.file_name#"
    outputFile="/opt/hermes/tmp/#customtrans3#_acme_output"
    timeout = "120">
    </cfexecute>
  --->

  <cfinclude template="docker_get_directory.cfm">


  <cfexecute name = "/usr/local/bin/docker"
  arguments="run --rm --name hermes_certbot -v #DockerDir#/config/hermes/var/www/html:/var/www/certbot -v #DockerDir#/config/certbot/conf:/etc/letsencrypt -v #DockerDir#/config/certbot/logs:/var/log certbot/certbot:latest delete --non-interactive --cert-name #getcertdetails.file_name#"
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
      output = "#cfcatch#">
--->
  

<cfset step=0>
<cfset session.m="There was an error deleting the Certificate">
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

    <cfif FindNoCase("Deleted all files relating to certificate", acmeOutput)>

<!--- Delete the SAN rows FIRST, then the certificate they point at.

     Child before parent: if the SAN delete fails, the certificate is still
     there and the operation can be retried. The other order deletes the
     certificate, then throws, leaving orphaned SAN rows behind and reporting
     failure for something that half happened.

     Table and column were BOTH wrong here. This read
     `mailbox_domains_sans.acme_certificate`, and no such table has ever
     existed in this schema: not in config/database/hermes_install.sql, not in
     any updates/*/sql/schema_updates.sql. The real table is `mailbox_sans`
     and its foreign key is `certificate`, which is what the Ofelia-scheduled
     schedule/acme_validate_ip.cfm has always used. Deleting any certificate
     therefore threw "Table 'hermes.mailbox_domains_sans' doesn't exist"
     AFTER the certificate row had already gone. --->
    <cfquery name = "deletesans" datasource="hermes">
    delete from mailbox_sans where certificate=<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

<!--- Delete from system_certificates --->
    <cfquery name = "deletecert" datasource="hermes">
    delete from system_certificates where id=<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
  

<cfset step=0>
<cfset session.m="Certificate Deleted successfully">
<cfset session.alerttype="success">
    
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>   
     
  <cfelse>


<cfset step=0>
<cfset session.m="There was an error deleting the Certificate">
<cfset session.alerttype="error">
    
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>  
    
<!--- /CFIF FindNoCase --->
  </cfif>


<!--- /CFIF getcertdetails.type --->
</cfif>
    
<!--- getcertdetails.recordcount --->  
</cfif>
  
    