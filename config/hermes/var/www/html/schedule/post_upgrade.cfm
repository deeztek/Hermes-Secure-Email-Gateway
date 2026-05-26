<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
Phase 5 of the update orchestrator (scripts/system_update_docker.sh, #221).

Called at the end of every upgrade with:
    docker exec hermes_commandbox curl --silent http://localhost:8888/schedule/post_upgrade.cfm

Houses cross-release CFML migrations gated by the `migrations` table.
Each named block:
    1. Checks `migrations` for its name; if present, skip with log.
    2. Otherwise, do the work.
    3. INSERT a row into `migrations` on completion.

This is for migrations that:
    - Don't bind cleanly to a single release boundary
    - Need to be retroactive across all existing installs regardless
      of which release they were on when the migration was added
    - Replace existing inline-in-CFML migrations (lazy backfills
      currently scattered across page handlers)

For per-release one-shots that ARE bound to a specific release, put
the .cfm under updates/v<DATE>/cfml/ instead. See
docs/install/release-and-update-methodology.md for the full taxonomy.

State of this file as of v260119: framework only, no migration blocks
yet registered. First real block lands when the first cross-release
CFML migration is needed.
--->

<cfsetting requesttimeout="600">
<cfsetting showdebugoutput="false">

<cfparam name="url.format" default="text">

<!--- Track results for the response --->
<cfset migrationsAttempted = []>
<cfset migrationsApplied = []>
<cfset migrationsSkipped = []>
<cfset migrationErrors = []>
<cfset startTime = now()>

<!---
Helper: hasRun(name) — returns true if a migration with this name has
already been recorded as completed.
--->
<cffunction name="hasRun" returntype="boolean">
    <cfargument name="migrationName" type="string" required="true">
    <cfset var q = "">
    <cfquery name="q" datasource="hermes">
        SELECT id FROM migrations
        WHERE name = <cfqueryparam value="#arguments.migrationName#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfreturn q.recordCount GT 0>
</cffunction>

<!---
Helper: markComplete(name) — records a migration as completed.
INSERT IGNORE so a concurrent run can't fail on the UNIQUE key.
--->
<cffunction name="markComplete" returntype="void">
    <cfargument name="migrationName" type="string" required="true">
    <cfquery datasource="hermes">
        INSERT IGNORE INTO migrations (name)
        VALUES (<cfqueryparam value="#arguments.migrationName#" cfsqltype="cf_sql_varchar">)
    </cfquery>
</cffunction>

<!---
====================================================================
Migration blocks register below. Pattern for each block:

    <cfset blockName = "descriptive-kebab-name-vN">
    <cfset arrayAppend(migrationsAttempted, blockName)>
    <cfif hasRun(blockName)>
        <cfset arrayAppend(migrationsSkipped, blockName)>
    <cfelse>
        <cftry>
            <!--- do the work --->
            <cfset markComplete(blockName)>
            <cfset arrayAppend(migrationsApplied, blockName)>
            <cfcatch>
                <cfset arrayAppend(migrationErrors,
                    blockName & ": " & cfcatch.message)>
            </cfcatch>
        </cftry>
    </cfif>

Naming convention:
    - Lowercase kebab-case
    - Include a version suffix (-v1, -v2) so a future re-rework can
      ship as a new block name without colliding with the original

No blocks registered yet — framework only.
====================================================================
--->

<!--- (intentionally empty — first real block lands when first migration needed) --->

<!--- Build response --->
<cfset elapsedMs = getTickCount() - getTickCount(startTime)>
<cfset elapsedMs = dateDiff("s", startTime, now()) * 1000>

<cfif url.format EQ "json">
    <cfset response = {
        "status" = arrayLen(migrationErrors) GT 0 ? "errors" : "ok",
        "framework_version" = "v1",
        "attempted" = migrationsAttempted,
        "applied" = migrationsApplied,
        "skipped" = migrationsSkipped,
        "errors" = migrationErrors,
        "elapsed_ms" = elapsedMs,
        "completed_at" = dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "HH:mm:ss")
    }>
    <cfcontent type="application/json" reset="true">
    <cfoutput>#serializeJSON(response)#</cfoutput>
<cfelse>
    <cfcontent type="text/plain" reset="true">
    <cfoutput>post_upgrade framework v1
attempted: #arrayLen(migrationsAttempted)#
applied:   #arrayLen(migrationsApplied)#
skipped:   #arrayLen(migrationsSkipped)#
errors:    #arrayLen(migrationErrors)#
elapsed:   #elapsedMs#ms
<cfif arrayLen(migrationsApplied) GT 0>
applied blocks:
<cfloop array="#migrationsApplied#" index="n">  + #n#
</cfloop></cfif><cfif arrayLen(migrationsSkipped) GT 0>
skipped blocks (already applied):
<cfloop array="#migrationsSkipped#" index="n">  = #n#
</cfloop></cfif><cfif arrayLen(migrationErrors) GT 0>
errors:
<cfloop array="#migrationErrors#" index="n">  ! #n#
</cfloop></cfif></cfoutput>
</cfif>
