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
<cfif action EQ "save_forwarders" OR action EQ "restart_unbound" OR action EQ "flush_cache">
  <cfinclude template="./inc/dns_resolver_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Forwarder settings saved and Unbound restarted.
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
      <!--- Calculate uptime from startedAt (ISO 8601) --->
      <cftry>
        <cfset startedAt = Replace(startedAt, "T", " ")>
        <cfset startedAt = Left(startedAt, 19)>
        <cfset startDate = ParseDateTime(startedAt)>
        <cfset uptimeSeconds = DateDiff("s", startDate, Now())>
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
<!--- READ CURRENT FORWARD.CONF                                           --->
<!--- ================================================================== --->
<cfset forwardingEnabled = false>
<cfset forwardTls = "no">
<cfset currentForwarders = ArrayNew(1)>

<cfif containerRunning>
  <cftry>
    <cffile action="read" file="/etc/unbound/conf.d/forward.conf" variable="fwdConfContent" charset="utf-8">

    <!--- Parse forward-addr lines --->
    <cfloop list="#fwdConfContent#" delimiters="#chr(10)#" index="line">
      <cfset line = trim(line)>
      <!--- Skip commented lines --->
      <cfif Left(line, 1) NEQ chr(35)>
        <cfif FindNoCase("forward-addr:", line)>
          <cfset fwdAddr = trim(ReplaceNoCase(line, "forward-addr:", ""))>
          <cfif fwdAddr NEQ "">
            <cfset ArrayAppend(currentForwarders, fwdAddr)>
            <cfset forwardingEnabled = true>
          </cfif>
        </cfif>
        <cfif FindNoCase("forward-tls-upstream:", line)>
          <cfset tlsVal = trim(ReplaceNoCase(line, "forward-tls-upstream:", ""))>
          <cfif tlsVal EQ "yes">
            <cfset forwardTls = "yes">
          </cfif>
        </cfif>
      </cfif>
    </cfloop>

    <!--- If there's a forward-zone but no forward-addr lines, it's still a forwarding config --->
    <!--- If the file is just a comment (disabled), forwardingEnabled stays false --->
    <cfif ArrayLen(currentForwarders) EQ 0>
      <cfset forwardingEnabled = false>
    </cfif>

  <cfcatch>
    <!--- Could not read forward.conf --->
  </cfcatch>
  </cftry>
</cfif>

<!--- Pad forwarders array to 4 entries --->
<cfloop condition="ArrayLen(currentForwarders) LT 4">
  <cfset ArrayAppend(currentForwarders, "")>
</cfloop>

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
<form method="post" action="view_dns_resolver.cfm">
<input type="hidden" name="action" value="save_forwarders">

<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-project-diagram"></i> Upstream Forwarders</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-info">
      <p class="mb-0"><i class="icon fas fa-info-circle"></i> When forwarding is enabled, Unbound forwards DNS queries to the specified upstream resolvers instead of performing full recursive resolution. When disabled, Unbound queries root servers directly (requires outbound port 53 access).</p>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>DNS Forwarding</strong></label>
          <select class="form-select" name="forwarding_enabled" id="forwarding_enabled">
            <option value="yes" <cfif forwardingEnabled>selected</cfif>>Enabled (forward to upstream resolvers)</option>
            <option value="no" <cfif NOT forwardingEnabled>selected</cfif>>Disabled (full recursive resolution)</option>
          </select>
          <small class="form-text text-muted">When disabled, Unbound acts as a full recursive resolver, querying authoritative DNS servers directly. This provides maximum privacy but requires outbound UDP/TCP port 53.</small>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>DNS-over-TLS</strong></label>
          <select class="form-select" name="forward_tls" id="forward_tls">
            <option value="no" <cfif forwardTls NEQ "yes">selected</cfif>>Disabled (standard DNS, port 53)</option>
            <option value="yes" <cfif forwardTls EQ "yes">selected</cfif>>Enabled (DNS-over-TLS, port 853)</option>
          </select>
          <small class="form-text text-muted">Encrypts DNS queries to upstream forwarders using TLS (port 853). The upstream resolvers must support DNS-over-TLS (e.g., Cloudflare 1.1.1.1, Google 8.8.8.8, Quad9 9.9.9.9).</small>
        </div>
      </div>
    </div>

    <hr>

    <h5><i class="fas fa-network-wired"></i> Forwarder Addresses</h5>
    <p class="text-muted">Enter up to 4 upstream DNS resolver IP addresses. Common choices: Cloudflare (1.1.1.1, 1.0.0.1), Google (8.8.8.8, 8.8.4.4), Quad9 (9.9.9.9, 149.112.112.112).</p>

    <div class="row" id="forwarder_fields">
      <cfoutput>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Forwarder 1</strong></label>
          <input type="text" class="form-control" name="forwarder1" id="forwarder1" value="#encodeForHTMLAttribute(currentForwarders[1])#" placeholder="e.g., 1.1.1.1">
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Forwarder 2</strong></label>
          <input type="text" class="form-control" name="forwarder2" id="forwarder2" value="#encodeForHTMLAttribute(currentForwarders[2])#" placeholder="e.g., 1.0.0.1">
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Forwarder 3</strong></label>
          <input type="text" class="form-control" name="forwarder3" id="forwarder3" value="#encodeForHTMLAttribute(currentForwarders[3])#" placeholder="e.g., 8.8.8.8">
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Forwarder 4</strong></label>
          <input type="text" class="form-control" name="forwarder4" id="forwarder4" value="#encodeForHTMLAttribute(currentForwarders[4])#" placeholder="e.g., 8.8.4.4">
        </div>
      </div>
      </cfoutput>
    </div>

  </div>
  <div class="card-footer">
    <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i>&nbsp;&nbsp;Save Forwarders</button>
  </div>
</div>

</form>

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

      <!--- Validate domain: alphanumeric, hyphens, dots only --->
      <cfif lookupDomain NEQ "" AND REFind("^[a-zA-Z0-9\.\-]+$", lookupDomain)>
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
          <i class="icon fas fa-exclamation-triangle"></i> Invalid domain name. Use only letters, numbers, hyphens, and dots.
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
