
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
for a mailbox user. This token lets DAV clients (CalDAV, CardDAV, WebDAV)
authenticate against NC even when the user has no local password — which is
the case for remote-auth (OIDC-provisioned) mailboxes. Local-auth mailboxes
don't need this since their NC local password already grants DAV access.

Required inputs:
  - ncAppPasswordAction : "create" | "regenerate" | "delete"
  - ncAppPasswordUser   : Nextcloud username (the mailbox email)

Outputs:
  - ncAppPassword       : plaintext token value (only set for create/regen success)
  - ncAppPasswordResult : "success" | "skipped" | "error: <reason>"
  - ncAppPasswordError  : raw occ output on failure (may be empty)

Implementation notes:
  - Uses the temp-shell-script + 2>&1 pattern. Lucee cfexecute's
    `arguments` attribute splits on whitespace, which mangles args
    that contain spaces (like --name="Hermes System"). Wrapping the
    docker exec in a shell script lets the shell handle quoting
    correctly.
  - `2>&1` merges stderr into stdout so occ messages land in our
    captured variable regardless of which stream occ writes to.
  - Writes to /opt/hermes/tmp/nc_app_password_debug.log so failures
    can be diagnosed after the fact. The log grows unbounded; rotate
    manually if it ever matters.
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

    <!--- === DELETE/REGENERATE: purge existing "Hermes System" tokens === --->
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
            <cfexecute name="#listScript#"
                variable="listResult"
                errorVariable="listError"
                timeout="30" />
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

    <!--- === CREATE/REGENERATE: generate a fresh token === --->
    <cfif ncAppPasswordAction EQ "create" OR ncAppPasswordAction EQ "regenerate">

        <cfset addScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_add_token.sh">
        <cfscript>
            fileWrite(addScript,
                chr(35) & "!/bin/bash" & chr(10) &
                'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:add "' & ncAppPasswordUser & '" --name="' & ncAppPasswordName & '" 2>&1' & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #addScript#" timeout="10" />
        <cfexecute name="#addScript#"
            variable="addResult"
            errorVariable="addError"
            timeout="30" />
        <cftry><cffile action="delete" file="#addScript#"><cfcatch type="any"></cfcatch></cftry>

        <cfif NOT isDefined("addResult")><cfset addResult = ""></cfif>

        <!--- Parse the generated token. Possible occ output shapes we've
             seen across NC versions:
               "App password generated for <user>. Token: <TOKEN>"
               "The following token is now active: <TOKEN>"
               "<TOKEN>"                                  (just the token)
               "Token created for <user>: <TOKEN>"
             Heuristics (in order):
               a) Look for any "token is:" / "token:" / ": <TOKEN>" marker
                  followed by a whitespace-separated word matching an
                  app-password shape (alnum, 20+ chars).
               b) Any bare line that is itself an alnum 20+ char string.
               c) Last whitespace-separated word on the last non-empty
                  line that matches the alnum 20+ char shape. --->
        <cfset extracted = "">
        <cfif Len(trim(addResult)) GT 0>
            <cfset addLines = ListToArray(addResult, chr(10), false)>
            <cfloop from="#ArrayLen(addLines)#" to="1" step="-1" index="iLine">
                <cfset line = trim(addLines[iLine])>
                <cfif Len(line) EQ 0><cfcontinue></cfif>

                <cfset words = ListToArray(line, " " & chr(9), false)>
                <cfloop from="#ArrayLen(words)#" to="1" step="-1" index="iWord">
                    <cfset w = trim(words[iWord])>
                    <!--- Strip trailing punctuation like "." or ":" --->
                    <cfset w = REReplace(w, "[[:punct:]]+$", "")>
                    <cfif Len(w) GTE 20 AND REFind("^[A-Za-z0-9]+$", w) GT 0>
                        <cfset extracted = w>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif Len(extracted) GT 0><cfbreak></cfif>
            </cfloop>
        </cfif>

        <!--- Always write a debug log entry so failures can be diagnosed. --->
        <cftry>
            <cfset logBody = "[" & DateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss") & "] " &
                ncAppPasswordAction & " for " & ncAppPasswordUser & chr(10) &
                "STDOUT:" & chr(10) & Left(addResult, 2000) & chr(10) &
                "STDERR:" & chr(10) & Left(isDefined("addError") ? addError : "", 2000) & chr(10) &
                "Extracted token length: " & Len(extracted) & chr(10) &
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
