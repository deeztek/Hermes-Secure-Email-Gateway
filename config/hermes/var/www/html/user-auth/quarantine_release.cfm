<!---
Hermes SEG - Tokenized Quarantine Message Release
Public endpoint (no Authelia login required).
Validates HMAC-SHA256 token and releases the quarantined message.
See GitHub issue #180
--->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hermes SEG | Release Quarantined Message</title>
    <style>
        body { font-family: Arial, Helvetica, sans-serif; background: #f4f6f9; margin: 0; padding: 40px 20px; color: #333; }
        .card { max-width: 500px; margin: 0 auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .card-header { padding: 20px 24px; text-align: center; }
        .card-header.success { background: #28a745; color: #fff; }
        .card-header.error { background: #dc3545; color: #fff; }
        .card-header.info { background: #17a2b8; color: #fff; }
        .card-header h2 { margin: 0; font-size: 20px; }
        .card-body { padding: 24px; }
        .card-body p { margin: 0 0 12px; line-height: 1.5; }
        .icon { font-size: 48px; margin-bottom: 10px; }
        .logo { text-align: center; margin-bottom: 20px; }
        .logo img { max-height: 60px; }
    </style>
</head>
<body>

<div class="logo">
    <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes Secure Email Gateway">
</div>

<cfparam name="url.token" default="">

<cfif url.token EQ "">
    <div class="card">
        <div class="card-header error"><div class="icon">&#10060;</div><h2>Invalid Request</h2></div>
        <div class="card-body"><p>No release token was provided.</p></div>
    </div>
    <cfabort>
</cfif>

<!--- Include token validation functions --->
<cfinclude template="/schedule/inc/quarantine_token.cfm">

<!--- Validate the token --->
<cfset tokenResult = validateQuarantineReleaseToken(url.token)>

<cfif NOT tokenResult.valid>
    <div class="card">
        <cfif tokenResult.error EQ "expired">
            <div class="card-header info"><div class="icon">&#9200;</div><h2>Link Expired</h2></div>
            <div class="card-body">
                <p>This release link has expired.</p>
                <p>You can still release this message by logging into the <a href="https://<cfoutput><cfquery name="getportal" datasource="hermes">SELECT value2 FROM parameters2 WHERE parameter='console.host' AND module='console'</cfquery>#getportal.value2#</cfoutput>/users/2/view_message_history.cfm">User Portal</a> and using the Message History page.</p>
            </div>
        <cfelse>
            <div class="card-header error"><div class="icon">&#10060;</div><h2>Invalid Link</h2></div>
            <div class="card-body"><p>This release link is not valid. It may have been tampered with or the message no longer exists.</p></div>
        </cfif>
    </div>
    <cfabort>
</cfif>

<!--- Token is valid — look up the quarantine details --->
<cfquery name="getmsg" datasource="hermes">
    SELECT m.mail_id, m.secret_id, m.quar_loc, m.subject,
           ma_rcpt.email AS recipient_email,
           ma_from.email AS from_email
    FROM msgs m
    INNER JOIN msgrcpt mr ON m.mail_id = mr.mail_id
    INNER JOIN maddr ma_rcpt ON mr.rid = ma_rcpt.id
    LEFT JOIN maddr ma_from ON m.sid = ma_from.id
    WHERE m.mail_id = <cfqueryparam value="#tokenResult.mailId#" cfsqltype="cf_sql_varchar">
      AND m.secret_id = <cfqueryparam value="#tokenResult.secretId#" cfsqltype="cf_sql_varchar">
      AND ma_rcpt.email = <cfqueryparam value="#tokenResult.recipientEmail#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getmsg.recordcount LT 1>
    <div class="card">
        <div class="card-header error"><div class="icon">&#10060;</div><h2>Message Not Found</h2></div>
        <div class="card-body"><p>The quarantined message could not be found. It may have already been released or deleted.</p></div>
    </div>
    <cfabort>
</cfif>

<!--- Check if quarantine file still exists --->
<cfset quarFile = "/mnt/data/amavis/" & getmsg.quar_loc>

<cfif NOT fileExists(quarFile)>
    <div class="card">
        <div class="card-header info"><div class="icon">&#9989;</div><h2>Already Released</h2></div>
        <div class="card-body"><p>This message (<strong><cfoutput>#encodeForHTML(getmsg.subject)#</cfoutput></strong>) has already been released or removed from quarantine.</p></div>
    </div>
    <cfabort>
</cfif>

<!--- Release the message via docker exec --->
<!--- Validate inputs contain only safe characters before passing to shell --->
<cfif REFind("[^A-Za-z0-9\-\_\.\/\@\+]", getmsg.quar_loc) GT 0
   OR REFind("[^A-Za-z0-9\-\_]", getmsg.secret_id) GT 0
   OR REFind("[^A-Za-z0-9\-\_\.\@\+]", getmsg.recipient_email) GT 0>
    <div class="card">
        <div class="card-header error"><div class="icon">&#10060;</div><h2>Release Failed</h2></div>
        <div class="card-body"><p>Invalid message data. Please release this message from the User Portal.</p></div>
    </div>
    <cfabort>
</cfif>
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter /usr/sbin/amavisd-release #getmsg.quar_loc# #getmsg.secret_id# #getmsg.recipient_email#"
        timeout="60"
        variable="releaseOutput"
        errorVariable="releaseError">
    </cfexecute>

    <cfset allOutput = releaseOutput & " " & releaseError>
    <cfif FindNoCase("250", allOutput)>
        <div class="card">
            <div class="card-header success"><div class="icon">&#9989;</div><h2>Message Released</h2></div>
            <div class="card-body">
                <p>The message <strong><cfoutput>#encodeForHTML(getmsg.subject)#</cfoutput></strong> from <strong><cfoutput>#encodeForHTML(getmsg.from_email EQ "" ? "unknown sender" : getmsg.from_email)#</cfoutput></strong> has been released to your mailbox.</p>
                <p>It should arrive within a few minutes.</p>
            </div>
        </div>
    <cfelse>
        <div class="card">
            <div class="card-header error"><div class="icon">&#10060;</div><h2>Release Failed</h2></div>
            <div class="card-body"><p>The message could not be released. It may have already been released or the quarantine file is no longer available.</p></div>
        </div>
    </cfif>

<cfcatch type="any">
    <div class="card">
        <div class="card-header error"><div class="icon">&#10060;</div><h2>Release Failed</h2></div>
        <div class="card-body"><p>An error occurred while attempting to release this message. Please try releasing it from the <a href="https://<cfoutput><cfquery name="getportal2" datasource="hermes">SELECT value2 FROM parameters2 WHERE parameter='console.host' AND module='console'</cfquery>#getportal2.value2#</cfoutput>/users/2/view_message_history.cfm">User Portal</a>.</p></div>
    </div>
</cfcatch>
</cftry>

</body>
</html>
