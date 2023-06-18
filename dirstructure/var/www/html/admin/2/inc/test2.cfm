<!--- GET UUID --->
<cfinclude template="dmi_decode.cfm">

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
        
    <cfoutput>#theUuid##chr(64)##recipients##chr(64)##domainsspecified##chr(64)##domainsany##chr(64)##virtual##chr(64)##getversion.value##chr(64)##getbuild.value##chr(64)##gettimezone.value##chr(64)##edition##chr(64)##ConsoleCertificate##chr(64)##SmtpCertificate##chr(64)##CleanMessages##chr(64)##SpamMessages##chr(64)##VirusMessages#</cfoutput>