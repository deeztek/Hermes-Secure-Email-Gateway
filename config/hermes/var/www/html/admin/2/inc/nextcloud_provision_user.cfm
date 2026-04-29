
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD USER PRE-PROVISIONING
Creates a Nextcloud user at mailbox creation time so the user appears in
NC Admin immediately and can be assigned to groups before their first login.

Two code paths depending on auth type:

1. LOCAL AUTH (ncProvisionAuthType = "local" or password provided):
   Uses `occ user:add` with the mailbox's local password. The local NC
   password enables DAV authentication (CalDAV/CardDAV/WebDAV) using the
   same credentials as email. On first OIDC login, user_oidc recognizes
   the existing account (soft_auto_provision=true) and takes over.

2. REMOTE AUTH (ncProvisionAuthType = "remote"):
   Uses the user_oidc REST API to create an OIDC-backed user with no local
   password (the user authenticates exclusively via OIDC/Authelia/AD).
   DAV is not available for remote-auth users by design — they have no
   local NC password to use for HTTP Basic Auth.

Requires the following variables before including:
  - ncProvisionAction: "create" or "delete"
  - ncProvisionUser: Nextcloud username (email address)
  - ncProvisionDisplayName: Display name (for create)
  - ncProvisionEmail: Email address (for create)
  - ncProvisionPassword: Plaintext password (local auth only)
  - ncProvisionAuthType: "local" or "remote" (defaults to "local" when
                        a password is provided, "remote" when blank)

Sets after execution:
  - ncProvisionResult: "success", "error", or "skipped"
  - ncProvisionError: error message (if any)
  - ncProvisionAppPassword: generated "Hermes System" DAV token
    (only set for remote-auth on successful create; empty otherwise).
    Caller should thread this into the welcome email — remote-auth
    users have no local NC password and need this token for
    CalDAV/CardDAV/WebDAV clients.
--->

<cfparam name="ncProvisionAction" default="">
<cfparam name="ncProvisionUser" default="">
<cfparam name="ncProvisionDisplayName" default="">
<cfparam name="ncProvisionEmail" default="">
<cfparam name="ncProvisionPassword" default="">
<cfparam name="ncProvisionAuthType" default="">

<!--- Infer auth type from password if caller didn't specify --->
<cfif ncProvisionAuthType EQ "">
    <cfset ncProvisionAuthType = (ncProvisionPassword EQ "") ? "remote" : "local">
</cfif>

<cfset ncProvisionResult = "skipped">
<cfset ncProvisionError = "">
<cfset ncProvisionAppPassword = "">

<cfif ncProvisionAction EQ "" OR ncProvisionUser EQ "">
    <!--- Nothing to do --->

<cfelseif ncProvisionAction EQ "create">

    <!--- Unified provisioning path: occ user:add for BOTH auth types.
         Local-auth uses the mailbox's own password as the NC local
         password (same value, enables DAV directly). Remote-auth uses
         a generated random password the user never sees — OIDC takes
         over the account on first login via soft_auto_provision, so the
         local password is vestigial.

         Why not user_oidc REST API for remote-auth anymore:
         Users provisioned through user_oidc's REST API land in a
         backend state where `occ user:resetpassword` silently fails and
         `user:auth-tokens:add --password-from-env` can't validate any
         password (the user effectively has no local password). That
         breaks our ability to generate a DAV app password (the token
         row's encrypted password ends up out of sync with the user's
         actual stored password, so NC rejects it on every DAV request
         with TokenPasswordExpiredException).

         With occ user:add the user is in the Database backend with a
         known password, all the app-password machinery works, and OIDC
         login still takes over via soft_auto_provision (same mechanism
         local-auth users use to transition to OIDC today). --->
    <cfif ncProvisionAuthType NEQ "local" AND ncProvisionPassword EQ "">
        <!--- Remote auth: generate a random password we'll use both for
             NC user creation and for subsequent app-password flows.
             Never disclosed to anyone. --->
        <cfset ncProvisionPassword = "HermesRAND" & createUUID() & createUUID()>
    </cfif>

    <cfif ncProvisionPassword EQ "">
        <cfset ncProvisionResult = "skipped">
        <cfset ncProvisionError = "No password provided and auth type not remote">
    <cfelse>
        <cftry>
            <cfinclude template="generate_customtrans.cfm">

            <!--- Read NC DB credentials once. Used for the post-flight
                 user-creation verify below AND the orphan oc_authtoken
                 cleanup further down (remote-auth branch). --->
            <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncDbUser" charset="utf-8">
            <cfset ncDbUser = Trim(ncDbUser)>
            <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncDbPass" charset="utf-8">
            <cfset ncDbPass = Trim(ncDbPass)>

            <cfset provScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_provision.sh">
            <cfscript>
                fileWrite(provScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -e OC_PASS="' & ncProvisionPassword & '" -u www-data hermes_nextcloud php /var/www/html/occ user:add --password-from-env --display-name="' & ncProvisionDisplayName & '" -- "' & ncProvisionUser & '" 2>&1' & chr(10) &
                    'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:setting "' & ncProvisionUser & '" settings email "' & ncProvisionEmail & '" 2>&1' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #provScript#" timeout="10" />
            <cfexecute name="#provScript#"
                variable="provResult"
                errorVariable="provError"
                timeout="30" />
            <cftry><cffile action="delete" file="#provScript#"><cfcatch type="any"></cfcatch></cftry>

            <!--- VERIFY: confirm the user actually exists in oc_users.
                 Don't trust occ stdout strings ("created successfully" /
                 "already exists") — verify directly via SQL. If post-
                 flight count is 1, the user is provisioned regardless of
                 whether occ created them or they were already there. --->
            <cfset _userExistsScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_user_exists.sh">
            <cfscript>
                fileWrite(_userExistsScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    "docker exec hermes_db_server mariadb -u """ & ncDbUser & """ -p""" & ncDbPass & """ nextcloud -se """ &
                    "SELECT COUNT(*) FROM oc_users WHERE uid='" & ncProvisionUser & "';" &
                    """ 2>&1" & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #_userExistsScript#" timeout="10" />
            <cfset _userExistsResult = "">
            <cfexecute name="#_userExistsScript#" variable="_userExistsResult" timeout="30" />
            <cftry><cffile action="delete" file="#_userExistsScript#"><cfcatch type="any"></cfcatch></cftry>

            <cfset _userExistsCount = -1>
            <cfloop array="#ListToArray(Trim(_userExistsResult), chr(10), false)#" index="_uxLine">
                <cfset _uxLine = Trim(_uxLine)>
                <cfif IsNumeric(_uxLine)>
                    <cfset _userExistsCount = _uxLine>
                    <cfbreak>
                </cfif>
            </cfloop>

            <cfscript>
                fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                    "Provision (" & ncProvisionAuthType & "): " & ncProvisionUser & chr(10) &
                    "Result: " & provResult & chr(10) &
                    "Error: " & provError & chr(10) &
                    "oc_users post-flight count: " & _userExistsCount & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>

            <cfif _userExistsCount EQ 1>
                <cfset ncProvisionResult = "success">

                <!--- For remote-auth: call nextcloud_app_password.cfm
                     purely for its side effect of resetting NC's local
                     password to a fresh random value. Remote-auth users
                     have no usable NC local password (OIDC handles login),
                     so we set one to a random throwaway here as
                     defense-in-depth — it closes the back-channel where
                     NC's Database auth backend might otherwise validate
                     a guessed value via DAV Basic auth.

                     Side effect we DO NOT want: the helper also calls
                     `occ user:auth-tokens:add` and creates an oc_authtoken
                     row labeled "Hermes System". Pre-#197, that token
                     was the DAV credential delivered to remote-auth users
                     in the welcome email. Phase 1b unified everything
                     onto user-generated app passwords (mirrored to
                     oc_authtoken at create time), so this row is now
                     unused dead weight — nothing reads from it, but it
                     IS a valid NC DAV credential nobody's tracking.

                     Fix: immediately delete the just-created token via
                     its captured id. The password-reset side effect we
                     wanted has already happened by the time the helper
                     returns. --->
                <cfif ncProvisionAuthType NEQ "local">
                    <cfset ncAppPasswordAction = "create">
                    <cfset ncAppPasswordUser = ncProvisionUser>
                    <cfinclude template="nextcloud_app_password.cfm">
                    <cfif ncAppPasswordResult EQ "success">
                        <cfset ncProvisionAppPassword = ncAppPassword>

                        <!--- Drop the orphan oc_authtoken row created by
                             the helper. Pre-flight + post-flight SQL
                             checks: verify the row exists before
                             deleting, then verify it's gone after. Same
                             pattern as rotate_db_credentials.sh. If
                             cleanup fails, surface a clear error via
                             ncProvisionError so the admin can audit and
                             clean up manually — but don't fail the
                             overall provisioning, because the mailbox
                             itself is fine; this is just NC-side
                             housekeeping. --->
                        <cfif IsDefined("ncAppPasswordTokenId") AND IsNumeric(ncAppPasswordTokenId)>
                            <cftry>
                                <!--- ncDbUser/ncDbPass already loaded
                                     above for the user-creation post-
                                     flight check; reuse here. --->
                                <cfset _orphanNcDbUser = ncDbUser>
                                <cfset _orphanNcDbPass = ncDbPass>

                                <!--- 1. PRE-FLIGHT: confirm the row the
                                     helper claimed to create actually
                                     exists in oc_authtoken AND belongs
                                     to this user. Defensive against the
                                     helper returning a wrong/stale id. --->
                                <cfset _preflightScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_orphan_preflight.sh">
                                <cfscript>
                                    fileWrite(_preflightScript,
                                        chr(35) & "!/bin/bash" & chr(10) &
                                        "docker exec hermes_db_server mariadb -u """ & _orphanNcDbUser & """ -p""" & _orphanNcDbPass & """ nextcloud -se """ &
                                        "SELECT COUNT(*) FROM oc_authtoken WHERE id=" & ncAppPasswordTokenId & " AND uid='" & ncProvisionUser & "';" &
                                        """ 2>&1" & chr(10),
                                        "utf-8");
                                </cfscript>
                                <cfexecute name="/bin/chmod" arguments="+x #_preflightScript#" timeout="10" />
                                <cfset _preflightResult = "">
                                <cfexecute name="#_preflightScript#" variable="_preflightResult" timeout="30" />
                                <cftry><cffile action="delete" file="#_preflightScript#"><cfcatch type="any"></cfcatch></cftry>

                                <cfset _preflightCount = 0>
                                <cfloop array="#ListToArray(Trim(_preflightResult), chr(10), false)#" index="_preflightLine">
                                    <cfset _preflightLine = Trim(_preflightLine)>
                                    <cfif IsNumeric(_preflightLine)>
                                        <cfset _preflightCount = _preflightLine>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>

                                <cfif _preflightCount EQ 0>
                                    <!--- Helper claimed a token id that
                                         doesn't exist in NC. Possibly the
                                         helper's id-lookup grabbed a stale
                                         id, or the row was deleted between
                                         helper-create and now. Either way,
                                         nothing to delete. Log and move on. --->
                                    <cfset ncProvisionError = "NC orphan cleanup: pre-flight found no oc_authtoken row with id=" & ncAppPasswordTokenId & " for user " & ncProvisionUser & " (helper claimed it created one). Manual audit recommended.">
                                <cfelse>
                                    <!--- 2. DELETE via occ. --->
                                    <cfset _orphanDelScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_drop_orphan.sh">
                                    <cfscript>
                                        fileWrite(_orphanDelScript,
                                            chr(35) & "!/bin/bash" & chr(10) &
                                            'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete "' & ncProvisionUser & '" ' & ncAppPasswordTokenId & ' 2>&1' & chr(10),
                                            "utf-8");
                                    </cfscript>
                                    <cfexecute name="/bin/chmod" arguments="+x #_orphanDelScript#" timeout="10" />
                                    <cfset _orphanDelResult = "">
                                    <cfexecute name="#_orphanDelScript#" variable="_orphanDelResult" timeout="30" />
                                    <cftry><cffile action="delete" file="#_orphanDelScript#"><cfcatch type="any"></cfcatch></cftry>

                                    <!--- 3. POST-FLIGHT: confirm the row
                                         is gone from oc_authtoken. occ
                                         exit code alone isn't enough. --->
                                    <cfset _postflightScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_orphan_postflight.sh">
                                    <cfscript>
                                        fileWrite(_postflightScript,
                                            chr(35) & "!/bin/bash" & chr(10) &
                                            "docker exec hermes_db_server mariadb -u """ & _orphanNcDbUser & """ -p""" & _orphanNcDbPass & """ nextcloud -se """ &
                                            "SELECT COUNT(*) FROM oc_authtoken WHERE id=" & ncAppPasswordTokenId & ";" &
                                            """ 2>&1" & chr(10),
                                            "utf-8");
                                    </cfscript>
                                    <cfexecute name="/bin/chmod" arguments="+x #_postflightScript#" timeout="10" />
                                    <cfset _postflightResult = "">
                                    <cfexecute name="#_postflightScript#" variable="_postflightResult" timeout="30" />
                                    <cftry><cffile action="delete" file="#_postflightScript#"><cfcatch type="any"></cfcatch></cftry>

                                    <cfset _postflightCount = -1>
                                    <cfloop array="#ListToArray(Trim(_postflightResult), chr(10), false)#" index="_postflightLine">
                                        <cfset _postflightLine = Trim(_postflightLine)>
                                        <cfif IsNumeric(_postflightLine)>
                                            <cfset _postflightCount = _postflightLine>
                                            <cfbreak>
                                        </cfif>
                                    </cfloop>

                                    <cfif _postflightCount NEQ 0>
                                        <cfset ncProvisionError = "NC orphan cleanup FAILED: oc_authtoken row id=" & ncAppPasswordTokenId & " still present after occ user:auth-tokens:delete. occ output: " & Left(_orphanDelResult, 300)>
                                    </cfif>
                                </cfif>
                            <cfcatch type="any">
                                <cfset ncProvisionError = "NC orphan cleanup threw: " & cfcatch.message & " / " & cfcatch.detail>
                            </cfcatch>
                            </cftry>
                        <cfelse>
                            <!--- Helper succeeded but didn't return a
                                 numeric token id. Should not happen with
                                 the mariadb fix; surface clearly if it
                                 does so we know to investigate. --->
                            <cfset ncProvisionError = "NC orphan cleanup skipped: helper returned no token id (ncAppPasswordTokenId was empty or non-numeric). Possible orphan oc_authtoken row left in NC for " & ncProvisionUser & ".">
                        </cfif>
                    </cfif>
                </cfif>
            <cfelse>
                <cfset ncProvisionResult = "error">
                <cfset ncProvisionError = "occ user:add ran but oc_users SELECT returned count=" & _userExistsCount & " for " & ncProvisionUser & " (expected 1). occ STDOUT: " & Left(provResult, 300) & " / occ STDERR: " & Left(provError, 300)>
            </cfif>

        <cfcatch type="any">
            <cfset ncProvisionResult = "error">
            <cfset ncProvisionError = cfcatch.message>
        </cfcatch>
        </cftry>
    </cfif>

<cfelseif ncProvisionAction EQ "delete">

    <!--- When a mailbox is deleted, the NC user is deleted via
         occ user:delete in the mailbox delete flow. Nothing extra
         needed here - this case exists for future use. --->
    <cfset ncProvisionResult = "skipped">

</cfif>
