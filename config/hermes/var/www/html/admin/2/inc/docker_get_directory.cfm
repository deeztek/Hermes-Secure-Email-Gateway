
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

 <cftry>

<!-- Get Docker Working Directory -->
<!-- Script now returns clean path directly (e.g., /opt/hermes-seg-docker-gl) -->
 <cfexecute name = "/opt/hermes/scripts/get_docker_directory.sh"
timeout = "60"
variable="DockerDir">
</cfexecute>

  <cfset DockerDir = trim(DockerDir)>

<!--- Enable for Debug
  <cfoutput>Docker Directory: #DockerDir#</cfoutput>
--->

 <cfcatch type="any">

  <cfset m="docker_get_directory.cfm: #cfcatch.detail#">
  <cfinclude template="error.cfm">
  <cfabort>

  </cfcatch>

 </cftry>



  