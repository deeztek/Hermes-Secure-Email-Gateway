
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

    <cfif ncProvisionAuthType EQ "local">

        <!--- ============================================================
             LOCAL AUTH PATH: occ user:add + occ user:setting email
             ============================================================ --->
        <cfif ncProvisionPassword EQ "">
            <cfset ncProvisionResult = "skipped">
            <cfset ncProvisionError = "No password provided for local auth">
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
                        "Provision (local): " & ncProvisionUser & chr(10) &
                        "Result: " & provResult & chr(10) &
                        "Error: " & provError & chr(10) &
                        "---" & chr(10),
                        "utf-8");
                </cfscript>

                <cfif FindNoCase("created successfully", provResult) OR FindNoCase("already exists", provResult)>
                    <cfset ncProvisionResult = "success">
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

    <cfelse>

        <!--- ============================================================
             REMOTE AUTH PATH: user_oidc REST API pre-provisioning
             Creates an OIDC-backed NC user with no local password. When
             the user logs in via Authelia/OIDC, user_oidc sees the
             existing account and takes over (soft_auto_provision=true).
             ============================================================ --->
        <cftry>
            <!--- Read NC admin credentials for Basic Auth to the OCS API --->
            <cffile action="read" file="/opt/hermes/creds/nextcloud_admin_username" variable="ncAdminUser" charset="utf-8">
            <cfset ncAdminUser = Trim(ncAdminUser)>
            <cffile action="read" file="/opt/hermes/creds/nextcloud_admin_password" variable="ncAdminPass" charset="utf-8">
            <cfset ncAdminPass = Trim(ncAdminPass)>

            <!--- Look up the user_oidc provider ID for "Hermes_SEG".
                 The API call needs the numeric provider ID, not the name. --->
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user_oidc:provider --output=json"
                variable="providerListJson"
                errorVariable="providerListError"
                timeout="30" />

            <cfset providerId = "">
            <cfif IsDefined("providerListJson") AND IsJSON(Trim(providerListJson))>
                <cfset providers = DeserializeJSON(Trim(providerListJson))>
                <cfif IsArray(providers)>
                    <cfloop array="#providers#" index="p">
                        <cfif IsStruct(p) AND StructKeyExists(p, "identifier") AND p.identifier EQ "Hermes_SEG">
                            <cfset providerId = p.id>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>

            <cfif providerId EQ "">
                <cfset ncProvisionResult = "error">
                <cfset ncProvisionError = "Could not find Hermes_SEG provider ID">
                <cfscript>
                    fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                        "Provision (remote) ERROR: Provider not found" & chr(10) &
                        "occ output: " & Left(providerListJson, 500) & chr(10) &
                        "occ error: " & Left(providerListError, 500) & chr(10) &
                        "---" & chr(10),
                        "utf-8");
                </cfscript>
            <cfelse>
                <!--- POST to user_oidc provisioning API. Uses hermes_nextcloud:80
                     (Docker internal) without /nc/ prefix — /nc/ is the Nginx
                     reverse-proxy path, not NC's own URL. --->
                <cfhttp url="http://hermes_nextcloud:80/ocs/v2.php/apps/user_oidc/api/v1/user"
                    method="POST"
                    timeout="30"
                    username="#ncAdminUser#"
                    password="#ncAdminPass#">
                    <cfhttpparam type="header" name="OCS-APIREQUEST" value="true">
                    <cfhttpparam type="header" name="Content-Type" value="application/json">
                    <cfhttpparam type="body" value='{"providerId":#providerId#,"userId":"#ncProvisionUser#","displayName":"#ncProvisionDisplayName#","email":"#ncProvisionEmail#"}'>
                </cfhttp>

                <cfscript>
                    fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                        "Provision (remote): " & ncProvisionUser & chr(10) &
                        "Provider ID: " & providerId & chr(10) &
                        "HTTP Status: " & cfhttp.statusCode & chr(10) &
                        "Response: " & Left(cfhttp.fileContent, 500) & chr(10) &
                        "---" & chr(10),
                        "utf-8");
                </cfscript>

                <cfif cfhttp.statusCode CONTAINS "200">
                    <cfset ncProvisionResult = "success">

                    <!--- Generate the "Hermes System" DAV app password.
                         Remote-auth users have no local NC password, so
                         CalDAV/CardDAV/WebDAV clients need this token as
                         their credential. The plaintext is returned in
                         ncProvisionAppPassword for the caller to include
                         in the welcome email (this is the only chance to
                         capture it — NC won't show it again). --->
                    <cfset ncAppPasswordAction = "create">
                    <cfset ncAppPasswordUser = ncProvisionUser>
                    <cfinclude template="nextcloud_app_password.cfm">
                    <cfif ncAppPasswordResult EQ "success">
                        <cfset ncProvisionAppPassword = ncAppPassword>
                    </cfif>
                <cfelse>
                    <cfset ncProvisionResult = "error">
                    <cfset ncProvisionError = "user_oidc API HTTP " & cfhttp.statusCode & ": " & Left(cfhttp.fileContent, 200)>
                </cfif>
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
