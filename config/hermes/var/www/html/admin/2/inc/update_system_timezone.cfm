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


<cfquery name="updatetimezone" datasource="hermes">
update system_settings set value='#form.timezone#' where parameter='timezone'
</cfquery>

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
    

    
    <cftry>
    
    <cfexecute name = "/usr/bin/timedatectl"
    timeout = "240"
    variable ="settimezone"
    arguments="set-timezone #form.timezone#">
    </cfexecute>
    
    
    <cfcatch type="any">
    
    <cfif #cfcatch.detail# contains "Invalid time zone">
    
        <cfset m="/inc/update_system_timezone: Error running /usr/bin/timedatectl. Error was Invalid time zone">
        <cfinclude template="error.cfm">
        <cfabort>

    <!-- /CFIF cfcatch.detail -->
    </cfif>

    </cfcatch>
    </cftry>
    


    
