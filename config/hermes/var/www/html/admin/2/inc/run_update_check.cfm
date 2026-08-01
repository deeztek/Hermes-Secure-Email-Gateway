<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!--- ON-DEMAND UPDATE CHECK (#288).

     Runs the same poll the nightly hermes-update-check job runs, immediately,
     and returns to the dashboard.

     Why this exists: the update check is the ONLY channel that tells an admin
     a release is available (dashboard widget + notification e-mail, both fed
     by the cache file this writes). When the scheduler was rendering a stale
     job list, that channel was silently dead -- so the very release fixing it
     could not announce itself. A manual trigger means an admin who notices
     "UPDATE CHECK PENDING" can resolve it themselves instead of waiting on a
     job that may never fire.

     Calls the schedule page over localhost rather than cfinclude-ing it: that
     page ends with `enablecfoutputonly` + a bare "OK" body, which would
     suppress this request's own output, and going over HTTP is exactly what
     the Ofelia job does -- one code path, no divergence. --->

<cfsetting requesttimeout="120">

<!--- No session.m here on purpose: index.cfm does not render the message
     scope, so setting it would be a silent no-op. The feedback IS the
     refreshed widget -- the admin lands back on the dashboard and the cell
     now reads LATEST VERSION, UPDATE BUILD <tag> FOUND, or UNAVAILABLE with
     its hint. The schedule page always writes the cache, even on failure. --->
<cftry>
    <cfhttp method="GET"
            url="http://localhost:8888/schedule/check_for_update.cfm"
            timeout="60"
            result="checkResult">
    </cfhttp>

    <cfif checkResult.status_code NEQ 200>
        <cflog file="hermes_update_check" type="error"
            text="run_update_check.cfm: schedule page returned status #checkResult.status_code#">
    </cfif>

    <cfcatch type="any">
        <cflog file="hermes_update_check" type="error"
            text="run_update_check.cfm: #cfcatch.message#">
    </cfcatch>
</cftry>

<cflocation url="../index.cfm" addtoken="no">
