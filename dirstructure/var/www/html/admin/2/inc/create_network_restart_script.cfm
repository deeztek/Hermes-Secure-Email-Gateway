<cffile action="read" file="/opt/hermes/templates/network_restart.sh" variable="networkrestart">
  
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-TRANSACTION","#customtrans3#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","SERVER-NAME","#ServerName#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-NET-COMMAND","#THENETCOMMAND#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-NETWORK-FILE","#THENETWORKFILE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-INT-FILE","#THEINTFILE#","ALL")#">
    

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_network_restart.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
outputfile ="/dev/null"
timeout = "120">
</cfexecute>

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_network_restart.sh")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh">
</cfif>