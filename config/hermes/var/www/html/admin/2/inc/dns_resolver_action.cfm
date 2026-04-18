<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

DNS RESOLVER ACTION HANDLER
Handles save_forwarders, restart_unbound, flush_cache actions.
Writes config files directly to mounted /etc/unbound/conf.d/ volume.
Uses docker exec for container restart and cache flush.
--->

<cfif action EQ "save_forwarders">

  <!--- Validate inputs --->
  <cfparam name="form.forwarding_enabled" default="yes">
  <cfparam name="form.forward_tls" default="no">
  <cfparam name="form.forwarder1" default="">
  <cfparam name="form.forwarder2" default="">
  <cfparam name="form.forwarder3" default="">
  <cfparam name="form.forwarder4" default="">

  <cfset forwarding_enabled = (form.forwarding_enabled EQ "yes") ? "yes" : "no">
  <cfset forward_tls = (form.forward_tls EQ "yes") ? "yes" : "no">

  <!--- IP address validation pattern (IPv4 only for forwarders) --->
  <cfset ipPattern = "^(\d{1,3}\.){3}\d{1,3}$">

  <!--- Collect valid forwarder IPs --->
  <cfset forwarders = ArrayNew(1)>
  <cfloop list="forwarder1,forwarder2,forwarder3,forwarder4" index="fld">
    <cfset fval = trim(form[fld])>
    <cfif fval NEQ "" AND REFind(ipPattern, fval)>
      <!--- Validate each octet is 0-255 --->
      <cfset validOctets = true>
      <cfloop list="#fval#" delimiters="." index="octet">
        <cfif NOT IsNumeric(octet) OR val(octet) LT 0 OR val(octet) GT 255>
          <cfset validOctets = false>
        </cfif>
      </cfloop>
      <cfif validOctets>
        <cfset ArrayAppend(forwarders, fval)>
      </cfif>
    </cfif>
  </cfloop>

  <!--- If forwarding enabled, must have at least one forwarder --->
  <cfif forwarding_enabled EQ "yes" AND ArrayLen(forwarders) EQ 0>
    <cfset session.m = 10>
    <cfset session.dnsError = "At least one valid forwarder IP address is required when forwarding is enabled.">
    <cflocation url="view_dns_resolver.cfm" addtoken="no">
  </cfif>

  <cftry>
    <cfif forwarding_enabled EQ "yes">
      <!--- Build forward.conf content --->
      <cfset nl = chr(10)>
      <cfset forwarderConf = "forward-zone:" & nl>
      <cfset forwarderConf = forwarderConf & "    name: "".""" & nl>
      <cfset forwarderConf = forwarderConf & "    forward-tls-upstream: " & forward_tls & nl>
      <cfloop array="#forwarders#" index="fwdIP">
        <cfset forwarderConf = forwarderConf & "    forward-addr: " & fwdIP & nl>
      </cfloop>

      <!--- Write directly to mounted config directory --->
      <cfscript>fileWrite("/etc/unbound/conf.d/forward.conf", forwarderConf, "utf-8");</cfscript>

    <cfelse>
      <!--- Forwarding disabled: write an empty forward.conf (comments only) --->
      <cfset nl = chr(10)>
      <cfset forwarderConf = "## Forwarding disabled - Unbound performs full recursive resolution" & nl>

      <cfscript>fileWrite("/etc/unbound/conf.d/forward.conf", forwarderConf, "utf-8");</cfscript>
    </cfif>

    <!--- Restart unbound to apply --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="container restart hermes_unbound"
        variable="restartResult"
        errorVariable="restartError"
        timeout="30" />

    <cfset session.m = 1>

  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "restart_unbound">

  <cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="container restart hermes_unbound"
        variable="restartResult"
        errorVariable="restartError"
        timeout="30" />

    <cfset session.m = 2>

  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "flush_cache">

  <cftry>
    <!--- Use temp script to capture stderr from unbound-control --->
    <cfinclude template="generate_customtrans.cfm">
    <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_unbound unbound-control flush_zone . 2>&1">
    <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_flush_cache.sh">
    <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
    <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />

    <cfexecute name="#scriptPath#"
        variable="flushResult"
        timeout="30" />

    <cffile action="delete" file="#scriptPath#">

    <cfset session.m = 3>

  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

</cfif>
