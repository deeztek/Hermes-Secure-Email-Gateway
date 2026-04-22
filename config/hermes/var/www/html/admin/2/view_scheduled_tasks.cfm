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

<!--- Load ofelia jobs from config.ini --->
<cfinclude template="./inc/parse_ofelia_config.cfm">

<!--- Load last-run-at per job from our local history table --->
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
  <p class="mb-1">Hermes uses <strong>Ofelia</strong> to run periodic maintenance jobs (certificate renewal, quarantine reports, intrusion-prevention validation, etc.). This page lists every job defined in <code>/etc/ofelia/config.ini</code>, its schedule, and lets you trigger a one-off run on demand.</p>
  <ul class="mb-1">
    <li><strong>Status</strong> &mdash; <span class="badge bg-success">Enabled</span> jobs run on their configured schedule; <span class="badge bg-secondary">Disabled</span> jobs are present in the config but commented out.</li>
    <li><strong>Run Now</strong> &mdash; executes the job's command immediately, independent of the schedule. Works for both enabled and disabled jobs (useful for one-off re-runs of a disabled job without turning it on).</li>
    <li><strong>Last Run</strong> &mdash; shows the most recent <strong>manually-triggered</strong> run from this page. Ofelia's own scheduled executions are not recorded here.</li>
  </ul>
  <p class="mb-0"><small>Output from each Run Now is captured and shown in a modal. Long-running jobs time out at 300 seconds in this view; the scheduled execution is unaffected.</small></p>
</div>

<!-- Jobs table -->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-clock me-2"></i>Scheduled Tasks (<cfoutput>#ArrayLen(ofeliaJobs)#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <cfif ArrayLen(ofeliaJobs) EQ 0>
      <div class="alert alert-warning mb-0">
        <i class="fas fa-exclamation-triangle"></i> No jobs found in <code>/etc/ofelia/config.ini</code>. Either the file is missing, empty, or contains no <code>[job-exec &quot;name&quot;]</code> blocks.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table id="scheduledTasksTable" class="table table-bordered table-striped" style="width:100%">
        <thead>
          <tr>
            <th>Name</th>
            <th>Schedule</th>
            <th>Container</th>
            <th>Command</th>
            <th>Status</th>
            <th>Last Run (manual)</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput>
          <cfloop array="#ofeliaJobs#" index="job">
            <tr>
              <td><code>#HTMLEditFormat(job.name)#</code></td>
              <td><code>#HTMLEditFormat(job.schedule)#</code></td>
              <td>#HTMLEditFormat(job.container)#</td>
              <td><small style="word-break: break-all;"><code>#HTMLEditFormat(job.command)#</code></small></td>
              <td>
                <cfif job.enabled>
                  <span class="badge bg-success">Enabled</span>
                <cfelse>
                  <span class="badge bg-secondary">Disabled</span>
                </cfif>
              </td>
              <td>
                <cfif StructKeyExists(lastRunMap, job.name)>
                  <small>#DateFormat(lastRunMap[job.name], "yyyy-mm-dd")# #TimeFormat(lastRunMap[job.name], "HH:mm:ss")#</small>
                <cfelse>
                  <small class="text-muted">&mdash;</small>
                </cfif>
              </td>
              <td>
                <button type="button"
                        class="btn btn-sm btn-primary run-now-btn"
                        data-job-name="#HTMLEditFormat(job.name)#">
                  <i class="fas fa-play"></i> Run Now
                </button>
              </td>
            </tr>
          </cfloop>
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
        <!-- Running spinner -->
        <div id="runResultRunning" class="text-center py-4">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Running...</span>
          </div>
          <p class="mt-3 mb-0 text-muted">Executing job... this may take a few seconds.</p>
        </div>

        <!-- Result summary -->
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
        { "orderable": false, "targets": [3, 6] }
      ]
    });

    $('#scheduledTasksTable').on('click', '.run-now-btn', function() {
      var jobName = $(this).data('job-name');
      $('#runResultJobName').text(jobName);
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
          // Reload the page after modal closes so "Last Run" column refreshes
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
