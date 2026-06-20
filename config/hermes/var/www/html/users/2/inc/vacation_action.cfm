
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

VACATION ACTION HANDLER (user portal)
Saves the user's vacation/auto-reply settings via UPSERT and triggers
sieve script regeneration so the change takes effect immediately.

Form fields:
  enabled              - 1 or 0
  vacation_subject     - reply subject (max 255)
  vacation_body        - reply body
  start_date           - YYYY-MM-DD or empty
  end_date             - YYYY-MM-DD or empty
  reply_interval_days  - integer >= 1
--->

<cfset sieveUsername = session.email>
<cfset displayUrl = "view_vacation.cfm">

<cfparam name="form.enabled" default="0">
<cfparam name="form.vacation_subject" default="">
<cfparam name="form.vacation_body" default="">
<cfparam name="form.start_date" default="">
<cfparam name="form.end_date" default="">
<cfparam name="form.reply_interval_days" default="7">
<cfparam name="form.reply_external" default="0">
<cfparam name="form.reply_addresses" default="">
<cfparam name="form.discard_incoming" default="0">

<!--- VALIDATION --->
<cfset enabledVal = (form.enabled EQ "1") ? 1 : 0>

<cfif enabledVal EQ 1>
    <cfif trim(form.vacation_subject) EQ "">
        <cfset session.m = 11>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>
    <cfif Len(trim(form.vacation_subject)) GT 255>
        <cfset session.m = 11>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>
    <cfif trim(form.vacation_body) EQ "">
        <cfset session.m = 12>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>
</cfif>

<!--- Datetime values come from <input type="datetime-local"> as
     "yyyy-MM-ddTHH:mm". We accept that and the older "yyyy-MM-dd" form
     for backwards compat, normalize to "yyyy-mm-dd HH:nn:ss" for storage,
     and store as user-local wall clock. The generator converts to UTC
     at script-write time using the user's saved timezone. --->
<cffunction name="normalizeDateTime" returntype="string" output="false">
    <cfargument name="raw" type="string" required="true">
    <cfset var s = trim(arguments.raw)>
    <cfif s EQ "">
        <cfreturn "">
    </cfif>
    <!--- Replace "T" with space for IsDate parsing --->
    <cfset s = Replace(s, "T", " ", "all")>
    <cfif NOT IsDate(s)>
        <cfreturn "INVALID">
    </cfif>
    <cfif Len(s) EQ 10>
        <!--- Date-only - default to 00:00:00 --->
        <cfreturn DateFormat(s, "yyyy-mm-dd") & " 00:00:00">
    </cfif>
    <cfreturn DateFormat(s, "yyyy-mm-dd") & " " & TimeFormat(s, "HH:mm:ss")>
</cffunction>

<cfset startDateVal = normalizeDateTime(form.start_date)>
<cfif startDateVal EQ "INVALID">
    <cfset session.m = 13>
    <cflocation url="#displayUrl#" addtoken="no">
</cfif>

<cfset endDateVal = normalizeDateTime(form.end_date)>
<cfif endDateVal EQ "INVALID">
    <cfset session.m = 13>
    <cflocation url="#displayUrl#" addtoken="no">
</cfif>

<cfif startDateVal NEQ "" AND endDateVal NEQ "" AND DateCompare(endDateVal, startDateVal) LT 0>
    <cfset session.m = 14>
    <cflocation url="#displayUrl#" addtoken="no">
</cfif>

<cfset intervalVal = Val(form.reply_interval_days)>
<cfif intervalVal LT 1>
    <cfset intervalVal = 7>
</cfif>
<cfif intervalVal GT 365>
    <cfset intervalVal = 365>
</cfif>

<cfset externalVal = (form.reply_external EQ "1") ? 1 : 0>
<cfset discardVal  = (form.discard_incoming EQ "1") ? 1 : 0>

<!--- Validate and clean reply_addresses (comma-separated email list).
     Tom Select submits selected items as a comma-separated string. Any
     invalid entry blocks the save. Empty = no restriction. --->
<cfset cleanedAddrs = []>
<cfset addrInput = trim(form.reply_addresses)>
<cfif addrInput NEQ "">
    <cfloop list="#addrInput#" index="addr">
        <cfset addr = trim(addr)>
        <cfif addr NEQ "">
            <cfif NOT IsValid("email", addr)>
                <cfset session.m = 15>
                <cflocation url="#displayUrl#" addtoken="no">
            </cfif>
            <cfif NOT ArrayFindNoCase(cleanedAddrs, addr)>
                <cfset ArrayAppend(cleanedAddrs, LCase(addr))>
            </cfif>
        </cfif>
    </cfloop>
</cfif>
<cfset reply_addresses_clean = ArrayToList(cleanedAddrs, ",")>

<!--- UPSERT --->
<cfquery datasource="hermes">
    INSERT INTO user_vacation (username, enabled, subject, body, start_date, end_date, reply_interval_days, reply_external, reply_addresses, discard_incoming)
    VALUES (
        <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#enabledVal#" cfsqltype="cf_sql_tinyint">,
        <cfqueryparam value="#trim(form.vacation_subject)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.vacation_body#" cfsqltype="cf_sql_longvarchar">,
        <cfqueryparam value="#startDateVal#" cfsqltype="cf_sql_timestamp" null="#(startDateVal IS '')#">,
        <cfqueryparam value="#endDateVal#" cfsqltype="cf_sql_timestamp" null="#(endDateVal IS '')#">,
        <cfqueryparam value="#intervalVal#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#externalVal#" cfsqltype="cf_sql_tinyint">,
        <cfqueryparam value="#reply_addresses_clean#" cfsqltype="cf_sql_longvarchar" null="#(reply_addresses_clean IS '')#">,
        <cfqueryparam value="#discardVal#" cfsqltype="cf_sql_tinyint">
    )
    ON DUPLICATE KEY UPDATE
        enabled = <cfqueryparam value="#enabledVal#" cfsqltype="cf_sql_tinyint">,
        subject = <cfqueryparam value="#trim(form.vacation_subject)#" cfsqltype="cf_sql_varchar">,
        body = <cfqueryparam value="#form.vacation_body#" cfsqltype="cf_sql_longvarchar">,
        start_date = <cfqueryparam value="#startDateVal#" cfsqltype="cf_sql_timestamp" null="#(startDateVal IS '')#">,
        end_date = <cfqueryparam value="#endDateVal#" cfsqltype="cf_sql_timestamp" null="#(endDateVal IS '')#">,
        reply_interval_days = <cfqueryparam value="#intervalVal#" cfsqltype="cf_sql_integer">,
        reply_external = <cfqueryparam value="#externalVal#" cfsqltype="cf_sql_tinyint">,
        reply_addresses = <cfqueryparam value="#reply_addresses_clean#" cfsqltype="cf_sql_longvarchar" null="#(reply_addresses_clean IS '')#">,
        discard_incoming = <cfqueryparam value="#discardVal#" cfsqltype="cf_sql_tinyint">
</cfquery>

<!--- Regenerate the user's sieve script so the change is live immediately --->
<cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">

<cfif IsDefined("request.sieveCompileError") AND request.sieveCompileError NEQ "">
    <cfset session.compile_error = request.sieveCompileError>
    <cfset session.m = 30>
<cfelse>
    <cfset session.m = 1>
</cfif>
<cflocation url="#displayUrl#" addtoken="no">
