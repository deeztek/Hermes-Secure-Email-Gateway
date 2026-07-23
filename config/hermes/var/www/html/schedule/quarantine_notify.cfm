<!---
Hermes SEG - Near Real-Time Quarantine Notification
Runs every 60s via Ofelia (no-overlap). Sends individual notification emails
for each newly quarantined message to opted-in recipients.
See GitHub issue #180
--->

<!--- Include token generation functions --->
<cfinclude template="inc/quarantine_token.cfm">

<!--- Get system settings --->
<cfquery name="getpostmaster" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'postmaster'
</cfquery>

<cfquery name="getportal" datasource="hermes">
    SELECT value2 FROM parameters2 WHERE parameter = 'console.host' AND module = 'console'
</cfquery>

<cfif getpostmaster.recordcount LT 1 OR getportal.recordcount LT 1>
    quarantine_notify: missing postmaster or console.host setting<br>
    <cfabort>
</cfif>

<cfset postmasterEmail = getpostmaster.value>
<cfset consoleHost = getportal.value2>

<!--- Recency backstop (days). The notifier gates ONLY on notification_sent = 0,
      so ANY event that introduces old quarantine rows at 0 -- a legacy->Docker
      migration, a cross-host restore/DR rehost, a manual DB import -- otherwise
      makes it treat the entire quarantine history as brand-new and blast a
      notification for every message ever held (observed: 49k+ queued after a
      migration). This window makes that structurally impossible: a message
      older than the window is never notified regardless of the flag. Trade-off:
      if the notifier (or the box) is down longer than the window, quarantines
      that age past it are silently skipped -- acceptable for a courtesy notice. --->
<cfset notifyWindowDays = 7>

<!--- Find quarantined messages that haven't been notified yet AND are recent --->
<!--- Step 1: Get pending mail_ids from msgrcpt (uses idx_msgrcpt_notify index),
      joined to msgs for the age filter (msgs_idx_time_num). --->
<cfquery name="getPendingIds" datasource="hermes">
    SELECT mr.mail_id, mr.rid
    FROM msgrcpt mr
    INNER JOIN msgs m ON m.mail_id = mr.mail_id
    WHERE mr.ds IN ('B', 'D')
      AND mr.notification_sent = 0
      AND m.time_num >= (UNIX_TIMESTAMP() - (86400 * <cfqueryparam value="#notifyWindowDays#" cfsqltype="cf_sql_integer">))
    LIMIT 100
</cfquery>

<cfif getPendingIds.recordcount LT 1>
    quarantine_notify: no pending notifications<br>
    <cfabort>
</cfif>

<!--- Step 2: Get full details only for the pending messages --->
<cfquery name="getPending" datasource="hermes">
    SELECT
        m.mail_id,
        m.secret_id,
        m.sid,
        m.spam_level,
        m.time_iso,
        m.subject,
        m.from_addr,
        m.content,
        mr.rid,
        mr.ds,
        ma_rcpt.email AS recipient_email,
        ma_from.email AS from_email
    FROM msgrcpt mr
    INNER JOIN msgs m ON m.mail_id = mr.mail_id
    INNER JOIN maddr ma_rcpt ON mr.rid = ma_rcpt.id
    LEFT JOIN maddr ma_from ON m.sid = ma_from.id
    WHERE mr.mail_id IN (<cfqueryparam value="#valueList(getPendingIds.mail_id)#" cfsqltype="cf_sql_varchar" list="true">)
      AND mr.rid IN (<cfqueryparam value="#valueList(getPendingIds.rid)#" cfsqltype="cf_sql_integer" list="true">)
      AND mr.ds IN ('B', 'D')
      AND mr.notification_sent = 0
    ORDER BY m.time_iso ASC
</cfquery>

<cfif getPending.recordcount LT 1>
    quarantine_notify: no pending notifications<br>
    <cfabort>
</cfif>

<cfoutput>quarantine_notify: processing #getPending.recordcount# pending notifications<br></cfoutput>

<!--- Process each pending notification --->
<cfloop query="getPending">

    <!--- Set local variables from query row - use toString() to prevent Lucee treating values as char arrays --->
    <cfset row = queryGetRow(getPending, getPending.currentRow)>
    <cfset thisMailId = toString(row.mail_id)>
    <cfset thisSecretId = toString(row.secret_id)>
    <cfset thisRid = toString(row.rid)>
    <cfset thisRecipientEmail = toString(row.recipient_email)>
    <cfset thisFromEmail = toString(row.from_email)>
    <cfset thisSubject = toString(row.subject)>
    <cfset thisContent = toString(row.content)>
    <cfset thisSpamLevel = row.spam_level>
    <cfset thisTimeIso = row.time_iso>

    <!--- Check if this recipient has notifications enabled --->
    <cfquery name="getUserSettings" datasource="hermes">
        SELECT us.report_enabled
        FROM user_settings us
        INNER JOIN recipients r ON r.recipient = us.email
        WHERE us.email = <cfqueryparam value="#thisRecipientEmail#" cfsqltype="cf_sql_varchar">
          AND us.report_enabled IN ('YES', 'ALL')
    </cfquery>

    <cfif getUserSettings.recordcount LT 1>
        <!--- User has notifications disabled or is not a configured recipient - mark as skipped --->
        <cfquery datasource="hermes">
            UPDATE msgrcpt SET notification_sent = 2
            WHERE mail_id = <cfqueryparam value="#thisMailId#" cfsqltype="cf_sql_varchar">
              AND rid = <cfqueryparam value="#thisRid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfoutput>#thisRecipientEmail#: skipped (notifications disabled)<br></cfoutput>
        <cfcontinue>
    </cfif>

    <!--- Get content type description --->
    <cfquery name="gettype" datasource="hermes">
        SELECT description FROM msg_content_type WHERE content_type LIKE BINARY <cfqueryparam value="#thisContent#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfset contentDesc = gettype.recordcount GTE 1 ? gettype.description : thisContent>

    <!--- Generate tokenized release URL --->
    <cfset releaseUrl = generateQuarantineReleaseUrl(thisMailId, thisSecretId, thisRecipientEmail, consoleHost)>

    <!--- Format date/time --->
    <cfset msgDate = DateFormat(thisTimeIso, "mm/dd/yyyy")>
    <cfset msgTime = TimeFormat(thisTimeIso, "hh:mm:ss tt")>

    <!--- Send notification email --->
    <cftry>
    <cfmail from="#postmasterEmail#" to="#trim(thisRecipientEmail)#"
            subject="[Quarantine Notice] Message from #thisFromEmail# held for review"
            type="HTML" server="hermes_postfix_dkim" port="10026">
    <HTML>
    <head><title>Hermes SEG Quarantine Notice</title></head>
    <body style="margin:0; padding:0; font-family:Arial,Helvetica,sans-serif; font-size:14px; color:##333333;">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="max-width:600px; margin:0 auto;">
        <!-- Header -->
        <tr>
            <td style="text-align:center; padding:20px 0;">
                <img src="cid:hermeslogo" style="max-height:80px; width:auto;" alt="Hermes Secure Email Gateway">
            </td>
        </tr>

        <!-- Notice -->
        <tr>
            <td style="padding:0 20px;">
                <p style="text-align:center; font-size:16px; font-weight:bold; color:##d9534f;">
                    A message to your address has been quarantined
                </p>
                <hr style="border:none; border-top:1px solid ##ddd;">
            </td>
        </tr>

        <!-- Message Details -->
        <tr>
            <td style="padding:10px 20px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="8" style="border:1px solid ##ddd; border-collapse:collapse;">
                    <tr style="background-color:##f9f9f9;">
                        <td style="border:1px solid ##ddd; font-weight:bold; width:120px;">Date/Time</td>
                        <td style="border:1px solid ##ddd;">#msgDate# #msgTime#</td>
                    </tr>
                    <tr>
                        <td style="border:1px solid ##ddd; font-weight:bold;">From</td>
                        <td style="border:1px solid ##ddd;">#encodeForHTML(thisFromEmail)#</td>
                    </tr>
                    <tr style="background-color:##f9f9f9;">
                        <td style="border:1px solid ##ddd; font-weight:bold;">Subject</td>
                        <td style="border:1px solid ##ddd;">#encodeForHTML(thisSubject)#</td>
                    </tr>
                    <tr>
                        <td style="border:1px solid ##ddd; font-weight:bold;">Type</td>
                        <td style="border:1px solid ##ddd;">#encodeForHTML(contentDesc)#</td>
                    </tr>
                    <tr style="background-color:##f9f9f9;">
                        <td style="border:1px solid ##ddd; font-weight:bold;">Spam Score</td>
                        <td style="border:1px solid ##ddd;">#NumberFormat(thisSpamLevel, '____.__')#</td>
                    </tr>
                </table>
            </td>
        </tr>

        <!-- Release Button -->
        <tr>
            <td style="padding:20px; text-align:center;">
                <a href="#releaseUrl#"
                   style="display:inline-block; padding:12px 30px; background-color:##337ab7; color:##ffffff; text-decoration:none; border-radius:4px; font-weight:bold; font-size:15px;">
                    Release Message
                </a>
                <p style="margin-top:8px; font-size:12px; color:##999;">This link expires in 72 hours. No login required.</p>
            </td>
        </tr>

        <tr>
            <td style="padding:0 20px;">
                <hr style="border:none; border-top:1px solid ##ddd;">
            </td>
        </tr>

        <!-- Portal Links (require login) -->
        <tr>
            <td style="padding:10px 20px;">
                <p style="font-size:13px; color:##666;">
                    <strong>More actions (login required):</strong><br>
                    <a href="https://#consoleHost#/users/2/view_message_history.cfm">Message History</a> |
                    <a href="https://#consoleHost#/users/2/view_sender_filters.cfm">Sender Filters</a> |
                    <a href="https://#consoleHost#/users/2/report_settings.cfm">Notification Settings</a>
                </p>
            </td>
        </tr>

        <!-- Footer -->
        <tr>
            <td style="padding:20px; text-align:center; font-size:11px; color:##999; border-top:1px solid ##eee;">
                This is an automated notification from Hermes Secure Email Gateway.<br>
                To stop receiving these notifications, visit <a href="https://#consoleHost#/users/2/report_settings.cfm">Notification Settings</a>.
            </td>
        </tr>
    </table>

    </body>
    </HTML>

    <cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline">

    </cfmail>

    <!--- Mark as sent --->
    <cfquery datasource="hermes">
        UPDATE msgrcpt SET notification_sent = 1
        WHERE mail_id = <cfqueryparam value="#thisMailId#" cfsqltype="cf_sql_varchar">
          AND rid = <cfqueryparam value="#thisRid#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfoutput>#thisRecipientEmail#: notification sent for #encodeForHTML(thisSubject)#<br></cfoutput>

    <cfcatch type="any">
        <cfoutput>#thisRecipientEmail#: ERROR sending notification - #cfcatch.message#<br></cfoutput>
    </cfcatch>
    </cftry>

</cfloop>

quarantine_notify: done<br>
