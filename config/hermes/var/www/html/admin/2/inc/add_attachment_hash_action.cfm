<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

ADD ATTACHMENT HASH ACTION HANDLER (#386)
--->

<cfif NOT StructKeyExists(form, "sha256")>
    <cfset session.m = 20>
    <cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
</cfif>

<cfset theHash = LCase(Trim(form.sha256))>
<cfset theSize = StructKeyExists(form, "file_size") ? Trim(form.file_size) : "">
<cfset theDescription = StructKeyExists(form, "description") ? Left(Trim(form.description), 255) : "">

<cfif NOT REFind("^[a-f0-9]{64}$", theHash)>
    <cfset session.m = 10>
    <cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
</cfif>

<cfif Len(theSize) AND (NOT REFind("^[1-9][0-9]{0,11}$", theSize))>
    <cfset session.m = 11>
    <cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
</cfif>

<cfquery name="checkHash" datasource="hermes">
    SELECT id FROM attachment_hash_blocklist
    WHERE sha256 = <cfqueryparam value="#theHash#" cfsqltype="cf_sql_char">
</cfquery>
<cfif checkHash.recordcount GT 0>
    <cfset session.m = 12>
    <cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
</cfif>

<cfquery datasource="hermes">
    INSERT INTO attachment_hash_blocklist (sha256, file_size, description, source)
    VALUES (
        <cfqueryparam value="#theHash#" cfsqltype="cf_sql_char">,
        <cfqueryparam value="#theSize#" cfsqltype="cf_sql_bigint" null="#NOT Len(theSize)#">,
        <cfqueryparam value="#theDescription#" cfsqltype="cf_sql_varchar" null="#NOT Len(theDescription)#">,
        'admin'
    )
</cfquery>

<cfinclude template="generate_attachment_hash_blocklist.cfm">

<cfset session.m = Len(request.hashBlocklistError) ? 30 : 1>
<cflocation url="view_attachment_hash_blocklist.cfm" addtoken="no">
