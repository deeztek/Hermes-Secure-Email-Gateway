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
       
<cfexecute name="/opt/hermes/scripts/getmem.sh"
variable="mem"
timeout="10" />

<cfset mem=#TRIM(mem)#>

<cfset mem = #Numberformat (mem, '____._')#>
      
      <cfcatch type="any">

      <cfset m="/inc/get_system_memory_usage: There was an error executing /opt/hermes/scripts/getmem.sh">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>

      <cfif #mem# GTE "0" and #mem# LTE "59">

        <cfset memcolor = "20c997">
        
        <cfelseif #mem# GTE "60" and #mem# LTE "79">
        
        <cfset memcolor = "ffc107">
        
        <cfelseif #mem# GTE "80" and #mem# LTE "89">
        
        <cfset memcolor = "fd7e14">
        
        <cfelseif #mem# GTE "90" and #mem# LTE "100">
        
        <cfset memcolor = "e74c3c">
        
        <cfelse>
        
        <cfset memcolor = "e74c3c">
        
        <!--- /CFIF #mem# is --->
        </cfif>

 