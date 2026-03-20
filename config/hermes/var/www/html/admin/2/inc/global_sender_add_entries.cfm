<!---
Hermes Secure Email Gateway - Global Sender Rules Add Entries Action Handler
Validates and inserts one or more sender email addresses or domains, then immediately
writes config files and reloads Postfix/Amavis.
Expects: form.entries (newline-delimited list), form.entry_type (block/allow)
--->

<cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
  <cfset session.m = 30>
  <cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
</cfif>

<cfset entries_added = 0>
<cfset entries_skipped = 0>
<cfset success_list = "">
<cfset invalid_list = "">
<cfset duplicate_list = "">

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

  <!--- Validate: must be a valid email address, @domain, .domain, or bare domain --->
  <cfset isAtDomain = Left(line, 1) is "@" AND Len(line) GT 1>
  <cfset isDotDomain = Left(line, 1) is ".">
  <cfset isEmail = NOT isAtDomain AND REFind("[@]", line) GT 0>

  <cfif isEmail>
    <cfif NOT IsValid("email", line)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset invalid_list = invalid_list & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>
  <cfelseif isAtDomain>
    <!--- @domain.com pattern: validate the domain part --->
    <cfset testDomain = Mid(line, 2, Len(line))>
    <cfif NOT IsValid("email", "test@" & testDomain)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset invalid_list = invalid_list & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>
  <cfelseif isDotDomain>
    <cfset testDomain = Mid(line, 2, Len(line))>
    <cfif NOT IsValid("email", "test@" & testDomain)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset invalid_list = invalid_list & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>
  <cfelse>
    <cfif NOT IsValid("email", "test@" & line)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset invalid_list = invalid_list & encodeForHTML(line) & "<br>">
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
    <cfset duplicate_list = duplicate_list & encodeForHTML(line) & "<br>">
    <cfcontinue>
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO amavis_sender_bypass (sender, transport, action, type, applied)
    VALUES (
      <cfqueryparam value="#line#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="FILTER amavis:[127.0.0.1]:10030" cfsqltype="cf_sql_varchar">,
      'NONE',
      <cfqueryparam value="#entryType#" cfsqltype="cf_sql_varchar">,
      '1'
    )
  </cfquery>
  <cfset entries_added = entries_added + 1>
  <cfset success_list = success_list & encodeForHTML(line) & "<br>">
</cfloop>

<cfset session.entries_added = entries_added>
<cfset session.entries_skipped = entries_skipped>
<cfset session.success_list = success_list>
<cfset session.invalid_list = invalid_list>
<cfset session.duplicate_list = duplicate_list>

<!--- Write config files and reload services if entries were added --->
<cfif entries_added GT 0>
  <cfinclude template="./global_sender_write_and_reload.cfm">
</cfif>

<cfset session.m = 1>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
