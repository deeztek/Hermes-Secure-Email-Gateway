<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.
Distributed under the GNU AGPL v3 (or later). See https://www.gnu.org/licenses/agpl.html.
--->

<!---
ROTATE NC INTERNAL PASSWORD (#197 Phase 1)

Regenerates the random local password stored in NC's oc_users table for
a single mailbox. This is purely defense-in-depth: nothing functional
depends on oc_users.password — NC Mail uses the "Hermes System" app
password (Hermes app_passwords table, read by Dovecot's lua passdb), and
DAV (after Phase 1b) uses user-generated app passwords mirrored to NC's
oc_authtoken. The only purpose of oc_users.password is to be a non-zero
value that can NEVER match anything a user holds, closing the back-channel
where NC's DAV endpoint might otherwise have accepted the user's login
password.

Admins use this to:
  - Respond to suspected NC password-hash leak (rotate everywhere).
  - Force-fix any mailbox that may have been provisioned pre-#197 with
    the user's login password set as oc_users.password.
  - Periodic rotation discipline (or Ofelia-driven rotation later).

See docs/admin/authentication/01-credential-model.md.
--->

<cfif NOT StructKeyExists(form, "rotate_mailbox_id") OR NOT IsNumeric(form.rotate_mailbox_id)>
    <cfset session.m = 50>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfquery name="getMailboxRot" datasource="hermes">
    SELECT id, username, nextcloud_enabled
    FROM mailboxes
    WHERE id = <cfqueryparam value="#form.rotate_mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailboxRot.recordcount LT 1>
    <cfset session.m = 51>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfif Val(getMailboxRot.nextcloud_enabled) NEQ 1>
    <!--- Mailbox is not NC-enabled — there's no oc_users row to rotate.
         Refuse benignly. --->
    <cfset session.m = 52>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- Generate a fresh 30-char random NC internal password
     (cryptographically random, unambiguous alphabet). --->
<cfset _ncRotAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789">
<cfset _ncRotLen = Len(_ncRotAlphabet)>
<cfset newNcInternalPassword = "">
<cfloop from="1" to="30" index="_ncRotIdx">
    <cfset newNcInternalPassword &= Mid(_ncRotAlphabet, RandRange(1, _ncRotLen, "SHA1PRNG"), 1)>
</cfloop>

<!--- Use the established temp shell script pattern (matches
     edit_mailbox_action.cfm and nextcloud_app_password.cfm). occ reads
     the password from OC_PASS env var via --password-from-env so the
     plaintext doesn't appear in argv.

     VERIFICATION: don't trust occ's stdout — independently confirm the
     hash in oc_users.password actually changed. Pre-flight SELECT before
     occ runs, post-flight SELECT after. Both must succeed AND the post-
     flight hash MUST differ from the pre-flight hash. NC uses per-user
     salt (bcrypt/argon2id) so we can't predict the new hash exactly —
     "did it change?" is the appropriate independent check. --->
<cfinclude template="generate_customtrans.cfm">

<cfset ncRotResult = "">
<cfset ncRotError = "">
<cfset ncRotPreHash = "">
<cfset ncRotPostHash = "">

<cftry>
    <!--- Read NC DB credentials. Reused for both pre- and post-flight
         SELECTs. --->
    <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncRotDbUser" charset="utf-8">
    <cfset ncRotDbUser = Trim(ncRotDbUser)>
    <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncRotDbPass" charset="utf-8">
    <cfset ncRotDbPass = Trim(ncRotDbPass)>

    <!--- 1. PRE-FLIGHT: capture current oc_users.password hash. --->
    <cfset ncRotPreScript = "/opt/hermes/tmp/" & customtrans3 & "_rotate_nc_pre.sh">
    <cfscript>
        fileWrite(ncRotPreScript,
            chr(35) & "!/bin/bash" & chr(10) &
            "docker exec hermes_db_server mariadb -u """ & ncRotDbUser & """ -p""" & ncRotDbPass & """ nextcloud -se """ &
            "SELECT password FROM oc_users WHERE uid='" & getMailboxRot.username & "';" &
            """ 2>&1" & chr(10),
            "utf-8");
    </cfscript>
    <cfexecute name="/bin/chmod" arguments="+x #ncRotPreScript#" timeout="10" />
    <cfset _preResult = "">
    <cfexecute name="#ncRotPreScript#" variable="_preResult" timeout="30" />
    <cftry><cffile action="delete" file="#ncRotPreScript#"><cfcatch type="any"></cfcatch></cftry>

    <!--- Trim and pick the longest line. mariadb -se returns the value
         alone; if any noise leaked in, the hash will be the longest line
         (NC bcrypt/argon2id hashes are dozens of chars long). --->
    <cfloop array="#ListToArray(Trim(_preResult), chr(10), false)#" index="_phLine">
        <cfset _phLine = Trim(_phLine)>
        <cfif Len(_phLine) GT Len(ncRotPreHash)>
            <cfset ncRotPreHash = _phLine>
        </cfif>
    </cfloop>

    <!--- 2. ROTATE via occ. --->
    <cfset ncRotScript = "/opt/hermes/tmp/" & customtrans3 & "_rotate_nc_pw.sh">
    <cfscript>
        fileWrite(ncRotScript,
            chr(35) & "!/bin/bash" & chr(10) &
            'docker exec -e OC_PASS="' & newNcInternalPassword & '" -u www-data hermes_nextcloud php /var/www/html/occ user:resetpassword --password-from-env "' & getMailboxRot.username & '" 2>&1' & chr(10),
            "utf-8");
    </cfscript>
    <cfexecute name="/bin/chmod" arguments="+x #ncRotScript#" timeout="10" />
    <cfexecute name="#ncRotScript#" variable="ncRotResult" errorVariable="ncRotError" timeout="60" />
    <!--- Always clean up the temp script (contains plaintext password
         literal — must not linger). --->
    <cftry><cffile action="delete" file="#ncRotScript#"><cfcatch type="any"></cfcatch></cftry>

    <!--- 3. POST-FLIGHT: capture new oc_users.password hash. --->
    <cfset ncRotPostScript = "/opt/hermes/tmp/" & customtrans3 & "_rotate_nc_post.sh">
    <cfscript>
        fileWrite(ncRotPostScript,
            chr(35) & "!/bin/bash" & chr(10) &
            "docker exec hermes_db_server mariadb -u """ & ncRotDbUser & """ -p""" & ncRotDbPass & """ nextcloud -se """ &
            "SELECT password FROM oc_users WHERE uid='" & getMailboxRot.username & "';" &
            """ 2>&1" & chr(10),
            "utf-8");
    </cfscript>
    <cfexecute name="/bin/chmod" arguments="+x #ncRotPostScript#" timeout="10" />
    <cfset _postResult = "">
    <cfexecute name="#ncRotPostScript#" variable="_postResult" timeout="30" />
    <cftry><cffile action="delete" file="#ncRotPostScript#"><cfcatch type="any"></cfcatch></cftry>

    <cfloop array="#ListToArray(Trim(_postResult), chr(10), false)#" index="_phLine">
        <cfset _phLine = Trim(_phLine)>
        <cfif Len(_phLine) GT Len(ncRotPostHash)>
            <cfset ncRotPostHash = _phLine>
        </cfif>
    </cfloop>
<cfcatch type="any">
    <cfset ncRotError = cfcatch.message & " / " & cfcatch.detail>
</cfcatch>
</cftry>

<!--- VERIFY: post-flight hash must be non-empty AND must differ from
     the pre-flight hash. If either condition fails, the rotation did
     NOT take effect regardless of what occ printed. Surface the actual
     state to the admin instead of a string-match assumption. --->
<cfif Len(ncRotPostHash) GT 0 AND ncRotPostHash NEQ ncRotPreHash>
    <cfset session.rotateNcUser = getMailboxRot.username>
    <cfset session.m = 53>
<cfelse>
    <cfif Len(ncRotPostHash) EQ 0>
        <cfset session.rotateNcError = "Post-rotation SELECT returned no oc_users.password value. occ STDOUT: " & Left(ncRotResult, 300) & " / occ STDERR: " & Left(ncRotError, 300)>
    <cfelse>
        <cfset session.rotateNcError = "Hash unchanged after occ user:resetpassword (still equals pre-rotation value). occ may have failed silently. occ STDOUT: " & Left(ncRotResult, 300)>
    </cfif>
    <cfset session.m = 54>
</cfif>

<cflocation url="view_mailboxes.cfm" addtoken="no">
