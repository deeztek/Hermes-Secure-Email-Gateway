<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

Resets the static PDF encryption password for an external recipient.
Expects: pdf_email, pdf_pass1 (validated before including)
--->

<!--- Set password in Ciphermail via CLITool --->
<cfinclude template="generate_customtrans.cfm">

<cfset scriptContent = "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.password --value " & pdf_pass1 & " --encrypt --email " & pdf_email & chr(10)>
<cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_reset_pdf_password.sh">
<cffile action="write" file="#scriptPath#" output="#scriptContent#">
<cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="60"></cfexecute>
<cfexecute name="#scriptPath#" timeout="240" outputfile="/dev/null" arguments=""></cfexecute>
<cfif fileExists(scriptPath)>
  <cffile action="delete" file="#scriptPath#">
</cfif>

<!--- Update encrypted password in hermes DB --->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
<cfset encrypted_pdf_password = encrypt(pdf_pass1, hermeskey, "AES", "Base64")>
<cfquery datasource="hermes">
  UPDATE external_recipients
  SET pdf_password = <cfqueryparam value="#encrypted_pdf_password#" cfsqltype="cf_sql_varchar">
  WHERE email = <cfqueryparam value="#pdf_email#" cfsqltype="cf_sql_varchar">
</cfquery>
