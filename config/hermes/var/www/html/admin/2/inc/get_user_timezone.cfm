
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET USER TIMEZONE HELPER
Returns the IANA timezone name for a given user (e.g. "America/New_York").
Falls back to the server's system timezone if the user has no value set.

Used by:
  - vacation auto-reply (datetime conversion for currentdate sieve blocks)
  - dashboard timestamp display
  - notification scheduling
  - anywhere a user-facing timestamp needs to be rendered

Usage:
  <cfinclude template="get_user_timezone.cfm">
  <cfset userTz = getUserTimezone("user@example.com")>
--->

<cffunction name="getSystemTimezone" returntype="string" output="false">
    <cfset var sysTz = "">
    <cfset var dbTz = "">

    <!--- Primary source: System Settings page (system_settings.parameter='timezone').
         This is the canonical configured timezone for the deployment. --->
    <cfquery name="local.sysTz" datasource="hermes">
        SELECT value FROM system_settings WHERE parameter = 'timezone'
    </cfquery>
    <cfif local.sysTz.recordcount GTE 1 AND Len(trim(local.sysTz.value)) GT 0>
        <cfreturn trim(local.sysTz.value)>
    </cfif>

    <!--- Fallback: MariaDB session timezone (from $TIMEZONE in .env) --->
    <cfquery name="local.dbTz" datasource="hermes">
        SELECT @@session.time_zone AS tz
    </cfquery>
    <cfset dbTz = local.dbTz.tz>
    <cfif dbTz EQ "SYSTEM" OR REFind("^[+-][0-9]{2}:[0-9]{2}$", dbTz)>
        <cfreturn "UTC">
    </cfif>
    <cfreturn dbTz>
</cffunction>

<cffunction name="getUserTimezone" returntype="string" output="false">
    <cfargument name="email" type="string" required="true">

    <cfquery name="local.tz" datasource="hermes">
        SELECT timezone FROM user_settings
        WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif local.tz.recordcount GTE 1 AND Len(trim(local.tz.timezone)) GT 0>
        <cfreturn trim(local.tz.timezone)>
    </cfif>

    <!--- No per-user value: fall back to system-wide default --->
    <cfreturn getSystemTimezone()>
</cffunction>

<!--- Convert a local datetime in a given IANA timezone to UTC.
     Lucee's parseDateTime() returns a date in the JVM's default timezone,
     so we use Java directly to parse as the user's TZ then convert. --->
<cffunction name="convertToUTC" returntype="string" output="false">
    <cfargument name="localDateTime" type="string" required="true">
    <cfargument name="userTz" type="string" required="true">

    <cfset var zoneId = createObject("java", "java.time.ZoneId")>
    <cfset var localDT = createObject("java", "java.time.LocalDateTime")>
    <cfset var dtFormatter = createObject("java", "java.time.format.DateTimeFormatter")>
    <cfset var pattern = "">
    <cfset var parsed = "">
    <cfset var zoned = "">
    <cfset var utc = "">

    <!--- Accept either "yyyy-MM-dd'T'HH:mm" (browser datetime-local) or
         "yyyy-MM-dd HH:mm:ss" (DB DATETIME format) --->
    <cfif Find("T", arguments.localDateTime)>
        <cfset pattern = "yyyy-MM-dd'T'HH:mm">
        <cfif Len(arguments.localDateTime) GT 16>
            <cfset pattern = "yyyy-MM-dd'T'HH:mm:ss">
        </cfif>
    <cfelse>
        <cfset pattern = "yyyy-MM-dd HH:mm:ss">
        <cfif Len(arguments.localDateTime) EQ 16>
            <cfset pattern = "yyyy-MM-dd HH:mm">
        </cfif>
    </cfif>

    <cfset parsed = localDT.parse(arguments.localDateTime, dtFormatter.ofPattern(pattern))>
    <cfset zoned = parsed.atZone(zoneId.of(arguments.userTz))>
    <cfset utc = zoned.withZoneSameInstant(zoneId.of("UTC"))>

    <!--- Return as RFC 5260 "iso8601" extended format with Z suffix:
         2026-04-15T21:00:00Z. Pigeonhole's currentdate test only accepts
         the extended format (with hyphens, colons, T separator) - basic
         format like 20260415T210000Z silently fails to match. --->
    <cfreturn utc.format(dtFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'"))>
</cffunction>

<!--- Convert a UTC datetime (from DB) to a local datetime string in the
     user's timezone, formatted for display or for an HTML datetime-local input. --->
<cffunction name="convertFromUTC" returntype="string" output="false">
    <cfargument name="utcDateTime" type="any" required="true">
    <cfargument name="userTz" type="string" required="true">
    <cfargument name="format" type="string" required="false" default="yyyy-MM-dd'T'HH:mm">

    <cfset var zoneId = createObject("java", "java.time.ZoneId")>
    <cfset var dtFormatter = createObject("java", "java.time.format.DateTimeFormatter")>
    <cfset var instant = "">
    <cfset var zoned = "">
    <cfset var dtString = "">

    <!--- The DB returns a Lucee date object. Format it as ISO so Java can parse. --->
    <cfif IsDate(arguments.utcDateTime)>
        <cfset dtString = DateFormat(arguments.utcDateTime, "yyyy-mm-dd") & "T" & TimeFormat(arguments.utcDateTime, "HH:mm:ss")>
    <cfelse>
        <cfset dtString = arguments.utcDateTime>
    </cfif>

    <cfset var localDT = createObject("java", "java.time.LocalDateTime")>
    <cfset var parsed = localDT.parse(dtString)>
    <cfset zoned = parsed.atZone(zoneId.of("UTC"))>
    <cfset var inUserTz = zoned.withZoneSameInstant(zoneId.of(arguments.userTz))>

    <cfreturn inUserTz.format(dtFormatter.ofPattern(arguments.format))>
</cffunction>
