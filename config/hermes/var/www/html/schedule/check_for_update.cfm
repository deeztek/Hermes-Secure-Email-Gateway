<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
Daily update check (#218). Polls the GitHub Releases API for the
latest release tag of deeztek/Hermes-Secure-Email-Gateway and compares
it to the local `build_no` in `system_settings`. Writes the result to
/opt/hermes/updates/check_system_update.txt -- the dashboard widget
(via inc/check_system_update.cfm) reads this file on every page load
so the UI is always reading a cached value (no network call per
render).

Invocation: Ofelia hermes-update-check job calls
    curl --silent http://localhost:8888/schedule/check_for_update.cfm

Replaces the legacy update_check.sh + api_token detour pattern.
Matches the /schedule/ convention used by hermes-message-cleanup,
hermes-quarantine-notify, etc. -- no auth dance, no X-Token header,
just a direct curl from inside the commandbox container.

Cache file format (@ -delimited, preserved from legacy for
backward-compat with the dashboard reader):
    status @ build @ released @ filename @ release_notes_url @
        release_notes_file @ mysqlroot @ dev

For Docker installs, fields 4 (filename), 6 (release_notes_file), and
7 (mysqlroot) are empty -- they were tarball/installer artifacts that
don't apply here.

status values:
    SUCCESS                 -- newer release available
    NOUPDATE                -- already on latest
    UPDATE CHECK UNAVAILABLE -- API call failed
--->

<!--- Required inputs from system_settings + parameters2 --->
<cfquery name="getBuildNo" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'build_no'
</cfquery>
<cfquery name="getDailyDevFlag" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'daily_update_check'
</cfquery>
<cfquery name="getAdminEmail" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'admin_email'
</cfquery>
<cfquery name="getPostmaster" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'postmaster'
</cfquery>
<cfquery name="getConsoleHost" datasource="hermes">
    SELECT value2 FROM parameters2 WHERE parameter = 'console.host' AND module = 'console'
</cfquery>

<cfset currentBuild  = (getBuildNo.recordcount       EQ 1) ? trim(getBuildNo.value)        : "">
<cfset dailyDevFlag  = (getDailyDevFlag.recordcount  EQ 1) ? trim(getDailyDevFlag.value)   : "2">
<cfset adminEmail    = (getAdminEmail.recordcount    EQ 1) ? trim(getAdminEmail.value)     : "">
<cfset postmaster    = (getPostmaster.recordcount    EQ 1) ? trim(getPostmaster.value)     : "">
<cfset consoleHost   = (getConsoleHost.recordcount   EQ 1) ? trim(getConsoleHost.value2)   : "">

<!--- Ensure cache directory exists --->
<cfset cacheDir  = "/opt/hermes/updates">
<cfset cacheFile = cacheDir & "/check_system_update.txt">
<cfif NOT DirectoryExists(cacheDir)>
    <cftry>
        <cfdirectory action="create" directory="#cacheDir#">
        <cfcatch type="any">
            <cflog file="hermes_update_check" type="error"
                text="check_for_update.cfm could not create cache dir #cacheDir#: #cfcatch.message#">
        </cfcatch>
    </cftry>
</cfif>

<cfset writeCache = "">

<cftry>
    <!--- /releases/latest returns the most recent non-prerelease,
         non-draft release. If no qualifying release exists, returns
         404 -- handled below as NOUPDATE. --->
    <cfhttp method="GET"
            url="https://api.github.com/repos/deeztek/Hermes-Secure-Email-Gateway/releases/latest"
            timeout="30"
            result="ghResult">
        <cfhttpparam type="header" name="Accept"     value="application/vnd.github+json">
        <cfhttpparam type="header" name="User-Agent" value="Hermes-SEG-UpdateCheck">
    </cfhttp>

    <cfif ghResult.status_code EQ 200>
        <cfset response   = DeserializeJSON(ghResult.FileContent)>
        <cfset latestTag  = StructKeyExists(response, "tag_name")     ? trim(response.tag_name)     : "">
        <cfset releaseUrl = StructKeyExists(response, "html_url")     ? response.html_url           : "">
        <cfset publishedAt = "">
        <cfif StructKeyExists(response, "published_at")>
            <cftry>
                <cfset publishedAt = DateFormat(ParseDateTime(response.published_at), "yyyy-mm-dd")>
                <cfcatch><cfset publishedAt = response.published_at></cfcatch>
            </cftry>
        </cfif>

        <!--- vYYMMDD format permits direct string comparison: v260120 > v260119 --->
        <cfif Len(latestTag) GT 0 AND latestTag GT currentBuild>
            <cfset writeCache = "SUCCESS" & chr(64) & latestTag & chr(64) & publishedAt & chr(64) & chr(64) & releaseUrl & chr(64) & chr(64) & chr(64) & dailyDevFlag>

            <cflog file="hermes_update_check" type="information"
                text="GitHub releases poll: UPDATEFOUND -- local=#currentBuild# latest=#latestTag#">

            <!--- Email notification (best-effort; failures logged, not raised) --->
            <cfif Len(adminEmail) GT 0 AND Len(postmaster) GT 0>
                <cftry>
                    <cfmail from="#postmaster#"
                            to="#adminEmail#"
                            server="hermes_postfix_dkim"
                            port="10026"
                            subject="[Hermes SEG] Update build: #latestTag# Notification"
                            type="html">
                        <div align="center">
                            <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
                            <h2>Hermes SEG Update Notification</h2>
                            Hermes SEG Update Build: <a href="#releaseUrl#">#latestTag#</a> is available.
                            Please install this update in order to get the latest features and fixes.<br><br>
                            <a href="#releaseUrl#">View release notes on GitHub</a>
                            <cfif Len(consoleHost) GT 0>
                                <br><br>
                                <small>Or open the admin console at https://#consoleHost# &mdash; the dashboard will show the update prompt.</small>
                            </cfif>
                        </div>
                    </cfmail>
                    <cflog file="hermes_update_check" type="information"
                        text="Update notification email sent to #adminEmail# for build #latestTag#">
                    <cfcatch type="any">
                        <cflog file="hermes_update_check" type="error"
                            text="check_for_update.cfm cfmail failure: #cfcatch.message#">
                    </cfcatch>
                </cftry>
            </cfif>
        <cfelse>
            <cfset writeCache = "NOUPDATE" & chr(64) & latestTag & chr(64) & publishedAt & chr(64) & chr(64) & releaseUrl & chr(64) & chr(64) & chr(64) & dailyDevFlag>
        </cfif>

    <cfelseif ghResult.status_code EQ 404>
        <!--- No releases on the repo yet (or all releases are drafts/prereleases).
             Treat as no update available -- not an error condition. --->
        <cfset writeCache = "NOUPDATE" & chr(64)>
        <cflog file="hermes_update_check" type="information"
            text="GitHub /releases/latest returned 404 -- no qualifying releases yet, treating as no update">

    <cfelse>
        <cfset writeCache = "UPDATE CHECK UNAVAILABLE" & chr(64)>
        <cflog file="hermes_update_check" type="error"
            text="GitHub API non-200: status=#ghResult.status_code# url=releases/latest">
    </cfif>

    <cfcatch type="any">
        <cfset writeCache = "UPDATE CHECK UNAVAILABLE" & chr(64)>
        <cflog file="hermes_update_check" type="error"
            text="check_for_update.cfm exception: #cfcatch.message#">
    </cfcatch>
</cftry>

<!--- Write the cache file (always, even on failure -- the dashboard
     widget reads this and needs SOMETHING to display) --->
<cftry>
    <cffile action="write"
        file="#cacheFile#"
        output="#writeCache#"
        addnewline="no">
    <cfcatch type="any">
        <cflog file="hermes_update_check" type="error"
            text="check_for_update.cfm could not write cache file #cacheFile#: #cfcatch.message#">
    </cfcatch>
</cftry>

<cfsetting enablecfoutputonly="yes">
<cfoutput>OK</cfoutput>
