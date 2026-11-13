<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

FORWARDING CLEANUP (#411)
Called when a mailbox stops existing (Delete Mailbox, Revert to Relay
Recipient). Removes the mailbox's own forwarding setting and, when
fwdCleanupInbound is true, every other user's forward that points at it.
Those users' Sieve scripts are regenerated so they stop redirecting to an
address that no longer has a mailbox.

Include AFTER the mailboxes row is gone (or changed), so the generator's
join to mailboxes already excludes the address.

Required:
  fwdCleanupAddress   the mailbox address being removed
Optional:
  fwdCleanupInbound   true (default) also remove forwards pointing at it.
                      false when the address keeps receiving, e.g. a
                      conversion to a shared mailbox.

Never throws: every step is soft-fail, so a cleanup problem cannot block
the deletion that called it.
--->

<cfparam name="fwdCleanupInbound" default="true">

<cftry>
    <cfquery datasource="hermes">
        DELETE FROM user_forwarding
        WHERE username = <cfqueryparam value="#fwdCleanupAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
<cfcatch type="any"></cfcatch>
</cftry>

<cfif fwdCleanupInbound>
    <cftry>
        <cfquery name="_fwdInbound" datasource="hermes">
            SELECT username FROM user_forwarding
            WHERE LOWER(forward_to) = <cfqueryparam value="#LCase(fwdCleanupAddress)#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset _fwdUsers = ValueList(_fwdInbound.username)>
        <cfif _fwdUsers NEQ "">
            <cfquery datasource="hermes">
                DELETE FROM user_forwarding
                WHERE LOWER(forward_to) = <cfqueryparam value="#LCase(fwdCleanupAddress)#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfloop list="#_fwdUsers#" index="_fwdUser">
                <cftry>
                    <cfset sieveUsername = _fwdUser>
                    <cfinclude template="generate_sieve_user.cfm">
                <cfcatch type="any"></cfcatch>
                </cftry>
            </cfloop>
        </cfif>
    <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>
