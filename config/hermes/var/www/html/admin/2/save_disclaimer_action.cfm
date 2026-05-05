<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
SAVE DISCLAIMER ACTION HANDLER (#214 Phase 2).

INSERT or UPDATE the disclaimers row from the edit_disclaimer.cfm form.
Scope is immutable after create -- UPDATE keeps the original scope from
the row and ignores form.scope. Scope key is validated against the
appropriate source table on each save.

Phase 2 stops at the DB write. Phase 3 will add the per-scope file
write to /etc/amavis/disclaimers/ and the Amavis policy bank regen +
reload that actually wire the disclaimer into the outbound mail flow.
--->

<!--- PRO EDITION LICENSE CHECK. Action handlers run before any layout
     so abort with a redirect if license is unhealthy or edition is
     Community. license_check.cfm aborts on TAMPERED / PENDING /
     INVALID; the cfif below catches Community downgrades. --->
<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset session.disclaimer_msg = "<strong>Pro license required.</strong> Disclaimers are a Pro Edition feature.">
    <cfset session.disclaimer_msg_type = "warning">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- COLLECT FORM VALUES --->
<cfparam name="form.id"       default="0">
<cfparam name="form.scope"    default="">
<cfparam name="form.scope_key_domain"   default="">
<cfparam name="form.scope_key_relay"    default="">
<cfparam name="form.enabled"  default="0">
<cfparam name="form.position" default="append">
<cfparam name="form.body_text" default="">
<cfparam name="form.body_html" default="">

<cfset isEdit = (IsNumeric(form.id) AND Val(form.id) GT 0)>

<!--- LOCK SCOPE on edit. Use the row's scope, ignore form.scope. --->
<cfif isEdit>
    <cfquery name="getExisting" datasource="hermes">
        SELECT scope, scope_key
        FROM disclaimers
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getExisting.recordcount LT 1>
        <cfset session.disclaimer_msg = "<strong>Save failed.</strong> The row no longer exists.">
        <cfset session.disclaimer_msg_type = "danger">
        <cflocation url="view_disclaimers.cfm" addtoken="no">
    </cfif>
    <cfset effectiveScope = getExisting.scope>
<cfelse>
    <cfset effectiveScope = form.scope>
</cfif>

<!--- VALIDATE scope --->
<cfif effectiveScope NEQ "domain" AND effectiveScope NEQ "relay">
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Invalid scope.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- DERIVE the active scope_key from the matching form field. The
     edit form renders three selects but disables the inactive ones, so
     only one will be populated; we just pick the field that matches
     the chosen scope. --->
<cfswitch expression="#effectiveScope#">
    <cfcase value="domain"> <cfset effectiveScopeKey = Trim(form.scope_key_domain)>  </cfcase>
    <cfcase value="relay">  <cfset effectiveScopeKey = Trim(form.scope_key_relay)>   </cfcase>
</cfswitch>

<cfif effectiveScopeKey EQ "">
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Pick a target for the chosen scope.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- VALIDATE scope_key against its source table. Defends against
     hand-crafted POSTs that bypass the form's dropdown. --->
<cfswitch expression="#effectiveScope#">
    <cfcase value="domain">
        <cfquery name="checkScopeKey" datasource="hermes">
            SELECT id FROM domains WHERE domain = <cfqueryparam value="#effectiveScopeKey#" cfsqltype="cf_sql_varchar">
        </cfquery>
    </cfcase>
    <cfcase value="relay">
        <!--- Mirror the dropdown filter in edit_disclaimer.cfm -- exclude
             rows that exist in the mailboxes table so a hand-crafted
             POST with a mailbox address can't persist as a relay row. --->
        <cfquery name="checkScopeKey" datasource="hermes">
            SELECT r.id
            FROM recipients r
            LEFT JOIN mailboxes m ON m.username = r.recipient
            WHERE r.recipient = <cfqueryparam value="#effectiveScopeKey#" cfsqltype="cf_sql_varchar">
              AND (r.recipient_type = 'relay' OR r.recipient_type IS NULL)
              AND r.domain IS NULL
              AND m.id IS NULL
        </cfquery>
    </cfcase>
</cfswitch>
<cfif checkScopeKey.recordcount LT 1>
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> The selected target does not exist.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- VALIDATE position --->
<cfif form.position NEQ "append" AND form.position NEQ "prepend">
    <cfset form.position = "append">
</cfif>

<!--- #230 image validation. Quill embeds pasted/uploaded images as
     base64 inline data: URLs in body_html. We enforce safety limits
     here BEFORE the DB write so an admin who pastes a 10 MB PNG (or
     a SVG with embedded scripts, or 50 tiny icons) is told no without
     bloating every outbound message that gets this disclaimer.

     Limits:
       - Max 200 KB per image (after base64 decode)
       - Max 5 images per disclaimer
       - Max 1 MB total across all images
       - Allowed types: png, jpeg, gif
       - SVG and webp explicitly rejected (security and MUA-support gaps).

     Decoded size approximation: base64 chars produce 3 bytes per 4 chars.
     Slight overcount due to padding; close enough for limit enforcement. --->
<cfset MAX_IMG_SIZE_BYTES = 200 * 1024>
<cfset MAX_IMG_COUNT = 5>
<cfset MAX_TOTAL_SIZE_BYTES = 1024 * 1024>
<cfset ALLOWED_IMG_FORMATS = "png,jpeg,jpg,gif">

<cfset imgValidationPattern = "<img\s+[^>]*src\s*=\s*[""']data:image/([\w+-]+);base64,([^""']+)[""'][^>]*>">
<cfset imgValidationMatches = REMatchNoCase(imgValidationPattern, form.body_html)>

<cfif ArrayLen(imgValidationMatches) GT MAX_IMG_COUNT>
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Too many images (" & ArrayLen(imgValidationMatches) & " > limit of " & MAX_IMG_COUNT & "). Reduce the image count and try again.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<cfset totalImgSize = 0>
<cfloop array="#imgValidationMatches#" index="imgTagToCheck">
    <cfset capturedCheck = ReFindNoCase(imgValidationPattern, imgTagToCheck, 1, true)>
    <cfif ArrayLen(capturedCheck.pos) GTE 3 AND capturedCheck.pos[2] GT 0>
        <cfset checkFormat = LCase(Mid(imgTagToCheck, capturedCheck.pos[2], capturedCheck.len[2]))>
        <cfset checkB64    = Mid(imgTagToCheck, capturedCheck.pos[3], capturedCheck.len[3])>

        <cfif NOT ListFind(ALLOWED_IMG_FORMATS, checkFormat)>
            <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Image type <code>" & HTMLEditFormat(checkFormat) & "</code> is not allowed. Allowed types: PNG, JPEG, GIF. SVG and WebP are rejected for security and recipient-compatibility reasons.">
            <cfset session.disclaimer_msg_type = "danger">
            <cflocation url="view_disclaimers.cfm" addtoken="no">
        </cfif>

        <cfset decodedBytes = Int((Len(checkB64) * 3) / 4)>
        <cfif decodedBytes GT MAX_IMG_SIZE_BYTES>
            <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Image too large: " & NumberFormat(decodedBytes / 1024, "9.9") & " KB exceeds the " & (MAX_IMG_SIZE_BYTES / 1024) & " KB per-image limit.">
            <cfset session.disclaimer_msg_type = "danger">
            <cflocation url="view_disclaimers.cfm" addtoken="no">
        </cfif>

        <cfset totalImgSize = totalImgSize + decodedBytes>
    </cfif>
</cfloop>

<cfif totalImgSize GT MAX_TOTAL_SIZE_BYTES>
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Total image size " & NumberFormat(totalImgSize / 1024, "9.9") & " KB exceeds the " & (MAX_TOTAL_SIZE_BYTES / 1024) & " KB total limit. Use smaller or fewer images.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- NORMALIZE enabled (checkbox: present + value=1 means on, absent means off) --->
<cfset enabledFlag = (form.enabled EQ "1") ? 1 : 0>

<!--- PERSIST. Use ON DUPLICATE KEY UPDATE so the unique (scope,scope_key)
     constraint can't be violated by an admin who creates two rows for
     the same target -- the second creation just overwrites the body. --->
<cfif isEdit>
    <cfquery datasource="hermes">
        UPDATE disclaimers
        SET enabled    = <cfqueryparam value="#enabledFlag#"           cfsqltype="cf_sql_tinyint">,
            position   = <cfqueryparam value="#form.position#"          cfsqltype="cf_sql_varchar">,
            body_text  = <cfqueryparam value="#form.body_text#"         cfsqltype="cf_sql_longvarchar">,
            body_html  = <cfqueryparam value="#form.body_html#"         cfsqltype="cf_sql_longvarchar">,
            scope_key  = <cfqueryparam value="#effectiveScopeKey#"      cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.disclaimer_msg = "<strong>Saved.</strong> Disclaimer for " & HTMLEditFormat(effectiveScopeKey) & " updated.">
<cfelse>
    <cfquery datasource="hermes">
        INSERT INTO disclaimers (scope, scope_key, enabled, position, body_text, body_html)
        VALUES (
            <cfqueryparam value="#effectiveScope#"     cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#effectiveScopeKey#"  cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#enabledFlag#"        cfsqltype="cf_sql_tinyint">,
            <cfqueryparam value="#form.position#"      cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.body_text#"     cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#form.body_html#"     cfsqltype="cf_sql_longvarchar">
        )
        ON DUPLICATE KEY UPDATE
            enabled   = VALUES(enabled),
            position  = VALUES(position),
            body_text = VALUES(body_text),
            body_html = VALUES(body_html)
    </cfquery>
    <cfset session.disclaimer_msg = "<strong>Saved.</strong> New disclaimer for " & HTMLEditFormat(effectiveScopeKey) & " created.">
</cfif>
<cfset session.disclaimer_msg_type = "success">

<!--- Phase 3: regenerate per-scope disclaimer files + reload Amavis
     so the change takes effect on outbound mail. Fails non-fatally -
     the DB row is committed regardless, and the next save will retry
     the regen. The user-facing message is augmented to surface the
     reload status. --->
<cfinclude template="./inc/disclaimer_write_and_reload.cfm" />

<cfif structKeyExists(session, "disclaimerApplySuccess") AND NOT session.disclaimerApplySuccess>
    <cfset session.disclaimer_msg = session.disclaimer_msg & " <br><strong>Warning:</strong> the database row was saved but the body-milter config write failed (#HTMLEditFormat(session.disclaimerApplyError)#). The next successful save will retry; existing disclaimers continue to apply until then.">
    <cfset session.disclaimer_msg_type = "warning">
</cfif>

<cflocation url="view_disclaimers.cfm" addtoken="no">
