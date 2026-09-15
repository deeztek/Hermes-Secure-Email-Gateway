<!---
Hermes SEG - Tokenized Quarantine Message View
Public endpoint (no Authelia login required).
--->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hermes SEG | View Quarantined Message</title>
    <style>
        body { font-family: Arial, Helvetica, sans-serif; background: #f4f6f9; margin: 0; padding: 32px 16px; color: #333; }
        .wrap { max-width: 900px; margin: 0 auto; }
        .logo { text-align: center; margin-bottom: 20px; }
        .logo img { max-height: 60px; }
        .card { background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .card-header { background: #f97316; color: #fff; padding: 20px 24px; }
        .card-body { padding: 24px; }
        .meta { margin: 0 0 18px; line-height: 1.7; }
        .actions a { display: inline-block; margin: 0 10px 10px 0; padding: 10px 16px; border-radius: 6px; text-decoration: none; font-weight: bold; }
        .btn-view { border: 1px solid #f97316; color: #f97316; }
        .btn-release { background: #f97316; color: #fff; }
        .btn-block { background: #dc3545; color: #fff; }
        pre { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 8px; padding: 16px; white-space: pre-wrap; word-break: break-word; }
    </style>
</head>
<body>
<div class="wrap">
<div class="logo">
    <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes Secure Email Gateway">
</div>

<cfparam name="url.token" default="">
<cfif url.token EQ "">
    <div class="card"><div class="card-header"><h2>Invalid Request</h2></div><div class="card-body"><p>No view token was provided.</p></div></div>
    <cfabort>
</cfif>

<cfinclude template="/schedule/inc/quarantine_token.cfm">
<cfset tokenResult = validateQuarantineActionToken(url.token, "view")>

<cfif NOT tokenResult.valid>
    <div class="card"><div class="card-header"><h2>Invalid Link</h2></div><div class="card-body"><p><cfoutput>#encodeForHTML(tokenResult.error EQ 'expired' ? 'This view link has expired.' : 'This view link is not valid.')#</cfoutput></p></div></div>
    <cfabort>
</cfif>

<cfquery name="getportal" datasource="hermes">
    SELECT value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<cfif getportal.recordcount LT 1 OR Trim(getportal.value2) EQ "">
    <div class="card"><div class="card-header"><h2>View Unavailable</h2></div><div class="card-body"><p>The quarantine portal host is not configured.</p></div></div>
    <cfabort>
</cfif>

<cfquery name="getmsg" datasource="hermes">
    SELECT m.mail_id, m.secret_id, m.quar_loc, m.subject, m.time_iso, m.archive,
           ma_rcpt.email AS recipient_email,
           COALESCE(ma_from.email, m.from_addr, 'unknown sender') AS from_email
    FROM msgs m
    INNER JOIN msgrcpt mr ON m.mail_id = mr.mail_id
    INNER JOIN maddr ma_rcpt ON mr.rid = ma_rcpt.id
    LEFT JOIN maddr ma_from ON m.sid = ma_from.id
    WHERE m.mail_id = <cfqueryparam value="#tokenResult.mailId#" cfsqltype="cf_sql_varchar">
      AND m.secret_id = <cfqueryparam value="#tokenResult.secretId#" cfsqltype="cf_sql_varchar">
      AND ma_rcpt.email = <cfqueryparam value="#tokenResult.recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getmsg.recordcount LT 1>
    <div class="card"><div class="card-header"><h2>Message Not Found</h2></div><div class="card-body"><p>The quarantined message could not be found.</p></div></div>
    <cfabort>
</cfif>

<cfif getmsg.archive EQ "Y">
    <cfset quarFile = "/mnt/hermesemail_archive/mnt/data/amavis/" & getmsg.quar_loc>
<cfelse>
    <cfset quarFile = "/mnt/data/amavis/" & getmsg.quar_loc>
</cfif>

<cfif NOT fileExists(quarFile)>
    <div class="card"><div class="card-header"><h2>Message Unavailable</h2></div><div class="card-body"><p>This quarantined file is no longer available.</p></div></div>
    <cfabort>
</cfif>

<cfset popAccount = createObject("component", "cfc.pop4.pop").init()>
<cfset message = popAccount.loadFromFile(quarFile)>
<cfset safeBody = Trim(message.textbody)>
<cfset htmlOnlyBody = "">
<cfif safeBody EQ "" AND Len(Trim(message.htmlbody))>
    <cfset htmlOnlyBody = Trim(message.htmlbody)>
<cfelseif safeBody EQ "">
    <cfset safeBody = "This quarantined message does not contain a displayable message body.">
</cfif>
<cfset safeBody = Trim(safeBody)>
<cfset releaseUrl = generateQuarantineActionUrl(getmsg.mail_id, getmsg.secret_id, getmsg.recipient_email, Trim(getportal.value2), "release")>
<cfset blockUrl = generateQuarantineActionUrl(getmsg.mail_id, getmsg.secret_id, getmsg.recipient_email, Trim(getportal.value2), "block")>

<div class="card">
    <div class="card-header">
        <h2 style="margin:0;">View Quarantined Message</h2>
    </div>
    <div class="card-body">
        <div class="meta">
            <cfoutput>
            <strong>Recipient:</strong> #encodeForHTML(getmsg.recipient_email)#<br>
            <strong>From:</strong> #encodeForHTML(getmsg.from_email)#<br>
            <strong>Subject:</strong> #encodeForHTML(getmsg.subject)#<br>
            <strong>Date:</strong> #DateFormat(getmsg.time_iso, "mm/dd/yyyy")# #TimeFormat(getmsg.time_iso, "hh:mm:ss tt")#
            </cfoutput>
        </div>
        <div class="actions">
            <cfoutput>
            <a class="btn-release" href="#releaseUrl#">Release Message</a>
            <a class="btn-block" href="#blockUrl#">Block Sender</a>
            </cfoutput>
        </div>
        <h3>Message Body</h3>
        <cfif htmlOnlyBody NEQ "">
            <p style="color:#6b7280;">This message only contains HTML. The HTML source is shown below for safety.</p>
            <pre><cfoutput>#encodeForHTML(htmlOnlyBody)#</cfoutput></pre>
        <cfelse>
            <pre><cfoutput>#encodeForHTML(safeBody)#</cfoutput></pre>
        </cfif>
        <p style="margin-top:20px; color:#6b7280;">For privacy, this public view shows the message body and key envelope details only. Full raw headers remain available from the authenticated user portal.</p>
    </div>
</div>
</div>
</body>
</html>
