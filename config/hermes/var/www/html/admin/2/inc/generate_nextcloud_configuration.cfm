

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
    
  <!--- READ OIDC CLIENT SECRET PLAIN --->
  <cffile action="read" file="/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_plain_file" variable="oidcclientplain">

<!--- GET SERVER URL FOR OIDC_LOGIN_PROVIDER_URL --->
<cfquery name = "getconsolehost" datasource = "hermes">
select value2 from parameters2 where module = 'console' and parameter = 'console.host'
</cfquery>

<cfset consoleHost = "#getconsolehost.value2#">

<!--- READ NEXTCLOUD CONFIG.PHP TEMPLATE --->
    <cffile action="read" file="/opt/hermes/templates/config.php" variable="config">
     
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_config.php"
  output = "#REReplace("#config#","OIDC_LOGIN_CLIENT_SECRET","#oidcclientplain#","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_config.php" variable="config">
   
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_config.php"
  output = "#REReplace("#config#","OIDC_LOGIN_PROVIDER_URL","https://#consoleHost#","ALL")#"> 
      
  
 <!--- BACKUP EXISTING CONFIG.PHP FILE ---> 
  <cffile action="copy" 
  source = "/mnt/data/nextcloud/config/config.php"
  destination="/mnt/data/nextcloud/config/config.HERMES">
  
  <!--- REPLACE EXISTING CONFIG.PHP FILE WITH NEWLY GENERATED ONE --->
  <cffile action="move" 
  source = "/opt/hermes/tmp/#customtrans3#_config.php"
  destination="/mnt/data/nextcloud/config/config.php">

<!--- GIVE PROPER PERMISSIONS TO CONFIG.PHP --->
<cftry>

 <cfexecute name = "/usr/local/bin/docker"
 arguments="exec hermes_nextcloud /usr/bin/chown www-data:www-data /var/www/html/config/config.php"
timeout = "240">
</cfexecute>


 <cfcatch type="any">


    <cfset m="Nextcloud: There was an error setting permissions to /var/www/html/config/config.php">
    <cfinclude template="error.cfm">
    <cfabort>   

  </cfcatch>


 </cftry>
  
  
  