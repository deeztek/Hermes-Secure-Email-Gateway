<!---
Hermes Secure Email Gateway - Add Virtual Recipient Action Handler
Validates ONE virtual address and inserts a row per destination.
Accepts a full email address (user@domain.com) or a catch-all pattern (@domain.com).
Validates the domain part against the domains table.
Expects: form.virtual_address (one address), form.forwards_1 (comma-delimited destinations)
Reports its verdict by setting `errormessage` in the caller, or `success` /
`successrecipient` on the way through.
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


<!--- No usable destination. Without this the loops below simply do nothing
     and the admin gets a success page that changed nothing. --->
<cfif ListLen(forwardsList) EQ 0>
  <cfset session.m = 15>
  <cflocation url="view_virtual_recipients.cfm" addtoken="no">
</cfif>

<!--- ONE virtual address, delivered to every destination. Same shape as
     Email Server > Aliases: one address in, one verdict out.

     This was a newline-delimited textarea creating many addresses in a single
     submission. Every outcome then had to be a per-row tally, which is why the
     page carried four separate accumulating callouts, and why an address that
     already existed could only be reported rather than refused. With one
     address there is one answer, so the failures below are plain errors. --->
<cfset entry = LCase(Trim(form.virtual_address))>

<cfset hasAt      = REFind("[@]", entry) GT 0>
<cfset isCatchAll = Left(entry, 1) is "@" AND Len(entry) GT 1>
<cfif isCatchAll>
  <cfset entryDomain = Mid(entry, 2, Len(entry))>
<cfelseif hasAt>
  <cfset entryDomain = ListLast(entry, "@")>
<cfelse>
  <cfset entryDomain = "">
</cfif>

<!--- The three lookups run up front rather than being short-circuited inside a
     nested chain. Each is a single indexed row lookup, so the cost of running
     one that turns out to be unnecessary is nil, and it buys a flat
     cfif/cfelseif below instead of six levels of nesting. --->
<cfquery name="checkDomain" datasource="hermes">
  SELECT domain, type FROM domains
  WHERE domain = <cfqueryparam value="#entryDomain#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfquery name="checkAlias" datasource="hermes">
  SELECT alias_address FROM mailbox_aliases
  WHERE alias_address = <cfqueryparam value="#entry#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfquery name="checkEntry" datasource="hermes">
  SELECT id FROM virtual_recipients
  WHERE virtual_address = <cfqueryparam value="#entry#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif NOT hasAt OR (NOT isCatchAll AND NOT IsValid("email", entry))>
  <cfset errormessage = 4>

<cfelseif checkDomain.recordcount LT 1>
  <cfset errormessage = 5>

<!--- A mailbox domain's addresses belong to Email Server > Aliases. --->
<cfelseif checkDomain.type EQ "mailbox">
  <cfset errormessage = 6>

<!--- An address belongs to one topology or the other, never both. --->
<cfelseif checkAlias.recordcount GTE 1>
  <cfset errormessage = 7>

<!--- Add CREATES. Changing an address that already exists, including adding
     and removing destinations, is the Edit modal's job, where the whole
     destination set is shown as chips and the save is a diff. --->
<cfelseif checkEntry.recordcount GTE 1>
  <cfset errormessage = 8>

<cfelse>
  <!--- One row per destination. The address is known not to exist and the
       destinations were deduplicated at the top, so every row written here is
       new. --->
  <cfloop index="oneForward" list="#forwardsList#" delimiters=",">
    <cfset oneForward = Trim(oneForward)>

    <cfquery datasource="hermes">
      INSERT INTO virtual_recipients (virtual_address, maps, system)
      VALUES (
        <cfqueryparam value="#entry#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#oneForward#" cfsqltype="cf_sql_varchar">,
        '2'
      )
    </cfquery>

    <cfset success = success + 1>
    <cfset successrecipient = successrecipient & " " & encodeForHTML(entry) & " --> " & encodeForHTML(oneForward) & "<br>">
  </cfloop>
</cfif>
