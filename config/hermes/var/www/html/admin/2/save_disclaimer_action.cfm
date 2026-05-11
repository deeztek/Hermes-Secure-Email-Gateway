<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
SAVE DISCLAIMER ACTION HANDLER (#235) - template-rendered version.

POST handler for edit_disclaimer.cfm. Validates inputs, renders the
chosen template with admin-supplied field values, stores both the
form-field map (fields_json) and the rendered HTML (body_html) on the
row so disclaimer_write_and_reload.cfm can push to disk without
re-running the CFML render.

Scope is locked after creation (the unique-key constraint and the
on-disk layout under /etc/hermes/body_milter/disclaimers/files/
both key off scope+scope_key).

After DB write, calls disclaimer_write_and_reload.cfm to push changes
to the body milter on-disk artifacts.

Replaces the previous Quill-driven flow (#214 Phase 2/3) which accepted
raw body_html from the editor. See GH issue #235 for the rationale.
--->

<!--- PRO EDITION LICENSE CHECK. --->
<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset session.disclaimer_msg = "<strong>Pro license required.</strong> Disclaimers are a Pro Edition feature.">
    <cfset session.disclaimer_msg_type = "warning">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- COLLECT FORM VALUES --->
<cfparam name="form.mode"               default="add">
<cfparam name="form.id"                 default="0">
<cfparam name="form.scope"              default="">
<cfparam name="form.scope_key_domain"   default="">
<cfparam name="form.scope_key_relay"    default="">
<cfparam name="form.enabled"            default="0">
<cfparam name="form.position"           default="append">
<cfparam name="form.template_key"       default="">

<cfset mode = (form.mode EQ "edit") ? "edit" : "add">
<cfset rowId = Val(form.id)>
<cfset isEdit = (mode EQ "edit" AND rowId GT 0)>
<cfset templateKey = Trim(form.template_key)>
<cfset positionFlag = (form.position EQ "prepend") ? "prepend" : "append">
<cfset enabledFlag = (Trim(form.enabled) EQ "1") ? 1 : 0>

<!--- LOCK SCOPE + SCOPE_KEY on edit. Use the row's values, ignore form. --->
<cfif isEdit>
    <cfquery name="getExisting" datasource="hermes">
        SELECT scope, scope_key
        FROM disclaimers
        WHERE id = <cfqueryparam value="#rowId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getExisting.recordcount LT 1>
        <cfset session.disclaimer_msg = "<strong>Save failed.</strong> The row no longer exists.">
        <cfset session.disclaimer_msg_type = "danger">
        <cflocation url="view_disclaimers.cfm" addtoken="no">
    </cfif>
    <cfset effectiveScope    = getExisting.scope>
    <cfset effectiveScopeKey = getExisting.scope_key>
<cfelse>
    <cfset effectiveScope = Trim(form.scope)>
    <cfswitch expression="#effectiveScope#">
        <cfcase value="domain"> <cfset effectiveScopeKey = Trim(form.scope_key_domain)>  </cfcase>
        <cfcase value="relay">  <cfset effectiveScopeKey = Trim(form.scope_key_relay)>   </cfcase>
        <cfdefaultcase>         <cfset effectiveScopeKey = "">                            </cfdefaultcase>
    </cfswitch>
</cfif>

<!--- VALIDATE scope --->
<cfif effectiveScope NEQ "domain" AND effectiveScope NEQ "relay">
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Invalid scope.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<cfif effectiveScopeKey EQ "">
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Pick a target for the chosen scope.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- VALIDATE scope_key against its source table (defends hand-crafted POSTs). --->
<cfif NOT isEdit>
    <cfswitch expression="#effectiveScope#">
        <cfcase value="domain">
            <cfquery name="checkScopeKey" datasource="hermes">
                SELECT id FROM domains WHERE domain = <cfqueryparam value="#effectiveScopeKey#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfcase>
        <cfcase value="relay">
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
</cfif>

<!--- DUPE check on add: only one disclaimer per (scope, scope_key). --->
<cfif NOT isEdit>
    <cfquery name="dupeCheck" datasource="hermes">
        SELECT id FROM disclaimers
        WHERE scope     = <cfqueryparam value="#effectiveScope#"     cfsqltype="cf_sql_varchar">
          AND scope_key = <cfqueryparam value="#effectiveScopeKey#"  cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif dupeCheck.recordcount GTE 1>
        <cfset session.disclaimer_msg = "<strong>Save failed.</strong> A disclaimer already exists for " & HTMLEditFormat(effectiveScopeKey) & ". <a href=""edit_disclaimer.cfm?id=" & dupeCheck.id & """ class=""alert-link"">Edit the existing one</a> or remove it first.">
        <cfset session.disclaimer_msg_type = "danger">
        <cfset restoreData = {}>
        <cfloop collection="#form#" item="restoreKey">
            <cfset restoreData[restoreKey] = form[restoreKey]>
        </cfloop>
        <cfset session.disclaimer_form_restore = restoreData>
        <cflocation url="edit_disclaimer.cfm" addtoken="no">
    </cfif>
</cfif>

<!--- VALIDATE template --->
<cfinclude template="./inc/disclaimer_template_loader.cfm" />

<cfif NOT ArrayContains(variables.disclaimerTemplateRegistry, templateKey)>
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Invalid template selection.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<cfset templatePath = variables.disclaimerTemplateDir & templateKey & ".cfm">
<cfif NOT FileExists(templatePath)>
    <cfset session.disclaimer_msg = "<strong>Save failed.</strong> Template file is missing on disk.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- BUILD fields struct from form (same logic as render preview). --->
<cfset template = {}>
<cfinclude template="inc/disclaimer_templates/#templateKey#.cfm" />

<cfset fields = {}>
<cfloop array="#template.fields#" index="f">
    <cfset formKey = "field_" & f.name>
    <cfif f.type EQ "checkbox">
        <cfset fields[f.name] = StructKeyExists(form, formKey) AND Trim(form[formKey]) EQ "1">
    <cfelse>
        <cfif StructKeyExists(form, formKey) AND Len(Trim(form[formKey]))>
            <cfset fields[f.name] = form[formKey]>
        <cfelseif StructKeyExists(f, "default")>
            <cfset fields[f.name] = f.default>
        <cfelse>
            <cfset fields[f.name] = "">
        </cfif>
    </cfif>
</cfloop>

<cfset fieldsJson = SerializeJSON(fields)>

<!--- RENDER --->
<cfset renderTemplate = true>
<cfsavecontent variable="renderedHtml"><cfinclude template="inc/disclaimer_templates/#templateKey#.cfm" /></cfsavecontent>
<cfset renderedHtml = Trim(renderedHtml)>

<!--- Auto-derive plain text from the rendered HTML. Strip tags, collapse newlines. --->
<cfset renderedText = ReReplaceNoCase(renderedHtml, "<br\s*/?>", Chr(10), "all")>
<cfset renderedText = ReReplaceNoCase(renderedText, "</p>|</li>|</tr>|</td>|</div>", Chr(10), "all")>
<cfset renderedText = ReReplaceNoCase(renderedText, "<[^>]+>", "", "all")>
<cfset renderedText = ReReplaceNoCase(renderedText, "(\r?\n){2,}", Chr(10), "all")>
<cfset renderedText = Trim(renderedText)>

<!--- INSERT or UPDATE --->
<cfif isEdit>
    <cfquery datasource="hermes">
        UPDATE disclaimers
        SET template_key = <cfqueryparam value="#templateKey#"    cfsqltype="cf_sql_varchar">,
            fields_json  = <cfqueryparam value="#fieldsJson#"     cfsqltype="cf_sql_longvarchar">,
            body_text    = <cfqueryparam value="#renderedText#"   cfsqltype="cf_sql_longvarchar">,
            body_html    = <cfqueryparam value="#renderedHtml#"   cfsqltype="cf_sql_longvarchar">,
            position     = <cfqueryparam value="#positionFlag#"   cfsqltype="cf_sql_varchar">,
            enabled      = <cfqueryparam value="#enabledFlag#"    cfsqltype="cf_sql_tinyint">
        WHERE id = <cfqueryparam value="#rowId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.disclaimer_msg = "<strong>Saved.</strong> Disclaimer for " & HTMLEditFormat(effectiveScopeKey) & " updated.">
<cfelse>
    <cfquery datasource="hermes">
        INSERT INTO disclaimers (scope, scope_key, enabled, position, template_key, fields_json, body_text, body_html)
        VALUES (
            <cfqueryparam value="#effectiveScope#"     cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#effectiveScopeKey#"  cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#enabledFlag#"        cfsqltype="cf_sql_tinyint">,
            <cfqueryparam value="#positionFlag#"       cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#templateKey#"        cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#fieldsJson#"         cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#renderedText#"       cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#renderedHtml#"       cfsqltype="cf_sql_longvarchar">
        )
    </cfquery>
    <cfset session.disclaimer_msg = "<strong>Saved.</strong> New disclaimer for " & HTMLEditFormat(effectiveScopeKey) & " created.">
</cfif>
<cfset session.disclaimer_msg_type = "success">

<!--- Push to body milter on-disk artifacts (mtime-watched). --->
<cfinclude template="./inc/disclaimer_write_and_reload.cfm" />

<cfif structKeyExists(session, "disclaimerApplySuccess") AND NOT session.disclaimerApplySuccess>
    <cfset session.disclaimer_msg = session.disclaimer_msg & " <br><strong>Warning:</strong> the database row was saved but the body-milter config write failed (#HTMLEditFormat(session.disclaimerApplyError)#). The next successful save will retry; existing disclaimers continue to apply until then.">
    <cfset session.disclaimer_msg_type = "warning">
</cfif>

<cflocation url="view_disclaimers.cfm" addtoken="no">
