
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


   <!--- GET MYSQL OPENDMARC CREDENTIALS BELOW --->
  
   <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
   <cfparam name = "algo" default = "AES">
   <cfparam name = "encoding" default = "Base64">
   
   <!--- GET OPENDMARC MYSQL USERNAME --->
   <cfquery name="get_mysql_username_opendmarc" datasource="hermes">
   select parameter, value from system_settings where parameter='mysql_username_opendmarc'
   </cfquery>
   
   <cfif #get_mysql_username_opendmarc.value# is "">
 
 
   <cfset m="/inc/get_dmarc_mysql_creds: opendmarc mysql username empty">
   <cfinclude template="./inc/error.cfm">
   <cfabort>
   
   
   <cfelseif #get_mysql_username_opendmarc.value# is not "">
   
   <cfset mysqlusernameopendmarc=#get_mysql_username_opendmarc.value#>
   
   </cfif>
   
   <!--- GET OPENDMARC PASSWORD --->
   <cfquery name="get_mysql_password_opendmarc" datasource="hermes">
   select parameter, value from system_settings where parameter='mysql_password_opendmarc'
   </cfquery>
   
   <cfif #get_mysql_password_opendmarc.value# is "">
   
 
     <cfset m="/inc/get_dmarc_mysql_creds: opendmarc mysql password empty">
     <cfinclude template="./inc/error.cfm">
     <cfabort>
   
   
   <cfelseif #get_mysql_password_opendmarc.value# is not "">
   
   
   <!--- DECRYPT OPENDMARC PASSWORD --->
   <cfset mysqlpasswordopendmarc=decrypt(get_mysql_password_opendmarc.value, #authkey#, #algo#, #encoding#)>
   
   </cfif>
   
   <!--- GET MYSQL OPENDMARC CREDENTIALS ABOVE --->