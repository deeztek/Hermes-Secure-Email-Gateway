<!---
Hermes Secure Email Gateway - Sender/Recipient Block/Allow Add Entry Action Handler
Validates input, inserts into mailaddr and wblist, reloads Amavis immediately.
Expects: form.sender, form.recipient, form.entry_type
--->

<cfparam name="form.sender" default="">
<cfparam name="form.recipient" default="">
<cfparam name="form.entry_type" default="BLOCK">

<cfset sender = trim(form.sender)>
<cfset recipient = trim(form.recipient)>
<cfset entryType = trim(form.entry_type)>

<!--- Validate sender --->
<cfif sender is "">
  <cfset session.m = 30>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Validate recipient --->
<cfif recipient is "">
  <cfset session.m = 31>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Validate entry type --->
<cfif entryType is not "BLOCK" AND entryType is not "ALLOW">
  <cfset session.m = 32>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Determine if sender is email or domain --->
<cfif Find("@", sender) GT 0>
  <cfset senderType = "email">
<cfelse>
  <cfset senderType = "domain">
</cfif>

<!--- Validate sender format --->
<cfif senderType is "email">
  <cfif NOT IsValid("email", sender)>
    <cfset session.m = 33>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>
<cfelse>
  <cfif Left(sender, 1) is ".">
    <cfset testEmail = "bob@temp" & sender>
  <cfelse>
    <cfset testEmail = "bob@" & sender>
  </cfif>
  <cfif NOT IsValid("email", testEmail)>
    <cfset session.m = 33>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>
</cfif>

<!--- Look up recipient in recipients table --->
<cfquery name="getRecipient" datasource="hermes">
  SELECT id, recipient, domain FROM recipients
  WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
  OR (domain = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
      AND <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar"> LIKE CONCAT('%', REPLACE(recipient, '@', ''), '%'))
  ORDER BY domain ASC
  LIMIT 1
</cfquery>

<cfif getRecipient.recordCount LT 1>
  <cfset session.m = 34>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Derive recipient domain for same-domain check --->
<cfif getRecipient.domain is "1">
  <cfset recipientDomain = REReplace(getRecipient.recipient, "@", "", "ALL")>
<cfelse>
  <cfset recipientDomain = trim(ListGetAt(getRecipient.recipient, 2, "@"))>
</cfif>

<cfif senderType is "email">
  <cfset senderDomain = trim(ListGetAt(sender, 2, "@"))>
<cfelse>
  <cfset senderDomain = sender>
</cfif>

<cfif CompareNoCase(senderDomain, recipientDomain) is 0>
  <cfset session.m = 35>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Format sender for storage (domains get @ prefix) --->
<cfif senderType is "domain">
  <cfset senderStored = "@" & sender>
<cfelse>
  <cfset senderStored = sender>
</cfif>

<cfset wbCode = (entryType is "ALLOW") ? "W" : "B">

<!--- Resolve or create mailaddr entry for sender --->
<cfquery name="checkSenderAddr" datasource="hermes">
  SELECT id FROM mailaddr
  WHERE email = <cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif checkSenderAddr.recordCount LT 1>
  <cfquery name="insertSenderAddr" datasource="hermes" result="stSender">
    INSERT INTO mailaddr (email)
    VALUES (<cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">)
  </cfquery>
  <cfset senderMailaddrId = stSender.GENERATED_KEY>
<cfelse>
  <cfset senderMailaddrId = checkSenderAddr.id>
</cfif>

<!--- If recipient is a domain entry, add mapping for all recipients in that domain --->
<cfif getRecipient.domain is "1">
  <cfquery name="getDomainRecipients" datasource="hermes">
    SELECT id, recipient FROM recipients
    WHERE recipient LIKE <cfqueryparam value="%#recipientDomain#%" cfsqltype="cf_sql_varchar">
      AND domain IS NULL
  </cfquery>
  <cfloop query="getDomainRecipients">
    <!--- Check for duplicate in wblist --->
    <cfquery name="checkDup" datasource="hermes">
      SELECT rid FROM wblist
      WHERE rid = <cfqueryparam value="#getDomainRecipients.id#" cfsqltype="cf_sql_integer">
        AND sid = <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkDup.recordCount LT 1>
      <cfquery datasource="hermes">
        INSERT INTO wblist (rid, sid, wb)
        VALUES (
          <cfqueryparam value="#getDomainRecipients.id#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#wbCode#" cfsqltype="cf_sql_varchar">
        )
      </cfquery>
    </cfif>
  </cfloop>
<cfelse>
  <!--- Check for duplicate in wblist --->
  <cfquery name="checkDup" datasource="hermes">
    SELECT rid FROM wblist
    WHERE rid = <cfqueryparam value="#getRecipient.id#" cfsqltype="cf_sql_integer">
      AND sid = <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkDup.recordCount GTE 1>
    <cfset session.m = 36>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>
  <cfquery datasource="hermes">
    INSERT INTO wblist (rid, sid, wb)
    VALUES (
      <cfqueryparam value="#getRecipient.id#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#wbCode#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>
</cfif>

<cfset session.m = 1>
<cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
