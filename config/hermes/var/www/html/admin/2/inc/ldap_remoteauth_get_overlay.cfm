
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

<!---
GET REMOTEAUTH OVERLAY INFORMATION FROM LDAP
Performs pre-flight checks to determine:
1. The MDB database index
2. All existing remoteauth overlays (there can be multiple - one per domain mapping)
3. The next available overlay index for adding new overlays

Sets the following variables:
- remoteauthMdbIndex: The MDB database index (e.g., "1")
- remoteauthExistingOverlays: Array of existing overlay indexes
- remoteauthNextOverlayIndex: Next available overlay index for adding
- remoteauthError: Any error message encountered
--->

<!--- INITIALIZE OUTPUT VARIABLES --->
<cfset remoteauthMdbIndex = "1">
<cfset remoteauthExistingOverlays = []>
<cfset remoteauthNextOverlayIndex = 0>
<cfset remoteauthError = "">

<cftry>

<!--- STEP 1: Find the MDB database index --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b cn=config (objectClass=olcMdbConfig) dn"
    variable="mdbSearchResult"
    errorVariable="mdbSearchError"
    timeout="30">
</cfexecute>

<!--- Parse MDB index from result like: dn: olcDatabase={1}mdb,cn=config --->
<cfset mdbMatch = REFind("olcDatabase=\{([0-9]+)\}mdb,cn=config", mdbSearchResult, 1, true)>
<cfif arrayLen(mdbMatch.pos) GTE 2 AND mdbMatch.pos[2] GT 0>
    <cfset remoteauthMdbIndex = mid(mdbSearchResult, mdbMatch.pos[2], mdbMatch.len[2])>
</cfif>

<!--- STEP 2: Find ALL remoteauth overlays --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b cn=config (objectClass=olcRemoteAuthCfg) dn"
    variable="overlaySearchResult"
    errorVariable="overlaySearchError"
    timeout="30">
</cfexecute>

<!--- Extract all remoteauth overlay indexes --->
<cfset overlayMatches = REMatch("olcOverlay=\{([0-9]+)\}remoteauth", overlaySearchResult)>
<cfloop array="#overlayMatches#" index="match">
    <cfset indexMatch = REFind("\{([0-9]+)\}", match, 1, true)>
    <cfif arrayLen(indexMatch.pos) GTE 2 AND indexMatch.pos[2] GT 0>
        <cfset overlayIndex = val(mid(match, indexMatch.pos[2], indexMatch.len[2]))>
        <cfset arrayAppend(remoteauthExistingOverlays, overlayIndex)>
    </cfif>
</cfloop>

<!--- Sort overlays in descending order (delete from highest to lowest) --->
<cfset arraySort(remoteauthExistingOverlays, "numeric", "desc")>

<!--- STEP 3: Find ALL overlays to determine next available index --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b olcDatabase={#remoteauthMdbIndex#}mdb,cn=config (objectClass=olcOverlayConfig) dn"
    variable="allOverlaysResult"
    errorVariable="allOverlaysError"
    timeout="30">
</cfexecute>

<!--- Find the highest overlay index across ALL overlays (not just remoteauth) --->
<cfset highestIndex = -1>
<cfset allIndexMatches = REMatch("olcOverlay=\{([0-9]+)\}", allOverlaysResult)>
<cfloop array="#allIndexMatches#" index="match">
    <cfset indexMatch = REFind("\{([0-9]+)\}", match, 1, true)>
    <cfif arrayLen(indexMatch.pos) GTE 2 AND indexMatch.pos[2] GT 0>
        <cfset currentIndex = val(mid(match, indexMatch.pos[2], indexMatch.len[2]))>
        <cfif currentIndex GT highestIndex>
            <cfset highestIndex = currentIndex>
        </cfif>
    </cfif>
</cfloop>

<!--- Next available index is highest + 1, or 0 if no overlays exist --->
<cfset remoteauthNextOverlayIndex = highestIndex + 1>

<cfcatch type="any">
    <cfset remoteauthError = "Error querying LDAP: #cfcatch.message#">
    <!--- Set safe defaults --->
    <cfset remoteauthMdbIndex = "1">
    <cfset remoteauthExistingOverlays = []>
    <cfset remoteauthNextOverlayIndex = 0>
</cfcatch>

</cftry>
