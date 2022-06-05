
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

<cfif structKeyExists(url, 'type')>

<cfif #url.type# is "api">
    
    <cfif structKeyExists(url, 'password')>
    
    <cfif #url.password# is not "">
    
    <cfset theHash=hash("#url.password#", "SHA", "UTF-8")>
    <!---
    <cfoutput>The Hash: #theHash#</cfoutput><br>
    --->   
    
    <cfset leftHash=left('#theHash#', 5)>
    <cfset rightHash=right('#theHash#', 35)>
    
    <!---
    <cfoutput>Left Hash: #leftHash#</cfoutput><br>
    <cfoutput>Right Hash: #rightHash#</cfoutput><br>
    --->
    
    
    <cfhttp result="theResult" method="GET" charset="utf-8" throwonerror="false" url="https://api.pwnedpasswords.com/range/#leftHash#" />
    
    <!---
    <cfoutput>
    Status Code: #theResult.status_code#<br>
    </cfoutput>
    --->
    
    <cfif #theResult.status_code# is "200">
    
    <cfif #theResult.filecontent# contains '#rightHash#'>
    
    <cfoutput>Hash Found</cfoutput>
    
    <cfelse>
    
    <cfoutput>Hash Not Found</cfoutput>
    
    <!--- #theResult.filecontent# contains '#rightHash#' --->
    </cfif>
    
    
    <cfelseif #theResult.status_code# is not "200">
    
    <cfoutput>Hibp Unreachable</cfoutput>
    
    <!--- /CFIF FOR theResult.status_code --->
    </cfif>
    
    <!--- /CFIF #url.password# is not "" --->
    </cfif>

    <!--- /CFIF structKeyExists(url, 'password') --->
    </cfif>
    
    <!--- url.type is api --->
    </cfif>
    
    
    <cfelse>
    
    <cfset theHash=hash("#form.password#", "SHA", "UTF-8")>
    <!---
    <cfoutput>The Hash: #theHash#</cfoutput><br>
    --->
    
    <cfset leftHash=left('#theHash#', 5)>
    <cfset rightHash=right('#theHash#', 35)>
    
    <!---
    <cfoutput>Left Hash: #leftHash#</cfoutput><br>
    <cfoutput>Right Hash: #rightHash#</cfoutput><br>
    --->
    
    
    <cfhttp result="theResult" method="GET" charset="utf-8" throwonerror="false" url="https://api.pwnedpasswords.com/range/#leftHash#" />
    
    <!---
    <cfoutput>
    Status Code: #theResult.status_code#<br>
    </cfoutput>
    --->
    
    <cfif #theResult.status_code# is "200">
    
    <cfif #theResult.filecontent# contains '#rightHash#'>
    <!---
    <cfoutput>Hash Found</cfoutput><br><br>
    --->
    <cfset step=0>
    <cfset session.m=99>
    
    
    <cfoutput>
    <cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
    </cfoutput>
    
    <cfelse>
    <!---
    <cfoutput>Hash Not Found</cfoutput><br><br>
    --->
    <cfoutput>
    <cfset step=#nextstep#>
    </cfoutput>
    </cfif>
    
    
    <cfelseif #theResult.status_code# is not "200">
    <cfset step=0>
    <cfset session.m=100>
    
    <cfoutput>
    <cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
    </cfoutput>
    
    
    <!--- /CFIF FOR theResult.status_code --->
    </cfif>
    
    <!--- /CFIF structKeyExists(url, 'type')> --->
    </cfif>