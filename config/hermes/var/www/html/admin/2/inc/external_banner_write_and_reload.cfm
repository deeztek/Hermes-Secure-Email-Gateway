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
EXTERNAL BANNER WRITE (#228) - template-rendered version.

Regenerates the body_milter banner file set from external_banners.
The hermes_body_milter container watches the files via mtime polling
and reloads on the next message - no force-reload needed.

Layout (one subdirectory per banner row):

    /etc/hermes/body_milter/banners/banner_by_recipient_domain
        recipient_domain -> option-name map.
        Special key "_default" = system-wide banner (NULL recipient_domain).

    /etc/hermes/body_milter/banners/files/<option>/
        body.txt           plain-text banner (auto-derived at save time)
        body.html          rendered HTML banner (already form-substituted)
        position           "prepend" or "append" sidecar

Where <option> is:
    banner_default                       (system-wide row)
    banner_<sanitized_recipient_domain>  (per-domain override)

Templates emit table-based HTML at admin save time (see
inc/external_banner_templates/<key>.cfm). The rendered HTML is stored
in external_banners.body_html and copied verbatim to body.html on disk
here. No image extraction (banner templates are text-only field types).

Sets session.extBannerApplySuccess = true/false.
session.extBannerApplyError holds the error message if false.
--->

<cftry>

<cfquery name="getBanners" datasource="hermes">
    SELECT recipient_domain, position, body_text, body_html
    FROM external_banners
    WHERE enabled = 1
      AND body_html IS NOT NULL
      AND TRIM(body_html) != ''
    ORDER BY (recipient_domain IS NULL) DESC, recipient_domain ASC
</cfquery>

<cfset bannersRoot    = "/etc/hermes/body_milter/banners">
<cfset bannerFilesDir = bannersRoot & "/files">
<cfset bannerMapFile  = bannersRoot & "/banner_by_recipient_domain">

<cfif NOT DirectoryExists(bannersRoot)>
    <cfdirectory action="create" directory="#bannersRoot#" mode="755" />
</cfif>
<cfif NOT DirectoryExists(bannerFilesDir)>
    <cfdirectory action="create" directory="#bannerFilesDir#" mode="755" />
</cfif>

<!--- Wipe per-banner subdirs. Catches deletions and recipient_domain
     renames in a single sweep. The .gitkeep at parent is preserved
     since we only delete type=Dir entries. --->
<cfset existingItems = DirectoryList(bannerFilesDir, false, "query")>
<cfloop query="existingItems">
    <cfif existingItems.type EQ "Dir">
        <cfdirectory action="delete" directory="#bannerFilesDir#/#existingItems.name#" recurse="yes" />
    </cfif>
</cfloop>

<cfset bannerMapLines = "">

<cfloop query="getBanners">

    <cfif Len(Trim(recipient_domain)) EQ 0>
        <cfset bannerOption = "banner_default">
        <cfset bannerKey    = "_default">
    <cfelse>
        <cfset bannerOption = "banner_" & ReReplaceNoCase(recipient_domain, "[^A-Za-z0-9_]", "_", "all")>
        <cfset bannerKey    = LCase(Trim(recipient_domain))>
    </cfif>

    <!--- Plain text was auto-derived at save time and stored in
         body_text. Fall back to a tag-strip of body_html if body_text
         is somehow empty (defensive). --->
    <cfif Len(Trim(body_text)) GT 0>
        <cfset bannerTxt = body_text>
    <cfelse>
        <cfset bannerTxt = ReReplaceNoCase(body_html, "<br\s*/?>", Chr(10), "all")>
        <cfset bannerTxt = ReReplaceNoCase(bannerTxt, "</p>|</li>|</tr>|</td>|</div>", Chr(10), "all")>
        <cfset bannerTxt = ReReplaceNoCase(bannerTxt, "<[^>]+>", "", "all")>
        <cfset bannerTxt = ReReplaceNoCase(bannerTxt, "(\r?\n){2,}", Chr(10), "all")>
        <cfset bannerTxt = Trim(bannerTxt)>
    </cfif>

    <cfset bannerOptionDir = bannerFilesDir & "/" & bannerOption>
    <cfdirectory action="create" directory="#bannerOptionDir#" mode="755" />

    <cffile action="write" file="#bannerOptionDir#/body.txt"  output="#bannerTxt##Chr(10)#"   charset="utf-8" addnewline="no">
    <cffile action="write" file="#bannerOptionDir#/body.html" output="#body_html##Chr(10)#"   charset="utf-8" addnewline="no">
    <cffile action="write" file="#bannerOptionDir#/position"  output="#position#"             charset="utf-8" addnewline="no">

    <cfset bannerMapLines = bannerMapLines & bannerKey & Chr(9) & bannerOption & Chr(10)>
</cfloop>

<!--- Always write the map file even when empty - milter mtime-stats
     this path on every message; absence is a load failure. Empty file
     = no entries = no banner applied. --->
<cffile action="write" file="#bannerMapFile#" output="#bannerMapLines#" charset="utf-8" addnewline="no">

<cfset session.extBannerApplySuccess = true>
<cfset session.extBannerApplyError = "">

<cfcatch type="any">
    <cfset session.extBannerApplySuccess = false>
    <cfset session.extBannerApplyError = cfcatch.message>
</cfcatch>
</cftry>
