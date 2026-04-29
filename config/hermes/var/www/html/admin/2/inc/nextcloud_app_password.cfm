
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
Create / regenerate / delete a Nextcloud app password (oc_authtoken row)
for a mailbox user. The token lets DAV clients (CalDAV, CardDAV, WebDAV)
authenticate against NC, regardless of auth type. After #197 Phase 1b
this is the mirror target for every user-generated Hermes app password.

Required inputs:
  - ncAppPasswordAction : "create" | "regenerate" | "delete"
  - ncAppPasswordUser   : Nextcloud username (the mailbox email)

Optional inputs:
  - ncAppPasswordName   : Token label (default "Hermes System"). Set per-call
                          to the user's Hermes app-password label so the NC
                          token shows the same name in NC's Personal Settings
                          &rarr; Devices & sessions.

Outputs:
  - ncAppPassword       : plaintext token value (only set for create/regen success)
  - ncAppPasswordResult : "success" | "skipped" | "error: <reason>"
  - ncAppPasswordError  : raw occ / mysql output on failure

Why this is more involved than it looks:
  Our NC's `occ user:auth-tokens:add` does not accept `--name` — tokens
  are always created with the OCC binary's default name (typically "cli"
  or "occ", depending on NC version). To get a stable, identifiable name
  we let occ create the token, then UPDATE oc_authtoken in the NC
  database to rename the most recently created token for that user. The
  plaintext value printed by occ is the actual DAV credential; we
  capture that and return it to the caller. The DB hash stays as NC
  created it — we never touch it.

  Side effect: occ user:auth-tokens:add requires verifying the user's
  oc_users.password, so this helper also resets that to a fresh random
  on every call. That is consistent with our defense-in-depth model
  (oc_users.password is not used by anything user-facing) and effectively
  rotates the NC internal password as a free side benefit.

Debug log: /opt/hermes/tmp/nc_app_password_debug.log records every attempt
with raw occ output so silent failures are diagnosable.
--->

<cfparam name="ncAppPasswordAction" default="">
<cfparam name="ncAppPasswordUser"   default="">
<cfparam name="ncAppPasswordName"   default="Hermes System">

<cfset ncAppPassword = "">
<cfset ncAppPasswordTokenId = "">
<cfset ncAppPasswordResult = "skipped">
<cfset ncAppPasswordError = "">
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

        <!--- Read NC DB credentials once, reused below by the rename
             + id-lookup queries. --->
        <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncDbUser" charset="utf-8">
        <cfset ncDbUser = Trim(ncDbUser)>
        <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncDbPass" charset="utf-8">
        <cfset ncDbPass = Trim(ncDbPass)>

        <!--- Now create the token with the password we just set. --name
             is not supported by this NC version — tokens land with the
             default CLI name and we rename them via DB UPDATE below.
             occ user:auth-tokens:add only emits the plaintext on stdout
             when it has actually committed the oc_authtoken row; failed
             inserts throw and exit non-zero. So a successfully extracted
             plaintext IS the proof of row creation — no separate
             pre/post-flight count check needed. --->
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

        <!--- Parse the plaintext token from occ output. Anchored on the
             literal "app password" marker so we never grab random alnum
             strings from other places in the output (warnings, debug
             noise, etc). NC versions emit one of these two formats:
               1. "app password created for <user>: <TOKEN>"   (older)
               2. "app password:" newline "<TOKEN>"            (current)
             The "(?: created for [^:]+)?" group makes the suffix
             optional; "\s*" after the colon consumes whitespace AND
             newlines (Java regex \s matches \n). Capture group 1 is
             the token. If the marker isn't present OR the captured
             token is shorter than 20 chars, extracted stays empty and
             the rest of the flow surfaces an error. --->
        <cfset extracted = "">
        <cfset _addMatch = REFind("app password(?: created for [^:]+)?:\s*([A-Za-z0-9]{20,})", addResult, 1, true)>
        <cfif IsArray(_addMatch.pos) AND ArrayLen(_addMatch.pos) GTE 2 AND _addMatch.pos[2] GT 0>
            <cfset extracted = Mid(addResult, _addMatch.pos[2], _addMatch.len[2])>
        </cfif>

        <cfset renameResult = "">
        <cfset renameError = "">
        <cfset hashLookupResult = "">

        <cfif Len(extracted) GT 0>
            <!--- VERIFICATION: independently confirm the extracted plaintext
                 corresponds to a real oc_authtoken row, by computing
                 SHA-512(plaintext + NC_secret) ourselves and looking it
                 up directly. NC stores oc_authtoken.token as that hex
                 hash (PublicKeyTokenProvider::hashToken in NC source).
                 If our computed hash doesn't match any row, either the
                 extraction picked nonsense from stdout, or occ silently
                 failed to commit despite emitting plaintext, or NC's
                 token-hashing scheme changed. Any of those cases must
                 abort — we cannot rely on a token id we can't verify. --->
            <cftry>
                <!--- 1. Read NC's instance secret via occ. Bare command
                     (no 2>&1) so cfexecute can separate stdout (the
                     secret) from stderr (any deprecation warnings). --->
                <cfset secretScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_get_secret.sh">
                <cfscript>
                    fileWrite(secretScript,
                        chr(35) & "!/bin/bash" & chr(10) &
                        "docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:get secret" & chr(10),
                        "utf-8");
                </cfscript>
                <cfexecute name="/bin/chmod" arguments="+x #secretScript#" timeout="10" />
                <cfset secretResult = "">
                <cfset secretError = "">
                <cfexecute name="#secretScript#"
                    variable="secretResult"
                    errorVariable="secretError"
                    timeout="30" />
                <cftry><cffile action="delete" file="#secretScript#"><cfcatch type="any"></cfcatch></cftry>

                <cfset ncSecret = Trim(isDefined("secretResult") ? secretResult : "")>

                <cfif Len(ncSecret) EQ 0>
                    <cfthrow message="Could not read NC instance secret via `occ config:system:get secret`. STDOUT empty. STDERR: #Left(secretError, 300)#">
                </cfif>

                <!--- 2. Compute SHA-512(plaintext + secret) using Java
                     MessageDigest. NC stores the hex result lowercase
                     in oc_authtoken.token. Lucee's Hash() differs
                     across versions, hence the explicit Java call. --->
                <cfset _md = createObject("java", "java.security.MessageDigest").getInstance("SHA-512")>
                <cfset _md.update(JavaCast("string", extracted & ncSecret).getBytes("UTF-8"))>
                <cfset _hashBytes = _md.digest()>
                <cfset _bigInt = createObject("java", "java.math.BigInteger").init(JavaCast("int", 1), _hashBytes)>
                <cfset expectedTokenHash = LCase(_bigInt.toString(JavaCast("int", 16)))>
                <!--- Left-pad to 128 hex chars (SHA-512 = 64 bytes). --->
                <cfloop condition="Len(expectedTokenHash) LT 128">
                    <cfset expectedTokenHash = "0" & expectedTokenHash>
                </cfloop>

                <!--- 3. Look up the row by exact (uid, token) match. The
                     hash is hex chars only, safe to embed in single-
                     quoted SQL. Use `mariadb` not `mysql` to avoid the
                     deprecation warning that would corrupt stdout. --->
                <cfset hashLookupScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_token_hashlookup.sh">
                <cfscript>
                    fileWrite(hashLookupScript,
                        chr(35) & "!/bin/bash" & chr(10) &
                        "docker exec hermes_db_server mariadb -u """ & ncDbUser & """ -p""" & ncDbPass & """ nextcloud -se """ &
                        "SELECT id FROM oc_authtoken WHERE uid='" & ncAppPasswordUser & "' AND token='" & expectedTokenHash & "';" &
                        """ 2>&1" & chr(10),
                        "utf-8");
                </cfscript>
                <cfexecute name="/bin/chmod" arguments="+x #hashLookupScript#" timeout="10" />
                <cfexecute name="#hashLookupScript#" variable="hashLookupResult" timeout="30" />
                <cftry><cffile action="delete" file="#hashLookupScript#"><cfcatch type="any"></cfcatch></cftry>

                <!--- Scan output line-by-line for a numeric id; tolerates
                     any stderr noise that 2>&1 may have merged in. --->
                <cfloop array="#ListToArray(Trim(hashLookupResult), chr(10), false)#" index="_idLine">
                    <cfset _idLine = Trim(_idLine)>
                    <cfif IsNumeric(_idLine) AND Len(_idLine) GT 0>
                        <cfset ncAppPasswordTokenId = _idLine>
                        <cfbreak>
                    </cfif>
                </cfloop>

                <!--- 4. Optional: rename for UX so the token shows up
                     with a meaningful name in NC's UI (Personal Settings
                     > Security > Devices & sessions). Only runs if the
                     hash lookup succeeded — we now know the exact id,
                     so no race-vulnerable "ORDER BY id DESC LIMIT 1". --->
                <cfif IsNumeric(ncAppPasswordTokenId)>
                    <cfset renameScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_token_rename.sh">
                    <cfscript>
                        fileWrite(renameScript,
                            chr(35) & "!/bin/bash" & chr(10) &
                            "docker exec hermes_db_server mariadb -u """ & ncDbUser & """ -p""" & ncDbPass & """ nextcloud -e """ &
                            "UPDATE oc_authtoken SET name='" & ncAppPasswordName & "' WHERE id=" & ncAppPasswordTokenId & ";" &
                            """ 2>&1" & chr(10),
                            "utf-8");
                    </cfscript>
                    <cfexecute name="/bin/chmod" arguments="+x #renameScript#" timeout="10" />
                    <cfexecute name="#renameScript#"
                        variable="renameResult"
                        errorVariable="renameError"
                        timeout="30" />
                    <cftry><cffile action="delete" file="#renameScript#"><cfcatch type="any"></cfcatch></cftry>
                </cfif>
            <cfcatch type="any">
                <cfset renameError = cfcatch.message & " / " & cfcatch.detail>
            </cfcatch>
            </cftry>
        </cfif>

        <!--- Debug log: always write an entry so silent failures are
             diagnosable. Records the hash-lookup output so an admin
             can immediately tell whether the extracted plaintext was
             real or noise (empty result = noise). --->
        <cftry>
            <cfset logBody = "[" & DateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss") & "] " &
                ncAppPasswordAction & " for " & ncAppPasswordUser & chr(10) &
                "resetpassword STDOUT: " & Left(isDefined("resetResult") ? resetResult : "", 500) & chr(10) &
                "resetpassword STDERR: " & Left(isDefined("resetError") ? resetError : "", 500) & chr(10) &
                "occ STDOUT:" & chr(10) & Left(addResult, 2000) & chr(10) &
                "occ STDERR:" & chr(10) & Left(isDefined("addError") ? addError : "", 2000) & chr(10) &
                "Extracted token length: " & Len(extracted) & chr(10) &
                "Hash lookup STDOUT: " & Left(hashLookupResult, 500) & chr(10) &
                "ncAppPasswordTokenId: " & ncAppPasswordTokenId & chr(10) &
                "Rename STDOUT: " & Left(renameResult, 500) & chr(10) &
                "Rename STDERR: " & Left(renameError, 500) & chr(10) &
                "---" & chr(10)>
            <cffile action="append" file="#ncAppPasswordDebugLog#" output="#logBody#" charset="utf-8">
        <cfcatch type="any"></cfcatch>
        </cftry>

        <!--- Success requires both:
             1. extracted plaintext from occ stdout — caught by the
                anchored regex on the literal "app password created for"
                marker. If occ output didn't have that marker, extracted
                stays empty and we abort.
             2. ncAppPasswordTokenId populated — set only when our
                computed SHA-512(plaintext + secret) hash actually
                matches a row in oc_authtoken. If extraction grabbed
                noise, or the secret read failed, or NC never committed
                the row, this lookup fails and we abort.
             Both conditions independently catch a different class of
             failure. Any failure surfaces a specific error so callers
             don't silently INSERT a NULL nc_token_id and orphan the row. --->
        <cfif Len(extracted) GT 0 AND IsNumeric(ncAppPasswordTokenId)>
            <cfset ncAppPassword = extracted>
            <cfset ncAppPasswordResult = "success">
        <cfelseif Len(extracted) EQ 0>
            <cfset ncAppPasswordResult = "error: occ output did not contain expected 'app password created for ...' marker">
            <cfset ncAppPasswordError = "STDOUT: " & Left(addResult, 500) & " / STDERR: " & Left(isDefined("addError") ? addError : "", 500)>
        <cfelse>
            <cfset ncAppPasswordResult = "error: extracted plaintext does not match any oc_authtoken row (hash lookup empty)">
            <cfset ncAppPasswordError = "Hash lookup STDOUT: " & Left(hashLookupResult, 300) & " / Rename STDERR: " & Left(renameError, 300)>
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
