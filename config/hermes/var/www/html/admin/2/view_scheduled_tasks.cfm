<!DOCTYPE html>

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

<!---
SCHEDULED TASKS ADMIN PAGE

Reads the pre-existing ofelia_jobs table (source of truth for every
Ofelia job) and lets admins trigger one-off "Run Now" runs.

Important schema conventions this page respects:
  - job_name : stores the full "[job-exec \"name\"]" header as used
              by Ofelia. The display-friendly name is the text
              between the quotes.
  - active   : '1' = enabled, '2' = disabled (VARCHAR, not boolean).
  - type     : category (system, dmarc, pushover, malware_feeds, ...).

Writing to the table is handled by inc/ofelia_generate_config.cfm
which renders /etc/ofelia/config.ini and restarts hermes_ofelia. We
do NOT write here — enable/disable/edit is future tier work.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Scheduled Tasks</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">System - Scheduled Tasks</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">System</li>
              <li class="breadcrumb-item active">Scheduled Tasks</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfquery name="getJobs" datasource="hermes">
    SELECT job_name, schedule, command, container, active, type, no_overlap
    FROM ofelia_jobs
    ORDER BY type, job_name
</cfquery>

<cfquery name="getLastRuns" datasource="hermes">
    SELECT job_name, MAX(triggered_at) AS last_run_at
    FROM scheduled_job_runs
    GROUP BY job_name
</cfquery>

<cfset lastRunMap = {}>
<cfloop query="getLastRuns">
    <cfset lastRunMap[getLastRuns.job_name] = getLastRuns.last_run_at>
</cfloop>

<!-- Info callout -->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Scheduled Tasks</h5>
  <p class="mb-1">Hermes uses <strong>Ofelia</strong> to run periodic maintenance jobs (certificate renewal, quarantine notifications, DMARC reports, intrusion-prevention validation, etc.). This page lists every job in the <code>ofelia_jobs</code> table and lets you trigger a one-off run on demand.</p>
  <ul class="mb-1">
    <li><strong>Status</strong> &mdash; <span class="badge bg-success">Enabled</span> jobs (<code>active = 1</code>) run on their configured schedule; <span class="badge bg-secondary">Disabled</span> jobs (<code>active = 2</code>) are present in the table but skipped by Ofelia.</li>
    <li><strong>Run Now</strong> &mdash; executes the job's command immediately, independent of the schedule. Works for both enabled and disabled jobs.</li>
    <li><strong>Last Run</strong> &mdash; shows the most recent <strong>manually-triggered</strong> run from this page. Ofelia's own scheduled executions are not recorded here.</li>
  </ul>
  <p class="mb-0"><small>Job definitions are edited elsewhere (e.g., the Malware Feeds settings page edits the <code>hermes-fangfrisch-refresh</code> schedule). Enable/disable and create-new controls on this page are future work.</small></p>
</div>

<!-- Jobs table -->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-clock me-2"></i>Scheduled Tasks (<cfoutput>#getJobs.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <cfif getJobs.recordcount EQ 0>
      <div class="alert alert-warning mb-0">
        <i class="fas fa-exclamation-triangle"></i> The <code>ofelia_jobs</code> table is empty. Seeds normally come from the install migration; if it's truly empty, consult the install script or re-run schema updates.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table id="scheduledTasksTable" class="table table-bordered table-striped" style="width:100%">
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Schedule</th>
            <th>Container</th>
            <th>Command</th>
            <th>Status</th>
            <th>Last Run (manual)</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getJobs">
            <cfset displayName = REReplace(job_name, "^\[job-exec\s+""([^""]+)"".*$", "\1")>
            <tr>
              <td><code>#HTMLEditFormat(displayName)#</code></td>
              <td><small>#HTMLEditFormat(type)#</small></td>
              <td><code>#HTMLEditFormat(schedule)#</code></td>
              <td>#HTMLEditFormat(container)#</td>
              <td><small style="word-break: break-all;"><code>#HTMLEditFormat(command)#</code></small></td>
              <td>
                <cfif Trim(active) EQ "1">
                  <span class="badge bg-success">Enabled</span>
                <cfelse>
                  <span class="badge bg-secondary">Disabled</span>
                </cfif>
                <cfif Val(no_overlap) EQ 1>
                  <span class="badge bg-info" title="Ofelia's no-overlap flag &mdash; a tick is skipped if the previous invocation is still running.">no-overlap</span>
                </cfif>
              </td>
              <td>
                <cfif StructKeyExists(lastRunMap, job_name)>
                  <small>#DateFormat(lastRunMap[job_name], "yyyy-mm-dd")# #TimeFormat(lastRunMap[job_name], "HH:mm:ss")#</small>
                <cfelse>
                  <small class="text-muted">&mdash;</small>
                </cfif>
              </td>
              <td>
                <button type="button"
                        class="btn btn-sm btn-primary run-now-btn"
                        data-job-name="#HTMLEditFormat(job_name)#"
                        data-display-name="#HTMLEditFormat(displayName)#">
                  <i class="fas fa-play"></i> Run Now
                </button>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
      </div>
    </cfif>
  </div>
</div>

<!-- Run Now result modal -->
<div class="modal fade" id="runResultModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">
          <i class="fas fa-play me-2"></i>Run Now: <span id="runResultJobName"></span>
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div id="runResultRunning" class="text-center py-4">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Running...</span>
          </div>
          <p class="mt-3 mb-0 text-muted">Executing job... this may take a few seconds.</p>
        </div>

        <div id="runResultSummary" style="display:none;">
          <div class="row mb-3">
            <div class="col-md-4">
              <strong>Status:</strong>
              <span id="runResultStatus"></span>
            </div>
            <div class="col-md-4">
              <strong>Duration:</strong>
              <span id="runResultDuration"></span>
            </div>
            <div class="col-md-4">
              <strong>Exit code:</strong>
              <code id="runResultExitCode"></code>
            </div>
          </div>
          <label class="form-label"><strong>Output</strong></label>
          <pre id="runResultOutput" style="background:##f8f9fa; padding:10px; max-height:400px; overflow:auto; font-size:12px; white-space: pre-wrap; word-break: break-all;"></pre>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>

<script>
  $(document).ready(function() {
    $('#scheduledTasksTable').DataTable({
      "order": [[0, "asc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [4, 7] }
      ]
    });

    $('#scheduledTasksTable').on('click', '.run-now-btn', function() {
      var jobName = $(this).data('job-name');
      var displayName = $(this).data('display-name');
      $('#runResultJobName').text(displayName);
      $('#runResultRunning').show();
      $('#runResultSummary').hide();
      new bootstrap.Modal(document.getElementById('runResultModal')).show();

      $.post('./inc/run_scheduled_task_action.cfm', { job_name: jobName })
        .done(function(data) {
          var r = (typeof data === 'string') ? JSON.parse(data) : data;
          $('#runResultRunning').hide();
          $('#runResultSummary').show();
          if (r.success) {
            $('#runResultStatus').html('<span class="badge bg-success">Success</span>');
          } else {
            $('#runResultStatus').html('<span class="badge bg-danger">Failed</span>' + (r.error ? ' <small class="text-danger ms-2">' + $('<div>').text(r.error).html() + '</small>' : ''));
          }
          $('#runResultDuration').text((r.duration_ms || 0) + ' ms');
          $('#runResultExitCode').text(r.exit_code || '—');
          $('#runResultOutput').text(r.output_summary || '(no output)');
          $('#runResultModal').one('hidden.bs.modal', function() { location.reload(); });
        })
        .fail(function(xhr) {
          $('#runResultRunning').hide();
          $('#runResultSummary').show();
          $('#runResultStatus').html('<span class="badge bg-danger">Request failed</span>');
          $('#runResultDuration').text('—');
          $('#runResultExitCode').text('—');
          $('#runResultOutput').text('HTTP ' + xhr.status + ': ' + xhr.statusText + '\n\n' + xhr.responseText);
        });
    });
  });
</script>

</html>
