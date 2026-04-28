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
     plaintext doesn't appear in argv. --->
<cfinclude template="generate_customtrans.cfm">
<cfset ncRotScript = "/opt/hermes/tmp/" & customtrans3 & "_rotate_nc_pw.sh">

<cfset ncRotResult = "">
<cfset ncRotError = "">

<cftry>
    <cfscript>
        fileWrite(ncRotScript,
            chr(35) & "!/bin/bash" & chr(10) &
            'docker exec -e OC_PASS="' & newNcInternalPassword & '" -u www-data hermes_nextcloud php /var/www/html/occ user:resetpassword --password-from-env "' & getMailboxRot.username & '" 2>&1' & chr(10),
            "utf-8");
    </cfscript>
    <cfexecute name="/bin/chmod" arguments="+x #ncRotScript#" timeout="10" />
    <cfexecute name="#ncRotScript#" variable="ncRotResult" errorVariable="ncRotError" timeout="60" />
<cfcatch type="any">
    <cfset ncRotError = cfcatch.message>
</cfcatch>
</cftry>

<!--- Always clean up the temp script (contains plaintext password
     literal — must not linger). --->
<cftry>
    <cffile action="delete" file="#ncRotScript#">
<cfcatch type="any"></cfcatch>
</cftry>

<!--- occ user:resetpassword prints "Successfully reset password for <user>"
     on success. Anything else = failure. Be liberal in matching. --->
<cfif FindNoCase("Successfully reset", ncRotResult) GT 0>
    <cfset session.rotateNcUser = getMailboxRot.username>
    <cfset session.m = 53>
<cfelse>
    <cfset session.rotateNcError = Trim(ncRotResult & " " & ncRotError)>
    <cfset session.m = 54>
</cfif>

<cflocation url="view_mailboxes.cfm" addtoken="no">
