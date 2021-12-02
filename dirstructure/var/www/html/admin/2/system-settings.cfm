<!DOCTYPE html>

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

<h1>System Settings</h1>

<!-- CFML CODE STARTS HERE -->



<cfparam name = "errormessage" default = "0">
<cfparam name = "wizardmessage" default = "0">
<cfparam name = "step" default = "0"> 


<!--- IF WIZARD IS SET TO 2 DISPLAY WIZZARDMESSAGE ERROR MESSAGE ---> 
<cfquery name="checkwizard" datasource="hermes">
select parameter, value from system_settings where parameter='wizard_settings'
</cfquery>
  
  <cfif #checkwizard.value# is "2">
  <cfset wizardmessage=1>
  
  <!--- /CFIF #checkwizard.value# is not ---> 
  </cfif>

  <!--- CHECK IF HERMES.KEY IS EMPTY AND GENERATE IF NECESSARY STARTS HERE  --->
  <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">

  <cfif #authkey# is "">
  
  <!-- GENERATE SECRET KEY -->
  <cfset authkey=generateSecretKey("AES", 256)>
  <cffile action = "write"
  file = "/opt/hermes/keys/hermes.key"
  output = "#authkey#">
  
  <!-- READ SECRET KEY -->
  <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
  
  <!-- /CFIF #authkey# is "" -->
  </cfif>
   
 <cfparam name = "algo" default = "AES">
 <cfparam name = "encoding" default = "Base64">

  <!--- CHECK IF HERMES.KEY IS EMPTY AND GENERATE IF NECESSARY ENDS HERE  --->

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>


<!--- GET SYSTEM SETTINGS PARAMETERS STARTS HERE --->

<cfquery name="get_admin_email" datasource="hermes">
select parameter, value from system_settings where parameter='admin_email'
</cfquery>
  
<cfquery name="get_postmaster" datasource="hermes">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>
  
<cfquery name="get_mysql_username_hermes" datasource="hermes">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>
  
<cfquery name="get_mysql_password_hermes" datasource="hermes">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>


  
<!--- DECRYPT MYSQL HERMES PASSWORD --->

<cfif #get_mysql_password_hermes.value# is not "">
  
<cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>
  
<cfelseif #get_mysql_password_hermes.value# is "">
  
<cfset mysqlpasswordhermes="">
  
</cfif>
  
  
  <cfquery name="get_mysql_username_djigzo" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_username_djigzo'
  </cfquery>
  
  <cfquery name="get_mysql_password_djigzo" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_password_djigzo'
  </cfquery>
  
  <!--- DECRYPT MYSQL DJIGZO PASSWORD --->

  <cfif #get_mysql_password_djigzo.value# is not "">
  
  <cfset mysqlpassworddjigzo=decrypt(get_mysql_password_djigzo.value, #authkey#, #algo#, #encoding#)>
  
  <cfelseif #get_mysql_password_djigzo.value# is "">
  
  <cfset mysqlpassworddjigzo="">
  
  </cfif>
  
  <cfquery name="get_mysql_username_syslog" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_username_syslog'
  </cfquery>
  
  <cfquery name="get_mysql_password_syslog" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_password_syslog'
  </cfquery>
  
  <!--- DECRYPT MYSQL SYSLOG PASSWORD --->

  <cfif #get_mysql_password_syslog.value# is not "">
  
  <cfset mysqlpasswordsyslog=decrypt(get_mysql_password_syslog.value, #authkey#, #algo#, #encoding#)>
  
  <cfelseif #get_mysql_password_syslog.value# is "">
  
  <cfset mysqlpasswordsyslog="">
  
  </cfif>
  
  <cfquery name="get_mysql_username_opendmarc" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_username_opendmarc'
  </cfquery>
  
  <cfquery name="get_mysql_password_opendmarc" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_password_opendmarc'
  </cfquery>

  <!--- DECRYPT MYSQL OPENDMARC PASSWORD --->
  
  <cfif #get_mysql_password_opendmarc.value# is not "">
  
  <cfset mysqlpasswordopendmarc=decrypt(get_mysql_password_opendmarc.value, #authkey#, #algo#, #encoding#)>
  
  <cfelseif #get_mysql_password_opendmarc.value# is "">
  
  <cfset mysqlpasswordopendmarc="">
  
  </cfif>
  
  <cfquery name="get_serial" datasource="hermes">
  select parameter, value from system_settings where parameter='serial'
  </cfquery>
  
  <cfquery name="get_accepted" datasource="hermes">
  select parameter, value from system_settings where parameter='accepted'
  </cfquery>
  
  <cfquery name="get_users" datasource="hermes">
  select parameter, value from system_settings where parameter='users'
  </cfquery>

  <!--- GET SYSTEM SETTINGS PARAMETERS ENDS HERE --->
  
  <cfparam name = "show_admin_email" default = "#get_admin_email.value#"> 
  <cfif IsDefined("form.admin_email") is "True">
  <cfset show_admin_email = form.admin_email>
  </cfif>
  
  <cfparam name = "show_postmaster" default = "#get_postmaster.value#"> 
  <cfif IsDefined("form.postmaster") is "True">
  <cfset show_postmaster = form.postmaster>
  </cfif>
  
  <cfparam name = "show_mysql_username_hermes" default = "#get_mysql_username_hermes.value#"> 
  <cfif IsDefined("form.mysql_username_hermes") is "True">
  <cfset show_mysql_username_hermes = form.mysql_username_hermes>
  </cfif>

  <cfparam name = "mysqlusernamehermes" default = "#get_mysql_username_hermes.value#"> 
  <cfif IsDefined("form.mysql_username_hermes") is "True">
  <cfset mysqlusernamehermes = form.mysql_username_hermes>
  </cfif>
  
  <cfparam name = "show_mysql_password_hermes" default = "#mysqlpasswordhermes#"> 
  <cfif IsDefined("form.mysql_password_hermes") is "True">
  <cfset show_mysql_password_hermes = form.mysql_password_hermes>
  </cfif>
  
  <cfparam name = "show_mysql_username_djigzo" default = "#get_mysql_username_djigzo.value#"> 
  <cfif IsDefined("form.mysql_username_djigzo") is "True">
  <cfset show_mysql_username_djigzo = form.mysql_username_djigzo>
  </cfif>
  
  <cfparam name = "show_mysql_password_djigzo" default = "#mysqlpassworddjigzo#"> 
  <cfif IsDefined("form.mysql_password_djigzo") is "True">
  <cfset show_mysql_password_djigzo = form.mysql_password_djigzo>
  </cfif>
  
  <cfparam name = "show_mysql_username_syslog" default = "#get_mysql_username_syslog.value#"> 
  <cfif IsDefined("form.mysql_username_syslog") is "True">
  <cfset show_mysql_username_syslog = form.mysql_username_syslog>
  </cfif>
  
  <cfparam name = "show_mysql_password_syslog" default = "#mysqlpasswordsyslog#"> 
  <cfif IsDefined("form.mysql_password_syslog") is "True">
  <cfset show_mysql_password_syslog = form.mysql_password_syslog>
  </cfif>
  
  <cfparam name = "show_mysql_username_opendmarc" default = "#get_mysql_username_opendmarc.value#"> 
  <cfif IsDefined("form.mysql_username_opendmarc") is "True">
  <cfset show_mysql_username_opendmarc = form.mysql_username_opendmarc>
  </cfif>
  
  <cfparam name = "show_mysql_password_opendmarc" default = "#mysqlpasswordopendmarc#"> 
  <cfif IsDefined("form.mysql_password_opendmarc") is "True">
  <cfset show_mysql_password_opendmarc = form.mysql_password_opendmarc>
  </cfif>
  
  <cfparam name = "serial" default = "#get_serial.value#"> 
  
  <cfparam name = "show_users" default = "#get_users.value#"> 
  
  <cfparam name = "accepted" default = "#get_accepted.value#">

  <cfif #action# is "edit">


  <cfif #show_postmaster# is not "">
  <cfif IsValid("email", show_postmaster)>

  <cfset domainpart = #trim(ListGetAt(show_postmaster, 2, "@"))#>
  <cfquery name="checkdomain" datasource="hermes">
  select domain from domains where domain='#domainpart#'
  </cfquery>

  <cfif #checkdomain.recordcount# GTE 1>
  <cfset step=1>
  <cfelseif #checkdomain.recordcount# LT 1>
  <cfset step=0>
  <cfset errormessage=4>
    
  <!--- /CFIF CHECKDOMAIN.RECORDCOUNT --->
  </cfif>

  <cfelseif not IsValid("email", show_postmaster)>
  <cfset step=0>
  <cfset errormessage=5>

  <!--- /CFIF ISVALID("EMAIL", SHOW_POSTMASTER) --->
  </cfif>

  <cfelseif #show_postmaster# is "">
  <cfset step=0>
  <cfset errormessage=6>

  <!--- /CFIF SHOW_POSTMASTER --->
  </cfif>
    
    <cfif #step# is "1">
    <cfif #show_admin_email# is not "">
    <cfif IsValid("email", show_admin_email)>
    <cfset step=2>
    <cfelseif not IsValid("email", show_admin_email)>
    <cfset step=0>
    <cfset errormessage=2>
    
    <!--- /CFIF ISVALID("EMAIL", SHOW_ADMIN_EMAIL) --->
    </cfif>

    <cfelseif #show_admin_email# is "">
    <cfset step=0>
    <cfset errormessage=3>

     <!--- /CFIF SHOW_ADMIN_EMAIL IS --->
    </cfif>

    <!--- /CFIF STEP IS "1" --->
    </cfif>
    
    <cfif #step# is "2">
    <cfif #show_mysql_username_hermes# is "">
    <cfset step=0>
    <cfset errormessage=13>
    <cfelseif #show_mysql_username_hermes# is not "">
    <cfset step=3>

    <!--- /CFIF SHOW_MYSQL_USERNAME_HERMES IS --->
    </cfif>

    <!--- /CFIF STEP IS "2" --->
    </cfif>
    
    <cfif #step# is "3">
    <cfif #show_mysql_password_hermes# is "">
    <cfset step=0>
    <cfset errormessage=14>
    <cfelseif #show_mysql_password_hermes# is not "">
    <cfset step=4>

    <!--- /CFIF SHOW_MYSQL_PASSWORD_HERMES IS  --->
    </cfif>

    <!--- /CFIF STEP IS "3" --->
    </cfif>
    
    <cfif #step# is "4">
    <cfif #show_mysql_username_djigzo# is "">
    <cfset step=0>
    <cfset errormessage=17>
    <cfelseif #show_mysql_username_djigzo# is not "">
    <cfset step=5>

    <!--- /CFIF SHOW_MYSQL_USERNAME_DJIGZO IS --->
    </cfif>

    <!--- /CFIF STEP IS "4" --->
    </cfif>
    
    <cfif #step# is "5">
    <cfif #show_mysql_password_djigzo# is "">
    <cfset step=0>
    <cfset errormessage=18>
    <cfelseif #show_mysql_password_djigzo# is not "">
    <cfset step=6>

    <!--- /CFIF SHOW_MYSQL_PASSWORD_DJIGZO IS --->
    </cfif>

     <!--- /CFIF STEP IS "5" --->
    </cfif>
    
    <cfif #step# is "6">
    <cfif #show_mysql_username_syslog# is "">
    <cfset step=0>
    <cfset errormessage=19>
    <cfelseif #show_mysql_username_syslog# is not "">
    <cfset step=7>

    <!--- /CFIF SHOW_MYSQL_USERNAME_SYSLOG IS  --->
    </cfif>

    <!--- /CFIF STEP IS "6" --->
    </cfif>
    
    <cfif #step# is "7">
    <cfif #show_mysql_password_syslog# is "">
    <cfset step=0>
    <cfset errormessage=20>
    <cfelseif #show_mysql_password_syslog# is not "">
    <cfset step=8>

    <!--- /CFIF SHOW_MYSQL_PASSWORD_SYSLOG IS --->
    </cfif>

    <!--- /CFIF STEP IS "7" --->
    </cfif>
    
    <cfif #step# is "8">
    <cfif #show_mysql_username_opendmarc# is "">
    <cfset step=0>
    <cfset errormessage=23>
    <cfelseif #show_mysql_username_opendmarc# is not "">
    <cfset step=9>

    <!--- /CFIF SHOW_MYSQL_USERNAME_OPENDMARC IS --->
    </cfif>

    <!--- /CFIF STEP IS "8" --->
    </cfif>
    
    <cfif #step# is "9">
    <cfif #show_mysql_password_opendmarc# is "">
    <cfset step=0>
    <cfset errormessage=24>
    <cfelseif #show_mysql_password_opendmarc# is not "">
    <cfset step=10>

    <!--- /CFIF SHOW_MYSQL_PASSWORD_OPENDMARC IS --->
    </cfif>

    <!--- /CFIF STEP IS "9" --->
    </cfif>

    <cfif #step# is "10">

    <!--- SET HERMES MYSQL USERNAME AND PASSWORDS ---> 
    <cfoutput>
    <cfset mysql_username="#show_mysql_username_hermes#">
    <cfset mysql_password="#show_mysql_password_hermes#">
    </cfoutput>

    <cfset PassTheStep=11>
    <cfset PassTheError=15>

    <!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS --->
  
    <cfinclude template="../common/validate_db_creds_pass_variables.cfm" />

    <!--- /CFIF STEP IS "10" --->
    </cfif>  

    <cfif #step# is "11">

    <!--- SET DJIGZO USERNAME AND PASSWORDS ---> 
    <cfoutput>
      <cfset mysql_username="#show_mysql_username_djigzo#">
      <cfset mysql_password="#show_mysql_password_djigzo#">
      </cfoutput>
  
      <cfset PassTheStep=12>
      <cfset PassTheError=16>
  
      <!--- VALIDATE DJIGZO DATABASE MYSQL CREDENTIALS --->
    
      <cfinclude template="../common/validate_db_creds_pass_variables.cfm" />
  
    <!--- /CFIF STEP IS "11" --->
    </cfif>  
    
    <cfif #step# is "12">

    <!--- SET SYSLOG MYSQL USERNAME AND PASSWORDS ---> 
    <cfoutput>
      <cfset mysql_username="#show_mysql_username_syslog#">
      <cfset mysql_password="#show_mysql_password_syslog#">
      </cfoutput>
  
      <cfset PassTheStep=13>
      <cfset PassTheError=21>
  
      <!--- VALIDATE SYSLOG DATABASE MYSQL CREDENTIALS --->
    
      <cfinclude template="../common/validate_db_creds_pass_variables.cfm" />
    
    <!--- /CFIF STEP IS "12" --->
    </cfif>  

    <cfif #step# is "13">

      <!--- SET OPENDMARC MYSQL USERNAME AND PASSWORDS ---> 
    <cfoutput>
      <cfset mysql_username="#show_mysql_username_opendmarc#">
      <cfset mysql_password="#show_mysql_password_opendmarc#">
      </cfoutput>
  
      <cfset PassTheStep=14>
      <cfset PassTheError=25>
  
      <!--- VALIDATE OPENDMARC DATABASE MYSQL CREDENTIALS --->
    
      <cfinclude template="../common/validate_db_creds_pass_variables.cfm" />
      
      <!--- /CFIF STEP IS "13" --->
      </cfif>  

      <cfif #step# is "14">

        <cftry>
        <cfset encrypted_mysql_password_hermes=encrypt(show_mysql_password_hermes, #authkey#, #algo#, #encoding#)>
        
        <cfcatch type="any">
        
        <cfif FindNoCase("Illegal key size", cfcatch.Message)>
        <cfset step=0>
        <cfset errormessage=22>
        
        <!--- <cfdump var="#cfcatch#" abort /> --->
        
        
        <!--- /CFIF FindNoCase --->
        </cfif>
        
        </cfcatch>
        
        <cfquery name="update3" datasource="hermes">
        update system_settings set value='#show_mysql_username_hermes#' where parameter='mysql_username_hermes'
        </cfquery>
        
        <cfquery name="update4" datasource="hermes">
        update system_settings set value='#encrypted_mysql_password_hermes#' where parameter='mysql_password_hermes'
        </cfquery>
        
        <cfset step=15>
        
        </cftry>
        
        <!--- /CFIF step is 14 --->
        </cfif>
        
        
        <cfif #step# is "15">
        
        <cftry>
        <cfset encrypted_mysql_password_djigzo=encrypt(show_mysql_password_djigzo, #authkey#, #algo#, #encoding#)>
        
        <cfcatch type="any">
        
        <cfif FindNoCase("Illegal key size", cfcatch.Message)>
        <cfset step=0>
        <cfset errormessage=22>
        
        <!--- <cfdump var="#cfcatch#" abort /> --->
        
        
        <!--- /CFIF FindNoCase --->
        </cfif>
        
        </cfcatch>
        
        <cfquery name="update5" datasource="hermes">
        update system_settings set value='#show_mysql_username_djigzo#' where parameter='mysql_username_djigzo'
        </cfquery>
        
        <cfquery name="update6" datasource="hermes">
        update system_settings set value='#encrypted_mysql_password_djigzo#' where parameter='mysql_password_djigzo'
        </cfquery>
        
        <cfset step=16>
        
        </cftry>
        
        <!--- /CFIF step is 15 --->
        </cfif>
        
        
        <cfif #step# is "16">
        
        <cftry>
        <cfset encrypted_mysql_password_syslog=encrypt(show_mysql_password_syslog, #authkey#, #algo#, #encoding#)>
        
        <cfcatch type="any">
        
        <cfif FindNoCase("Illegal key size", cfcatch.Message)>
        <cfset step=0>
        <cfset errormessage=22>
        
        <!--- <cfdump var="#cfcatch#" abort /> --->
        
        <!--- /CFIF FindNoCase --->
        </cfif>
        
        </cfcatch>
        
        <cfquery name="update7" datasource="hermes">
        update system_settings set value='#show_mysql_username_syslog#' where parameter='mysql_username_syslog'
        </cfquery>
        
        <cfquery name="update8" datasource="hermes">
        update system_settings set value='#encrypted_mysql_password_syslog#' where parameter='mysql_password_syslog'
        </cfquery>
        
        
        <cfset step=17>
        
        </cftry>
        
        <!--- /CFIF step is 16 --->
        </cfif>
        
        <cfif #step# is "17">
        
        <cftry>
        <cfset encrypted_mysql_password_opendmarc=encrypt(show_mysql_password_opendmarc, #authkey#, #algo#, #encoding#)>
        
        <cfcatch type="any">
        
        <cfif FindNoCase("Illegal key size", cfcatch.Message)>
        <cfset step=0>
        <cfset errormessage=22>
        
        <!--- <cfdump var="#cfcatch#" abort /> --->
        
        <!--- /CFIF FindNoCase --->
        </cfif>
        
        </cfcatch>
        
        <cfquery name="update9" datasource="hermes">
        update system_settings set value='#show_mysql_username_opendmarc#' where parameter='mysql_username_opendmarc'
        </cfquery>
        
        <cfquery name="update10" datasource="hermes">
        update system_settings set value='#encrypted_mysql_password_opendmarc#' where parameter='mysql_password_opendmarc'
        </cfquery>
        
        
        <cfset step=18>
        
        </cftry>
        
        <!--- /CFIF step is 17 --->
        </cfif>
        
        
        <cfif #step# is "18">

          <cfquery name="update" datasource="hermes">
          update system_settings set value='#show_admin_email#' where parameter='admin_email'
          </cfquery>
          
          <cfquery name="update2" datasource="hermes">
          update system_settings set value='#show_postmaster#' where parameter='postmaster'
          </cfquery>
          
          <cfquery name="update9" datasource="hermes">
          update system_settings set value='1' where parameter='wizard_settings'
          </cfquery>
          
          
          <cfquery name="checkpostmaster" datasource="hermes">
          delete from virtual_recipients where system='1'
          </cfquery>
          
          <cfquery name="checkpostmaster" datasource="hermes">
          delete from virtual_recipients where virtual_address='#show_postmaster#' and maps='#show_admin_email#'
          </cfquery>
          
          <cfquery name="insertpostmaster" datasource="hermes">
          insert into virtual_recipients
          (virtual_address, maps, system)
          values
          ('#show_postmaster#', '#show_admin_email#', '1')
          </cfquery>
          
          
          <cfset domainpart = #trim(ListGetAt(show_postmaster, 2, "@"))#>
          
          
          <cfquery name="checkroot" datasource="hermes">
          delete from virtual_recipients where virtual_address='root@#domainpart#' and maps='#show_admin_email#'
          </cfquery>
          
          <cfquery name="insertroot" datasource="hermes">
          insert into virtual_recipients
          (virtual_address, maps, system)
          values
          ('root@#domainpart#', '#show_admin_email#', '1')
          </cfquery>
          
          
          <cfquery name="checkabuse" datasource="hermes">
          delete from virtual_recipients where virtual_address='abuse@#domainpart#' and maps='#show_admin_email#'
          </cfquery>
          
          <cfquery name="insertabuse" datasource="hermes">
          insert into virtual_recipients
          (virtual_address, maps, system)
          values
          ('abuse@#domainpart#', '#show_admin_email#', '1')
          </cfquery>

<!--- MODIFY CONFIG FILES WITH NEWLY SET MYSQL USERNAME AND PASSWORDS STARTS HERE --->

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
  
  <!-- MODIFY POSTFIX MYSQL USERNAME AND PASSWORD CONFIG FILES STARTS HERE -->
  
  <!-- MODIFY mysql-aliases.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-aliases.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
  <!-- MODIFY mysql-clients.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-clients.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-clients.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
      
  <!-- MODIFY mysql-domains.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-domains.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-domains.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
  <!-- MODIFY mysql-rbl_override.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-rbl_override.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
      
  <!-- MODIFY mysql-recipients.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-recipients.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
      
  <!-- MODIFY mysql-senders.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-senders.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-senders.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
      
  <!-- MODIFY mysql-transport.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-transport.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-transport.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
  <!-- MODIFY mysql-virtual.cf -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql-virtual.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf"
      output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf"
      output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
      
  <!-- MODIFY POSTFIX MYSQL USERNAME AND PASSWORD CONFIG FILES ENDS HERE -->
  
  <!-- MODIFY DJIGZO MYSQL CONFIG STARTS HERE -->
  
  <cffile action="read" file="/opt/hermes/conf_files/hibernate.mysql.connection.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml"
      output = "#REReplace("#postfix#","DJIGZO-USERNAME","#show_mysql_username_djigzo#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml"
      output = "#REReplace("#postfix#","DJIGZO-PASSWORD","#show_mysql_password_djigzo#","ALL")#"> 
  
  <!-- MODIFY DJIGZO MYSQL CONFIG ENDS HERE -->
  
  <!-- MODIFY RSYSLOG MYSQL CONFIG STARTS HERE -->
  
  <cffile action="read" file="/opt/hermes/conf_files/mysql.HERMES" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql.conf"
      output = "#REReplace("#postfix#","SYSLOG-USERNAME","#show_mysql_username_syslog#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql.conf" variable="postfix">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_mysql.conf"
      output = "#REReplace("#postfix#","SYSLOG-PASSWORD","#show_mysql_password_syslog#","ALL")#"> 
  
  <!-- MODIFY RSYSLOG MYSQL CONFIG ENDS HERE -->

<!--- MODIFY CONFIG FILES WITH NEWLY SET MYSQL USERNAME AND PASSWORDS ENDS HERE --->

<!--- GET /etc/amavis/conf.d/50-user PARAMETERS --->

<cfquery name="server_name" datasource="hermes">
  select * from parameters2 where parameter='server_name' and module='network' and active='1'
  </cfquery>
  
  <cfquery name="server_domain" datasource="hermes">
  select * from parameters2 where parameter='server_domain' and module='network' and active='1'
  </cfquery>
  
  <cfquery name="get_sa_spam_subject_tag" datasource="hermes">
  select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
  </cfquery>
  
  <cfquery name="get_final_virus_destiny" datasource="hermes">
  select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
  </cfquery>
  
  <cfquery name="get_final_banned_destiny" datasource="hermes">
  select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
  </cfquery>
  
  <cfquery name="get_final_spam_destiny" datasource="hermes">
  select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
  </cfquery>
  
  <cfquery name="get_final_bad_header_destiny" datasource="hermes">
  select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
  </cfquery>

<cfset ServerName="#server_name.value2#">
<cfset ServerDomain="#server_domain.value2#">

  <!--- MODIFY /etc/amavis/conf.d/50-user BELOW --->
  
  <cfinclude template="../common/modify_amavis_50_user.cfm" />
  
   <!--- MODIFY /etc/amavis/conf.d/50-user ABOVE --->
  
 <!-- MAKE BACKUPS OF MYSQL CONFIG FILES STARTS HERE -->

<cffile action = "copy" source = "/etc/postfix/mysql-aliases.cf" destination = "/etc/postfix/mysql-aliases.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-clients.cf" destination = "/etc/postfix/mysql-clients.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-domains.cf" destination = "/etc/postfix/mysql-domains.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-rbl_override.cf" destination = "/etc/postfix/mysql-rbl_override.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-recipients.cf" destination = "/etc/postfix/mysql-recipients.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-senders.cf" destination = "/etc/postfix/mysql-senders.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-transport.cf" destination = "/etc/postfix/mysql-transport.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-virtual.cf" destination = "/etc/postfix/mysql-virtual.HERMES.BACKUP">
<cffile action = "copy" source = "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" destination = "/usr/share/djigzo/conf/database/hibernate.mysql.connection.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/rsyslog.d/mysql.conf" destination = "/etc/rsyslog.d/mysql.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/amavis/conf.d/50-user" destination = "/etc/amavis/conf.d/50-user.HERMES.BACKUP">

<!-- MAKE BACKUPS OF MYSQL CONFIG FILES ENDS HERE -->

<!-- COPY MYSQL CONFIG FILES TO APPROPRIATE LOCATIONS STARTS HERE -->

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf" destination = "/etc/postfix/mysql-aliases.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf" destination = "/etc/postfix/mysql-clients.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-clients.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-clients.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf" destination = "/etc/postfix/mysql-domains.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-domains.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-domains.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf" destination = "/etc/postfix/mysql-rbl_override.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf" destination = "/etc/postfix/mysql-recipients.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf" destination = "/etc/postfix/mysql-senders.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-senders.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-senders.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf" destination = "/etc/postfix/mysql-transport.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-transport.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-transport.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf" destination = "/etc/postfix/mysql-virtual.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml" destination =
 "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml">
 
 <cfif FileExists("/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql.conf" destination = "/etc/rsyslog.d/mysql.conf">

 <cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql.conf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql.conf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#50-user" destination = "/etc/amavis/conf.d/50-user">

 <cfif FileExists("/opt/hermes/tmp/#customtrans3#50-user")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#50-user">
</cfif>



<!-- COPY MYSQL CONFIG FILES TO APPROPRIATE LOCATIONS ENDS HERE -->

<cfset errormessage=7>
<cfset wizardmessage=0>

<!--- CFIF STEP 18--->
</cfif> 

<!--- /CFIF #action# --->
</cfif>

<!-- CFML CODE ENDS HERE -->


<!-- CFML APPLICATION ALERTS STARTS HERE -->

<!--- ALERT BELOW NO LONGER USED --->
<!---
<cfif #errormessage# is "1"> 

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Admin E-mail Address must be part of a domain that this system does NOT relay</cfoutput>
    </div>

</cfif>
--->

<cfif #errormessage# is "2">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Admin E-mail Address must be a valid e-mail address</cfoutput>
    </div>

</cfif>

<cfif #errormessage# is "3">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Admin E-mail Address must not be blank</cfoutput>
    </div>

</cfif>


<cfif #errormessage# is "4">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Postmaster E-mail Address must be part of a domain that this system relays</cfoutput>
    </div>

</cfif>

<cfif #errormessage# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Postmaster E-mail Address must must be a valid e-mail address</cfoutput>
  </div>

</cfif>



<cfif #errormessage# is "6">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Postmaster E-mail Address must not be blank</cfoutput>
    </div>

</cfif>

<cfif #errormessage# is "7">

    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Settings updated</cfoutput>
    </div>

</cfif>


<!---
<cfif #errormessage# is "7">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Connection Name field cannot be empty</cfoutput>
    </div>

</cfif>
--->



<cfif #errormessage# is "13">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The MySQL Hermes Database Username must not be blank</cfoutput>
    </div>

</cfif>



<cfif #errormessage# is "14">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The MySQL Hermes Database Password must not be blank</cfoutput>
    </div>

</cfif>


<cfif #errormessage# is "15">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The MySQL Credentials you entered are invalid. Please verify MySQL Hermes Database Username and MySQL Hermes Database Password and try again</cfoutput>
  </div>

</cfif>


<cfif #errormessage# is "16">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The MySQL Credentials you entered are invalid. Please verify MySQL Ciphermail Database Username and MySQL Ciphermail Database Password and try again</cfoutput>
  </div>

</cfif>

        <cfif #errormessage# is "17">

            <div class="alert alert-danger alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fa fa-ban"></i> Oops!</h4>
              <cfoutput>The MySQL Ciphermail Database Username must not be blank</cfoutput>
            </div>
        
        </cfif>

        <cfif #errormessage# is "18">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The MySQL Ciphermail Database Password must not be blank</cfoutput>
          </div>
      
      </cfif>

      <cfif #errormessage# is "19">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The MySQL Syslog Database Username must not be blank</cfoutput>
        </div>
    
    </cfif>

    <cfif #errormessage# is "20">

      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>The MySQL Syslog Database Password must not be blank</cfoutput>
      </div>
  
  </cfif>

  <cfif #errormessage# is "21">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The MySQL Credentials you entered are invalid. Please verify MySQL Syslog Database Username and MySQL Syslog
        Database Password and try again</cfoutput>
    </div>

</cfif>

<cfif #errormessage# is "22">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Unable to save the settings because the sytem doesn't have the Java JCE Unlimited Strength Policy Jars. Please
      follow the instructions on <a href="http://www.deeztek.com/documentation/hermes-seg-documentation/hermes-secure-email-gateway-general-documentation/insall-java-jce-unlimi
     ted-strength-jurisdiction-policy-files/">how to install the Unlimited Strength Policy Jars on Hermes SEG</> and try again</cfoutput>
  </div>

</cfif>

<cfif #errormessage# is "23">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The MySQL OpenDMARC Database Username must not be blank</cfoutput>
  </div>

</cfif>

<cfif #errormessage# is "24">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The MySQL OpenDMARC Database Password must not be blank</cfoutput>
  </div>

</cfif>

<cfif #errormessage# is "25">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The MySQL Credentials you entered are invalid. Please verify MySQL OpenDMARC Database Username and MySQL Syslog Database Password and try again</cfoutput>
  </div>

</cfif>

<cfif #wizardmessage# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must set and save the parameters in this page before you will be allowed to configure the rest of the system</cfoutput>
  </div>

</cfif>



<!-- CFML APPLICATION ALERTS ENDS HERE -->



<!-- ADD AD CONNECTION FORM STARTS HERE -->


<!-- form start -->
  <form action="" method="post">
  <input type="hidden" name="action" value="edit">
    <div class="box-body">
       
      <cfoutput>
      <div class="form-group">
        <label for="postmaster"><strong>Postmaster E-mail Address</strong></label>
        <input type="text" class="form-control" name="postmaster" value="#show_postmaster#" id="postmaster" placeholder="Enter an e-mail address for a domain the system relays">
      </div>
      </cfoutput>

      
        <cfoutput>
            <div class="form-group">
              <label for="admin_email"><strong>Admin E-mail Address</strong></label>
              <input type="text" class="form-control" name="admin_email" value="#show_admin_email#" id="admin_email" placeholder="Enter an e-mail address for a domain the system does NOT relay">
            </div>
            </cfoutput>

            <cfoutput>
              <div class="form-group">
                <label for="mysql_username_hermes"><strong>MySQL Hermes Database Username</strong></label>
                <input type="text" class="form-control" name="mysql_username_hermes" value="#show_mysql_username_hermes#" id="mysql_username_hermes" placeholder="Enter Username for MySQL Hermes Database">
              </div>
              </cfoutput>    
              
              <cfoutput>
                <div class="form-group">
                  <label for="mysql_password_hermes"><strong>MySQL Hermes Database Password</strong></label>
                  <input type="password" class="form-control" name="mysql_password_hermes" value="#show_mysql_password_hermes#" id="mysql_password_hermes" placeholder="Enter Password for MySQL Hermes Database">
                </div>
                </cfoutput>  

                <cfoutput>
                  <div class="form-group">
                    <label for="mysql_username_djigzo"><strong>MySQL Ciphermail Database Username</strong></label>
                    <input type="text" class="form-control" name="mysql_username_djigzo" value="#show_mysql_username_djigzo#" id="mysql_username_djigzo" placeholder="Enter Username for MySQL Ciphermail Database">
                  </div>
                  </cfoutput>    
                  
                  <cfoutput>
                    <div class="form-group">
                      <label for="mysql_password_djigzo"><strong>MySQL Ciphermail Database Password</strong></label>
                      <input type="password" class="form-control" name="mysql_password_djigzo" value="#show_mysql_password_djigzo#" id="mysql_password_djigzo" placeholder="Enter Password for MySQL Ciphermail Database">
                    </div>
                    </cfoutput>  

                    <cfoutput>
                      <div class="form-group">
                        <label for="mysql_username_syslog"><strong>MySQL Syslog Database Username</strong></label>
                        <input type="text" class="form-control" name="mysql_username_syslog" value="#show_mysql_username_syslog#" id="mysql_username_syslog" placeholder="Enter Username for MySQL Syslog Database">
                      </div>
                      </cfoutput>    
                      
                      <cfoutput>
                        <div class="form-group">
                          <label for="mysql_password_syslog"><strong>MySQL Syslog Database Password</strong></label>
                          <input type="password" class="form-control" name="mysql_password_syslog" value="#show_mysql_password_syslog#" id="mysql_password_syslog" placeholder="Enter Password for MySQL Syslog Database">
                        </div>
                        </cfoutput>  

                        <cfoutput>
                          <div class="form-group">
                            <label for="mysql_username_opendmarc"><strong>MySQL Opendmarc Database Username</strong></label>
                            <input type="text" class="form-control" name="mysql_username_opendmarc" value="#show_mysql_username_opendmarc#" id="mysql_username_opendmarc" placeholder="Enter Username for MySQL Opendmarc Database">
                          </div>
                          </cfoutput>    
                          
                          <cfoutput>
                            <div class="form-group">
                              <label for="mysql_password_opendmarc"><strong>MySQL Opendmarc Database Password</strong></label>
                              <input type="password" class="form-control" name="mysql_password_opendmarc" value="#show_mysql_password_opendmarc#" id="mysql_password_opendmarc" placeholder="Enter Password for MySQL Opendmarc Database">
                            </div>
                            </cfoutput>  

                            <cfoutput>
                              <div class="form-group">
                                <label for="serial"><strong>Serial Number</strong></label>
                                <input type="text" class="form-control" name="serial" value="#serial#" id="serial" placeholder="" disabled="disabled">
                              </div>
                              </cfoutput>  

                              <cfoutput>
                                <div class="form-group">
                                  <label for="users"><strong>Number of Licensed Users</strong></label>
                                  <input type="text" class="form-control" name="users" value="#show_users#" id="users" placeholder="Number of Licensed Users" disabled="disabled">
                                </div>
                                </cfoutput>  

       
           

    <div class="box-footer">
<!--- <p class="help-block">Help Block Text</p> --->
      <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
    </div>
  </form>

<!-- ADD AD CONNECTION FORM STARTS HERE -->