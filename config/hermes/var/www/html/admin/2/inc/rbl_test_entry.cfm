
<!---
Hermes Secure Email Gateway - RBL Test Entry Action Handler
Performs a live DNS probe against an RBL entry to verify it is responding.
Standard DNSBL test: query 2.0.0.127.<hostname> (127.0.0.2 reversed).
Returns JSON: {"status":"ok|error|timeout","message":"..."}
Expects: url.id
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<cfcontent type="application/json">

<cfif NOT StructKeyExists(url, "id") OR NOT IsNumeric(url.id)>
  <cfoutput>{"status":"error","message":"Invalid request"}</cfoutput>
  <cfabort>
</cfif>

<!--- Get the entry from DB --->
<cfquery name="getEntry" datasource="hermes">
  SELECT parameter FROM parameters
  WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    AND child = '1'
</cfquery>

<cfif getEntry.recordCount IS 0>
  <cfoutput>{"status":"error","message":"Entry not found"}</cfoutput>
  <cfabort>
</cfif>

<!--- Extract plain hostname (strip *weight and =returncode suffixes) --->
<cfset testHost = getEntry.parameter>
<cfset lastStar = Find("*", Reverse(testHost))>
<cfif lastStar GT 0>
  <cfset testHost = Left(testHost, Len(testHost) - lastStar)>
</cfif>
<cfset eqPos = Find("=", testHost)>
<cfif eqPos GT 0>
  <cfset testHost = Left(testHost, eqPos - 1)>
</cfif>

<!--- Standard DNSBL test: 2.0.0.127.<hostname> (127.0.0.2 reversed) --->
<cfset testQuery = "2.0.0.127." & testHost>

<!---
  Both stages use docker exec dig in hermes_postfix_dkim — the same DNS resolver
  and source IP that Postfix uses for actual DNSBL queries. The CommandBox JVM
  resolver cannot reach DNSBL servers reliably.

  Stage 1: dig A 2.0.0.127.<host> — if resolves, zone is actively serving data.
  Stage 2: dig SOA <host> — if SOA found, zone infrastructure exists but data
           unconfirmed. SOA (not NS) because NS delegation records persist even
           after a zone goes dead.
--->
<cfset threadName = "rbltest_" & Replace(CreateUUID(), "-", "", "ALL")>

<cfthread action="run" name="#threadName#" testQuery="#testQuery#" testHost="#testHost#">
  <cfset thread.success = false>
  <cfset thread.zoneExists = false>
  <cfset thread.ip = "">

  <!--- Stage 1: DNSBL test IP lookup via postfix container DNS --->
  <cftry>
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim dig +short +time=3 +tries=1 A #attributes.testQuery#"
      variable="stage1Output"
      timeout="8" />
    <cfset stage1Output = Trim(stage1Output)>
    <cfif Len(stage1Output) GT 0 AND Left(stage1Output, 2) IS "12">
      <cfset thread.ip = ListFirst(stage1Output, Chr(10))>
      <cfset thread.success = true>
    </cfif>
    <cfcatch type="any">
    </cfcatch>
  </cftry>

  <!--- Stage 2: SOA check via postfix container DNS --->
  <cfif NOT thread.success>
    <cftry>
      <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim dig +short +time=3 +tries=1 SOA #attributes.testHost#"
        variable="stage2Output"
        timeout="8" />
      <cfset thread.zoneExists = (Len(Trim(stage2Output)) GT 0)>
      <cfcatch type="any">
        <cfset thread.zoneExists = false>
      </cfcatch>
    </cftry>
  </cfif>
</cfthread>

<cfthread action="join" name="#threadName#" timeout="10000">

<cfset t = cfthread[threadName]>

<cfif t.status IS "COMPLETED">
  <cfif t.success>
    <cfoutput>{"status":"ok","message":"#JSStringFormat(t.ip)#"}</cfoutput>
  <cfelseif t.zoneExists>
    <cfoutput>{"status":"ok","message":"Zone active (SOA)"}</cfoutput>
  <cfelse>
    <cfoutput>{"status":"error","message":"Zone not found or unreachable"}</cfoutput>
  </cfif>
<cfelse>
  <cfoutput>{"status":"timeout","message":"DNS lookup timed out"}</cfoutput>
</cfif>

<cfabort>
