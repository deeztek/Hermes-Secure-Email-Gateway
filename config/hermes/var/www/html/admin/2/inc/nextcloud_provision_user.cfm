
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD USER PRE-PROVISIONING (user_oidc API)
Pre-creates a Nextcloud user via the user_oidc provisioning API so that
group membership, mail profile, and app password can be set immediately
at mailbox creation time - without waiting for the user's first OIDC login.

The user is created as an OIDC-backed account (no local password). When
the user eventually logs in via Authelia, user_oidc recognises the existing
account (soft_auto_provision=true) and takes over seamlessly.

Requires the following variables before including:
  - ncProvisionAction: "create" or "delete"
  - ncProvisionUser: Nextcloud username (email address)
  - ncProvisionDisplayName: Display name (for create)
  - ncProvisionEmail: Email address (for create)

Sets after execution:
  - ncProvisionResult: "success", "error", or "skipped"
  - ncProvisionError: error message (if any)
--->

<cfparam name="ncProvisionAction" default="">
<cfparam name="ncProvisionUser" default="">
<cfparam name="ncProvisionDisplayName" default="">
<cfparam name="ncProvisionEmail" default="">

<cfset ncProvisionResult = "skipped">
<cfset ncProvisionError = "">

<cfif ncProvisionAction EQ "" OR ncProvisionUser EQ "">
    <!--- Nothing to do --->

<cfelseif ncProvisionAction EQ "create">

    <cftry>
        <!--- Read NC admin credentials --->
        <cffile action="read" file="/opt/hermes/creds/nextcloud_admin_username" variable="ncAdminUser" charset="utf-8">
        <cfset ncAdminUser = Trim(ncAdminUser)>
        <cffile action="read" file="/opt/hermes/creds/nextcloud_admin_password" variable="ncAdminPass" charset="utf-8">
        <cfset ncAdminPass = Trim(ncAdminPass)>

        <!--- Get the user_oidc provider ID. We registered the provider as
             "Hermes_SEG" - parse the occ output to find its numeric ID. --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user_oidc:provider --output=json"
            variable="providerListJson"
            errorVariable="providerListError"
            timeout="30" />

        <cfset providerId = "">
        <cfif IsJSON(Trim(providerListJson))>
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
                    "ERROR: Provider not found" & chr(10) &
                    "occ output: " & Left(providerListJson, 500) & chr(10) &
                    "occ error: " & Left(providerListError, 500) & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>
        <cfelse>
            <!--- Call the user_oidc pre-provisioning API.
                 URL uses hermes_nextcloud:80 (Docker internal) without /nc/
                 prefix - the /nc/ is Nginx's reverse proxy path, not NC's. --->
            <cfhttp url="http://hermes_nextcloud:80/ocs/v2.php/apps/user_oidc/api/v1/user"
                method="POST"
                timeout="30"
                username="#ncAdminUser#"
                password="#ncAdminPass#">
                <cfhttpparam type="header" name="OCS-APIREQUEST" value="true">
                <cfhttpparam type="header" name="Content-Type" value="application/json">
                <cfhttpparam type="body" value='{"providerId":#providerId#,"userId":"#ncProvisionUser#","displayName":"#ncProvisionDisplayName#","email":"#ncProvisionEmail#"}'>
            </cfhttp>

            <!--- Debug log --->
            <cfscript>
                fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                    "Provision: " & ncProvisionUser & chr(10) &
                    "Provider ID: " & providerId & chr(10) &
                    "HTTP Status: " & cfhttp.statusCode & chr(10) &
                    "Response: " & Left(cfhttp.fileContent, 500) & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>

            <cfif cfhttp.statusCode CONTAINS "200">
                <cfset ncProvisionResult = "success">
            <cfelse>
                <cfset ncProvisionResult = "error">
                <cfset ncProvisionError = "API returned: " & cfhttp.statusCode & " - " & Left(cfhttp.fileContent, 500)>
            </cfif>
        </cfif>

    <cfcatch type="any">
        <cfset ncProvisionResult = "error">
        <cfset ncProvisionError = cfcatch.message>
        <cfscript>
            fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                "EXCEPTION in provision" & chr(10) &
                "Message: " & cfcatch.message & chr(10) &
                "Detail: " & cfcatch.detail & chr(10) &
                "Type: " & cfcatch.type & chr(10) &
                "---" & chr(10),
                "utf-8");
        </cfscript>
    </cfcatch>
    </cftry>

<cfelseif ncProvisionAction EQ "delete">

    <!--- When a mailbox is deleted, the NC user is deleted via
         occ user:delete in the mailbox delete flow. Nothing extra
         needed here - this case exists for future use. --->
    <cfset ncProvisionResult = "skipped">

</cfif>
