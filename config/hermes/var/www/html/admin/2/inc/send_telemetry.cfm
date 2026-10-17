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
      
        select count(recipient) as domainsspecified from recipients where domain = '1' and (status = '' or status is null)
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

            
<!--- ENCRYPT AND SEND.
     Receiver: https://telemetry.hermesseg.io/ (dedicated host; the old
     updates.deeztek.com endpoint is defunct). The wire format is unchanged:
     one RSA block encrypted with /opt/hermes/ssl/public.pem, posted as a file
     field named <token>_telemetryfile.ssl plus a customtrans field.

     Failures are logged to the hermes log and never stop the nightly job
     that includes this file. Before this, every failure was silent, so a
     broken receiver (an expired certificate) went unnoticed for weeks. The
     unencrypted payload is deleted whatever happens. --->
<cfinclude template="generate_customtrans.cfm">
<cfset telemetryPlain = "/opt/hermes/tmp/#customtrans3#_telemetryfile">
<cfset telemetryEnc = "/opt/hermes/tmp/#customtrans3#_telemetryfile.ssl">
<cftry>
    <cffile action="write" file="#telemetryPlain#" output="#theUuid##chr(64)##recipients##chr(64)##domainsspecified##chr(64)##domainsany##chr(64)##virtual##chr(64)##getversion.value##chr(64)##getbuild.value##chr(64)##gettimezone.value##chr(64)##edition##chr(64)##ConsoleCertificate##chr(64)##SmtpCertificate##chr(64)##CleanMessages##chr(64)##SpamMessages##chr(64)##VirusMessages#" addnewline="no">

    <cfexecute name="/usr/bin/openssl"
        arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in #telemetryPlain# -out #telemetryEnc#"
        timeout="60">
    </cfexecute>
    <cfif NOT FileExists(telemetryEnc)>
        <cfthrow message="openssl produced no encrypted file">
    </cfif>

    <cfhttp method="post" url="https://telemetry.hermesseg.io/" timeout="60" throwonerror="false" result="telemetryResult">
        <cfhttpparam type="file" name="#customtrans3#_telemetryfile.ssl" file="#telemetryEnc#">
        <cfhttpparam type="formfield" name="customtrans" value="#customtrans3#">
    </cfhttp>

    <cfif NOT (IsDefined("telemetryResult.status_code") AND telemetryResult.status_code EQ 200)>
        <cflog file="hermes" type="warning"
               text="send_telemetry: telemetry.hermesseg.io did not accept the report: #IsDefined('telemetryResult.statuscode') ? telemetryResult.statuscode : 'no response'# #Left(IsDefined('telemetryResult.errordetail') ? telemetryResult.errordetail : '', 200)#">
    </cfif>
    <cfcatch type="any">
        <cflog file="hermes" type="warning" text="send_telemetry: not sent: #cfcatch.message#">
    </cfcatch>
    <cffinally>
        <cfif FileExists(telemetryPlain)><cffile action="delete" file="#telemetryPlain#"></cfif>
        <cfif FileExists(telemetryEnc)><cffile action="delete" file="#telemetryEnc#"></cfif>
    </cffinally>
</cftry>

<!--- /CFIF #checktelemetry.value# is "1" --->
</cfif>
    
          
    
    
    
    