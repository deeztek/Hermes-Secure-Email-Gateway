<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.
Distributed under the GNU AGPL v3 (or later). See https://www.gnu.org/licenses/agpl.html.
--->

<!---
ADMIN APP PASSWORD ACTIONS HANDLER (#197 Phase 1 + 1b)

Mirrors users/2/inc/app_password_actions.cfm but operates on a target
mailbox identified by URL/form param (mailbox_id) rather than the logged-
in user. Caller is presumed to be in the admins group (Authelia gates
the /admin path).

create (Phase 1b — mirrors to NC oc_authtoken):
  1. Validate mailbox_id → fetch mailbox.username
  2. Validate label
  3. Mint a Nextcloud auth token via nextcloud_app_password.cfm
     (occ user:auth-tokens:add, with the chosen label)
  4. NC returns the plaintext token + the new oc_authtoken row id
  5. Hash that plaintext via doveadm pw -s ARGON2ID
  6. INSERT row (mailbox.username, label, hash, nc_token_id)
  7. Stash plaintext in session.adminNewAppPasswordPlain for one-shot
     display on the redirected admin page
  Result: a single plaintext that the admin can hand to the user, which
  works for IMAP/SMTP and CalDAV/CardDAV.

revoke (Phase 1b — also deletes the NC oc_authtoken row):
  1. Look up the row to be revoked (must belong to this mailbox)
  2. If it has a non-null nc_token_id, call occ user:auth-tokens:delete
  3. UPDATE app_passwords SET revoked_at = NOW()
--->

<cfparam name="form.action" default="">
<cfparam name="form.mailbox_id" default="">
<cfparam name="url.mailbox_id" default="">

<cfset _adminMailboxId = form.mailbox_id NEQ "" ? form.mailbox_id : url.mailbox_id>

<cfif NOT IsNumeric(_adminMailboxId)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfquery name="getMailboxForApp" datasource="hermes">
    SELECT id, username
    FROM mailboxes
    WHERE id = <cfqueryparam value="#_adminMailboxId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailboxForApp.recordCount EQ 0>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset _adminMailboxUsername = getMailboxForApp.username>
<cfset _adminRedirectUrl = "view_mailbox_app_passwords.cfm?mailbox_id=" & _adminMailboxId>

<cfif form.action EQ "create">

    <cfparam name="form.label" default="">
    <cfset _labelTrim = Trim(form.label)>

    <cfif _labelTrim EQ "" OR Len(_labelTrim) GT 100>
        <cfset session.m = 11>
        <cflocation url="#_adminRedirectUrl#" addtoken="no">
    </cfif>

    <!--- 1. Mint NC oc_authtoken first; helper returns plaintext + row id. --->
    <cfset ncAppPasswordAction = "create">
    <cfset ncAppPasswordUser   = _adminMailboxUsername>
    <cfset ncAppPasswordName   = _labelTrim>
    <cfinclude template="nextcloud_app_password.cfm">

    <cfif ncAppPasswordResult NEQ "success" OR Len(ncAppPassword) EQ 0>
        <cfset session.m = 32>
        <cfset session.adminNewAppPasswordError = Left(ncAppPasswordError, 200)>
        <cflocation url="#_adminRedirectUrl#" addtoken="no">
    </cfif>

    <cfset _newPlain = ncAppPassword>
    <cfset _newNcTokenId = ncAppPasswordTokenId>

    <!--- 2. Hash the NC plaintext via doveadm pw for Hermes Dovecot. --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_dovecot doveadm pw -s ARGON2ID -p #_newPlain#"
            variable="_passwordHash"
            timeout="60" />
        <cfset _passwordHash = Trim(_passwordHash)>

        <cfif _passwordHash EQ "" OR NOT FindNoCase("{ARGON2ID}", _passwordHash)>
            <cfthrow message="doveadm pw returned unexpected output: #_passwordHash#">
        </cfif>
    <cfcatch type="any">
        <cfset session.m = 30>
        <cflocation url="#_adminRedirectUrl#" addtoken="no">
    </cfcatch>
    </cftry>

    <!--- 3. INSERT row in Hermes app_passwords. --->
    <cftry>
        <cfquery datasource="hermes">
            INSERT INTO app_passwords (username, label, password, nc_token_id)
            VALUES (
                <cfqueryparam value="#_adminMailboxUsername#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#_labelTrim#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#_passwordHash#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#_newNcTokenId#" cfsqltype="cf_sql_varchar" null="#(_newNcTokenId EQ '')#">
            )
        </cfquery>
    <cfcatch type="any">
        <cfset session.m = 31>
        <cflocation url="#_adminRedirectUrl#" addtoken="no">
    </cfcatch>
    </cftry>

    <cfset session.adminNewAppPasswordPlain = _newPlain>
    <cfset session.adminNewAppPasswordLabel = _labelTrim>
    <cfset session.adminNewAppPasswordUser  = _adminMailboxUsername>
    <cfset session.m = 1>
    <cflocation url="#_adminRedirectUrl#" addtoken="no">

<cfelseif form.action EQ "revoke">

    <cfparam name="form.id" default="">

    <cfif NOT IsNumeric(form.id)>
        <cfset session.m = 12>
        <cflocation url="#_adminRedirectUrl#" addtoken="no">
    </cfif>

    <!--- Look up the row first so we can grab nc_token_id for NC cleanup
         and confirm ownership (defensive across mailboxes). --->
    <cfquery name="getAdminRowToRevoke" datasource="hermes">
        SELECT id, nc_token_id
        FROM app_passwords
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
          AND username = <cfqueryparam value="#_adminMailboxUsername#" cfsqltype="cf_sql_varchar">
          AND revoked_at IS NULL
    </cfquery>

    <!--- 1. Best-effort delete of the NC oc_authtoken side. --->
    <cfif getAdminRowToRevoke.recordCount EQ 1 AND IsNumeric(getAdminRowToRevoke.nc_token_id)>
        <cftry>
            <cfinclude template="generate_customtrans.cfm">
            <cfset _delTokenScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_token_admindel.sh">
            <cfscript>
                fileWrite(_delTokenScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete "' & _adminMailboxUsername & '" ' & getAdminRowToRevoke.nc_token_id & ' 2>&1' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #_delTokenScript#" timeout="10" />
            <cfexecute name="#_delTokenScript#" variable="_delTokenResult" timeout="30" />
            <cftry><cffile action="delete" file="#_delTokenScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfcatch type="any">
            <!--- NC delete failed; continue with local revocation. --->
        </cfcatch>
        </cftry>
    </cfif>

    <!--- 2. Local revocation. --->
    <cfquery datasource="hermes">
        UPDATE app_passwords
           SET revoked_at = NOW()
         WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
           AND username = <cfqueryparam value="#_adminMailboxUsername#" cfsqltype="cf_sql_varchar">
           AND revoked_at IS NULL
    </cfquery>

    <cfset session.m = 2>
    <cflocation url="#_adminRedirectUrl#" addtoken="no">

</cfif>
