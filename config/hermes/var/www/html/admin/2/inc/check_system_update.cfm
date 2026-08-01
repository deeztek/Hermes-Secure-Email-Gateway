  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- Update-check dashboard widget (#218). Docker installs use GitHub
     Releases as the source of truth: the daily Ofelia job invokes
     /schedule/check_for_update.cfm, which polls the GitHub Releases API,
     writes the result to /opt/hermes/updates/check_system_update.txt, and
     emails the admin when a new build is available. This file is just a thin
     cache-reader for the dashboard widget -- no network call, no auth dance,
     no per-page-load API hit.

     (The legacy bare-metal path that RSA-encrypted a payload and POSTed it to
     updates.deeztek.com/update_comm.cfm was removed -- it never ran on Docker
     and the product is Docker-only. History is in git if ever needed.) --->

<!--- Staleness signalling (#288).

     The cache is only ever written by the hermes-update-check Ofelia job. If
     that job is not running, this file never appears and the widget sat on a
     bland "UPDATE CHECK PENDING" forever -- indistinguishable from the benign
     "installed an hour ago, the 04:30 check hasn't fired yet" case. That is
     precisely how a dead scheduler stayed invisible on affected installs.

     So: expose whether the reading is TRUSTWORTHY alongside the reading
     itself, and let the dashboard offer a one-click on-demand check rather
     than leaving the admin with a dead-end string.

       hermesupdatestale  1 = do not trust this value; something needs doing
       hermesupdatehint   short actionable sentence (already HTML-safe)
       hermesupdatechecked  when the cache was last written, or "" if never
--->
<cfset hermesupdatestale   = 0>
<cfset hermesupdatehint    = "">
<cfset hermesupdatechecked = "">
<cfset staleAfterDays      = 3>

<cfset cacheFile = "/opt/hermes/updates/check_system_update.txt">
<cfif fileExists(cacheFile)>
    <cftry>
        <cfset cacheInfo = GetFileInfo(cacheFile)>
        <cfset hermesupdatechecked = DateFormat(cacheInfo.lastmodified, "yyyy-mm-dd") & " " & TimeFormat(cacheInfo.lastmodified, "HH:mm")>
        <cfif DateDiff("d", cacheInfo.lastmodified, Now()) GT staleAfterDays>
            <cfset hermesupdatestale = 1>
            <cfset hermesupdatehint  = "Last successful check was #hermesupdatechecked#. The daily update-check job may not be running.">
        </cfif>
        <cfcatch type="any">
            <!--- Unreadable timestamp is not worth failing the dashboard over. --->
        </cfcatch>
    </cftry>
    <cffile action="read" file="#cacheFile#" variable="cachedContent">
    <cfset cachedContent = trim(cachedContent)>
    <cfif Len(cachedContent) GT 0>
        <cfset status = ListGetAt(cachedContent, 1, chr(64))>
        <cfif status EQ "SUCCESS">
            <cfif ListLen(cachedContent, chr(64)) GE 2>
                <cfset build = ListGetAt(cachedContent, 2, chr(64))>
            </cfif>
            <cfif ListLen(cachedContent, chr(64)) GE 3>
                <cfset released = ListGetAt(cachedContent, 3, chr(64))>
            </cfif>
            <cfif ListLen(cachedContent, chr(64)) GE 5>
                <cfset releasenote = ListGetAt(cachedContent, 5, chr(64))>
            </cfif>
            <cfset hermesupdate = "UPDATEFOUND">
        <cfelseif status EQ "NOUPDATE">
            <cfset hermesupdate = "LATEST VERSION">
        <cfelse>
            <!--- "UPDATE CHECK UNAVAILABLE" passes through verbatim --->
            <cfset hermesupdate = status>
            <cfset hermesupdatestale = 1>
            <cfset hermesupdatehint  = "The last check could not reach the GitHub Releases API. Verify outbound HTTPS and DNS.">
        </cfif>
    <cfelse>
        <cfset hermesupdate = "UPDATE CHECK UNAVAILABLE">
        <cfset hermesupdatestale = 1>
        <cfset hermesupdatehint  = "The update-check cache is empty. Run a check to repopulate it.">
    </cfif>
<cfelse>
    <!--- Cache file has never been written. Benign on a box installed within
         the last day (the job runs at 04:30); otherwise the job is not
         running -- which is the state every install shipped in before #288,
         because the scheduler was calling a long-removed script. Either way
         the honest presentation is "unverified", with a way to resolve it. --->
    <cfset hermesupdate = "UPDATE CHECK PENDING">
    <cfset hermesupdatestale = 1>
    <cfset hermesupdatehint  = "No update check has completed yet. This clears after the nightly check; if it persists, the scheduler is not running.">
</cfif>
