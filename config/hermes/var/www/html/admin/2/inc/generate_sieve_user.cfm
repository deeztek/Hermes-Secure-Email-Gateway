
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE USER SIEVE SCRIPT
Reads all enabled personal sieve rules (with multi-condition/multi-action
children) for a specific user and generates their personal sieve script at
/mnt/data/sieve/users/{user}.sieve. Compiles via sievec inside hermes_dovecot.

Requires: sieveUsername variable to be set before including.
--->

<cfinclude template="sieve_helpers.cfm">

<cfquery name="getUserRules" datasource="hermes">
    SELECT id, rule_name, match_type
    FROM sieve_rules
    WHERE scope = 'user'
      AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
      AND enabled = 1
    ORDER BY rule_order ASC
</cfquery>

<cfset ruleIds = ValueList(getUserRules.id)>
<cfif ruleIds EQ "">
    <cfset ruleIds = "0">
</cfif>

<cfquery name="allConditions" datasource="hermes">
    SELECT rule_id, condition_field, condition_type, condition_value
    FROM sieve_rule_conditions
    WHERE rule_id IN (<cfqueryparam value="#ruleIds#" cfsqltype="cf_sql_integer" list="yes">)
    ORDER BY rule_id ASC, condition_order ASC, id ASC
</cfquery>

<cfquery name="allActions" datasource="hermes">
    SELECT rule_id, action_type, action_value
    FROM sieve_rule_actions
    WHERE rule_id IN (<cfqueryparam value="#ruleIds#" cfsqltype="cf_sql_integer" list="yes">)
    ORDER BY rule_id ASC, action_order ASC, id ASC
</cfquery>

<cfset needsFileinto = false>
<cfset needsImap4flags = false>
<cfset needsReject = false>
<cfset needsVacation = false>

<cfloop query="allActions">
    <cfif action_type EQ "fileinto">
        <cfset needsFileinto = true>
    <cfelseif action_type EQ "flag_seen">
        <cfset needsImap4flags = true>
    <cfelseif action_type EQ "reject">
        <cfset needsReject = true>
    </cfif>
</cfloop>

<!--- Vacation auto-reply: load row from user_vacation if active.
     Active = enabled=1 AND (start_date NULL OR <= today)
                       AND (end_date   NULL OR >= today)
     The DB filter handles automatic deactivation by date so we don't have
     to clear the enabled flag on a schedule. --->
<cfset vacationActive = false>
<cfset vacationSubject = "">
<cfset vacationBody = "">
<cfset vacationDays = 7>
<cfset vacationExternal = false>
<cfset vacationInternalDomains = []>
<cfset vacationAddresses = []>
<cfset vacationDiscard = false>
<cfset vacationStartUTC = "">
<cfset vacationEndUTC = "">

<!--- NOTE: We no longer filter by start/end date in SQL. The date check is
     done at message-delivery time inside the sieve script via the currentdate
     extension, so the .sieve file stays correct without a scheduled job
     re-running this generator daily. The only filter here is "enabled". --->
<cfquery name="getVacation" datasource="hermes">
    SELECT subject, body, reply_interval_days, reply_external, reply_addresses, discard_incoming, start_date, end_date
    FROM user_vacation
    WHERE username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
      AND enabled = 1
</cfquery>
<cfif getVacation.recordcount GTE 1>
    <cfset vacationActive = true>
    <cfset vacationSubject = (getVacation.subject NEQ "") ? getVacation.subject : "Out of office">
    <cfset vacationBody = getVacation.body>
    <cfset vacationDays = (Val(getVacation.reply_interval_days) GT 0) ? Val(getVacation.reply_interval_days) : 7>
    <cfset vacationExternal = (Val(getVacation.reply_external) EQ 1)>
    <cfset vacationDiscard = (Val(getVacation.discard_incoming) EQ 1)>
    <cfset needsVacation = true>

    <!--- Load the user's timezone and convert start/end (stored as user-local
         in DB but we treat them as the user's local wall clock) to UTC for
         the currentdate :iso8601 comparison in sieve. Pigeonhole evaluates
         currentdate :iso8601 in UTC regardless of container TZ, so this
         comparison is timezone-safe. --->
    <cfinclude template="get_user_timezone.cfm">
    <cfset userTz = getUserTimezone(sieveUsername)>

    <cfif IsDate(getVacation.start_date)>
        <cftry>
            <cfset vacationStartUTC = convertToUTC(
                DateFormat(getVacation.start_date, "yyyy-mm-dd") & " " & TimeFormat(getVacation.start_date, "HH:mm:ss"),
                userTz)>
        <cfcatch type="any">
            <cfset vacationStartUTC = "">
        </cfcatch>
        </cftry>
    </cfif>
    <cfif IsDate(getVacation.end_date)>
        <cftry>
            <cfset vacationEndUTC = convertToUTC(
                DateFormat(getVacation.end_date, "yyyy-mm-dd") & " " & TimeFormat(getVacation.end_date, "HH:mm:ss"),
                userTz)>
        <cfcatch type="any">
            <cfset vacationEndUTC = "">
        </cfcatch>
        </cftry>
    </cfif>

    <!--- Parse comma-separated reply_addresses list --->
    <cfif getVacation.reply_addresses NEQ "">
        <cfloop list="#getVacation.reply_addresses#" index="addr">
            <cfset addr = trim(addr)>
            <cfif addr NEQ "">
                <cfset ArrayAppend(vacationAddresses, addr)>
            </cfif>
        </cfloop>
    </cfif>

    <!--- When NOT replying to external addresses, load all locally hosted
         domains (mailbox + relay) so the generator can wrap the vacation
         block in an `if address :domain :is "From" [<list>]` check. --->
    <cfif NOT vacationExternal>
        <cfquery name="getInternalDomains" datasource="hermes">
            SELECT DISTINCT LCASE(domain) AS domain
            FROM domains
            ORDER BY domain
        </cfquery>
        <cfloop query="getInternalDomains">
            <cfset ArrayAppend(vacationInternalDomains, getInternalDomains.domain)>
        </cfloop>
    </cfif>
</cfif>

<cfset sieveLines = []>
<cfset ArrayAppend(sieveLines, "## Hermes SEG Personal Sieve Rules for #sieveUsername# (auto-generated)")>
<cfset ArrayAppend(sieveLines, "## Do not edit manually - changes will be overwritten")>
<cfset ArrayAppend(sieveLines, "## Generated: #DateTimeFormat(Now(), 'yyyy-MM-dd HH:nn:ss')#")>
<cfset ArrayAppend(sieveLines, "")>

<cfset requires = []>
<cfif needsFileinto>
    <cfset ArrayAppend(requires, '"fileinto"')>
    <cfset ArrayAppend(requires, '"mailbox"')>
</cfif>
<cfif needsImap4flags><cfset ArrayAppend(requires, '"imap4flags"')></cfif>
<cfif needsReject><cfset ArrayAppend(requires, '"reject"')></cfif>
<cfif needsVacation>
    <cfset ArrayAppend(requires, '"vacation"')>
    <!--- "date" extension provides currentdate test for time-window checks.
         "relational" extension is required for the :value match-type with
         "ge"/"le" comparators (RFC 5231) - without it Pigeonhole errors with
         "unknown tagged argument ':value' for the currentdate test". --->
    <cfif vacationStartUTC NEQ "" OR vacationEndUTC NEQ "">
        <cfset ArrayAppend(requires, '"date"')>
        <cfset ArrayAppend(requires, '"relational"')>
    </cfif>
</cfif>

<cfif ArrayLen(requires) GT 0>
    <cfset ArrayAppend(sieveLines, 'require [#ArrayToList(requires, ", ")#];')>
    <cfset ArrayAppend(sieveLines, "")>
</cfif>

<!--- Vacation block. Must come before fileinto rules so the auto-reply
     fires regardless of how the message is filed. Sieve "vacation" has
     built-in protection against mailing lists, bulk mail, and reply loops
     via Auto-Submitted/Precedence headers per RFC 5230 - no extra guards
     needed for those.

     Internal-only mode (default): wrap the vacation action in an
     `if address :domain :is "From" [<hosted domains>]` check using the
     "envelope" extension's :domain match part. Only fires when the From
     header's domain is one of our locally hosted domains. --->
<cfif vacationActive>
    <cfset ArrayAppend(sieveLines, "## Vacation auto-reply")>

    <!--- Build the optional `:addresses` parameter line. --->
    <cfset addrParam = "">
    <cfif ArrayLen(vacationAddresses) GT 0>
        <cfset addrQuoted = []>
        <cfloop array="#vacationAddresses#" index="a">
            <cfset ArrayAppend(addrQuoted, '"' & sieveEscape(a) & '"')>
        </cfloop>
        <cfset addrParam = ":addresses [" & ArrayToList(addrQuoted, ", ") & "]">
    </cfif>

    <!--- Build the date-window guard tests using `currentdate :iso8601`.
         Pigeonhole evaluates these in UTC at message-delivery time, so the
         comparison is correct regardless of how the user's timezone changes
         after the script was generated. --->
    <cfset dateTests = []>
    <cfif vacationStartUTC NEQ "">
        <cfset ArrayAppend(dateTests, 'currentdate :value "ge" "iso8601" "#vacationStartUTC#"')>
    </cfif>
    <cfif vacationEndUTC NEQ "">
        <cfset ArrayAppend(dateTests, 'currentdate :value "le" "iso8601" "#vacationEndUTC#"')>
    </cfif>

    <cfset useDateGuard = ArrayLen(dateTests) GT 0>
    <cfset useDomainGuard = (NOT vacationExternal) AND ArrayLen(vacationInternalDomains) GT 0>

    <cfset outerIndent = "">
    <cfif useDateGuard>
        <cfif ArrayLen(dateTests) EQ 1>
            <cfset ArrayAppend(sieveLines, "if " & dateTests[1] & " {")>
        <cfelse>
            <cfset ArrayAppend(sieveLines, "if allof (")>
            <cfset ArrayAppend(sieveLines, "    " & dateTests[1] & ",")>
            <cfset ArrayAppend(sieveLines, "    " & dateTests[2])>
            <cfset ArrayAppend(sieveLines, ") {")>
        </cfif>
        <cfset outerIndent = "    ">
    </cfif>

    <!--- Auto-reply block: the vacation action itself is gated by the
         optional domain guard. The domain guard limits WHO gets a reply
         (default: only senders from locally hosted domains, to avoid
         leaking OOO messages to spammers and prevent mail loops), but it
         does NOT gate the discard below — those are independent concerns. --->
    <cfset vacIndent = outerIndent>
    <cfif useDomainGuard>
        <cfset domQuoted = []>
        <cfloop array="#vacationInternalDomains#" index="d">
            <cfset ArrayAppend(domQuoted, '"' & sieveEscape(d) & '"')>
        </cfloop>
        <cfset ArrayAppend(sieveLines, outerIndent & 'if address :domain :is "From" [#ArrayToList(domQuoted, ", ")#] {')>
        <cfset vacIndent = outerIndent & "    ">
    </cfif>

    <cfset ArrayAppend(sieveLines, vacIndent & "vacation")>
    <cfset ArrayAppend(sieveLines, vacIndent & "    :days #vacationDays#")>
    <cfif addrParam NEQ "">
        <cfset ArrayAppend(sieveLines, vacIndent & "    " & addrParam)>
    </cfif>
    <cfset ArrayAppend(sieveLines, vacIndent & '    :subject "#sieveEscape(vacationSubject)#"')>
    <cfset ArrayAppend(sieveLines, vacIndent & '    "#sieveEscape(vacationBody)#";')>

    <cfif useDomainGuard>
        <cfset ArrayAppend(sieveLines, outerIndent & "}")>
    </cfif>

    <!--- Discard-while-away block: fires for EVERY message during the
         vacation window, independent of sender. Domain guard does not
         apply here — "delete incoming during vacation" is a blanket
         intent; if it were gated by the internal-sender check it would
         skip the 99% of incoming mail that originates externally.
         discard cancels the implicit INBOX keep; stop halts the personal
         script so no user fileinto/redirect rules run afterward. The
         global sieve_before script has already run and is unaffected. --->
    <cfif vacationDiscard>
        <cfset ArrayAppend(sieveLines, outerIndent & "discard;")>
        <cfset ArrayAppend(sieveLines, outerIndent & "stop;")>
    </cfif>

    <cfif useDateGuard>
        <cfset ArrayAppend(sieveLines, "}")>
    </cfif>
    <cfset ArrayAppend(sieveLines, "")>
</cfif>

<cfloop query="getUserRules">
    <cfset ruleId = getUserRules.id>
    <cfset matchType = getUserRules.match_type>

    <cfset condArr = []>
    <cfset hasAllCondition = false>
    <cfloop query="allConditions">
        <cfif allConditions.rule_id EQ ruleId>
            <cfif allConditions.condition_field EQ "all">
                <cfset hasAllCondition = true>
            <cfelse>
                <cfset condStr = buildSieveCondition(allConditions.condition_field, allConditions.condition_type, allConditions.condition_value)>
                <cfif condStr NEQ "">
                    <cfset ArrayAppend(condArr, condStr)>
                </cfif>
            </cfif>
        </cfif>
    </cfloop>

    <!--- User actions: enable :create on fileinto so folders are auto-created --->
    <cfset actArr = []>
    <cfloop query="allActions">
        <cfif allActions.rule_id EQ ruleId>
            <cfset actStr = buildSieveAction(allActions.action_type, allActions.action_value, true)>
            <cfif actStr NEQ "">
                <cfset ArrayAppend(actArr, actStr)>
            </cfif>
        </cfif>
    </cfloop>

    <cfif ArrayLen(actArr) EQ 0>
        <cfcontinue>
    </cfif>

    <cfset ArrayAppend(sieveLines, "## Rule: #getUserRules.rule_name#")>

    <cfif hasAllCondition OR ArrayLen(condArr) EQ 0>
        <cfloop array="#actArr#" index="a">
            <cfset ArrayAppend(sieveLines, a)>
        </cfloop>
    <cfelseif ArrayLen(condArr) EQ 1>
        <cfset ArrayAppend(sieveLines, "if #condArr[1]# {")>
        <cfloop array="#actArr#" index="a">
            <cfset ArrayAppend(sieveLines, "    #a#")>
        </cfloop>
        <cfset ArrayAppend(sieveLines, "}")>
    <cfelse>
        <cfset matchKw = (matchType EQ "any") ? "anyof" : "allof">
        <cfset ArrayAppend(sieveLines, "if #matchKw# (#ArrayToList(condArr, ', ')#) {")>
        <cfloop array="#actArr#" index="a">
            <cfset ArrayAppend(sieveLines, "    #a#")>
        </cfloop>
        <cfset ArrayAppend(sieveLines, "}")>
    </cfif>
    <cfset ArrayAppend(sieveLines, "")>
</cfloop>

<cfset sieveContent = ArrayToList(sieveLines, Chr(10))>

<cfif NOT DirectoryExists("/mnt/data/sieve/users")>
    <cfdirectory action="create" directory="/mnt/data/sieve/users" mode="755" recurse="true">
</cfif>

<cffile action="write"
    file="/mnt/data/sieve/users/#sieveUsername#.sieve"
    output="#sieveContent#"
    charset="utf-8"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot chown 1000:1000 /srv/sieve/users/#sieveUsername#.sieve"
        timeout="30" />
<cfcatch type="any">
</cfcatch>
</cftry>

<!--- Compile via sievec. Capture stderr - non-empty means compile failed.
     Log to sieve_compile_log and surface via request.sieveCompileError. --->
<cfset request.sieveCompileError = "">
<cftry>
    <cfset sievecOutput = "">
    <cfset sievecError = "">
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot sievec /srv/sieve/users/#sieveUsername#.sieve"
        variable="sievecOutput"
        errorVariable="sievecError"
        timeout="30" />
    <cfif IsDefined("sievecError") AND Len(trim(sievecError)) GT 0>
        <cfset request.sieveCompileError = trim(sievecError)>
        <cftry>
            <cfquery datasource="hermes">
                INSERT INTO sieve_compile_log (scope, username, rule_id, error_text)
                VALUES (
                    'user',
                    <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">,
                    NULL,
                    <cfqueryparam value="#request.sieveCompileError#" cfsqltype="cf_sql_longvarchar">
                )
            </cfquery>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
<cfcatch type="any">
    <cfset request.sieveCompileError = "sievec execution error: " & cfcatch.message>
</cfcatch>
</cftry>
