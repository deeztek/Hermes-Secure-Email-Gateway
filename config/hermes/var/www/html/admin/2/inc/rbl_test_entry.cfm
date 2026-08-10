
<!---
Hermes Secure Email Gateway - RBL Test Entry Action Handler
Performs a live DNS probe against an RBL entry to verify it is responding.
Two-point probe: 2.0.0.127.<hostname> must answer, 1.0.0.127.<hostname> must not.
Returns JSON: {"status":"ok|warn|error|timeout","message":"..."}
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

<!---
  TWO-POINT PROBE

  127.0.0.2 is the conventional "listed" test point that most lists publish.
  127.0.0.1 must never be listed by any list, so an answer there means the
  zone wildcards every query and will score every connecting IP.

  A single probe cannot tell a healthy list from a wildcarded one, which is
  why both points are needed. It also cannot tell a live answer from a coded
  refusal: lists in the 127.255.255.0/24 range are error codes, not hits, and
  the previous version of this handler accepted any answer beginning "12" as
  success. On a gateway whose resolver was being refused, that reported the
  refusal code as live data.

  WHERE THE PROBE RUNS, AND WHY NOT VIA docker exec ANY MORE

  This used to shell out to `docker exec hermes_postfix_dkim dig`, on the
  reasoning that Postfix's own container is the honest place to ask. The
  postfix-dkim image has never contained dnsutils, so `dig` was not there and
  every probe failed with an OCI "executable file not found" error.

  That failure was invisible, and worse than invisible. Neither probe captured
  stderr, so Lucee folded docker's error message into the output variable. The
  SOA fallback only tested `Len(Trim(output)) GT 0`, and the error text is not
  empty, so it read as a successful SOA lookup. The original handler therefore
  reported EVERY list as green "Zone active (SOA)", and the first version of
  this rewrite reported every list as yellow "No Data", on gateways where no DNS
  query had actually been made at all.

  So: run dig locally. The CFML runs inside hermes_commandbox, which has
  dnsutils and is pointed at hermes_unbound by compose (dns: <subnet>.117), so a
  local dig resolves through exactly the same resolver Postfix uses. The source
  address the block list sees is unbound's egress either way, because unbound
  performs the outbound query; the asking container never talks to the list. The
  old comment's worry about "the CommandBox JVM resolver" is a different thing
  entirely: that is java.net.InetAddress, not the dig binary, and it is not in
  play here.

  Every cfexecute now captures stderr separately and no probe ever treats stderr
  as data. Missing dig is reported as its own verdict instead of being laundered
  into a DNS result.

  Probe 3 (SOA) runs only when the listed point returned nothing, to separate
  "the zone is gone" from "the zone is there but no data reached us". SOA
  rather than NS, because NS delegation records persist after a zone dies. Its
  output is validated as an actual SOA record (the five trailing timers) rather
  than merely being non-empty, which is the check that failed above.
--->
<cfset digBin = "/usr/bin/dig">

<cfif NOT FileExists(digBin)>
  <cfoutput>{"status":"error","message":"#JSStringFormat(digBin)# is not present in this container, so no DNS probe can be made. Install dnsutils in the commandbox image."}</cfoutput>
  <cfabort>
</cfif>

<cfset testQuery    = "2.0.0.127." & testHost>
<cfset controlQuery = "1.0.0.127." & testHost>

<cfset threadName = "rbltest_" & Replace(CreateUUID(), "-", "", "ALL")>

<cfthread action="run" name="#threadName#" digBin="#digBin#"
          testQuery="#testQuery#" controlQuery="#controlQuery#" testHost="#testHost#">

  <cfset thread.verdict = "error">
  <cfset thread.detail  = "Zone not found or unreachable">

  <cfset nlDelims  = Chr(10) & Chr(13)>
  <cfset ipPattern = "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">
  <cfset listedIPs  = "">
  <cfset controlIPs = "">
  <cfset listedOut  = "">
  <cfset controlOut = "">
  <cfset probeErr   = "">

  <!--- Probe 1: the listed test point. Should answer 127.0.0.2 and friends.
       stderr goes to its own variable so it can never be mistaken for an
       answer, which is the defect that made this handler report every list as
       healthy on a box where dig was not even present. --->
  <cftry>
    <cfexecute name="#attributes.digBin#"
      arguments="+short +time=3 +tries=1 A #attributes.testQuery#"
      variable="listedOut"
      errorVariable="listedErr"
      timeout="8" />
    <cfloop list="#Trim(listedOut)#" index="ln" delimiters="#nlDelims#">
      <cfif REFind(ipPattern, Trim(ln))>
        <cfset listedIPs = ListAppend(listedIPs, Trim(ln))>
      </cfif>
    </cfloop>
    <cfif Len(Trim(listedErr))>
      <cfset probeErr = Trim(listedErr)>
    </cfif>
    <cfcatch type="any">
      <cfset probeErr = cfcatch.message>
    </cfcatch>
  </cftry>

  <!--- Probe 2: the control point, 127.0.0.1, which no list should ever list. --->
  <cftry>
    <cfexecute name="#attributes.digBin#"
      arguments="+short +time=3 +tries=1 A #attributes.controlQuery#"
      variable="controlOut"
      errorVariable="controlErr"
      timeout="8" />
    <cfloop list="#Trim(controlOut)#" index="ln" delimiters="#nlDelims#">
      <cfif REFind(ipPattern, Trim(ln))>
        <cfset controlIPs = ListAppend(controlIPs, Trim(ln))>
      </cfif>
    </cfloop>
    <cfcatch type="any">
      <cfset probeErr = cfcatch.message>
    </cfcatch>
  </cftry>

  <!--- Wildcard is checked first, because such a zone answers the listed point
       too and would otherwise be reported as healthy.

       But "the control point answered" is NOT on its own a wildcard, and taking
       it as one was wrong. Reputation services return a verdict for EVERY query
       rather than only for listed senders: hostkarma.junkemailfilter.com answers
       127.0.0.1 white, 127.0.0.2 black, 127.0.1.x brown, and answers both test
       points with different code sets. Flagging that as a wildcard marked a
       perfectly healthy service as broken, while pure block lists like
       zen.spamhaus.org and allow lists like list.dnswl.org passed, because they
       only answer for genuinely listed senders.

       The distinction is discrimination. A wildcarded or hijacked zone returns
       the SAME answer to everything; that is what makes it dangerous, since
       every connecting IP scores identically. A zone returning different answers
       for different queries is doing its job. So: wildcard means the control
       point answered AND returned exactly what the listed point returned.

       Compared as sorted sets, because these services legitimately return
       several records for one query. --->
  <cfset listedSorted  = ListSort(listedIPs,  "text", "asc")>
  <cfset controlSorted = ListSort(controlIPs, "text", "asc")>

  <cfif ListLen(controlIPs) GT 0 AND controlSorted IS listedSorted>
    <cfset thread.verdict = "error">
    <cfset thread.detail  = "Wildcard: 127.0.0.1 and 127.0.0.2 both answered "
        & Replace(controlSorted, ",", ", ", "all")
        & ". This zone returns the same answer for every query, so it will score all mail "
        & "identically. Remove this entry.">

  <cfelseif ListLen(controlIPs) GT 0 AND ListLen(listedIPs) IS 0>
    <!--- Inverted: the never-listed address answers while the always-listed one
         does not. Not a wildcard, but not trustworthy either. --->
    <cfset thread.verdict = "error">
    <cfset thread.detail  = "Inverted responses: 127.0.0.1, which must never be listed, answered "
        & Replace(controlSorted, ",", ", ", "all")
        & " while the 127.0.0.2 test point returned nothing. Do not rely on this entry.">

  <cfelseif ListLen(listedIPs) GT 0>
    <cfset refusalIP = "">
    <cfset offZoneIP = "">
    <cfloop list="#listedIPs#" index="ip">
      <cfif Left(ip, 12) IS "127.255.255.">
        <cfset refusalIP = ip>
      <cfelseif Left(ip, 4) IS NOT "127.">
        <cfset offZoneIP = ip>
      </cfif>
    </cfloop>

    <cfif Len(refusalIP)>
      <cfset why = "The list refused the query and returned no reputation data.">
      <cfif refusalIP IS "127.255.255.254">
        <cfset why = "Refused as an open or public resolver. See System / DNS Resolver; recursive mode avoids this.">
      <cfelseif refusalIP IS "127.255.255.255">
        <cfset why = "Blocked, or over the anonymous query quota for this source IP.">
      <cfelseif refusalIP IS "127.255.255.253">
        <cfset why = "Refused: no reverse DNS, or the querying resolver is not registered.">
      <cfelseif refusalIP IS "127.255.255.252">
        <cfset why = "Query prohibited: malformed query, or the querying resolver is not registered.">
      </cfif>
      <cfset thread.verdict = "error">
      <cfset thread.detail  = "Refused (" & refusalIP & "). " & why>

    <cfelseif Len(offZoneIP)>
      <cfset thread.verdict = "error">
      <cfset thread.detail  = "Unexpected answer " & offZoneIP
          & " outside 127.0.0.0/8. The zone may be parked or hijacked. Remove this entry.">

    <cfelse>
      <cfset thread.verdict = "ok">
      <cfset thread.detail  = "Data returned: " & Replace(listedIPs, ",", ", ", "all")>
    </cfif>

  <cfelseif Len(probeErr)>
    <!--- The probe itself failed. Report that, rather than turning a broken
         tool into a statement about the block list. --->
    <cfset thread.verdict = "error">
    <cfset thread.detail  = "The DNS probe could not run, so this list's status is unknown: " & probeErr>

  <cfelse>
    <!--- Probe 3: nothing came back. Is the zone still there at all?
         The output is validated as a real SOA record, by its five trailing
         timers, rather than merely being non-empty. A bare non-empty test is
         what previously let an error message masquerade as a live zone. --->
    <cfset soaOut = "">
    <cftry>
      <cfexecute name="#attributes.digBin#"
        arguments="+short +time=3 +tries=1 SOA #attributes.testHost#"
        variable="soaOut"
        errorVariable="soaErr"
        timeout="8" />
      <cfif REFind("[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+", Trim(soaOut))>
        <cfset thread.verdict = "warn">
        <cfset thread.detail  = "Zone resolves (SOA) but the 127.0.0.2 test point returned no data. "
            & "Either this list publishes no test entry, or its answers are not reaching us. "
            & "Verify before relying on this entry.">
      </cfif>
      <cfcatch type="any">
      </cfcatch>
    </cftry>
  </cfif>
</cfthread>

<!--- Up to three sequential 8s probes, so the join has to outlast them. --->
<cfthread action="join" name="#threadName#" timeout="26000">

<cfset t = cfthread[threadName]>

<cfif t.status IS "COMPLETED">
  <cfoutput>{"status":"#JSStringFormat(t.verdict)#","message":"#JSStringFormat(t.detail)#"}</cfoutput>
<cfelse>
  <cfoutput>{"status":"timeout","message":"DNS lookup timed out"}</cfoutput>
</cfif>

<cfabort>
