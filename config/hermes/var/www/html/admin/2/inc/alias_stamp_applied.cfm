<!---
Hermes Secure Email Gateway - record that a consumer just rendered its aliases

Included at the end of each generator that expands network aliases. Marks every
alias that consumer references as applied as of now, which is what clears the
"changed but not applied" warning for that page and leaves it standing for the
pages that have not caught up.

Per consumer, because each is applied separately. A single stamp on the alias
would clear the warning for pages that are still stale.

Expects: aliasStampConsumer, one of the consumer names used by
inc/get_network_aliases.cfm. The caller sets it immediately before including
this. An install with no aliases in use stamps nothing.
--->
<cfif StructKeyExists(variables, "aliasStampConsumer") AND Len(Trim(aliasStampConsumer))>
  <cftry>
    <cfquery name="stampAppliedAliases" datasource="hermes">
      INSERT INTO network_alias_applied (alias_id, consumer, applied_at)
      SELECT a.id, <cfqueryparam value="#aliasStampConsumer#" cfsqltype="cf_sql_varchar">, NOW(6)
      FROM network_aliases a
      WHERE a.id IN (
        SELECT p.alias_id FROM (
          SELECT a2.id AS alias_id
            FROM parameters c JOIN network_aliases a2 ON a2.name = c.parameter
           WHERE c.parent_name = 'mynetworks' AND c.child = '1' AND c.network_entry = '2'
             AND <cfqueryparam value="#aliasStampConsumer#" cfsqltype="cf_sql_varchar"> = 'Relay Networks'
          UNION
          SELECT a3.id
            FROM postscreen_access s JOIN network_aliases a3 ON a3.name = s.sender
           WHERE s.entry_type = 'alias'
             AND <cfqueryparam value="#aliasStampConsumer#" cfsqltype="cf_sql_varchar"> = 'Network Block-Allow'
          UNION
          SELECT a4.id
            FROM intrusion_prevention_whitelist w JOIN network_aliases a4 ON a4.name = w.ip_cidr
           WHERE w.entry_type = 'alias'
             AND <cfqueryparam value="#aliasStampConsumer#" cfsqltype="cf_sql_varchar"> = 'Intrusion Prevention'
        ) p
      )
      ON DUPLICATE KEY UPDATE applied_at = NOW(6)
    </cfquery>
    <cfcatch type="any">
      <!--- Never fail a config generation over bookkeeping. The worst case is a
           warning that stays up one cycle longer than it should. --->
      <cflog file="hermes" type="warning"
             text="alias_stamp_applied: #aliasStampConsumer#: #cfcatch.message#">
    </cfcatch>
  </cftry>
</cfif>
<cfset aliasStampConsumer = "">
