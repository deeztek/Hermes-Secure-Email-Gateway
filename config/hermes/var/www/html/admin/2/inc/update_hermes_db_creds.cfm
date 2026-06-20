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

<cftry>
    <cfset encrypted_mysql_password_hermes=encrypt(show_mysql_password_hermes, #authkey#, #algo#, #encoding#)>
    
    <cfcatch type="any">
    
    <cfif FindNoCase("Illegal key size", cfcatch.Message)>

        <cfset errormessage=26>
        <cfset step=0>
    
    <!--- <cfdump var="#cfcatch#" abort /> --->
    
    
    <!--- /CFIF FindNoCase --->
    </cfif>
    
    </cfcatch>
    
    <cfquery name="updateusername" datasource="hermes">
    update system_settings set value='#form.mysql_username_hermes#' where parameter='mysql_username_hermes'
    </cfquery>
    
    <cfquery name="password" datasource="hermes">
    update system_settings set value='#encrypted_mysql_password_hermes#' where parameter='mysql_password_hermes'
    </cfquery>
    
    
    </cftry>
    