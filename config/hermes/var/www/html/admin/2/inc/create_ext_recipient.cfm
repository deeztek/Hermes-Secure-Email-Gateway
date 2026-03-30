<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<!---
Creates an external encryption recipient in both hermes and djigzo (Ciphermail).
Expects these variables to be set before including:
  - ext_email: The recipient email address
  - ext_encryption_mode: pdf_mandatory, pdf_by_subject, smime_mandatory, smime_by_subject, pgp_mandatory, pgp_by_subject
  - ext_pdf_mode: (for PDF only) static, random, backtosender
  - ext_pdf_password: (for PDF static only) the password
  - ext_pdf_password_age: (for PDF backtosender only) age in minutes
  - ext_pdf_password_length: (for PDF backtosender only) 16 or 20
  - ext_is_edit: true/false - whether this is an edit or insert
--->

<cfinclude template="generate_customtrans.cfm">

<!--- Step 1: Create recipient in Ciphermail --->
<cfset scriptContent = "">
<cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --add-user " & ext_email & chr(10)>
<cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.locality --value external --email " & ext_email & chr(10)>

<!--- Step 2: Set encryption mode properties --->
<cfswitch expression="#ext_encryption_mode#">
  <cfcase value="pdf_mandatory">
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value mandatory --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value true --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value false --email " & ext_email & chr(10)>
  </cfcase>
  <cfcase value="pdf_by_subject">
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value allow --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value true --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value false --email " & ext_email & chr(10)>
  </cfcase>
  <cfcase value="smime_mandatory">
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value mandatory --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value true --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value false --email " & ext_email & chr(10)>
  </cfcase>
  <cfcase value="smime_by_subject">
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value allow --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value true --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value false --email " & ext_email & chr(10)>
  </cfcase>
  <cfcase value="pgp_mandatory">
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value mandatory --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value true --email " & ext_email & chr(10)>
  </cfcase>
  <cfcase value="pgp_by_subject">
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value allow --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value false --email " & ext_email & chr(10)>
    <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value true --email " & ext_email & chr(10)>
  </cfcase>
</cfswitch>

<!--- Step 3: PDF-specific password settings --->
<cfif Left(ext_encryption_mode, 3) is "pdf" AND isDefined("ext_pdf_mode")>
  <cfswitch expression="#ext_pdf_mode#">
    <cfcase value="static">
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.otpEnabled --value false --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.passwordsSendToOriginator --value false --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & 'docker exec hermes_ciphermail /usr/bin/java -cp ''/usr/share/djigzo/lib/*'' mitm.application.djigzo.tools.CLITool --set-property user.passwordValidityInterval --value "-60000" --email ' & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.password --value " & ext_pdf_password & " --encrypt --email " & ext_email & chr(10)>
    </cfcase>
    <cfcase value="random">
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.password --value '' --encrypt --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.passwordsSendToOriginator --value false --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.otpEnabled --value true --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.autoCreateClientSecret --value true --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.passwordLength --value 16 --email " & ext_email & chr(10)>
    </cfcase>
    <cfcase value="backtosender">
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.password --value '' --encrypt --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.passwordsSendToOriginator --value true --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.passwordValidityInterval --value " & ext_pdf_password_age & " --email " & ext_email & chr(10)>
      <cfset scriptContent = scriptContent & "docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.passwordLength --value " & ext_pdf_password_length & " --email " & ext_email & chr(10)>
    </cfcase>
  </cfswitch>
</cfif>

<!--- Execute the script --->
<cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_create_ext_recipient.sh">
<cffile action="write" file="#scriptPath#" output="#scriptContent#">
<cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="60"></cfexecute>
<cfexecute name="#scriptPath#" timeout="240" outputfile="/dev/null" arguments=""></cfexecute>
<cfif fileExists(scriptPath)>
  <cffile action="delete" file="#scriptPath#">
</cfif>

<!--- Step 4: Update hermes database --->
<cfset db_smime = "2">
<cfset db_pdf = "2">
<cfset db_pgp = "2">
<cfif Left(ext_encryption_mode, 3) is "pdf"><cfset db_pdf = "1"></cfif>
<cfif Left(ext_encryption_mode, 5) is "smime"><cfset db_smime = "1"></cfif>
<cfif Left(ext_encryption_mode, 3) is "pgp"><cfset db_pgp = "1"></cfif>

<cfif isDefined("ext_is_edit") AND ext_is_edit>
  <!--- Update existing --->
  <cfif db_pdf is "1" AND isDefined("ext_pdf_mode") AND ext_pdf_mode is "static">
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    <cfset encrypted_pdf_password = encrypt(ext_pdf_password, hermeskey, "AES", "Base64")>
    <cfquery datasource="hermes">
      UPDATE external_recipients
      SET encryption_mode = <cfqueryparam value="#ext_encryption_mode#" cfsqltype="cf_sql_varchar">,
          smime = <cfqueryparam value="#db_smime#" cfsqltype="cf_sql_varchar">,
          pdf = <cfqueryparam value="#db_pdf#" cfsqltype="cf_sql_varchar">,
          pgp = <cfqueryparam value="#db_pgp#" cfsqltype="cf_sql_varchar">,
          pdf_mode = <cfqueryparam value="#ext_pdf_mode#" cfsqltype="cf_sql_varchar">,
          pdf_password = <cfqueryparam value="#encrypted_pdf_password#" cfsqltype="cf_sql_varchar">
      WHERE email = <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">
    </cfquery>
  <cfelse>
    <cfquery datasource="hermes">
      UPDATE external_recipients
      SET encryption_mode = <cfqueryparam value="#ext_encryption_mode#" cfsqltype="cf_sql_varchar">,
          smime = <cfqueryparam value="#db_smime#" cfsqltype="cf_sql_varchar">,
          pdf = <cfqueryparam value="#db_pdf#" cfsqltype="cf_sql_varchar">,
          pgp = <cfqueryparam value="#db_pgp#" cfsqltype="cf_sql_varchar">,
          pdf_mode = <cfqueryparam value="#IIF(isDefined('ext_pdf_mode'), DE(ext_pdf_mode), DE(''))#" cfsqltype="cf_sql_varchar">
      WHERE email = <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">
    </cfquery>
  </cfif>
<cfelse>
  <!--- Insert new --->
  <cfif db_pdf is "1" AND isDefined("ext_pdf_mode") AND ext_pdf_mode is "static">
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    <cfset encrypted_pdf_password = encrypt(ext_pdf_password, hermeskey, "AES", "Base64")>
    <cfquery datasource="hermes">
      INSERT INTO external_recipients (email, encryption_mode, smime, pdf, pgp, pdf_mode, pdf_password)
      VALUES (
        <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#ext_encryption_mode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#db_smime#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#db_pdf#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#db_pgp#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#ext_pdf_mode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#encrypted_pdf_password#" cfsqltype="cf_sql_varchar">
      )
    </cfquery>
  <cfelse>
    <cfquery datasource="hermes">
      INSERT INTO external_recipients (email, encryption_mode, smime, pdf, pgp, pdf_mode)
      VALUES (
        <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#ext_encryption_mode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#db_smime#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#db_pdf#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#db_pgp#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#IIF(isDefined('ext_pdf_mode'), DE(ext_pdf_mode), DE(''))#" cfsqltype="cf_sql_varchar">
      )
    </cfquery>
  </cfif>
</cfif>

<!--- Step 5: Mark as manual in djigzo --->
<cfquery datasource="djigzo">
  UPDATE cm_users SET cm_locality = 'manual' WHERE cm_email = <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">
</cfquery>
