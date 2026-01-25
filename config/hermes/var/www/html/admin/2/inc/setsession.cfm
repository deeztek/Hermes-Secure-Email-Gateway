  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->
  
<cfexecute name = "/opt/hermes/scripts/dmidecode"
arguments=""
timeout = "60">
</cfexecute>

<cffile action="read" file="/usr/share/UUID" variable="temp1">

<cfset temp2="#REReplace("#temp1#","#chr(10)#","","ALL")#">

<cfset temp3="#REReplace("#temp2#","#chr(13)#","","ALL")#">
<cfset temp4="#REReplace("#temp3#","","","ALL")#">
<cfset temp5="#REReplace("#temp4#","UUID:","","ALL")#">

<cffile action = "write"
    file = "/usr/share/UUID"
    output = "#TRIM(temp5)#" addnewline="no">

<cfset uuid2_file="/usr/share/UUID2">

<cfif fileExists(uuid2_file)> 

<cffile action="read" file="/usr/share/UUID" variable="uuid">
<cffile action="read" file="/usr/share/UUID2" variable="uuid2">
<cfset compare_uuid = Compare(#uuid#, #uuid2#)>

<cfif #compare_uuid# is "0">

<cffile action="read" file="/usr/share/lt" variable="lt">

<cfset lt2=#TRIM(lt)#>

<cfif #lt2# is "1">

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cffile action="read" file="/usr/share/djigzo/ADDITIONAL-NOTES.TXT" variable="date">
<cfset difference = #datediff("d", '#datenow# #timenow#', '#date#')#>

<cfif #difference# LT 1>

<cfquery name="getserial" datasource="hermes">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cffile action = "delete"
    file = "/usr/share/UUID2">

<cfoutput>
<cfset session.license="N/A">
<cfset session.edition="Community">
<CFSET session.reason = "">
<CFSET session.licensevaliddays = "">
<CFSET session.licenseexpires = "">
</cfoutput>

<cfelseif #difference# GTE 1>

<cfoutput>
<cfset session.license="VALID">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFSET session.licensevaliddays = #difference#>
<CFSET session.licenseexpires = "#DateFormat(date,"mm/dd/yyyy")#">
</cfoutput>


<!--- /CFIF difference --->
</cfif>

<cfelseif #lt2# is "2">

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cffile action="read" file="/usr/share/djigzo/ADDITIONAL-NOTES.TXT" variable="date">
<cfset difference = #datediff("d", '#datenow# #timenow#', '#date#')#>

<cfif #difference# LT 1>

<cfoutput>
<cfset session.license="EXPIRED">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFSET session.licensevaliddays = "#difference#">
<CFSET session.licenseexpires = "#DateFormat(date,"mm/dd/yyyy")#">
</cfoutput>

<cfelseif #difference# GTE 1>

    <cfoutput>
    <cfset session.license="VALID">
    <cfset session.edition="Pro">
    <CFSET session.reason = "">
    <CFSET session.licensevaliddays = #difference#>
    <CFSET session.licenseexpires = "#DateFormat(date,"mm/dd/yyyy")#">
    </cfoutput>
    
    
    <!--- /CFIF difference --->
    </cfif>

<!--- /CFIF lt2 is 1 or 2 --->
</cfif>

<cfelseif #compare_uuid# is "1">

<cfquery name="getserial" datasource="hermes">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cfoutput>
<cfset session.license="VIOLATION">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFSET session.licensevaliddays = "">
<CFSET session.licenseexpires = "">
</cfoutput>

<cfelseif #compare_uuid# is "-1">
<cfquery name="getserial" datasource="hermes">
select parameter, value from system_settings where parameter='serial'
</cfquery>


<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

    <cfoutput>
<cfset session.license="VIOLATION">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFSET session.licensevaliddays = "">
<CFSET session.licenseexpires = "">
</cfoutput>

<!--- /CFIF compare_uuid is 0, 1 or -1 --->
</cfif>

<cfelseif NOT fileExists(uuid2_file)> 

<cfoutput>
<cfset session.license="N/A">
<cfset session.edition="Community">
<CFSET session.reason = "">
<CFSET session.licensevaliddays = "">
<CFSET session.licenseexpires = "">
</cfoutput>

<!--- /CFIF fileExists(uuid2_file) --->
</cfif>


