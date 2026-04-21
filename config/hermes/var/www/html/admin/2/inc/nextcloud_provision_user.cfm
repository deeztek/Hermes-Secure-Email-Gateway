
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

            <cfscript>
                fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                    "Provision (" & ncProvisionAuthType & "): " & ncProvisionUser & chr(10) &
                    "Result: " & provResult & chr(10) &
                    "Error: " & provError & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>

            <cfif FindNoCase("created successfully", provResult) OR FindNoCase("already exists", provResult)>
                <cfset ncProvisionResult = "success">

                <!--- For remote-auth: generate the "Hermes System" DAV app
                     password now that we have a known local password on
                     the user. nextcloud_app_password.cfm will reset the
                     local password to a fresh random value, then use that
                     to create the token — all in the Database backend, so
                     occ user:resetpassword works. --->
                <cfif ncProvisionAuthType NEQ "local">
                    <cfset ncAppPasswordAction = "create">
                    <cfset ncAppPasswordUser = ncProvisionUser>
                    <cfinclude template="nextcloud_app_password.cfm">
                    <cfif ncAppPasswordResult EQ "success">
                        <cfset ncProvisionAppPassword = ncAppPassword>
                    </cfif>
                </cfif>
            <cfelse>
                <cfset ncProvisionResult = "error">
                <cfset ncProvisionError = provResult>
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
