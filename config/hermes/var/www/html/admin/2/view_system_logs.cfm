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
  <title>Hermes SEG | System Logs</title>
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
            <h1 class="m-0">System Logs</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Logs</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION: Set Log Retention --->
<cfif action is "save_retention">
  <cfif StructKeyExists(form, "logretention") AND isValid("integer", form.logretention)>
    <cfquery datasource="hermes">
      UPDATE parameters2 SET value2 = <cfqueryparam value="#form.logretention#" cfsqltype="cf_sql_integer">
      WHERE parameter = 'system_log_retention' AND module = 'systemlog'
    </cfquery>
    <cfset session.m = 1>
  </cfif>
  <cflocation url="view_system_logs.cfm" addtoken="no">
</cfif>

<!--- Default date range: last 24 hours --->
<cfset defaultenddate = DateFormat(Now(), "yyyy-mm-dd") & " 23:59:59">
<cfset defaultstartdate = DateFormat(DateAdd("h", -24, Now()), "yyyy-mm-dd") & " 00:00:00">

<!--- Read URL parameters with validation --->
<cfparam name="url.startdate" default="#defaultstartdate#">
<cfparam name="url.enddate" default="#defaultenddate#">
<cfparam name="url.limit" default="1000">
<cfparam name="url.facility" default="">

<cfset startdate = url.startdate>
<cfset enddate = url.enddate>
<cfset limit = url.limit>
<cfset facility = url.facility>

<!--- Validate dates --->
<cfif NOT isValid("date", startdate)><cfset startdate = defaultstartdate></cfif>
<cfif NOT isValid("date", enddate)><cfset enddate = defaultenddate></cfif>

<!--- Validate limit --->
<cfset validLimits = "1000,1500,2500,5000,10000,15000">
<cfif NOT ListFindNoCase(validLimits, limit)><cfset limit = 1000></cfif>

<!--- Get distinct facilities for filter dropdown --->
<cfquery name="getFacilities" datasource="syslog">
  SELECT DISTINCT SUBSTRING_INDEX(SysLogTag, '[', 1) AS facility
  FROM SystemEvents
  WHERE ReceivedAt BETWEEN <cfqueryparam value="#startdate#" cfsqltype="cf_sql_timestamp">
    AND <cfqueryparam value="#enddate#" cfsqltype="cf_sql_timestamp">
  ORDER BY facility ASC
</cfquery>

<!--- Get logs with optional facility filter --->
<cfquery name="getlogs" datasource="syslog">
  SELECT ReceivedAt, Message, SysLogTag FROM SystemEvents
  WHERE ReceivedAt BETWEEN <cfqueryparam value="#startdate#" cfsqltype="cf_sql_timestamp">
    AND <cfqueryparam value="#enddate#" cfsqltype="cf_sql_timestamp">
  <cfif facility is not "">
    AND SysLogTag LIKE <cfqueryparam value="#facility#%" cfsqltype="cf_sql_varchar">
  </cfif>
  ORDER BY ReceivedAt DESC
  LIMIT <cfqueryparam value="#limit#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Get log retention setting --->
<cfquery name="getlogretention" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'system_log_retention' AND module = 'systemlog'
</cfquery>
<cfset logretention = getlogretention.value2>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Log retention saved successfully.
  </div>
</cfif>

<!-- LOG RETENTION CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-cog"></i> Log Retention</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_retention">
      <div class="row">
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Retention Period</strong></label>
            <select class="form-select" name="logretention">
              <cfloop list="7,15,30,60,90,120,180" index="d">
                <cfoutput><option value="#d#" <cfif logretention is d>selected</cfif>>#d# Days</option></cfoutput>
              </cfloop>
            </select>
          </div>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
            <i class="fas fa-save"></i> Save
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- LOG VIEWER CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-file-alt"></i> System Logs</h3>
  </div>
  <div class="card-body">

    <!-- FILTER FORM -->
    <form method="get" autocomplete="off" class="mb-4">
      <div class="row">
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Start Date/Time</strong></label>
            <div class="input-group" id="startdatetime" data-td-target-input="nearest" data-td-target-toggle="nearest">
              <cfoutput>
              <input type="text" name="startdate" value="#startdate#" class="form-control" data-td-target="##startdatetime"/>
              </cfoutput>
              <span class="input-group-text" data-td-target="#startdatetime" data-td-toggle="datetimepicker">
                <i class="fa fa-calendar"></i>
              </span>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>End Date/Time</strong></label>
            <div class="input-group" id="enddatetime" data-td-target-input="nearest" data-td-target-toggle="nearest">
              <cfoutput>
              <input type="text" name="enddate" value="#enddate#" class="form-control" data-td-target="##enddatetime"/>
              </cfoutput>
              <span class="input-group-text" data-td-target="#enddatetime" data-td-toggle="datetimepicker">
                <i class="fa fa-calendar"></i>
              </span>
            </div>
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Facility</strong></label>
            <select class="form-select" name="facility">
              <option value="">All Facilities</option>
              <cfoutput query="getFacilities">
                <cfif facility is not "">
                  <option value="#encodeForHTMLAttribute(getFacilities.facility)#" <cfif url.facility is getFacilities.facility>selected</cfif>>#encodeForHTML(getFacilities.facility)#</option>
                </cfif>
              </cfoutput>
            </select>
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Limit</strong></label>
            <select class="form-select" name="limit">
              <cfloop list="1000,1500,2500,5000,10000,15000" index="l">
                <cfoutput><option value="#l#" <cfif limit is l>selected</cfif>>#l#</option></cfoutput>
              </cfloop>
            </select>
          </div>
        </div>
        <div class="col-md-2 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Fetching...';this.form.submit();">
            <i class="fas fa-search"></i> Fetch Logs
          </button>
        </div>
      </div>
      <cfif limit GTE 10000>
        <div class="callout callout-warning mb-0">
          <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> High result limits (10000+) will significantly increase page loading time.</p>
        </div>
      </cfif>
    </form>

    <!-- LOGS TABLE -->
    <cfif getlogs.recordcount GTE 1>
      <table id="logsTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th>Date/Time</th>
            <th>Message</th>
            <th>Facility</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getlogs">
            <tr>
              <td>#DateFormat(ReceivedAt, "mm/dd/yyyy")# #TimeFormat(ReceivedAt, "HH:mm:ss")#</td>
              <td>#encodeForHTML(Message)#</td>
              <td><span class="badge bg-secondary">#encodeForHTML(SysLogTag)#</span></td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    <cfelse>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No logs found for the selected date range and filter.
      </div>
    </cfif>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
$(document).ready(function() {
  $('#logsTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[50, 75, 100, -1], ['50 rows', '75 rows', '100 rows', 'Show all']],
    order: [[0, 'desc']],
    columnDefs: [
      { width: '180px', targets: [0] },
      { width: '120px', targets: [2] }
    ]
  });
});

// Tempus Dominus datetime pickers
document.addEventListener('DOMContentLoaded', function() {
  var pickerOptions = {
    display: {
      sideBySide: true,
      components: { clock: true, seconds: true }
    },
    localization: {
      format: 'yyyy-MM-dd HH:mm:ss',
      dayViewHeaderFormat: { month: 'long', year: 'numeric' }
    }
  };

  new tempusDominus.TempusDominus(document.getElementById('startdatetime'), pickerOptions);
  new tempusDominus.TempusDominus(document.getElementById('enddatetime'), pickerOptions);
});
</script>

</body>
</html>
