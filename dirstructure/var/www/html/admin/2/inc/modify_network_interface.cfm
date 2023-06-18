
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


<cfif #show_network_mode# is "static">

<cffile action="read" file="/opt/hermes/conf_files/50-cloud-init.yaml.HERMES.#show_network_mode#" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
 variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","SERVER-ADDRESS","#ServerAddress#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
 variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","SERVER-SUBNET","#ServerSubnet#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
 variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","SERVER-GATEWAY","#ServerGateway#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
 variable="interfaces">



<cfset theServerDNS="#ServerDNS1#">
<cfif #ServerDNS2# is not "">
<cfset
 theServerDNS="#ServerDNS1##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS2#">
</cfif>
<cfif #ServerDNS3# is not "">
<cfset
 theServerDNS="#ServerDNS1##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS2##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS3#">
</cfif>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","SERVER-DNS","#theServerDNS#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
 variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","SERVER-DOMAIN","#ServerDomain#","ALL")#">

<cfelseif #show_network_mode# is "dhcp">

<cffile action="read" file="/opt/hermes/conf_files/50-cloud-init.yaml.HERMES.#show_network_mode#" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.#show_network_mode#"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">

<!--- /CFIF #show_network_mode# is --->
</cfif>