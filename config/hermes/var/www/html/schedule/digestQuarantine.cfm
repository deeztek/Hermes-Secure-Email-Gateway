<!---
Hermes SEG - Quarantine Digest Scheduler
Runs every 60s via Ofelia. Sends daily, weekly or monthly digest emails.
Use ?force to ignore the schedule window and emit verbose output.
--->

<cfinclude template="inc/quarantine_token.cfm">

<cfparam name="url.force" default="0">
<cfset forceRun = StructKeyExists(url, "force")>
<cfset verbose = forceRun>

<cfscript>
function getDigestSetting(required query q, required string name, string defaultValue="") {
    for (var row in q) {
        if (row.parameter EQ arguments.name) {
            return trim(toString(row.value2));
        }
    }
    return arguments.defaultValue;
}

function getDigestWindowStart(required string frequency, any lastRunValue, boolean forceRun = false) {
    if (!arguments.forceRun AND isDate(arguments.lastRunValue)) {
        return arguments.lastRunValue;
    }
    switch (lCase(arguments.frequency)) {
        case "weekly":
            return dateAdd("ww", -1, now());
        case "monthly":
            return dateAdd("m", -1, now());
        default:
            return dateAdd("d", -1, now());
    }
}

function shouldRunDigest(required string frequency, any lastRunValue, boolean forceRun = false) {
    if (arguments.forceRun OR !isDate(arguments.lastRunValue)) {
        return true;
    }
    switch (lCase(arguments.frequency)) {
        case "weekly":
            return now() GTE dateAdd("ww", 1, arguments.lastRunValue);
        case "monthly":
            return now() GTE dateAdd("m", 1, arguments.lastRunValue);
        default:
            return now() GTE dateAdd("d", 1, arguments.lastRunValue);
    }
}

function getTemplateConfig(required string templateName) {
    var templateKey = lCase(trim(arguments.templateName));
    var cfg = {
        bodyBg: "#f4f6f9",
        headerBg: "#f97316",
        accentBg: "#fff7ed",
        accentBorder: "#fdba74",
        buttonBg: "#f97316",
        cardRadius: "12px",
        tableHeaderBg: "#fff7ed",
        heading: "Quarantine Digest"
    };

    switch (templateKey) {
        case "classic":
            cfg.bodyBg = "#f8fafc";
            cfg.headerBg = "#1d4ed8";
            cfg.accentBg = "#eff6ff";
            cfg.accentBorder = "#93c5fd";
            cfg.buttonBg = "#2563eb";
            cfg.cardRadius = "6px";
            cfg.tableHeaderBg = "#dbeafe";
            cfg.heading = "Classic Quarantine Digest";
            break;
        case "compact":
            cfg.bodyBg = "#f3f4f6";
            cfg.headerBg = "#111827";
            cfg.accentBg = "#f9fafb";
            cfg.accentBorder = "#d1d5db";
            cfg.buttonBg = "#374151";
            cfg.cardRadius = "10px";
            cfg.tableHeaderBg = "#e5e7eb";
            cfg.heading = "Compact Quarantine Digest";
            break;
    }
    return cfg;
}
</cfscript>

<cftry>
<cflock name="digestQuarantineSchedulerLock" type="exclusive" timeout="1" throwOnTimeout="true">

<cfquery name="getDigestSettings" datasource="hermes">
    SELECT parameter, value2
    FROM parameters2
    WHERE module = 'quarantine_digest'
</cfquery>

<cfset digestEnabled = getDigestSetting(getDigestSettings, "enabled", "0")>
<cfset digestFrequency = lCase(getDigestSetting(getDigestSettings, "frequency", "daily"))>
<cfset digestTemplate = lCase(getDigestSetting(getDigestSettings, "template", "modern"))>
<cfset digestSubject = getDigestSetting(getDigestSettings, "subject", "[Hermes SEG] Quarantine Digest")>
<cfset digestIntro = getDigestSetting(getDigestSettings, "intro", "Review quarantined messages below. Secure links let recipients view, release, or block senders without signing in.")>
<cfset digestDisableIndividual = getDigestSetting(getDigestSettings, "disable_individual", "1")>
<cfset digestLastRunRaw = getDigestSetting(getDigestSettings, "last_run", "")>
<cfset digestLastRun = "">
<cfif digestLastRunRaw NEQ "" AND isDate(digestLastRunRaw)>
    <cfset digestLastRun = parseDateTime(digestLastRunRaw)>
</cfif>

<cfif digestEnabled NEQ "1">
    <cfoutput>digestQuarantine: feature disabled<br></cfoutput>
    <cfabort>
</cfif>

<cfif NOT ListFindNoCase("daily,weekly,monthly", digestFrequency)>
    <cfset digestFrequency = "daily">
</cfif>
<cfif NOT ListFindNoCase("modern,classic,compact", digestTemplate)>
    <cfset digestTemplate = "modern">
</cfif>

<cfif NOT shouldRunDigest(digestFrequency, digestLastRun, forceRun)>
    <cfoutput>digestQuarantine: not due yet (frequency=#digestFrequency# last_run=#encodeForHTML(digestLastRunRaw)#)<br></cfoutput>
    <cfabort>
</cfif>

<cfquery name="getpostmaster" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'postmaster'
</cfquery>

<cfquery name="getportal" datasource="hermes">
    SELECT value2 FROM parameters2 WHERE parameter = 'console.host' AND module = 'console'
</cfquery>

<cfif getpostmaster.recordcount LT 1 OR getportal.recordcount LT 1>
    digestQuarantine: missing postmaster or console.host setting<br>
    <cfabort>
</cfif>

<cfset postmasterEmail = Trim(getpostmaster.value)>
<cfset consoleHost = Trim(getportal.value2)>
<cfset windowStart = getDigestWindowStart(digestFrequency, digestLastRun, forceRun)>
<cfset windowEnd = now()>
<cfset templateConfig = getTemplateConfig(digestTemplate)>
<cfset sentCount = 0>
<cfset skippedCount = 0>
<cfset errorCount = 0>

<cfquery name="getRecipientMessages" datasource="hermes">
    SELECT r.recipient AS recipient_email,
           ma_rcpt.id AS rid,
           COALESCE(us.report_enabled, 'YES') AS report_enabled,
           digest_rows.mail_id,
           digest_rows.secret_id,
           digest_rows.spam_level,
           digest_rows.time_iso,
           digest_rows.subject,
           digest_rows.from_email
    FROM recipients r
    INNER JOIN maddr ma_rcpt ON ma_rcpt.email = r.recipient
    LEFT JOIN user_settings us ON us.email = r.recipient
    LEFT JOIN (
        SELECT mr.rid,
               m.mail_id,
               m.secret_id,
               m.spam_level,
               m.time_iso,
               m.subject,
               COALESCE(ma_from.email, m.from_addr, 'unknown sender') AS from_email
        FROM msgrcpt mr
        INNER JOIN msgs m ON m.mail_id = mr.mail_id
        LEFT JOIN maddr ma_from ON ma_from.id = m.sid
        LEFT JOIN quarantine_digest_deliveries qdd
               ON qdd.rid = mr.rid
              AND qdd.mail_id = CAST(m.mail_id AS CHAR(255))
        WHERE mr.ds IN ('B', 'D')
          AND m.time_iso <= <cfqueryparam value="#windowEnd#" cfsqltype="cf_sql_timestamp">
          AND (
                (qdd.mail_id IS NULL AND m.time_iso >= <cfqueryparam value="#windowStart#" cfsqltype="cf_sql_timestamp">)
             OR COALESCE(qdd.status, 'P') = 'F'
          )
          AND COALESCE(qdd.status, 'P') <> 'S'
        GROUP BY mr.rid, m.mail_id
    ) digest_rows ON digest_rows.rid = ma_rcpt.id
    WHERE COALESCE(us.report_enabled, 'YES') <> 'NO'
    ORDER BY r.recipient, digest_rows.time_iso DESC
</cfquery>

<cfscript>
recipientMap = structNew("ordered");
for (var row in getRecipientMessages) {
    var recipientKey = toString(row.recipient_email);
    if (!structKeyExists(recipientMap, recipientKey)) {
        recipientMap[recipientKey] = {
            recipientEmail: recipientKey,
            rid: row.rid,
            reportEnabled: toString(row.report_enabled),
            messages: []
        };
    }
    if (structKeyExists(row, "mail_id") && !isNull(row.mail_id) && len(trim(toString(row.mail_id)))) {
        arrayAppend(recipientMap[recipientKey].messages, {
            mail_id: toString(row.mail_id),
            secret_id: toString(row.secret_id),
            spam_level: row.spam_level,
            time_iso: row.time_iso,
            subject: toString(row.subject),
            from_email: toString(row.from_email)
        });
    }
}
recipientKeys = structKeyArray(recipientMap);
arraySort(recipientKeys, "textnocase");
</cfscript>

<cfoutput>digestQuarantine: evaluating #arrayLen(recipientKeys)# recipients from #DateFormat(windowStart, "yyyy-mm-dd")# #TimeFormat(windowStart, "HH:mm:ss")# through #DateFormat(windowEnd, "yyyy-mm-dd")# #TimeFormat(windowEnd, "HH:mm:ss")#<br></cfoutput>

<cfloop array="#recipientKeys#" index="recipientKey">
    <cfset recipientData = recipientMap[recipientKey]>
    <cfset recipientEmail = recipientData.recipientEmail>
    <cfset reportEnabled = recipientData.reportEnabled>
    <cfset recipientRid = recipientData.rid>
    <cfset messageList = recipientData.messages>
    <cfset messageCount = arrayLen(messageList)>

    <cfset sendEmptyDigest = (reportEnabled EQ "ALL")>
    <cfif messageCount EQ 0 AND NOT sendEmptyDigest>
        <cfset skippedCount = skippedCount + 1>
        <cfif verbose>
            <cfoutput>#encodeForHTML(recipientEmail)#: skipped (no quarantined messages)<br></cfoutput>
        </cfif>
        <cfcontinue>
    </cfif>

    <cfsavecontent variable="digestBodyHtml"><cfoutput>
    <html>
    <head>
        <title>#encodeForHTML(digestSubject)#</title>
    </head>
    <body style="margin:0; padding:24px; background:#templateConfig.bodyBg#; font-family:Arial,Helvetica,sans-serif; color:##1f2937;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="max-width:900px; margin:0 auto; background:##ffffff; border-radius:#templateConfig.cardRadius#; overflow:hidden;">
            <tr>
                <td style="background:#templateConfig.headerBg#; padding:24px; text-align:center; color:##ffffff;">
                    <img src="cid:hermeslogo" alt="Hermes Secure Email Gateway" style="max-height:64px; width:auto; display:block; margin:0 auto 16px;">
                    <h1 style="margin:0; font-size:24px;">#encodeForHTML(templateConfig.heading)#</h1>
                    <p style="margin:12px 0 0; font-size:14px; opacity:0.95;">#encodeForHTML(recipientEmail)#</p>
                </td>
            </tr>
            <tr>
                <td style="padding:24px;">
                    <div style="background:#templateConfig.accentBg#; border:1px solid #templateConfig.accentBorder#; border-radius:#templateConfig.cardRadius#; padding:16px; margin-bottom:20px;">
                        <p style="margin:0 0 10px; font-size:16px; font-weight:bold;">#encodeForHTML(digestSubject)#</p>
                        <p style="margin:0 0 8px; line-height:1.6;">#encodeForHTML(digestIntro)#</p>
                        <p style="margin:0; color:##6b7280; font-size:13px;">Window: #DateFormat(windowStart, "mm/dd/yyyy")# #TimeFormat(windowStart, "hh:mm tt")# - #DateFormat(windowEnd, "mm/dd/yyyy")# #TimeFormat(windowEnd, "hh:mm tt")#</p>
                    </div>

                    <p style="margin:0 0 16px; font-size:15px;">
                        <strong>#messageCount#</strong> quarantined message<cfif messageCount NEQ 1>s</cfif> found for this digest period.
                    </p>

                    <cfif messageCount EQ 0>
                        <div style="padding:18px; background:##f9fafb; border:1px dashed ##d1d5db; border-radius:#templateConfig.cardRadius#; color:##4b5563;">
                            No quarantined messages were found during this digest period.
                        </div>
                    <cfelse>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; font-size:14px;">
                            <tr style="background:#templateConfig.tableHeaderBg#;">
                                <th align="left" style="padding:12px; border:1px solid ##e5e7eb;">Date/Time</th>
                                <th align="left" style="padding:12px; border:1px solid ##e5e7eb;">From</th>
                                <th align="left" style="padding:12px; border:1px solid ##e5e7eb;">Subject</th>
                                <th align="left" style="padding:12px; border:1px solid ##e5e7eb;">Actions</th>
                            </tr>
                            <cfloop array="#messageList#" index="messageItem">
                                <cfset viewUrl = generateQuarantineActionUrl(messageItem.mail_id, messageItem.secret_id, recipientEmail, consoleHost, "view")>
                                <cfset releaseUrl = generateQuarantineActionUrl(messageItem.mail_id, messageItem.secret_id, recipientEmail, consoleHost, "release")>
                                <cfset blockUrl = generateQuarantineActionUrl(messageItem.mail_id, messageItem.secret_id, recipientEmail, consoleHost, "block")>
                                <tr>
                                    <td valign="top" style="padding:12px; border:1px solid ##e5e7eb; white-space:nowrap;">#DateFormat(messageItem.time_iso, "mm/dd/yyyy")#<br>#TimeFormat(messageItem.time_iso, "hh:mm:ss tt")#</td>
                                    <td valign="top" style="padding:12px; border:1px solid ##e5e7eb; word-break:break-word;">#encodeForHTML(messageItem.from_email)#</td>
                                    <td valign="top" style="padding:12px; border:1px solid ##e5e7eb; word-break:break-word;">#encodeForHTML(messageItem.subject)#</td>
                                    <td valign="top" style="padding:12px; border:1px solid ##e5e7eb; min-width:240px;">
                                        <a href="#viewUrl#" style="display:inline-block; margin:0 8px 8px 0; padding:9px 14px; background:##ffffff; border:1px solid #templateConfig.buttonBg#; color:#templateConfig.buttonBg#; text-decoration:none; border-radius:6px; font-weight:bold;">View</a>
                                        <a href="#releaseUrl#" style="display:inline-block; margin:0 8px 8px 0; padding:9px 14px; background:#templateConfig.buttonBg#; color:##ffffff; text-decoration:none; border-radius:6px; font-weight:bold;">Release</a>
                                        <a href="#blockUrl#" style="display:inline-block; margin:0 8px 8px 0; padding:9px 14px; background:##dc2626; color:##ffffff; text-decoration:none; border-radius:6px; font-weight:bold;">Block Sender</a>
                                    </td>
                                </tr>
                            </cfloop>
                        </table>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td style="padding:20px 24px; font-size:12px; color:##6b7280; border-top:1px solid ##e5e7eb;">
                    Secure links expire in 72 hours and do not require portal login. To stop all quarantine mail for a recipient, disable their quarantine notifications from the recipient or mailbox settings.
                </td>
            </tr>
        </table>
    </body>
    </html>
    </cfoutput></cfsavecontent>

    <cftry>
        <cfmail from="#postmasterEmail#"
                to="#trim(recipientEmail)#"
                subject="#digestSubject#"
                type="HTML"
                server="hermes_postfix_dkim"
                port="10026">#digestBodyHtml#
            <cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline">
        </cfmail>

        <cfif messageCount GT 0>
            <cfloop array="#messageList#" index="messageItem">
                <cfquery datasource="hermes">
                    INSERT INTO quarantine_digest_deliveries (rid, mail_id, status, last_attempt_at, delivered_at)
                    VALUES (
                        <cfqueryparam value="#recipientRid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#messageItem.mail_id#" cfsqltype="cf_sql_varchar">,
                        'S',
                        NOW(),
                        NOW()
                    )
                    ON DUPLICATE KEY UPDATE
                        status = 'S',
                        last_attempt_at = NOW(),
                        delivered_at = NOW()
                </cfquery>
            </cfloop>

            <cfif digestDisableIndividual EQ "1">
                <cfset deliveredMailIds = []>
                <cfloop array="#messageList#" index="messageItem">
                    <cfset arrayAppend(deliveredMailIds, messageItem.mail_id)>
                </cfloop>
                <cfquery datasource="hermes">
                    UPDATE msgrcpt
                    SET notification_sent = 2
                    WHERE rid = <cfqueryparam value="#recipientRid#" cfsqltype="cf_sql_integer">
                      AND mail_id IN (<cfqueryparam value="#arrayToList(deliveredMailIds)#" cfsqltype="cf_sql_varchar" list="true">)
                </cfquery>
            </cfif>
        </cfif>

        <cfset sentCount = sentCount + 1>
        <cfif verbose>
            <cfoutput>#encodeForHTML(recipientEmail)#: digest sent (#messageCount# messages)<br></cfoutput>
        </cfif>
    <cfcatch type="any">
        <cfset errorCount = errorCount + 1>
        <cfif messageCount GT 0>
            <cfloop array="#messageList#" index="messageItem">
                <cfquery datasource="hermes">
                    INSERT INTO quarantine_digest_deliveries (rid, mail_id, status, last_attempt_at, delivered_at)
                    VALUES (
                        <cfqueryparam value="#recipientRid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#messageItem.mail_id#" cfsqltype="cf_sql_varchar">,
                        'F',
                        NOW(),
                        NULL
                    )
                    ON DUPLICATE KEY UPDATE
                        status = 'F',
                        last_attempt_at = NOW(),
                        delivered_at = NULL
                </cfquery>
            </cfloop>
        </cfif>
        <cfoutput>#encodeForHTML(recipientEmail)#: ERROR sending digest - #encodeForHTML(cfcatch.message)#<br></cfoutput>
    </cfcatch>
    </cftry>
</cfloop>

<cfquery datasource="hermes">
    UPDATE parameters2
    SET value2 = <cfqueryparam value="#DateFormat(windowEnd, 'yyyy-mm-dd')# #TimeFormat(windowEnd, 'HH:mm:ss')#" cfsqltype="cf_sql_varchar">,
        applied = 2
    WHERE module = 'quarantine_digest'
      AND parameter = 'last_run'
</cfquery>

<cfif errorCount EQ 0>
    <cfoutput>digestQuarantine: complete (sent=#sentCount# skipped=#skippedCount# errors=#errorCount#)<br></cfoutput>
<cfelse>
    <cfoutput>digestQuarantine: complete with errors (sent=#sentCount# skipped=#skippedCount# errors=#errorCount# failed recipient deliveries remain queued for retry)<br></cfoutput>
</cfif>

</cflock>
<cfcatch type="lock">
    <cfoutput>digestQuarantine: another run is already in progress<br></cfoutput>
</cfcatch>
</cftry>
