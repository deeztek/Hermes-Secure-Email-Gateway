
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

<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS STARTS HERE --->
<cffile action="read" file="/opt/hermes/creds/hermes_username" variable="mysqlusernamehermes">
<cffile action="read" file="/opt/hermes/creds/hermes_password" variable="mysqlpasswordhermes">

<cfset mysqlusernamehermes = #TRIM(mysqlusernamehermes)#>
<cfset mysqlpasswordhermes = #TRIM(mysqlpasswordhermes)#>

<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS ENDS HERE --->

    <!-- MODIFY POSTFIX MYSQL USERNAME AND PASSWORD CONFIG FILES STARTS HERE -->
    
<!-- MODIFY mysql-aliases.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-aliases.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
<!-- MODIFY mysql-clients.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-clients.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-clients.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-domains.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-domains.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-domains.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
<!-- MODIFY mysql-rbl_override.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-rbl_override.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-recipients.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-recipients.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-senders.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-senders.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-senders.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-transport.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-transport.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-transport.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
<!-- MODIFY mysql-virtual.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-virtual.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#"> 
    
<!-- MODIFY POSTFIX MYSQL USERNAME AND PASSWORD CONFIG FILES ENDS HERE -->

<!-- MAKE BACKUPS OF POSTFIX MYSQL CONFIG FILES STARTS HERE -->

<cffile action = "copy" source = "/etc/postfix/mysql-aliases.cf" destination = "/etc/postfix/mysql-aliases.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-clients.cf" destination = "/etc/postfix/mysql-clients.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-domains.cf" destination = "/etc/postfix/mysql-domains.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-rbl_override.cf" destination = "/etc/postfix/mysql-rbl_override.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-recipients.cf" destination = "/etc/postfix/mysql-recipients.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-senders.cf" destination = "/etc/postfix/mysql-senders.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-transport.cf" destination = "/etc/postfix/mysql-transport.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-virtual.cf" destination = "/etc/postfix/mysql-virtual.HERMES.BACKUP">

<!-- MAKE BACKUPS OF POSTFIX MYSQL CONFIG FILES ENDS HERE -->


<!-- MOVE GENERATED MYSQL CONFIG FILES TO /ETC/POSTFIX STARTS HERE  -->

<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf" destination = "/etc/postfix/mysql-aliases.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf" destination = "/etc/postfix/mysql-clients.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf" destination = "/etc/postfix/mysql-domains.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf" destination = "/etc/postfix/mysql-rbl_override.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf" destination = "/etc/postfix/mysql-recipients.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf" destination = "/etc/postfix/mysql-senders.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf" destination = "/etc/postfix/mysql-transport.cf">
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf" destination = "/etc/postfix/mysql-virtual.cf">

<!-- MOVE GENERATED MYSQL CONFIG FILES TO /ETC/POSTFIX ENDS HERE  -->