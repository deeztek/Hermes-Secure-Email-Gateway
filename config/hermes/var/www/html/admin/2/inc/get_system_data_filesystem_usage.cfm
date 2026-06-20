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

<!--- GET /MNT/DATA USAGE --->



<cftry>
       
  <cfexecute name="/opt/hermes/scripts/disk_space_usage_data.sh"
  variable="datausage"
  timeout="10" />
    
          
          <cfcatch type="any">
    
          <cfset m="/inc/get_system_data_filesystem_usage: There was an error executing /opt/hermes/scripts/disk_space_usage_data.sh">
          <cfinclude template="error.cfm">
          <cfabort>   
    
          </cfcatch>
          </cftry>
    

<cfset datausage = reReplace( datausage, "Use%", "", "all" )>
<cfset datausage = reReplace( datausage, "%", "", "all" )>
<cfset datausage = reReplace( datausage, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
<cfset datausage=#TRIM(datausage)#>


<cfif #datausage# GTE "0" and #datausage# LTE "59">

  <cfset datausagecolor = "20c997">
  
  <cfelseif #datausage# GTE "60" and #datausage# LTE "79">
  
  <cfset datausagecolor = "ffc107">
  
  <cfelseif #datausage# GTE "80" and #datausage# LTE "89">
  
  <cfset datausagecolor = "fd7e14">
  
  <cfelseif #datausage# GTE "90" and #datausage# LTE "100">
  
  <cfset datausagecolor = "e74c3c">
  
  <cfelse>
  
  <cfset datausagecolor = "e74c3c">
  
  <!--- /CFIF #datausage# is --->
  </cfif>
