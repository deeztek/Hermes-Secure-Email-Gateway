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
<cfset cacheFile = "/opt/hermes/updates/check_system_update.txt">
<cfif fileExists(cacheFile)>
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
        </cfif>
    <cfelse>
        <cfset hermesupdate = "UPDATE CHECK UNAVAILABLE">
    </cfif>
<cfelse>
    <!--- Cache file not yet written; first Ofelia run hasn't happened. --->
    <cfset hermesupdate = "UPDATE CHECK PENDING">
</cfif>
