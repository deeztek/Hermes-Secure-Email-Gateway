<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

DNS RESOLVER ACTION HANDLER
Handles save_forwarders, restart_unbound, flush_cache actions.
Settings stored in parameters2 (module='unbound'), config files
generated from database via generate_unbound_forward_conf.cfm.
--->

<cfif action EQ "save_forwarders">

  <!--- Validate inputs --->
  <cfparam name="form.forwarding_enabled" default="no">
  <cfparam name="form.forward_tls" default="no">
  <cfparam name="form.forwarder1" default="">
  <cfparam name="form.forwarder2" default="">
  <cfparam name="form.forwarder3" default="">
  <cfparam name="form.forwarder4" default="">

  <cfset forwarding_enabled = (form.forwarding_enabled EQ "yes") ? "yes" : "no">
  <cfset forward_tls = (form.forward_tls EQ "yes") ? "yes" : "no">

  <!--- IP address validation (IPv4) --->
  <cfset ipPattern = "^(\d{1,3}\.){3}\d{1,3}$">
  <cfset validForwarders = ArrayNew(1)>
  <cfloop list="forwarder1,forwarder2,forwarder3,forwarder4" index="fld">
    <cfset fval = trim(form[fld])>
    <cfif fval NEQ "" AND REFind(ipPattern, fval)>
      <cfset validOctets = true>
      <cfloop list="#fval#" delimiters="." index="octet">
        <cfif NOT IsNumeric(octet) OR val(octet) LT 0 OR val(octet) GT 255>
          <cfset validOctets = false>
        </cfif>
      </cfloop>
      <cfif validOctets>
        <cfset ArrayAppend(validForwarders, fval)>
      </cfif>
    </cfif>
  </cfloop>

  <!--- If forwarding enabled, must have at least one forwarder --->
  <cfif forwarding_enabled EQ "yes" AND ArrayLen(validForwarders) EQ 0>
    <cfset session.m = 10>
    <cfset session.dnsError = "At least one valid forwarder IP address is required when forwarding is enabled.">
    <cflocation url="view_dns_resolver.cfm" addtoken="no">
  </cfif>

  <cftry>
    <!--- Pad to 4 entries --->
    <cfloop condition="ArrayLen(validForwarders) LT 4">
      <cfset ArrayAppend(validForwarders, "")>
    </cfloop>

    <!--- Save to parameters2 --->
    <cfloop list="forwarding.enabled,forwarding.tls,forwarding.server1,forwarding.server2,forwarding.server3,forwarding.server4" index="paramKey">
      <cfswitch expression="#paramKey#">
        <cfcase value="forwarding.enabled"><cfset paramVal = forwarding_enabled></cfcase>
        <cfcase value="forwarding.tls"><cfset paramVal = forward_tls></cfcase>
        <cfcase value="forwarding.server1"><cfset paramVal = validForwarders[1]></cfcase>
        <cfcase value="forwarding.server2"><cfset paramVal = validForwarders[2]></cfcase>
        <cfcase value="forwarding.server3"><cfset paramVal = validForwarders[3]></cfcase>
        <cfcase value="forwarding.server4"><cfset paramVal = validForwarders[4]></cfcase>
      </cfswitch>

      <cfquery name="checkParam" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'unbound' AND parameter = <cfqueryparam value="#paramKey#" cfsqltype="cf_sql_varchar">
      </cfquery>
      <cfif checkParam.recordcount GTE 1>
        <cfquery datasource="hermes">
          UPDATE parameters2
          SET value2 = <cfqueryparam value="#paramVal#" cfsqltype="cf_sql_varchar">,
              applied = '2'
          WHERE module = 'unbound' AND parameter = <cfqueryparam value="#paramKey#" cfsqltype="cf_sql_varchar">
        </cfquery>
      <cfelse>
        <cfquery datasource="hermes">
          INSERT INTO parameters2 (module, parameter, value2, applied)
          VALUES ('unbound',
                  <cfqueryparam value="#paramKey#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#paramVal#" cfsqltype="cf_sql_varchar">,
                  '2')
        </cfquery>
      </cfif>
    </cfloop>

    <!--- Regenerate forward.conf and restart Unbound --->
    <cfinclude template="generate_unbound_forward_conf.cfm">

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
    <cfinclude template="generate_customtrans.cfm">
    <cfset scriptContent = chr(35) & "!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_unbound unbound-control flush_zone . 2>&1">
    <cfset scriptPath = "/opt/hermes/tmp/" & customtrans3 & "_flush_cache.sh">
    <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
    <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />
    <cfexecute name="#scriptPath#" variable="flushResult" timeout="30" />
    <cffile action="delete" file="#scriptPath#">
    <cfset session.m = 3>
  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

</cfif>
