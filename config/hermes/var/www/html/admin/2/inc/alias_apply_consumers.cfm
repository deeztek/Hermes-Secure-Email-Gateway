<!---
Hermes Secure Email Gateway - apply the consumers that reference one alias

Called after an alias's ranges change, by the resolver or by a hand edit. Each
consumer renders the alias to its current ranges inside its own existing
generator, so this only has to decide WHICH generators to run.

Scoped to the consumers that actually reference this alias. An alias nobody uses
regenerates nothing.

ONE WRITER PER CONFIG FILE

Each consumer is applied by the generator that already owns that file. Nothing
here writes Postfix, Amavis or fail2ban config itself. A second writer for the
same file is a second thing to keep in step, and the two would drift.

Note that generate_postfix_configuration.cfm rebuilds all of main.cf and
commits every staged parameter, not only mynetworks. That is the same thing it
does when an operator presses Apply on any Postfix settings page, and staged
rows are rendered by any regeneration regardless of their applied flag, so this
does not make anything live that was not already going to be.

Its four fatal paths, guarding chown, dos2unix, chmod and the amavis reload,
used to draw an error box and cfabort, which on a scheduled run would emit HTML
into a JSON response and end the run early so later aliases never resolved.
They now log unconditionally and, when request.generateQuiet is set, throw
instead. The throw is caught here, the consumer is recorded as failed and left
unstamped, and the run continues.

EACH CONSUMER IS INDEPENDENT AND FAILURE IS PER CONSUMER

The three generators write different files and reload different services. One
failing must not stop the others, or a single Amavis reload timeout (that call
carries a 240s timeout for a reason) leaves the postscreen table unapplied as
well. Each is tried on its own and its outcome recorded separately.

Nothing here clears a pending warning by itself. Each generator stamps
network_alias_applied on its own success path, so a consumer that failed stays
listed as not applied, which is the whole point of tracking it per consumer.

Expects: aliasApplyId (numeric alias id).
Sets:    aliasApplyResults, an array of {consumer, ok, error}.
--->
<!--- Nobody is looking at a page here, whether this came from the scheduler or
     from a hand edit on the aliases page: in both cases the outcome is reported
     as a structured result, not as an error box drawn mid-template. generateQuiet
     tells the generators to log and throw rather than render error.cfm and
     cfabort the request. Each consumer's cftry below then records the failure and
     the run continues to the next one. --->
<cfset request.generateQuiet = true>
<cfset aliasApplyResults = []>

<cfquery name="aliasApplyWho" datasource="hermes">
  SELECT 'Relay Networks' AS consumer
    FROM parameters p JOIN network_aliases a ON a.name = p.parameter
   WHERE p.parent_name = 'mynetworks' AND p.child = '1' AND p.network_entry = '2'
     AND a.id = <cfqueryparam value="#aliasApplyId#" cfsqltype="cf_sql_integer">
   GROUP BY 1
  UNION ALL
  SELECT 'Network Block-Allow'
    FROM postscreen_access s JOIN network_aliases a ON a.name = s.sender
   WHERE s.entry_type = 'alias'
     AND a.id = <cfqueryparam value="#aliasApplyId#" cfsqltype="cf_sql_integer">
   GROUP BY 1
  UNION ALL
  SELECT 'Intrusion Prevention'
    FROM intrusion_prevention_whitelist w JOIN network_aliases a ON a.name = w.ip_cidr
   WHERE w.entry_type = 'alias'
     AND a.id = <cfqueryparam value="#aliasApplyId#" cfsqltype="cf_sql_integer">
   GROUP BY 1
</cfquery>

<cfloop query="aliasApplyWho">
  <cfset oneOk = false>
  <cfset oneErr = "">

  <cftry>
    <cfswitch expression="#aliasApplyWho.consumer#">
      <cfcase value="Relay Networks">
        <cfinclude template="generate_postfix_configuration.cfm">
        <cfset oneOk = true>
      </cfcase>

      <cfcase value="Network Block-Allow">
        <cfinclude template="generate_postscreen_access.cfm">
        <cfset oneOk = true>
      </cfcase>

      <cfcase value="Intrusion Prevention">
        <cfinclude template="intrusion_prevention_generate_config.cfm">
        <cfset oneOk = (StructKeyExists(variables, "ipSyncSuccess") AND ipSyncSuccess)>
        <cfif NOT oneOk AND StructKeyExists(variables, "ipSyncError")>
          <cfset oneErr = ipSyncError>
        </cfif>
      </cfcase>
    </cfswitch>

    <cfcatch type="any">
      <cfset oneOk = false>
      <cfset oneErr = cfcatch.message>
    </cfcatch>
  </cftry>

  <cfif NOT oneOk>
    <cflog file="hermes" type="error"
           text="alias_apply_consumers: #aliasApplyWho.consumer# failed: #oneErr#">
  </cfif>
  <cfset ArrayAppend(aliasApplyResults, {
    consumer = aliasApplyWho.consumer,
    ok       = oneOk,
    error    = oneErr
  })>
</cfloop>

<cfset request.generateQuiet = false>
