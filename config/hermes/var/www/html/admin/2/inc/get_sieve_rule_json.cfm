
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET SIEVE RULE JSON - AJAX endpoint for edit modal.
Returns rule metadata + arrays of conditions and actions (multi-condition/action).
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid rule ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getRule" datasource="hermes">
    SELECT id, scope, username, rule_name, rule_order, enabled, is_system, match_type
    FROM sieve_rules
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getRule.recordcount LT 1>
    <cfoutput>{"error": "Rule not found"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getConds" datasource="hermes">
    SELECT condition_field, condition_type, condition_value
    FROM sieve_rule_conditions
    WHERE rule_id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
    ORDER BY condition_order ASC, id ASC
</cfquery>

<cfquery name="getActs" datasource="hermes">
    SELECT action_type, action_value
    FROM sieve_rule_actions
    WHERE rule_id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
    ORDER BY action_order ASC, id ASC
</cfquery>

<cfset condJson = []>
<cfloop query="getConds">
    <cfset ArrayAppend(condJson, {
        "field": getConds.condition_field,
        "type": getConds.condition_type,
        "value": getConds.condition_value
    })>
</cfloop>

<cfset actJson = []>
<cfloop query="getActs">
    <cfset ArrayAppend(actJson, {
        "type": getActs.action_type,
        "value": getActs.action_value
    })>
</cfloop>

<cfset out = {
    "id": getRule.id,
    "scope": getRule.scope,
    "rule_name": getRule.rule_name,
    "rule_order": getRule.rule_order,
    "enabled": getRule.enabled,
    "is_system": getRule.is_system,
    "match_type": getRule.match_type,
    "conditions": condJson,
    "actions": actJson
}>

<cfcontent type="application/json" reset="true">
<cfoutput>#SerializeJSON(out)#</cfoutput>
<cfabort>
