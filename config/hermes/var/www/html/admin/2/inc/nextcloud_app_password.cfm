
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD APP PASSWORD MANAGEMENT
Creates, regenerates, or deletes a Nextcloud app password for a mailbox user.
The app password is named "Hermes System" and allows DAV clients
(calendar/contacts) to authenticate even when the user has 2FA enabled.

Requires the following variables to be set before including:
  - ncAppPasswordAction: "create", "regenerate", or "delete"
  - ncAppPasswordUser: the Nextcloud username (email address)
  - ncAppPasswordValue: the plaintext password (required for create/regenerate)

The app password uses the same value as the user's LDAP password so there
is no additional attack surface. It is synced on every password change
(admin reset or user self-service) and deleted on mailbox deletion.

Uses docker exec to run occ commands inside the hermes_nextcloud container.
Non-fatal: failures are caught and logged but do not block the calling action.
--->

<cfparam name="ncAppPasswordAction" default="">
<cfparam name="ncAppPasswordUser" default="">
<cfparam name="ncAppPasswordValue" default="">

<cfif ncAppPasswordAction EQ "" OR ncAppPasswordUser EQ "">
    <!--- Missing required parameters, skip silently --->
    <cfset ncAppPasswordResult = "skipped">
<cfelse>

<cfset ncAppPasswordResult = "">
<cfset ncAppPasswordError = "">
<cfset ncAppPasswordName = "Hermes System">

<cftry>

    <cfif ncAppPasswordAction EQ "delete" OR ncAppPasswordAction EQ "regenerate">
        <!--- Delete existing app password(s) named "Hermes System".
             occ user:auth-tokens:list returns JSON with token names.
             We parse and delete any matching tokens. --->
        <cfset listResult = "">
        <cfset listError = "">
        <cftry>
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:list #ncAppPasswordUser# --output=json"
                variable="listResult"
                errorVariable="listError"
                timeout="30" />

            <cfif Len(trim(listResult)) GT 0>
                <cftry>
                    <cfset tokenList = DeserializeJSON(listResult)>
                    <!--- tokenList is an object with token IDs as keys --->
                    <cfloop collection="#tokenList#" item="tokenId">
                        <cfset tokenData = tokenList[tokenId]>
                        <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                            <!--- Delete this token --->
                            <cfexecute name="/usr/local/bin/docker"
                                arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenId#"
                                variable="delResult"
                                errorVariable="delError"
                                timeout="30" />
                        </cfif>
                    </cfloop>
                <cfcatch type="any">
                    <!--- JSON parse error or no tokens - continue --->
                </cfcatch>
                </cftry>
            </cfif>
        <cfcatch type="any">
            <!--- List command failed - user may not exist in NC yet --->
        </cfcatch>
        </cftry>
    </cfif>

    <cfif ncAppPasswordAction EQ "create" OR ncAppPasswordAction EQ "regenerate">
        <cfif ncAppPasswordValue EQ "">
            <cfset ncAppPasswordResult = "skipped_no_password">
        <cfelse>
            <!--- Create a new app password using docker exec with env var for password.
                 The --name flag sets the display name visible in NC Security page. --->
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec -e NC_PASS=#ncAppPasswordValue# -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:add #ncAppPasswordUser# --name=#ncAppPasswordName#"
                variable="ncAppPasswordResult"
                errorVariable="ncAppPasswordError"
                timeout="30" />
        </cfif>
    </cfif>

<cfcatch type="any">
    <!--- App password operations are non-fatal. The mailbox creation/edit
         succeeds regardless. Admin can retry by re-saving the mailbox. --->
    <cfset ncAppPasswordResult = "error: " & cfcatch.message>
</cfcatch>
</cftry>

</cfif>
