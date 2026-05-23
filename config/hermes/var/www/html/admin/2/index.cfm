<!DOCTYPE html>

 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<html lang="en">



<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Welcome</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">



  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Welcome #session.theUser#!</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
            <cfif StructKeyExists(session, "previous_login") AND IsDate(session.previous_login)>
              <small class="text-muted"><i class="fas fa-clock me-1"></i>Last login: #DateTimeFormat(session.previous_login, "yyyy/mm/dd HH:nn")#</small>
            <cfelseif StructKeyExists(session, "previous_login")>
              <small class="text-muted"><i class="fas fa-clock me-1"></i>Last login: First login</small>
            </cfif>
          </cfoutput>

          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Home</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

        <!---
        <div class="alert alert-warning alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
             
          <p><i class="icon fas fa-exclamation-triangle"></i>Welcome to new Hermes SEG 2.0 Web GUI. The new Web GUI is still a work in progress. Some of the navigation links will take you to the old Web GUI. We appreciate your patience as we continue to improve Hermes SEG.</p>

          <!--- /DIV class="alert alert-warning alert-dismissible" --->
          </div>
        --->
      
<!--- Database credential injection into config files is now handled by
     /opt/hermes/scripts/rotate_db_credentials.sh which is called by the
     install script after container startup. The wizard_settings flag and
     the CFML credential updaters (update_postfix_config_files.cfm,
     update_djigzo_config_files.cfm, update_syslog_config_files.cfm)
     have been retired in favor of the bash script approach, which can
     also handle ALTER USER and full service restarts without depending
     on a working datasource connection. --->



  <!--- CHECK IF HERMES.KEY EXISTS AND IS NON-BLANK; GENERATE IF NEITHER ---><!--- Self-healing: on fresh installs (or if the file ever gets deleted) the
       file may not exist yet. Create an empty placeholder so the read below
       succeeds; the existing if-blank guard then calls generate_hermes_key.cfm
       which populates it with a fresh AES-256 key. This keeps the install
       script out of the hermes-key business entirely. --->
<cfif NOT FileExists("/opt/hermes/keys/hermes.key")>
  <cffile action="write" file="/opt/hermes/keys/hermes.key" output="" addnewline="no">
</cfif>
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">

<cfif #authkey# is "">

<!--- GENERATE HERMES KEY --->
<cfinclude template="./inc/generate_hermes_key.cfm">

<!--- #authkey# is "" --->
</cfif>

<!--- GENERATE CIPHERMAIL SERVER, CLIENT AND MAIL KEYWORDS IF EMPTY --->
<cfquery name="get_serverkeyword" datasource="hermes">
  select property, value from encryption_settings where property='user.serverSecret'
  </cfquery>

<cfif #get_serverkeyword.value# is "">

<!--- GENERATE SERVER KEYWORD --->
<cfinclude template="./inc/generate_ciphermail_server_secret.cfm">

<!--- /CFIF #get_serverkeyword.value# is "" --->
</cfif>

 <cfquery name="get_clientkeyword" datasource="hermes">
  select property, value from encryption_settings where property='user.clientSecret'
  </cfquery>

<cfif #get_clientkeyword.value# is "">

<!--- GENERATE CLIENT KEYWORD --->
<cfinclude template="./inc/generate_ciphermail_client_secret.cfm">

<!--- /CFIF #get_clientkeyword.value# is "" --->
</cfif>

<cfquery name="get_mailkeyword" datasource="hermes">
select property, value from encryption_settings where property='user.systemMailSecret'
</cfquery>
  
<cfif #get_mailkeyword.value# is "">

  <!--- GENERATE MAIL KEYWORD --->
<cfinclude template="./inc/generate_ciphermail_mail_secret.cfm">

<!--- /CFIF #get_mailkeyword.value# --->
</cfif>


<!--- GET SYSTEM RESOURCES AND INFO --->


<cfinclude template="./inc/get_system_uptime.cfm" />
<cfinclude template="./inc/get_system_version_build.cfm" />
<cfinclude template="./inc/get_system_reboot_required.cfm" />
<cfinclude template="./inc/check_system_update.cfm" />

<!--- Generate container IPs file for fail2ban API notify script --->
<!--- This file is read by hermes-api-notify.sh which can't use Docker DNS in host network mode --->
<cfinclude template="./inc/generate_container_ips.cfm" />



<div id="systemresources">

  <cfinclude template="./inc/get_system_resources.cfm" />

<!--- /DIV id=systemresources --->
</div>

 <!-- System Info Card -->
 <div class="card mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <i class="fas fa-info"></i>
     System Info
    </h3>


  <!-- /.card-header -->
</div>



  <div class="card-body table-responsive">

    <div class="row">

      <table class="table">
        <thead>
        <tr>
          <th>Version</th>
          <th>Build</th>
          <th>Edition</th>
          <th>Uptime</th>
          <th>Console IP or FQDN</th>
          <th>License Status</th>
          <th>OS Updates</th>
          <th>Hermes Update</th>
     
    
        </tr>
        </thead>
        <tbody>

          <tr>
            <cfoutput>
            <td>#theVersion#</td>
            <td>#theBuild#</td>

            <cfif session.license EQ "TAMPERED">
            <td>Pro <span class="text-danger">(Templates Modified)</span></td>
            <cfelseif session.license EQ "PENDING_VALIDATION">
            <td>Pro <span class="text-warning">(Validation Required)</span></td>
            <cfelseif #session.edition# is "Community">
            <td>#session.edition#&nbsp;&nbsp;<a href='view_system_settings.cfm'>ENTER SERIAL</a></td>
            <cfelseif #session.edition# is "Pro">
              <td>#session.edition#</td>
            <cfelse>
              <td>N/A</td>
          </cfif>

            <td>#uptime# Days</td>
            <td>#ConsoleHost#</td>


<cfif session.license EQ "TAMPERED">
  <td class="text-danger">Template integrity violation</td>
<cfelseif session.license EQ "PENDING_VALIDATION">
  <td class="text-warning">Online validation required</td>
<cfelseif #session.edition# is "Pro">
  <cfif #session.license# is "VALID">
    <td>#session.license# EXPIRES #session.licenseexpires#</td>
  <cfelseif #session.license# is "EXPIRED">
    <td>#session.license# ON #session.licenseexpires#</td>
  <cfelseif #session.license# is "VIOLATION">
    <td>VIOLATION</td>
  <cfelseif #session.license# is "N/A">
    <td>N/A</td>
  <!--- /CFIF #session.license# --->
  </cfif>
<cfelseif #session.edition# is "Community">
  <td>N/A</td>
 <!--- /CFIF #session.edition# --->
</cfif>         



          <cfif #mustreboot# is "2">
            <td>REBOOT REQUIRED</td>
          <cfelse>
            <td>NO REBOOT REQUIRED</td>
          </cfif>

<cfif #hermesupdate# contains 'UPDATEFOUND'>

  <td>
  <a href="##" data-bs-toggle="modal" data-bs-target="##releaseNotesModal" data-build="#build#" class="release-notes-link">UPDATE BUILD #build# FOUND</a>
</td>

<cfelse>

  <td>#hermesupdate#</td>

</cfif>

         

          </cfoutput>
         
      </tr>
            
                  
                  </tbody>
                </table>


<!--- /DIV class="row" --->
</div>

      
    <!--- /DIV class="card-body table-responsive" --->
    </div>

        <!--- /DIV class="card" --->
      </div>

<!-- Message Statistics Card -->
<div class="card mb-4">
  <div class="card-header d-flex justify-content-between align-items-center">
    <h3 class="card-title">
      <i class="fas fa-envelope"></i>
      Messages Processed
    </h3>
    <div class="card-tools">
      <select id="messagePeriodSelect" class="form-select form-select-sm" style="width: auto;">
        <option value="0.25">Past 15 Minutes</option>
        <option value="1">Past Hour</option>
        <option value="8">Past 8 Hours</option>
        <option value="12">Past 12 Hours</option>
        <option value="24" selected>Past 24 Hours</option>
      </select>
    </div>
  </div>

  <div class="card-body">
    <div class="row">
      <div class="col-md-8">
        <div class="chart-container" style="position: relative; height: 250px;">
          <canvas id="messageStatsChart"></canvas>
        </div>
      </div>
      <div class="col-md-4">
        <div class="d-flex flex-column justify-content-center h-100">
          <h4 class="text-center mb-3">Total: <span id="stat-total" class="fw-bold">0</span></h4>
          <table class="table table-sm table-borderless">
            <tbody>
              <tr>
                <td><span class="badge" style="background-color: #28a745;">&nbsp;&nbsp;</span> Clean</td>
                <td class="text-end fw-bold" id="stat-clean">0</td>
              </tr>
              <tr>
                <td><span class="badge" style="background-color: #ffc107;">&nbsp;&nbsp;</span> Spam</td>
                <td class="text-end fw-bold" id="stat-spam">0</td>
              </tr>
              <tr>
                <td><span class="badge" style="background-color: #dc3545;">&nbsp;&nbsp;</span> Virus</td>
                <td class="text-end fw-bold" id="stat-virus">0</td>
              </tr>
              <tr>
                <td><span class="badge" style="background-color: #6c757d;">&nbsp;&nbsp;</span> Banned</td>
                <td class="text-end fw-bold" id="stat-banned">0</td>
              </tr>
              <tr>
                <td><span class="badge" style="background-color: #343a40;">&nbsp;&nbsp;</span> Bad Header</td>
                <td class="text-end fw-bold" id="stat-badheader">0</td>
              </tr>
              <tr>
                <td><span class="badge" style="background-color: #17a2b8;">&nbsp;&nbsp;</span> Other</td>
                <td class="text-end fw-bold" id="stat-other">0</td>
              </tr>
            </tbody>
          </table>
          <small id="stat-limit-note" class="text-muted" style="display: none;">
            <i class="fas fa-info-circle"></i> Showing most recent 10,000 messages
          </small>
        </div>
      </div>
    </div>
  </div>
  <!--- /DIV class="card" --->
</div>

        <!-- System Resources Card -->
        <div class="card mb-4">

          <div class="card-header">
            <h3 class="card-title">
              <i class="fas fa-chart-bar"></i>
             System Resources
            </h3>


       <!-- /.card-header -->
</div>



          <div class="card-body" id="systemresources">

            <div class="row g-4">
              <div class="col-6 col-md text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-cpu" data-value="#cpu#" data-color="###cpucolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#cpu#</div>
                </div>
                </cfoutput>
                <div class="knob-label">CPU Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-mem" data-value="#mem#" data-color="###memcolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#mem#</div>
                </div>
                </cfoutput>
                <div class="knob-label">Memory Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-root" data-value="#rootusage#" data-color="###rootusagecolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#rootusage#</div>
                </div>
                </cfoutput>
                <div class="knob-label">Root FileSystem Utilization %</div>
              </div>
              <!-- ./col -->


              <div class="col-6 col-md text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-data" data-value="#datausage#" data-color="###datausagecolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#datausage#</div>
                </div>
                </cfoutput>
                <div class="knob-label">Data FileSystem Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-vmail" data-value="#vmailusage#" data-color="###vmailusagecolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#vmailusage#</div>
                </div>
                </cfoutput>
                <div class="knob-label">Vmail FileSystem Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-nextcloud" data-value="#nextcloudusage#" data-color="###nextcloudusagecolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#nextcloudusage#</div>
                </div>
                </cfoutput>
                <div class="knob-label">Nextcloud FileSystem Utilization %</div>
              </div>
              <!-- ./col -->

  <!--- /DIV class="row" --->
</div>

      
<!--- /DIV class="card-body table-responsive" --->
</div>

    <!--- /DIV class="card" --->
  </div>
                      

</div><!-- /.col -->
</div><!-- /.row -->
           
           
      
      <!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </div>
  </main><!-- replaced content-wrapper -->


  <cfinclude template="./inc/main_footer.cfm" />

<!-- Release Notes Modal -->
<div class="modal fade" id="releaseNotesModal" tabindex="-1" aria-labelledby="releaseNotesModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="releaseNotesModalLabel">Release Notes</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="releaseNotesContent">
        <div class="text-center">
          <div class="spinner-border" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p>Loading release notes...</p>
        </div>
      </div>
      <div class="modal-footer">
        <a href="#" id="githubReleaseLink" target="_blank" class="btn btn-primary">View on GitHub</a>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Release Notes Modal Script (Vanilla JS) -->
<script>
document.addEventListener('DOMContentLoaded', function() {
  // Handle release notes link click
  document.querySelectorAll('.release-notes-link').forEach(function(link) {
    link.addEventListener('click', function(e) {
      var buildNumber = this.getAttribute('data-build');
      var githubReleaseUrl = 'https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases/tag/build-' + buildNumber;
      var githubApiUrl = 'https://api.github.com/repos/deeztek/Hermes-Secure-Email-Gateway/releases/tags/build-' + buildNumber;

      // Update modal title and GitHub link
      document.getElementById('releaseNotesModalLabel').textContent = 'Release Notes - Build ' + buildNumber;
      document.getElementById('githubReleaseLink').href = githubReleaseUrl;

      // Show loading state
      document.getElementById('releaseNotesContent').innerHTML =
        '<div class="text-center">' +
          '<div class="spinner-border" role="status">' +
            '<span class="visually-hidden">Loading...</span>' +
          '</div>' +
          '<p>Loading release notes...</p>' +
        '</div>';

      // Fetch release notes from GitHub API
      fetch(githubApiUrl)
        .then(function(response) {
          if (!response.ok) throw new Error('HTTP ' + response.status);
          return response.json();
        })
        .then(function(data) {
          if (data && data.body) {
            var releaseNotes = convertMarkdownToHtml(data.body);
            document.getElementById('releaseNotesContent').innerHTML =
              '<h6>Published: ' + new Date(data.published_at).toLocaleDateString() + '</h6>' +
              '<hr>' +
              '<div class="release-notes-body">' + releaseNotes + '</div>';
          } else {
            document.getElementById('releaseNotesContent').innerHTML =
              '<div class="alert alert-warning">' +
                '<i class="fas fa-exclamation-triangle"></i> No release notes found for this build.' +
              '</div>';
          }
        })
        .catch(function(error) {
          document.getElementById('releaseNotesContent').innerHTML =
            '<div class="alert alert-danger">' +
              '<i class="fas fa-times-circle"></i> Error loading release notes: ' + error.message + '<br>' +
              '<small>The release may not exist yet or GitHub API rate limit exceeded.</small>' +
            '</div>' +
            '<p>You can view the release directly on GitHub:</p>' +
            '<a href="' + githubReleaseUrl + '" target="_blank" class="btn btn-outline-primary">' +
              '<i class="fab fa-github"></i> View Release on GitHub' +
            '</a>';
        });
    });
  });

  // Basic Markdown to HTML converter
  function convertMarkdownToHtml(markdown) {
    if (!markdown) return '';

    var html = markdown
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/^### (.*$)/gim, '<h5>$1</h5>')
      .replace(/^## (.*$)/gim, '<h4>$1</h4>')
      .replace(/^# (.*$)/gim, '<h3>$1</h3>')
      .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.*?)\*/g, '<em>$1</em>')
      .replace(/```([\s\S]*?)```/g, '<pre><code>$1</code></pre>')
      .replace(/`(.*?)`/g, '<code>$1</code>')
      .replace(/^\s*[-*]\s+(.*$)/gim, '<li>$1</li>')
      .replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2" target="_blank">$1</a>')
      .replace(/\n\n/g, '</p><p>')
      .replace(/\n/g, '<br>');

    html = html.replace(/(<li>.*<\/li>)/s, '<ul>$1</ul>');
    html = '<p>' + html + '</p>';

    return html;
  }
});
</script>

<!-- System Resources - CSS Progress Rings (Vanilla JS) -->
<script>
(function() {
  var RING_RADIUS = 38;
  var RING_CIRCUMFERENCE = 2 * Math.PI * RING_RADIUS;

  // Function to update a progress ring
  function updateProgressRing(id, value, color) {
    var container = document.getElementById(id);
    if (!container) return;

    // Default to 0 if value is undefined, null, or not a number
    var numValue = (value !== undefined && value !== null && !isNaN(value)) ? Number(value) : 0;

    var circle = container.querySelector('.progress-ring-circle');
    var text = container.querySelector('.progress-ring-text');

    if (circle && text) {
      // Calculate stroke offset (0 = full, circumference = empty)
      var offset = RING_CIRCUMFERENCE - (numValue / 100) * RING_CIRCUMFERENCE;
      circle.style.strokeDasharray = RING_CIRCUMFERENCE + ' ' + RING_CIRCUMFERENCE;
      circle.style.strokeDashoffset = offset;
      circle.style.stroke = color || '#20c997';
      text.textContent = numValue;
    }
  }

  // Initialize all progress rings on page load
  function initProgressRings() {
    document.querySelectorAll('.progress-ring-container').forEach(function(container) {
      var value = parseInt(container.getAttribute('data-value')) || 0;
      var color = container.getAttribute('data-color') || '#20c997';
      var circle = container.querySelector('.progress-ring-circle');

      if (circle) {
        circle.style.strokeDasharray = RING_CIRCUMFERENCE + ' ' + RING_CIRCUMFERENCE;
        var offset = RING_CIRCUMFERENCE - (value / 100) * RING_CIRCUMFERENCE;
        circle.style.strokeDashoffset = offset;
        circle.style.stroke = color;
      }
    });
  }

  // Function to fetch and update system resources
  function refreshSystemResources() {
    fetch('/admin/2/api/get_system_resources.cfm?_=' + Date.now())
      .then(function(response) { return response.json(); })
      .then(function(data) {
        if (data.success) {
          updateProgressRing('ring-cpu', data.cpu, '#' + data.cpuColor);
          updateProgressRing('ring-mem', data.mem, '#' + data.memColor);
          updateProgressRing('ring-root', data.rootUsage, '#' + data.rootUsageColor);
          updateProgressRing('ring-data', data.dataUsage, '#' + data.dataUsageColor);
          updateProgressRing('ring-vmail', data.vmailUsage, '#' + data.vmailUsageColor);
          updateProgressRing('ring-nextcloud', data.nextcloudUsage, '#' + data.nextcloudUsageColor);
        }
      })
      .catch(function(error) {
        console.log('Error fetching system resources:', error);
      });
  }

  // Initialize rings on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initProgressRings);
  } else {
    initProgressRings();
  }

  // Auto-refresh every 10 seconds
  setInterval(refreshSystemResources, 10000);
})();
</script>

<!-- Message Statistics Script (Vanilla JS) -->
<script>
(function() {
  var messageStatsChart = null;
  var currentPeriod = '24';

  // Function to fetch and update message statistics
  function refreshMessageStats(period) {
    if (period) currentPeriod = period;

    fetch('/admin/2/api/get_message_stats.cfm?period=' + currentPeriod + '&_=' + Date.now())
      .then(function(response) { return response.json(); })
      .then(function(data) {
        if (data.success) {
          // Update text values with limited indicator
          var totalText = data.total.toLocaleString();
          if (data.limited) {
            totalText += '+';
          }
          document.getElementById('stat-total').textContent = totalText;
          document.getElementById('stat-clean').textContent = data.clean.toLocaleString();
          document.getElementById('stat-spam').textContent = data.spam.toLocaleString();
          document.getElementById('stat-virus').textContent = data.virus.toLocaleString();
          document.getElementById('stat-banned').textContent = data.banned.toLocaleString();
          document.getElementById('stat-badheader').textContent = data.badHeader.toLocaleString();
          document.getElementById('stat-other').textContent = data.other.toLocaleString();

          // Show/hide limited note
          var limitNote = document.getElementById('stat-limit-note');
          if (limitNote) {
            limitNote.style.display = data.limited ? 'block' : 'none';
          }

          // Update chart
          updateMessageChart(data);
        }
      })
      .catch(function(error) {
        console.log('Error fetching message stats:', error);
      });
  }

  // Function to create/update the chart
  function updateMessageChart(data) {
    var canvas = document.getElementById('messageStatsChart');
    if (!canvas) return;

    // Ensure Chart.js is available
    if (typeof Chart === 'undefined') {
      console.log('Chart.js not loaded yet');
      return;
    }

    var ctx = canvas.getContext('2d');

    var chartData = {
      labels: ['Clean', 'Spam', 'Virus', 'Banned', 'Bad Header', 'Other'],
      datasets: [{
        data: [data.clean, data.spam, data.virus, data.banned, data.badHeader, data.other],
        backgroundColor: [
          '#28a745', // Green - Clean
          '#ffc107', // Yellow - Spam
          '#dc3545', // Red - Virus
          '#6c757d', // Gray - Banned
          '#343a40', // Dark - Bad Header
          '#17a2b8'  // Cyan - Other
        ],
        borderWidth: 0
      }]
    };

    var chartOptions = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              var label = context.label || '';
              var value = context.raw || 0;
              var total = data.total || 1;
              var percentage = ((value / total) * 100).toFixed(1);
              return label + ': ' + value.toLocaleString() + ' (' + percentage + '%)';
            }
          }
        }
      }
    };

    if (messageStatsChart) {
      // Update existing chart
      messageStatsChart.data = chartData;
      messageStatsChart.update();
    } else {
      // Create new chart
      messageStatsChart = new Chart(ctx, {
        type: 'doughnut',
        data: chartData,
        options: chartOptions
      });
    }
  }

  // Initialize message stats functionality
  function initMessageStats() {
    // Handle period selector change
    var periodSelect = document.getElementById('messagePeriodSelect');
    if (periodSelect) {
      periodSelect.addEventListener('change', function() {
        refreshMessageStats(this.value);
      });
    }

    // Initial load of message stats immediately
    refreshMessageStats();

    // Auto-refresh message stats every 60 seconds
    setInterval(function() { refreshMessageStats(); }, 60000);
  }

  // Wait for DOM to be ready before initializing
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMessageStats);
  } else {
    initMessageStats();
  }
})();
</script>

<!-- ./wrapper -->


</body>







</html>
