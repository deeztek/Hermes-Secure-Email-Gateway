<!---
  mail_import.cfm (#356)

  Called every minute by the Ofelia job 'hermes-mail-import'. It does two short
  things and returns; the import itself runs detached inside hermes_dovecot
  (config/dovecot-2.4/scripts/mail_import_run.sh), because an import can take
  hours and no request should stay open for it.

  1. Record finished runs. The runner leaves <token>.status in the dovecot_logs
     volume. A run with no status file and no live process died, usually
     because the container restarted, and is marked failed.

  2. Start due jobs, up to maxConcurrent, so imports do not starve live mail.

  THE SOURCE PASSWORD: decrypted here into a local variable, passed to the
  runner over stdin through a mode 600 file that is deleted straight after, and
  cleared from mail_import_jobs when a job finishes. Lucee's cfexecute cannot
  write to stdin and an argument would show in the process list. It must never
  appear in an -o option. A failed job keeps it so Run Now can retry, until the
  administrator stops or deletes the job.
--->

<cfsetting requesttimeout="120">

<cfset stateDir = "/servicelogs/dovecot/mail_import">
<cfset maxConcurrent = 2>

<cftry>
  <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermesKey" charset="utf-8">
  <cfcatch>
    <cfoutput>FATAL: cannot read /opt/hermes/keys/hermes.key -- #cfcatch.message#</cfoutput>
    <cfabort>
  </cfcatch>
</cftry>

<cffunction name="miNotify" returntype="void" output="false">
  <cfargument name="target" type="string" required="true">
  <cfargument name="sourceHost" type="string" required="true">
  <cfargument name="message" type="string" required="true">
  <cftry>
    <cfquery name="local.getpostmaster" datasource="hermes">
      SELECT value FROM system_settings WHERE parameter='postmaster'
    </cfquery>
    <cfquery name="local.getadmin" datasource="hermes">
      SELECT value FROM system_settings WHERE parameter='admin_email'
    </cfquery>
    <cfmail from="#local.getpostmaster.value#" to="#local.getadmin.value#" server="hermes_postfix_dkim" subject="[Hermes SEG] Mail Import Failed: #arguments.target#" port="10026" type="html">
      <div align="center">
        <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
        <h2>Hermes SEG Mail Import Failed</h2>
        The import from #HTMLEditFormat(arguments.sourceHost)# into #HTMLEditFormat(arguments.target)# failed.<br><br>
        #HTMLEditFormat(arguments.message)#<br><br>
        See Email Server &gt; Mail Import in the console.
      </div>
    </cfmail>
    <cfcatch></cfcatch>
  </cftry>
</cffunction>

<cffunction name="miErrorText" returntype="string" output="false">
  <cfargument name="logPath" type="string" required="true">
  <cfset var raw = "">
  <cfset var kept = []>
  <cfset var line = "">
  <cfif NOT FileExists(arguments.logPath)>
    <cfreturn "">
  </cfif>
  <cffile action="read" file="#arguments.logPath#" variable="raw" charset="utf-8">
  <cfloop list="#raw#" delimiters="#Chr(10)#" index="line">
    <cfif FindNoCase("error", line) OR FindNoCase("fatal", line)>
      <cfset ArrayAppend(kept, Trim(line))>
    </cfif>
  </cfloop>
  <cfif ArrayLen(kept) GT 10>
    <cfset kept = ArraySlice(kept, ArrayLen(kept) - 9, 10)>
  </cfif>
  <cfreturn Left(ArrayToList(kept, Chr(10)), 2000)>
</cffunction>

<!--- ================================================================
     1. RECORD FINISHED RUNS
     ================================================================ --->
<cfquery name="openRuns" datasource="hermes">
  SELECT r.id AS run_id, r.job_id, r.token, j.mode, j.interval_minutes, j.source_host, m.username
  FROM mail_import_runs r
  INNER JOIN mail_import_jobs j ON j.id = r.job_id
  LEFT JOIN mailboxes m ON m.id = j.mailbox_id
  WHERE r.ended_at IS NULL
</cfquery>

<cfloop query="openRuns">
  <cfset statusPath = stateDir & "/" & openRuns.token & ".status">
  <cfset logPath = stateDir & "/" & openRuns.token & ".log">
  <cfset result = {"exit" = -1, "before" = "", "after" = "", "reason" = ""}>
  <cfset haveResult = false>

  <cfif NOT FileExists(statusPath)>
    <cfset aliveOut = "">
    <cftry>
      <cfexecute name="/usr/local/bin/docker"
          arguments="exec hermes_dovecot /bin/bash /scripts/mail_import_run.sh alive #openRuns.token#"
          variable="aliveOut" timeout="30"></cfexecute>
      <cfcatch><cfset aliveOut = "alive"></cfcatch>
    </cftry>
    <cfif Find("alive", aliveOut)>
      <cfcontinue>
    </cfif>
  </cfif>

  <!--- Read again: the run may have finished between the two checks. --->
  <cfif FileExists(statusPath)>
    <cffile action="read" file="#statusPath#" variable="statusRaw" charset="utf-8">
    <cfloop list="#statusRaw#" delimiters="#Chr(10)#" index="statusLine">
      <cfset statusKey = ListFirst(statusLine, "=")>
      <cfif StructKeyExists(result, statusKey)>
        <cfset result[statusKey] = ListLen(statusLine, "=") GT 1 ? ListRest(statusLine, "=") : "">
      </cfif>
    </cfloop>
    <cfset haveResult = true>
  </cfif>

  <cfset runError = "">
  <cfif NOT haveResult>
    <cfset runError = "The import stopped unexpectedly, usually because hermes_dovecot restarted. Mail copied so far is kept. Use Run Now to continue.">
  <cfelseif Val(result.exit) EQ 70 AND Left(result.reason, 17) EQ "source_too_large:">
    <cfset runError = "The source account is about " & NumberFormat(Val(ListLast(result.reason, ":")) / 1048576, "9") & " MB, which is more than the mailbox quota. Nothing was copied. Raise the quota, then use Run Now.">
  <cfelseif Val(result.exit) NEQ 0>
    <cfset runError = miErrorText(logPath)>
    <cfif NOT Len(runError)>
      <cfset runError = "doveadm exited with code " & Val(result.exit) & ".">
    </cfif>
  </cfif>

  <cfquery datasource="hermes">
    UPDATE mail_import_runs
       SET ended_at = NOW(),
           exit_code = <cfqueryparam value="#Val(result.exit)#" cfsqltype="cf_sql_integer">,
           messages_before = <cfqueryparam value="#result.before#" cfsqltype="cf_sql_bigint" null="#NOT IsNumeric(result.before)#">,
           messages_after = <cfqueryparam value="#result.after#" cfsqltype="cf_sql_bigint" null="#NOT IsNumeric(result.after)#">,
           error_text = <cfqueryparam value="#runError#" cfsqltype="cf_sql_longvarchar" null="#NOT Len(runError)#">
     WHERE id = <cfqueryparam value="#openRuns.run_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif Len(runError)>
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs
         SET status = 'failed', next_run_at = NULL,
             last_error = <cfqueryparam value="#runError#" cfsqltype="cf_sql_longvarchar">
       WHERE id = <cfqueryparam value="#openRuns.job_id#" cfsqltype="cf_sql_integer">
         AND status = 'running'
    </cfquery>
    <cfset miNotify(openRuns.username, openRuns.source_host, runError)>
  <cfelseif openRuns.mode EQ "repeat">
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs
         SET status = 'queued', last_error = NULL,
             next_run_at = DATE_ADD(NOW(), INTERVAL <cfqueryparam value="#openRuns.interval_minutes#" cfsqltype="cf_sql_integer"> MINUTE)
       WHERE id = <cfqueryparam value="#openRuns.job_id#" cfsqltype="cf_sql_integer">
         AND status = 'running'
    </cfquery>
  <cfelse>
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs
         SET status = 'finished', next_run_at = NULL, last_error = NULL, source_password = NULL
       WHERE id = <cfqueryparam value="#openRuns.job_id#" cfsqltype="cf_sql_integer">
         AND status = 'running'
    </cfquery>
  </cfif>

  <cftry><cfif FileExists(statusPath)><cffile action="delete" file="#statusPath#"></cfif><cfcatch></cfcatch></cftry>
  <cftry><cfif FileExists(logPath)><cffile action="delete" file="#logPath#"></cfif><cfcatch></cfcatch></cftry>
</cfloop>

<!--- ================================================================
     2. START DUE JOBS
     ================================================================ --->
<cfquery name="runningNow" datasource="hermes">
  SELECT COUNT(*) AS total FROM mail_import_jobs WHERE status = 'running'
</cfquery>

<cfset slots = maxConcurrent - Val(runningNow.total)>
<cfif slots LTE 0>
  <cfoutput>Mail import: #runningNow.total# running, no free slots.</cfoutput>
  <cfabort>
</cfif>

<cfquery name="dueJobs" datasource="hermes">
  SELECT j.*, m.username, m.quota
  FROM mail_import_jobs j
  LEFT JOIN mailboxes m ON m.id = j.mailbox_id
  WHERE j.status = 'queued'
    AND j.next_run_at <= NOW()
  ORDER BY j.next_run_at, j.id
  LIMIT <cfqueryparam value="#slots#" cfsqltype="cf_sql_integer">
</cfquery>

<cfloop query="dueJobs">
  <cfset startError = "">
  <cfset token = LCase(Replace(CreateUUID(), "-", "", "all"))>
  <cfset inPath = "/opt/hermes/tmp/" & token & "_mi.in">
  <cfset shPath = "/opt/hermes/tmp/" & token & "_mi.sh">
  <cfset startOut = "">

  <cftry>
    <cfif NOT Len(dueJobs.username)>
      <cfthrow message="The target mailbox no longer exists.">
    </cfif>
    <cfif NOT Len(dueJobs.source_password)>
      <cfthrow message="The source password is no longer stored. Delete this job and add it again.">
    </cfif>

    <cfset sourcePass = decrypt(Trim(dueJobs.source_password), hermesKey, "AES", "Base64")>

    <cfset lines = []>
    <cfset ArrayAppend(lines, "HOST=" & dueJobs.source_host)>
    <cfset ArrayAppend(lines, "PORT=" & dueJobs.source_port)>
    <cfset ArrayAppend(lines, "SSL=" & dueJobs.source_ssl)>
    <cfset ArrayAppend(lines, "VERIFY=" & (Val(dueJobs.verify_cert) EQ 1 ? "yes" : "no"))>
    <cfset ArrayAppend(lines, "TARGET=" & dueJobs.username)>
    <cfset ArrayAppend(lines, "QUOTA=" & (REFind("^[0-9]+$", dueJobs.quota) ? dueJobs.quota : 0))>
    <cfset ArrayAppend(lines, "FEATURES=" & dueJobs.imapc_features)>
    <cfset ArrayAppend(lines, "PREFIX=" & dueJobs.folder_prefix)>
    <cfset ArrayAppend(lines, "SINCE_DAYS=" & Val(dueJobs.since_days))>
    <cfset ArrayAppend(lines, "MAX_MB=" & Val(dueJobs.max_message_mb))>
    <cfset ArrayAppend(lines, "TIMEOUT=" & Val(dueJobs.io_timeout))>
    <!--- Dovecot expands %{...} in these two values, so a literal % is doubled. --->
    <cfset ArrayAppend(lines, "USER=" & Replace(dueJobs.source_username, "%", "%%", "all"))>
    <cfset ArrayAppend(lines, "PASS=" & Replace(sourcePass, "%", "%%", "all"))>
    <cfloop list="#dueJobs.exclude_folders#" delimiters="#Chr(10)##Chr(13)#" index="excludeFolder">
      <cfif Len(Trim(excludeFolder))>
        <cfset ArrayAppend(lines, "EXCLUDE=" & Trim(excludeFolder))>
      </cfif>
    </cfloop>

    <cfquery datasource="hermes">
      INSERT INTO mail_import_runs (job_id, token, started_at)
      VALUES (
        <cfqueryparam value="#dueJobs.id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#token#" cfsqltype="cf_sql_char">,
        NOW()
      )
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs SET status = 'running', last_error = NULL
       WHERE id = <cfqueryparam value="#dueJobs.id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cffile action="write" file="#inPath#" output="#ArrayToList(lines, Chr(10))#" charset="utf-8" mode="600" addNewLine="yes">
    <cffile action="write" file="#shPath#" output="/usr/local/bin/docker exec -i hermes_dovecot /bin/bash /scripts/mail_import_run.sh start #token# < #inPath#" charset="utf-8" mode="700">
    <cfexecute name="/bin/bash" arguments="#shPath#" variable="startOut" timeout="60"></cfexecute>

    <cfif NOT Find("started", startOut)>
      <cfthrow message="The import runner did not start: #Left(startOut, 500)#">
    </cfif>

    <cfcatch>
      <cfset startError = cfcatch.message>
    </cfcatch>
  </cftry>

  <!--- The file holding the password goes first and unconditionally. --->
  <cftry><cfif FileExists(inPath)><cffile action="delete" file="#inPath#"></cfif><cfcatch></cfcatch></cftry>
  <cftry><cfif FileExists(shPath)><cffile action="delete" file="#shPath#"></cfif><cfcatch></cfcatch></cftry>
  <cfset sourcePass = "">

  <cfif Len(startError)>
    <cfquery datasource="hermes">
      UPDATE mail_import_runs
         SET ended_at = NOW(), exit_code = -1,
             error_text = <cfqueryparam value="#startError#" cfsqltype="cf_sql_longvarchar">
       WHERE token = <cfqueryparam value="#token#" cfsqltype="cf_sql_char">
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs
         SET status = 'failed', next_run_at = NULL,
             last_error = <cfqueryparam value="#startError#" cfsqltype="cf_sql_longvarchar">
       WHERE id = <cfqueryparam value="#dueJobs.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset miNotify(dueJobs.username, dueJobs.source_host, startError)>
  </cfif>
</cfloop>

<cfoutput>Mail import: #dueJobs.recordcount# job(s) considered.</cfoutput>
