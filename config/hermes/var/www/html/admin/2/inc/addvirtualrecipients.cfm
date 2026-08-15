<!---
Hermes Secure Email Gateway - Add Virtual Recipients Action Handler
Validates and inserts one or more virtual recipient entries.
Accepts full email addresses (user@domain.com) or catch-all patterns (@domain.com).
Validates domain part against the domains table.
Expects: form.addresses (newline-delimited), form.forwards_1 (delivery address)
--->

<!--- Destinations. Accepts several, separated by comma, semicolon or
     whitespace, and writes one row per destination. Postfix concatenates the
     rows it gets back into a single recipient list, which is how an address
     here becomes a distribution list.

     Format validation only. Destinations outside our own domains have always
     been permitted on this page and remain so; the form warns about the SPF
     and DKIM consequences rather than blocking them. --->
<cfparam name="form.forwards_1" default="">
<cfset forwardsList = "">
<cfloop index="fwdCandidate" list="#Trim(form.forwards_1)#" delimiters=",; #chr(9)##chr(10)##chr(13)#">
  <cfset fwdCandidate = LCase(Trim(fwdCandidate))>
  <cfif fwdCandidate is "">
    <cfcontinue>
  </cfif>
  <cfif ListFindNoCase(forwardsList, fwdCandidate) EQ 0>
    <cfset forwardsList = ListAppend(forwardsList, fwdCandidate)>
  </cfif>
</cfloop>

<!--- Who may send TO these addresses. Separate question from where they
     deliver, and the control that makes external destinations defensible. --->
<cfparam name="form.internal_only" default="0">
<cfif form.internal_only NEQ "0" AND form.internal_only NEQ "1">
  <cfset form.internal_only = 0>
</cfif>

<!--- No usable destination. Without this the loops below simply do nothing
     and the admin gets a success page that changed nothing. --->
<cfif ListLen(forwardsList) EQ 0>
  <cfset session.m = 15>
  <cflocation url="view_virtual_recipients.cfm" addtoken="no">
</cfif>

<!--- Kept for the messages below, which report one destination per line. --->
<cfset forwards = ListFirst(forwardsList)>

<cfloop index="entry" list="#form.addresses#" delimiters="#chr(10)#">
  <cfset entry = LCase(trim(entry))>
  <cfif entry is ""><cfcontinue></cfif>

  <!--- Determine if catch-all (@domain) or full email --->
  <cfset isCatchAll = Left(entry, 1) is "@" AND Len(entry) GT 1>

  <cfif isCatchAll>
    <!--- Extract domain from @domain pattern --->
    <cfset entryDomain = Mid(entry, 2, Len(entry))>
    <cfset virtualAddress = entry>
  <cfelseif REFind("[@]", entry) GT 0>
    <!--- Full email address --->
    <cfset entryDomain = ListLast(entry, "@")>
    <cfset virtualAddress = entry>
  <cfelse>
    <!--- No @ sign — invalid --->
    <cfset invalidemail = invalidemail + 1>
    <cfset invalidemailrecipient = invalidemailrecipient & " " & encodeForHTML(entry) & "<br>">
    <cfcontinue>
  </cfif>

  <!--- Validate format: catch-all or valid email --->
  <cfif NOT isCatchAll AND NOT IsValid("email", entry)>
    <cfset invalidemail = invalidemail + 1>
    <cfset invalidemailrecipient = invalidemailrecipient & " " & encodeForHTML(entry) & "<br>">
    <cfcontinue>
  </cfif>

  <!--- Validate domain exists in the system --->
  <cfquery name="checkDomain" datasource="hermes">
    SELECT domain, type FROM domains
    WHERE domain = <cfqueryparam value="#entryDomain#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDomain.recordcount LT 1>
    <cfset invaliddomain = invaliddomain + 1>
    <cfset invaliddomainrecipient = invaliddomainrecipient & " " & encodeForHTML(entry) & " (domain: " & encodeForHTML(entryDomain) & ")<br>">
    <cfcontinue>
  </cfif>

  <!--- Block mailbox domains - use Email Server > Aliases instead --->
  <cfif checkDomain.type EQ "mailbox">
    <cfset invaliddomain = invaliddomain + 1>
    <cfset invaliddomainrecipient = invaliddomainrecipient & " " & encodeForHTML(entry) & " (mailbox domain - use Email Server &gt; Aliases)<br>">
    <cfcontinue>
  </cfif>

  <!--- Check for duplicates in mailbox_aliases. Still an outright refusal:
       an address belongs to one topology or the other, never both. --->
  <cfquery name="checkAlias" datasource="hermes">
    SELECT alias_address FROM mailbox_aliases
    WHERE alias_address = <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkAlias.recordcount GTE 1>
    <cfset alreadyexists = alreadyexists + 1>
    <cfset alreadyexistsrecipient = alreadyexistsrecipient & " " & encodeForHTML(virtualAddress) & " (exists as mailbox alias)<br>">
    <cfcontinue>
  </cfif>

  <!--- Adding destinations to an address that already exists must not
       silently change its reachability. Inherit what its rows carry. --->
  <cfquery name="getExistingVirtualInternal" datasource="hermes">
    SELECT MAX(internal_only) AS internal_only
    FROM virtual_recipients
    WHERE virtual_address = <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfset thisInternalOnly = form.internal_only>
  <cfif getExistingVirtualInternal.recordcount GTE 1 AND IsNumeric(getExistingVirtualInternal.internal_only)>
    <cfset thisInternalOnly = getExistingVirtualInternal.internal_only>
  </cfif>

  <!--- One row per destination. The address existing already is no longer a
       reason to refuse: that is how a list grows. Only an exact repeat of
       the same address AND destination is skipped. --->
  <cfloop index="oneForward" list="#forwardsList#" delimiters=",">
    <cfset oneForward = Trim(oneForward)>

    <cfquery name="checkEntry" datasource="hermes">
      SELECT id FROM virtual_recipients
      WHERE virtual_address = <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">
        AND maps = <cfqueryparam value="#oneForward#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkEntry.recordcount GTE 1>
      <cfset alreadyexists = alreadyexists + 1>
      <cfset alreadyexistsrecipient = alreadyexistsrecipient & " " & encodeForHTML(virtualAddress) & " --> " & encodeForHTML(oneForward) & "<br>">
      <cfcontinue>
    </cfif>

    <cfquery datasource="hermes">
      INSERT INTO virtual_recipients (virtual_address, maps, internal_only, system)
      VALUES (
        <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#oneForward#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#thisInternalOnly#" cfsqltype="cf_sql_tinyint">,
        '2'
      )
    </cfquery>

    <cfset success = success + 1>
    <cfset successrecipient = successrecipient & " " & encodeForHTML(virtualAddress) & " --> " & encodeForHTML(oneForward) & "<br>">
  </cfloop>
</cfloop>
