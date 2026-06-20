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
SAVE PERSONAL SIGNATURE ACTION (#226)

User-portal POST handler. Validates image limits (mirrors #230 disclaimer
pipeline), UPSERTs into user_signatures, regenerates the per-user
on-disk files for the body_milter to consume.

Re-checks the domain allow_user_signatures gate server-side - if a
malicious POST hits this endpoint after the admin disabled the feature,
we reject it instead of trusting the form action exposed by the page.
--->

<cfif NOT StructKeyExists(session, "email") OR session.email EQ "">
    <cflocation url="/admin/2/logout.cfm" addtoken="no">
</cfif>

<!--- Server-side gate: re-check domain.allow_user_signatures --->
<cfquery name="getDomain" datasource="hermes">
    SELECT d.allow_user_signatures
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id
    WHERE m.username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif getDomain.recordcount LT 1 OR Val(getDomain.allow_user_signatures) NEQ 1>
    <cfset session.signature_msg = "<strong>Save failed.</strong> Personal signatures are disabled for your domain.">
    <cfset session.signature_msg_type = "danger">
    <cflocation url="../view_signature.cfm" addtoken="no">
</cfif>

<cfparam name="form.enabled"   default="0">
<cfparam name="form.body_text" default="">
<cfparam name="form.body_html" default="">

<cfset enabledFlag = (form.enabled EQ "1") ? 1 : 0>

<!--- #230-style image validation. Quill embeds pasted/uploaded images
     as base64 inline data: URLs in body_html. Enforce safety limits
     BEFORE the DB write so a user who pastes a 10 MB PNG (or a SVG
     with embedded scripts, or 50 tiny icons) is told no rather than
     bloating every outbound message they send.

     Limits:
       - Max 200 KB per image (after base64 decode)
       - Max 5 images per signature
       - Max 1 MB total across all images
       - Allowed types: png, jpeg, gif
       - SVG and webp explicitly rejected (security and MUA-support gaps).

     Decoded size approximation: base64 chars produce 3 bytes per 4 chars. --->
<cfset MAX_IMG_SIZE_BYTES = 200 * 1024>
<!--- Bumped to 10 (was 5) so users can pair a logo with up to 4-6
     social-media icons + a headshot without hitting the cap. The
     1 MB total budget below still bounds outbound message bloat. --->
<cfset MAX_IMG_COUNT = 10>
<cfset MAX_TOTAL_SIZE_BYTES = 1024 * 1024>
<cfset ALLOWED_IMG_FORMATS = "png,jpeg,jpg,gif">

<cfset imgValidationPattern = "<img\s+[^>]*src\s*=\s*[""']data:image/([\w+-]+);base64,([^""']+)[""'][^>]*>">
<cfset imgValidationMatches = REMatchNoCase(imgValidationPattern, form.body_html)>

<cfif ArrayLen(imgValidationMatches) GT MAX_IMG_COUNT>
    <cfset session.signature_msg = "<strong>Save failed.</strong> Too many images (" & ArrayLen(imgValidationMatches) & " > limit of " & MAX_IMG_COUNT & "). Reduce the image count and try again.">
    <cfset session.signature_msg_type = "danger">
    <cflocation url="../view_signature.cfm" addtoken="no">
</cfif>

<cfset totalImgSize = 0>
<cfloop array="#imgValidationMatches#" index="imgTagToCheck">
    <cfset capturedCheck = ReFindNoCase(imgValidationPattern, imgTagToCheck, 1, true)>
    <cfif ArrayLen(capturedCheck.pos) GTE 3 AND capturedCheck.pos[2] GT 0>
        <cfset checkFormat = LCase(Mid(imgTagToCheck, capturedCheck.pos[2], capturedCheck.len[2]))>
        <cfset checkB64    = Mid(imgTagToCheck, capturedCheck.pos[3], capturedCheck.len[3])>

        <cfif NOT ListFind(ALLOWED_IMG_FORMATS, checkFormat)>
            <cfset session.signature_msg = "<strong>Save failed.</strong> Image type <code>" & HTMLEditFormat(checkFormat) & "</code> is not allowed. Allowed types: PNG, JPEG, GIF. SVG and WebP are rejected for security and recipient-compatibility reasons.">
            <cfset session.signature_msg_type = "danger">
            <cflocation url="../view_signature.cfm" addtoken="no">
        </cfif>

        <cfset decodedBytes = Int((Len(checkB64) * 3) / 4)>
        <cfif decodedBytes GT MAX_IMG_SIZE_BYTES>
            <cfset session.signature_msg = "<strong>Save failed.</strong> Image too large: " & NumberFormat(decodedBytes / 1024, "9.9") & " KB exceeds the " & (MAX_IMG_SIZE_BYTES / 1024) & " KB per-image limit.">
            <cfset session.signature_msg_type = "danger">
            <cflocation url="../view_signature.cfm" addtoken="no">
        </cfif>

        <cfset totalImgSize = totalImgSize + decodedBytes>
    </cfif>
</cfloop>

<cfif totalImgSize GT MAX_TOTAL_SIZE_BYTES>
    <cfset session.signature_msg = "<strong>Save failed.</strong> Total image size " & NumberFormat(totalImgSize / 1024, "9.9") & " KB exceeds the " & (MAX_TOTAL_SIZE_BYTES / 1024) & " KB total limit. Use smaller or fewer images.">
    <cfset session.signature_msg_type = "danger">
    <cflocation url="../view_signature.cfm" addtoken="no">
</cfif>

<!--- UPSERT keyed on uniq_username. source='user' marks this row as
     user-edited so the future Pro LDAP auto-gen pass skips it. --->
<cfquery datasource="hermes">
    INSERT INTO user_signatures (username, enabled, source, body_text, body_html)
    VALUES (
        <cfqueryparam value="#session.email#"    cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#enabledFlag#"      cfsqltype="cf_sql_tinyint">,
        'user',
        <cfqueryparam value="#form.body_text#"   cfsqltype="cf_sql_longvarchar" null="#(Trim(form.body_text) EQ '')#">,
        <cfqueryparam value="#form.body_html#"   cfsqltype="cf_sql_longvarchar" null="#(Trim(form.body_html) EQ '')#">
    )
    ON DUPLICATE KEY UPDATE
        enabled    = <cfqueryparam value="#enabledFlag#"     cfsqltype="cf_sql_tinyint">,
        source     = 'user',
        body_text  = <cfqueryparam value="#form.body_text#"  cfsqltype="cf_sql_longvarchar" null="#(Trim(form.body_text) EQ '')#">,
        body_html  = <cfqueryparam value="#form.body_html#"  cfsqltype="cf_sql_longvarchar" null="#(Trim(form.body_html) EQ '')#">
</cfquery>

<!--- Regenerate on-disk files for body_milter. Sets
     session.signatureApplySuccess and session.signatureApplyError. --->
<cfinclude template="./signature_write_and_reload.cfm">

<cfif session.signatureApplySuccess>
    <cfset session.signature_msg = "<strong>Signature saved.</strong> Changes will appear on your next outbound message.">
    <cfset session.signature_msg_type = "success">
<cfelse>
    <cfset session.signature_msg = "<strong>Signature saved to database, but the on-disk file regeneration failed.</strong> Detail: " & HTMLEditFormat(session.signatureApplyError) & ". Contact your administrator.">
    <cfset session.signature_msg_type = "warning">
</cfif>

<cflocation url="../view_signature.cfm" addtoken="no">
