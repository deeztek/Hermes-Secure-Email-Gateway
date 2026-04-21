
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
  - ncAppPasswordError  : raw occ stderr on failure (may be empty)

"regenerate" = delete any existing "Hermes System" token(s) for the user
then create a fresh one. Previous DAV clients configured with the old
token stop working the moment the delete completes.

All occ calls go through docker exec on hermes_nextcloud. Failures are
non-fatal from the caller's perspective (the mailbox create/edit succeeds
regardless); the caller should inspect ncAppPasswordResult to decide
whether to surface a warning.
--->

<cfparam name="ncAppPasswordAction" default="">
<cfparam name="ncAppPasswordUser"   default="">

<cfset ncAppPassword = "">
<cfset ncAppPasswordResult = "skipped">
<cfset ncAppPasswordError = "">
<cfset ncAppPasswordName = "Hermes System">

<cfif ncAppPasswordAction NEQ "" AND ncAppPasswordUser NEQ "">
<cftry>

    <!--- === DELETE/REGENERATE: purge existing "Hermes System" tokens === --->
    <cfif ncAppPasswordAction EQ "delete" OR ncAppPasswordAction EQ "regenerate">
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
                    <!--- Output shape varies by NC version: sometimes an array of
                         token structs, sometimes an object keyed by token id.
                         Handle both. --->
                    <cfif IsArray(tokenList)>
                        <cfloop array="#tokenList#" index="tokenData">
                            <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName AND StructKeyExists(tokenData, "id")>
                                <cftry>
                                    <cfexecute name="/usr/local/bin/docker"
                                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenData.id#"
                                        variable="delResult"
                                        errorVariable="delError"
                                        timeout="30" />
                                <cfcatch type="any"></cfcatch>
                                </cftry>
                            </cfif>
                        </cfloop>
                    <cfelseif IsStruct(tokenList)>
                        <cfloop collection="#tokenList#" item="tokenId">
                            <cfset tokenData = tokenList[tokenId]>
                            <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                                <cftry>
                                    <cfexecute name="/usr/local/bin/docker"
                                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenId#"
                                        variable="delResult"
                                        errorVariable="delError"
                                        timeout="30" />
                                <cfcatch type="any"></cfcatch>
                                </cftry>
                            </cfif>
                        </cfloop>
                    </cfif>
                <cfcatch type="any">
                    <!--- JSON parse error - no tokens or unexpected format. Skip. --->
                </cfcatch>
                </cftry>
            </cfif>
        <cfcatch type="any">
            <!--- List failed (user may not exist in NC yet). Fall through
                 to create so a fresh token is generated even if list failed. --->
        </cfcatch>
        </cftry>
    </cfif>

    <!--- === CREATE/REGENERATE: generate a fresh token === --->
    <cfif ncAppPasswordAction EQ "create" OR ncAppPasswordAction EQ "regenerate">

        <cfset addResult = "">
        <cfset addError = "">

        <!--- NC generates a random 24-char token. We do NOT pass --password-from-env
             because remote-auth users have no local password to sync with —
             the token is a standalone DAV credential. --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:add #ncAppPasswordUser# --name=#ncAppPasswordName#"
            variable="addResult"
            errorVariable="addError"
            timeout="30" />

        <!--- Parse the generated password from stdout. Recent NC versions
             print a line like "App password created for <user>. The token is: <TOKEN>"
             or "Generated new app password: <TOKEN>". We grab the last
             whitespace-separated token on the last non-empty line that
             contains ":" or is 20+ chars on its own. --->
        <cfset extracted = "">
        <cfif Len(trim(addResult)) GT 0>
            <cfset addLines = ListToArray(addResult, chr(10), false)>
            <cfloop from="#ArrayLen(addLines)#" to="1" step="-1" index="iLine">
                <cfset line = trim(addLines[iLine])>
                <cfif Len(line) EQ 0>
                    <cfcontinue>
                </cfif>
                <!--- If the line has "token is:" or similar marker, grab the part after. --->
                <cfif REFindNoCase("token\s+is\s*:", line) GT 0>
                    <cfset extracted = trim(ListLast(line, ":"))>
                    <cfbreak>
                </cfif>
                <!--- Otherwise, if the line itself looks like a bare token (no spaces, 20+ chars). --->
                <cfif Len(line) GTE 20 AND REFind("^[A-Za-z0-9]+$", line) GT 0>
                    <cfset extracted = line>
                    <cfbreak>
                </cfif>
                <!--- Fallback: last whitespace-separated word on the line. --->
                <cfset lastWord = trim(ListLast(line, " " & chr(9)))>
                <cfif Len(lastWord) GTE 20 AND REFind("^[A-Za-z0-9]+$", lastWord) GT 0>
                    <cfset extracted = lastWord>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>

        <cfif Len(extracted) GT 0>
            <cfset ncAppPassword = extracted>
            <cfset ncAppPasswordResult = "success">
        <cfelse>
            <cfset ncAppPasswordResult = "error: could not parse token from occ output">
            <cfset ncAppPasswordError = addError & chr(10) & "STDOUT: " & addResult>
        </cfif>

    <cfelseif ncAppPasswordAction EQ "delete">
        <cfset ncAppPasswordResult = "success">
    </cfif>

<cfcatch type="any">
    <cfset ncAppPasswordResult = "error: " & cfcatch.message>
    <cfset ncAppPasswordError = cfcatch.detail>
</cfcatch>
</cftry>
</cfif>
