
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
<cffile action="read" file="/opt/hermes/creds/syslog_username" variable="mysqlusernamesyslog">
<cffile action="read" file="/opt/hermes/creds/syslog_password" variable="mysqlpasswordsyslog">

<cfset mysqlusernamesyslog = #TRIM(mysqlusernamesyslog)#>
<cfset mysqlpasswordsyslog = #TRIM(mysqlpasswordsyslog)#>

<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS ENDS HERE --->

<!-- MODIFY RSYSLOG MYSQL CONFIG STARTS HERE -->

<cffile action="read" file="/opt/hermes/conf_files/mysql.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql.conf"
    output = "#REReplace("#postfix#","SYSLOG-USERNAME","#mysqlusernamesyslog#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql.conf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql.conf"
    output = "#REReplace("#postfix#","SYSLOG-PASSWORD","#mysqlpasswordsyslog#","ALL")#"> 

<!-- MODIFY RSYSLOG MYSQL CONFIG ENDS HERE -->

<!-- MAKE BACKUPS OF RSYSLOG MYSQL CONFIG FILES STARTS HERE -->

<cffile action = "copy" source = "/etc/rsyslog.d/mysql.conf" destination = "/etc/rsyslog.d/mysql.HERMES.BACKUP">

<!-- MAKE BACKUPS OF RSYSLOG MYSQL CONFIG FILES ENDS HERE -->

<!-- MOVE GENERATED MYSQL CONFIG FILES TO /ETC/RSYSLOG.D/ STARTS HERE  -->

<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_mysql.conf" destination = "/etc/rsyslog.d/mysql.conf">

<!-- MOVE GENERATED MYSQL CONFIG FILES TO /ETC/RSYSLOG.D/ ENDS HERE  -->