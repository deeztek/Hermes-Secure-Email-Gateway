<cfset theHash=hash("#thePassword#", "SHA", "UTF-8")>
<!---
<cfoutput>The Hash: #theHash#</cfoutput><br>
--->

<cfset leftHash=left('#theHash#', 5)>
<cfset rightHash=right('#theHash#', 35)>

<!---
<cfoutput>Left Hash: #leftHash#</cfoutput><br>
<cfoutput>Right Hash: #rightHash#</cfoutput><br>
--->


<cfhttp result="theResult" method="GET" charset="utf-8" throwonerror="false" url="https://api.pwnedpasswords.com/range/#leftHash#" />

<!---
<cfoutput>
Status Code: #theResult.status_code#<br>
</cfoutput>
--->

<cfif #theResult.status_code# is "200">

<cfif #theResult.filecontent# contains '#rightHash#'>
<!---
<cfoutput>Hash Found</cfoutput><br><br>
--->
<cfset step=0>
<cfset errormessage=99>
<cfelse>
<!---
<cfoutput>Hash Not Found</cfoutput><br><br>
--->
<cfoutput>
<cfset step=#nextstep#>
</cfoutput>
</cfif>


<cfelseif #theResult.status_code# is not "200">
<cfset step=0>
<cfset errormessage=100>


<!--- /CFIF FOR theResult.status_code --->
</cfif>