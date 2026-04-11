
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE GLOBAL SIEVE SCRIPT
Reads all enabled global sieve rules (with their multi-condition/multi-action
children) from the database and generates the sieve_before script at
/mnt/data/sieve/global/before.sieve. After writing, compiles the script using
sievec via Docker exec.
--->

<cfinclude template="sieve_helpers.cfm">

<!--- Get all enabled global rules ordered by rule_order --->
<cfquery name="getGlobalRules" datasource="hermes">
    SELECT id, rule_name, match_type
    FROM sieve_rules
    WHERE scope = 'global' AND enabled = 1
    ORDER BY rule_order ASC
</cfquery>

<!--- Pre-load all conditions and actions for these rules.
     Use cfqueryparam list="yes" so the IN clause is parameterized
     (defense in depth even though ids come from a typed query). --->
<cfset ruleIds = ValueList(getGlobalRules.id)>
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

<!--- Determine which sieve extensions are needed --->
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
    <cfelseif action_type EQ "vacation">
        <cfset needsVacation = true>
    </cfif>
</cfloop>

<!--- Build sieve script --->
<cfset sieveLines = []>

<cfset ArrayAppend(sieveLines, "## Hermes SEG Global Sieve Rules (auto-generated)")>
<cfset ArrayAppend(sieveLines, "## Do not edit manually - changes will be overwritten")>
<cfset ArrayAppend(sieveLines, "## Generated: #DateTimeFormat(Now(), 'yyyy-MM-dd HH:nn:ss')#")>
<cfset ArrayAppend(sieveLines, "")>

<cfset requires = []>
<cfif needsFileinto><cfset ArrayAppend(requires, '"fileinto"')></cfif>
<cfif needsImap4flags><cfset ArrayAppend(requires, '"imap4flags"')></cfif>
<cfif needsReject><cfset ArrayAppend(requires, '"reject"')></cfif>
<cfif needsVacation><cfset ArrayAppend(requires, '"vacation"')></cfif>

<cfif ArrayLen(requires) GT 0>
    <cfset ArrayAppend(sieveLines, 'require [#ArrayToList(requires, ", ")#];')>
    <cfset ArrayAppend(sieveLines, "")>
</cfif>

<cfloop query="getGlobalRules">
    <cfset ruleId = getGlobalRules.id>
    <cfset matchType = getGlobalRules.match_type>

    <!--- Collect this rule's conditions --->
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

    <!--- Collect this rule's actions (admin: no :create on fileinto) --->
    <cfset actArr = []>
    <cfloop query="allActions">
        <cfif allActions.rule_id EQ ruleId>
            <cfset actStr = buildSieveAction(allActions.action_type, allActions.action_value, false)>
            <cfif actStr NEQ "">
                <cfset ArrayAppend(actArr, actStr)>
            </cfif>
        </cfif>
    </cfloop>

    <cfif ArrayLen(actArr) EQ 0>
        <cfcontinue>
    </cfif>

    <cfset ArrayAppend(sieveLines, "## Rule: #getGlobalRules.rule_name#")>

    <cfif hasAllCondition OR ArrayLen(condArr) EQ 0>
        <!--- Unconditional actions --->
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

<cfif NOT DirectoryExists("/mnt/data/sieve/global")>
    <cfdirectory action="create" directory="/mnt/data/sieve/global" mode="755" recurse="true">
</cfif>

<cffile action="write"
    file="/mnt/data/sieve/global/before.sieve"
    output="#sieveContent#"
    charset="utf-8"
    addNewLine="no">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot chown -R 1000:1000 /srv/sieve/global"
        timeout="30" />
<cfcatch type="any">
</cfcatch>
</cftry>

<!--- Compile via sievec. If anything is written to stderr the compilation
     failed - log it to sieve_compile_log and surface via request.sieveCompileError
     so the action handler can show a warning. The previous .svbin remains. --->
<cfset request.sieveCompileError = "">
<cftry>
    <cfset sievecOutput = "">
    <cfset sievecError = "">
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot sievec /srv/sieve/global/before.sieve"
        variable="sievecOutput"
        errorVariable="sievecError"
        timeout="30" />
    <cfif IsDefined("sievecError") AND Len(trim(sievecError)) GT 0>
        <cfset request.sieveCompileError = trim(sievecError)>
        <cftry>
            <cfquery datasource="hermes">
                INSERT INTO sieve_compile_log (scope, username, rule_id, error_text)
                VALUES (
                    'global', NULL, NULL,
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
