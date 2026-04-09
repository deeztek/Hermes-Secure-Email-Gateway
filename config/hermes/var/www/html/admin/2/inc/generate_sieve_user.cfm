
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE USER SIEVE SCRIPT
Reads all enabled personal sieve rules for a specific user from the database
and generates their personal sieve script at /srv/mail/sieve/{user}.sieve.
After writing, compiles the script using sievec via Docker exec.

Requires: sieveUsername variable to be set before including.
--->

<!--- Get all enabled user rules ordered by rule_order --->
<cfquery name="getUserRules" datasource="hermes">
    SELECT id, rule_name, condition_field, condition_type, condition_value,
           action_type, action_value
    FROM sieve_rules
    WHERE scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    AND enabled = 1
    ORDER BY rule_order ASC
</cfquery>

<!--- Determine which sieve extensions are needed --->
<cfset needsFileinto = false>
<cfset needsImap4flags = false>
<cfset needsReject = false>
<cfset needsVacation = false>

<cfloop query="getUserRules">
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

<!--- Build the sieve script --->
<cfset sieveLines = []>

<cfset ArrayAppend(sieveLines, "## Hermes SEG Personal Sieve Rules for #sieveUsername# (auto-generated)")>
<cfset ArrayAppend(sieveLines, "## Do not edit manually - changes will be overwritten")>
<cfset ArrayAppend(sieveLines, "## Generated: #DateTimeFormat(Now(), 'yyyy-MM-dd HH:nn:ss')#")>
<cfset ArrayAppend(sieveLines, "")>

<!--- Require statements --->
<cfset requires = []>
<cfif needsFileinto><cfset ArrayAppend(requires, '"fileinto"')></cfif>
<cfif needsImap4flags><cfset ArrayAppend(requires, '"imap4flags"')></cfif>
<cfif needsReject><cfset ArrayAppend(requires, '"reject"')></cfif>
<cfif needsVacation><cfset ArrayAppend(requires, '"vacation"')></cfif>

<cfif ArrayLen(requires) GT 0>
    <cfset ArrayAppend(sieveLines, 'require [#ArrayToList(requires, ", ")#];')>
    <cfset ArrayAppend(sieveLines, "")>
</cfif>

<!--- Generate rules (same logic as global) --->
<cfloop query="getUserRules">

    <cfset ArrayAppend(sieveLines, "## Rule: #rule_name#")>

    <cfset condField = condition_field>
    <cfset condType = condition_type>
    <cfset condValue = condition_value>

    <cfif condField EQ "header">
        <cfset headerName = ListFirst(condValue, ":")>
        <cfset headerValue = trim(ListRest(condValue, ":"))>
        <cfif condType EQ "is">
            <cfset condition = 'header :is "#trim(headerName)#" "#headerValue#"'>
        <cfelseif condType EQ "contains">
            <cfset condition = 'header :contains "#trim(headerName)#" "#headerValue#"'>
        <cfelseif condType EQ "matches">
            <cfset condition = 'header :matches "#trim(headerName)#" "#headerValue#"'>
        <cfelseif condType EQ "not_contains">
            <cfset condition = 'not header :contains "#trim(headerName)#" "#headerValue#"'>
        </cfif>
    <cfelseif condField EQ "from">
        <cfif condType EQ "is">
            <cfset condition = 'header :is "From" "#condValue#"'>
        <cfelseif condType EQ "contains">
            <cfset condition = 'header :contains "From" "#condValue#"'>
        <cfelseif condType EQ "matches">
            <cfset condition = 'header :matches "From" "#condValue#"'>
        <cfelseif condType EQ "not_contains">
            <cfset condition = 'not header :contains "From" "#condValue#"'>
        </cfif>
    <cfelseif condField EQ "to">
        <cfif condType EQ "is">
            <cfset condition = 'header :is "To" "#condValue#"'>
        <cfelseif condType EQ "contains">
            <cfset condition = 'header :contains "To" "#condValue#"'>
        <cfelseif condType EQ "matches">
            <cfset condition = 'header :matches "To" "#condValue#"'>
        <cfelseif condType EQ "not_contains">
            <cfset condition = 'not header :contains "To" "#condValue#"'>
        </cfif>
    <cfelseif condField EQ "cc">
        <cfif condType EQ "is">
            <cfset condition = 'header :is "Cc" "#condValue#"'>
        <cfelseif condType EQ "contains">
            <cfset condition = 'header :contains "Cc" "#condValue#"'>
        <cfelseif condType EQ "matches">
            <cfset condition = 'header :matches "Cc" "#condValue#"'>
        <cfelseif condType EQ "not_contains">
            <cfset condition = 'not header :contains "Cc" "#condValue#"'>
        </cfif>
    <cfelseif condField EQ "subject">
        <cfif condType EQ "is">
            <cfset condition = 'header :is "Subject" "#condValue#"'>
        <cfelseif condType EQ "contains">
            <cfset condition = 'header :contains "Subject" "#condValue#"'>
        <cfelseif condType EQ "matches">
            <cfset condition = 'header :matches "Subject" "#condValue#"'>
        <cfelseif condType EQ "not_contains">
            <cfset condition = 'not header :contains "Subject" "#condValue#"'>
        </cfif>
    <cfelseif condField EQ "size">
        <cfif condType EQ "over">
            <cfset condition = 'size :over #condValue#'>
        <cfelseif condType EQ "under">
            <cfset condition = 'size :under #condValue#'>
        </cfif>
    <cfelseif condField EQ "all">
        <cfset condition = 'true'>
    </cfif>

    <cfif action_type EQ "fileinto">
        <cfset action = 'fileinto "#action_value#";'>
    <cfelseif action_type EQ "discard">
        <cfset action = "discard;">
    <cfelseif action_type EQ "keep">
        <cfset action = "keep;">
    <cfelseif action_type EQ "redirect">
        <cfset action = 'redirect "#action_value#";'>
    <cfelseif action_type EQ "flag_seen">
        <cfset action = 'addflag "\\Seen";'>
    <cfelseif action_type EQ "reject">
        <cfset action = 'reject "#action_value#";'>
    </cfif>

    <cfif condField EQ "all">
        <cfset ArrayAppend(sieveLines, "#action#")>
    <cfelse>
        <cfset ArrayAppend(sieveLines, "if #condition# {")>
        <cfset ArrayAppend(sieveLines, "    #action#")>
        <cfset ArrayAppend(sieveLines, "}")>
    </cfif>
    <cfset ArrayAppend(sieveLines, "")>

</cfloop>

<!--- Write the sieve file --->
<cfset sieveContent = ArrayToList(sieveLines, Chr(10))>

<!--- Ensure the sieve directory exists --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_dovecot mkdir -p /srv/mail/sieve"
    timeout="30" />

<!--- Write via temp file --->
<cfset sieveTempFile = "/opt/hermes/tmp/#Replace(sieveUsername, '@', '_at_', 'ALL')#.sieve">
<cffile action="write"
    file="#sieveTempFile#"
    output="#sieveContent#"
    charset="utf-8"
    addNewLine="no">

<!--- Copy to Dovecot container --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_dovecot cp #sieveTempFile# /srv/mail/sieve/#sieveUsername#.sieve"
    timeout="30" />

<!--- Set ownership --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_dovecot chown 1000:1000 /srv/mail/sieve/#sieveUsername#.sieve"
    timeout="30" />

<!--- Compile --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot sievec /srv/mail/sieve/#sieveUsername#.sieve"
        variable="sievecOutput"
        errorVariable="sievecError"
        timeout="30" />
<cfcatch type="any">
</cfcatch>
</cftry>

<!--- Cleanup --->
<cfif fileExists(sieveTempFile)>
    <cffile action="delete" file="#sieveTempFile#">
</cfif>
