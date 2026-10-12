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

<!--- AJAX endpoint for the dashboard Messages Processed chart - returns JSON.

     Returns, for the chosen period, a count per time bucket and per message
     type (one series per Amavis content code) plus totals for the period.

     Every message is counted. This used to sample the newest 10,000 in the
     period, which already undercounted "Past 24 Hours" on a busy gateway and
     cannot support 7 or 30 days. The GROUP BY runs on
     idx_msgs_time_content (time_num, content), so it is answered from the
     index without reading table rows.

     Buckets are aligned to the BROWSER's time zone (url.tz, minutes, as
     returned by JavaScript's getTimezoneOffset), so daily points start at the
     viewer's local midnight rather than UTC's.

     The dashboard polls every 60 seconds. The window end is rounded up to a
     bucket boundary, which keeps the query parameters identical between polls
     inside one bucket, so cachedwithin can serve repeats: a 30-day view hits
     the database at most every 5 minutes however many dashboards are open. --->

<cfcontent type="application/json">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">

<cftry>

<cfparam name="url.period" default="24">
<cfparam name="url.tz" default="0">

<!--- Period (hours) -> bucket size (seconds). Each gives 12 to 32 points. --->
<cfset bucketFor = {
    "0.25": 60,
    "1":    300,
    "8":    900,
    "12":   1800,
    "24":   3600,
    "168":  21600,
    "720":  86400
}>
<cfset labelFor = {
    "0.25": "Past 15 Minutes",
    "1":    "Past Hour",
    "8":    "Past 8 Hours",
    "12":   "Past 12 Hours",
    "24":   "Past 24 Hours",
    "168":  "Past 7 Days",
    "720":  "Past 30 Days"
}>
<cfif NOT StructKeyExists(bucketFor, url.period)>
    <cfset url.period = "24">
</cfif>
<cfset bucketSeconds = bucketFor[url.period]>

<!--- Browser offset in minutes, valid range -840..840 (UTC+14..UTC-14). --->
<cfif NOT IsValid("integer", url.tz) OR Abs(url.tz) GT 840>
    <cfset url.tz = 0>
</cfif>
<!--- getTimezoneOffset() is UTC minus local, so local = utc - tz*60. --->
<cfset tzShift = -1 * url.tz * 60>

<!--- Real Unix time. dateDiff from createDateTime(1970,...) measures from
     1970 in the server's local zone, which is off by the UTC offset. --->
<cfset nowUnix = Int(CreateObject("java", "java.lang.System").currentTimeMillis() / 1000)>

<!--- Window: N whole buckets, the last one containing "now". --->
<cfset bucketCount = Int(url.period * 3600 / bucketSeconds)>
<cfset lastBucketKey = Int((nowUnix + tzShift) / bucketSeconds)>
<cfset firstBucketKey = lastBucketKey - bucketCount + 1>
<cfset windowStart = firstBucketKey * bucketSeconds - tzShift>
<cfset windowEnd = (lastBucketKey + 1) * bucketSeconds - tzShift>

<cfset cacheSeconds = Min(bucketSeconds, 300)>

<cfquery name="getBuckets" datasource="hermes" cachedwithin="#CreateTimeSpan(0, 0, 0, cacheSeconds)#">
    SELECT
        FLOOR((time_num + <cfqueryparam cfsqltype="cf_sql_integer" value="#tzShift#">) / <cfqueryparam cfsqltype="cf_sql_integer" value="#bucketSeconds#">) AS bucket_key,
        content,
        COUNT(*) AS n
    FROM msgs
    WHERE time_num >= <cfqueryparam cfsqltype="cf_sql_integer" value="#windowStart#">
      AND time_num <  <cfqueryparam cfsqltype="cf_sql_integer" value="#windowEnd#">
    GROUP BY bucket_key, content
</cfquery>

<!--- Zero-filled series, one slot per bucket. --->
<cfset seriesNames = ["clean", "spam", "virus", "banned", "badHeader", "other"]>
<cfset codeToSeries = { "C": "clean", "S": "spam", "V": "virus", "B": "banned", "H": "badHeader" }>
<cfset series = {}>
<cfset totals = {}>
<cfloop array="#seriesNames#" index="name">
    <cfset series[name] = []>
    <cfset ArraySet(series[name], 1, bucketCount, 0)>
    <cfset totals[name] = 0>
</cfloop>

<cfloop query="getBuckets">
    <cfset slot = getBuckets.bucket_key - firstBucketKey + 1>
    <cfif slot GTE 1 AND slot LE bucketCount>
        <cfset code = UCase(Trim(getBuckets.content))>
        <cfset name = StructKeyExists(codeToSeries, code) ? codeToSeries[code] : "other">
        <cfset series[name][slot] = series[name][slot] + getBuckets.n>
        <cfset totals[name] = totals[name] + getBuckets.n>
    </cfif>
</cfloop>

<!--- Bucket start times as Unix seconds; the browser formats them locally. --->
<cfset bucketStarts = []>
<cfloop from="0" to="#bucketCount - 1#" index="i">
    <cfset ArrayAppend(bucketStarts, (firstBucketKey + i) * bucketSeconds - tzShift)>
</cfloop>

<cfset grandTotal = 0>
<cfloop array="#seriesNames#" index="name">
    <cfset grandTotal = grandTotal + totals[name]>
</cfloop>

<cfset response = {
    "success": true,
    "period": url.period,
    "periodLabel": labelFor[url.period],
    "bucketSeconds": bucketSeconds,
    "buckets": bucketStarts,
    "series": series,
    "total": grandTotal,
    "clean": totals.clean,
    "spam": totals.spam,
    "virus": totals.virus,
    "banned": totals.banned,
    "badHeader": totals.badHeader,
    "other": totals.other,
    "limited": false
}>

<cfcatch type="any">
    <cflog file="hermes" type="error" text="get_message_stats.cfm: #cfcatch.message# #cfcatch.detail#">
    <cfset response = {
        "success": false,
        "error": "Message statistics are temporarily unavailable."
    }>
</cfcatch>

</cftry>

<cfoutput>#serializeJSON(response)#</cfoutput>
