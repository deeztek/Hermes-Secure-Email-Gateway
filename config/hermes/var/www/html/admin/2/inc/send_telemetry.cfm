  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


<!--- Check if Telemetry is enabled --->

<CFQUERY NAME="checktelemetry" DATASOURCE="hermes">
    select value from system_settings where parameter = 'telemetry'
    </CFQUERY>
    
    <!--- If telemetry is enabled collect and send telemetry --->
    <cfif #checktelemetry.value# is "1">
    

<!--- GET UUID --->
<cfinclude template="dmi_decode.cfm">

<!--- GET TELEMETRY DATA --->

<cfquery name="getrecipients" datasource="hermes">
    select count(recipient) as recipients from recipients where domain is NULL
    </cfquery>
    
    
    <cfquery name="getdomainsspecified" datasource="hermes">
      
        select count(recipient) as domainsspecified from recipients where domain = '1' and status = '' or status is null
      </cfquery>
    
    <cfquery name="getdomainsany" datasource="hermes">
        select count(recipient) as domainsany from recipients where domain = '1' and status = "OK"
      </cfquery>
    
    <cfquery name="getvirtual" datasource="hermes">
    select count(virtual_address) as virtual from virtual_recipients where system = '2'
      </cfquery>
    
    <cfquery name="getversion" datasource="hermes">
        SELECT value FROM system_settings where parameter = 'version_no'
        </cfquery>
    
    <cfquery name="getbuild" datasource="hermes">
        SELECT value FROM system_settings where parameter = 'build_no'
        </cfquery>
    
    <cfquery name="gettimezone" datasource="hermes">
        SELECT value FROM system_settings where parameter = 'timezone'
        </cfquery>
    
    <cfquery name="getserial" datasource="hermes">
        SELECT value FROM system_settings where parameter = 'serial'
        </cfquery>
    
    <cfquery name="getconsolecertificate" datasource="hermes">
        SELECT value2 FROM parameters2 where parameter = 'console.certificate'
        </cfquery>
    
    <cfquery name="getsmtpcertificate" datasource="hermes">
        SELECT value2 FROM parameters2 where parameter = 'smtp.certificate'
        </cfquery>
    
    <cfquery name="getcleanmessagecount" datasource="hermes">
    select count(mail_id) as cleanmessages from msgs where content like binary 'C'
        </cfquery>
    
    <cfquery name="getspammessagecount" datasource="hermes">
    select count(mail_id) as spammessages from msgs where content like binary 'S' or content like binary 'Y'
    </cfquery>
    
    <cfquery name="getvirusmessagecount" datasource="hermes">
    select count(mail_id) as virusmessages from msgs where content like binary 'V'
    </cfquery>    

<!--- SET TELEMETRY DATA --->

<cfif #getrecipients.recipients# is "">
    <cfset recipients=0>
<cfelse>
    <cfset recipients=#getrecipients.recipients#> 
</cfif>

<cfif #getdomainsspecified.domainsspecified# is "">
    <cfset domainsspecified=0>
<cfelse>
    <cfset domainsspecified=#getdomainsspecified.domainsspecified#> 
</cfif>

<cfif #getdomainsany.domainsany# is "">
    <cfset domainsany=0>
<cfelse>
    <cfset domainsany=#getdomainsany.domainsany#> 
</cfif>

<cfif #getvirtual.virtual# is "">
    <cfset virtual=0>
<cfelse>
    <cfset virtual=#getvirtual.virtual#> 
</cfif>


<cfif #getserial.value# is "">
    <cfset edition="Community">
<cfelse>
    <cfset edition="Pro"> 
</cfif>

<cfif #getconsolecertificate.value2# is "1">
    <cfset ConsoleCertificate="Build-In">
<cfelse>
    <cfset ConsoleCertificate="Other"> 
</cfif>

<cfif #getsmtpcertificate.value2# is "1">
    <cfset SmtpCertificate="Build-In">
<cfelse>
    <cfset SmtpCertificate="Other"> 
</cfif>

<cfif #getcleanmessagecount.cleanmessages# is "">
    <cfset CleanMessages=0>
<cfelse>
    <cfset CleanMessages=#getcleanmessagecount.cleanmessages#> 
</cfif>

<cfif #getspammessagecount.spammessages# is "">
    <cfset SpamMessages=0>
<cfelse>
    <cfset SpamMessages=#getspammessagecount.spammessages#> 
</cfif>

<cfif #getvirusmessagecount.virusmessages# is "">
    <cfset VirusMessages=0>
<cfelse>
    <cfset VirusMessages=#getvirusmessagecount.virusmessages#> 
</cfif>

            
      <!--- GENERATE CUSTOMTRANS --->
    <cfinclude template="generate_customtrans.cfm">
            
            
    <!--- GENERATE/ENCRYPT TELEMETRY WITH PUBLIC KEY STARTS HERE --->
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_telemetryfile"
    output = "#theUuid##chr(64)##recipients##chr(64)##domainsspecified##chr(64)##domainsany##chr(64)##virtual##chr(64)##getversion.value##chr(64)##getbuild.value##chr(64)##gettimezone.value##chr(64)##edition##chr(64)##ConsoleCertificate##chr(64)##SmtpCertificate##chr(64)##CleanMessages##chr(64)##SpamMessages##chr(64)##VirusMessages#" addnewline="no">
      
    
      <cftry> 
    
      <cfexecute name = "/usr/bin/openssl"
        arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_telemetryfile -out /opt/hermes/tmp/#customtrans3#_telemetryfile.ssl"
        timeout = "60">
        </cfexecute>
        
        <cfcatch type="any">
     
            <cfset m="/inc/check_system_update.cfm: Error running /usr/bin/openssl">
            <cfinclude template="error.cfm">
            <cfabort>
    
    
        </cfcatch>
        </cftry>
    
    <!--- GENERATE/ENCRYPT TELEMETRY WITH PUBLIC KEY ENDS HERE --->
    
    <cftry>
    
    <!--- POST TO TELEMETRY SERVER STARTS HERE --->
    
    <CFHTTP METHOD="Post" URL="https://updates.deeztek.com/telemetry.cfm" timeout="60">
          
      <CFHTTPPARAM TYPE="File"
              NAME="#customtrans3#_telemetryfile.ssl"
              FILE="/opt/hermes/tmp/#customtrans3#_telemetryfile.ssl">
              
      <CFHTTPPARAM TYPE="Formfield"
              VALUE="#customtrans3#"
              NAME="customtrans">
              
      </CFHTTP>
      
      <cfcatch type="any">
    
    <!--- Disabling catching errors --->
    <!---
        <cfif #cfcatch.message# contains "invalid call of the function listGetAt">
        
        <cfoutput>
          <cfset m="/inc/check_system_update.cfm: Error reaching server. Error was: #cfcatch.message#. Ensure updates.deeztek.com is accessible via ports 80 and 443 with no SSL interception.">
        </cfoutput>
          <cfinclude template="error.cfm">
          <cfabort>
        
        <!-- /CFIF cfcatch.message -->
        </cfif>
        
    --->
        </cfcatch>
        
        
        </cftry>
    
    
    
          <!--- POST TO TELEMETRY SERVER ENDS HERE --->
          
         <!--- PARSE HTTP STATUS CODE STARTS HERE --->
    
          <cfif #cfhttp.status_code# EQ "200">
    
          <!--- DELETE /opt/hermes/tmp/#form.customtrans#_telemetryfile --->
           <cfset telemetryfile="/opt/hermes/tmp/#customtrans3#_telemetryfile">
          <cfif fileExists(telemetryfile)>
          
          <cffile action = "delete" file = "#telemetryfile#">
          
          <!--- /CFIF fileExists(telemetryfile)> --->
          </cfif>
          
          <!--- DELETE /opt/hermes/tmp/#form.customtrans#_telemetryfile.ssl --->
          <cfset telemetryfile_ssl="/opt/hermes/tmp/#customtrans3#_telemetryfile.ssl">
          <cfif fileExists(telemetryfile_ssl)>
          
          <cffile action = "delete" file = "#telemetryfile_ssl#">
          
          <!--- /CFIF fileExists(telemetryfile_ssl)> --->
          </cfif>
    
     
         <cfelse>
    
     <!--- DELETE /opt/hermes/tmp/#form.customtrans#_telemetryfile --->
     <cfset updatefile="/opt/hermes/tmp/#customtrans3#_telemetryfile">
     <cfif fileExists(updatefile)>
     
     <cffile action = "delete" file = "#updatefile#">
     
     <!-- /CFIF fileExists(updatefile)> -->
     </cfif>
     
     <!--- DELETE /opt/hermes/tmp/#form.customtrans#_telemetryfile.ssl --->
     <cfset updatefile_ssl="/opt/hermes/tmp/#customtrans3#_telemetryfile.ssl">
     <cfif fileExists(updatefile_ssl)>
     
     <cffile action = "delete" file = "#updatefile_ssl#">
     
     <!-- /CFIF fileExists(updatefile_ssl)> -->
     </cfif>
      
    <!--- Disabling error page --->
    <!---
    <cfoutput>
      <cfset m="/inc/send_telemetry.cfm: HTTP Status Code: #cfhttp.statuscode#">
    </cfoutput>
    
      <cfinclude template="error.cfm">
    
      <cfabort>  
    
--->
    
          <!--- /CFIF #cfhttp.status_code# --->
          </cfif>

<!--- /CFIF #checktelemetry.value# is "1" --->
</cfif>
    
          
    
    
    
    