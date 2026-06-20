<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

Resets the Secure Email Portal password for an external recipient.
Two-step process: encode password via CLITool, then set the encoded password.
Expects: portal_email, portal_pass1 (validated before including)
--->

<cfinclude template="generate_customtrans.cfm">

<!--- Step 1: Encode the password via CLITool --->
<cfset encodedPasswordFile = "/opt/hermes/tmp/#customtrans3#_portal_password">
<cfset scriptContent = "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --encode-password " & portal_pass1 & " >> " & encodedPasswordFile & chr(10)>
<cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh">
<cffile action="write" file="#scriptPath#" output="#scriptContent#">
<cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="60"></cfexecute>
<cfexecute name="#scriptPath#" timeout="240" outputfile="/dev/null" arguments=""></cfexecute>
<cfif fileExists(scriptPath)>
  <cffile action="delete" file="#scriptPath#">
</cfif>

<!--- Read the encoded password --->
<cffile action="read" file="#encodedPasswordFile#" variable="encodedpassword">
<cfset encodedpassword = trim(encodedpassword)>
<cfif fileExists(encodedPasswordFile)>
  <cffile action="delete" file="#encodedPasswordFile#">
</cfif>

<!--- Step 2: Set the encoded portal password in Ciphermail --->
<cfset scriptContent = "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.portal.password --encrypt --email " & portal_email & " --value " & encodedpassword & chr(10)>
<cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh">
<cffile action="write" file="#scriptPath#" output="#scriptContent#">
<cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="60"></cfexecute>
<cfexecute name="#scriptPath#" timeout="240" outputfile="/dev/null" arguments=""></cfexecute>
<cfif fileExists(scriptPath)>
  <cffile action="delete" file="#scriptPath#">
</cfif>
