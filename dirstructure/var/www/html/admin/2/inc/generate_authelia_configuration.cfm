
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

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- GET AUTHELIA SETTINGS  --->
<cfinclude template="get_authelia_settings.cfm">



<!--- GENERATE AUTHELIA CONFIGURATION.YML STARTS HERE --->

<cfquery name = "getconsolemode" datasource="hermes">
select parameter, value2 from parameters2 where parameter='console.mode'
</cfquery>


<cffile action="read" file="/opt/hermes/templates/configuration.yml" variable="authelia">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
    output = "#REReplace("#authelia#","hermes_jwt_secret","#jwt_secret.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cfif #getconsolemode.value2# is "ip">

    <cftry>
       
        <cfexecute name="/opt/hermes/scripts/getip.sh"
        variable="GenerateAutheliaIpAddress"
        timeout="10" />
          
          <cfcatch type="any">
    
          <cfset m="Generate Auth Nginx Configuration: There was an error executing /opt/hermes/scripts/getip.sh">
          <cfinclude template="error.cfm">
          <cfabort>   
    
          </cfcatch>
          </cftry>


<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_access_control_domain","#trim(GenerateAutheliaIpAddress)#","ALL")#" addnewline="no">



<cfelseif #getconsolemode.value2# is "fqdn">

<cfquery name="getconsolehost" datasource="hermes">
select value2 from parameters2 where parameter='console.host' and module='console'
</cfquery>   

<cfif #getconsolehost.value2# is "">

<cfset m="Generate Authelia Configuration: getconsolehost.value is blank">
<cfinclude template="error.cfm">
<cfabort>

<cfelse>

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_access_control_domain","#getconsolehost.value2#","ALL")#" addnewline="no">

<!--- /CFIF getconsolehost.value2 is --->
</cfif>

<!--- /CFIF #getconsolemode.value2# --->
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_authentication_backend_disable_reset_password","#authentication_backend_disable_reset_password.value2#","ALL")#" addnewline="no">

<!--- ACCESS CONTROL NO LONGER A GLOBAL SETTING BUT SET ON A PER USER BASIS  --->
<!---
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_access_control_rules_policy","#form.access_control_rules_policy#","ALL")#" addnewline="no">
--->

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_session_name","#session_name.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_session_secret","#session_secret.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_session_expiration","#session_expiration.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_session_inactivity","#session_inactivity.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_notifier_smtp_host","#notifier_smtp_host.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_notifier_smtp_port","#notifier_smtp_port.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_notifier_smtp_sender","#notifier_smtp_sender.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_notifier_smtp_subject","#notifier_smtp_subject.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_log_level","#log_level.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_log_format","#log_format.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_regulation_max_retries","#regulation_max_retries.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_regulation_find_time","#regulation_find_time.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_regulation_ban_time","#regulation_ban_time.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_duo_disable","#duo_disable.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_duo_hostname","#duo_hostname.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_duo_integration_key","#duo_integration_key.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_duo_secret_key","#duo_secret_key.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_duo_self_enrollment","#duo_self_enrollment.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_storage_encryption_key","#storage_encryption_key.value2#","ALL")#" addnewline="no">

<!--- NOT USED YET 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_storage_mysql_username","#mysqlusernamehermes#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_configuration.yml" variable="authelia">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_configuration.yml"
output = "#REReplace("#authelia#","hermes_storage_mysql_password","#mysqlpasswordhermes#","ALL")#" addnewline="no">

--->


<!--- Backup Authelia configuration.yml --->
<cffile action = "copy" source = "/etc/authelia/configuration.yml" 
destination = "/etc/authelia/configuration.HERMES">

<!--- Move #customtrans3#_configuration.yml to /etc/authelia/configuration.yml --->
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_configuration.yml" 
destination = "/etc/authelia/configuration.yml">

<!--- Restart Authelia --->   
<cfinclude template="restart_authelia.cfm">




