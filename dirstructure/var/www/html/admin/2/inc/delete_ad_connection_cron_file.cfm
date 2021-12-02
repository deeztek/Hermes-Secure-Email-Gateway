
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

<cfquery name="getversion" datasource="hermes">
    select parameter, value from system_settings where parameter = 'version_no'
    </cfquery>
    
    <cfif #getversion.value# is "20.04">
    
     <!--- DELETE /VAR/WWW/HTML/SCHEDULE AD_TASKS.CFM --->
  <cfset testfile="/var/www/html/schedule/#getconnection.entry_name#_ad_tasks.cfm">
  <cfif fileExists(testfile)>
  <cffile 
  action = "delete"
  file = "#testfile#">
  </cfif>
    
  <cfelse>
  <!--- DELETE /OPT/HERMES/WEBAPPS/SCHEDULE AD_TASKS.CFM --->
  <cfset testfile="/opt/hermes/webapps/schedule/#getconnection.entry_name#_ad_tasks.cfm">
  <cfif fileExists(testfile)>
  <cffile 
  action = "delete"
  file = "#testfile#">
  </cfif>
    <!--- /CFIF #getversion.value# is --->
    </cfif>