<cfset frequency=#url.frequency#>

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cfset datetimenow="#datenow# #timenow#">
<cfset theDate=#DateFormat(DateAdd('h', -#frequency#, datetimenow),'yyyy-mm-dd')#>
<cfset theTime=#TimeFormat(DateAdd('h', -#frequency#, datetimenow),'HH:mm:ss')#>

<cfset datenow2=#DateFormat(datenow,"mm/dd/yyyy")#>
<cfset timenow2=#TimeFormat(timenow,"hh:mm:ss tt")#>

<cfoutput>
Date Time Now: #datetimenow#<br>
The Date: #theDate# #theTime#<br>
Human Date: #datenow2#<br>
Human Time: #timenow2#
</cfoutput>