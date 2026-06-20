<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

DNS RESOLVER ACTION HANDLER
Handles save_forwarding, add_forwarder, delete_forwarder, toggle_forwarder,
restart_unbound, flush_cache actions.
Settings stored in parameters2 + dns_forwarders table.
--->

<cfif action EQ "save_forwarding">

  <!--- Save global forwarding toggle --->
  <cfparam name="form.forwarding_enabled" default="no">
  <cfset fwdVal = (form.forwarding_enabled EQ "yes") ? "yes" : "no">

  <cftry>
    <cfquery name="checkFwd" datasource="hermes">
      SELECT parameter FROM parameters2 WHERE module = 'unbound' AND parameter = 'forwarding.enabled'
    </cfquery>
    <cfif checkFwd.recordcount GTE 1>
      <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#fwdVal#" cfsqltype="cf_sql_varchar">, applied = '2'
        WHERE module = 'unbound' AND parameter = 'forwarding.enabled'
      </cfquery>
    <cfelse>
      <cfquery datasource="hermes">
        INSERT INTO parameters2 (module, parameter, value2, applied) VALUES ('unbound', 'forwarding.enabled', <cfqueryparam value="#fwdVal#" cfsqltype="cf_sql_varchar">, '2')
      </cfquery>
    </cfif>

    <cfinclude template="generate_unbound_forward_conf.cfm">
    <cfset session.m = 1>
  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "add_forwarder">

  <cfparam name="form.new_server" default="">
  <cfparam name="form.new_port" default="853">
  <cfparam name="form.new_tls" default="0">

  <cfset newServer = trim(form.new_server)>
  <cfset newPort = IsNumeric(form.new_port) ? Int(form.new_port) : 853>
  <cfset newTls = (form.new_tls EQ "1") ? 1 : 0>

  <!--- Validate IP --->
  <cfset ipPattern = "^(\d{1,3}\.){3}\d{1,3}$">
  <cfif newServer EQ "" OR NOT REFind(ipPattern, newServer)>
    <cfset session.m = 11>
    <cfset session.dnsError = "Invalid IP address.">
    <cflocation url="view_dns_resolver.cfm" addtoken="no">
  </cfif>

  <!--- Validate octets --->
  <cfloop list="#newServer#" delimiters="." index="octet">
    <cfif NOT IsNumeric(octet) OR val(octet) LT 0 OR val(octet) GT 255>
      <cfset session.m = 11>
      <cfset session.dnsError = "Invalid IP address octet.">
      <cflocation url="view_dns_resolver.cfm" addtoken="no">
    </cfif>
  </cfloop>

  <!--- Validate port --->
  <cfif newPort LT 1 OR newPort GT 65535>
    <cfset session.m = 11>
    <cfset session.dnsError = "Invalid port number.">
    <cflocation url="view_dns_resolver.cfm" addtoken="no">
  </cfif>

  <cftry>
    <!--- Get next sort order --->
    <cfquery name="getMaxSort" datasource="hermes">
      SELECT COALESCE(MAX(sort_order), 0) + 1 AS next_sort FROM dns_forwarders
    </cfquery>

    <cfquery datasource="hermes">
      INSERT IGNORE INTO dns_forwarders (server, port, tls, enabled, sort_order)
      VALUES (
        <cfqueryparam value="#newServer#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#newPort#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#newTls#" cfsqltype="cf_sql_tinyint">,
        1,
        <cfqueryparam value="#getMaxSort.next_sort#" cfsqltype="cf_sql_integer">
      )
    </cfquery>

    <cfset session.m = 4>
  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "delete_forwarder">

  <cfparam name="form.forwarder_id" default="">

  <cfif IsNumeric(form.forwarder_id)>
    <cftry>
      <cfquery datasource="hermes">
        DELETE FROM dns_forwarders WHERE id = <cfqueryparam value="#form.forwarder_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 5>
    <cfcatch type="any">
      <cfset session.m = 10>
      <cfset session.dnsError = cfcatch.message>
    </cfcatch>
    </cftry>
  </cfif>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "toggle_forwarder">

  <cfparam name="form.forwarder_id" default="">

  <cfif IsNumeric(form.forwarder_id)>
    <cftry>
      <cfquery datasource="hermes">
        UPDATE dns_forwarders SET enabled = IF(enabled = 1, 0, 1)
        WHERE id = <cfqueryparam value="#form.forwarder_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 6>
    <cfcatch type="any">
      <cfset session.m = 10>
      <cfset session.dnsError = cfcatch.message>
    </cfcatch>
    </cftry>
  </cfif>

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

<cfelseif action EQ "apply_forwarders">

  <!--- Regenerate forward.conf from current database state and restart --->
  <cftry>
    <cfinclude template="generate_unbound_forward_conf.cfm">
    <cfset session.m = 1>
  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "add_local_record">

  <cfparam name="form.local_hostname" default="">
  <cfparam name="form.local_type" default="A">
  <cfparam name="form.local_value" default="">
  <cfparam name="form.local_description" default="">

  <cfset localHost = trim(form.local_hostname)>
  <cfset localType = trim(form.local_type)>
  <cfset localValue = trim(form.local_value)>
  <cfset localDesc = trim(form.local_description)>

  <!--- Validate --->
  <cfif localHost EQ "" OR localValue EQ "">
    <cfset session.m = 11>
    <cfset session.dnsError = "Hostname and value are required.">
    <cflocation url="view_dns_resolver.cfm" addtoken="no">
  </cfif>

  <cfif NOT ListFindNoCase("A,AAAA,CNAME,MX,TXT,PTR", localType)>
    <cfset session.m = 11>
    <cfset session.dnsError = "Invalid record type.">
    <cflocation url="view_dns_resolver.cfm" addtoken="no">
  </cfif>

  <cftry>
    <cfquery datasource="hermes">
      INSERT IGNORE INTO dns_local_records (hostname, record_type, value, enabled, description)
      VALUES (
        <cfqueryparam value="#localHost#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#localType#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#localValue#" cfsqltype="cf_sql_varchar">,
        1,
        <cfqueryparam value="#localDesc#" cfsqltype="cf_sql_varchar" null="#(localDesc EQ '')#">
      )
    </cfquery>
    <cfset session.m = 7>
  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "delete_local_record">

  <cfparam name="form.local_record_id" default="">
  <cfif IsNumeric(form.local_record_id)>
    <cftry>
      <cfquery datasource="hermes">
        DELETE FROM dns_local_records WHERE id = <cfqueryparam value="#form.local_record_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 8>
    <cfcatch type="any">
      <cfset session.m = 10>
      <cfset session.dnsError = cfcatch.message>
    </cfcatch>
    </cftry>
  </cfif>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "toggle_local_record">

  <cfparam name="form.local_record_id" default="">
  <cfif IsNumeric(form.local_record_id)>
    <cftry>
      <cfquery datasource="hermes">
        UPDATE dns_local_records SET enabled = IF(enabled = 1, 0, 1)
        WHERE id = <cfqueryparam value="#form.local_record_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 9>
    <cfcatch type="any">
      <cfset session.m = 10>
      <cfset session.dnsError = cfcatch.message>
    </cfcatch>
    </cftry>
  </cfif>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

<cfelseif action EQ "apply_local_records">

  <cftry>
    <cfinclude template="generate_unbound_local_conf.cfm">
    <cfset session.m = 1>
  <cfcatch type="any">
    <cfset session.m = 10>
    <cfset session.dnsError = cfcatch.message>
  </cfcatch>
  </cftry>

  <cflocation url="view_dns_resolver.cfm" addtoken="no">

</cfif>
