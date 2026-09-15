<!---
Hermes Secure Email Gateway - apply mynetworks only

Writes the current mynetworks value to Postfix and to /etc/amavis/mynetworks,
reloads both, and records Relay Networks as applied for every alias it
references.

WHY THIS EXISTS RATHER THAN CALLING generate_postfix_configuration.cfm

That generator copies main.cf.HERMES over /etc/postfix/main.cf and rebuilds the
whole file from every `parameters` row, then finishes with

    update parameters set applied='1', action='NONE' where applied = '2'

which is unfiltered. Run it and you commit every staged Postfix change anywhere
in the console, not just this one. That is fine when an operator pressed Apply
on a page and is watching. It is not fine on an automatic path, where it would
silently commit half-finished work somebody left staged, at 03:30, with nobody
present.

So this touches one directive and one file, and commits only the mynetworks
rows it actually applied. Same shape as generate_postscreen_access.cfm, which
already does exactly this for its own file.

Sets: applyMynetworksOk (boolean), applyMynetworksError (string).
--->
<cfset applyMynetworksOk = false>
<cfset applyMynetworksError = "">

<cftry>
  <!--- Same expansion as the full generator. An alias contributes its current
       IPv4 ranges; one that is disabled or unresolved contributes nothing
       rather than an empty element. --->
  <cfquery name="applyNetRows" datasource="hermes">
    SELECT rendered AS parameter FROM (
      SELECT c.order1,
             CASE WHEN c.network_entry = '2'
                  THEN (SELECT GROUP_CONCAT(e.cidr ORDER BY e.cidr SEPARATOR ', ')
                          FROM network_alias_entries e
                          JOIN network_aliases a ON a.id = e.alias_id
                         WHERE a.name = c.parameter AND a.enabled = 1 AND e.family = 'ip4')
                  ELSE c.parameter END AS rendered
        FROM parameters c
       WHERE c.child = '1' AND c.parent_name = 'mynetworks' AND c.enabled = '1'
    ) x
    WHERE rendered IS NOT NULL AND rendered <> ''
    ORDER BY order1 ASC
  </cfquery>

  <!--- Refuse to write an empty mynetworks. Postfix would then trust nothing,
       including the Docker subnet the containers talk to each other on, which
       breaks mail flow far worse than a stale range does. --->
  <cfif applyNetRows.recordcount IS 0>
    <cfthrow message="mynetworks would be empty, refusing to apply">
  </cfif>

  <cfinclude template="generate_customtrans.cfm">
  <cfset applyScript = "/opt/hermes/tmp/#customtrans3#_mynetworks.sh">

  <cfset applyNetValue = ValueList(applyNetRows.parameter, ", ")>
  <cffile action="write" file="#applyScript#"
          output='/usr/sbin/postconf -e "mynetworks = #applyNetValue#"' addNewLine="yes">
  <cffile action="append" file="#applyScript#"
          output="/usr/sbin/postfix reload" addNewLine="yes">

  <cfexecute name="/usr/bin/dos2unix" arguments="#applyScript#" timeout="10" />
  <cfexecute name="/bin/chmod" arguments="+x #applyScript#" timeout="30" />
  <cfexecute name="/usr/local/bin/docker"
             arguments="exec hermes_postfix_dkim /bin/bash #applyScript#"
             timeout="120" variable="applyNetOut" errorVariable="applyNetErr" />
  <cfif FileExists(applyScript)>
    <cffile action="delete" file="#applyScript#">
  </cfif>

  <!--- Amavis reads one network per line, so split the comma list an expanded
       alias produces rather than writing it as a single line. --->
  <cffile action="write" file="/etc/amavis/mynetworks" output="" addnewline="no">
  <cfloop query="applyNetRows">
    <cfloop list="#applyNetRows.parameter#" index="oneApplyNet" delimiters=",">
      <cffile action="append" file="/etc/amavis/mynetworks"
              output="#Trim(oneApplyNet)#" addnewline="yes">
    </cfloop>
  </cfloop>
  <cfexecute name="/usr/local/bin/docker"
             arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
             timeout="240" />

  <!--- Commit only the mynetworks rows, never the whole pending set. --->
  <cfquery name="applyNetCommit" datasource="hermes">
    UPDATE parameters SET applied = '1', action = 'NONE'
    WHERE parent_name = 'mynetworks' AND applied = '2'
  </cfquery>

  <cfset aliasStampConsumer = "Relay Networks">
  <cfinclude template="alias_stamp_applied.cfm">
  <cfset applyMynetworksOk = true>

  <cfcatch type="any">
    <cfset applyMynetworksError = cfcatch.message>
    <cflog file="hermes" type="error"
           text="apply_mynetworks: #cfcatch.message# | #cfcatch.detail#">
  </cfcatch>
</cftry>
