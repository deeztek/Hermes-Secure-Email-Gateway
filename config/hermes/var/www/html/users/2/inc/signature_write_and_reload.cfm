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
PERSONAL SIGNATURE WRITE (#226).

Regenerates the body_milter on-disk files for a single user from
user_signatures + the signature_by_sender map. Mirrors the disclaimer
write pipeline (#214 Phase 3 + #230 image support) so the milter can
reuse the same mtime-watch + cid: image attach machinery. The milter
uses the map to look up the right per-user folder by sender address.

Layout:

  /etc/hermes/body_milter/signatures/signature_by_sender
       sender->option-name map (one line per signature: "<email>\t<option>")

  /etc/hermes/body_milter/signatures/files/<option>/
       body.txt           plain-text signature (auto-derived)
       body.html          html signature (cid: refs after image extraction)
       images/            inline images for cid: references
           1.png
           ...

Where <option> is "user_<sanitized_email>" (non-alphanumerics in the
local part replaced with _, @ replaced with _at_).

Pipeline placement: this fires AFTER the user_signatures UPSERT in
save_signature_action.cfm. The body milter watches files/<option>
mtimes via the map and reloads on the next message.

Operates on session.email only - never touches other users' files,
even on shared installs. The map file IS rewritten in full on each
save (read all enabled rows, regenerate the entire map) so a user
toggling enabled=0 cleanly removes their map entry without leaving
stale references.

Sets session.signatureApplySuccess = true/false.
session.signatureApplyError holds the error message if false.
--->

<cftry>

<cfset rootDir  = "/etc/hermes/body_milter/signatures">
<cfset filesDir = rootDir & "/files">
<cfset mapFile  = rootDir & "/signature_by_sender">

<!--- Ensure directories exist. The root is a bind mount; files/ may not
     yet exist on first save (created here, not by docker-compose). --->
<cfif NOT DirectoryExists(filesDir)>
    <cfdirectory action="create" directory="#filesDir#" mode="755" />
</cfif>

<!--- Sanitize the current user's email for option-name use.
     bob.smith@example.com -> user_bob_smith_at_example_com --->
<cfset userOption = "user_" & ReReplaceNoCase(Replace(session.email, "@", "_at_", "all"), "[^A-Za-z0-9_]", "_", "all")>

<!--- Pull the current user's row from user_signatures.
     A "save with enabled=0 and empty body" should result in NO map
     entry and a wiped per-user folder, NOT a phantom empty folder. --->
<cfquery name="getMine" datasource="hermes">
    SELECT enabled, body_text, body_html
    FROM user_signatures
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- Wipe THIS user's option directory before regenerating. Catches
     image deletions and body changes in a single sweep so we never
     leak stale image binaries from a prior version. --->
<cfset userDir = filesDir & "/" & userOption>
<cfif DirectoryExists(userDir)>
    <cfdirectory action="delete" directory="#userDir#" recurse="yes" />
</cfif>

<!--- Decide if this user should produce on-disk files.
     enabled=0 OR (empty html AND empty text) -> no files, no map entry. --->
<cfset hasContent = false>
<cfif getMine.recordcount GTE 1 AND Val(getMine.enabled) EQ 1>
    <cfif Trim(getMine.body_html) NEQ "" OR Trim(getMine.body_text) NEQ "">
        <cfset hasContent = true>
    </cfif>
</cfif>

<cfif hasContent>
    <!--- Auto-derive plain-text part if the user didn't explicitly
         supply body_text. Strip block-level tags to newlines, drop
         the rest, collapse runs of newlines. Same pattern as the
         disclaimer pipeline so behavior is consistent. --->
    <cfif Trim(getMine.body_text) EQ "">
        <cfset txt = ReReplaceNoCase(getMine.body_html, "<br\s*/?>", Chr(10), "all")>
        <cfset txt = ReReplaceNoCase(txt, "</p>|</li>", Chr(10), "all")>
        <cfset txt = ReReplaceNoCase(txt, "<[^>]+>", "", "all")>
        <cfset txt = ReReplaceNoCase(txt, "(\r?\n){3,}", Chr(10) & Chr(10), "all")>
        <cfset txt = Trim(txt)>
    <cfelse>
        <cfset txt = getMine.body_text>
    </cfif>
    <cfset txtOut = txt & Chr(10)>

    <cfdirectory action="create" directory="#userDir#" mode="755" />
    <cfdirectory action="create" directory="#userDir#/images" mode="755" />

    <!--- Extract base64 inline images (mirrors disclaimer #230 pipeline).
         CID prefix uses signature_<option>_img_<N> so it can never
         collide with disclaimer_<option>_img_<N> CIDs even when both
         apply to the same message.

         Replaces JUST the src attribute inside each <img>, preserving
         other attributes (style, width, height, alt, class) so the
         user-portal width picker's inline style="width:200px" survives
         the rewrite. --->
    <cfset imageIndex = 0>
    <cfset rewrittenHtml = getMine.body_html>
    <cfset imgPattern = "<img\s+[^>]*src\s*=\s*[""']data:image/(png|jpeg|jpg|gif);base64,([^""']+)[""'][^>]*>">
    <cfset srcAttrPattern = "src\s*=\s*[""']data:image/(?:png|jpeg|jpg|gif);base64,[^""']+[""']">
    <cfset imgMatches = REMatchNoCase(imgPattern, getMine.body_html)>
    <cfloop array="#imgMatches#" index="imgTag">
        <cfset imageIndex = imageIndex + 1>
        <cfset captured = ReFindNoCase(imgPattern, imgTag, 1, true)>
        <cfif ArrayLen(captured.pos) GTE 3 AND captured.pos[2] GT 0>
            <cfset imgFormat = LCase(Mid(imgTag, captured.pos[2], captured.len[2]))>
            <cfset b64data   = Mid(imgTag, captured.pos[3], captured.len[3])>
            <cfset ext = imgFormat>
            <cfif ext EQ "jpeg"><cfset ext = "jpg"></cfif>

            <cfset binData = ToBinary(b64data)>
            <cfset imgFilename = imageIndex & "." & ext>
            <cffile action="write"
                    file="#userDir#/images/#imgFilename#"
                    output="#binData#">

            <cfset cid = "signature_" & userOption & "_img_" & imageIndex>
            <cfset newSrc = "src=""cid:" & cid & """">
            <!--- Replace only the src attribute inside this img tag,
                 keep the rest of the tag intact. --->
            <cfset newImgTag = REReplaceNoCase(imgTag, srcAttrPattern, newSrc, "one")>
            <cfset rewrittenHtml = Replace(rewrittenHtml, imgTag, newImgTag, "one")>
        </cfif>
    </cfloop>

    <!--- Tighten paragraph margins. Quill 2.x normalizes inline <br>
         line breaks into separate <p> blocks; default browser margins
         on <p> (~1em top + bottom) create visible gaps between
         contact-info lines that should render compact in the mail
         client. Inject inline style="margin:0.4em 0;" on every <p>
         that doesn't already have a style attribute (templates that
         hardcode their own paragraph styles are preserved). Done
         server-side so the spacing is baked into the delivered html
         and survives mail clients that strip <style> blocks. --->
    <cfset rewrittenHtml = REReplaceNoCase(rewrittenHtml,
        "<p>",
        "<p style=""margin:0.4em 0;"">",
        "all")>

    <cfset htmlOut = rewrittenHtml & Chr(10)>

    <cffile action="write" file="#userDir#/body.txt"  output="#txtOut#"  charset="utf-8" addnewline="no">
    <cffile action="write" file="#userDir#/body.html" output="#htmlOut#" charset="utf-8" addnewline="no">
</cfif>

<!--- Delegate the map + sender_data rebuild to the shared #226
     Phase 2B resolver. It walks all enabled mailboxes, picks the
     winning signature per sender (Personal -> Dept Org -> Default
     Org -> none), writes signature_by_sender + sender_data.json,
     and self-heals any org_<id> dir that wins for at least one
     mailbox. The personal-sig file write above is unchanged; this
     just replaces the inline map-only rebuild with the unified
     resolver so user toggling enabled=0 cleanly cascades to the
     org-sig fallback. --->
<cfinclude template="../../admin/2/inc/signature_regen_map.cfm">

<cfcatch type="any">
    <cfset session.signatureApplySuccess = false>
    <cfset session.signatureApplyError = cfcatch.message>
</cfcatch>
</cftry>
