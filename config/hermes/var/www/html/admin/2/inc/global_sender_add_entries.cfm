<!---
Hermes Secure Email Gateway - Global Sender Block/Allow Add Entries Action Handler
Validates and stages one or more sender email addresses or domains for addition.
Expects: form.entries (newline-delimited list), form.entry_type (block/allow)
--->

<cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
  <cfset session.m = 30>
  <cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
</cfif>

<cfset entries_added = 0>
<cfset entries_skipped = 0>
<cfset entry_errors = "">

<cfset entryType = "block">
<cfif StructKeyExists(form, "entry_type") AND form.entry_type is "allow">
  <cfset entryType = "allow">
</cfif>

<cfset entryText = Replace(form.entries, Chr(13) & Chr(10), Chr(10), "ALL")>
<cfset entryText = Replace(entryText, Chr(13), Chr(10), "ALL")>
<cfset lines = ListToArray(entryText, Chr(10))>

<cfloop array="#lines#" index="line">
  <cfset line = trim(line)>
  <cfif line is ""><cfcontinue></cfif>

  <!--- Validate: must be a valid email address, domain, or .domain (leading dot for root-domain match) --->
  <cfset isEmail = REFind("[@]", line) GT 0>
  <cfset isDotDomain = Left(line, 1) is ".">

  <cfif isEmail>
    <cfif NOT IsValid("email", line)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid email: " & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>
  <cfelseif isDotDomain>
    <cfset testDomain = Mid(line, 2, Len(line))>
    <cfif NOT IsValid("email", "test@" & testDomain)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid domain: " & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>
  <cfelse>
    <cfif NOT IsValid("email", "test@" & line)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid domain: " & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>
  </cfif>

  <!--- Check for duplicates --->
  <cfquery name="checkDup" datasource="hermes">
    SELECT COUNT(*) as cnt FROM amavis_sender_bypass
    WHERE sender = <cfqueryparam value="#line#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDup.cnt GT 0>
    <cfset entries_skipped = entries_skipped + 1>
    <cfset entry_errors = entry_errors & "Duplicate: " & encodeForHTML(line) & "<br>">
    <cfcontinue>
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO amavis_sender_bypass (sender, transport, action, type, applied)
    VALUES (
      <cfqueryparam value="#line#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="FILTER amavis:[127.0.0.1]:10030" cfsqltype="cf_sql_varchar">,
      'add',
      <cfqueryparam value="#entryType#" cfsqltype="cf_sql_varchar">,
      '2'
    )
  </cfquery>
  <cfset entries_added = entries_added + 1>
</cfloop>

<cfset session.entries_added = entries_added>
<cfset session.entries_skipped = entries_skipped>
<cfset session.entry_errors = entry_errors>
<cfset session.m = 1>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
