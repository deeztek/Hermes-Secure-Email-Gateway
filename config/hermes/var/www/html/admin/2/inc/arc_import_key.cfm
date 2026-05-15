<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- Import an existing ARC private key: takes pasted PEM, extracts the
      public key via openssl inside hermes_openarc, writes both files to
      /opt/hermes/arc/keys/, inserts into arc_sign. Mirrors dkim_import_key.cfm. --->

<cfset keysDir = "/opt/hermes/arc/keys">
<cfset selectorName = form.import_selector>
<cfset domainName = getdomain.domain>
<cfset privateKeyContent = form.import_private_key>

<cfset PrivateFileName = "#selectorName#_#domainName#.arc.private">
<cfset PublicFileName = "#selectorName#_#domainName#.arc.txt">
<cfset PrivateFile = "#keysDir#/#PrivateFileName#">
<cfset PublicFile = "#keysDir#/#PublicFileName#">

<cfinclude template="generate_customtrans.cfm">

<!--- Normalize line endings in private key (CRLF -> LF) --->
<cfset normalizedPrivateKey = Replace(privateKeyContent, Chr(13) & Chr(10), Chr(10), "ALL")>
<cfset normalizedPrivateKey = Replace(normalizedPrivateKey, Chr(13), Chr(10), "ALL")>

<cfset tempPrivateFile = "/opt/hermes/tmp/#customtrans3#_arc_private.pem">

<cftry>
    <cffile action="write" file="#tempPrivateFile#" output="#normalizedPrivateKey#" mode="600">
    <cfcatch type="any">
        <cfset m="/inc/arc_import_key.cfm: Error writing temp private key file: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Extract the public key using openssl in the openarc container --->
<cfset tempPublicKeyFile = "/opt/hermes/tmp/#customtrans3#_arc_pubkey.pem">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_openarc /usr/bin/openssl rsa -in #tempPrivateFile# -pubout -out #tempPublicKeyFile#"
        timeout="60"
        variable="opensslOutput"
        errorVariable="opensslError">
    </cfexecute>
    <cfcatch type="any">
        <cfif fileExists(tempPrivateFile)>
            <cffile action="delete" file="#tempPrivateFile#">
        </cfif>
        <cfset session.m = 14>
        <cfoutput>
            <cflocation url="view_arc_settings.cfm" addtoken="no">
        </cfoutput>
    </cfcatch>
</cftry>

<cfif NOT fileExists(tempPublicKeyFile)>
    <cfif fileExists(tempPrivateFile)>
        <cffile action="delete" file="#tempPrivateFile#">
    </cfif>
    <cfset session.m = 14>
    <cfoutput>
        <cflocation url="view_arc_settings.cfm" addtoken="no">
    </cfoutput>
</cfif>

<cffile action="read" file="#tempPublicKeyFile#" variable="publicKeyPem">

<cfset publicKeyBase64 = publicKeyPem>
<cfset publicKeyBase64 = ReplaceNoCase(publicKeyBase64, "-----BEGIN PUBLIC KEY-----", "", "ALL")>
<cfset publicKeyBase64 = ReplaceNoCase(publicKeyBase64, "-----END PUBLIC KEY-----", "", "ALL")>
<cfset publicKeyBase64 = Replace(publicKeyBase64, Chr(10), "", "ALL")>
<cfset publicKeyBase64 = Replace(publicKeyBase64, Chr(13), "", "ALL")>
<cfset publicKeyBase64 = Trim(publicKeyBase64)>

<!--- DNS TXT record format (identical to DKIM key record per RFC 8617 §4.2.2) --->
<cfset dnsRecord = "#selectorName#._domainkey	IN	TXT	( ""v=DKIM1; k=rsa; ""#Chr(10)#	  ""p=#publicKeyBase64#"" )  ; ----- ARC key #selectorName# for #domainName#">

<!--- Move private key into final location --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_openarc /bin/mv #tempPrivateFile# #PrivateFile#"
        timeout="60">
    </cfexecute>
    <cfcatch type="any">
        <cfset m="/inc/arc_import_key.cfm: Error moving private key file: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<cftry>
    <cffile action="write" file="#PublicFile#" output="#dnsRecord#" mode="644">
    <cfcatch type="any">
        <cfset m="/inc/arc_import_key.cfm: Error writing public key file: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<cfif fileExists(tempPublicKeyFile)>
    <cffile action="delete" file="#tempPublicKeyFile#">
</cfif>

<cfif fileExists(PrivateFile) AND fileExists(PublicFile)>

    <cfquery name="insertkey" datasource="hermes">
        INSERT INTO arc_sign (domain, applied, public, private, enabled, generated, selector)
        VALUES ('#domainName#', '1', '#PublicFileName#', '#PrivateFileName#', '2', '1', '#selectorName#')
    </cfquery>

    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_openarc /bin/chown openarc:openarc #PrivateFile# #PublicFile#"
            timeout="60">
        </cfexecute>
        <cfcatch type="any">
            <cfset m="/inc/arc_import_key.cfm: Error setting ownership on ARC key files">
            <cfinclude template="error.cfm">
            <cfabort>
        </cfcatch>
    </cftry>

<cfelse>

    <cfset m="/inc/arc_import_key.cfm: PublicFile and/or PrivateFile does not exist after import">
    <cfinclude template="error.cfm">
    <cfabort>

</cfif>
