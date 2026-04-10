
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

USER SIEVE RULE ACTIONS HANDLER
Handles add, edit, delete, toggle for personal user sieve rules.
Uses session.email for the username scope.
--->

<cfset sieveUsername = session.email>

<cfif action EQ "add_rule">

    <cfif NOT StructKeyExists(form, "rule_name") OR trim(form.rule_name) EQ "">
        <cfset session.m = 10>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfparam name="form.condition_field" default="subject">
    <cfparam name="form.condition_type" default="contains">
    <cfparam name="form.condition_value" default="">
    <cfparam name="form.action_type" default="fileinto">
    <cfparam name="form.action_value" default="">

    <cfif trim(form.condition_value) EQ "" AND form.condition_field NEQ "all">
        <cfset session.m = 11>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfif form.action_type EQ "fileinto" AND trim(form.action_value) EQ "">
        <cfset session.m = 12>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfquery name="getMaxOrder" datasource="hermes">
        SELECT COALESCE(MAX(rule_order), 0) + 1 AS next_order FROM sieve_rules
        WHERE scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfquery datasource="hermes">
        INSERT INTO sieve_rules (scope, username, rule_name, rule_order, condition_field, condition_type, condition_value, action_type, action_value)
        VALUES (
          'user',
          <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#trim(form.rule_name)#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#getMaxOrder.next_order#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#form.condition_field#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.condition_type#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#trim(form.condition_value)#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.action_type#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#trim(form.action_value)#" cfsqltype="cf_sql_varchar" null="#(trim(form.action_value) IS '')#">
        )
    </cfquery>

    <cfinclude template="../../admin/2/inc/generate_sieve_user.cfm">

    <cfset session.m = 1>
    <cflocation url="view_sieve_rules.cfm" addtoken="no">

<cfelseif action EQ "edit_rule">

    <cfif NOT StructKeyExists(form, "rule_id") OR NOT IsNumeric(form.rule_id)>
        <cfset session.m = 20>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <!--- Verify rule belongs to this user --->
    <cfquery name="getRule" datasource="hermes">
        SELECT id FROM sieve_rules
        WHERE id = <cfqueryparam value="#form.rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getRule.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfparam name="form.edit_rule_name" default="">
    <cfparam name="form.edit_condition_field" default="subject">
    <cfparam name="form.edit_condition_type" default="contains">
    <cfparam name="form.edit_condition_value" default="">
    <cfparam name="form.edit_action_type" default="fileinto">
    <cfparam name="form.edit_action_value" default="">

    <cfquery datasource="hermes">
        UPDATE sieve_rules
        SET rule_name = <cfqueryparam value="#trim(form.edit_rule_name)#" cfsqltype="cf_sql_varchar">,
            condition_field = <cfqueryparam value="#form.edit_condition_field#" cfsqltype="cf_sql_varchar">,
            condition_type = <cfqueryparam value="#form.edit_condition_type#" cfsqltype="cf_sql_varchar">,
            condition_value = <cfqueryparam value="#trim(form.edit_condition_value)#" cfsqltype="cf_sql_varchar">,
            action_type = <cfqueryparam value="#form.edit_action_type#" cfsqltype="cf_sql_varchar">,
            action_value = <cfqueryparam value="#trim(form.edit_action_value)#" cfsqltype="cf_sql_varchar" null="#(trim(form.edit_action_value) IS '')#">
        WHERE id = <cfqueryparam value="#form.rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfinclude template="../../admin/2/inc/generate_sieve_user.cfm">

    <cfset session.m = 2>
    <cflocation url="view_sieve_rules.cfm" addtoken="no">

<cfelseif action EQ "delete_rule">

    <cfif NOT StructKeyExists(form, "delete_rule_id") OR NOT IsNumeric(form.delete_rule_id)>
        <cfset session.m = 20>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
        DELETE FROM sieve_rules
        WHERE id = <cfqueryparam value="#form.delete_rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfinclude template="../../admin/2/inc/generate_sieve_user.cfm">

    <cfset session.m = 3>
    <cflocation url="view_sieve_rules.cfm" addtoken="no">

<cfelseif action EQ "toggle_rule">

    <cfif NOT StructKeyExists(form, "toggle_rule_id") OR NOT IsNumeric(form.toggle_rule_id)>
        <cfset session.m = 20>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
        UPDATE sieve_rules SET enabled = IF(enabled = 1, 0, 1)
        WHERE id = <cfqueryparam value="#form.toggle_rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfinclude template="../../admin/2/inc/generate_sieve_user.cfm">

    <cfset session.m = 4>
    <cflocation url="view_sieve_rules.cfm" addtoken="no">

<cfelseif action EQ "reorder_rule">

    <cfif NOT StructKeyExists(form, "reorder_rule_id") OR NOT IsNumeric(form.reorder_rule_id)>
        <cfset session.m = 20>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfparam name="form.reorder_direction" default="down">

    <cfquery name="getCurrentRule" datasource="hermes">
        SELECT id, rule_order FROM sieve_rules
        WHERE id = <cfqueryparam value="#form.reorder_rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif getCurrentRule.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="view_sieve_rules.cfm" addtoken="no">
    </cfif>

    <cfif form.reorder_direction EQ "up">
        <cfquery name="getAdjacent" datasource="hermes">
            SELECT id, rule_order FROM sieve_rules
            WHERE scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
            AND rule_order < <cfqueryparam value="#getCurrentRule.rule_order#" cfsqltype="cf_sql_integer">
            ORDER BY rule_order DESC
            LIMIT 1
        </cfquery>
    <cfelse>
        <cfquery name="getAdjacent" datasource="hermes">
            SELECT id, rule_order FROM sieve_rules
            WHERE scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
            AND rule_order > <cfqueryparam value="#getCurrentRule.rule_order#" cfsqltype="cf_sql_integer">
            ORDER BY rule_order ASC
            LIMIT 1
        </cfquery>
    </cfif>

    <cfif getAdjacent.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE sieve_rules SET rule_order = <cfqueryparam value="#getAdjacent.rule_order#" cfsqltype="cf_sql_integer">
            WHERE id = <cfqueryparam value="#getCurrentRule.id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfquery datasource="hermes">
            UPDATE sieve_rules SET rule_order = <cfqueryparam value="#getCurrentRule.rule_order#" cfsqltype="cf_sql_integer">
            WHERE id = <cfqueryparam value="#getAdjacent.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfinclude template="../../admin/2/inc/generate_sieve_user.cfm">
    </cfif>

    <cfset session.m = 5>
    <cflocation url="view_sieve_rules.cfm" addtoken="no">

</cfif>
