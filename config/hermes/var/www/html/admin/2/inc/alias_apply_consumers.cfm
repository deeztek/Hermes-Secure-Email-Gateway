<!---
Hermes Secure Email Gateway - apply the consumers that reference one alias

Called after an alias's ranges change, by the resolver or by a hand edit. Each
consumer renders the alias to its current ranges inside its own existing
generator, so this only has to decide WHICH generators to run.

Scoped to the consumers that actually reference this alias. An alias nobody uses
regenerates nothing.

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
        <!--- Narrow apply: one directive and one file, never the whole main.cf
             rebuild. See inc/apply_mynetworks.cfm for why. --->
        <cfinclude template="apply_mynetworks.cfm">
        <cfset oneOk = applyMynetworksOk>
        <cfset oneErr = applyMynetworksError>
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
