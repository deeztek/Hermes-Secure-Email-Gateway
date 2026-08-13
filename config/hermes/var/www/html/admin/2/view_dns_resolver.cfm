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
  <title>Hermes SEG | System - DNS Resolver</title>
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
            <h1 class="m-0">System - DNS Resolver</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">System</li>
              <li class="breadcrumb-item active">DNS Resolver</li>
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
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLER --->
<cfif ListFindNoCase("save_forwarding,add_forwarder,delete_forwarder,toggle_forwarder,apply_forwarders,add_local_record,delete_local_record,toggle_local_record,apply_local_records,restart_unbound,flush_cache", action)>
  <cfinclude template="./inc/dns_resolver_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    DNS forwarding settings saved and Unbound restarted.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Unbound DNS resolver restarted.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    DNS cache flushed.
  </div>
<cfelseif m EQ 4>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Forwarder added. Click <strong>Apply &amp; Restart Unbound</strong> to activate.
  </div>
<cfelseif m EQ 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Forwarder deleted. Click <strong>Apply &amp; Restart Unbound</strong> to activate.
  </div>
<cfelseif m EQ 6>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Forwarder status updated. Click <strong>Apply &amp; Restart Unbound</strong> to activate.
  </div>
<cfelseif m EQ 7>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Local DNS record added. Click <strong>Apply &amp; Restart Unbound</strong> to activate.
  </div>
<cfelseif m EQ 8>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Local DNS record deleted. Click <strong>Apply &amp; Restart Unbound</strong> to activate.
  </div>
<cfelseif m EQ 9>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Local DNS record status updated. Click <strong>Apply &amp; Restart Unbound</strong> to activate.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <cfif StructKeyExists(session, "dnsError") AND session.dnsError NEQ "">
      <cfoutput>#encodeForHTML(session.dnsError)#</cfoutput>
      <cfset session.dnsError = "">
    <cfelse>
      An error occurred while processing your request.
    </cfif>
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <cfif StructKeyExists(session, "dnsError") AND session.dnsError NEQ "">
      <cfoutput>#encodeForHTML(session.dnsError)#</cfoutput>
      <cfset session.dnsError = "">
    <cfelse>
      Invalid input.
    </cfif>
  </div>
</cfif>

<!--- ================================================================== --->
<!--- GATHER CONTAINER STATUS                                             --->
<!--- ================================================================== --->
<cfset containerRunning = false>
<cfset containerStatus = "unknown">
<cfset containerUptime = "">

<cftry>
  <cfinclude template="./inc/generate_customtrans.cfm">
  <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker inspect --format='" & chr(123) & chr(123) & ".State.Status" & chr(125) & chr(125) & "|" & chr(123) & chr(123) & ".State.StartedAt" & chr(125) & chr(125) & "' hermes_unbound 2>&1">
  <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_dns_status.sh">
  <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
  <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />
  <cfexecute name="#scriptPath#" variable="inspectResult" timeout="10" />
  <cffile action="delete" file="#scriptPath#">

  <cfset inspectResult = trim(inspectResult)>
  <cfif ListLen(inspectResult, "|") GTE 2>
    <cfset containerStatus = ListFirst(inspectResult, "|")>
    <cfset startedAt = ListGetAt(inspectResult, 2, "|")>
    <cfif containerStatus EQ "running">
      <cfset containerRunning = true>
      <!--- Calculate uptime from startedAt (ISO 8601 UTC) --->
      <cftry>
        <cfset startedAt = Replace(startedAt, "T", " ")>
        <cfset startedAt = Left(startedAt, 19)>
        <cfset startDate = ParseDateTime(startedAt)>
        <cfset nowUTC = DateConvert("local2utc", Now())>
        <cfset uptimeSeconds = DateDiff("s", startDate, nowUTC)>
        <cfset uptimeDays = Int(uptimeSeconds / 86400)>
        <cfset uptimeHours = Int((uptimeSeconds MOD 86400) / 3600)>
        <cfset uptimeMins = Int((uptimeSeconds MOD 3600) / 60)>
        <cfif uptimeDays GT 0>
          <cfset containerUptime = "#uptimeDays#d #uptimeHours#h #uptimeMins#m">
        <cfelseif uptimeHours GT 0>
          <cfset containerUptime = "#uptimeHours#h #uptimeMins#m">
        <cfelse>
          <cfset containerUptime = "#uptimeMins#m">
        </cfif>
      <cfcatch>
        <cfset containerUptime = "N/A">
      </cfcatch>
      </cftry>
    </cfif>
  </cfif>
<cfcatch>
  <cfset containerStatus = "error">
</cfcatch>
</cftry>

<!--- ================================================================== --->
<!--- READ SETTINGS FROM DATABASE                                         --->
<!--- ================================================================== --->
<cfquery name="getForwardingEnabled" datasource="hermes">
    SELECT value2 FROM parameters2 WHERE module = 'unbound' AND parameter = 'forwarding.enabled'
</cfquery>
<cfset forwardingEnabled = false>
<cfif getForwardingEnabled.recordcount GTE 1 AND getForwardingEnabled.value2 EQ "yes">
    <cfset forwardingEnabled = true>
</cfif>

<cfquery name="getForwarders" datasource="hermes">
    SELECT id, server, port, tls, enabled, sort_order FROM dns_forwarders ORDER BY sort_order ASC
</cfquery>

<!--- ================================================================== --->
<!--- READ DNSSEC STATUS                                                  --->
<!--- ================================================================== --->
<cfset dnssecEnabled = false>
<cfset dnssecStatus = "Unknown">

<cfif containerRunning>
  <cftry>
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_unbound cat /etc/unbound/unbound.conf 2>&1">
    <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_dns_sec.sh">
    <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
    <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />
    <cfexecute name="#scriptPath#" variable="unboundConf" timeout="10" />
    <cffile action="delete" file="#scriptPath#">

    <cfloop list="#unboundConf#" delimiters="#chr(10)#" index="line">
      <cfset line = trim(line)>
      <cfif FindNoCase("auto-trust-anchor-file:", line) OR FindNoCase("trust-anchor-file:", line)>
        <cfset dnssecEnabled = true>
      </cfif>
      <!--- Check if module-config contains validator --->
      <cfif FindNoCase("module-config:", line) AND FindNoCase("validator", line)>
        <cfset dnssecEnabled = true>
      </cfif>
    </cfloop>

    <cfif dnssecEnabled>
      <cfset dnssecStatus = "Enabled">
    <cfelse>
      <cfset dnssecStatus = "Disabled">
    </cfif>

  <cfcatch>
    <cfset dnssecStatus = "Unknown">
  </cfcatch>
  </cftry>
</cfif>

<!--- ================================================================== --->
<!--- READ CACHE STATISTICS                                               --->
<!--- ================================================================== --->
<cfset cacheStats = StructNew()>
<cfset cacheStatsRaw = "">
<cfset cacheStatsAvailable = false>

<cfif containerRunning>
  <cftry>
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_unbound unbound-control stats_noreset 2>&1">
    <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_dns_stats.sh">
    <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
    <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />
    <cfexecute name="#scriptPath#" variable="statsOutput" timeout="10" />
    <cffile action="delete" file="#scriptPath#">

    <!--- Parse key stats --->
    <cfloop list="#statsOutput#" delimiters="#chr(10)#" index="line">
      <cfset line = trim(line)>
      <cfif line contains "=">
        <cfset sKey = trim(ListFirst(line, "="))>
        <cfset sVal = trim(ListRest(line, "="))>
        <cfset cacheStats[sKey] = sVal>
      </cfif>
    </cfloop>

    <!--- Check if we got meaningful stats --->
    <cfif StructKeyExists(cacheStats, "total.num.queries")>
      <cfset cacheStatsAvailable = true>
    </cfif>

  <cfcatch>
    <!--- unbound-control may not be available --->
  </cfcatch>
  </cftry>
</cfif>

<!--- ================================================================== --->
<!--- CARD 1: DNS RESOLVER STATUS                                         --->
<!--- ================================================================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-server"></i> DNS Resolver Status</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Container Status</strong></label>
          <div class="form-control-plaintext">
            <cfif containerRunning>
              <span class="badge bg-success"><i class="fas fa-check-circle"></i> Running</span>
            <cfelseif containerStatus EQ "exited">
              <span class="badge bg-danger"><i class="fas fa-times-circle"></i> Stopped</span>
            <cfelse>
              <cfoutput><span class="badge bg-warning"><i class="fas fa-question-circle"></i> #encodeForHTML(containerStatus)#</span></cfoutput>
            </cfif>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Uptime</strong></label>
          <div class="form-control-plaintext">
            <cfif containerRunning AND containerUptime NEQ "">
              <cfoutput>#encodeForHTML(containerUptime)#</cfoutput>
            <cfelse>
              <span class="text-muted">N/A</span>
            </cfif>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Actions</strong></label>
          <div>
            <form method="post" action="view_dns_resolver.cfm" style="display:inline;">
              <input type="hidden" name="action" value="restart_unbound">
              <button type="submit" class="btn btn-warning btn-sm" onclick="return confirm('Restart Unbound DNS resolver?');">
                <i class="fas fa-sync-alt"></i> Restart Unbound
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!--- ================================================================== --->
<!--- CARD 2: UPSTREAM FORWARDERS                                         --->
<!--- ================================================================== --->
<!-- FORWARDING MODE -->
<form method="post" action="view_dns_resolver.cfm">
<input type="hidden" name="action" value="save_forwarding">
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-project-diagram"></i> DNS Forwarding</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-info">
      <p class="mb-1"><i class="icon fas fa-info-circle"></i> <strong>Recursive resolution</strong> (default) queries authoritative DNS servers directly. Recommended for email servers.</p>
      <p class="mb-0"><i class="icon fas fa-exclamation-triangle text-warning"></i> <strong>Warning:</strong> Enabling forwarding can cause RBL/DNSBL lookup failures. When queries are forwarded through public resolvers (Cloudflare, Google, etc.), your blocklist lookups originate from their shared IP addresses. RBL providers throttle or block these IPs because thousands of other customers are making the same queries from the same resolvers. With recursive resolution, queries come from your server's own IP, keeping you well under rate limits.</p>
    </div>
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>DNS Resolution Mode</strong></label>
          <select class="form-select" name="forwarding_enabled">
            <option value="no" <cfif NOT forwardingEnabled>selected</cfif>>Recursive (recommended for email servers)</option>
            <option value="yes" <cfif forwardingEnabled>selected</cfif>>Forward to upstream resolvers</option>
          </select>
        </div>
      </div>
    </div>
  </div>
  <div class="card-footer">
    <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Save &amp; Apply</button>
  </div>
</div>
</form>

<!-- FORWARDERS TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired"></i> Upstream Forwarders (<cfoutput>#getForwarders.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <cfif NOT forwardingEnabled>
      <div class="alert alert-secondary mb-3">
        <i class="fas fa-info-circle"></i> Forwarding is currently <strong>disabled</strong>. Forwarders below will be used when forwarding is enabled.
      </div>
    </cfif>

    <!-- ADD FORWARDER -->
    <form method="post" action="view_dns_resolver.cfm" class="row g-3 align-items-end mb-3">
      <input type="hidden" name="action" value="add_forwarder">
      <div class="col-md-4">
        <label class="form-label"><strong>Server IP</strong></label>
        <input type="text" class="form-control" name="new_server" placeholder="e.g., 1.1.1.1" required pattern="(\d{1,3}\.){3}\d{1,3}">
      </div>
      <div class="col-md-2">
        <label class="form-label"><strong>Port</strong></label>
        <input type="number" class="form-control" name="new_port" value="853" min="1" max="65535">
      </div>
      <div class="col-md-2">
        <label class="form-label"><strong>TLS</strong></label>
        <select class="form-select" name="new_tls">
          <option value="0" selected>No</option>
          <option value="1">Yes</option>
        </select>
      </div>
      <div class="col-md-2">
        <button type="submit" class="btn btn-primary"><i class="fa fa-plus"></i> Add</button>
      </div>
    </form>

    <!-- FORWARDERS LIST -->
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>Server</th>
          <th>Port</th>
          <th>TLS</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getForwarders">
        <tr<cfif enabled NEQ 1> class="table-secondary"</cfif>>
          <td><code>#encodeForHTML(getForwarders.server)#</code></td>
          <td>#port#</td>
          <td>
            <cfif tls EQ 1>
              <span class="badge bg-success">Yes</span>
            <cfelse>
              <span class="badge bg-secondary">No</span>
            </cfif>
          </td>
          <td>
            <cfif enabled EQ 1>
              <span class="badge bg-success">Enabled</span>
            <cfelse>
              <span class="badge bg-secondary">Disabled</span>
            </cfif>
          </td>
          <td>
            <form method="post" action="view_dns_resolver.cfm" style="display:inline;">
              <input type="hidden" name="action" value="toggle_forwarder">
              <input type="hidden" name="forwarder_id" value="#id#">
              <button type="submit" class="btn btn-sm btn-<cfif enabled EQ 1>warning<cfelse>success</cfif>" title="<cfif enabled EQ 1>Disable<cfelse>Enable</cfif>">
                <i class="fas fa-<cfif enabled EQ 1>pause<cfelse>play</cfif>"></i>
              </button>
            </form>
            <form method="post" action="view_dns_resolver.cfm" style="display:inline;" onsubmit="return confirm('Delete forwarder #encodeForJavaScript(getForwarders.server)#?');">
              <input type="hidden" name="action" value="delete_forwarder">
              <input type="hidden" name="forwarder_id" value="#id#">
              <button type="submit" class="btn btn-sm btn-danger" title="Delete">
                <i class="fas fa-trash"></i>
              </button>
            </form>
          </td>
        </tr>
        </cfoutput>
        <cfif getForwarders.recordcount EQ 0>
          <tr><td colspan="5" class="text-center text-muted">No forwarders configured.</td></tr>
        </cfif>
      </tbody>
    </table>
  </div>
  <div class="card-footer">
    <form method="post" action="view_dns_resolver.cfm" style="display:inline;">
      <input type="hidden" name="action" value="apply_forwarders">
      <button type="submit" class="btn btn-warning"><i class="fas fa-sync"></i> Apply &amp; Restart Unbound</button>
    </form>
  </div>
</div>

<!--- ================================================================== --->
<!--- CARD: LOCAL DNS OVERRIDES                                            --->
<!--- ================================================================== --->
<cfquery name="getLocalRecords" datasource="hermes">
    SELECT id, hostname, record_type, value, enabled, description
    FROM dns_local_records ORDER BY hostname ASC
</cfquery>

<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-map-marker-alt"></i> Local DNS Overrides (<cfoutput>#getLocalRecords.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-info">
      <p class="mb-0"><i class="icon fas fa-info-circle"></i> Add static DNS entries that Unbound resolves locally instead of querying upstream. Useful for internal hosts, split-horizon DNS, or overriding public DNS for internal routing.</p>
    </div>

    <!-- ADD LOCAL RECORD -->
    <form method="post" action="view_dns_resolver.cfm" class="row g-3 align-items-end mb-3">
      <input type="hidden" name="action" value="add_local_record">
      <div class="col-md-3">
        <label class="form-label"><strong>Hostname</strong></label>
        <input type="text" class="form-control" name="local_hostname" placeholder="e.g., mail.example.com" required>
      </div>
      <div class="col-md-2">
        <label class="form-label"><strong>Type</strong></label>
        <select class="form-select" name="local_type">
          <option value="A" selected>A</option>
          <option value="AAAA">AAAA</option>
          <option value="CNAME">CNAME</option>
          <option value="MX">MX</option>
          <option value="TXT">TXT</option>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label"><strong>Value</strong></label>
        <input type="text" class="form-control" name="local_value" placeholder="e.g., 10.0.0.50" required>
      </div>
      <div class="col-md-2">
        <label class="form-label"><strong>Description</strong></label>
        <input type="text" class="form-control" name="local_description" placeholder="optional">
      </div>
      <div class="col-md-2">
        <button type="submit" class="btn btn-primary"><i class="fa fa-plus"></i> Add</button>
      </div>
    </form>

    <!-- LOCAL RECORDS TABLE -->
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>Hostname</th>
          <th>Type</th>
          <th>Value</th>
          <th>Description</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getLocalRecords">
        <tr<cfif enabled NEQ 1> class="table-secondary"</cfif>>
          <td><code>#encodeForHTML(hostname)#</code></td>
          <td><span class="badge bg-secondary">#encodeForHTML(record_type)#</span></td>
          <td><code>#encodeForHTML(value)#</code></td>
          <td class="text-muted small">#encodeForHTML(description)#</td>
          <td>
            <cfif enabled EQ 1>
              <span class="badge bg-success">Enabled</span>
            <cfelse>
              <span class="badge bg-secondary">Disabled</span>
            </cfif>
          </td>
          <td>
            <form method="post" action="view_dns_resolver.cfm" style="display:inline;">
              <input type="hidden" name="action" value="toggle_local_record">
              <input type="hidden" name="local_record_id" value="#id#">
              <button type="submit" class="btn btn-sm btn-<cfif enabled EQ 1>warning<cfelse>success</cfif>" title="<cfif enabled EQ 1>Disable<cfelse>Enable</cfif>">
                <i class="fas fa-<cfif enabled EQ 1>pause<cfelse>play</cfif>"></i>
              </button>
            </form>
            <form method="post" action="view_dns_resolver.cfm" style="display:inline;" onsubmit="return confirm('Delete record #encodeForJavaScript(hostname)#?');">
              <input type="hidden" name="action" value="delete_local_record">
              <input type="hidden" name="local_record_id" value="#id#">
              <button type="submit" class="btn btn-sm btn-danger" title="Delete">
                <i class="fas fa-trash"></i>
              </button>
            </form>
          </td>
        </tr>
        </cfoutput>
        <cfif getLocalRecords.recordcount EQ 0>
          <tr><td colspan="6" class="text-center text-muted">No local DNS overrides configured.</td></tr>
        </cfif>
      </tbody>
    </table>
  </div>
  <div class="card-footer">
    <form method="post" action="view_dns_resolver.cfm" style="display:inline;">
      <input type="hidden" name="action" value="apply_local_records">
      <button type="submit" class="btn btn-warning"><i class="fas fa-sync"></i> Apply &amp; Restart Unbound</button>
    </form>
  </div>
</div>

<!--- ================================================================== --->
<!--- CARD 3: DNSSEC                                                      --->
<!--- ================================================================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> DNSSEC</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>DNSSEC Validation</strong></label>
          <div class="form-control-plaintext">
            <cfif dnssecEnabled>
              <span class="badge bg-success"><i class="fas fa-check-circle"></i> Enabled</span>
            <cfelse>
              <span class="badge bg-secondary"><i class="fas fa-minus-circle"></i> <cfoutput>#encodeForHTML(dnssecStatus)#</cfoutput></span>
            </cfif>
          </div>
          <small class="form-text text-muted">DNSSEC validates the authenticity of DNS responses, protecting against DNS spoofing and cache poisoning. This is managed in the Unbound server configuration.</small>
        </div>
      </div>
      <div class="col-md-8">
        <div class="mb-3">
          <label class="form-label"><strong>Test DNSSEC Validation</strong></label>
          <form method="post" action="view_dns_resolver.cfm">
            <input type="hidden" name="dnssec_test" value="1">
            <button type="submit" class="btn btn-info btn-sm">
              <i class="fas fa-vial"></i> Test DNSSEC
            </button>
          </form>
        </div>

        <!--- Show DNSSEC test results if requested --->
        <cfif StructKeyExists(form, "dnssec_test") AND form.dnssec_test EQ "1" AND containerRunning>
          <cftry>
            <cfinclude template="./inc/generate_customtrans.cfm">
            <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_unbound drill -D example.com 2>&1">
            <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_dnssec_test.sh">
            <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
            <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />
            <cfexecute name="#scriptPath#" variable="dnssecTestResult" timeout="15" />
            <cffile action="delete" file="#scriptPath#">

            <div class="mt-2">
              <pre class="bg-dark text-light p-3 rounded" style="max-height: 300px; overflow-y: auto; font-size: 0.85em;"><cfoutput>#encodeForHTML(trim(dnssecTestResult))#</cfoutput></pre>
            </div>

          <cfcatch>
            <div class="alert alert-danger mt-2">
              <cfoutput>DNSSEC test failed: #encodeForHTML(cfcatch.message)#</cfoutput>
            </div>
          </cfcatch>
          </cftry>
        </cfif>

      </div>
    </div>
  </div>
</div>

<!--- ================================================================== --->
<!--- CARD 4: CACHE STATISTICS                                            --->
<!--- ================================================================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-chart-bar"></i> Cache Statistics</h3>
  </div>
  <div class="card-body">

    <cfif cacheStatsAvailable>
      <div class="row">
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Total Queries</strong></label>
            <div class="form-control-plaintext">
              <cfoutput><code>#encodeForHTML(cacheStats['total.num.queries'])#</code></cfoutput>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Cache Hits</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "total.num.cachehits")>
                <cfoutput><code>#encodeForHTML(cacheStats['total.num.cachehits'])#</code></cfoutput>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Cache Misses</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "total.num.cachemiss")>
                <cfoutput><code>#encodeForHTML(cacheStats['total.num.cachemiss'])#</code></cfoutput>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Prefetch</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "total.num.prefetch")>
                <cfoutput><code>#encodeForHTML(cacheStats['total.num.prefetch'])#</code></cfoutput>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>RRset Cache</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "rrset.cache.count")>
                <cfoutput><code>#encodeForHTML(cacheStats['rrset.cache.count'])#</code> entries</cfoutput>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Message Cache</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "msg.cache.count")>
                <cfoutput><code>#encodeForHTML(cacheStats['msg.cache.count'])#</code> entries</cfoutput>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Avg Recursion Time</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "total.recursion.time.avg")>
                <cfoutput><code>#encodeForHTML(cacheStats['total.recursion.time.avg'])#</code> sec</cfoutput>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Num Threads</strong></label>
            <div class="form-control-plaintext">
              <cfif StructKeyExists(cacheStats, "num.query.flags.QR")>
                <cfoutput><code>#encodeForHTML(cacheStats['num.query.flags.QR'])#</code></cfoutput>
              <cfelseif StructKeyExists(cacheStats, "thread0.num.queries")>
                <code>Available</code>
              <cfelse>
                <span class="text-muted">N/A</span>
              </cfif>
            </div>
          </div>
        </div>
      </div>
    <cfelse>
      <div class="alert alert-secondary mb-0">
        <i class="icon fas fa-info-circle"></i> Cache statistics are not available. The Unbound container may not be running, or <code>unbound-control</code> may not be configured with remote-control enabled.
      </div>
    </cfif>

    <hr>

    <form method="post" action="view_dns_resolver.cfm" style="display:inline;">
      <input type="hidden" name="action" value="flush_cache">
      <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Flush the entire DNS cache? All cached records will be cleared.');">
        <i class="fas fa-trash-alt"></i> Flush Cache
      </button>
    </form>

  </div>
</div>

<!--- ================================================================== --->
<!--- CARD 5: DNS LOOKUP TEST                                             --->
<!--- ================================================================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-search"></i> DNS Lookup Test</h3>
  </div>
  <div class="card-body">

    <form method="post" action="view_dns_resolver.cfm">
      <input type="hidden" name="dns_lookup" value="1">
      <div class="row">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Domain Name</strong></label>
            <input type="text" class="form-control" name="lookup_domain" id="lookup_domain"
              placeholder="e.g., example.com"
              <cfif StructKeyExists(form, "lookup_domain")>value="<cfoutput>#encodeForHTMLAttribute(form.lookup_domain)#</cfoutput>"</cfif>>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Record Type</strong></label>
            <select class="form-select" name="lookup_type">
              <option value="A" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "A">selected</cfif>>A (IPv4)</option>
              <option value="AAAA" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "AAAA">selected</cfif>>AAAA (IPv6)</option>
              <option value="MX" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "MX">selected</cfif>>MX (Mail)</option>
              <option value="TXT" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "TXT">selected</cfif>>TXT</option>
              <option value="NS" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "NS">selected</cfif>>NS (Nameserver)</option>
              <option value="SOA" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "SOA">selected</cfif>>SOA</option>
              <option value="PTR" <cfif StructKeyExists(form, "lookup_type") AND form.lookup_type EQ "PTR">selected</cfif>>PTR (Reverse)</option>
            </select>
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label">&nbsp;</label>
            <div>
              <button type="submit" class="btn btn-info">
                <i class="fas fa-search"></i> Lookup
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>

    <!--- Show lookup results --->
    <cfif StructKeyExists(form, "dns_lookup") AND form.dns_lookup EQ "1" AND StructKeyExists(form, "lookup_domain")>
      <cfset lookupDomain = trim(form.lookup_domain)>
      <cfset lookupType = "A">
      <cfif StructKeyExists(form, "lookup_type") AND ListFindNoCase("A,AAAA,MX,TXT,NS,SOA,PTR", form.lookup_type)>
        <cfset lookupType = form.lookup_type>
      </cfif>

      <!--- Validate domain: alphanumeric, hyphens, dots, underscores only.
           Underscore is required for the records a mail gateway most needs to
           look up: _dmarc, <selector>._domainkey, _mta-sts, and the
           _submission._tcp / _submissions._tcp SRV records this product tells
           admins to publish (#304).
           This allowlist is also the injection guard -- lookupDomain is
           interpolated into a shell script below. Underscore is not a shell
           metacharacter, so it is safe to add; do NOT widen this further. --->
      <cfif lookupDomain NEQ "" AND REFind("^[a-zA-Z0-9\._\-]+$", lookupDomain)>
        <cfif containerRunning>
          <cftry>
            <cfinclude template="./inc/generate_customtrans.cfm">
            <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_unbound drill @127.0.0.1 #lookupType# #lookupDomain# 2>&1">
            <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_dns_lookup.sh">
            <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
            <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />
            <cfexecute name="#scriptPath#" variable="lookupResult" timeout="15" />
            <cffile action="delete" file="#scriptPath#">

            <div class="mt-2">
              <cfoutput>
              <label class="form-label"><strong>Results for <code>#encodeForHTML(lookupType)# #encodeForHTML(lookupDomain)#</code></strong></label>
              <pre class="bg-dark text-light p-3 rounded" style="max-height: 400px; overflow-y: auto; font-size: 0.85em;">#encodeForHTML(trim(lookupResult))#</pre>
              </cfoutput>
            </div>

          <cfcatch>
            <div class="alert alert-danger mt-2">
              <cfoutput>DNS lookup failed: #encodeForHTML(cfcatch.message)#</cfoutput>
            </div>
          </cfcatch>
          </cftry>
        <cfelse>
          <div class="alert alert-warning mt-2">
            <i class="icon fas fa-exclamation-triangle"></i> Cannot perform lookup: Unbound container is not running.
          </div>
        </cfif>
      <cfelseif lookupDomain NEQ "">
        <div class="alert alert-warning mt-2">
          <i class="icon fas fa-exclamation-triangle"></i> Invalid domain name. Use only letters, numbers, hyphens, dots, and underscores.
        </div>
      </cfif>
    </cfif>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
  // Toggle forwarder fields and TLS based on forwarding enabled/disabled
  function updateForwardingUI() {
    var enabled = $('#forwarding_enabled').val() === 'yes';
    $('#forward_tls').prop('disabled', !enabled);
    $('#forwarder_fields input').prop('disabled', !enabled);
    if (!enabled) {
      $('#forwarder_fields').css('opacity', '0.5');
    } else {
      $('#forwarder_fields').css('opacity', '1');
    }
  }

  $(document).ready(function() {
    updateForwardingUI();
    $('#forwarding_enabled').on('change', updateForwardingUI);

    // Re-enable disabled fields before form submission so their values are sent
    $('form').on('submit', function() {
      $(this).find(':disabled').prop('disabled', false);
    });
  });
</script>

</body>
</html>
