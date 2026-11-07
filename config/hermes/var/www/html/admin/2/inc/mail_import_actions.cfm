<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

MAIL IMPORT ACTION HANDLERS (#356)

add_import, edit_import, run_import, stop_import, delete_import. Every branch ends in
cflocation. Nothing here talks to the source server: schedule/mail_import.cfm
starts queued jobs within a minute.

The switches are a fixed allowlist rather than free text, because they end up
in a config file used by a root doveadm command.
--->

<cfset miPage = "view_mail_import.cfm">
<cfset miFeatureAllowlist = "no-examine,no-qresync,no-modseq,zimbra-workarounds,fetch-msn-workarounds">

<cfif ListFind("add_import,edit_import", action)>

  <cfset isEdit = (action is "edit_import")>

  <cfif NOT StructKeyExists(form, "source_host")
        OR NOT StructKeyExists(form, "source_username") OR NOT StructKeyExists(form, "source_password")
        OR (isEdit AND (NOT StructKeyExists(form, "job_id") OR NOT IsNumeric(form.job_id)))
        OR (NOT isEdit AND NOT StructKeyExists(form, "mailbox_id"))>
    <cfset session.m = 20>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <!--- An edit keeps its mailbox. Changing a running job would leave the worker
       on the old settings. --->
  <cfif isEdit>
    <cfquery name="editJob" datasource="hermes">
      SELECT id, mailbox_id, status, source_password
      FROM mail_import_jobs
      WHERE id = <cfqueryparam value="#form.job_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif editJob.recordcount LT 1>
      <cfset session.m = 21>
      <cflocation url="#miPage#" addtoken="no">
    </cfif>
    <cfif editJob.status EQ "running">
      <cfset session.m = 24>
      <cflocation url="#miPage#" addtoken="no">
    </cfif>
    <cfset theMailboxId = Val(editJob.mailbox_id)>
  <cfelse>
    <cfset theMailboxId = Val(form.mailbox_id)>
  </cfif>

  <cfset theHost = Trim(form.source_host)>
  <cfset thePort = StructKeyExists(form, "source_port") ? Trim(form.source_port) : "">
  <cfset theSsl = StructKeyExists(form, "source_ssl") ? Trim(form.source_ssl) : "">
  <cfset theUser = Trim(form.source_username)>
  <cfset thePass = form.source_password>
  <cfset thePrefix = StructKeyExists(form, "folder_prefix") ? Trim(form.folder_prefix) : "">
  <cfset theExcludes = StructKeyExists(form, "exclude_folders") ? Trim(form.exclude_folders) : "">
  <cfset theFeatures = StructKeyExists(form, "imapc_features") ? form.imapc_features : "">
  <cfset theSince = StructKeyExists(form, "since_days") ? Trim(form.since_days) : "0">
  <cfset theMaxMb = StructKeyExists(form, "max_message_mb") ? Trim(form.max_message_mb) : "0">
  <cfset theTimeout = StructKeyExists(form, "io_timeout") ? Trim(form.io_timeout) : "600">
  <cfset theMode = StructKeyExists(form, "mode") ? Trim(form.mode) : "once">
  <cfset theInterval = StructKeyExists(form, "interval_minutes") ? Trim(form.interval_minutes) : "60">
  <cfset theVerify = StructKeyExists(form, "verify_cert") ? 1 : 0>

  <cfif NOT REFind("^[A-Za-z0-9._-]{1,255}$", theHost)
        OR NOT REFind("^[0-9]{1,5}$", thePort) OR Val(thePort) LT 1 OR Val(thePort) GT 65535
        OR NOT ListFind("imaps,starttls,no", theSsl)>
    <cfset session.m = 10>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <!--- A blank password on an edit keeps the stored one, if there still is one. --->
  <cfset keepPass = isEdit AND NOT Len(thePass) AND Len(editJob.source_password) GT 0>

  <cfif NOT Len(theUser) OR Len(theUser) GT 255 OR (NOT Len(thePass) AND NOT keepPass)
        OR REFind("[\r\n]", theUser) OR REFind("[\r\n]", thePass)>
    <cfset session.m = 11>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <!--- REFind returns 0 on an empty string whatever the pattern, so a blank
       prefix has to be let through before the check. --->
  <cfif (Len(thePrefix) AND NOT REFind("^[A-Za-z0-9._/-]{1,100}$", thePrefix))
        OR NOT REFind("^[0-9]{1,5}$", theSince)
        OR NOT REFind("^[0-9]{1,6}$", theMaxMb)
        OR NOT REFind("^[0-9]{2,5}$", theTimeout) OR Val(theTimeout) LT 30
        OR NOT ListFind("once,repeat", theMode)
        OR (theMode EQ "repeat" AND (NOT REFind("^[0-9]{2,5}$", theInterval) OR Val(theInterval) LT 15))>
    <cfset session.m = 12>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cfif theMode EQ "once">
    <cfset theInterval = 60>
  </cfif>

  <cfset cleanFeatures = "">
  <cfloop list="#theFeatures#" index="oneFeature">
    <cfif ListFind(miFeatureAllowlist, Trim(oneFeature))>
      <cfset cleanFeatures = ListAppend(cleanFeatures, Trim(oneFeature), " ")>
    </cfif>
  </cfloop>

  <cfquery name="checkMailbox" datasource="hermes">
    SELECT id FROM mailboxes
    WHERE id = <cfqueryparam value="#theMailboxId#" cfsqltype="cf_sql_integer">
      AND active = 1
      AND mailbox_type = 'user'
  </cfquery>
  <cfif checkMailbox.recordcount LT 1>
    <cfset session.m = 13>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <!--- Two syncs into one mailbox at once would fight over its lock. --->
  <cfquery name="checkOpenJob" datasource="hermes">
    SELECT id FROM mail_import_jobs
    WHERE mailbox_id = <cfqueryparam value="#theMailboxId#" cfsqltype="cf_sql_integer">
      AND status IN ('queued','running','failed')
      <cfif isEdit>AND id <> <cfqueryparam value="#editJob.id#" cfsqltype="cf_sql_integer"></cfif>
  </cfquery>
  <cfif checkOpenJob.recordcount GT 0>
    <cfset session.m = 14>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermesKey" charset="utf-8">
  <cfset encryptedPass = Len(thePass) ? encrypt(thePass, hermesKey, "AES", "Base64") : "">

  <cfif isEdit>
    <!--- Saving queues the job, so an edit also re-runs a finished one. --->
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs SET
        source_host = <cfqueryparam value="#theHost#" cfsqltype="cf_sql_varchar">,
        source_port = <cfqueryparam value="#Val(thePort)#" cfsqltype="cf_sql_integer">,
        source_ssl = <cfqueryparam value="#theSsl#" cfsqltype="cf_sql_varchar">,
        verify_cert = <cfqueryparam value="#theVerify#" cfsqltype="cf_sql_tinyint">,
        source_username = <cfqueryparam value="#theUser#" cfsqltype="cf_sql_varchar">,
        <cfif Len(encryptedPass)>source_password = <cfqueryparam value="#encryptedPass#" cfsqltype="cf_sql_longvarchar">,</cfif>
        exclude_folders = <cfqueryparam value="#theExcludes#" cfsqltype="cf_sql_longvarchar" null="#NOT Len(theExcludes)#">,
        folder_prefix = <cfqueryparam value="#thePrefix#" cfsqltype="cf_sql_varchar" null="#NOT Len(thePrefix)#">,
        imapc_features = <cfqueryparam value="#cleanFeatures#" cfsqltype="cf_sql_varchar" null="#NOT Len(cleanFeatures)#">,
        since_days = <cfqueryparam value="#Val(theSince)#" cfsqltype="cf_sql_integer">,
        max_message_mb = <cfqueryparam value="#Val(theMaxMb)#" cfsqltype="cf_sql_integer">,
        io_timeout = <cfqueryparam value="#Val(theTimeout)#" cfsqltype="cf_sql_integer">,
        mode = <cfqueryparam value="#theMode#" cfsqltype="cf_sql_varchar">,
        interval_minutes = <cfqueryparam value="#Val(theInterval)#" cfsqltype="cf_sql_integer">,
        status = 'queued',
        next_run_at = NOW(),
        last_error = NULL
      WHERE id = <cfqueryparam value="#editJob.id#" cfsqltype="cf_sql_integer">
        AND status <> 'running'
    </cfquery>
    <cfset session.m = 5>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO mail_import_jobs
      (mailbox_id, source_host, source_port, source_ssl, verify_cert, source_username, source_password,
       exclude_folders, folder_prefix, imapc_features, since_days, max_message_mb, io_timeout,
       mode, interval_minutes, status, next_run_at)
    VALUES (
      <cfqueryparam value="#theMailboxId#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#theHost#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#Val(thePort)#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#theSsl#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#theVerify#" cfsqltype="cf_sql_tinyint">,
      <cfqueryparam value="#theUser#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#encryptedPass#" cfsqltype="cf_sql_longvarchar">,
      <cfqueryparam value="#theExcludes#" cfsqltype="cf_sql_longvarchar" null="#NOT Len(theExcludes)#">,
      <cfqueryparam value="#thePrefix#" cfsqltype="cf_sql_varchar" null="#NOT Len(thePrefix)#">,
      <cfqueryparam value="#cleanFeatures#" cfsqltype="cf_sql_varchar" null="#NOT Len(cleanFeatures)#">,
      <cfqueryparam value="#Val(theSince)#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#Val(theMaxMb)#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#Val(theTimeout)#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#theMode#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#Val(theInterval)#" cfsqltype="cf_sql_integer">,
      'queued',
      NOW()
    )
  </cfquery>

  <cfset session.m = 1>
  <cflocation url="#miPage#" addtoken="no">

</cfif>

<!--- The other three act on an existing job. --->
<cfif ListFind("run_import,stop_import,delete_import", action)>

  <cfif NOT StructKeyExists(form, "job_id") OR NOT IsNumeric(form.job_id)>
    <cfset session.m = 20>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cfquery name="getJob" datasource="hermes">
    SELECT id, status, source_password
    FROM mail_import_jobs
    WHERE id = <cfqueryparam value="#form.job_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif getJob.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cfif action is "run_import">
    <cfif NOT ListFind("queued,failed", getJob.status) OR NOT Len(getJob.source_password)>
      <cfset session.m = 22>
      <cflocation url="#miPage#" addtoken="no">
    </cfif>
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs SET status = 'queued', next_run_at = NOW()
       WHERE id = <cfqueryparam value="#getJob.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 2>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cfif action is "stop_import">
    <cfif getJob.status EQ "running">
      <cfquery name="getOpenRun" datasource="hermes">
        SELECT id, token FROM mail_import_runs
        WHERE job_id = <cfqueryparam value="#getJob.id#" cfsqltype="cf_sql_integer">
          AND ended_at IS NULL
      </cfquery>
      <cfloop query="getOpenRun">
        <cftry>
          <cfexecute name="/usr/local/bin/docker"
              arguments="exec hermes_dovecot /bin/bash /scripts/mail_import_run.sh stop #getOpenRun.token#"
              variable="stopOut" timeout="30"></cfexecute>
          <cfcatch></cfcatch>
        </cftry>
        <cfquery datasource="hermes">
          UPDATE mail_import_runs
             SET ended_at = NOW(), error_text = 'Stopped by the administrator.'
           WHERE id = <cfqueryparam value="#getOpenRun.id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfloop list="status,log" index="stateExt">
          <cfset statePath = "/servicelogs/dovecot/mail_import/" & getOpenRun.token & "." & stateExt>
          <cftry><cfif FileExists(statePath)><cffile action="delete" file="#statePath#"></cfif><cfcatch></cfcatch></cftry>
        </cfloop>
      </cfloop>
    </cfif>
    <cfquery datasource="hermes">
      UPDATE mail_import_jobs
         SET status = 'stopped', next_run_at = NULL, source_password = NULL
       WHERE id = <cfqueryparam value="#getJob.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 3>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

  <cfif action is "delete_import">
    <cfif getJob.status EQ "running">
      <cfset session.m = 23>
      <cflocation url="#miPage#" addtoken="no">
    </cfif>
    <cfquery datasource="hermes">
      DELETE FROM mail_import_runs WHERE job_id = <cfqueryparam value="#getJob.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfquery datasource="hermes">
      DELETE FROM mail_import_jobs WHERE id = <cfqueryparam value="#getJob.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 4>
    <cflocation url="#miPage#" addtoken="no">
  </cfif>

</cfif>
