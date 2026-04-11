
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

RECORD LOGIN HELPER
Records the current login timestamp for the active session and surfaces
the *previous* login timestamp via session.previous_login for dashboard
display ("Last login: ...").

Called from both admin/Application.cfc and users/Application.cfc on every
request, but only does work on the first request of a fresh session
(detected via session.login_recorded flag).

Schema: user_login_history (username PK, current_login, previous_login)
--->

<cfif NOT StructKeyExists(session, "login_recorded") OR session.login_recorded NEQ true>

    <!--- Pick the username for the row key. Admin sets session.theUser
         (LDAP cn), user portal sets session.email. Prefer email when
         available so it stays stable across portals. --->
    <cfset loginUser = "">
    <cfif StructKeyExists(session, "email") AND session.email NEQ "">
        <cfset loginUser = session.email>
    <cfelseif StructKeyExists(session, "theUser") AND session.theUser NEQ "">
        <cfset loginUser = session.theUser>
    </cfif>

    <cfif loginUser NEQ "">
        <cftry>
            <cfquery name="getPrior" datasource="hermes">
                SELECT current_login
                FROM user_login_history
                WHERE username = <cfqueryparam value="#loginUser#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif getPrior.recordcount GTE 1>
                <!--- Existing row: roll the old current_login into previous_login --->
                <cfset session.previous_login = getPrior.current_login>
                <cfquery datasource="hermes">
                    UPDATE user_login_history
                    SET previous_login = <cfqueryparam value="#getPrior.current_login#" cfsqltype="cf_sql_timestamp" null="#(NOT IsDate(getPrior.current_login))#">,
                        current_login  = NOW()
                    WHERE username = <cfqueryparam value="#loginUser#" cfsqltype="cf_sql_varchar">
                </cfquery>
            <cfelse>
                <!--- First ever recorded login for this user --->
                <cfset session.previous_login = "">
                <cfquery datasource="hermes">
                    INSERT INTO user_login_history (username, current_login, previous_login)
                    VALUES (
                        <cfqueryparam value="#loginUser#" cfsqltype="cf_sql_varchar">,
                        NOW(),
                        NULL
                    )
                </cfquery>
            </cfif>

            <cfset session.login_recorded = true>
        <cfcatch type="any">
            <!--- Don't break login if the table doesn't exist yet (pre-migration). --->
            <cfset session.previous_login = "">
            <cfset session.login_recorded = true>
        </cfcatch>
        </cftry>
    </cfif>

</cfif>
