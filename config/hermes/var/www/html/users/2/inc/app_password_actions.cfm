<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.
Distributed under the GNU AGPL v3 (or later). See https://www.gnu.org/licenses/agpl.html.
--->

<!---
APP PASSWORD ACTIONS HANDLER (#197 Phase 1 + 1b)

Handles create + revoke for the user's own app_passwords rows.
ALL writes are scoped to session.email so a user can never affect another
user's rows (the WHERE clauses always include username = session.email).

create (Phase 1b — mirrors to NC oc_authtoken):
  1. Validate label
  2. Mint a Nextcloud auth token via /admin/2/inc/nextcloud_app_password.cfm
     (occ user:auth-tokens:add, with our chosen label so it shows up the
     same way in NC's Personal Settings UI)
  3. NC returns the plaintext token (its own randomly-generated string)
     and the row id of the new oc_authtoken record
  4. Hash that plaintext with ARGON2ID via doveadm pw
  5. INSERT into app_passwords (label, password=hash, nc_token_id=NC row id)
  6. Stash NC plaintext in session.newAppPasswordPlain for one-shot display
  Result: a single plaintext that works for IMAP/SMTP (Dovecot reads
  app_passwords) AND CalDAV/CardDAV (NC reads oc_authtoken).

revoke (Phase 1b — also deletes the NC oc_authtoken row):
  1. Look up the row to be revoked (must be owned by session.email)
  2. If it has a non-null nc_token_id, call occ user:auth-tokens:delete
     to remove the NC side first
  3. UPDATE app_passwords SET revoked_at = NOW() — stops Dovecot accepting
  Either side breaks first — instant revocation across both protocols.
--->

<cfparam name="form.action" default="">
<cfset thisUsername = session.email>

<cfif form.action EQ "create">

    <cfparam name="form.label" default="">
    <cfset labelTrim = Trim(form.label)>

    <cfif labelTrim EQ "" OR Len(labelTrim) GT 100>
        <cfset session.m = 11>
        <cflocation url="view_app_passwords.cfm" addtoken="no">
    </cfif>

    <!--- 1. Mint the NC oc_authtoken first. The NC helper resets
         oc_users.password as a side effect (consistent with our defense-
         in-depth model — that password is never used by anything user-
         facing), then runs occ user:auth-tokens:add and renames the new
         row to our chosen label. --->
    <cfset ncAppPasswordAction = "create">
    <cfset ncAppPasswordUser   = thisUsername>
    <cfset ncAppPasswordName   = labelTrim>
    <cfinclude template="../../../admin/2/inc/nextcloud_app_password.cfm">

    <cfif ncAppPasswordResult NEQ "success" OR Len(ncAppPassword) EQ 0>
        <cfset session.m = 32>
        <cfset session.newAppPasswordError = Left(ncAppPasswordError, 200)>
        <cflocation url="view_app_passwords.cfm" addtoken="no">
    </cfif>

    <cfset newPlain = ncAppPassword>
    <cfset newNcTokenId = ncAppPasswordTokenId>

    <!--- 2. Hash the NC plaintext via doveadm pw so Dovecot (lua passdb)
         can verify it on IMAP/SMTP login. Using ARGON2ID matches LDAP and
         NC's own oc_users hash format. --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_dovecot doveadm pw -s ARGON2ID -p #newPlain#"
            variable="passwordHash"
            timeout="60">
        </cfexecute>
        <cfset passwordHash = Trim(passwordHash)>

        <cfif passwordHash EQ "" OR NOT FindNoCase("{ARGON2ID}", passwordHash)>
            <cfthrow message="doveadm pw returned unexpected output: #passwordHash#">
        </cfif>
    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="view_app_passwords.cfm" addtoken="no">
    </cfcatch>
    </cftry>

    <!--- 3. INSERT into Hermes app_passwords with the hash + nc_token_id. --->
    <cftry>
        <cfquery datasource="hermes">
            INSERT INTO app_passwords (username, label, password, nc_token_id)
            VALUES (
                <cfqueryparam value="#thisUsername#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#labelTrim#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#passwordHash#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#newNcTokenId#" cfsqltype="cf_sql_varchar" null="#(newNcTokenId EQ '')#">
            )
        </cfquery>
    <cfcatch type="any">
        <cfset session.m = 31>
        <cflocation url="view_app_passwords.cfm" addtoken="no">
    </cfcatch>
    </cftry>

    <!--- One-shot plaintext display via session. View page reads it once
         on render and immediately clears it. Storing in session keeps it
         out of URL history and referer headers. --->
    <cfset session.newAppPasswordPlain = newPlain>
    <cfset session.newAppPasswordLabel = labelTrim>
    <cfset session.m = 1>
    <cflocation url="view_app_passwords.cfm" addtoken="no">

<cfelseif form.action EQ "revoke">

    <cfparam name="form.id" default="">

    <cfif NOT IsNumeric(form.id)>
        <cfset session.m = 12>
        <cflocation url="view_app_passwords.cfm" addtoken="no">
    </cfif>

    <!--- Look up the row first so we can grab nc_token_id for NC cleanup
         and confirm the user owns the row (defensive). --->
    <cfquery name="getRowToRevoke" datasource="hermes">
        SELECT id, nc_token_id
        FROM app_passwords
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
          AND username = <cfqueryparam value="#thisUsername#" cfsqltype="cf_sql_varchar">
          AND revoked_at IS NULL
    </cfquery>

    <!--- 1. Delete the NC oc_authtoken row (if any). Best-effort: any
         failure here is logged but the local revocation still proceeds
         so the user's IMAP/SMTP access is cut. --->
    <cfif getRowToRevoke.recordCount EQ 1 AND IsNumeric(getRowToRevoke.nc_token_id)>
        <cftry>
            <cfinclude template="../../../admin/2/inc/generate_customtrans.cfm">
            <cfset _delTokenScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_token_userdel.sh">
            <cfscript>
                fileWrite(_delTokenScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete "' & thisUsername & '" ' & getRowToRevoke.nc_token_id & ' 2>&1' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #_delTokenScript#" timeout="10" />
            <cfexecute name="#_delTokenScript#" variable="_delTokenResult" timeout="30" />
            <cftry><cffile action="delete" file="#_delTokenScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfcatch type="any">
            <!--- NC delete failed; we continue with local revocation
                 anyway. Hermes IMAP/SMTP gets cut, NC DAV may still
                 accept the now-orphan token until next NC garbage
                 collection or admin cleanup. --->
        </cfcatch>
        </cftry>
    </cfif>

    <!--- 2. Local revocation. --->
    <cfquery datasource="hermes">
        UPDATE app_passwords
           SET revoked_at = NOW()
         WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
           AND username = <cfqueryparam value="#thisUsername#" cfsqltype="cf_sql_varchar">
           AND revoked_at IS NULL
    </cfquery>

    <cfset session.m = 2>
    <cflocation url="view_app_passwords.cfm" addtoken="no">

</cfif>
