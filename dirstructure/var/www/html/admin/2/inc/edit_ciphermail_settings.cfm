
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<cfquery name="get_subjectenable" datasource="hermes">
  select property, value from encryption_settings where property='user.subjectTriggerEnabled'
  </cfquery>
  
  <cfquery name="get_subject_trigger" datasource="hermes">
  select property, value from encryption_settings where property='user.subjectTrigger'
  </cfquery>
  
  <cfquery name="get_removesubjecttrigger" datasource="hermes">
  select property, value from encryption_settings where property='user.subjectTriggerRemovePattern'
  </cfquery>
  
  <cfquery name="get_portal_url" datasource="hermes">
  select value2 from parameters2 where parameter='console.host' and module='console'
  </cfquery>
  
  <cfquery name="get_pdfreply_sender" datasource="hermes">
  select property, value from encryption_settings where property='user.pdf.replySender'
  </cfquery>
  
  <cfquery name="get_serverkeyword" datasource="hermes">
  select property, value from encryption_settings where property='user.serverSecret'
  </cfquery>

<cfif #get_serverkeyword.value# is "">

<!--- GENERATE SERVER KEYWORD --->
<cfinclude template="generate_ciphermail_server_secret.cfm">

<cfelse>
    
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    
<!-- DECRYPT KEYWORD -->
<cfset theServerKeyword = decrypt(get_serverkeyword.value, #hermeskey#, "AES", "Base64")>
        
<!-- /CFIF #get_serverkeyword.value# is ""  -->
</cfif>

  <cfquery name="get_clientkeyword" datasource="hermes">
  select property, value from encryption_settings where property='user.clientSecret'
  </cfquery>

<cfif #get_clientkeyword.value# is "">

<!--- GENERATE CLIENT KEYWORD --->
<cfinclude template="generate_ciphermail_client_secret.cfm">

<cfelse>
    
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    
<!-- DECRYPT KEYWORD -->
<cfset theClientKeyword = decrypt(get_clientkeyword.value, #hermeskey#, "AES", "Base64")>
    
<!-- /CFIF #get_clientkeyword.value# is ""  -->
</cfif>
  
<cfquery name="get_mailkeyword" datasource="hermes">
select property, value from encryption_settings where property='user.systemMailSecret'
</cfquery>
  
<cfif #get_mailkeyword.value# is "">

  <!--- GENERATE MAIL KEYWORD --->
<cfinclude template="generate_ciphermail_mail_secret.cfm">

<cfelse>
    
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    
<!-- DECRYPT KEYWORD -->
<cfset theMailKeyword = decrypt(get_mailkeyword.value, #hermeskey#, "AES", "Base64")>
    
<!-- /CFIF #get_mailkeyword.value# is ""  -->
</cfif>

  <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    
    <cffile action="read" file="/opt/hermes/scripts/edit_encryption_settings.sh" variable="temp">
    
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","PDFREPLY-SENDER","#get_pdfreply_sender.value#","ALL")#" addnewline="no">
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","PORTAL-URL","https://#get_portal_url.value2#/web/portal","ALL")#" addnewline="no">
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","SUBJECT-TRIGGER","#get_subject_trigger.value#","ALL")#" addnewline="no">
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","SUBJECT-ENABLE","#get_subjectenable.value#","ALL")#" addnewline="no">
        
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","TRIGGER-REMOVE","#get_removesubjecttrigger.value#","ALL")#" addnewline="no">
        
        
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","SERVER-SECRET","#theServerKeyword#","ALL")#" addnewline="no">
        
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","CLIENT-SECRET","#theClientKeyword#","ALL")#" addnewline="no">
        
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
        output = "#REReplace("#temp#","MAIL-SECRET","#theMailKeyword#","ALL")#" addnewline="no">
    
    <cftry>
    
      <cfexecute name = "/bin/chmod"
      arguments="+x /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
      timeout = "60">
      </cfexecute>
        
        <cfcatch type="any">
  
        <cfset m="Edit Ciphermail Settings: There was an /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh executable">
        <cfinclude template="error.cfm">
        <cfabort>   
  
        </cfcatch>
        </cftry>


    <cftry>
    
      <cfexecute name = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
      timeout = "240"
      outputfile ="/dev/null"
      arguments="-inputformat none">
      </cfexecute>
        
        <cfcatch type="any">
  
        <cfset m="Edit Ciphermail Settings: There was an error executing /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh">
        <cfinclude template="error.cfm">
        <cfabort>   
  
        </cfcatch>
        </cftry>



<!--- delete /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh")>
  
  <cffile
  action = "delete"
  file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh">    
  
  </cfif>
    

  