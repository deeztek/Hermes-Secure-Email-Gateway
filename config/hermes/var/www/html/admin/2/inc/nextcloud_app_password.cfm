
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD APP PASSWORD MANAGEMENT
Creates, updates, or deletes a Nextcloud app password for a mailbox user.
The app password is named "Hermes System" and allows DAV clients
(calendar/contacts/files) to authenticate using the same password as email.

How it works:
  1. Creates an app password token via occ user:auth-tokens:add
  2. Calls nextcloud_app_password_crypto.cfm to replace the token's
     crypto chain (token hash, RSA keypair, encrypted private key,
     encrypted password) so the user's email password works for DAV
  3. Renames the token from "cli" to "Hermes System"

Requires the following variables before including:
  - ncAppPasswordAction: "create", "update", or "delete"
  - ncAppPasswordUser: Nextcloud username (email address)
  - ncAppPasswordValue: plaintext password (required for create/update)

Sets after execution:
  - ncAppPasswordResult: "success", "error", or "skipped"
  - ncAppPasswordError: error message (if any)

Non-fatal: failures are caught and logged but do not block the calling action.
--->

<cfparam name="ncAppPasswordAction" default="">
<cfparam name="ncAppPasswordUser" default="">
<cfparam name="ncAppPasswordValue" default="">

<cfset ncAppPasswordResult = "skipped">
<cfset ncAppPasswordError = "">
<cfset ncAppPasswordName = "Hermes System">

<cfif ncAppPasswordAction EQ "" OR ncAppPasswordUser EQ "">
    <!--- Nothing to do --->

<cfelseif ncAppPasswordAction EQ "delete">

    <!--- DELETE: Remove all app passwords named "Hermes System" for this user --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:list #ncAppPasswordUser# --output=json"
            variable="listResult"
            errorVariable="listError"
            timeout="30" />

        <cfif Len(trim(listResult)) GT 0 AND IsJSON(trim(listResult))>
            <cfset tokenList = DeserializeJSON(trim(listResult))>
            <cfif IsArray(tokenList)>
                <cfloop array="#tokenList#" index="tokenData">
                    <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenData.id#"
                            variable="delResult"
                            errorVariable="delError"
                            timeout="30" />
                    </cfif>
                </cfloop>
            <cfelseif IsStruct(tokenList)>
                <cfloop collection="#tokenList#" item="tokenId">
                    <cfset tokenData = tokenList[tokenId]>
                    <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenId#"
                            variable="delResult"
                            errorVariable="delError"
                            timeout="30" />
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>
        <cfset ncAppPasswordResult = "success">
    <cfcatch type="any">
        <cfset ncAppPasswordResult = "error">
        <cfset ncAppPasswordError = cfcatch.message>
    </cfcatch>
    </cftry>

<cfelseif ncAppPasswordAction EQ "create" OR ncAppPasswordAction EQ "update">

    <cfif ncAppPasswordValue EQ "">
        <cfset ncAppPasswordResult = "skipped">
    <cfelse>
        <cftry>
            <!--- Step 1: If updating, delete existing "Hermes System" tokens first --->
            <cfif ncAppPasswordAction EQ "update">
                <cftry>
                    <cfexecute name="/usr/local/bin/docker"
                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:list #ncAppPasswordUser# --output=json"
                        variable="listResult2"
                        errorVariable="listError2"
                        timeout="30" />
                    <cfif Len(trim(listResult2)) GT 0 AND IsJSON(trim(listResult2))>
                        <cfset tokenList2 = DeserializeJSON(trim(listResult2))>
                        <cfif IsArray(tokenList2)>
                            <cfloop array="#tokenList2#" index="td2">
                                <cfif IsStruct(td2) AND StructKeyExists(td2, "name") AND td2.name EQ ncAppPasswordName>
                                    <cfexecute name="/usr/local/bin/docker"
                                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #td2.id#"
                                        variable="dr2" errorVariable="de2" timeout="30" />
                                </cfif>
                            </cfloop>
                        <cfelseif IsStruct(tokenList2)>
                            <cfloop collection="#tokenList2#" item="tid2">
                                <cfset td2 = tokenList2[tid2]>
                                <cfif IsStruct(td2) AND StructKeyExists(td2, "name") AND td2.name EQ ncAppPasswordName>
                                    <cfexecute name="/usr/local/bin/docker"
                                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tid2#"
                                        variable="dr2" errorVariable="de2" timeout="30" />
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfif>
                <cfcatch type="any"><!--- ignore delete errors ---></cfcatch>
                </cftry>
            </cfif>

            <!--- Step 2: Create a new app password via occ --->
            <cfinclude template="generate_customtrans.cfm">
            <cfset appPwdScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_app_pwd.sh">
            <cfscript>
                fileWrite(appPwdScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -e OC_PASS="' & ncAppPasswordValue & '" -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:add "' & ncAppPasswordUser & '" --password-from-env' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #appPwdScript#" timeout="10" />
            <cfexecute name="#appPwdScript#"
                variable="occResult"
                errorVariable="occError"
                timeout="30" />
            <cftry><cffile action="delete" file="#appPwdScript#"><cfcatch type="any"></cfcatch></cftry>

            <!--- Step 3: Find the token ID we just created (most recent "cli" token for this user) --->
            <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncDbUser" charset="utf-8">
            <cfset ncDbUser = Trim(ncDbUser)>
            <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncDbPass" charset="utf-8">
            <cfset ncDbPass = Trim(ncDbPass)>

            <cfinclude template="generate_customtrans.cfm">
            <cfset findScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_find_token.sh">
            <cfscript>
                fileWrite(findScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    "docker exec hermes_db_server mysql -u """ & ncDbUser & """ -p""" & ncDbPass & """ nextcloud -N -e """ &
                    "SELECT id FROM oc_authtoken WHERE uid='" & ncAppPasswordUser & "' AND name='cli' ORDER BY id DESC LIMIT 1;" &
                    """" & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #findScript#" timeout="10" />
            <cfexecute name="#findScript#"
                variable="tokenIdResult"
                errorVariable="tokenIdError"
                timeout="30" />
            <cftry><cffile action="delete" file="#findScript#"><cfcatch type="any"></cfcatch></cftry>

            <cfset newTokenId = Trim(tokenIdResult)>

            <cfscript>
                fileWrite("/opt/hermes/tmp/nc_apppwd_debug.log",
                    "Step 3 complete" & chr(10) &
                    "occ result: " & occResult & chr(10) &
                    "token ID result: [" & tokenIdResult & "]" & chr(10) &
                    "token ID trimmed: [" & newTokenId & "]" & chr(10) &
                    "is numeric: " & IsNumeric(newTokenId) & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>

            <cfif NOT IsNumeric(newTokenId)>
                <cfthrow message="Could not find newly created token ID. occ output: #occResult# | find result: #tokenIdResult#">
            </cfif>

            <!--- Step 4: Replace the crypto chain using the crypto module --->
            <cfset ncCryptoTokenId = newTokenId>
            <cfset ncCryptoPassword = ncAppPasswordValue>
            <cfset ncCryptoUser = ncAppPasswordUser>
            <cfinclude template="nextcloud_app_password_crypto.cfm">

            <cfscript>
                fileAppend("/opt/hermes/tmp/nc_apppwd_debug.log",
                    "Step 4 complete" & chr(10) &
                    "crypto result: " & ncCryptoResult & chr(10) &
                    "crypto error: " & ncCryptoError & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>

            <cfif ncCryptoResult EQ "success">
                <cfset ncAppPasswordResult = "success">
            <cfelse>
                <cfset ncAppPasswordResult = "error">
                <cfset ncAppPasswordError = ncCryptoError>
            </cfif>

        <cfcatch type="any">
            <cfscript>
                fileWrite("/opt/hermes/tmp/nc_apppwd_debug.log",
                    "EXCEPTION in nextcloud_app_password" & chr(10) &
                    "Message: " & cfcatch.message & chr(10) &
                    "Detail: " & cfcatch.detail & chr(10) &
                    "Type: " & cfcatch.type & chr(10) &
                    "---" & chr(10),
                    "utf-8");
            </cfscript>
            <cfset ncAppPasswordResult = "error">
            <cfset ncAppPasswordError = cfcatch.message & " | " & cfcatch.detail>
        </cfcatch>
        </cftry>
    </cfif>

</cfif>
