<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
DISCLAIMER WRITE (#214 Phase 3 + #230 image support layout).

Regenerates the body_milter disclaimer file set from the disclaimers
table. The hermes_body_milter container watches these files via
mtime polling and reloads automatically on the next message it
processes - no force-reload, no docker exec, no service signal.

Layout (one subdirectory per disclaimer):

  /etc/hermes/body_milter/disclaimers/disclaimer_by_sender
       sender->option-name map (one line: "<sender>\t<option>")

  /etc/hermes/body_milter/disclaimers/files/<option>/
      body.txt           plain-text disclaimer
      body.html          html disclaimer (may contain cid: refs after #230)
      images/            per-disclaimer inline images for cid: references
          1.png          (#230 - populated by save action when admin
          2.jpg           pastes/uploads images into the Quill editor)
          ...

Where <option> is "domain_<sanitized_domain>" or "relay_<sanitized_address>"
(non-alphanumerics replaced with _).

Pipeline placement: this fires AFTER the DB write in
save_disclaimer_action.cfm and disclaimer_delete.cfm. The body milter
sits in postfix's smtpd_milters chain, BEFORE amavis and Ciphermail,
modifying the body at message ingress. OpenDKIM at :10026 signs the
final composed message, so Hermes' DKIM covers the disclaimer. See
docs/admin/email-policies/disclaimers.md for full pipeline notes.

No reply-chain dedup. Every outbound message gets a fresh disclaimer
applied, matching industry norm (Exclaimer, Crossware, CodeTwo, M365
transport rules) and compliance posture - many regulatory regimes
treat each transmission as requiring its own disclaimer.

Sets session.disclaimerApplySuccess = true/false.
session.disclaimerApplyError holds the error message if false.
--->

<cftry>

<!--- Pull all enabled disclaimers. Disabled rows are skipped - no
     map entry, no subdirectory written, milter never matches them. --->
<cfquery name="getDisclaimers" datasource="hermes">
    SELECT scope, scope_key, position, body_text, body_html
    FROM disclaimers
    WHERE enabled = 1
    ORDER BY scope ASC, scope_key ASC
</cfquery>

<cfset filesDir = "/etc/hermes/body_milter/disclaimers/files">

<!--- Ensure the parent files/ directory exists. The directory itself
     is part of the body_milter bind mount; we only manage subdirs
     inside it. --->
<cfif NOT DirectoryExists(filesDir)>
    <cfdirectory action="create" directory="#filesDir#" mode="755" />
</cfif>

<!--- Wipe per-disclaimer subdirectories before regenerating. Catches
     deletions and scope_key renames in a single sweep so we never
     leak stale files (or stale image binaries from a prior version
     of the disclaimer that referenced different cid:s). The per-option
     subdirs are regular subdirectories inside the bind mount (not
     mount points themselves), so recursive delete is safe and does
     not orphan the milter's view. The .gitkeep file at the parent
     level is preserved (we only delete subdirectories of type=Dir). --->
<cfset existingItems = DirectoryList(filesDir, false, "query")>
<cfloop query="existingItems">
    <cfif existingItems.type EQ "Dir">
        <cfdirectory action="delete" directory="#filesDir#/#existingItems.name#" recurse="yes" />
    </cfif>
</cfloop>

<!--- Build the map content while looping the per-disclaimer rows. --->
<cfset mapLines = "">

<cfloop query="getDisclaimers">

    <!--- Option-name (subdirectory name) and sender key (lookup key):
           Domain scope -> option=domain_<safe>, sender=@<domain>
           Relay scope  -> option=relay_<safe>,  sender=<full_address>
         Non-alphanumeric chars in the source key are replaced with _
         so the option-name is filename-safe. --->
    <cfif scope EQ "domain">
        <cfset optionName = "domain_" & ReReplaceNoCase(scope_key, "[^A-Za-z0-9_]", "_", "all")>
        <cfset senderKey = "@" & scope_key>
    <cfelse>
        <cfset optionName = "relay_" & ReReplaceNoCase(scope_key, "[^A-Za-z0-9_]", "_", "all")>
        <cfset senderKey = scope_key>
    </cfif>

    <!--- Auto-derive plain-text part if the admin didn't supply a
         separate body_text via the Quill "edit plain-text separately"
         toggle. Strip <br>/<p>/<li> to newlines, drop other tags
         (including <img cid:...> references which don't translate to
         text), collapse runs of newlines. --->
    <cfif Trim(body_text) EQ "">
        <cfset txt = ReReplaceNoCase(body_html, "<br\s*/?>", Chr(10), "all")>
        <cfset txt = ReReplaceNoCase(txt, "</p>|</li>", Chr(10), "all")>
        <cfset txt = ReReplaceNoCase(txt, "<[^>]+>", "", "all")>
        <cfset txt = ReReplaceNoCase(txt, "(\r?\n){3,}", Chr(10) & Chr(10), "all")>
        <cfset txt = Trim(txt)>
    <cfelse>
        <cfset txt = body_text>
    </cfif>

    <cfset txtOut = txt & Chr(10)>

    <!--- Create the per-disclaimer subdirectory + images/ subdirectory. --->
    <cfset optionDir = filesDir & "/" & optionName>
    <cfdirectory action="create" directory="#optionDir#" mode="755" />
    <cfdirectory action="create" directory="#optionDir#/images" mode="755" />

    <!--- #230: extract base64 inline images from body_html, write each
         to images/<N>.<ext>, rewrite the <img> tag in HTML to reference
         cid:disclaimer_<option>_img_<N>. The milter then attaches each
         image as a multipart/related part with matching Content-ID.

         DB stores body_html with base64 data: URLs (admin-editor
         convenience: Quill displays inline preview of pasted images
         without round-tripping through the server). Each save
         regenerates the on-disk file set fresh: extracts images,
         rewrites HTML with cid: refs. The base64 stays in DB only.

         Image filename uses 1-based index in the order Quill emitted
         them. Extension derived from the data: URL's media type.

         Replaces JUST the src attribute inside each <img>, preserving
         other attributes (style, width, height, alt, class) so the
         editor's width picker inline style="width:200px" survives
         the rewrite. --->
    <cfset imageIndex = 0>
    <cfset rewrittenHtml = body_html>
    <cfset imgPattern = "<img\s+[^>]*src\s*=\s*[""']data:image/(png|jpeg|jpg|gif);base64,([^""']+)[""'][^>]*>">
    <cfset srcAttrPattern = "src\s*=\s*[""']data:image/(?:png|jpeg|jpg|gif);base64,[^""']+[""']">
    <cfset imgMatches = REMatchNoCase(imgPattern, body_html)>
    <cfloop array="#imgMatches#" index="imgTag">
        <cfset imageIndex = imageIndex + 1>
        <!--- Re-match against the matched substring to capture groups. --->
        <cfset captured = ReFindNoCase(imgPattern, imgTag, 1, true)>
        <cfif ArrayLen(captured.pos) GTE 3 AND captured.pos[2] GT 0>
            <cfset imgFormat = LCase(Mid(imgTag, captured.pos[2], captured.len[2]))>
            <cfset b64data   = Mid(imgTag, captured.pos[3], captured.len[3])>
            <cfset ext = imgFormat>
            <cfif ext EQ "jpeg"><cfset ext = "jpg"></cfif>

            <cfset binData = ToBinary(b64data)>
            <cfset imgFilename = imageIndex & "." & ext>
            <cffile action="write"
                    file="#optionDir#/images/#imgFilename#"
                    output="#binData#">

            <cfset cid = "disclaimer_" & optionName & "_img_" & imageIndex>
            <cfset newSrc = "src=""cid:" & cid & """">
            <!--- Replace only the src attribute inside this img tag,
                 keeping other attributes (style, width, alt) intact. --->
            <cfset newImgTag = REReplaceNoCase(imgTag, srcAttrPattern, newSrc, "one")>
            <!--- Replace the FIRST occurrence in rewrittenHtml. Multiple
                 identical base64 tags (same image pasted twice) are
                 handled correctly because each loop iteration replaces
                 the first remaining instance with a fresh cid. --->
            <cfset rewrittenHtml = Replace(rewrittenHtml, imgTag, newImgTag, "one")>
        </cfif>
    </cfloop>

    <cfset htmlOut = rewrittenHtml & Chr(10)>

    <cffile action="write" file="#optionDir#/body.txt"  output="#txtOut#"  charset="utf-8" addnewline="no">
    <cffile action="write" file="#optionDir#/body.html" output="#htmlOut#" charset="utf-8" addnewline="no">

    <cfset mapLines = mapLines & senderKey & Chr(9) & optionName & Chr(10)>
</cfloop>

<!--- Always write the map file even when empty - the milter mtime-stats
     this path on every message and treats absence as a load failure.
     Empty file = no entries = no disclaimer applied to anyone. --->
<cffile action="write" file="/etc/hermes/body_milter/disclaimers/disclaimer_by_sender" output="#mapLines#" charset="utf-8" addnewline="no">

<!--- No force-reload needed. The body milter mtime-watches the map
     and per-scope files; the file write above is enough to make the
     change take effect on the next message. --->

<cfset session.disclaimerApplySuccess = true>
<cfset session.disclaimerApplyError = "">

<cfcatch type="any">
    <cfset session.disclaimerApplySuccess = false>
    <cfset session.disclaimerApplyError = cfcatch.message>
</cfcatch>
</cftry>
