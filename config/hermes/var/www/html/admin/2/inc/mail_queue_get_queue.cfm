<!---
Hermes Secure Email Gateway - Mail Queue: Get Queue (In-Memory)
Runs mailq via docker exec, parses output directly into a CFML query object.
No temp files, no database round-trip.
Sets: getqueue (query), mailqueuelimit (boolean)
--->

<cfset mailqueuelimit = 0>
<cfset mailqueueoverload = false>
<cfset mailqueuetotalcount = 0>
<cfset maxQueueDisplay = 100>
<cfset maxQueueLoad = 500>

<!--- Quick count: get just the summary line from mailq --->
<cftry>
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_postfix_dkim /bin/bash -c '/usr/bin/mailq | /usr/bin/tail -1'"
    timeout="60"
    variable="mailqSummary"
    errorVariable="mailqSummaryError" />
  <cfcatch type="any">
    <cfset mailqSummary = "Mail queue is empty">
  </cfcatch>
</cftry>

<!--- Parse request count from summary: "-- 1234 Kbytes in 567 Requests." --->
<cfif mailqSummary contains "Requests">
  <cfset summaryMatch = REFind("in\s+(\d+)\s+Request", mailqSummary, 1, true)>
  <cfif summaryMatch.pos[1] GT 0>
    <cfset mailqueuetotalcount = Mid(mailqSummary, summaryMatch.pos[2], summaryMatch.len[2])>
  </cfif>
</cfif>

<!--- Build query object --->
<cfset getqueue = QueryNew("QueueID,Sender,Recipient,ConnectionStatus,MsgStatus", "varchar,varchar,varchar,varchar,varchar")>

<cfif mailqSummary contains "Mail queue is empty">
  <!--- Empty queue, getqueue has 0 rows --->

<cfelseif Val(mailqueuetotalcount) GT maxQueueLoad>
  <!--- Queue exceeds load threshold — don't attempt to parse --->
  <cfset mailqueueoverload = true>

<cfelse>
  <!--- Queue is within threshold — load and parse --->
  <cftry>
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim /usr/bin/mailq"
      timeout="240"
      variable="mailqOutput"
      errorVariable="mailqError" />
    <cfcatch type="any">
      <cfset mailqOutput = "Mail queue is empty">
    </cfcatch>
  </cftry>

  <!--- Parse mailq output --->
  <!---
  mailq output format:
  A1B2C3D4E5*   1234 Mon Mar 22 10:00:00  sender@example.com
                           (connect to smtp.example.com: Connection refused)
                                           recipient@example.com

  Queue ID ends with * (active), ! (hold), or nothing
  --->

  <!--- includeEmptyFields=true preserves blank lines between queue entries --->
  <cfset lines = ListToArray(mailqOutput, Chr(10), true)>
  <cfset totalParsed = 0>
  <cfset lineIdx = 1>

  <cfloop condition="lineIdx LTE ArrayLen(lines) AND totalParsed LT maxQueueDisplay">
    <cfset line = lines[lineIdx]>

    <!--- Queue entries start with a hex ID at position 1 --->
    <cfif REFind("^[A-F0-9]", line)>
      <!--- Extract queue ID (first token) --->
      <cfset rawId = trim(ListFirst(line, " "))>
      <cfset msgStatus = "N/A">

      <!--- Check for hold (!) or active (*) markers --->
      <cfif Right(rawId, 1) is "!">
        <cfset msgStatus = "ON-HOLD">
        <cfset queueId = Left(rawId, Len(rawId) - 1)>
      <cfelseif Right(rawId, 1) is "*">
        <cfset msgStatus = "ACTIVE">
        <cfset queueId = Left(rawId, Len(rawId) - 1)>
      <cfelse>
        <cfset queueId = rawId>
      </cfif>

      <!--- Sender is the last token on this line --->
      <cfset tokens = ListToArray(line, " ")>
      <cfset sender = tokens[ArrayLen(tokens)]>

      <!--- Next line(s): connection status (indented, in parentheses) and recipients --->
      <cfset connStatus = "">
      <cfset recipients = []>

      <cfset lineIdx = lineIdx + 1>
      <cfloop condition="lineIdx LTE ArrayLen(lines)">
        <cfset nextLine = lines[lineIdx]>

        <!--- Empty line = end of this queue entry --->
        <cfif trim(nextLine) is "">
          <cfset lineIdx = lineIdx + 1>
          <cfbreak>
        </cfif>

        <!--- New queue entry header = end of current entry (don't advance lineIdx) --->
        <cfif REFind("^[A-F0-9]", nextLine)>
          <cfbreak>
        </cfif>

        <cfset nextLine = trim(nextLine)>

        <!--- Connection status line starts with ( --->
        <cfif Left(nextLine, 1) is "(">
          <cfset connStatus = nextLine>
          <cfset lineIdx = lineIdx + 1>

        <!--- Summary line at bottom (-- X Kbytes in Y Requests.) --->
        <cfelseif Left(nextLine, 2) is "--">
          <cfset lineIdx = lineIdx + 1>
          <cfbreak>

        <!--- Recipient line (email address) --->
        <cfelseif REFind("^[^ (]", nextLine)>
          <cfset ArrayAppend(recipients, nextLine)>
          <cfset lineIdx = lineIdx + 1>

        <cfelse>
          <cfset lineIdx = lineIdx + 1>
        </cfif>
      </cfloop>

      <!--- Add row to query (join multiple recipients with comma) --->
      <cfset QueryAddRow(getqueue)>
      <cfset QuerySetCell(getqueue, "QueueID", queueId)>
      <cfset QuerySetCell(getqueue, "Sender", sender)>
      <cfset QuerySetCell(getqueue, "Recipient", ArrayToList(recipients, ", "))>
      <cfset QuerySetCell(getqueue, "ConnectionStatus", connStatus)>
      <cfset QuerySetCell(getqueue, "MsgStatus", msgStatus)>

      <cfset totalParsed = totalParsed + 1>
    <cfelse>
      <cfset lineIdx = lineIdx + 1>
    </cfif>
  </cfloop>

  <!--- Check if we hit the limit --->
  <cfif lineIdx LT ArrayLen(lines)>
    <!--- There are more entries we didn't parse --->
    <cfset mailqueuelimit = 1>
  </cfif>
</cfif>
