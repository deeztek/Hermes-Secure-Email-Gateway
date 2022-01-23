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

<cfquery name="getrandom_512" datasource="#datasource#" result="getrandom_results">
    select random_letter as random_512 from captcha_list order by RAND() limit 30
    </cfquery>
    
    <cfquery name="insert_salt_512" datasource="#datasource#" result="stResult512">
    insert into salt
    (salt)
    values
    ('<cfoutput query="getrandom_512">#TRIM(random_512)#</cfoutput>')
    </cfquery>
    
    <cfquery name="getsalt_512" datasource="#datasource#">
    select salt as salt_512 from salt where id='#stResult512.GENERATED_KEY#'
    </cfquery>
    
    <cfset salt512=#getsalt_512.salt_512#>
    
    <cfquery name="deletesalt512" datasource="#datasource#">
    delete from salt where id='#stResult512.GENERATED_KEY#'
    </cfquery>
    
    <cfloop index="hashCount" from="1" to="10000">
    <cfset passwordHash512=Hash(form.newpassword & salt512, 'SHA-512', 'UTF-8') />
    </cfloop>
    
    <cfset thePassword="#salt512##passwordHash512#" />
    
    <cfquery name="updatepassword" datasource="#datasource#">
    update user_settings set password='#thePassword#' where id like binary '#session.uid#'
    </cfquery>