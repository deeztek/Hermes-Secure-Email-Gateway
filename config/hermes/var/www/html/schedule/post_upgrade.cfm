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

As of v260807 this file has two sections:

    Section 1  Idempotent repairs, run on EVERY upgrade, not guarded.
               Re-render generated config from the database so a box
               whose config drifted self-heals.
    Section 2  One-time migrations guarded by the `migrations` table,
               for work that is destructive or non-repeatable.

Anything destructive belongs in section 2 and must also be pre-seeded
as complete in hermes_install.sql, or a fresh install will eventually
run it against state it legitimately accumulated later.
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
<cfset startTickCount = getTickCount()>

<!---
Helper: hasRun(name): returns true if a migration with this name has
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
Helper: markComplete(name): records a migration as completed.
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

Section 1 below holds idempotent repairs that run every upgrade;
section 2 holds one-time migrations guarded by this table.
====================================================================
--->

<!---
====================================================================
SECTION 1: IDEMPOTENT REPAIRS (run on EVERY upgrade, not guarded)

These re-render generated config from the database, which is the
authoritative source once an install exists. They are safe to repeat
and self-heal a box whose config drifted, so they deliberately do NOT
get a migrations row.

All three fix the same class of defect found in #292: the installer
writes these files before the database exists, so it can only mirror
the seeded defaults. Where an installer bug wrote something the DB
disagreed with, the file stayed wrong until an admin happened to save
the relevant settings page. Re-rendering here closes that gap for
every existing install without requiring anyone to notice.
====================================================================
--->
<cfset repairsRun = []>
<cfset repairErrors = []>

<!--- Each repair runs in its own thread, and this is not decoration.

     Every generator these include ends its error paths with
     <cfinclude template="error.cfm"><cfabort>. cfabort is NOT catchable by
     cftry, so with a plain include a single failing generator would end the
     whole request: the remaining repairs and BOTH one-time migrations below
     would never run. Phase 5 of the orchestrator treats this hook as
     non-fatal, so the upgrade would report success while silently skipping
     most of its own repair work. That matters more now that this page is the
     mechanism by which existing installs receive fixes at all.

     cfabort inside a thread ends only that thread, so an aborting generator
     costs its own repair and nothing else. thread.ok is set as the LAST
     statement in the thread body and its absence is what detects an abort;
     that is more reliable than interpreting thread.status, which differs
     between an abort and a genuine failure.

     The join timeout is generous because generate_postfix_configuration.cfm
     shells out to docker for postconf and a postfix reload. A thread that
     overruns it is reported rather than silently dropped. --->
<cfloop array="#[
        {'name' = 'spamassassin-local-cf',  'tpl' = '../admin/2/inc/update_spamassassin_config_files.cfm'},
        {'name' = 'dovecot-conf',           'tpl' = '../admin/2/inc/generate_dovecot_configuration.cfm'},
        {'name' = 'nextcloud-trusted-hosts','tpl' = '../admin/2/inc/generate_nextcloud_configuration.cfm'},
        {'name' = 'postfix-config',         'tpl' = '../admin/2/inc/generate_postfix_configuration.cfm'}
    ]#" index="repair">

    <cfset repairThread = "repair_" & Replace(CreateUUID(), "-", "", "ALL")>
    <cfthread action="run" name="#repairThread#" tpl="#repair.tpl#">
        <cftry>
            <cfinclude template="#attributes.tpl#">
            <cfset thread.ok = true>
        <cfcatch type="any">
            <cfset thread.err = cfcatch.message>
        </cfcatch>
        </cftry>
    </cfthread>
    <cfthread action="join" name="#repairThread#" timeout="300000">

    <cfset repairOutcome = cfthread[repairThread]>
    <cfif StructKeyExists(repairOutcome, "ok")>
        <cfset arrayAppend(repairsRun, repair.name)>
    <cfelseif StructKeyExists(repairOutcome, "err")>
        <cfset arrayAppend(repairErrors, repair.name & ": " & repairOutcome.err)>
    <cfelse>
        <cfset arrayAppend(repairErrors, repair.name
            & ": aborted or timed out before completing (thread status "
            & repairOutcome.status & "). The other repairs were unaffected.")>
    </cfif>
</cfloop>

<!--- Amavis quarantine subdirectories and service data ownership. The
     installer creates these now, but every box installed before v260807
     is missing them: mail is rejected because $clean_quarantine_method
     has nowhere to write, and amavis cannot write the Bayes corpus.

     /etc/razor is in the chown for the same reason. Razor's home is written
     at scan time (it refreshes servers.*.lst and the per-server .conf files),
     and SpamAssassin runs as amavis, so a root-owned /etc/razor leaves Razor
     mute even on a box where registration landed correctly. --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter mkdir -p /mnt/data/amavis/clean /mnt/data/amavis/virus /mnt/data/amavis/spam /mnt/data/amavis/banned /mnt/data/amavis/bad_header"
        variable="quarMkdirOut" errorVariable="quarMkdirErr" timeout="120" />
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter chown -R amavis:amavis /mnt/data/amavis /opt/hermes/sa-bayes /etc/razor"
        variable="quarChownOut" errorVariable="quarChownErr" timeout="240" />
    <cfset arrayAppend(repairsRun, "amavis-quarantine-dirs-and-ownership")>
<cfcatch type="any">
    <cfset arrayAppend(repairErrors, "amavis-quarantine-dirs-and-ownership: " & cfcatch.message)>
</cfcatch>
</cftry>

<!--- Postfix hash: lookup tables. A hash: map with no compiled .db is a lookup
     ERROR, not a miss, and smtpd_sender_restrictions uses check_sender_access
     against one of them, so Postfix answers

       451 4.3.5 <sender>: Sender address rejected: Server configuration error

     to EVERY inbound message. The installer only touched empty source stubs and
     left the .db to be built "on the admin's first save through the UI", so any
     box whose admin never saved the Global Senders page has been rejecting all
     mail. The container entrypoint does not postmap either, so restarting does
     not help.

     Discovered from the LIVE config rather than hardcoded: the rendered map set
     varies by topology, relay_domains is a bare list rather than a hash: map,
     and aliases is sendmail-format so it needs postalias. Same idiom as the
     migration path, which fixed this for restores in 73d7c700.

     Empty source produces an empty .db, which matches nothing and is the
     correct default, so this is safe to repeat. --->
<cftry>
    <!--- Self-contained unique name: this page does not include
         generate_customtrans.cfm and should not gain a dependency on it. --->
    <cfset pfMapScript = "/opt/hermes/tmp/pu_" & Replace(CreateUUID(), "-", "", "ALL") & "_postfix_maps.sh">
    <cfset pfMapBody = "##!/bin/bash" & chr(10)
        & "set -u" & chr(10)
        & "maps=$(cat /etc/postfix/main.cf /etc/postfix/master.cf 2>/dev/null \" & chr(10)
        & "  | grep -oE 'hash:/etc/postfix/[a-zA-Z0-9_]+' \" & chr(10)
        & "  | sed 's##hash:/etc/postfix/####' | sort -u)" & chr(10)
        & "for m in $maps; do" & chr(10)
        & "  tool=postmap; [ ""$m"" = aliases ] && tool=postalias" & chr(10)
        & "  touch ""/etc/postfix/$m"" && /usr/sbin/$tool ""/etc/postfix/$m""" & chr(10)
        & "done" & chr(10)
        & "/usr/sbin/postfix reload" & chr(10)
        & "echo ""maps: $maps""" & chr(10)>
    <cffile action="write" file="#pfMapScript#" output="#pfMapBody#" addnewline="no">
    <cfexecute name="/usr/bin/dos2unix" arguments="#pfMapScript#" timeout="10" />
    <cfexecute name="/bin/chmod" arguments="+x #pfMapScript#" timeout="10" />
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim /bin/bash #pfMapScript#"
        variable="pfMapOut" errorVariable="pfMapErr" timeout="120" />
    <cffile action="delete" file="#pfMapScript#">
    <cfset arrayAppend(repairsRun, "postfix-lookup-table-db")>
<cfcatch type="any">
    <cfset arrayAppend(repairErrors, "postfix-lookup-table-db: " & cfcatch.message)>
</cfcatch>
</cftry>

<!---
====================================================================
SECTION 2: ONE-TIME MIGRATIONS (guarded by the migrations table)

Unlike the repairs above these are destructive or non-repeatable, so
they must run exactly once. Both are pre-seeded as complete in
hermes_install.sql, so a fresh install never runs them: a box built
after v260807 has neither the shipped Bayes corpus nor the broken
Nextcloud Mail provisioning, and re-running either would destroy
legitimate state it accumulated later.
====================================================================
--->

<!--- Clear the Bayes corpus that shipped with Hermes before v260807.
     It was trained on unrelated mail between 2020 and 2025. Because
     SpamAssassin merges all learning into one token store, anything
     trained locally since is inseparable from it, so a partial cleanup
     is not possible. Cleared once; the gateway relearns from its own
     traffic. Ownership is fixed in section 1 above, which must run
     first or sa-learn writes into a directory amavis cannot use.

     Note that phase 1 of the orchestrator has usually already removed
     the corpus files by the time this runs: v260807 untracked them, so
     `git checkout -f` deletes them from the working tree. A .gitkeep
     keeps the directories, which are bind-mount sources and must exist.
     This block is therefore belt-and-braces rather than the primary
     mechanism, and covers a box where the files survived the checkout.
     sa-learn --clear on an already-empty store is harmless. --->
<cfset blockName = "clear-seeded-bayes-corpus-v1">
<cfset arrayAppend(migrationsAttempted, blockName)>
<cfif hasRun(blockName)>
    <cfset arrayAppend(migrationsSkipped, blockName)>
<cfelse>
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u amavis hermes_mail_filter /usr/bin/sa-learn --clear"
            variable="bayesClearOut" errorVariable="bayesClearErr" timeout="240" />
        <cfset markComplete(blockName)>
        <cfset arrayAppend(migrationsApplied, blockName)>
    <cfcatch type="any">
        <cfset arrayAppend(migrationErrors, blockName & ": " & cfcatch.message)>
    </cfcatch>
    </cftry>
</cfif>

<!--- Repair mailboxes that have Nextcloud enabled but no Mail profile.
     Before v260807, enabling Nextcloud on an existing mailbox provisioned
     the LDAP group and the Nextcloud account but never the Mail profile,
     and the failure was silently discarded (#292). Affected users get a
     working /nc login with an empty Mail app.

     The credential is regenerated rather than reused: only the ARGON2ID
     hash of the system app password is stored, so the plaintext that
     Nextcloud Mail needs cannot be recovered. --->
<cfset blockName = "repair-missing-nc-mail-profiles-v1">
<cfset arrayAppend(migrationsAttempted, blockName)>
<cfif hasRun(blockName)>
    <cfset arrayAppend(migrationsSkipped, blockName)>
<cfelse>
    <cftry>
        <cfquery name="ncEnabledMailboxes" datasource="hermes">
            SELECT m.username, m.name
            FROM mailboxes m
            WHERE m.nextcloud_enabled = 1
              AND m.active = 1
            ORDER BY m.username
        </cfquery>

        <!--- Ask Nextcloud which users already have a Mail profile. The
             hermes DB user has no rights on the nextcloud schema, so this
             cannot be a join. --->
        <cfset ncRepaired = 0>
        <cfset ncSkippedExisting = 0>
        <cfset ncFailed = 0>
        <cfset ncFailures = []>
        <cfloop query="ncEnabledMailboxes">
            <cfset ncHasProfile = false>
            <cftry>
                <cfexecute name="/usr/local/bin/docker"
                    arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:export #ncEnabledMailboxes.username# --output=json"
                    variable="ncProbeOut" errorVariable="ncProbeErr" timeout="60" />
                <cfif FindNoCase("""email""", ncProbeOut)>
                    <cfset ncHasProfile = true>
                </cfif>
            <cfcatch type="any">
                <!--- Cannot determine: leave this mailbox alone rather than
                     risk replacing a working profile. --->
                <cfset ncHasProfile = true>
            </cfcatch>
            </cftry>

            <cfif ncHasProfile>
                <cfset ncSkippedExisting = ncSkippedExisting + 1>
            <cfelse>
                <!--- The Nextcloud USER must exist before a Mail account can
                     attach to it; `occ mail:account:create` otherwise reports
                     "User <x> does not exist" on STDOUT with a zero exit. A
                     mailbox switched to Nextcloud AFTER creation never had one
                     provisioned, because nextcloud_provision_user.cfm was only
                     wired into add_mailbox_action.cfm -- which is exactly the
                     population this migration targets. Provision it first,
                     mirroring the add path. The include is idempotent and skips
                     when the user already exists.

                     The password is random and deliberately not the user's own:
                     `occ user:add` creates a live DAV Basic Auth credential, so
                     reusing the login password would let clients authenticate
                     with it. OIDC takes over the account on first login. --->
                <cfset ncProvisionAction      = "create">
                <cfset ncProvisionUser        = ncEnabledMailboxes.username>
                <cfset ncProvisionDisplayName = Len(Trim(ncEnabledMailboxes.name)) ? ncEnabledMailboxes.name : ncEnabledMailboxes.username>
                <cfset ncProvisionEmail       = ncEnabledMailboxes.username>
                <cfset ncProvisionAuthType    = "local">
                <cfset ncProvisionPassword    = "">
                <cfset _ncPwAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789">
                <cfloop from="1" to="30" index="_ncPwIdx">
                    <cfset ncProvisionPassword &= Mid(_ncPwAlphabet, RandRange(1, Len(_ncPwAlphabet), "SHA1PRNG"), 1)>
                </cfloop>
                <cfset ncProvisionResult = "">
                <cfset ncProvisionError  = "">
                <cfinclude template="../admin/2/inc/nextcloud_provision_user.cfm">

                <cfif ncProvisionResult EQ "error">
                    <cfset ncFailed = ncFailed + 1>
                    <cfset arrayAppend(ncFailures, ncEnabledMailboxes.username & ": could not provision the Nextcloud user: " & ncProvisionError)>
                <cfelse>
                    <cfset mintAppPwUser = ncEnabledMailboxes.username>
                    <cfinclude template="../admin/2/inc/mint_system_app_password.cfm">
                    <cfif mintedAppPasswordPlain EQ "">
                        <cfset ncFailed = ncFailed + 1>
                        <cfset arrayAppend(ncFailures, ncEnabledMailboxes.username & ": could not mint the app password: " & mintedAppPasswordError)>
                    <cfelse>
                        <cfset ncMailAction   = "create">
                        <cfset ncMailUser     = ncEnabledMailboxes.username>
                        <cfset ncMailName     = Len(Trim(ncEnabledMailboxes.name)) ? ncEnabledMailboxes.name : ncEnabledMailboxes.username>
                        <cfset ncMailEmail    = ncEnabledMailboxes.username>
                        <cfset ncMailPassword = mintedAppPasswordPlain>
                        <cfset ncMailResult   = "">
                        <cfset ncMailError    = "">
                        <cfinclude template="../admin/2/inc/nextcloud_mail_account.cfm">

                        <!--- Count the OUTCOME, not the attempt. This previously
                             incremented unconditionally, so the summary reported
                             "repaired: 1" for a mailbox that still had no
                             account, and the real diagnostic in ncMailError was
                             discarded. The include signals failure by setting
                             ncMailResult and never throws. --->
                        <cfif ncMailResult EQ "success">
                            <cfset ncRepaired = ncRepaired + 1>
                        <cfelse>
                            <cfset ncFailed = ncFailed + 1>
                            <cfset arrayAppend(ncFailures, ncEnabledMailboxes.username & ": " & ncMailError)>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
        </cfloop>

        <!--- Only burn the one-time guard when nothing failed. Marking it
             complete regardless meant a failed repair could never be retried,
             on this box or any customer's, and the failure was invisible in the
             summary. --->
        <cfif ncFailed EQ 0>
            <cfset markComplete(blockName)>
            <cfset arrayAppend(migrationsApplied,
                blockName & " (repaired: " & ncRepaired & ", already present: " & ncSkippedExisting & ")")>
        <cfelse>
            <cfset arrayAppend(migrationErrors,
                blockName & " NOT marked complete -- repaired: " & ncRepaired
                & ", already present: " & ncSkippedExisting & ", failed: " & ncFailed
                & ". Re-runnable. Failures: " & ArrayToList(ncFailures, " | "))>
        </cfif>
    <cfcatch type="any">
        <cfset arrayAppend(migrationErrors, blockName & ": " & cfcatch.message)>
    </cfcatch>
    </cftry>
</cfif>

<!--- Build response --->
<cfset elapsedMs = getTickCount() - startTickCount>

<cfif url.format EQ "json">
    <cfset response = {
        "status" = (arrayLen(migrationErrors) GT 0 OR arrayLen(repairErrors) GT 0) ? "errors" : "ok",
        "framework_version" = "v1",
        "repairs_run" = repairsRun,
        "repair_errors" = repairErrors,
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
repairs:   #arrayLen(repairsRun)# run, #arrayLen(repairErrors)# failed
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
</cfloop></cfif><cfif arrayLen(repairsRun) GT 0>
repairs applied:
<cfloop array="#repairsRun#" index="n">  * #n#
</cfloop></cfif><cfif arrayLen(repairErrors) GT 0>
repair errors:
<cfloop array="#repairErrors#" index="n">  ! #n#
</cfloop></cfif><cfif arrayLen(migrationErrors) GT 0>
errors:
<cfloop array="#migrationErrors#" index="n">  ! #n#
</cfloop></cfif></cfoutput>
</cfif>
