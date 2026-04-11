
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

USER SIEVE RULE ACTIONS HANDLER (multi-condition/multi-action)
Handles add, edit, delete, toggle, reorder for personal user sieve rules.
Scoped to session.email.
--->

<cfset sieveUsername = session.email>
<cfset displayUrl = "view_sieve_rules.cfm">

<cffunction name="formArray" returntype="array" output="false">
    <cfargument name="prefix" type="string" required="true">
    <cfargument name="countKey" type="string" required="true">
    <cfset var arr = []>
    <cfset var n = 0>
    <cfset var i = 0>
    <cfif StructKeyExists(form, arguments.countKey) AND IsNumeric(form[arguments.countKey])>
        <cfset n = form[arguments.countKey]>
    </cfif>
    <cfloop from="0" to="#n - 1#" index="i">
        <cfset var k = arguments.prefix & i>
        <cfif StructKeyExists(form, k)>
            <cfset ArrayAppend(arr, form[k])>
        <cfelse>
            <cfset ArrayAppend(arr, "")>
        </cfif>
    </cfloop>
    <cfreturn arr>
</cffunction>

<!--- Allowed user-portal action types. redirect/reject excluded - those are
     admin-only because of forwarding-loop and bounce-leak risks. --->
<cfset USER_ALLOWED_ACTIONS = "fileinto,discard,keep,flag_seen">

<cffunction name="validatePayload" returntype="string" output="false">
    <cfset var condFields = formArray("cond_field_", "cond_count")>
    <cfset var condTypes  = formArray("cond_type_", "cond_count")>
    <cfset var condValues = formArray("cond_value_", "cond_count")>
    <cfset var actTypes   = formArray("act_type_", "act_count")>
    <cfset var actValues  = formArray("act_value_", "act_count")>
    <cfset var i = 0>
    <cfset var realCondCount = 0>
    <cfset var hasAll = false>

    <cfif NOT StructKeyExists(form, "rule_name") OR trim(form.rule_name) EQ "">
        <cfreturn "10">
    </cfif>
    <cfif Len(trim(form.rule_name)) GT 255>
        <cfreturn "10">
    </cfif>

    <cfif ArrayLen(condFields) EQ 0>
        <cfreturn "11">
    </cfif>
    <cfif ArrayLen(actTypes) EQ 0>
        <cfreturn "12">
    </cfif>

    <cfloop from="1" to="#ArrayLen(condFields)#" index="i">
        <cfset var f = trim(condFields[i])>
        <cfset var t = (i LTE ArrayLen(condTypes)) ? trim(condTypes[i]) : "contains">
        <cfset var v = (i LTE ArrayLen(condValues)) ? trim(condValues[i]) : "">
        <cfif f EQ "">
            <cfcontinue>
        </cfif>
        <cfif f EQ "all">
            <cfset hasAll = true>
            <cfset realCondCount++>
            <cfcontinue>
        </cfif>
        <cfif v EQ "">
            <cfreturn "11">
        </cfif>
        <cfif Len(v) GT 500>
            <cfreturn "16">
        </cfif>
        <cfif f EQ "size">
            <!--- Accept "10", "10M", "10m", "10mb", "10 MB" - all normalized at save. --->
            <cfif NOT REFind("^\d+\s*[KMGkmg]?[Bb]?$", v)>
                <cfreturn "13">
            </cfif>
        </cfif>
        <cfset realCondCount++>
    </cfloop>

    <cfif realCondCount EQ 0>
        <cfreturn "11">
    </cfif>

    <cfif hasAll AND realCondCount GT 1>
        <cfreturn "17">
    </cfif>

    <cfloop from="1" to="#ArrayLen(actTypes)#" index="i">
        <cfset var at = trim(actTypes[i])>
        <cfset var av = (i LTE ArrayLen(actValues)) ? trim(actValues[i]) : "">
        <cfif at EQ "">
            <cfcontinue>
        </cfif>
        <!--- Reject action types not allowed for users (defense in depth -
             the UI doesn't expose them). --->
        <cfif NOT ListFindNoCase(USER_ALLOWED_ACTIONS, at)>
            <cfreturn "18">
        </cfif>
        <cfif at EQ "fileinto">
            <cfif av EQ "">
                <cfreturn "15">
            </cfif>
            <cfif Len(av) GT 255>
                <cfreturn "16">
            </cfif>
        </cfif>
    </cfloop>

    <cfreturn "">
</cffunction>

<cffunction name="saveConditionsAndActions" returntype="void" output="false">
    <cfargument name="ruleId" type="numeric" required="true">

    <cfset var condFields = formArray("cond_field_", "cond_count")>
    <cfset var condTypes  = formArray("cond_type_", "cond_count")>
    <cfset var condValues = formArray("cond_value_", "cond_count")>
    <cfset var actTypes   = formArray("act_type_", "act_count")>
    <cfset var actValues  = formArray("act_value_", "act_count")>
    <cfset var i = 0>

    <cftransaction action="begin">
        <cftry>
            <cfquery datasource="hermes">
                DELETE FROM sieve_rule_conditions WHERE rule_id = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery datasource="hermes">
                DELETE FROM sieve_rule_actions WHERE rule_id = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfloop from="1" to="#ArrayLen(condFields)#" index="i">
                <cfset var f = trim(condFields[i])>
                <cfset var t = (i LTE ArrayLen(condTypes)) ? trim(condTypes[i]) : "contains">
                <cfset var v = (i LTE ArrayLen(condValues)) ? trim(condValues[i]) : "">
                <cfif f EQ "">
                    <cfcontinue>
                </cfif>
                <cfif f NEQ "all" AND v EQ "">
                    <cfcontinue>
                </cfif>
                <cfif f EQ "size">
                    <cfset v = UCase(REReplace(v, "\s+", "", "all"))>
                    <cfset v = REReplace(v, "B$", "", "all")>
                </cfif>
                <cfquery datasource="hermes">
                    INSERT INTO sieve_rule_conditions (rule_id, condition_field, condition_type, condition_value, condition_order)
                    VALUES (
                        <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#f#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#t#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#v#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#i - 1#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
            </cfloop>

            <cfloop from="1" to="#ArrayLen(actTypes)#" index="i">
                <cfset var at = trim(actTypes[i])>
                <cfset var av = (i LTE ArrayLen(actValues)) ? trim(actValues[i]) : "">
                <cfif at EQ "">
                    <cfcontinue>
                </cfif>
                <!--- Server-side allowlist (defense in depth) --->
                <cfif NOT ListFindNoCase(USER_ALLOWED_ACTIONS, at)>
                    <cfcontinue>
                </cfif>
                <cfif at EQ "fileinto" AND av EQ "">
                    <cfcontinue>
                </cfif>
                <cfquery datasource="hermes">
                    INSERT INTO sieve_rule_actions (rule_id, action_type, action_value, action_order)
                    VALUES (
                        <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#at#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#av#" cfsqltype="cf_sql_varchar" null="#(av IS '')#">,
                        <cfqueryparam value="#i - 1#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
            </cfloop>

            <cftransaction action="commit">
        <cfcatch type="any">
            <cftransaction action="rollback">
            <cfthrow object="#cfcatch#">
        </cfcatch>
        </cftry>
    </cftransaction>
</cffunction>

<cfif action EQ "add_rule">

    <cfparam name="form.match_type" default="all">

    <cfset validationError = validatePayload()>
    <cfif validationError NEQ "">
        <cfset session.m = validationError>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfquery name="getMaxOrder" datasource="hermes">
        SELECT COALESCE(MAX(rule_order), 0) + 1 AS next_order
        FROM sieve_rules
        WHERE scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfquery name="insertRule" datasource="hermes" result="insRes">
        INSERT INTO sieve_rules (scope, username, rule_name, rule_order, match_type)
        VALUES (
            'user',
            <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#trim(form.rule_name)#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#getMaxOrder.next_order#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.match_type#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>

    <cfset newId = insRes.GENERATED_KEY>
    <cfset saveConditionsAndActions(newId)>

    <cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">

    <cfif IsDefined("request.sieveCompileError") AND request.sieveCompileError NEQ "">
        <cfset session.compile_error = request.sieveCompileError>
        <cfset session.m = 30>
    <cfelse>
        <cfset session.m = 1>
    </cfif>
    <cflocation url="#displayUrl#" addtoken="no">

<cfelseif action EQ "edit_rule">

    <cfif NOT StructKeyExists(form, "rule_id") OR NOT IsNumeric(form.rule_id)>
        <cfset session.m = 20>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfquery name="getRule" datasource="hermes">
        SELECT id FROM sieve_rules
        WHERE id = <cfqueryparam value="#form.rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getRule.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfparam name="form.match_type" default="all">

    <cfset validationError = validatePayload()>
    <cfif validationError NEQ "">
        <cfset session.m = validationError>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
        UPDATE sieve_rules
        SET rule_name = <cfqueryparam value="#trim(form.rule_name)#" cfsqltype="cf_sql_varchar">,
            match_type = <cfqueryparam value="#form.match_type#" cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#form.rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfset saveConditionsAndActions(form.rule_id)>

    <cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">

    <cfif IsDefined("request.sieveCompileError") AND request.sieveCompileError NEQ "">
        <cfset session.compile_error = request.sieveCompileError>
        <cfset session.m = 30>
    <cfelse>
        <cfset session.m = 2>
    </cfif>
    <cflocation url="#displayUrl#" addtoken="no">

<cfelseif action EQ "delete_rule">

    <cfif NOT StructKeyExists(form, "delete_rule_id") OR NOT IsNumeric(form.delete_rule_id)>
        <cfset session.m = 20>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
        DELETE FROM sieve_rules
        WHERE id = <cfqueryparam value="#form.delete_rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">

    <cfset session.m = 3>
    <cflocation url="#displayUrl#" addtoken="no">

<cfelseif action EQ "toggle_rule">

    <cfif NOT StructKeyExists(form, "toggle_rule_id") OR NOT IsNumeric(form.toggle_rule_id)>
        <cfset session.m = 20>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
        UPDATE sieve_rules SET enabled = IF(enabled = 1, 0, 1)
        WHERE id = <cfqueryparam value="#form.toggle_rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">

    <cfset session.m = 4>
    <cflocation url="#displayUrl#" addtoken="no">

<cfelseif action EQ "reorder_rule">

    <cfif NOT StructKeyExists(form, "reorder_rule_id") OR NOT IsNumeric(form.reorder_rule_id)>
        <cfset session.m = 20>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <cfparam name="form.reorder_direction" default="down">

    <cfquery name="getCurrentRule" datasource="hermes">
        SELECT id, rule_order FROM sieve_rules
        WHERE id = <cfqueryparam value="#form.reorder_rule_id#" cfsqltype="cf_sql_integer">
        AND scope = 'user' AND username = <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif getCurrentRule.recordcount LT 1>
        <cfset session.m = 21>
        <cflocation url="#displayUrl#" addtoken="no">
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

        <cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">
    </cfif>

    <cfset session.m = 5>
    <cflocation url="#displayUrl#" addtoken="no">

</cfif>
