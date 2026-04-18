
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD USER PRE-PROVISIONING (occ user:add)
Creates a local Nextcloud user with the same password as the mailbox.
When the user logs in via OIDC, user_oidc recognises the existing
account (soft_auto_provision=true) and takes over seamlessly.

The local password enables DAV authentication (CalDAV/CardDAV/WebDAV)
using the same credentials as email — no app passwords needed.

Requires the following variables before including:
  - ncProvisionAction: "create" or "delete"
  - ncProvisionUser: Nextcloud username (email address)
  - ncProvisionDisplayName: Display name (for create)
  - ncProvisionEmail: Email address (for create)
  - ncProvisionPassword: Plaintext password (for create)

Sets after execution:
  - ncProvisionResult: "success", "error", or "skipped"
  - ncProvisionError: error message (if any)
--->

<cfparam name="ncProvisionAction" default="">
<cfparam name="ncProvisionUser" default="">
<cfparam name="ncProvisionDisplayName" default="">
<cfparam name="ncProvisionEmail" default="">
<cfparam name="ncProvisionPassword" default="">

<cfset ncProvisionResult = "skipped">
<cfset ncProvisionError = "">

<cfif ncProvisionAction EQ "" OR ncProvisionUser EQ "">
    <!--- Nothing to do --->

<cfelseif ncProvisionAction EQ "create">

    <cfif ncProvisionPassword EQ "">
        <cfset ncProvisionResult = "skipped">
        <cfset ncProvisionError = "No password provided">
    <cfelse>
        <cftry>
            <!--- Create NC user with occ user:add using password from env var --->
            <cfinclude template="generate_customtrans.cfm">
            <cfset provScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_provision.sh">
            <cfscript>
                fileWrite(provScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -e OC_PASS="' & ncProvisionPassword & '" -u www-data hermes_nextcloud php /var/www/html/occ user:add --password-from-env --display-name="' & ncProvisionDisplayName & '" -- "' & ncProvisionUser & '" 2>&1' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #provScript#" timeout="10" />
            <cfexecute name="#provScript#"
                variable="provResult"
                errorVariable="provError"
                timeout="30" />
            <cftry><cffile action="delete" file="#provScript#"><cfcatch type="any"></cfcatch></cftry>

            <!--- Debug log --->
            <cfscript>
                fileWrite("/opt/hermes/tmp/nc_provision_debug.log",
                    "Provision: " & ncProvisionUser & chr(10) &
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

<cfelseif ncProvisionAction EQ "delete">

    <!--- When a mailbox is deleted, the NC user is deleted via
         occ user:delete in the mailbox delete flow. Nothing extra
         needed here - this case exists for future use. --->
    <cfset ncProvisionResult = "skipped">

</cfif>
