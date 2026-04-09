
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE GLOBAL SIEVE SCRIPT
Reads all enabled global sieve rules from the database and generates
the sieve_before script at /srv/mail/sieve/global/before.sieve.
After writing, compiles the script using sievec via Docker exec.
--->

<!--- Get all enabled global rules ordered by rule_order --->
<cfquery name="getGlobalRules" datasource="hermes">
    SELECT id, rule_name, condition_field, condition_type, condition_value,
           action_type, action_value
    FROM sieve_rules
    WHERE scope = 'global' AND enabled = 1
    ORDER BY rule_order ASC
</cfquery>

<!--- Determine which sieve extensions are needed --->
<cfset needsFileinto = false>
<cfset needsImap4flags = false>
<cfset needsReject = false>
<cfset needsVacation = false>

<cfloop query="getGlobalRules">
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

<!--- Header comment --->
<cfset ArrayAppend(sieveLines, "## Hermes SEG Global Sieve Rules (auto-generated)")>
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

<!--- Generate rules --->
<cfloop query="getGlobalRules">

    <cfset ArrayAppend(sieveLines, "## Rule: #rule_name#")>

    <!--- Build condition --->
    <cfset condField = condition_field>
    <cfset condType = condition_type>
    <cfset condValue = condition_value>

    <cfif condField EQ "header">
        <!--- Header condition: value format is "Header-Name: value" --->
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

    <!--- Build action --->
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

    <!--- Write the rule --->
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

<!--- Ensure the global sieve directory exists --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_dovecot mkdir -p /srv/mail/sieve/global"
    timeout="30" />

<!--- Write the script file via temp file (commandbox can write, then docker exec moves it) --->
<cffile action="write"
    file="/opt/hermes/tmp/before.sieve"
    output="#sieveContent#"
    charset="utf-8"
    addNewLine="no">

<!--- Copy to Dovecot container's sieve directory --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_dovecot cp /opt/hermes/tmp/before.sieve /srv/mail/sieve/global/before.sieve"
    timeout="30" />

<!--- Set ownership --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_dovecot chown -R 1000:1000 /srv/mail/sieve/global"
    timeout="30" />

<!--- Compile the sieve script --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot sievec /srv/mail/sieve/global/before.sieve"
        variable="sievecOutput"
        errorVariable="sievecError"
        timeout="30" />
<cfcatch type="any">
    <!--- Compilation failure is non-critical - Dovecot will interpret at runtime --->
</cfcatch>
</cftry>

<!--- Cleanup temp file --->
<cfif fileExists("/opt/hermes/tmp/before.sieve")>
    <cffile action="delete" file="/opt/hermes/tmp/before.sieve">
</cfif>
