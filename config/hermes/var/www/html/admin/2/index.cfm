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


  <style>
    /* Dashboard presentation only: existing CFML/JavaScript logic is unchanged. */
    .hermes-dashboard {
      --dashboard-gap: 1.25rem;
    }

    .hermes-dashboard .dashboard-card {
      height: 100%;
      margin-bottom: 0 !important;
      border-radius: 0.75rem;
      overflow: hidden;
    }

    .hermes-dashboard .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: var(--dashboard-gap);
      align-items: stretch;
      margin-bottom: var(--dashboard-gap);
    }

    .hermes-dashboard .dashboard-grid > .dashboard-card {
      min-width: 0;
    }

    .hermes-dashboard .dashboard-card-wide {
      margin-bottom: var(--dashboard-gap) !important;
    }

    .hermes-dashboard .card-header {
      min-height: 3.25rem;
      display: flex;
      align-items: center;
      padding: 0.85rem 1rem;
    }

    .hermes-dashboard .card-title {
      display: flex;
      align-items: center;
      gap: 0.55rem;
      margin: 0;
      font-weight: 600;
      letter-spacing: 0.01em;
    }

    .hermes-dashboard .card-title i {
      width: 1.25rem;
      text-align: center;
      opacity: 0.9;
    }

    .hermes-dashboard .card-body {
      padding: 1rem;
    }

    .hermes-dashboard .system-info-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 0.75rem;
    }

    .hermes-dashboard .system-info-item {
      min-width: 0;
      min-height: 5.4rem;
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 0.9rem 1rem;
      border: 1px solid var(--bs-border-color);
      border-radius: 0.65rem;
      background: var(--bs-tertiary-bg);
      box-shadow: 0 0.15rem 0.45rem rgba(0, 0, 0, 0.035);
    }

    .hermes-dashboard .system-info-label {
      display: block;
      margin-bottom: 0.3rem;
      font-size: 0.72rem;
      font-weight: 700;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--bs-secondary-color);
    }

    .hermes-dashboard .system-info-value {
      display: block;
      min-width: 0;
      overflow-wrap: anywhere;
      font-weight: 600;
    }

    .hermes-dashboard .message-stats-card .chart-container {
      height: 290px !important;
    }

    .hermes-dashboard .message-stats-summary {
      height: 100%;
      padding: 0.75rem;
      border: 1px solid var(--bs-border-color);
      border-radius: 0.65rem;
      background: var(--bs-tertiary-bg);
    }

    .hermes-dashboard .message-stats-summary h4 {
      font-size: 1.35rem;
    }

    .hermes-dashboard .message-stats-summary .table {
      margin-bottom: 0;
    }

    .hermes-dashboard .traffic-stat {
      border-radius: 0.7rem;
      min-height: 6.25rem;
      transition: transform 0.15s ease, box-shadow 0.15s ease;
    }

    .hermes-dashboard .traffic-stat:hover {
      transform: translateY(-1px);
      box-shadow: 0 0.35rem 1rem rgba(0, 0, 0, 0.08) !important;
    }

    .hermes-dashboard .traffic-stat .inner h3 {
      font-size: 1.8rem;
      margin-bottom: 0.15rem;
    }

    .hermes-dashboard .traffic-processing {
      display: flex;
      flex-direction: column;
      justify-content: center;
      min-height: 6.25rem;
      border-radius: 0.7rem;
    }

    .hermes-dashboard .traffic-table-card,
    .hermes-dashboard .quick-access-card { height: 100%; }
    .hermes-dashboard .quick-access-card .card-body { padding: 0.85rem; }
    .hermes-dashboard .quick-access-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 0.75rem;
    }
    .hermes-dashboard .quick-access-item {
      min-width: 0;
      min-height: 4.25rem;
      display: flex;
      align-items: center;
      gap: 0.65rem;
      padding: 0.75rem 0.85rem;
      border: 1px solid var(--bs-border-color);
      border-radius: 0.65rem;
      background: var(--bs-tertiary-bg);
      color: var(--bs-body-color);
      text-decoration: none;
      font-weight: 600;
      transition: transform 0.15s ease, box-shadow 0.15s ease, background-color 0.15s ease;
    }
    .hermes-dashboard .quick-access-item:hover {
      transform: translateY(-2px);
      box-shadow: 0 0.3rem 0.8rem rgba(0, 0, 0, 0.08);
      text-decoration: none;
    }
    .hermes-dashboard .quick-access-item i {
      flex: 0 0 1.5rem;
      width: 1.5rem;
      text-align: center;
      font-size: 1rem;
    }
    .hermes-dashboard .quick-access-item span {
      min-width: 0;
      overflow-wrap: anywhere;
    }

    .hermes-dashboard .resource-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 0.75rem;
      align-items: stretch;
      width: 100%;
    }

    .hermes-dashboard .resource-card .card-body {
      overflow: visible;
    }

    .hermes-dashboard .resource-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: flex-start;
    }

    .hermes-dashboard .resource-item {
      min-width: 0;
      padding: 0.85rem 0.5rem;
      border: 1px solid var(--bs-border-color);
      border-radius: 0.7rem;
      background: var(--bs-tertiary-bg);
    }

    .hermes-dashboard .progress-ring-container {
      margin: 0 auto;
    }

    .hermes-dashboard .knob-label {
      min-height: 2.5rem;
      margin-top: 0.65rem;
      font-size: 0.78rem;
      line-height: 1.25;
      font-weight: 600;
      color: var(--bs-secondary-color);
    }

    .hermes-dashboard .table thead th {
      white-space: nowrap;
      font-size: 0.78rem;
      letter-spacing: 0.03em;
      text-transform: uppercase;
      color: var(--bs-secondary-color);
      border-bottom-width: 1px;
    }

    .hermes-dashboard .table tbody tr:last-child td {
      border-bottom: 0;
    }

    .hermes-dashboard .release-notes-body {
      line-height: 1.65;
    }

    @media (max-width: 1399.98px) {
      .hermes-dashboard .system-info-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 991.98px) {
      .hermes-dashboard .dashboard-grid {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 767.98px) {
      .hermes-dashboard .system-info-grid,
      .hermes-dashboard .health-summary-grid {
        grid-template-columns: 1fr;
      }

      .hermes-dashboard .resource-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }\n\n      .hermes-dashboard .quick-access-grid {
        grid-template-columns: 1fr;
      }

      .hermes-dashboard .message-stats-card .chart-container {
        height: 240px !important;
      }

      .hermes-dashboard .card-body {
        padding: 0.85rem;
      }
    }
  </style>

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

 <div class="hermes-dashboard">

<div class="dashboard-grid dashboard-grid-top">

<!-- System Info Card -->
 <div class="card card-outline card-primary shadow-sm mb-4 dashboard-card system-info-card">
   <div class="card-header bg-body-secondary">
    <h3 class="card-title">
      <i class="fas fa-info"></i>
     System Info
    </h3>
   </div>

   <div class="card-body">
     <div class="system-info-grid">

       <div class="system-info-item">
         <span class="system-info-label">Version</span>
         <span class="system-info-value"><cfoutput>#theVersion#</cfoutput></span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">Build</span>
         <span class="system-info-value"><cfoutput>#theBuild#</cfoutput></span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">Edition</span>
         <span class="system-info-value">
           <cfoutput>
           <cfif session.license EQ "TAMPERED">
             Pro <span class="text-danger">(Templates Modified)</span>
           <cfelseif session.license EQ "PENDING_VALIDATION">
             Pro <span class="text-warning">(Validation Required)</span>
           <cfelseif #session.edition# is "Community">
             #session.edition#&nbsp;&nbsp;<a href='view_system_settings.cfm'>ENTER SERIAL</a>
           <cfelseif #session.edition# is "Pro">
             #session.edition#
           <cfelse>
             N/A
           </cfif>
           </cfoutput>
         </span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">Uptime</span>
         <span class="system-info-value"><cfoutput>#uptime# Days</cfoutput></span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">Console IP or FQDN</span>
         <span class="system-info-value"><cfoutput>#ConsoleHost#</cfoutput></span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">License Status</span>
         <span class="system-info-value">
           <cfoutput>
           <cfif session.license EQ "TAMPERED">
             <span class="text-danger">Template integrity violation</span>
           <cfelseif session.license EQ "PENDING_VALIDATION">
             <span class="text-warning">Online validation required</span>
           <cfelseif #session.edition# is "Pro">
             <cfif #session.license# is "VALID">
               #session.license# EXPIRES #session.licenseexpires#
             <cfelseif #session.license# is "EXPIRED">
               #session.license# ON #session.licenseexpires#
             <cfelseif #session.license# is "VIOLATION">
               VIOLATION
             <cfelseif #session.license# is "N/A">
               N/A
             <!--- /CFIF #session.license# --->
             </cfif>
           <cfelseif #session.edition# is "Community">
             N/A
           <!--- /CFIF #session.edition# --->
           </cfif>
           </cfoutput>
         </span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">OS Updates</span>
         <span class="system-info-value">
           <cfoutput>
           <cfif #mustreboot# is "2">
             REBOOT REQUIRED
           <cfelse>
             NO REBOOT REQUIRED
           </cfif>
           </cfoutput>
         </span>
       </div>

       <div class="system-info-item">
         <span class="system-info-label">Hermes Update</span>
         <span class="system-info-value">
           <cfoutput>
           <cfif #hermesupdate# contains 'UPDATEFOUND'>
             <a href="##" data-bs-toggle="modal" data-bs-target="##releaseNotesModal" data-build="#build#" class="release-notes-link">UPDATE BUILD #build# FOUND</a>
           <cfelseif IsDefined("hermesupdatestale") AND hermesupdatestale EQ 1>
             <!--- Unverified reading (issue 288). PENDING / UNAVAILABLE used to render as
                  plain text identical in weight to a healthy "LATEST VERSION", so a
                  scheduler that had stopped feeding this cell looked like a normal
                  state and went unnoticed indefinitely. Flag it, say why, and offer the
                  one-click check so it is resolvable from here. --->
             <span class="text-warning" title="#EncodeForHTMLAttribute(hermesupdatehint)#">
               <i class="fas fa-exclamation-triangle"></i> #hermesupdate#
             </span>
             <br>
             <a href="inc/run_update_check.cfm" class="small">Check now</a>
           <cfelse>
             #hermesupdate#
           </cfif>
           </cfoutput>
         </span>
       </div>

     </div>
   </div>
 </div>

<!-- System Resources Card -->
        <div class="card mb-4 dashboard-card resource-card">

          <div class="card-header">
            <h3 class="card-title">
              <i class="fas fa-chart-bar"></i>
             System Resources
            </h3>


       <!-- /.card-header -->
</div>



          <div class="card-body" id="systemresources">

            <div class="resource-grid">
              <div class="resource-item text-center">
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

              <div class="resource-item text-center">
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

              <div class="resource-item text-center">
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


              <div class="resource-item text-center">
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

              <!--- Archive tier ring -- #260 (Amavis quarantine on its own tier) --->
              <div class="resource-item text-center">
                <cfoutput>
                <div class="progress-ring-container" id="ring-archive" data-value="#archiveusage#" data-color="###archiveusagecolor#">
                  <svg class="progress-ring" width="90" height="90">
                    <circle class="progress-ring-bg" cx="45" cy="45" r="38" />
                    <circle class="progress-ring-circle" cx="45" cy="45" r="38" />
                  </svg>
                  <div class="progress-ring-text">#archiveusage#</div>
                </div>
                </cfoutput>
                <div class="knob-label">Archive FileSystem Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="resource-item text-center">
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

              <div class="resource-item text-center">
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

</div><!-- /.dashboard-grid -->

<div class="dashboard-grid">

<!-- Message Statistics Card -->
<div class="card mb-4 dashboard-card message-stats-card">
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
        <div class="d-flex flex-column justify-content-center h-100 message-stats-summary">
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

<!-- Mail Traffic Insights -->
<div class="card card-outline card-primary shadow-sm mb-4 dashboard-card">
  <div class="card-header bg-body-secondary">
    <h3 class="card-title">
      <i class="fas fa-exchange-alt"></i>
      Mail Traffic Insights
    </h3>
  </div>
  <div class="card-body">
    <div class="row g-3">
      <div class="col-lg-4">
        <div class="row g-3">
          <div class="col-12">
        <div class="small-box text-bg-primary mb-0 shadow-sm traffic-stat">
          <div class="inner">
            <h3 id="traffic-incoming">0</h3>
            <p>Incoming Mail</p>
          </div>
          <div class="icon"><i class="fas fa-inbox"></i></div>
        </div>
          </div>
          <div class="col-12">
        <div class="small-box text-bg-success mb-0 shadow-sm traffic-stat">
          <div class="inner">
            <h3 id="traffic-outgoing">0</h3>
            <p>Outgoing Mail</p>
          </div>
          <div class="icon"><i class="fas fa-paper-plane"></i></div>
        </div>
          </div>
          <div class="col-12">
        <div class="alert alert-secondary mb-0 h-100 traffic-processing">
          <strong>Average processing time:</strong>
          <span id="avg-processing-time">Not available</span>
          <br>
          <small id="avg-processing-note" class="text-muted">Not available</small>
        </div>
          </div>
        </div>
      </div>
      <div class="col-lg-4">
        <div class="card h-100 shadow-sm traffic-table-card">
          <div class="card-header py-2"><h6 class="mb-0">Top 10 Senders</h6></div>
          <div class="card-body p-2">
        <div class="table-responsive">
          <table class="table table-sm mb-0">
            <thead>
              <tr>
                <th>Sender</th>
                <th class="text-end">Messages</th>
              </tr>
            </thead>
            <tbody id="top-senders-body">
              <tr><td colspan="2" class="text-muted">Loading...</td></tr>
            </tbody>
          </table>
        </div>
          </div>
        </div>
      </div>
      <div class="col-lg-4">
        <div class="card h-100 shadow-sm traffic-table-card">
          <div class="card-header py-2"><h6 class="mb-0">Top 10 Recipients</h6></div>
          <div class="card-body p-2">
        <div class="table-responsive">
          <table class="table table-sm mb-0">
            <thead>
              <tr>
                <th>Recipient</th>
                <th class="text-end">Messages</th>
              </tr>
            </thead>
            <tbody id="top-recipients-body">
              <tr><td colspan="2" class="text-muted">Loading...</td></tr>
            </tbody>
          </table>
        </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

</div><!-- /.dashboard-grid -->

<div class="dashboard-grid">

<!-- Health Checks -->
<div class="card card-outline card-success shadow-sm mb-4 dashboard-card">
  <div class="card-header bg-body-secondary">
    <h3 class="card-title">
      <i class="fas fa-heartbeat"></i>
      Health Checks
    </h3>
  </div>
  <div class="card-body">
    <div class="row g-3">
      <div class="col-12">
        <div class="row g-3 mb-1">
          <div class="col-md-6">
            <div class="info-box mb-2 bg-light shadow-sm">
              <span class="info-box-icon text-bg-success"><i class="fas fa-shield-alt"></i></span>
              <div class="info-box-content">
                <span class="info-box-text">Security Checks</span>
                <span class="info-box-number"><span id="health-check-pass">0</span>/<span id="health-check-total">0</span> passing</span>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="info-box mb-2 bg-light shadow-sm">
              <span class="info-box-icon text-bg-primary"><i class="fas fa-cogs"></i></span>
              <div class="info-box-content">
                <span class="info-box-text">Services Running</span>
                <span class="info-box-number"><span id="services-running">0</span>/<span id="services-total">0</span> running</span>
              </div>
            </div>
          </div>
        </div>
        <div class="table-responsive health-table mb-3">
          <table class="table table-sm">
            <caption class="visually-hidden">Mail security and relay configuration health checks</caption>
            <thead><tr><th>Check</th><th>Category</th><th>Status</th></tr></thead>
            <tbody id="health-checks-body" role="status" aria-live="polite" aria-atomic="true">
              <tr><td colspan="3" class="text-muted">Loading...</td></tr>
            </tbody>
          </table>
        </div>
        <div class="table-responsive health-table">
          <table class="table table-sm mb-0">
            <caption class="visually-hidden">Core mail service runtime status</caption>
            <thead><tr><th>Service</th><th>Status</th></tr></thead>
            <tbody id="service-status-body" role="status" aria-live="polite" aria-atomic="true">
              <tr><td colspan="2" class="text-muted">Loading...</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Quick Access -->
<div class="card card-outline card-primary shadow-sm mb-4 dashboard-card quick-access-card">
  <div class="card-header bg-body-secondary">
    <h3 class="card-title">
      <i class="fas fa-th-large"></i>
      Quick Access
    </h3>
  </div>
  <div class="card-body">
    <div class="quick-access-grid">
      <a href="view_message_history.cfm" class="quick-access-item"><i class="fas fa-history"></i><span>Message History</span></a>
      <a href="view_mail_queue.cfm" class="quick-access-item"><i class="fas fa-stream"></i><span>Mail Queue</span></a>
      <a href="view_perimeter_checks.cfm" class="quick-access-item"><i class="fas fa-shield-alt"></i><span>Perimeter Checks</span></a>
      <a href="view_relay_networks.cfm" class="quick-access-item"><i class="fas fa-network-wired"></i><span>Relay Networks</span></a>
      <a href="view_system_logs.cfm" class="quick-access-item"><i class="fas fa-file-alt"></i><span>System Logs</span></a>
      <a href="view_system_updates.cfm" class="quick-access-item"><i class="fas fa-download"></i><span>System Updates</span></a>
    </div>
  </div>
</div>

</div><!-- /.dashboard-grid -->

        </div><!-- /.hermes-dashboard -->

      <!-- /.container-fluid -->
    </div>
    <!-- /.content -->
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
      // Tag format is vYYMMDD (e.g. v260119) -- the GitHub release tag is
      // the build number itself, no `build-` prefix. Pre-#218 code added
      // a `build-` prefix that doesn't match the canonical tag scheme.
      var githubReleaseUrl = 'https://github.com/deeztek/Hermes-Secure-Email-Gateway/releases/tag/' + buildNumber;
      var githubApiUrl = 'https://api.github.com/repos/deeztek/Hermes-Secure-Email-Gateway/releases/tags/' + buildNumber;

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
          updateProgressRing('ring-archive', data.archiveUsage, '#' + data.archiveUsageColor);
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
  var topTrafficLoaded = false;

  function renderTopTrafficTable(bodyId, rows) {
    var body = document.getElementById(bodyId);
    if (!body) return;

    if (!rows.length) {
      body.innerHTML = '<tr><td colspan="2" class="text-muted">No data in selected period</td></tr>';
      return;
    }

    body.innerHTML = rows.map(function(item) {
      var email = (item.email || '(unknown)').toString()
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
      var count = Number(item.count || 0).toLocaleString();
      return '<tr><td style="word-break: break-all;">' + email + '</td><td class="text-end">' + count + '</td></tr>';
    }).join('');
  }

  // Function to fetch and update message statistics
  function refreshMessageStats(period, includeTop) {
    if (period) currentPeriod = period;
    var shouldIncludeTop = includeTop ? '1' : '0';

    fetch('/admin/2/api/get_message_stats.cfm?period=' + currentPeriod + '&includeTop=' + shouldIncludeTop + '&_=' + Date.now())
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
          document.getElementById('traffic-incoming').textContent = (data.incoming || 0).toLocaleString();
          document.getElementById('traffic-outgoing').textContent = (data.outgoing || 0).toLocaleString();

          var avgProcessing = document.getElementById('avg-processing-time');
          var avgProcessingNote = document.getElementById('avg-processing-note');
          if (avgProcessing) {
            if (data.processingTimeAvailable && data.averageProcessingTimeMs !== undefined) {
              avgProcessing.textContent = data.averageProcessingTimeMs.toLocaleString() + ' ms';
            } else {
              avgProcessing.textContent = 'Not available';
            }
          }
          if (avgProcessingNote) {
            avgProcessingNote.textContent = data.processingTimeNote || '';
          }

          if (data.includeTop || !topTrafficLoaded) {
            renderTopTrafficTable('top-senders-body', data.topSenders || []);
            renderTopTrafficTable('top-recipients-body', data.topRecipients || []);
            topTrafficLoaded = true;
          }

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
        refreshMessageStats(this.value, true);
      });
    }

    // Initial load of message stats immediately
    refreshMessageStats(currentPeriod, true);

    // Auto-refresh message stats every 60 seconds
    if (window.messageStatsRefreshInterval) {
      clearInterval(window.messageStatsRefreshInterval);
    }
    window.messageStatsRefreshInterval = setInterval(function() { refreshMessageStats(currentPeriod, false); }, 60000);
  }

  // Wait for DOM to be ready before initializing
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMessageStats);
  } else {
    initMessageStats();
  }
})();
</script>

<!-- Dashboard Health Script (Vanilla JS) -->
<script>
(function() {
  function statusBadge(statusText, successValues) {
    var normalized = (statusText || '').toString().toLowerCase();
    var ok = successValues.indexOf(normalized) !== -1;
    return ok
      ? '<span class="fw-semibold">Pass</span> <span class="badge text-bg-success">OK</span>'
      : '<span class="fw-semibold">Fail</span> <span class="badge text-bg-danger">Needs Attention</span>';
  }

  function serviceBadge(statusText) {
    var normalized = (statusText || '').toString().toLowerCase();
    if (normalized === 'running') {
      return '<span class="fw-semibold">Running</span> <span class="badge text-bg-success">Running</span>';
    }
    if (normalized === 'stopped') {
      return '<span class="fw-semibold">Stopped</span> <span class="badge text-bg-danger">Stopped</span>';
    }
    return '<span class="fw-semibold">Unknown</span> <span class="badge text-bg-secondary">Unknown</span>';
  }

  function setHealthSummaryCounts(checkPass, checkTotal, serviceRunning, serviceTotal) {
    document.getElementById('health-check-pass').textContent = checkPass;
    document.getElementById('health-check-total').textContent = checkTotal;
    document.getElementById('services-running').textContent = serviceRunning;
    document.getElementById('services-total').textContent = serviceTotal;
  }

  function refreshDashboardHealth() {
    fetch('/admin/2/api/get_dashboard_health.cfm', { cache: 'no-store' })
      .then(function(response) {
        var contentType = (response.headers.get('content-type') || '').toLowerCase();
        if (contentType.indexOf('application/json') === -1) {
          return { success: false, error: 'Session expired or unauthorized' };
        }

        return response.json()
          .catch(function() { return { success: false, error: 'Unable to load health status' }; })
          .then(function(data) {
            if (!response.ok) {
              data.success = false;
              if (response.status === 401 || response.status === 403) {
                data.error = 'Access denied for health status';
              } else if (!data.error) {
                data.error = 'Unable to load health status';
              }
            }
            return data;
          });
      })
      .then(function(data) {
        if (!data.success) {
          var errorMessage = (data.error || 'Unable to load health status').toString()
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
          var checksBodyOnError = document.getElementById('health-checks-body');
          var servicesBodyOnError = document.getElementById('service-status-body');
          if (checksBodyOnError) {
            checksBodyOnError.innerHTML = '<tr><td colspan="3" class="text-danger">' + errorMessage + '</td></tr>';
          }
          if (servicesBodyOnError) {
            servicesBodyOnError.innerHTML = '<tr><td colspan="2" class="text-danger">' + errorMessage + '</td></tr>';
          }
          setHealthSummaryCounts('0', '0', '0', '0');
          return;
        }

        setHealthSummaryCounts(
          data.summary.checkPass || 0,
          data.summary.checkTotal || 0,
          data.summary.serviceRunning || 0,
          data.summary.serviceTotal || 0
        );

        var checksBody = document.getElementById('health-checks-body');
        if (checksBody) {
          var checks = data.checks || [];
          if (!checks.length) {
            checksBody.innerHTML = '<tr><td colspan="3" class="text-muted">No checks available</td></tr>';
          } else {
            checksBody.innerHTML = checks.map(function(item) {
              var checkName = (item.name || '').toString()
                .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
              var category = (item.category || '').toString()
                .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
              return '<tr><td>' + checkName + '</td><td>' + category + '</td><td>' + statusBadge(item.status ? 'ok' : 'bad', ['ok']) + '</td></tr>';
            }).join('');
          }
        }

        var servicesBody = document.getElementById('service-status-body');
        if (servicesBody) {
          var services = data.services || [];
          if (!services.length) {
            servicesBody.innerHTML = '<tr><td colspan="2" class="text-muted">No services available</td></tr>';
          } else {
            servicesBody.innerHTML = services.map(function(item) {
              var serviceName = (item.name || item.service || '').toString()
                .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
              return '<tr><td>' + serviceName + '</td><td>' + serviceBadge(item.status) + '</td></tr>';
            }).join('');
          }
        }
      })
      .catch(function(error) {
        var checksBodyOnCatch = document.getElementById('health-checks-body');
        var servicesBodyOnCatch = document.getElementById('service-status-body');
        var errorMessage = 'Unable to load health status';
        if (checksBodyOnCatch) {
          checksBodyOnCatch.innerHTML = '<tr><td colspan="3" class="text-danger">' + errorMessage + '</td></tr>';
        }
        if (servicesBodyOnCatch) {
          servicesBodyOnCatch.innerHTML = '<tr><td colspan="2" class="text-danger">' + errorMessage + '</td></tr>';
        }
        setHealthSummaryCounts('0', '0', '0', '0');
        console.error('Error fetching dashboard health:', error);
      });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', refreshDashboardHealth);
  } else {
    refreshDashboardHealth();
  }

  if (window.dashboardHealthInterval) {
    clearInterval(window.dashboardHealthInterval);
  }
  window.dashboardHealthInterval = setInterval(refreshDashboardHealth, 60000);
})();
</script>

<!-- ./wrapper -->


</body>







</html>
