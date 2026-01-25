
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
 <cfexecute name = "/opt/hermes/scripts/get_docker_directory.sh"
timeout = "240"
variable="DockerDir">
</cfexecute>

<!--- Enable for debug
<cfoutput> RAW: #DockerDir#</cfoutput><BR>
--->

 <cfcatch type="any">

  <cfset m="docker_get_directory.cfm: #cfcatch.detail#">
  <cfinclude template="error.cfm">
  <cfabort>

  </cfcatch>


 </cftry>



<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_docker_dir"
output = "#DockerDir#" addnewline="no">

  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_docker_dir"
output = "#REReplace("#DockerDir#","com.docker.compose.project.working_dir","","ALL")#" addnewline="no">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_docker_dir" variable="DockerDir">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_docker_dir"
output = "#REReplace("#DockerDir#",'"',"","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_docker_dir" variable="DockerDir">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_docker_dir"
output = "#REReplace("#DockerDir#",":","","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_docker_dir" variable="DockerDir">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_docker_dir"
output = "#REReplace("#DockerDir#",",","","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_docker_dir" variable="DockerDir">


  <cfset DockerDir = #trim(DockerDir)#>

<!--- Enable for Debug
  <cfoutput>FINAL: #DockerDir#</cfoutput>
--->

  <!-- delete /opt/hermes/tmp/#customtrans3#_docker_dir -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_docker_dir">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>



  