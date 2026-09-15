<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<!---
  refresh_network_aliases.cfm (#324)

  Re-resolves every enabled alias whose source_type is 'spf' and records what
  changed. Called by Ofelia.

  ADVISORY ONLY. This writes to network_alias_entries and nothing else. No
  config file is rendered, no service is reloaded, and no consumer is touched.
  A change here cannot affect mail flow, which is the entire point while there
  is no evidence yet that the resolve is trustworthy.

  Three rules this file exists to honour:

  1. A FAILED OR EMPTY RESOLVE NEVER EMPTIES THE LIST. If DNS is down, or the
     record has gone, the existing entries stay exactly as they are and the
     alias is marked failed. Losing ranges because a resolver hiccuped is the
     one outcome worse than stale ranges.

  2. STDERR IS NEVER TREATED AS DATA. inc/rbl_test_entry.cfm learned this the
     expensive way: neither probe captured stderr, so Lucee folded docker's
     "executable file not found" into the output variable, the emptiness test
     passed on the error text, and every block list was reported healthy on
     gateways where no DNS query had been made at all. Every cfexecute here
     captures stderr separately and a non-empty stderr is a failure, full stop.

  3. MANUAL ENTRIES ARE NEVER DISCARDED. Only rows with origin='resolved' are
     reconciled. Anything an operator typed survives a resolve.

  dig runs locally. This CFML executes inside hermes_commandbox, which has
  dnsutils and is pointed at hermes_unbound by compose, so it resolves through
  the same resolver Postfix uses.
--->

<cfsetting requesttimeout="300">
<cfparam name="url.debug" default="0">

<cfset digBin = "/usr/bin/dig">
<cfset runStarted = Now()>
<cfset changedAliases = []>
<cfset failedAliases = []>

<cfif NOT FileExists(digBin)>
  <cfquery name="markAllUnresolvable" datasource="hermes">
    UPDATE network_aliases
    SET last_status = <cfqueryparam value="no_resolver" cfsqltype="cf_sql_varchar">,
        last_message = <cfqueryparam value="dig is not present in hermes_commandbox; install dnsutils in the image" cfsqltype="cf_sql_varchar">
    WHERE enabled = 1 AND source_type = 'spf'
  </cfquery>
  <cflog file="hermes" type="error"
         text="refresh_network_aliases: #digBin# missing in hermes_commandbox, no alias could be resolved">
  <cfoutput>{"status":"error","message":"dig not present"}</cfoutput>
  <cfabort>
</cfif>

<!--- ------------------------------------------------------------------
      digTxt: one TXT lookup. Returns a struct, never a bare string, so a
      failure can never be mistaken for a record.
      ------------------------------------------------------------------ --->
<cffunction name="digTxt" returntype="struct" output="false">
  <cfargument name="host" type="string" required="true">
  <cfargument name="bin" type="string" required="true">

  <cfset var out = "">
  <cfset var err = "">
  <cfset var res = StructNew()>
  <cfset var lines = "">
  <cfset var oneLine = "">
  <cfset var joined = "">

  <cfset res.ok = false>
  <cfset res.record = "">
  <cfset res.message = "">

  <cftry>
    <cfexecute name="#arguments.bin#"
               arguments="+short +time=3 +tries=2 TXT #arguments.host#"
               variable="out"
               errorVariable="err"
               timeout="15" />
    <cfcatch type="any">
      <cfset res.message = "dig failed: " & cfcatch.message>
      <cfreturn res>
    </cfcatch>
  </cftry>

  <!--- Rule 2: stderr is a failure, never data. --->
  <cfif Len(Trim(err))>
    <cfset res.message = "resolver error: " & Left(Trim(err), 200)>
    <cfreturn res>
  </cfif>

  <cfif NOT Len(Trim(out))>
    <cfset res.message = "no TXT record returned for " & arguments.host>
    <cfreturn res>
  </cfif>

  <!---
    dig +short TXT returns one line per record, each a sequence of quoted
    strings that the DNS layer split at 255 characters. Concatenating them is
    the correct reassembly, not a convenience.
  --->
  <cfset lines = ListToArray(Trim(out), Chr(10))>
  <cfloop array="#lines#" index="oneLine">
    <cfset oneLine = Trim(oneLine)>
    <cfif Left(oneLine, 7) is '"v=spf1' OR FindNoCase("v=spf1", oneLine)>
      <cfset joined = Trim(ReplaceNoCase(oneLine, '" "', "", "all"))>
      <cfset joined = Replace(joined, '"', "", "all")>
      <cfset res.ok = true>
      <cfset res.record = joined>
      <cfreturn res>
    </cfif>
  </cfloop>

  <cfset res.message = "no SPF record among the TXT records for " & arguments.host>
  <cfreturn res>
</cffunction>

<!--- ------------------------------------------------------------------
      expandSpf: recursive expansion of ip4/ip6 with include and redirect.

      The SPF specification caps a policy at 10 DNS-querying mechanisms.
      Honouring that is not politeness, it is what stops a hostile or
      misconfigured record turning a scheduled job into an amplifier.
      ------------------------------------------------------------------ --->
<cffunction name="expandSpf" returntype="struct" output="false">
  <cfargument name="host"    type="string"  required="true">
  <cfargument name="bin"     type="string"  required="true">
  <cfargument name="budget"  type="numeric" required="true">
  <cfargument name="seen"    type="struct"  required="true">

  <cfset var res = StructNew()>
  <cfset var txt = "">
  <cfset var terms = "">
  <cfset var oneTerm = "">
  <cfset var target = "">
  <cfset var sub = "">
  <cfset var i = 0>

  <cfset res.ok = false>
  <cfset res.ip4 = []>
  <cfset res.ip6 = []>
  <cfset res.budget = arguments.budget>
  <cfset res.message = "">

  <!--- Loop protection independent of the budget: a record that includes
        itself, directly or through a cycle, is stopped here. --->
  <cfif StructKeyExists(arguments.seen, LCase(arguments.host))>
    <cfset res.ok = true>
    <cfreturn res>
  </cfif>
  <cfset arguments.seen[LCase(arguments.host)] = true>

  <cfif res.budget LTE 0>
    <cfset res.message = "SPF lookup limit of 10 reached while expanding " & arguments.host>
    <cfreturn res>
  </cfif>
  <cfset res.budget = res.budget - 1>

  <cfset txt = digTxt(arguments.host, arguments.bin)>
  <cfif NOT txt.ok>
    <cfset res.message = txt.message>
    <cfreturn res>
  </cfif>

  <cfset terms = ListToArray(Trim(txt.record), " ")>
  <cfloop array="#terms#" index="oneTerm">
    <cfset oneTerm = Trim(oneTerm)>
    <cfif oneTerm is "">
      <cfcontinue>
    </cfif>

    <cfif LCase(Left(oneTerm, 4)) is "ip4:">
      <cfset ArrayAppend(res.ip4, Mid(oneTerm, 5, Len(oneTerm) - 4))>

    <cfelseif LCase(Left(oneTerm, 4)) is "ip6:">
      <cfset ArrayAppend(res.ip6, Mid(oneTerm, 5, Len(oneTerm) - 4))>

    <cfelseif LCase(Left(oneTerm, 8)) is "include:">
      <cfset target = Mid(oneTerm, 9, Len(oneTerm) - 8)>
      <cfset sub = expandSpf(target, arguments.bin, res.budget, arguments.seen)>
      <cfset res.budget = sub.budget>
      <cfif NOT sub.ok>
        <!--- A failed include makes the whole expansion untrustworthy. Partial
              ranges are worse than none: they look like a shrunk list. --->
        <cfset res.message = "include " & target & ": " & sub.message>
        <cfreturn res>
      </cfif>
      <cfloop array="#sub.ip4#" index="i"><cfset ArrayAppend(res.ip4, i)></cfloop>
      <cfloop array="#sub.ip6#" index="i"><cfset ArrayAppend(res.ip6, i)></cfloop>

    <cfelseif LCase(Left(oneTerm, 9)) is "redirect=">
      <cfset target = Mid(oneTerm, 10, Len(oneTerm) - 9)>
      <cfset sub = expandSpf(target, arguments.bin, res.budget, arguments.seen)>
      <cfset res.budget = sub.budget>
      <cfif NOT sub.ok>
        <cfset res.message = "redirect " & target & ": " & sub.message>
        <cfreturn res>
      </cfif>
      <cfloop array="#sub.ip4#" index="i"><cfset ArrayAppend(res.ip4, i)></cfloop>
      <cfloop array="#sub.ip6#" index="i"><cfset ArrayAppend(res.ip6, i)></cfloop>
    </cfif>
    <!--- a, mx, ptr, exists are deliberately not expanded. They resolve to
          host addresses rather than published ranges, they change constantly,
          and an alias built from them would churn. --->
  </cfloop>

  <cfset res.ok = true>
  <cfreturn res>
</cffunction>

<!--- ------------------------------------------------------------------
      aliasConsumers: where an alias is referenced, in words.

      A notification that says "the ranges changed" and stops is a notice, not an
      instruction. Nothing applies itself, so the mail has to name the pages the
      admin must go and apply, or they are left to work it out.

      Each consumer adds a clause here as it is adopted.
      ------------------------------------------------------------------ --->
<cffunction name="aliasConsumers" returntype="string" output="false">
  <cfargument name="aliasName" type="string" required="true">
  <cfset var out = []>
  <cfset var relay = "">
  <cfset var pscreen = "">
  <cfset var f2b = "">

  <cfquery name="relay" datasource="hermes">
    SELECT COUNT(*) AS c FROM parameters
    WHERE parent_name = 'mynetworks' AND child = '1' AND network_entry = '2'
      AND parameter = <cfqueryparam value="#arguments.aliasName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif relay.c GT 0>
    <cfset ArrayAppend(out, "Email Relay / Relay Networks")>
  </cfif>

  <cfquery name="pscreen" datasource="hermes">
    SELECT COUNT(*) AS c FROM postscreen_access
    WHERE entry_type = 'alias'
      AND sender = <cfqueryparam value="#arguments.aliasName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif pscreen.c GT 0>
    <cfset ArrayAppend(out, "System / Network Block-Allow")>
  </cfif>

  <cfquery name="f2b" datasource="hermes">
    SELECT COUNT(*) AS c FROM intrusion_prevention_whitelist
    WHERE entry_type = 'alias'
      AND ip_cidr = <cfqueryparam value="#arguments.aliasName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif f2b.c GT 0>
    <cfset ArrayAppend(out, "System / Intrusion Prevention")>
  </cfif>

  <cfreturn ArrayToList(out, ", ")>
</cffunction>

<!--- ==================================================================
      MAIN
      ================================================================== --->
<!---
  Optional ?alias=<id> resolves ONE alias instead of every enabled one. The console
  uses it for the per-alias Resolve button and to resolve immediately when an alias
  is enabled, so an admin never has to wait for the nightly run to see it work.
  Ofelia calls this page with no parameter and gets all of them.
--->
<cfparam name="url.alias" default="0">

<cfquery name="getAliases" datasource="hermes">
  SELECT id, name, source_value
  FROM network_aliases
  WHERE enabled = 1
    AND source_type = 'spf'
    AND source_value IS NOT NULL
    AND source_value <> ''
    <cfif IsNumeric(url.alias) AND url.alias GT 0>
      AND id = <cfqueryparam value="#url.alias#" cfsqltype="cf_sql_integer">
    </cfif>
  ORDER BY name ASC
</cfquery>

<cfloop query="getAliases">
  <cfset thisId = getAliases.id>
  <cfset thisName = getAliases.name>
  <cfset seenHosts = StructNew()>
  <cfset expansion = expandSpf(getAliases.source_value, digBin, 10, seenHosts)>

  <cfif NOT expansion.ok>
    <!--- Rule 1: leave the entries alone. --->
    <cfquery name="markFailed" datasource="hermes">
      UPDATE network_aliases
      SET last_status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">,
          last_message = <cfqueryparam value="#Left(expansion.message, 500)#" cfsqltype="cf_sql_varchar">,
          last_resolved = NOW()
      WHERE id = <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset ArrayAppend(failedAliases, thisName & ": " & expansion.message)>
    <cflog file="hermes" type="warning"
           text="refresh_network_aliases: #thisName# failed, entries left untouched -- #expansion.message#">
    <cfcontinue>
  </cfif>

  <cfif ArrayLen(expansion.ip4) is 0 AND ArrayLen(expansion.ip6) is 0>
    <!--- Resolved cleanly but to nothing. Also rule 1: an empty answer is not
          an instruction to delete every range. --->
    <cfquery name="markEmpty" datasource="hermes">
      UPDATE network_aliases
      SET last_status = <cfqueryparam value="empty" cfsqltype="cf_sql_varchar">,
          last_message = <cfqueryparam value="the record resolved but published no ip4 or ip6 ranges; existing entries were left in place" cfsqltype="cf_sql_varchar">,
          last_resolved = NOW()
      WHERE id = <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset ArrayAppend(failedAliases, thisName & ": resolved to no ranges")>
    <cfcontinue>
  </cfif>

  <!--- What we had before, so the change can be described rather than counted. --->
  <cfquery name="beforeRows" datasource="hermes">
    SELECT cidr FROM network_alias_entries
    WHERE alias_id = <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">
      AND origin = 'resolved'
  </cfquery>
  <cfset beforeList = ValueList(beforeRows.cidr)>

  <cfset nowList = "">
  <cfloop array="#expansion.ip4#" index="oneRange">
    <cfquery name="upsert4" datasource="hermes">
      INSERT INTO network_alias_entries (alias_id, cidr, family, origin, first_seen, last_seen)
      VALUES (
        <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#oneRange#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="ip4" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="resolved" cfsqltype="cf_sql_varchar">,
        NOW(), NOW())
      ON DUPLICATE KEY UPDATE last_seen = NOW()
    </cfquery>
    <cfset nowList = ListAppend(nowList, oneRange)>
  </cfloop>
  <cfloop array="#expansion.ip6#" index="oneRange">
    <cfquery name="upsert6" datasource="hermes">
      INSERT INTO network_alias_entries (alias_id, cidr, family, origin, first_seen, last_seen)
      VALUES (
        <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#oneRange#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="ip6" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="resolved" cfsqltype="cf_sql_varchar">,
        NOW(), NOW())
      ON DUPLICATE KEY UPDATE last_seen = NOW()
    </cfquery>
    <cfset nowList = ListAppend(nowList, oneRange)>
  </cfloop>

  <!--- Rule 3: only resolved rows are reconciled. A range an operator typed
        keeps its origin='manual' and is never removed by a resolve. --->
  <cfquery name="dropVanished" datasource="hermes">
    DELETE FROM network_alias_entries
    WHERE alias_id = <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">
      AND origin = 'resolved'
      AND cidr NOT IN (
        <cfqueryparam value="#nowList#" cfsqltype="cf_sql_varchar" list="true">
      )
  </cfquery>

  <cfquery name="markOk" datasource="hermes">
    UPDATE network_aliases
    SET last_status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">,
        last_message = NULL,
        last_resolved = NOW()
    WHERE id = <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Change detection by set comparison, so the notification can name the
        ranges rather than report a count. A count is not actionable. --->
  <cfset addedRanges = []>
  <cfset removedRanges = []>
  <cfloop list="#nowList#" index="oneRange">
    <cfif NOT ListFindNoCase(beforeList, oneRange)>
      <cfset ArrayAppend(addedRanges, oneRange)>
    </cfif>
  </cfloop>
  <cfloop list="#beforeList#" index="oneRange">
    <cfif NOT ListFindNoCase(nowList, oneRange)>
      <cfset ArrayAppend(removedRanges, oneRange)>
    </cfif>
  </cfloop>

  <cfif ArrayLen(addedRanges) OR ArrayLen(removedRanges)>
    <!--- Stamp the change so the console can keep saying "not applied yet" long
         after this mail has been read and forgotten. The mail is a one-shot;
         network_alias_applied is the thing that persists. --->
    <cfquery name="stampChanged" datasource="hermes">
      UPDATE network_aliases SET ranges_changed_at = NOW(6)
      WHERE id = <cfqueryparam value="#thisId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset ArrayAppend(changedAliases, {
      name      = thisName,
      added     = addedRanges,
      removed   = removedRanges,
      consumers = aliasConsumers(thisName)
    })>
    <cflog file="hermes" type="information"
           text="refresh_network_aliases: #thisName# changed -- #ArrayLen(addedRanges)# added, #ArrayLen(removedRanges)# removed">
  </cfif>
</cfloop>

<!--- ==================================================================
      NOTIFY
      ==================================================================
      On change only. A mail on every clean resolve becomes noise, gets
      filtered, and then the one that mattered is filtered too.

      The email reaches someone who is not logged in. It is not the safety net:
      an email is a one-shot and admin_email goes stale when people leave. The
      dashboard alert in inc/system_alerts.cfm persists until the condition
      clears, which is the property that matters when nothing applies itself.
--->
<cfif ArrayLen(changedAliases) OR ArrayLen(failedAliases)>
  <cfquery name="getAdminEmail" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'admin_email'
  </cfquery>
  <cfquery name="getPostmaster" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'postmaster'
  </cfquery>

  <cfif getAdminEmail.recordcount AND Len(Trim(getAdminEmail.value))
        AND getPostmaster.recordcount AND Len(Trim(getPostmaster.value))>
    <cftry>
      <cfmail from="#getPostmaster.value#"
              to="#getAdminEmail.value#"
              subject="Hermes SEG: network alias ranges changed"
              type="html">
        <h3>Network alias ranges changed</h3>
        <p>
          <strong>Nothing has been applied.</strong> No configuration was regenerated and
          mail flow is unchanged. Each alias below lists the pages that use it: open each
          one and click its Apply button to put the new ranges into effect.
        </p>
        <cfif ArrayLen(changedAliases)>
          <cfloop array="#changedAliases#" index="oneChange">
            <h4><cfoutput>#EncodeForHTML(oneChange.name)#</cfoutput></h4>
            <cfif ArrayLen(oneChange.added)>
              <p>Added:</p>
              <ul><cfloop array="#oneChange.added#" index="r"><li><cfoutput>#EncodeForHTML(r)#</cfoutput></li></cfloop></ul>
            </cfif>
            <cfif ArrayLen(oneChange.removed)>
              <p>No longer published:</p>
              <ul><cfloop array="#oneChange.removed#" index="r"><li><cfoutput>#EncodeForHTML(r)#</cfoutput></li></cfloop></ul>
            </cfif>
            <cfif Len(Trim(oneChange.consumers))>
              <p><strong>Apply on:</strong> <cfoutput>#EncodeForHTML(oneChange.consumers)#</cfoutput></p>
            <cfelse>
              <p><em>Nothing uses this alias yet, so there is nothing to apply.</em></p>
            </cfif>
          </cfloop>
        </cfif>
        <cfif ArrayLen(failedAliases)>
          <h4>Could not be resolved</h4>
          <p>Existing ranges for these were left untouched.</p>
          <ul><cfloop array="#failedAliases#" index="r"><li><cfoutput>#EncodeForHTML(r)#</cfoutput></li></cfloop></ul>
        </cfif>
      </cfmail>
      <cfcatch type="any">
        <cflog file="hermes" type="error"
               text="refresh_network_aliases: cfmail failure: #cfcatch.message#">
      </cfcatch>
    </cftry>
  <cfelse>
    <cflog file="hermes" type="warning"
           text="refresh_network_aliases: ranges changed but admin_email or postmaster is unset, so no mail was sent">
  </cfif>
</cfif>

<cfoutput>{"status":"ok","changed":#ArrayLen(changedAliases)#,"failed":#ArrayLen(failedAliases)#}</cfoutput>
