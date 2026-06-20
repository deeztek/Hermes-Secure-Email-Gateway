
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2024. All Rights Reserved.

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

<!--- Set variables for key import --->
<cfset keysDir = "/opt/hermes/dkim/keys">
<cfset selectorName = form.import_selector>
<cfset domainName = getdomain.domain>
<cfset privateKeyContent = form.import_private_key>

<!--- File names --->
<cfset PrivateFileName = "#selectorName#_#domainName#.dkim.private">
<cfset PublicFileName = "#selectorName#_#domainName#.dkim.txt">
<cfset PrivateFile = "#keysDir#/#PrivateFileName#">
<cfset PublicFile = "#keysDir#/#PublicFileName#">

<!--- Generate a random string for temp file --->
<cfinclude template="generate_customtrans.cfm">

<!--- Normalize line endings in private key (Windows CRLF to Unix LF) --->
<cfset normalizedPrivateKey = Replace(privateKeyContent, Chr(13) & Chr(10), Chr(10), "ALL")>
<cfset normalizedPrivateKey = Replace(normalizedPrivateKey, Chr(13), Chr(10), "ALL")>

<!--- Write the private key to a temp file first --->
<cfset tempPrivateFile = "/opt/hermes/tmp/#customtrans3#_private.pem">

<cftry>
    <cffile action="write" file="#tempPrivateFile#" output="#normalizedPrivateKey#" mode="600">
    <cfcatch type="any">
        <cfset m="/inc/dkim_import_key.cfm: Error writing temp private key file: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Extract the public key using openssl in Docker container --->
<cfset tempPublicKeyFile = "/opt/hermes/tmp/#customtrans3#_pubkey.pem">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim /usr/bin/openssl rsa -in #tempPrivateFile# -pubout -out #tempPublicKeyFile#"
        timeout="60"
        variable="opensslOutput"
        errorVariable="opensslError">
    </cfexecute>
    <cfcatch type="any">
        <!--- Clean up temp file --->
        <cfif fileExists(tempPrivateFile)>
            <cffile action="delete" file="#tempPrivateFile#">
        </cfif>
        <cfset session.m = 14>
        <cfoutput>
        <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
        </cfoutput>
    </cfcatch>
</cftry>

<!--- Check if public key was generated --->
<cfif NOT fileExists(tempPublicKeyFile)>
    <!--- Clean up temp file --->
    <cfif fileExists(tempPrivateFile)>
        <cffile action="delete" file="#tempPrivateFile#">
    </cfif>
    <cfset session.m = 14>
    <cfoutput>
    <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
    </cfoutput>
</cfif>

<!--- Read the public key --->
<cffile action="read" file="#tempPublicKeyFile#" variable="publicKeyPem">

<!--- Extract just the base64 encoded public key (remove headers/footers and newlines) --->
<cfset publicKeyBase64 = publicKeyPem>
<cfset publicKeyBase64 = ReplaceNoCase(publicKeyBase64, "-----BEGIN PUBLIC KEY-----", "", "ALL")>
<cfset publicKeyBase64 = ReplaceNoCase(publicKeyBase64, "-----END PUBLIC KEY-----", "", "ALL")>
<cfset publicKeyBase64 = Replace(publicKeyBase64, Chr(10), "", "ALL")>
<cfset publicKeyBase64 = Replace(publicKeyBase64, Chr(13), "", "ALL")>
<cfset publicKeyBase64 = Trim(publicKeyBase64)>

<!--- Create the DNS TXT record format (same format as opendkim-genkey) --->
<cfset dnsRecord = "#selectorName#._domainkey	IN	TXT	( ""v=DKIM1; k=rsa; ""#Chr(10)#	  ""p=#publicKeyBase64#"" )  ; ----- DKIM key #selectorName# for #domainName#">

<!--- Move private key to final location --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim /bin/mv #tempPrivateFile# #PrivateFile#"
        timeout="60">
    </cfexecute>
    <cfcatch type="any">
        <cfset m="/inc/dkim_import_key.cfm: Error moving private key file: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Write the public key DNS record file --->
<cftry>
    <cffile action="write" file="#PublicFile#" output="#dnsRecord#" mode="644">
    <cfcatch type="any">
        <cfset m="/inc/dkim_import_key.cfm: Error writing public key file: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Clean up temp public key file --->
<cfif fileExists(tempPublicKeyFile)>
    <cffile action="delete" file="#tempPublicKeyFile#">
</cfif>

<!--- Verify both files exist --->
<cfif fileExists(PrivateFile) AND fileExists(PublicFile)>

    <!--- Insert into database --->
    <cfquery name="insertkey" datasource="hermes">
        INSERT INTO dkim_sign (domain, applied, public, private, enabled, generated, selector)
        VALUES ('#domainName#', '1', '#PublicFileName#', '#PrivateFileName#', '2', '1', '#selectorName#')
    </cfquery>

    <!--- SET OWNERSHIP OF IMPORTED DKIM KEY FILES --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_postfix_dkim /bin/chown opendkim:opendkim #PrivateFile# #PublicFile#"
            timeout="60">
        </cfexecute>
        <cfcatch type="any">
            <cfset m="/inc/dkim_import_key.cfm: Error setting ownership on DKIM key files">
            <cfinclude template="error.cfm">
            <cfabort>
        </cfcatch>
    </cftry>

<cfelse>

    <cfset m="/inc/dkim_import_key.cfm: PublicFile and/or PrivateFile does not exist after import">
    <cfinclude template="error.cfm">
    <cfabort>

</cfif>
