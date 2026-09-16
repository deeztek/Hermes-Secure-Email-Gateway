<!---
Hermes Secure Email Gateway - literal rows already covered by a referenced alias

Builds aliasCoveredBy: a struct of CIDR -> alias name, for every range the
aliases referenced BY THIS CONSUMER currently expand to. A literal row whose
value is a key in that struct is redundant: the same range would be written to
the config file by the alias even if the row were deleted.

WHY FLAG RATHER THAN DEDUPE THE OUTPUT

The rendered file is meant to say exactly what is configured. Silently collapsing
a duplicate hides a row that is doing nothing, and makes deleting it look broken:
the range stays in the config, because the alias still supplies it. Flagging the
row lets the operator remove it and see the duplicate go away for the right
reason. Postfix, Amavis and fail2ban all ignore repeats, so there is no
functional cost to leaving them.

This is the normal adoption path, not an edge case. An operator with hand-pasted
ranges creates an alias covering the same ground and has not yet removed the old
rows.

EXACT MATCH ONLY. 203.0.113.5/32 sitting inside an alias's 203.0.113.0/24 is
not flagged. Catching that needs CIDR containment arithmetic, and the common case
by far is the operator having pasted the very ranges the alias now resolves.

Expects: aliasCoverConsumer, one of the consumer names used by
inc/get_network_aliases.cfm.
--->
<cfparam name="aliasCoverConsumer" default="">
<cfset aliasCoveredBy = StructNew()>

<cfif Len(Trim(aliasCoverConsumer))>
  <cfquery name="getAliasCovered" datasource="hermes">
    SELECT e.cidr, a.name
    FROM network_alias_entries e
    JOIN network_aliases a ON a.id = e.alias_id
    WHERE a.enabled = 1
      AND e.family = 'ip4'
      AND a.name IN (
        SELECT p.parameter FROM parameters p
         WHERE p.parent_name = 'mynetworks' AND p.child = '1' AND p.network_entry = '2'
           AND <cfqueryparam value="#aliasCoverConsumer#" cfsqltype="cf_sql_varchar"> = 'Relay Networks'
        UNION
        SELECT s.sender FROM postscreen_access s
         WHERE s.entry_type = 'alias'
           AND <cfqueryparam value="#aliasCoverConsumer#" cfsqltype="cf_sql_varchar"> = 'Network Block-Allow'
        UNION
        SELECT w.ip_cidr FROM intrusion_prevention_whitelist w
         WHERE w.entry_type = 'alias'
           AND <cfqueryparam value="#aliasCoverConsumer#" cfsqltype="cf_sql_varchar"> = 'Intrusion Prevention'
      )
  </cfquery>
  <cfloop query="getAliasCovered">
    <cfif NOT StructKeyExists(aliasCoveredBy, getAliasCovered.cidr)>
      <cfset aliasCoveredBy[getAliasCovered.cidr] = getAliasCovered.name>
    </cfif>
  </cfloop>
</cfif>
