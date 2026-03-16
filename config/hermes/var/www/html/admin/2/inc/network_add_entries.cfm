
<!---
Hermes Secure Email Gateway - Network Block/Allow Add Entries Action Handler
Parses multi-line textarea input, validates IPs/CIDR networks, and inserts entries.
Expects: form.entries, form.entry_action
Requires: get_network_block_allow.cfm, normalizeIP function, ipv4_pattern
--->

<cfset entries_added = 0>
<cfset entries_skipped = 0>
<cfset entry_errors = "">

<cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
  <cfset session.m = 30>
  <cflocation url="view_network_block_allow.cfm" addtoken="no">
</cfif>

<cfset entryAction = "permit">
<cfif StructKeyExists(form, "entry_action") AND form.entry_action is "reject">
  <cfset entryAction = "reject">
</cfif>

<cfset entryText = Replace(form.entries, Chr(13) & Chr(10), Chr(10), "ALL")>
<cfset entryText = Replace(entryText, Chr(13), Chr(10), "ALL")>
<cfset lines = ListToArray(entryText, Chr(10))>

<cfloop array="#lines#" index="line">
  <cfset line = trim(line)>
  <cfif line is ""><cfcontinue></cfif>

  <cfset firstSpace = Find(" ", line)>
  <cfif firstSpace GT 0>
    <cfset entryAddress = trim(Left(line, firstSpace - 1))>
    <cfset entryNote = trim(Mid(line, firstSpace + 1, Len(line)))>
  <cfelse>
    <cfset entryAddress = line>
    <cfset entryNote = line>
  </cfif>

  <cfset isNetwork = Find("/", entryAddress) GT 0>

  <cfif isNetwork>
    <cfset networkPart = ListFirst(entryAddress, "/")>
    <cfset cidrPart = ListLast(entryAddress, "/")>
    <cfif NOT REFind(ipv4_pattern, networkPart)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid network: " & encodeForHTML(entryAddress) & "<br>">
      <cfcontinue>
    </cfif>
    <cfif NOT IsNumeric(cidrPart) OR cidrPart LT 1 OR cidrPart GT 32>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid CIDR: " & encodeForHTML(entryAddress) & "<br>">
      <cfcontinue>
    </cfif>
    <cfset theEntry = normalizeIP(networkPart) & "/" & Int(cidrPart)>
  <cfelse>
    <cfif NOT REFind(ipv4_pattern, entryAddress)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid IP: " & encodeForHTML(entryAddress) & "<br>">
      <cfcontinue>
    </cfif>
    <cfset theEntry = normalizeIP(entryAddress)>
  </cfif>

  <!--- Check for duplicates --->
  <cfquery name="checkDup" datasource="hermes">
    SELECT COUNT(*) as cnt FROM postscreen_access
    WHERE sender = <cfqueryparam value="#theEntry#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDup.cnt GT 0>
    <cfset entries_skipped = entries_skipped + 1>
    <cfset entry_errors = entry_errors & "Duplicate: " & encodeForHTML(theEntry) & "<br>">
    <cfcontinue>
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO postscreen_access (sender, action, action2, applied, note)
    VALUES (
      <cfqueryparam value="#theEntry#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#entryAction#" cfsqltype="cf_sql_varchar">,
      'insert', '2',
      <cfqueryparam value="#entryNote#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>
  <cfset entries_added = entries_added + 1>
</cfloop>

<cfset session.entries_added = entries_added>
<cfset session.entries_skipped = entries_skipped>
<cfset session.entry_errors = entry_errors>
<cfset session.m = 1>
<cflocation url="view_network_block_allow.cfm" addtoken="no">
