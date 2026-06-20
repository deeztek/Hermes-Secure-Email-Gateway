<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
WRITE ONE ORG SIGNATURE'S ON-DISK FILES (#226 Phase 2B).

Renders one org_signatures row's rendered_html into the body milter
on-disk layout the SignatureModifier consumes. Caller MUST set:

    orgSignatureWriteRowId = <id of org_signatures row>

Output:
    /etc/hermes/body_milter/signatures/files/org_<id>/
        body.txt           plain-text (auto-derived from html)
        body.html          rendered_html with cid: img refs in place
                           of data: URIs (placeholders intact)
        images/<N>.<ext>   inline images extracted from data: URIs

Disabled or missing rows: the dir is wiped clean. A subsequent regen
of the signature_by_sender map will skip mailboxes that resolved to
this org sig, so the milter never points at empty files.

Placeholder strings ({{user.*}}, {{org.*}}, {{dept.*}}) inside
rendered_html survive untouched - the milter substitutes them at
message-send time against sender_data.json.

cid: prefix is `signature_org_<id>_img_<N>`, which matches the
existing SignatureModifier CID_REF_RE = cid:(signature_[\w.-]+_img_\d+).
No milter regex change is needed.

Idempotent: safe to call repeatedly; always wipes the dir first.
--->

<cfif NOT isDefined("orgSignatureWriteRowId") OR NOT IsNumeric(orgSignatureWriteRowId)>
    <cfthrow message="org_signature_write_files: caller must set orgSignatureWriteRowId">
</cfif>

<cfset orgSigWriteId  = Val(orgSignatureWriteRowId)>
<cfset orgSigOption   = "org_" & orgSigWriteId>
<cfset orgSigFilesDir = "/etc/hermes/body_milter/signatures/files">
<cfset orgSigOptDir   = orgSigFilesDir & "/" & orgSigOption>

<!--- Files dir might not yet exist on first call. --->
<cfif NOT DirectoryExists(orgSigFilesDir)>
    <cfdirectory action="create" directory="#orgSigFilesDir#" mode="755" />
</cfif>

<cfquery name="getOrgSigRow" datasource="hermes">
    SELECT id, rendered_html, enabled
    FROM org_signatures
    WHERE id = <cfqueryparam value="#orgSigWriteId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Wipe the per-option dir first to clear stale images and stale
     html if the row was edited. Mirrors the Personal Sig pipeline. --->
<cfif DirectoryExists(orgSigOptDir)>
    <cfdirectory action="delete" directory="#orgSigOptDir#" recurse="yes" />
</cfif>

<cfif getOrgSigRow.recordcount GTE 1
      AND Val(getOrgSigRow.enabled) EQ 1
      AND Len(Trim(getOrgSigRow.rendered_html)) GT 0>

    <cfdirectory action="create" directory="#orgSigOptDir#"           mode="755" />
    <cfdirectory action="create" directory="#orgSigOptDir#/images"    mode="755" />

    <!--- Extract base64 inline images. Mirrors signature_write_and_reload
         exactly: replaces only the src attribute inside each img tag,
         leaving width/style/alt etc. intact. --->
    <cfset orgSigImageIndex   = 0>
    <cfset orgSigRewritten    = getOrgSigRow.rendered_html>
    <cfset orgSigImgPattern   = "<img\s+[^>]*src\s*=\s*[""']data:image/(png|jpeg|jpg|gif);base64,([^""']+)[""'][^>]*>">
    <cfset orgSigSrcAttrPat   = "src\s*=\s*[""']data:image/(?:png|jpeg|jpg|gif);base64,[^""']+[""']">
    <cfset orgSigImgMatches   = REMatchNoCase(orgSigImgPattern, getOrgSigRow.rendered_html)>

    <cfloop array="#orgSigImgMatches#" index="orgSigImgTag">
        <cfset orgSigImageIndex = orgSigImageIndex + 1>
        <cfset orgSigCaptured   = ReFindNoCase(orgSigImgPattern, orgSigImgTag, 1, true)>
        <cfif ArrayLen(orgSigCaptured.pos) GTE 3 AND orgSigCaptured.pos[2] GT 0>
            <cfset orgSigImgFmt = LCase(Mid(orgSigImgTag, orgSigCaptured.pos[2], orgSigCaptured.len[2]))>
            <cfset orgSigB64    = Mid(orgSigImgTag, orgSigCaptured.pos[3], orgSigCaptured.len[3])>
            <cfset orgSigExt    = orgSigImgFmt>
            <cfif orgSigExt EQ "jpeg"><cfset orgSigExt = "jpg"></cfif>

            <cfset orgSigBin       = ToBinary(orgSigB64)>
            <cfset orgSigImgFile   = orgSigImageIndex & "." & orgSigExt>
            <cffile action="write"
                    file="#orgSigOptDir#/images/#orgSigImgFile#"
                    output="#orgSigBin#">

            <cfset orgSigCid    = "signature_" & orgSigOption & "_img_" & orgSigImageIndex>
            <cfset orgSigNewSrc = "src=""cid:" & orgSigCid & """">
            <cfset orgSigNewTag = REReplaceNoCase(orgSigImgTag, orgSigSrcAttrPat, orgSigNewSrc, "one")>
            <cfset orgSigRewritten = Replace(orgSigRewritten, orgSigImgTag, orgSigNewTag, "one")>
        </cfif>
    </cfloop>

    <!--- Auto-derive plain-text part. Same regex chain as the Personal
         Sig pipeline so behavior is consistent. --->
    <cfset orgSigPlain = ReReplaceNoCase(orgSigRewritten, "<br\s*/?>",        Chr(10), "all")>
    <cfset orgSigPlain = ReReplaceNoCase(orgSigPlain,     "</p>|</li>",       Chr(10), "all")>
    <cfset orgSigPlain = ReReplaceNoCase(orgSigPlain,     "<[^>]+>",          "",      "all")>
    <cfset orgSigPlain = ReReplaceNoCase(orgSigPlain,     "(\r?\n){3,}",      Chr(10) & Chr(10), "all")>
    <cfset orgSigPlain = Trim(orgSigPlain)>

    <cffile action="write" file="#orgSigOptDir#/body.txt"  output="#orgSigPlain##Chr(10)#"     charset="utf-8" addnewline="no">
    <cffile action="write" file="#orgSigOptDir#/body.html" output="#orgSigRewritten##Chr(10)#" charset="utf-8" addnewline="no">
</cfif>

<cfset StructDelete(variables, "orgSignatureWriteRowId", false)>
