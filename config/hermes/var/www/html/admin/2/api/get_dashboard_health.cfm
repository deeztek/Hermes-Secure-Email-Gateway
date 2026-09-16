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

<cfcontent type="application/json">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">

<cfif NOT StructKeyExists(session, "theUser")
    OR NOT StructKeyExists(session, "loggedin")
    OR session.loggedin NEQ "true"
    OR NOT StructKeyExists(session, "userid")
    OR NOT IsNumeric(session.userid)
    OR NOT StructKeyExists(session, "email")
    OR Trim(session.email) EQ "">
    <cfheader statuscode="401" statustext="Unauthorized">
    <cfoutput>{"success":false,"error":"Unauthorized"}</cfoutput>
    <cfabort>
</cfif>

<cfset response = {
    "success": true,
    "checks": [],
    "services": [],
    "summary": {
        "checkPass": 0,
        "checkTotal": 0,
        "serviceRunning": 0,
        "serviceTotal": 0
    }
}>

<cfset cacheTtlSeconds = 30>
<cfset cacheKey = "user-" & trim(session.userid)>
<cfset cachedResponseJson = "">
<cfset cacheIsValid = false>
<cfset responseJson = "">
<cflock scope="application" type="readonly" timeout="5">
    <cfif StructKeyExists(application, "dashboardHealthCacheByUser")
        AND IsStruct(application.dashboardHealthCacheByUser)
        AND StructKeyExists(application.dashboardHealthCacheByUser, cacheKey)
        AND IsStruct(application.dashboardHealthCacheByUser[cacheKey])
        AND StructKeyExists(application.dashboardHealthCacheByUser[cacheKey], "generatedAt")
        AND StructKeyExists(application.dashboardHealthCacheByUser[cacheKey], "responseJson")>
        <cfset cacheAgeSeconds = DateDiff("s", application.dashboardHealthCacheByUser[cacheKey].generatedAt, now())>
        <cfif cacheAgeSeconds GTE 0 AND cacheAgeSeconds LTE cacheTtlSeconds>
            <cfset cachedResponseJson = application.dashboardHealthCacheByUser[cacheKey].responseJson>
            <cfset cacheIsValid = true>
        </cfif>
    </cfif>
</cflock>

<cfif cacheIsValid>
    <cfoutput>#cachedResponseJson#</cfoutput>
    <cfabort>
</cfif>

<cftry>
    <cfquery name="getHeloRequired" datasource="hermes">
        SELECT enabled
        FROM parameters
        WHERE parameter = <cfqueryparam value="smtpd_helo_required" cfsqltype="cf_sql_varchar">
          AND child = '1'
        LIMIT 1
    </cfquery>

    <cfquery name="getRejectUnauthDestination" datasource="hermes">
        SELECT enabled
        FROM parameters
        WHERE parameter = <cfqueryparam value="reject_unauth_destination" cfsqltype="cf_sql_varchar">
          AND child = '1'
        LIMIT 1
    </cfquery>

    <cfquery name="getSpfEnabled" datasource="hermes">
        SELECT enabled
        FROM parameters
        WHERE parameter = <cfqueryparam value="check_policy_service unix:private/policy-spf" cfsqltype="cf_sql_varchar">
          AND child = '1'
        LIMIT 1
    </cfquery>

    <cfquery name="getSmtpdMiltersId" datasource="hermes">
        SELECT id
        FROM parameters
        WHERE parameter = <cfqueryparam value="smtpd_milters" cfsqltype="cf_sql_varchar">
          AND child = '2'
        LIMIT 1
    </cfquery>

    <cfset smtpdMiltersParentId = 0>
    <cfif getSmtpdMiltersId.recordCount EQ 1 AND IsNumeric(getSmtpdMiltersId.id)>
        <cfset smtpdMiltersParentId = getSmtpdMiltersId.id>
    </cfif>

    <cfset dkimEnabled = false>
    <cfset dmarcEnabled = false>
    <cfif smtpdMiltersParentId GT 0>
        <cfquery name="getDkimEnabled" datasource="hermes">
            SELECT enabled
            FROM parameters
            WHERE parameter LIKE <cfqueryparam value="inet:%:8891" cfsqltype="cf_sql_varchar">
              AND child = '1'
              AND parent = <cfqueryparam value="#smtpdMiltersParentId#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>

        <cfquery name="getDmarcEnabled" datasource="hermes">
            SELECT enabled
            FROM parameters
            WHERE parameter LIKE <cfqueryparam value="inet:%:54321" cfsqltype="cf_sql_varchar">
              AND child = '1'
              AND parent = <cfqueryparam value="#smtpdMiltersParentId#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>

        <cfset dkimEnabled = (getDkimEnabled.recordCount EQ 1 AND getDkimEnabled.enabled EQ "1")>
        <cfset dmarcEnabled = (getDmarcEnabled.recordCount EQ 1 AND getDmarcEnabled.enabled EQ "1")>
    </cfif>

    <cfset checks = []>
    <cfset arrayAppend(checks, {
        "name": "HELO/EHLO required",
        "category": "Mail security",
        "status": (getHeloRequired.recordCount EQ 1 AND getHeloRequired.enabled EQ "1")
    })>
    <cfset arrayAppend(checks, {
        "name": "Reject unauthorized destination (relay protection)",
        "category": "Relay configuration",
        "status": (getRejectUnauthDestination.recordCount EQ 1 AND getRejectUnauthDestination.enabled EQ "1")
    })>
    <cfset arrayAppend(checks, {
        "name": "SPF policy service enabled",
        "category": "Mail security",
        "status": (getSpfEnabled.recordCount EQ 1 AND getSpfEnabled.enabled EQ "1")
    })>
    <cfset arrayAppend(checks, {
        "name": "DKIM milter enabled",
        "category": "Mail security",
        "status": dkimEnabled
    })>
    <cfset arrayAppend(checks, {
        "name": "DMARC milter enabled",
        "category": "Mail security",
        "status": dmarcEnabled
    })>

    <cfset serviceDefs = [
        {"name":"postfix","label":"Postfix"},
        {"name":"amavis","label":"Amavis"},
        {"name":"clamav-daemon","label":"ClamAV"},
        {"name":"spamassassin","label":"SpamAssassin"}
    ]>
    <cfset services = []>
    <cfloop array="#serviceDefs#" index="svc">
        <cfset serviceState = "unknown">
        <cfset rawStatus = "">
        <cfset serviceOutput = "">
        <cfset serviceErrorOutput = "">
        <cftry>
            <cfexecute
                name="/usr/sbin/service"
                arguments="#svc.name# status"
                variable="serviceOutput"
                errorVariable="serviceErrorOutput"
                timeout="3" />
            <cfset rawStatus = lCase(trim(serviceOutput & " " & serviceErrorOutput))>
            <cfcatch type="any">
                <cfset rawStatus = lCase(trim(cfcatch.message & " " & cfcatch.detail))>
            </cfcatch>
        </cftry>

        <cfif rawStatus EQ "active" OR findNoCase("active (running)", rawStatus) OR findNoCase("is running", rawStatus)>
            <cfset serviceState = "running">
        <cfelseif rawStatus EQ "inactive" OR rawStatus EQ "failed" OR findNoCase("not running", rawStatus) OR findNoCase("could not be found", rawStatus) OR findNoCase("stopped", rawStatus)>
            <cfset serviceState = "stopped">
        </cfif>

        <cfset arrayAppend(services, {
            "name": svc.label,
            "service": svc.name,
            "status": serviceState
        })>
    </cfloop>

    <cfset passCount = 0>
    <cfloop array="#checks#" index="checkItem">
        <cfif checkItem.status>
            <cfset passCount = passCount + 1>
        </cfif>
    </cfloop>

    <cfset runningCount = 0>
    <cfloop array="#services#" index="serviceItem">
        <cfif serviceItem.status EQ "running">
            <cfset runningCount = runningCount + 1>
        </cfif>
    </cfloop>

    <cfset response.checks = checks>
    <cfset response.services = services>
    <cfset response.summary.checkPass = passCount>
    <cfset response.summary.checkTotal = arrayLen(checks)>
    <cfset response.summary.serviceRunning = runningCount>
    <cfset response.summary.serviceTotal = arrayLen(services)>

    <cfset responseJson = serializeJSON(response)>

    <cftry>
        <cflock scope="application" type="exclusive" timeout="5">
            <cfif NOT StructKeyExists(application, "dashboardHealthCacheByUser") OR NOT IsStruct(application.dashboardHealthCacheByUser)>
                <cfset application.dashboardHealthCacheByUser = {}>
            </cfif>
            <cfset cacheEntry = {}>
            <cfif StructKeyExists(application.dashboardHealthCacheByUser, cacheKey) AND IsStruct(application.dashboardHealthCacheByUser[cacheKey])>
                <cfset cacheEntry = duplicate(application.dashboardHealthCacheByUser[cacheKey])>
            </cfif>
            <cfset cacheEntry.generatedAt = now()>
            <cfset cacheEntry.responseJson = responseJson>
            <cfset application.dashboardHealthCacheByUser[cacheKey] = cacheEntry>
        </cflock>
        <cfcatch type="any">
            <cflog file="application" type="warning" text="Dashboard health cache write warning: #cfcatch.message# #cfcatch.detail#">
        </cfcatch>
    </cftry>

    <cfcatch type="any">
        <cflog file="application" type="error" text="Dashboard health endpoint error: #cfcatch.message# #cfcatch.detail#">
        <cfset response = {
            "success": false,
            "error": "Unable to load dashboard health status at this time."
        }>
        <cfset responseJson = serializeJSON(response)>
    </cfcatch>
</cftry>

<cfif Len(responseJson) EQ 0>
    <cfset responseJson = serializeJSON(response)>
</cfif>
<cfoutput>#responseJson#</cfoutput>
