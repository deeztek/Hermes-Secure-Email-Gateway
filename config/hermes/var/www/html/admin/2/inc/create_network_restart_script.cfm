
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

<cffile action="read" file="/opt/hermes/templates/network_restart_#show_network_mode#.sh" variable="networkrestart">
  
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","THE-TRANSACTION","#customtrans3#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","SERVER-NAME","#ServerName#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","THE-NET-COMMAND","#THENETCOMMAND#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","THE-NETWORK-FILE","#THENETWORKFILE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","THE-INT-FILE","#THEINTFILE#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
    output = "#REReplace("#networkrestart#","THE-TOKEN","#THETOKEN#","ALL")#">
    

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh"
outputfile ="/dev/null"
timeout = "120">
</cfexecute>


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_network_restart_#show_network_mode#.sh">
</cfif>


<!--- SLEEP 5 SECONDS WAITING FOR NETWORK TO RESTART --->
<cfscript> 
    thread = CreateObject("java", "java.lang.Thread"); 
    thread.sleep(5000); 
    </cfscript> 


    

    