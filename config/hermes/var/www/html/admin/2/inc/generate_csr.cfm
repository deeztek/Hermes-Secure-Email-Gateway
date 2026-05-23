<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

GENERATE CSR (#243)

Builds a temp openssl.cnf carrying the distinguished name and the
subjectAltName extension, then invokes /opt/hermes/scripts/generate_csr.sh
which runs `openssl req -config <cnf> -reqexts req_ext`. The SAN list
arrives in form.sans (one DNS name per line, already sanitized + deduped
in cert_action.cfm + CN auto-prepended).
--->

<cfinclude template="generate_customtrans.cfm">

<cfset cnfPath = "/opt/hermes/tmp/" & customtrans3 & ".csr.cnf">

<!--- Build [alt_names] block from the validated SAN list. cert_action.cfm
     guarantees form.sans is newline-separated, deduped, lowercase, and
     contains the CN as the first entry. --->
<cfset altLines = "">
<cfset sanCounter = 0>
<cfloop list="#form.sans#" index="oneSan" delimiters="#chr(10)#">
    <cfset oneSan = trim(oneSan)>
    <cfif Len(oneSan) GT 0>
        <cfset sanCounter = sanCounter + 1>
        <cfset altLines = altLines & "DNS." & sanCounter & " = " & oneSan & chr(10)>
    </cfif>
</cfloop>

<cfset cnfBody = "[req]" & chr(10)
    & "prompt = no" & chr(10)
    & "distinguished_name = req_dn" & chr(10)
    & "req_extensions = req_ext" & chr(10)
    & chr(10)
    & "[req_dn]" & chr(10)
    & "C  = " & form.country      & chr(10)
    & "ST = " & form.state        & chr(10)
    & "L  = " & form.locality     & chr(10)
    & "O  = " & form.organization & chr(10)
    & "OU = " & form.department   & chr(10)
    & "CN = " & form.commonname   & chr(10)
    & chr(10)
    & "[req_ext]" & chr(10)
    & "subjectAltName = @alt_names" & chr(10)
    & chr(10)
    & "[alt_names]" & chr(10)
    & altLines>

<cffile action="write" file="#cnfPath#" output="#cnfBody#" addnewline="no" charset="utf-8">

<!--- Read + substitute the shell template's placeholders. The CN-related
     and DN-related substitutions are now redundant for openssl (the cnf
     carries them), but SHA-TYPE / KEY-LENGTH / SESSION still need to land
     in the script body. --->
<cffile action="read" file="/opt/hermes/scripts/generate_csr.sh" variable="temp" charset="utf-8">
<cfset temp = REReplace(temp, "SHA-TYPE",   form.algorithm,  "ALL")>
<cfset temp = REReplace(temp, "KEY-LENGTH", form.encryption, "ALL")>
<cfset temp = REReplace(temp, "SESSION",    customtrans3,    "ALL")>

<cfset shPath = "/opt/hermes/tmp/" & customtrans3 & "_generate_csr.sh">
<cffile action="write" file="#shPath#" output="#temp#" addnewline="no" charset="utf-8">

<cfexecute name="/bin/chmod" arguments="+x #shPath#" timeout="60"></cfexecute>
<cfexecute name="#shPath#" timeout="240" outputfile="/dev/null" arguments="-inputformat none"></cfexecute>

<cfset rar = "/opt/hermes/tmp/" & customtrans3 & "_csr_key.rar">

<cfif NOT fileExists(rar)>
    <cfset session.m = "There was an error creating the certificate request">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
<cfelse>
    <cfset session.customtrans = customtrans3>
    <cfset session.m = "CSR completed successfully. Click Download CSR button below">
    <cfset session.alerttype = "success">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
</cfif>
