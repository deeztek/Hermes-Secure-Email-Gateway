
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
<cffile action="read" file="/opt/hermes/creds/ciphermail_username" variable="mysqlusernameciphermail">
<cffile action="read" file="/opt/hermes/creds/ciphermail_password" variable="mysqlpasswordciphermail">

<cfset mysqlusernameciphermail = #TRIM(mysqlusernameciphermail)#>
<cfset mysqlpasswordciphermail = #TRIM(mysqlpasswordciphermail)#>

<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS ENDS HERE --->

<!-- MODIFY DJIGZO MYSQL CONFIG STARTS HERE -->

<cffile action="read" file="/opt/hermes/conf_files/hibernate.mysql.connection.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml"
    output = "#REReplace("#postfix#","DJIGZO-USERNAME","#mysqlusernameciphermail#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml"
    output = "#REReplace("#postfix#","DJIGZO-PASSWORD","#mysqlpasswordciphermail#","ALL")#"> 

<!-- MODIFY DJIGZO MYSQL CONFIG ENDS HERE -->

<!-- MAKE BACKUPS OF DJIGZO MYSQL CONFIG FILES STARTS HERE -->

<cffile action = "copy" source = "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" destination = "/usr/share/djigzo/conf/database/hibernate.mysql.connection.HERMES.BACKUP">

<!-- MAKE BACKUPS OF DJIGZO MYSQL CONFIG FILES ENDS HERE -->

<!-- MOVE GENERATED MYSQL CONFIG FILES TO /USR/SHARE/DJIGZO/CONF/DATABASE STARTS HERE  -->

<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml" destination = "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml">

<!-- MOVE GENERATED MYSQL CONFIG FILES TO /USR/SHARE/DJIGZO/CONF/DATABASE ENDS HERE  -->