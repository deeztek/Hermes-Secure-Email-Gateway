<!---
Hermes Secure Email Gateway - Add Virtual Recipients Action Handler
Validates and inserts one or more virtual recipient entries.
Accepts full email addresses (user@domain.com) or catch-all patterns (@domain.com).
Validates domain part against the domains table.
Expects: form.addresses (newline-delimited), form.forwards_1 (delivery address)
--->

<cfset forwards = LCase(trim(form.forwards_1))>

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

  <!--- Check for duplicates in virtual_recipients --->
  <cfquery name="checkEntry" datasource="hermes">
    SELECT virtual_address FROM virtual_recipients
    WHERE virtual_address = <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">
      AND maps = <cfqueryparam value="#forwards#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkEntry.recordcount GTE 1>
    <cfset alreadyexists = alreadyexists + 1>
    <cfset alreadyexistsrecipient = alreadyexistsrecipient & " " & encodeForHTML(virtualAddress) & " --> " & encodeForHTML(forwards) & "<br>">
    <cfcontinue>
  </cfif>

  <!--- Check for duplicates in mailbox_aliases --->
  <cfquery name="checkAlias" datasource="hermes">
    SELECT alias_address FROM mailbox_aliases
    WHERE alias_address = <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkAlias.recordcount GTE 1>
    <cfset alreadyexists = alreadyexists + 1>
    <cfset alreadyexistsrecipient = alreadyexistsrecipient & " " & encodeForHTML(virtualAddress) & " (exists as mailbox alias)<br>">
    <cfcontinue>
  </cfif>

  <!--- Insert --->
  <cfquery datasource="hermes">
    INSERT INTO virtual_recipients (virtual_address, maps, system)
    VALUES (
      <cfqueryparam value="#virtualAddress#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#forwards#" cfsqltype="cf_sql_varchar">,
      '2'
    )
  </cfquery>

  <cfset success = success + 1>
  <cfset successrecipient = successrecipient & " " & encodeForHTML(virtualAddress) & " --> " & encodeForHTML(forwards) & "<br>">
</cfloop>
