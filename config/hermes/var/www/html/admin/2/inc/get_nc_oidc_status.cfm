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

<!--- Reads the current enabled/disabled state of the Nextcloud user_oidc
      app via `occ config:app:get user_oidc enabled`. Sets variables:
        ncOidcEnabled    - boolean ("yes" / "" string from NC, normalized)
        ncAdminUsername  - the NC local admin username (from creds file)
      Used by view_nextcloud_admin.cfm. #262. --->

<cfset ncOidcEnabled = false>
<cfset ncOidcStateRaw = "">
<cfset ncAdminUsername = "">

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_nextcloud php occ config:app:get user_oidc enabled"
        variable="ncOidcStateRaw"
        timeout="10" />
    <cfset ncOidcStateRaw = trim(ncOidcStateRaw)>
    <!--- NC returns "yes" when enabled, empty / "no" / nothing when disabled --->
    <cfif ncOidcStateRaw EQ "yes">
        <cfset ncOidcEnabled = true>
    </cfif>
    <cfcatch type="any">
        <cfset ncOidcEnabled = false>
        <cfset ncOidcStateRaw = "ERROR: " & cfcatch.message>
    </cfcatch>
</cftry>

<cftry>
    <cffile action="read"
        file="/opt/hermes/creds/nextcloud_admin_username"
        variable="ncAdminUsername"
        charset="utf-8" />
    <cfset ncAdminUsername = trim(ncAdminUsername)>
    <cfcatch type="any">
        <cfset ncAdminUsername = "<not found>">
    </cfcatch>
</cftry>
