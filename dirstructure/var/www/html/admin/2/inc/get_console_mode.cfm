
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

       <!--- DETERMINE CONSOLE MODE --->
       <cfquery name = "getconsolemode" datasource="hermes">
        select parameter, value2 from parameters2 where parameter='console.mode'
        </cfquery>

       <cfset theConsoleMode="#getconsolemode.value2#">
      
        <cfif #theConsoleMode# is "ip">

        <!--- GET SYSTEM IP --->  
        <cfinclude template="/admin/2/inc/get_system_ip.cfm">

        <cfif #theIpAddress# is "">
          
        <cfset m="Get Console Mode: There was an error getting system IP Address">
        <cfinclude template="error.cfm">
        <cfabort>   
          
        <cfelse>
          
        <cfset theIpAddress = #trim(theIpAddress)#>
      
        <cfset theurl="https://#theIpAddress#">

         
        <!--- /CFIF #theIpAddress# is "" --->
          </cfif>
        
        <cfelseif #theConsoleMode# is "fqdn">
        
        <!--- DETERMINE CONSOLE HOST --->
        <cfquery name = "getconsolehost" datasource="hermes">
        select parameter, value2 from parameters2 where parameter='console.host'
        </cfquery>
      
      <cfset theurl="https://#getconsolehost.value2#">


      
    <cfelse>

      <cfset m="Get Console Mode: getconsolemode.value2 is not ip or fqdn">
      <cfinclude template="error.cfm">
      <cfabort>

        <!--- /CFIF THECONSOLEMODE --->
        </cfif>