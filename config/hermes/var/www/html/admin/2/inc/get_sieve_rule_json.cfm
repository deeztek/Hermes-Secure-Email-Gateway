
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET SIEVE RULE JSON - AJAX endpoint for edit modal
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid rule ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getRule" datasource="hermes">
    SELECT id, scope, username, rule_name, rule_order, enabled, is_system,
           condition_field, condition_type, condition_value,
           action_type, action_value
    FROM sieve_rules
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getRule.recordcount LT 1>
    <cfoutput>{"error": "Rule not found"}</cfoutput>
    <cfabort>
</cfif>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #getRule.id#,
    "scope": "#JSStringFormat(getRule.scope)#",
    "rule_name": "#JSStringFormat(getRule.rule_name)#",
    "rule_order": #getRule.rule_order#,
    "enabled": #getRule.enabled#,
    "is_system": #getRule.is_system#,
    "condition_field": "#JSStringFormat(getRule.condition_field)#",
    "condition_type": "#JSStringFormat(getRule.condition_type)#",
    "condition_value": "#JSStringFormat(getRule.condition_value)#",
    "action_type": "#JSStringFormat(getRule.action_type)#",
    "action_value": "#JSStringFormat(getRule.action_value)#"
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
