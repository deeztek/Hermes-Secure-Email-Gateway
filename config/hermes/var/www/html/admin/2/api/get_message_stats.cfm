<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!--- AJAX endpoint for message statistics - returns JSON --->
<cfcontent type="application/json">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">

<cftry>

<!--- Get time period from URL parameter (default: 24 hours) --->
<cfparam name="url.period" default="24">

<!--- Validate period parameter --->
<cfset validPeriods = "0.25,1,8,12,24">
<cfif NOT listFind(validPeriods, url.period)>
    <cfset url.period = 24>
</cfif>

<!--- Calculate date range based on period --->
<cfset periodEnd = now()>
<cfset periodStart = dateAdd("h", -url.period, periodEnd)>

<!--- Convert to Unix timestamps for indexed time_num column --->
<cfset periodStartUnix = dateDiff("s", createDateTime(1970,1,1,0,0,0), periodStart)>
<cfset periodEndUnix = dateDiff("s", createDateTime(1970,1,1,0,0,0), periodEnd)>

<!--- Format period label for response --->
<cfswitch expression="#url.period#">
    <cfcase value="0.25">
        <cfset periodLabel = "Past 15 Minutes">
    </cfcase>
    <cfcase value="1">
        <cfset periodLabel = "Past Hour">
    </cfcase>
    <cfcase value="8">
        <cfset periodLabel = "Past 8 Hours">
    </cfcase>
    <cfcase value="12">
        <cfset periodLabel = "Past 12 Hours">
    </cfcase>
    <cfdefaultcase>
        <cfset periodLabel = "Past 24 Hours">
    </cfdefaultcase>
</cfswitch>

<!--- Get message counts from most recent 10,000 messages in the time period --->
<!--- Uses Amavis content codes: C=clean, S=spam, V=virus, B=banned, H=bad header, ?/NULL/other=unknown --->
<!--- Uses time_num (Unix timestamp) which is indexed for better performance --->
<cfset maxMessages = 10000>
<cfquery name="getStats" datasource="hermes">
    SELECT
        COUNT(*) as total,
        SUM(CASE WHEN content = 'C' THEN 1 ELSE 0 END) as clean,
        SUM(CASE WHEN content = 'S' THEN 1 ELSE 0 END) as spam,
        SUM(CASE WHEN content = 'V' THEN 1 ELSE 0 END) as virus,
        SUM(CASE WHEN content = 'B' THEN 1 ELSE 0 END) as banned,
        SUM(CASE WHEN content = 'H' THEN 1 ELSE 0 END) as badHeader,
        SUM(CASE WHEN content IS NULL OR content = '' OR content NOT IN ('C','S','V','B','H') THEN 1 ELSE 0 END) as other,
        SUM(CASE WHEN originating = 'Y' THEN 1 ELSE 0 END) as outgoing,
        SUM(CASE WHEN originating <> 'Y' OR originating IS NULL OR originating = '' THEN 1 ELSE 0 END) as incoming
    FROM (
        SELECT content, originating
        FROM msgs
        WHERE time_num >= <cfqueryparam cfsqltype="cf_sql_integer" value="#periodStartUnix#">
          AND time_num < <cfqueryparam cfsqltype="cf_sql_integer" value="#periodEndUnix#">
        ORDER BY time_num DESC
        LIMIT #maxMessages#
    ) as recent_msgs
</cfquery>

<!--- Top 10 senders in selected period (recent capped data) --->
<cfquery name="getTopSenders" datasource="hermes">
    SELECT
        maddr.email as email,
        COUNT(*) as total
    FROM (
        SELECT mail_id, sid
        FROM msgs
        WHERE time_num >= <cfqueryparam cfsqltype="cf_sql_integer" value="#periodStartUnix#">
          AND time_num < <cfqueryparam cfsqltype="cf_sql_integer" value="#periodEndUnix#">
        ORDER BY time_num DESC
        LIMIT #maxMessages#
    ) as recent_msgs
    LEFT JOIN maddr ON recent_msgs.sid = maddr.id
    GROUP BY maddr.email
    ORDER BY total DESC
    LIMIT 10
</cfquery>

<!--- Top 10 recipients in selected period (recent capped data) --->
<cfquery name="getTopRecipients" datasource="hermes">
    SELECT
        maddr.email as email,
        COUNT(*) as total
    FROM msgrcpt
    INNER JOIN maddr ON msgrcpt.rid = maddr.id
    INNER JOIN (
        SELECT mail_id
        FROM msgs
        WHERE time_num >= <cfqueryparam cfsqltype="cf_sql_integer" value="#periodStartUnix#">
          AND time_num < <cfqueryparam cfsqltype="cf_sql_integer" value="#periodEndUnix#">
        ORDER BY time_num DESC
        LIMIT #maxMessages#
    ) as recent_msgs ON msgrcpt.mail_id = recent_msgs.mail_id
    GROUP BY maddr.email
    ORDER BY total DESC
    LIMIT 10
</cfquery>

<cfset topSenders = []>
<cfloop query="getTopSenders">
    <cfset senderEmail = "(unknown)">
    <cfif IsDefined("getTopSenders.email") AND Len(Trim(getTopSenders.email))>
        <cfset senderEmail = Trim(getTopSenders.email)>
    </cfif>
    <cfset arrayAppend(topSenders, {
        "email": senderEmail,
        "count": getTopSenders.total
    })>
</cfloop>

<cfset topRecipients = []>
<cfloop query="getTopRecipients">
    <cfset recipientEmail = "(unknown)">
    <cfif IsDefined("getTopRecipients.email") AND Len(Trim(getTopRecipients.email))>
        <cfset recipientEmail = Trim(getTopRecipients.email)>
    </cfif>
    <cfset arrayAppend(topRecipients, {
        "email": recipientEmail,
        "count": getTopRecipients.total
    })>
</cfloop>

<!--- Build response structure --->
<cfif getStats.total GTE maxMessages>
    <cfset isLimited = true>
<cfelse>
    <cfset isLimited = false>
</cfif>
<cfset response = {
    "success": true,
    "period": url.period,
    "periodLabel": periodLabel,
    "startTime": dateTimeFormat(periodStart, "yyyy-mm-dd HH:nn:ss"),
    "endTime": dateTimeFormat(periodEnd, "yyyy-mm-dd HH:nn:ss"),
    "total": getStats.total,
    "clean": getStats.clean,
    "spam": getStats.spam,
    "virus": getStats.virus,
    "banned": getStats.banned,
    "badHeader": getStats.badHeader,
    "other": getStats.other,
    "incoming": getStats.incoming,
    "outgoing": getStats.outgoing,
    "topSenders": topSenders,
    "topRecipients": topRecipients,
    "processingTimeAvailable": false,
    "processingTimeNote": "Average processing time is not available from the current message log tables.",
    "limited": isLimited,
    "maxMessages": maxMessages
}>

<cfcatch type="any">
    <cfset response = {
        "success": false,
        "error": cfcatch.message
    }>
</cfcatch>
</cftry>

<cfoutput>#serializeJSON(response)#</cfoutput>
