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
AUTH SERVICE: password reset and password change

Lives OUTSIDE the web root (/opt/hermes/cfml), so no URL can reach it.
Pages load it through the "/hermesauth" mapping defined in their
Application.cfc. An Application.cfc mapping is never web accessible: Lucee
resolves the requested file before it reads Application.cfc.

Design rules (GHSA-wwxm-p5f2-q6xm, GHSA-rgx7-j3qv-h2gm, GHSA-h2c7-jjqq-j49j):
  - Every public function demands proof (a valid reset token, or the
    current password). None of them takes "which account" on trust.
  - The account, its groups and the delivery address are always derived
    here, from LDAP and the database. Callers cannot choose them.
  - Every value that reaches a command line is checked against a strict
    allowlist first. Passwords never reach a command line: they go to
    slappasswd and ldapwhoami through a temporary file.
  - Reset tokens are stored only as a SHA-256 hash.
  - No function has access="remote".
--->

<cfcomponent displayname="HermesAuthService" output="false">

    <cfset variables.DOCKER     = "/usr/local/bin/docker">
    <cfset variables.LDAPI      = "ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi">
    <cfset variables.USERS_BASE = "ou=users,dc=hermes,dc=local">
    <cfset variables.GROUPS_BASE = "ou=groups,dc=hermes,dc=local">
    <cfset variables.TMP        = "/opt/hermes/tmp/">
    <cfset variables.TOKEN_MINUTES = 15>
    <cfset variables.PW_MIN = 8>
    <cfset variables.PW_MAX = 128>
    <cfset variables.FORM_MINUTES = 30>

    <cffunction name="init" access="public" returntype="any" output="false">
        <cfreturn this>
    </cffunction>

    <!--- ================================================================
         PUBLIC: forgot password
         Always returns quietly. The page shows one generic message whatever
         happened, so the response never reveals whether an account exists,
         is an administrator, or was rate limited.
         ================================================================ --->
    <cffunction name="requestReset" access="public" returntype="void" output="false">
        <cfargument name="email" type="string" required="true">

        <cfset var e = LCase(Trim(arguments.email))>
        <cfset var acct = "">
        <cfset var q = "">
        <cfset var method = "">
        <cfset var recipient = "">
        <cfset var userType = "">
        <cfset var token = "">
        <cfset var ins = "">

        <cfif NOT isSafeEmail(e)>
            <cfreturn>
        </cfif>

        <cfset acct = lookupAccount(e)>
        <cfif NOT acct.found>
            <cfset logEvent("reset ignored: no account for #e#")>
            <cfreturn>
        </cfif>
        <cfif acct.isAdmin>
            <cfset logEvent("reset refused: administrator account #acct.cn#")>
            <cfreturn>
        </cfif>
        <cfif isRemoteAuth(e)>
            <cfset logEvent("reset refused: remote authentication account #acct.cn#")>
            <cfreturn>
        </cfif>

        <cfif acct.isRelay>
            <cfset userType = "relay">
            <cfset method = "email">
            <cfset recipient = e>
        <cfelseif acct.isMailbox>
            <cfset userType = "mailbox">
            <cfquery name="q" datasource="hermes">
                SELECT secondary_email, secondary_email_verified
                FROM user_settings
                WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#e#">
            </cfquery>
            <cfif q.recordcount EQ 1 AND Val(q.secondary_email_verified) EQ 1
                  AND isSafeEmail(LCase(Trim(q.secondary_email)))>
                <cfset method = "email">
                <cfset recipient = LCase(Trim(q.secondary_email))>
            <cfelse>
                <cfset method = "admin">
            </cfif>
        <cfelse>
            <cfreturn>
        </cfif>

        <!--- Rate limit: one open request per account per 15 minutes --->
        <cfquery name="q" datasource="hermes">
            SELECT id FROM password_reset_requests
            WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#e#">
              AND status = 'pending'
              AND requested_at > DATE_SUB(NOW(), INTERVAL 15 MINUTE)
            LIMIT 1
        </cfquery>
        <cfif q.recordcount GTE 1>
            <cfset logEvent("reset rate limited: open request #q.id# for #acct.cn# is under 15 minutes old")>
            <cfreturn>
        </cfif>

        <cfif method EQ "email">
            <cfset token = newToken()>
            <cfquery datasource="hermes" result="ins">
                INSERT INTO password_reset_requests
                    (email, ldap_username, user_type, token, notification_method, status, expires_at)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#e#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#acct.cn#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#userType#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#tokenHash(token)#">,
                    'email', 'pending',
                    DATE_ADD(NOW(), INTERVAL #variables.TOKEN_MINUTES# MINUTE)
                )
            </cfquery>
            <cfif NOT sendResetMail(recipient, token)>
                <cfquery datasource="hermes">
                    UPDATE password_reset_requests SET status = 'cancelled'
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ins.generatedKey#">
                </cfquery>
                <cfset logEvent("reset mail could not be sent for #acct.cn#")>
            </cfif>
        <cfelse>
            <!--- No self-service address: an administrator resets it from the
                 console. No token is created, so there is nothing to steal. --->
            <cfquery datasource="hermes" result="ins">
                INSERT INTO password_reset_requests
                    (email, ldap_username, user_type, token, notification_method, status, expires_at)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#e#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#acct.cn#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#userType#">,
                    NULL, 'admin', 'pending', NULL
                )
            </cfquery>
            <cfset notifyAdmins(ins.generatedKey)>
        </cfif>
    </cffunction>

    <!--- ================================================================
         PUBLIC: check a reset link before showing the form
         Returns {valid, error, email}. error: invalid | used | expired
         ================================================================ --->
    <cffunction name="checkResetToken" access="public" returntype="struct" output="false">
        <cfargument name="token" type="string" required="true">

        <cfset var r = {valid = false, error = "invalid", email = ""}>
        <cfset var q = "">

        <cfif NOT isTokenFormat(arguments.token)>
            <cfreturn r>
        </cfif>

        <cfquery name="q" datasource="hermes">
            SELECT id, email, status,
                   (expires_at IS NOT NULL AND expires_at > NOW()) AS still_valid
            FROM password_reset_requests
            WHERE token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tokenHash(arguments.token)#">
              AND notification_method = 'email'
            LIMIT 1
        </cfquery>

        <cfif q.recordcount EQ 0>
            <cfreturn r>
        </cfif>
        <cfif q.status NEQ "pending">
            <cfset r.error = "used">
            <cfreturn r>
        </cfif>
        <cfif NOT Val(q.still_valid)>
            <cfquery datasource="hermes">
                UPDATE password_reset_requests SET status = 'expired'
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.id#">
                  AND status = 'pending'
            </cfquery>
            <cfset r.error = "expired">
            <cfreturn r>
        </cfif>

        <cfset r.valid = true>
        <cfset r.error = "">
        <cfset r.email = q.email>
        <cfreturn r>
    </cffunction>

    <!--- ================================================================
         PUBLIC: set a new password with a reset link
         Returns {success, error}. error: invalid | password | ldap
         ================================================================ --->
    <cffunction name="resetPasswordWithToken" access="public" returntype="struct" output="false">
        <cfargument name="token" type="string" required="true">
        <cfargument name="newPassword" type="string" required="true">

        <cfset var r = {success = false, error = "invalid"}>
        <cfset var q = "">
        <cfset var claim = "">
        <cfset var acct = "">

        <cfif NOT isTokenFormat(arguments.token)>
            <cfreturn r>
        </cfif>
        <cfif NOT isAcceptablePassword(arguments.newPassword)>
            <cfset r.error = "password">
            <cfreturn r>
        </cfif>

        <cfquery name="q" datasource="hermes">
            SELECT id, email, ldap_username
            FROM password_reset_requests
            WHERE token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tokenHash(arguments.token)#">
              AND notification_method = 'email'
              AND status = 'pending'
              AND expires_at > NOW()
            LIMIT 1
        </cfquery>
        <cfif q.recordcount NEQ 1>
            <cfreturn r>
        </cfif>

        <!--- Claim the request atomically, so one link can never be used twice,
             not even by two requests arriving at the same moment. --->
        <cfquery datasource="hermes" result="claim">
            UPDATE password_reset_requests
            SET status = 'completed', completed_at = NOW()
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.id#">
              AND status = 'pending'
        </cfquery>
        <cfif claim.recordcount NEQ 1>
            <cfreturn r>
        </cfif>

        <!--- Re-derive the account from LDAP. The stored row is only a pointer. --->
        <cfset acct = lookupAccount(q.email)>
        <cfif NOT acct.found OR CompareNoCase(acct.cn, q.ldap_username) NEQ 0
              OR acct.isAdmin OR NOT (acct.isRelay OR acct.isMailbox) OR isRemoteAuth(q.email)>
            <cfset logEvent("reset refused at redemption for request #q.id#")>
            <cfreturn r>
        </cfif>

        <cfif NOT setLdapPassword(acct.dn, arguments.newPassword)>
            <!--- Give the link back so the user can try again --->
            <cfquery datasource="hermes">
                UPDATE password_reset_requests SET status = 'pending', completed_at = NULL
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.id#">
            </cfquery>
            <cfset r.error = "ldap">
            <cfreturn r>
        </cfif>

        <cfquery datasource="hermes">
            UPDATE password_reset_requests SET status = 'expired'
            WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q.email#">
              AND status = 'pending'
              AND id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#q.id#">
        </cfquery>

        <cfset logEvent("password reset completed for #acct.cn#")>
        <cfset sendChangedMail(q.email)>
        <cfset r.success = true>
        <cfset r.error = "">
        <cfreturn r>
    </cffunction>

    <!--- ================================================================
         PUBLIC: signed-in user changes their own password
         email must be the authenticated identity (session.email), never a
         form value. Returns {success, error}. error: notfound | oldpassword |
         password | ldap
         ================================================================ --->
    <cffunction name="changeOwnPassword" access="public" returntype="struct" output="false">
        <cfargument name="email" type="string" required="true">
        <cfargument name="oldPassword" type="string" required="true">
        <cfargument name="newPassword" type="string" required="true">

        <cfset var r = {success = false, error = "notfound"}>
        <cfset var acct = "">

        <cfif NOT isAcceptablePassword(arguments.newPassword)>
            <cfset r.error = "password">
            <cfreturn r>
        </cfif>

        <cfset acct = lookupAccount(LCase(Trim(arguments.email)))>
        <cfif NOT acct.found>
            <cfreturn r>
        </cfif>

        <cfif NOT verifyLdapPassword(acct.dn, arguments.oldPassword)>
            <cfset r.error = "oldpassword">
            <cfreturn r>
        </cfif>

        <cfif NOT setLdapPassword(acct.dn, arguments.newPassword)>
            <cfset r.error = "ldap">
            <cfreturn r>
        </cfif>

        <cfset logEvent("password changed by its owner for #acct.cn#")>
        <cfset sendChangedMail(LCase(Trim(arguments.email)))>
        <cfset r.success = true>
        <cfset r.error = "">
        <cfreturn r>
    </cffunction>

    <!--- ================================================================
         PUBLIC: read-only account lookup by e-mail
         Returns {found, cn, dn, isRelay, isMailbox, isAdmin}. Changes nothing.
         ================================================================ --->
    <cffunction name="lookupAccount" access="public" returntype="struct" output="false">
        <cfargument name="email" type="string" required="true">

        <cfset var r = {found = false, cn = "", dn = "", isRelay = false, isMailbox = false, isAdmin = false}>
        <cfset var e = LCase(Trim(arguments.email))>
        <cfset var out = "">
        <cfset var dns = []>
        <cfset var line = "">
        <cfset var m = "">

        <cfif NOT isSafeEmail(e)>
            <cfreturn r>
        </cfif>

        <cftry>
            <cfset out = ldapSearch(variables.USERS_BASE, "(mail=#e#)")>
        <cfcatch type="any">
            <cfreturn r>
        </cfcatch>
        </cftry>

        <cfloop list="#out#" index="line" delimiters="#Chr(10)##Chr(13)#">
            <cfif Left(line, 4) EQ "dn: ">
                <cfset ArrayAppend(dns, Trim(Mid(line, 5, Len(line))))>
            </cfif>
        </cfloop>

        <!--- Exactly one match, or nothing --->
        <cfif ArrayLen(dns) NEQ 1>
            <cfreturn r>
        </cfif>

        <cfset m = REFindNoCase("^cn=([A-Za-z0-9._@+-]{1,254}),ou=users,dc=hermes,dc=local$", dns[1], 1, true)>
        <cfif m.pos[1] EQ 0>
            <cfreturn r>
        </cfif>

        <cfset r.cn = Mid(dns[1], m.pos[2], m.len[2])>
        <cfset r.dn = "cn=" & r.cn & "," & variables.USERS_BASE>
        <cfset r.found = true>
        <cfset r.isRelay   = isGroupMember("relays", r.dn)>
        <cfset r.isMailbox = isGroupMember("mailboxes", r.dn)>
        <cfset r.isAdmin   = isGroupMember("admins", r.dn)>
        <cfreturn r>
    </cffunction>

    <!--- ================================================================
         PUBLIC: one-time form tokens
         issueFormToken(purpose) stores a fresh random token in the caller's
         session (one per purpose; issuing again replaces it) and returns it
         for a hidden field. consumeFormToken(purpose, value) deletes the
         stored token FIRST, whatever happens next, then returns true only
         if the value matched and the token was under FORM_MINUTES old.
         A submission can therefore never be replayed, resubmitted by
         refresh or back button, or forged from another site.
         ================================================================ --->
    <cffunction name="issueFormToken" access="public" returntype="string" output="false">
        <cfargument name="purpose" type="string" required="true">

        <cfset var t = "">
        <cfif NOT isPurpose(arguments.purpose)>
            <cfthrow message="AuthService: invalid form token purpose">
        </cfif>
        <cfif NOT StructKeyExists(session, "hermesFormTokens") OR NOT IsStruct(session.hermesFormTokens)>
            <cfset session.hermesFormTokens = {}>
        </cfif>
        <cfset t = newToken()>
        <cfset session.hermesFormTokens[arguments.purpose] = {value = t, issued = Now()}>
        <cfreturn t>
    </cffunction>

    <cffunction name="consumeFormToken" access="public" returntype="boolean" output="false">
        <cfargument name="purpose" type="string" required="true">
        <cfargument name="value" type="string" required="true">

        <cfset var held = "">
        <cfif NOT isPurpose(arguments.purpose)
              OR NOT StructKeyExists(session, "hermesFormTokens")
              OR NOT IsStruct(session.hermesFormTokens)
              OR NOT StructKeyExists(session.hermesFormTokens, arguments.purpose)>
            <cfreturn false>
        </cfif>

        <cfset held = session.hermesFormTokens[arguments.purpose]>
        <cfset StructDelete(session.hermesFormTokens, arguments.purpose)>

        <cfif NOT IsStruct(held) OR NOT StructKeyExists(held, "value") OR NOT StructKeyExists(held, "issued")>
            <cfreturn false>
        </cfif>
        <cfif NOT isTokenFormat(arguments.value)>
            <cfreturn false>
        </cfif>
        <cfif DateDiff("n", held.issued, Now()) GE variables.FORM_MINUTES>
            <cfreturn false>
        </cfif>
        <!--- constant-time comparison --->
        <cfreturn createObject("java", "java.security.MessageDigest").isEqual(
            JavaCast("string", held.value).getBytes("UTF-8"),
            JavaCast("string", arguments.value).getBytes("UTF-8"))>
    </cffunction>

    <!--- ================================================================
         PRIVATE
         ================================================================ --->

    <cffunction name="isSafeEmail" access="private" returntype="boolean" output="false">
        <cfargument name="s" type="string" required="true">
        <cfreturn Len(arguments.s) GE 3 AND Len(arguments.s) LE 254
            AND REFind("^[a-z0-9._+-]+@[a-z0-9-]+(\.[a-z0-9-]+)+$", arguments.s) GT 0>
    </cffunction>

    <cffunction name="isSafeDn" access="private" returntype="boolean" output="false">
        <cfargument name="dn" type="string" required="true">
        <cfreturn REFindNoCase("^cn=[A-Za-z0-9._@+-]{1,254},ou=users,dc=hermes,dc=local$", arguments.dn) GT 0>
    </cffunction>

    <cffunction name="isTokenFormat" access="private" returntype="boolean" output="false">
        <cfargument name="token" type="string" required="true">
        <cfreturn REFind("^[a-f0-9]{64}$", arguments.token) GT 0>
    </cffunction>

    <cffunction name="isAcceptablePassword" access="private" returntype="boolean" output="false">
        <cfargument name="pw" type="string" required="true">
        <cfset var i = 0>
        <cfset var c = 0>
        <cfif Len(arguments.pw) LT variables.PW_MIN OR Len(arguments.pw) GT variables.PW_MAX>
            <cfreturn false>
        </cfif>
        <cfloop from="1" to="#Len(arguments.pw)#" index="i">
            <cfset c = Asc(Mid(arguments.pw, i, 1))>
            <cfif c LT 32 OR c EQ 127>
                <cfreturn false>
            </cfif>
        </cfloop>
        <cfreturn true>
    </cffunction>

    <cffunction name="isPurpose" access="private" returntype="boolean" output="false">
        <cfargument name="s" type="string" required="true">
        <cfreturn REFind("^[a-z_]{1,40}$", arguments.s) GT 0>
    </cffunction>

    <cffunction name="newToken" access="private" returntype="string" output="false">
        <!--- 32 bytes from the JVM's SecureRandom, as 64 hex characters --->
        <cfreturn LCase(BinaryEncode(BinaryDecode(GenerateSecretKey("AES", 256), "base64"), "hex"))>
    </cffunction>

    <cffunction name="tokenHash" access="private" returntype="string" output="false">
        <cfargument name="token" type="string" required="true">
        <cfreturn LCase(Hash(arguments.token, "SHA-256", "UTF-8"))>
    </cffunction>

    <cffunction name="randomName" access="private" returntype="string" output="false">
        <cfreturn LCase(BinaryEncode(BinaryDecode(GenerateSecretKey("AES", 128), "base64"), "hex"))>
    </cffunction>

    <cffunction name="isRemoteAuth" access="private" returntype="boolean" output="false">
        <cfargument name="email" type="string" required="true">
        <cfset var q = "">
        <cfquery name="q" datasource="hermes">
            SELECT auth_type FROM recipients
            WHERE recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
        </cfquery>
        <cfreturn q.recordcount GT 0 AND q.auth_type EQ "remote">
    </cffunction>

    <!--- Values reaching this command line are already allowlisted
         (isSafeEmail / isSafeDn); there is no quoting to get wrong. --->
    <cffunction name="ldapSearch" access="private" returntype="string" output="false">
        <cfargument name="base" type="string" required="true">
        <cfargument name="filter" type="string" required="true">
        <cfset var out = "">
        <cfset var err = "">
        <cfexecute name="#variables.DOCKER#"
            arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H #variables.LDAPI# -LLL -o ldif-wrap=no -b #arguments.base# #arguments.filter# dn"
            variable="out"
            errorVariable="err"
            timeout="60" />
        <cfreturn out>
    </cffunction>

    <cffunction name="isGroupMember" access="private" returntype="boolean" output="false">
        <cfargument name="group" type="string" required="true">
        <cfargument name="dn" type="string" required="true">
        <cfset var out = "">
        <cfif NOT ListFind("relays,mailboxes,admins", arguments.group) OR NOT isSafeDn(arguments.dn)>
            <cfreturn false>
        </cfif>
        <cftry>
            <cfset out = ldapSearch("cn=#arguments.group#,#variables.GROUPS_BASE#", "(member=#arguments.dn#)")>
        <cfcatch type="any">
            <cfreturn false>
        </cfcatch>
        </cftry>
        <cfreturn FindNoCase("dn: cn=#arguments.group#,#variables.GROUPS_BASE#", out) GT 0>
    </cffunction>

    <!--- Passwords go through a temp file (shared with hermes_ldap), never
         a command line, so no character in them can reach a shell. --->
    <cffunction name="writeSecretFile" access="private" returntype="string" output="false">
        <cfargument name="secret" type="string" required="true">
        <cfset var path = variables.TMP & randomName() & "_pw.txt">
        <cfset FileWrite(path, arguments.secret, "utf-8")>
        <cfreturn path>
    </cffunction>

    <cffunction name="removeFile" access="private" returntype="void" output="false">
        <cfargument name="path" type="string" required="true">
        <cftry>
            <cfif arguments.path NEQ "" AND FileExists(arguments.path)>
                <cfset FileDelete(arguments.path)>
            </cfif>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="verifyLdapPassword" access="private" returntype="boolean" output="false">
        <cfargument name="dn" type="string" required="true">
        <cfargument name="password" type="string" required="true">
        <cfset var pwFile = "">
        <cfset var out = "">
        <cfset var err = "">
        <cfset var ok = false>

        <cfif NOT isSafeDn(arguments.dn) OR Len(arguments.password) EQ 0 OR Len(arguments.password) GT 1024>
            <cfreturn false>
        </cfif>
        <cftry>
            <cfset pwFile = writeSecretFile(arguments.password)>
            <cfexecute name="#variables.DOCKER#"
                arguments="exec hermes_ldap ldapwhoami -x -D #arguments.dn# -y #pwFile#"
                variable="out"
                errorVariable="err"
                timeout="30" />
            <cfset ok = (CompareNoCase(Trim(out), "dn:" & arguments.dn) EQ 0)>
        <cfcatch type="any">
            <cfset ok = false>
        </cfcatch>
        <cffinally>
            <cfset removeFile(pwFile)>
        </cffinally>
        </cftry>
        <cfreturn ok>
    </cffunction>

    <cffunction name="setLdapPassword" access="private" returntype="boolean" output="false">
        <cfargument name="dn" type="string" required="true">
        <cfargument name="password" type="string" required="true">
        <cfset var pwFile = "">
        <cfset var ldifFile = "">
        <cfset var pwHash = "">
        <cfset var out = "">
        <cfset var err = "">
        <cfset var ok = false>

        <cfif NOT isSafeDn(arguments.dn) OR NOT isAcceptablePassword(arguments.password)>
            <cfreturn false>
        </cfif>

        <cftry>
            <cfset pwFile = writeSecretFile(arguments.password)>
            <cfexecute name="#variables.DOCKER#"
                arguments="exec hermes_ldap slappasswd -o module-load=argon2.la -h {ARGON2} -T #pwFile#"
                variable="pwHash"
                errorVariable="err"
                timeout="60" />
            <cfset removeFile(pwFile)>
            <cfset pwFile = "">
            <cfset pwHash = Trim(pwHash)>

            <!--- The hash goes into an LDIF line, so it must be exactly a hash --->
            <cfif REFind("^\{ARGON2\}\$argon2(id|i|d)\$v=[0-9]+\$m=[0-9]+,t=[0-9]+,p=[0-9]+\$[A-Za-z0-9+/]+\$[A-Za-z0-9+/]+$", pwHash) EQ 0>
                <cfthrow message="unexpected slappasswd output">
            </cfif>

            <cfset ldifFile = variables.TMP & randomName() & "_pw.ldif">
            <cfset FileWrite(ldifFile,
                "dn: " & arguments.dn & Chr(10) &
                "changetype: modify" & Chr(10) &
                "replace: userPassword" & Chr(10) &
                "userPassword: " & pwHash & Chr(10), "utf-8")>

            <cfexecute name="#variables.DOCKER#"
                arguments="exec hermes_ldap ldapmodify -Y EXTERNAL -H #variables.LDAPI# -f #ldifFile#"
                variable="out"
                errorVariable="err"
                timeout="60" />

            <cfset ok = (FindNoCase('modifying entry "' & arguments.dn & '"', out & err) GT 0
                         AND FindNoCase("ldap_modify:", err) EQ 0)>
        <cfcatch type="any">
            <cfset ok = false>
        </cfcatch>
        <cffinally>
            <cfset removeFile(pwFile)>
            <cfset removeFile(ldifFile)>
        </cffinally>
        </cftry>
        <cfreturn ok>
    </cffunction>

    <cffunction name="consoleHost" access="private" returntype="string" output="false">
        <cfset var q = "">
        <cfquery name="q" datasource="hermes">
            SELECT value2 FROM parameters2 WHERE parameter = 'console.host' AND module = 'console'
        </cfquery>
        <cfreturn Trim(q.value2)>
    </cffunction>

    <cffunction name="postmaster" access="private" returntype="string" output="false">
        <cfset var q = "">
        <cfquery name="q" datasource="hermes">
            SELECT value FROM system_settings WHERE parameter = 'postmaster'
        </cfquery>
        <cfreturn Trim(q.value)>
    </cffunction>

    <cffunction name="sendResetMail" access="private" returntype="boolean" output="false">
        <cfargument name="recipient" type="string" required="true">
        <cfargument name="token" type="string" required="true">
        <cfset var link = "https://" & consoleHost() & "/user-auth/reset_password.cfm?token=" & arguments.token>
        <cftry>
            <cfmail from="#postmaster()#" to="#arguments.recipient#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Password Reset Request" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Password Reset Request</h2>
<p>Someone, presumably you, has requested to reset your password.</p>
<p>If you did <strong>NOT</strong> initiate this request, you can safely ignore this message and no action will be taken.</p>
<p>If you did initiate this request, please click the button below to reset your password:</p>
<div style="margin: 20px 0;">
    <a href="#EncodeForHTMLAttribute(link)#" style="background-color: ##007bff; color: ##ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;">Reset Password</a>
</div>
<p style="color: ##6c757d; font-size: 12px;">If the button above doesn't work, copy and paste this URL into your browser:</p>
<p style="color: ##6c757d; font-size: 12px; word-break: break-all;">#EncodeForHTML(link)#</p>
<p style="margin-top: 20px;"><b>*** This link is only valid for #variables.TOKEN_MINUTES# minutes ***</b></p>
<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">This is an automated message from Hermes SEG.</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
            </cfmail>
        <cfcatch type="any">
            <cfreturn false>
        </cfcatch>
        </cftry>
        <cfreturn true>
    </cffunction>

    <!--- "Password changed" notice to every address the owner controls: the
         account address and, if set and verified, the recovery address. If an
         attacker holds one of them, the real owner still hears about it at the
         other. One message per address, so neither address is disclosed to
         the other recipient. --->
    <cffunction name="sendChangedMail" access="private" returntype="void" output="false">
        <cfargument name="account" type="string" required="true">

        <cfset var a = LCase(Trim(arguments.account))>
        <cfset var q = "">
        <cfset var rec = "">
        <cfif NOT isSafeEmail(a)>
            <cfreturn>
        </cfif>
        <cfset sendChangedMailTo(a, a)>

        <cftry>
            <cfquery name="q" datasource="hermes">
                SELECT secondary_email, secondary_email_verified
                FROM user_settings
                WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#">
            </cfquery>
            <cfif q.recordcount EQ 1 AND Val(q.secondary_email_verified) EQ 1>
                <cfset rec = LCase(Trim(q.secondary_email))>
                <cfif isSafeEmail(rec) AND rec NEQ a>
                    <cfset sendChangedMailTo(rec, a)>
                </cfif>
            </cfif>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="sendChangedMailTo" access="private" returntype="void" output="false">
        <cfargument name="recipient" type="string" required="true">
        <cfargument name="account" type="string" required="true">
        <cfif NOT isSafeEmail(LCase(Trim(arguments.recipient))) OR NOT isSafeEmail(LCase(Trim(arguments.account)))>
            <cfreturn>
        </cfif>
        <cftry>
            <cfmail from="#postmaster()#" to="#arguments.recipient#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Password changed for #LCase(Trim(arguments.account))#" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">User Console Password Changed</h2>
<p>Someone, presumably you, has changed the Hermes SEG password for:</p>
<p style="font-size: 16px;"><strong>#EncodeForHTML(LCase(Trim(arguments.account)))#</strong></p>
<p style="color: ##6c757d;">#EncodeForHTML(DateTimeFormat(Now(), "yyyy-mm-dd HH:nn"))# (server time)</p>
<p>If you did initiate this change, you can safely ignore this message.</p>
<p>If you <strong>did NOT</strong> initiate this change, please contact your Hermes SEG Administrator immediately as this may indicate an account compromise.</p>
<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">This is an automated message from Hermes SEG.</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
            </cfmail>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cffunction>

    <!--- Reads the details from the request row itself and encodes them --->
    <cffunction name="notifyAdmins" access="private" returntype="void" output="false">
        <cfargument name="requestId" type="numeric" required="true">
        <cfset var req = "">
        <cfset var admins = "">
        <cfset var typeDisplay = "">
        <cfset var panelLink = "https://" & consoleHost() & "/admin/2/view_password_reset_requests.cfm">
        <cfset var from = postmaster()>

        <cfquery name="req" datasource="hermes">
            SELECT email, ldap_username, user_type, requested_at
            FROM password_reset_requests
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.requestId#">
        </cfquery>
        <cfif req.recordcount NEQ 1>
            <cfreturn>
        </cfif>
        <cfset typeDisplay = (req.user_type EQ "relay") ? "Relay Recipient" : "Mailbox User">

        <cfquery name="admins" datasource="hermes">
            SELECT email FROM system_users
            WHERE applied = '1' AND email IS NOT NULL AND email <> ''
        </cfquery>

        <cfloop query="admins">
            <cfif isSafeEmail(LCase(Trim(admins.email)))>
            <cftry>
                <cfmail from="#from#" to="#admins.email#" server="hermes_postfix_dkim" port="10026" subject="[Hermes SEG] Password Reset Request Pending" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Password Reset Request</h2>
<p>A <strong>#typeDisplay#</strong> has requested a password reset and requires administrator assistance.</p>
<table border="0" cellpadding="8" style="background-color: ##f8f9fa; border-radius: 5px; margin: 20px 0;">
<tr><td><strong>User Email:</strong></td><td>#EncodeForHTML(req.email)#</td></tr>
<tr><td><strong>LDAP Username:</strong></td><td>#EncodeForHTML(req.ldap_username)#</td></tr>
<tr><td><strong>User Type:</strong></td><td>#typeDisplay#</td></tr>
<tr><td><strong>Requested At:</strong></td><td>#DateFormat(req.requested_at, "yyyy-mm-dd")# #TimeFormat(req.requested_at, "HH:mm:ss")#</td></tr>
</table>
<div style="margin: 20px 0;">
    <a href="#EncodeForHTMLAttribute(panelLink)#" style="background-color: ##007bff; color: ##ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;">View Password Reset Requests</a>
</div>
<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">This is an automated message from Hermes SEG.</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
                </cfmail>
            <cfcatch type="any"></cfcatch>
            </cftry>
            </cfif>
        </cfloop>
    </cffunction>

    <cffunction name="logEvent" access="private" returntype="void" output="false">
        <cfargument name="msg" type="string" required="true">
        <cftry>
            <cflog file="hermes-auth" type="information" text="#arguments.msg#">
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cffunction>

</cfcomponent>
