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

<!--- GET / USAGE --->


<cftry>
       
  <cfexecute name="/opt/hermes/scripts/disk_space_usage_root.sh"
  variable="rootusage"
  timeout="10" />
  
        
        <cfcatch type="any">
  
        <cfset m="/inc/get_system_root_filesystem_usage: There was an error executing /opt/hermes/scripts/disk_space_usage_root.sh">
        <cfinclude template="error.cfm">
        <cfabort>   
  
        </cfcatch>
        </cftry>
  



          <cfset rootusage = reReplace( rootusage, "Use%", "", "all" )>
          <cfset rootusage = reReplace( rootusage, "%", "", "all" )>
          <cfset rootusage = reReplace( rootusage, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
          <cfset rootusage=#TRIM(rootusage)#>
 
          

<cfif #rootusage# GTE "0" and #rootusage# LTE "59">

  <cfset rootusagecolor = "20c997">
  
  <cfelseif #rootusage# GTE "60" and #rootusage# LTE "79">
  
  <cfset rootusagecolor = "ffc107">
  
  <cfelseif #rootusage# GTE "80" and #rootusage# LTE "89">
  
  <cfset rootusagecolor = "fd7e14">
  
  <cfelseif #rootusage# GTE "90" and #rootusage# LTE "100">
  
  <cfset rootusagecolor = "e74c3c">
  
  <cfelse>
  
  <cfset rootusagecolor = "e74c3c">
  
  <!--- /CFIF #rootusage# is --->
  </cfif>


