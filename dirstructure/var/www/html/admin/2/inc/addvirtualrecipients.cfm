
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

<cfparam name = "step" default = "0"> 

<!--- ENABLE BELOW FOR DEBUG ONLY --->
<!---
<cfoutput>
Form: #form.local_part#<br>
</cfoutput>
--->

<cfif #form.local_part# is not "">
<cfset step=1>
<cfelseif #form.local_part# is "">
<cfset step=2>

<!--- /CFIF #form.local_part# is/is not "" --->
</cfif>

<cfif #step# is "1">

<cfloop index="local_part" list="#form.local_part#" delimiters="#chr(10)#">

<cfoutput>
<cfset local_part = #LCase(local_part)#>
<cfset local_part = #trim(local_part)#>
<cfset recipient = "#local_part#@#form.domain#">

<cfset forwards = #LCase(form.forwards_1)#>
<cfset forwards = #trim(forwards)#>



<!--- ENABLE BELOW FOR DEBUG ONLY --->
<!---
Recipient: #theRecipient#<br>
--->
</cfoutput>


<cfif IsValid("email", recipient)>

<cfoutput>
<cfquery name="checkentry" datasource="hermes">
select virtual_address, maps from virtual_recipients where virtual_address = '#recipient#' and maps = '#forwards#'
</cfquery>
</cfoutput>

<cfif #checkentry.recordcount# LT 1>

<cfquery name="insertvirtual" datasource="hermes">
insert into virtual_recipients 
(virtual_address, maps, system)
values
('#recipient#', '#forwards#', '2')
</cfquery>
        
<cfset success=#success#+1>
<cfset successrecipient="#successrecipient# #recipient# --> #forwards#<br>">      

<cfelseif #checkentry.recordcount# GTE 1>

<cfset step=0>
<cfset errormessage=3>
<cfset alreadyexists=#alreadyexists#+1>
<cfset alreadyexistsrecipient="#alreadyexistsrecipient# #recipient# --> #forwards#<br>">

<!--- /CFIF #checkentry.recordcount# --->
</cfif>


<cfelseif NOT IsValid("email", recipient)>
<cfset step=0>
<cfset errormessage=3>
<cfset invalidemail=#invalidemail#+1>
<cfset invalidemailrecipient="#invalidemailrecipient# #recipient#<br>">

<!--- /CFIF IsValid("email", recipient) --->
</cfif>
        

<!--- /CFLOOP index="recipient" --->
</cfloop>

<!--- /CFIF #step# is "1" --->
</cfif>

<cfif #step# is "2">

<cfoutput>

<cfset forwards = #LCase(form.forwards_1)#>
<cfset forwards = #trim(forwards)#>

</cfoutput>

<cfoutput>
<cfquery name="checkentry" datasource="hermes">
select virtual_address, maps from virtual_recipients where virtual_address = '@#form.domain#' and maps = '#forwards#'
</cfquery>
</cfoutput>
        
<cfif #checkentry.recordcount# LT 1>
        
<cfquery name="insertvirtual" datasource="hermes">
insert into virtual_recipients 
(virtual_address, maps, system)
values
('@#form.domain#', '#forwards#', '2')
</cfquery>       


<cfset success=#success#+1>
<cfset successrecipient="#successrecipient# @#form.domain# --> #forwards#<br>">
        
<cfelseif #checkentry.recordcount# LT 1>
<cfset step=0>
<cfset errormessage=3>
<cfset alreadyexists=#alreadyexists#+1>
<cfset alreadyexistsrecipient="#alreadyexistsrecipient# @#form.domain# --> #forwards#<br>">
        
<!--- /CFIF #checkentry.recordcount# --->
</cfif>

        
<!--- /CFIF #step# is "2" --->
</cfif>


