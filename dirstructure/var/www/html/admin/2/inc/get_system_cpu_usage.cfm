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
       
    <cfexecute name="/opt/hermes/scripts/getcpu.sh"
    variable="cpu"
    timeout="10" />
      
      <cfcatch type="any">

      <cfset m="/inc/get_system_cpu_usage: There was an error executing /opt/hermes/scripts/getcpu.sh">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>


<cfset cpu = reReplace( cpu, "%", "", "all" )>
<cfset cpu=#TRIM(cpu)#>


<cfif #cpu# GTE "0" and #cpu# LTE "19">

<cfset cpucolor = "20c997">

<cfelseif #cpu# GTE "20" and #cpu# LTE "49">

<cfset cpucolor = "ffc107">

<cfelseif #cpu# GTE "50" and #cpu# LTE "79">

<cfset cpucolor = "fd7e14">

<cfelseif #cpu# GTE "80" and #cpu# LTE "100">

<cfset cpucolor = "e74c3c">

<cfelse>

<cfset cpucolor = "e74c3c">

<!--- /CFIF #cpu# is --->
</cfif>


 