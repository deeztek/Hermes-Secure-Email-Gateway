<!---
Hermes SEG - Tokenized Quarantine Sender Block
Public endpoint (no Authelia login required).
--->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hermes SEG | Block Sender</title>
    <style>
        body { font-family: Arial, Helvetica, sans-serif; background: #f4f6f9; margin: 0; padding: 40px 20px; color: #333; }
        .card { max-width: 560px; margin: 0 auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .card-header { padding: 20px 24px; text-align: center; color: #fff; background: #dc3545; }
        .card-body { padding: 24px; line-height: 1.6; }
        .logo { text-align: center; margin-bottom: 20px; }
        .logo img { max-height: 60px; }
        .actions a { display:inline-block; margin-top: 8px; padding: 10px 16px; border-radius: 6px; text-decoration:none; font-weight:bold; background:#f97316; color:#fff; }
    </style>
</head>
<body>
<div class="logo"><img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes Secure Email Gateway"></div>

<cfparam name="url.token" default="">
<cfif url.token EQ "">
    <div class="card"><div class="card-header"><h2>Invalid Request</h2></div><div class="card-body"><p>No block token was provided.</p></div></div>
    <cfabort>
</cfif>

<cfinclude template="/schedule/inc/quarantine_token.cfm">
<cfset tokenResult = validateQuarantineActionToken(url.token, "block")>

<cfif NOT tokenResult.valid>
    <div class="card"><div class="card-header"><h2>Invalid Link</h2></div><div class="card-body"><p><cfoutput>#encodeForHTML(tokenResult.error EQ 'expired' ? 'This block link has expired.' : 'This block link is not valid.')#</cfoutput></p></div></div>
    <cfabort>
</cfif>

<cfquery name="getportal" datasource="hermes">
    SELECT value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfif getportal.recordcount LT 1 OR Trim(getportal.value2) EQ "">
    <div class="card"><div class="card-header"><h2>Block Unavailable</h2></div><div class="card-body"><p>The quarantine portal host is not configured.</p></div></div>
    <cfabort>
</cfif>

<cfquery name="getmsg" datasource="hermes">
    SELECT m.mail_id, m.secret_id,
           ma_rcpt.email AS recipient_email,
           COALESCE(ma_from.email, m.from_addr, '') AS from_email,
           m.subject
    FROM msgs m
    INNER JOIN msgrcpt mr ON m.mail_id = mr.mail_id
    INNER JOIN maddr ma_rcpt ON mr.rid = ma_rcpt.id
    LEFT JOIN maddr ma_from ON m.sid = ma_from.id
    WHERE m.mail_id = <cfqueryparam value="#tokenResult.mailId#" cfsqltype="cf_sql_varchar">
      AND m.secret_id = <cfqueryparam value="#tokenResult.secretId#" cfsqltype="cf_sql_varchar">
      AND ma_rcpt.email = <cfqueryparam value="#tokenResult.recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getmsg.recordcount LT 1 OR Trim(getmsg.from_email) EQ "">
    <div class="card"><div class="card-header"><h2>Block Failed</h2></div><div class="card-body"><p>The message or sender could not be resolved.</p></div></div>
    <cfabort>
</cfif>

<cfquery name="getRecipient" datasource="hermes">
    SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#getmsg.recipient_email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getRecipient.recordcount LT 1>
    <div class="card"><div class="card-header"><h2>Block Failed</h2></div><div class="card-body"><p>The recipient record could not be found.</p></div></div>
    <cfabort>
</cfif>

<cfquery name="getSenderAddress" datasource="hermes">
    SELECT CAST(ma.email AS CHAR(255)) AS sender_email,
           wa.id AS mailaddr_id
    FROM msgs m
    INNER JOIN maddr ma ON ma.id = m.sid
    LEFT JOIN mailaddr wa ON wa.email = CAST(ma.email AS CHAR(255))
    WHERE m.mail_id = <cfqueryparam value="#tokenResult.mailId#" cfsqltype="cf_sql_varchar">
      AND m.secret_id = <cfqueryparam value="#tokenResult.secretId#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getSenderAddress.recordcount LT 1 OR Trim(getSenderAddress.sender_email) EQ "">
    <div class="card"><div class="card-header"><h2>Block Failed</h2></div><div class="card-body"><p>The message sender could not be resolved.</p></div></div>
    <cfabort>
</cfif>

<cfif NOT Len(Trim(getSenderAddress.mailaddr_id))>
<cfquery datasource="hermes">
    INSERT INTO mailaddr (email)
    VALUES (<cfqueryparam value="#getSenderAddress.sender_email#" cfsqltype="cf_sql_varchar">)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)
</cfquery>
</cfif>

<cfquery name="getMailaddr" datasource="hermes">
    SELECT id FROM mailaddr WHERE email = <cfqueryparam value="#getSenderAddress.sender_email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset senderMailaddrId = getMailaddr.id>

<cfquery name="getExisting" datasource="hermes">
    SELECT wb FROM wblist
    WHERE rid = <cfqueryparam value="#getRecipient.id#" cfsqltype="cf_sql_integer">
      AND sid = <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery datasource="hermes">
    INSERT INTO wblist (rid, sid, wb)
    VALUES (
        <cfqueryparam value="#getRecipient.id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
        'B'
    )
    ON DUPLICATE KEY UPDATE wb = 'B'
</cfquery>

<cfif getExisting.recordcount LT 1>
    <cfset blockMessage = "The sender has been added to the recipient block list.">
    <cfset blockHeading = "Sender Blocked">
<cfelseif getExisting.wb EQ "B">
    <cfset blockMessage = "This sender is already blocked for the recipient.">
    <cfset blockHeading = "Sender Already Blocked">
<cfelse>
    <cfset blockMessage = "The existing sender rule has been updated to block this sender.">
    <cfset blockHeading = "Sender Rule Updated">
</cfif>

<div class="card">
    <div class="card-header"><h2 style="margin:0;"><cfoutput>#encodeForHTML(blockHeading)#</cfoutput></h2></div>
    <div class="card-body">
        <p><cfoutput>#encodeForHTML(blockMessage)#</cfoutput></p>
        <p><cfoutput><strong>Recipient:</strong> #encodeForHTML(getmsg.recipient_email)#<br><strong>Sender:</strong> #encodeForHTML(getmsg.from_email)#<br><strong>Subject:</strong> #encodeForHTML(getmsg.subject)#</cfoutput></p>
        <div class="actions"><cfoutput><a href="https://#encodeForHTMLAttribute(Trim(getportal.value2))#/users/2/view_sender_filters.cfm">Manage Sender Filters</a></cfoutput></div>
    </div>
</div>
</body>
</html>
