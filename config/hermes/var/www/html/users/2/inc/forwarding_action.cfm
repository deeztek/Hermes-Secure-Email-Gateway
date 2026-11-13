<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

FORWARDING ACTION HANDLER (user portal, #411)
Saves the user's forwarding setting via UPSERT and regenerates their sieve
script so the change takes effect immediately.

Form fields:
  enabled      - 1 or 0
  forward_to   - another mailbox on the user's own domain
  keep_copy    - 1 or 0 (keep a copy in this mailbox)

Same target rules as Redirect in Mail Filters (sieve_user_rule_actions.cfm):
an existing mailbox on the user's own domain. Also refuses the user's own
address and any target whose forwarding chain leads back to this user.
--->

<cfset sieveUsername = session.email>
<cfset displayUrl = "view_forwarding.cfm">

<cfparam name="form.enabled" default="0">
<cfparam name="form.forward_to" default="">
<cfparam name="form.keep_copy" default="0">

<cfset enabledVal = (form.enabled EQ "1") ? 1 : 0>
<cfset keepVal = (form.keep_copy EQ "1") ? 1 : 0>
<cfset forwardToVal = LCase(trim(form.forward_to))>

<cfif Len(forwardToVal) GT 255>
    <cfset session.m = 21>
    <cflocation url="#displayUrl#" addtoken="no">
</cfif>

<cfif enabledVal EQ 1>
    <cfif forwardToVal EQ "" OR NOT IsValid("email", forwardToVal)>
        <cfset session.m = 21>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>
    <cfif forwardToVal EQ LCase(sieveUsername)>
        <cfset session.m = 23>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>
    <cfif LCase(ListLast(forwardToVal, "@")) NEQ LCase(ListLast(sieveUsername, "@"))>
        <cfset session.m = 22>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>
    <cfquery name="checkFwdTarget" datasource="hermes">
        SELECT id FROM mailboxes
        WHERE username = <cfqueryparam value="#forwardToVal#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkFwdTarget.recordcount LT 1>
        <cfset session.m = 23>
        <cflocation url="#displayUrl#" addtoken="no">
    </cfif>

    <!--- Loop guard: follow the target's own forwarding, and the next one's,
         and refuse if the chain comes back to this user. Bounded so a
         corrupt chain cannot spin. --->
    <cfset fwdHop = forwardToVal>
    <cfloop from="1" to="25" index="fwdStep">
        <cfquery name="nextHop" datasource="hermes">
            SELECT forward_to FROM user_forwarding
            WHERE username = <cfqueryparam value="#fwdHop#" cfsqltype="cf_sql_varchar">
              AND enabled = 1
              AND forward_to IS NOT NULL
        </cfquery>
        <cfif nextHop.recordcount LT 1>
            <cfbreak>
        </cfif>
        <cfset fwdHop = LCase(nextHop.forward_to)>
        <cfif fwdHop EQ LCase(sieveUsername)>
            <cfset session.m = 24>
            <cflocation url="#displayUrl#" addtoken="no">
        </cfif>
    </cfloop>
<cfelseif forwardToVal NEQ "" AND NOT IsValid("email", forwardToVal)>
    <!--- Disabled: the address is only remembered for next time, so an
         invalid one is dropped rather than refused. --->
    <cfset forwardToVal = "">
</cfif>

<cfquery datasource="hermes">
    INSERT INTO user_forwarding (username, enabled, forward_to, keep_copy)
    VALUES (
        <cfqueryparam value="#sieveUsername#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#enabledVal#" cfsqltype="cf_sql_tinyint">,
        <cfqueryparam value="#forwardToVal#" cfsqltype="cf_sql_varchar" null="#(forwardToVal IS '')#">,
        <cfqueryparam value="#keepVal#" cfsqltype="cf_sql_tinyint">
    )
    ON DUPLICATE KEY UPDATE
        enabled = <cfqueryparam value="#enabledVal#" cfsqltype="cf_sql_tinyint">,
        forward_to = <cfqueryparam value="#forwardToVal#" cfsqltype="cf_sql_varchar" null="#(forwardToVal IS '')#">,
        keep_copy = <cfqueryparam value="#keepVal#" cfsqltype="cf_sql_tinyint">
</cfquery>

<!--- Regenerate the user's sieve script so the change is live immediately --->
<cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">

<cfif IsDefined("request.sieveCompileError") AND request.sieveCompileError NEQ "">
    <cfset session.compile_error = request.sieveCompileError>
    <cfset session.m = 30>
<cfelse>
    <cfset session.m = 1>
</cfif>
<cflocation url="#displayUrl#" addtoken="no">
