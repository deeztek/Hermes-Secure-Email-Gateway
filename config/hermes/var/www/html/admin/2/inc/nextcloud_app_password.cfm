
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
NEXTCLOUD APP PASSWORD MANAGEMENT
Create / regenerate / delete a Nextcloud app password named "Hermes System"
for a mailbox user. The token lets DAV clients (CalDAV, CardDAV, WebDAV)
authenticate against NC even when the user has no local password — which is
the case for remote-auth (OIDC-provisioned) mailboxes.

Required inputs:
  - ncAppPasswordAction : "create" | "regenerate" | "delete"
  - ncAppPasswordUser   : Nextcloud username (the mailbox email)

Outputs:
  - ncAppPassword       : plaintext token value (only set for create/regen success)
  - ncAppPasswordResult : "success" | "skipped" | "error: <reason>"
  - ncAppPasswordError  : raw occ / mysql output on failure

Why this is more involved than it looks:
  Our NC's `occ user:auth-tokens:add` does not accept `--name` — tokens
  are always created with the OCC binary's default name (typically "cli"
  or "occ", depending on NC version). To get a stable, identifiable name
  ("Hermes System") we let occ create the token, then UPDATE oc_authtoken
  in the NC database to rename the most recently created token for that
  user. The plaintext value printed by occ is the actual DAV credential;
  we capture that and return it to the caller. The DB hash stays as NC
  created it — we never touch it.

Debug log: /opt/hermes/tmp/nc_app_password_debug.log records every attempt
with raw occ output so silent failures are diagnosable.
--->

<cfparam name="ncAppPasswordAction" default="">
<cfparam name="ncAppPasswordUser"   default="">

<cfset ncAppPassword = "">
<cfset ncAppPasswordResult = "skipped">
<cfset ncAppPasswordError = "">
<cfset ncAppPasswordName = "Hermes System">
<cfset ncAppPasswordDebugLog = "/opt/hermes/tmp/nc_app_password_debug.log">

<cfif ncAppPasswordAction NEQ "" AND ncAppPasswordUser NEQ "">
<cftry>

    <cfinclude template="generate_customtrans.cfm">

    <!--- === DELETE / REGENERATE: find and delete existing tokens named
         "Hermes System" for this user. Uses occ user:auth-tokens:list
         --output=json and matches on the `name` field. === --->
    <cfif ncAppPasswordAction EQ "delete" OR ncAppPasswordAction EQ "regenerate">
        <cftry>
            <cfset listScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_list_tokens.sh">
            <cfscript>
                fileWrite(listScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:list "' & ncAppPasswordUser & '" --output=json 2>&1' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #listScript#" timeout="10" />
            <cfexecute name="#listScript#" variable="listResult" errorVariable="listError" timeout="30" />
            <cftry><cffile action="delete" file="#listScript#"><cfcatch type="any"></cfcatch></cftry>

            <cfif isDefined("listResult") AND Len(trim(listResult)) GT 0 AND IsJSON(trim(listResult))>
                <cftry>
                    <cfset tokenList = DeserializeJSON(trim(listResult))>

                    <cfif IsArray(tokenList)>
                        <cfloop array="#tokenList#" index="tokenData">
                            <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName AND StructKeyExists(tokenData, "id")>
                                <cftry>
                                    <cfset delScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_del_" & tokenData.id & ".sh">
                                    <cfscript>
                                        fileWrite(delScript,
                                            chr(35) & "!/bin/bash" & chr(10) &
                                            'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete "' & ncAppPasswordUser & '" ' & tokenData.id & ' 2>&1' & chr(10),
                                            "utf-8");
                                    </cfscript>
                                    <cfexecute name="/bin/chmod" arguments="+x #delScript#" timeout="10" />
                                    <cfexecute name="#delScript#" variable="delResult" timeout="30" />
                                    <cftry><cffile action="delete" file="#delScript#"><cfcatch type="any"></cfcatch></cftry>
                                <cfcatch type="any"></cfcatch>
                                </cftry>
                            </cfif>
                        </cfloop>
                    <cfelseif IsStruct(tokenList)>
                        <cfloop collection="#tokenList#" item="tokenId">
                            <cfset tokenData = tokenList[tokenId]>
                            <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                                <cftry>
                                    <cfset delScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_del_" & tokenId & ".sh">
                                    <cfscript>
                                        fileWrite(delScript,
                                            chr(35) & "!/bin/bash" & chr(10) &
                                            'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete "' & ncAppPasswordUser & '" ' & tokenId & ' 2>&1' & chr(10),
                                            "utf-8");
                                    </cfscript>
                                    <cfexecute name="/bin/chmod" arguments="+x #delScript#" timeout="10" />
                                    <cfexecute name="#delScript#" variable="delResult" timeout="30" />
                                    <cftry><cffile action="delete" file="#delScript#"><cfcatch type="any"></cfcatch></cftry>
                                <cfcatch type="any"></cfcatch>
                                </cftry>
                            </cfif>
                        </cfloop>
                    </cfif>
                <cfcatch type="any"></cfcatch>
                </cftry>
            </cfif>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>

    <!--- === CREATE / REGENERATE: generate a fresh token === --->
    <cfif ncAppPasswordAction EQ "create" OR ncAppPasswordAction EQ "regenerate">

        <!--- occ user:auth-tokens:add validates the user's local NC
             password before creating the token. Remote-auth users have
             no usable local password (OIDC is their login path), so we
             set a fresh random one via occ user:resetpassword first,
             then use it for the token call. The random password sticks
             around in NC but is never consulted — OIDC takes over the
             account on login and never checks the local hash. --->
        <cfset tokenGenPassword = "Hermes" & createUUID() & createUUID()>

        <cfset resetScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_reset_pwd.sh">
        <cfscript>
            fileWrite(resetScript,
                chr(35) & "!/bin/bash" & chr(10) &
                'docker exec -e OC_PASS="' & tokenGenPassword & '" -u www-data hermes_nextcloud php /var/www/html/occ user:resetpassword --password-from-env "' & ncAppPasswordUser & '" 2>&1' & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #resetScript#" timeout="10" />
        <cfexecute name="#resetScript#"
            variable="resetResult"
            errorVariable="resetError"
            timeout="30" />
        <cftry><cffile action="delete" file="#resetScript#"><cfcatch type="any"></cfcatch></cftry>

        <!--- Now create the token with the password we just set. --name
             is not supported by this NC version — tokens land with the
             default CLI name and we rename them via DB UPDATE below. --->
        <cfset addScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_add_token.sh">
        <cfscript>
            fileWrite(addScript,
                chr(35) & "!/bin/bash" & chr(10) &
                'docker exec -e OC_PASS="' & tokenGenPassword & '" -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:add --password-from-env "' & ncAppPasswordUser & '" 2>&1' & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #addScript#" timeout="10" />
        <cfexecute name="#addScript#"
            variable="addResult"
            errorVariable="addError"
            timeout="30" />
        <cftry><cffile action="delete" file="#addScript#"><cfcatch type="any"></cfcatch></cftry>

        <cfif NOT isDefined("addResult")><cfset addResult = ""></cfif>

        <!--- Parse the plaintext token from occ output. Expected formats:
               "app password created for <user>: <TOKEN>"
               "<TOKEN>"
             Scan each non-empty line right-to-left for the first word that
             looks like an app password (alnum, 20+ chars). --->
        <cfset extracted = "">
        <cfif Len(trim(addResult)) GT 0>
            <cfset addLines = ListToArray(addResult, chr(10), false)>
            <cfloop from="#ArrayLen(addLines)#" to="1" step="-1" index="iLine">
                <cfset line = trim(addLines[iLine])>
                <cfif Len(line) EQ 0><cfcontinue></cfif>
                <cfset words = ListToArray(line, " " & chr(9), false)>
                <cfloop from="#ArrayLen(words)#" to="1" step="-1" index="iWord">
                    <cfset w = trim(words[iWord])>
                    <cfset w = REReplace(w, "[[:punct:]]+$", "")>
                    <cfif Len(w) GTE 20 AND REFind("^[A-Za-z0-9]+$", w) GT 0>
                        <cfset extracted = w>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif Len(extracted) GT 0><cfbreak></cfif>
            </cfloop>
        </cfif>

        <cfset renameResult = "">
        <cfset renameError = "">

        <cfif Len(extracted) GT 0>
            <!--- Token created. Rename the most recent oc_authtoken row
                 for this user to "Hermes System" so we can find it later
                 via occ user:auth-tokens:list. --->
            <cftry>
                <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncDbUser" charset="utf-8">
                <cfset ncDbUser = Trim(ncDbUser)>
                <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncDbPass" charset="utf-8">
                <cfset ncDbPass = Trim(ncDbPass)>

                <cfset renameScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_token_rename.sh">
                <cfscript>
                    fileWrite(renameScript,
                        chr(35) & "!/bin/bash" & chr(10) &
                        "docker exec hermes_db_server mysql -u """ & ncDbUser & """ -p""" & ncDbPass & """ nextcloud -e """ &
                        "UPDATE oc_authtoken SET name='" & ncAppPasswordName & "' WHERE uid='" & ncAppPasswordUser & "' ORDER BY id DESC LIMIT 1;" &
                        """ 2>&1" & chr(10),
                        "utf-8");
                </cfscript>
                <cfexecute name="/bin/chmod" arguments="+x #renameScript#" timeout="10" />
                <cfexecute name="#renameScript#"
                    variable="renameResult"
                    errorVariable="renameError"
                    timeout="30" />
                <cftry><cffile action="delete" file="#renameScript#"><cfcatch type="any"></cfcatch></cftry>
            <cfcatch type="any">
                <cfset renameError = cfcatch.message & " / " & cfcatch.detail>
            </cfcatch>
            </cftry>
        </cfif>

        <!--- Debug log: always write an entry so silent failures are
             diagnosable. --->
        <cftry>
            <cfset logBody = "[" & DateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss") & "] " &
                ncAppPasswordAction & " for " & ncAppPasswordUser & chr(10) &
                "resetpassword STDOUT: " & Left(isDefined("resetResult") ? resetResult : "", 500) & chr(10) &
                "resetpassword STDERR: " & Left(isDefined("resetError") ? resetError : "", 500) & chr(10) &
                "occ STDOUT:" & chr(10) & Left(addResult, 2000) & chr(10) &
                "occ STDERR:" & chr(10) & Left(isDefined("addError") ? addError : "", 2000) & chr(10) &
                "Extracted token length: " & Len(extracted) & chr(10) &
                "mysql rename STDOUT: " & Left(renameResult, 500) & chr(10) &
                "mysql rename STDERR: " & Left(renameError, 500) & chr(10) &
                "---" & chr(10)>
            <cffile action="append" file="#ncAppPasswordDebugLog#" output="#logBody#" charset="utf-8">
        <cfcatch type="any"></cfcatch>
        </cftry>

        <cfif Len(extracted) GT 0>
            <cfset ncAppPassword = extracted>
            <cfset ncAppPasswordResult = "success">
        <cfelse>
            <cfset ncAppPasswordResult = "error: could not parse token from occ output">
            <cfset ncAppPasswordError = "STDOUT: " & Left(addResult, 500) & " / STDERR: " & Left(isDefined("addError") ? addError : "", 500)>
        </cfif>

    <cfelseif ncAppPasswordAction EQ "delete">
        <cfset ncAppPasswordResult = "success">
    </cfif>

<cfcatch type="any">
    <cfset ncAppPasswordResult = "error: " & cfcatch.message>
    <cfset ncAppPasswordError = cfcatch.detail>
    <cftry>
        <cffile action="append" file="#ncAppPasswordDebugLog#"
            output="[#DateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss")#] EXCEPTION: #cfcatch.message# / #cfcatch.detail#
---
"
            charset="utf-8">
    <cfcatch type="any"></cfcatch>
    </cftry>
</cfcatch>
</cftry>
</cfif>
