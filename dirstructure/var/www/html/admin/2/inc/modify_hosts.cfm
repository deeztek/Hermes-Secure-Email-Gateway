
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

<!--- Get Network Settings Hostname in order to modify /etc/hosts --->
<cfinclude template="get_network_parameters.cfm" />

<!--- Get Console Mode to decide which /opt/hermes/conf_files/host. to read --->
<cfinclude template="get_console_settings.cfm">

<!--- If console mode is fqdn then read /opt/hermes/conf_files/hosts.fqdn ---> 
<cfif #console_mode.value2# is "fqdn">

<cffile action="read" file="/opt/hermes/conf_files/hosts.fqdn.HERMES" variable="hosts">
  
<!--- If console mode is fqdn then read /opt/hermes/conf_files/hosts.ip ---> 
<cfelseif #console_mode.value2# is "ip">

<cffile action="read" file="/opt/hermes/conf_files/hosts.ip.HERMES" variable="hosts">

<!--- /CFIF #console_mode.value2# is --->
</cfif>

<!--- CREATE /opt/hermes/tmp/#customtrans3#hosts file to be set as /etc/hosts with server name and console host parameters --->  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#hosts"
      output = "#REReplace("#hosts#","SERVER-NAME","#server_name.value2#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#hosts" variable="hosts">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#hosts"
      output = "#REReplace("#hosts#","SERVER-DOMAIN","#server_domain.value2#","ALL")#">

      <cffile action="read" file="/opt/hermes/tmp/#customtrans3#hosts" variable="hosts">
  
      <cffile action = "write"
          file = "/opt/hermes/tmp/#customtrans3#hosts"
          output = "#REReplace("#hosts#","CONSOLE-HOST","#console_host.value2#","ALL")#">
      
  <!--- MODIFY /etc/mailname --->    
  
  <cffile action="read" file="/opt/hermes/conf_files/mailname.HERMES" variable="mailname">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#mailname"
      output = "#REReplace("#mailname#","SERVER-NAME","#server_name.value2#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#mailname" variable="mailname">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#mailname"
      output = "#REReplace("#mailname#","SERVER-DOMAIN","#server_domain.value2#","ALL")#">

<!--- Move  /opt/hermes/tmp/#customtrans3#hosts to /etc/hosts --->   
<cffile action="move" source="/opt/hermes/tmp/#customtrans3#hosts" destination="/etc/hosts">

<!--- Move  /opt/hermes/tmp/#customtrans3#mailname to /etc/mailname --->   
<cffile action="move" source="/opt/hermes/tmp/#customtrans3#mailname" destination="/etc/mailname">

<!--- Restart Postfix --->   
<cfinclude template="restart_postfix.cfm">