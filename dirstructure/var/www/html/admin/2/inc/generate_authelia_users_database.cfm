
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

<cfquery name="checkapplied" datasource="hermes">
    SELECT * FROM system_users where applied = '1'
    </cfquery>
    
<cfif #checkapplied.recordcount# GTE 1>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_users_database.yml"
    output = "users:"
    addNewLine = "yes">


    <cfloop query="checkapplied">

    <cffile action="read" file="/opt/hermes/templates/authelia_user_entry" variable="userEntry">
   
    <cfoutput>
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_authelia_user_entry"
        output = "#REReplace("#userEntry#","THE_USERNAME","#username#","ALL")#">
    </cfoutput>

        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_authelia_user_entry" variable="userEntry">
   
        <cfoutput>
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_authelia_user_entry"
            output = "#REReplace("#userEntry#","FIRST_NAME","#first_name#","ALL")#">
        </cfoutput>

        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_authelia_user_entry" variable="userEntry">
   
        <cfoutput>
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_authelia_user_entry"
            output = "#REReplace("#userEntry#","LAST_NAME","#last_name#","ALL")#">
        </cfoutput>

        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_authelia_user_entry" variable="userEntry">
   
        <cfoutput>
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_authelia_user_entry"
            output = "#REReplace("#userEntry#","THE_PASSWORD","#password#","ALL")#">
        </cfoutput>

        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_authelia_user_entry" variable="userEntry">
   
        <cfoutput>
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_authelia_user_entry"
            output = "#REReplace("#userEntry#","THE_EMAIL","#email#","ALL")#">
        </cfoutput>

        
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_authelia_user_entry" variable="userEntry">
   
        <cfoutput>
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_authelia_user_entry"
            output = "#REReplace("#userEntry#","THE_GROUP","#access_control#","ALL")#">
        </cfoutput>

        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_authelia_user_entry" variable="userEntry">

    
        <!--- delete /opt/hermes/tmp/#customtrans3#_authelia_user_entry --->
        <cfset filetoDelete="/opt/hermes/tmp/#customtrans3#_authelia_user_entry">

        <cfif FileExists("#filetoDelete#")>
        <cffile action="delete" file="#filetoDelete#">

        <!--- /CFIF FileExists --->
        </cfif>
     

    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_users_database.yml"
    output = "#userentry#"
    addNewLine = "no">

    <!---

    <cfquery name="updateapplied" datasource="hermes">
    update system_users set applied = '1' where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

--->

    </cfloop>


<!--- Backup Authelia users_database.yml --->
<cffile action = "copy" source = "/etc/authelia/users_database.yml" 
destination = "/etc/authelia/users_database.HERMES">

<!--- Move #customtrans3#_users_database.yml to /etc/authelia/users_database.yml --->
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_users_database.yml" 
destination = "/etc/authelia/users_database.yml">

<cfinclude template="restart_authelia.cfm">

<!--- /CFIF checkapplied.recordcount --->
</cfif>
      
    
   

