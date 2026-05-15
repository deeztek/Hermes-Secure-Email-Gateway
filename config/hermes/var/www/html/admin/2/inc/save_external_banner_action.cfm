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
SAVE EXTERNAL SENDER BANNER ACTION (#228) - template-rendered version.

POST handler for edit_external_banner.cfm. Validates inputs, renders
the chosen template with admin-supplied field values, stores both the
form-field map (fields_json) and the rendered HTML (body_html) on the
row so the regenerator can write to disk without re-running the CFML
render.

recipient_domain is locked after creation. Empty form value = system
default = NULL row. NULL is the unique-key target for "system default";
MariaDB's NULL-distinct behavior in unique indexes lets one NULL row +
N per-domain rows coexist.

After DB write, calls external_banner_write_and_reload.cfm to push
changes to the body milter on-disk artifacts.
--->

<cfinclude template="../inc/setsession.cfm" />

<cfparam name="form.mode"             default="add">
<cfparam name="form.id"               default="0">
<cfparam name="form.recipient_domain" default="">
<cfparam name="form.template_key"     default="">
<cfparam name="form.position"         default="prepend">
<cfparam name="form.enabled"          default="0">

<cfset mode = (form.mode EQ "edit") ? "edit" : "add">
<cfset rowId = Val(form.id)>
<cfset templateKey = Trim(form.template_key)>
<cfset positionFlag = (form.position EQ "append") ? "append" : "prepend">
<cfset enabledFlag = (Trim(form.enabled) EQ "1") ? 1 : 0>

<!--- LOCK recipient_domain on edit. --->
<cfif mode EQ "edit" AND rowId GT 0>
    <cfquery name="getExisting" datasource="hermes">
        SELECT recipient_domain
        FROM external_banners
        WHERE id = <cfqueryparam value="#rowId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getExisting.recordcount LT 1>
        <cfset session.ext_banner_msg = "<strong>Save failed.</strong> The row no longer exists.">
        <cfset session.ext_banner_msg_type = "danger">
        <cflocation url="../view_external_banners.cfm" addtoken="no">
    </cfif>
    <cfset effectiveDomain = StructKeyExists(getExisting, "recipient_domain") AND Len(Trim(getExisting.recipient_domain)) ? Trim(getExisting.recipient_domain) : "">
<cfelse>
    <cfset effectiveDomain = Trim(form.recipient_domain)>
</cfif>

<cfset isSystemDefault = (Len(effectiveDomain) EQ 0)>

<!--- VALIDATE recipient_domain (only when not system default). --->
<cfif NOT isSystemDefault>
    <cfquery name="checkDomain" datasource="hermes">
        SELECT id FROM domains
        WHERE domain = <cfqueryparam value="#effectiveDomain#" cfsqltype="cf_sql_varchar">
          AND type = 'mailbox'
    </cfquery>
    <cfif checkDomain.recordcount LT 1>
        <cfset session.ext_banner_msg = "<strong>Save failed.</strong> The selected recipient domain doesn't exist or isn't a mailbox-hosting domain.">
        <cfset session.ext_banner_msg_type = "danger">
        <cflocation url="../view_external_banners.cfm" addtoken="no">
    </cfif>
</cfif>

<!--- VALIDATE template. --->
<cfinclude template="./external_banner_template_loader.cfm" />

<cfif NOT ArrayContains(variables.externalBannerTemplateRegistry, templateKey)>
    <cfset session.ext_banner_msg = "<strong>Save failed.</strong> Invalid template selection.">
    <cfset session.ext_banner_msg_type = "danger">
    <cflocation url="../view_external_banners.cfm" addtoken="no">
</cfif>

<cfset templatePath = variables.externalBannerTemplateDir & templateKey & ".cfm">
<cfif NOT FileExists(templatePath)>
    <cfset session.ext_banner_msg = "<strong>Save failed.</strong> Template file is missing on disk.">
    <cfset session.ext_banner_msg_type = "danger">
    <cflocation url="../view_external_banners.cfm" addtoken="no">
</cfif>

<!--- DUPE check on add: only one row per recipient_domain (NULL-safe). --->
<cfif mode NEQ "edit">
    <cfquery name="dupeCheck" datasource="hermes">
        SELECT id FROM external_banners
        WHERE
        <cfif isSystemDefault>
            recipient_domain IS NULL
        <cfelse>
            recipient_domain = <cfqueryparam value="#effectiveDomain#" cfsqltype="cf_sql_varchar">
        </cfif>
    </cfquery>
    <cfif dupeCheck.recordcount GTE 1>
        <cfset variantLabel = isSystemDefault ? "system default" : ("'" & effectiveDomain & "' recipient domain")>
        <cfset session.ext_banner_msg = "<strong>Save failed.</strong> A " & HTMLEditFormat(variantLabel) & " banner already exists. <a href=""edit_external_banner.cfm?id=" & dupeCheck.id & """ class=""alert-link"">Edit the existing one</a> or remove it first.">
        <cfset session.ext_banner_msg_type = "danger">
        <!--- Stash form scope (sans potential big values) for the edit
             page to repopulate. --->
        <cfset restoreData = {}>
        <cfloop collection="#form#" item="restoreKey">
            <cfset restoreData[restoreKey] = form[restoreKey]>
        </cfloop>
        <cfset session.ext_banner_form_restore = restoreData>
        <cflocation url="../edit_external_banner.cfm" addtoken="no">
    </cfif>
</cfif>

<!--- BUILD fields struct from form. Same logic as render preview. --->
<cfset template = {}>
<cfinclude template="external_banner_templates/#templateKey#.cfm" />

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
<cfsavecontent variable="renderedHtml"><cfinclude template="external_banner_templates/#templateKey#.cfm" /></cfsavecontent>
<cfset renderedHtml = Trim(renderedHtml)>

<!--- Auto-derive plain text from the rendered HTML. Strip tags, drop
     runs of newlines. --->
<cfset renderedText = ReReplaceNoCase(renderedHtml, "<br\s*/?>", Chr(10), "all")>
<cfset renderedText = ReReplaceNoCase(renderedText, "</p>|</li>|</tr>|</td>|</div>", Chr(10), "all")>
<cfset renderedText = ReReplaceNoCase(renderedText, "<[^>]+>", "", "all")>
<cfset renderedText = ReReplaceNoCase(renderedText, "(\r?\n){2,}", Chr(10), "all")>
<cfset renderedText = Trim(renderedText)>

<!--- INSERT or UPDATE --->
<cfif mode EQ "edit" AND rowId GT 0>
    <cfquery datasource="hermes">
        UPDATE external_banners SET
            template_key = <cfqueryparam value="#templateKey#"   cfsqltype="cf_sql_varchar">,
            fields_json  = <cfqueryparam value="#fieldsJson#"    cfsqltype="cf_sql_longvarchar">,
            body_text    = <cfqueryparam value="#renderedText#"  cfsqltype="cf_sql_longvarchar">,
            body_html    = <cfqueryparam value="#renderedHtml#"  cfsqltype="cf_sql_longvarchar">,
            position     = <cfqueryparam value="#positionFlag#"  cfsqltype="cf_sql_varchar">,
            enabled      = <cfqueryparam value="#enabledFlag#"   cfsqltype="cf_sql_tinyint">
        WHERE id = <cfqueryparam value="#rowId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset variantLabel = isSystemDefault ? "system default" : effectiveDomain>
    <cfset session.ext_banner_msg = "<strong>Saved.</strong> Banner for " & HTMLEditFormat(variantLabel) & " updated.">
<cfelse>
    <cfquery datasource="hermes">
        INSERT INTO external_banners
            (recipient_domain, template_key, fields_json, body_text, body_html, position, enabled)
        VALUES (
            <cfqueryparam value="#effectiveDomain#" cfsqltype="cf_sql_varchar"     null="#isSystemDefault#">,
            <cfqueryparam value="#templateKey#"     cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#fieldsJson#"      cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#renderedText#"    cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#renderedHtml#"    cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#positionFlag#"    cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#enabledFlag#"     cfsqltype="cf_sql_tinyint">
        )
    </cfquery>
    <cfset variantLabel = isSystemDefault ? "system default" : effectiveDomain>
    <cfset session.ext_banner_msg = "<strong>Saved.</strong> New banner for " & HTMLEditFormat(variantLabel) & " created.">
</cfif>
<cfset session.ext_banner_msg_type = "success">

<!--- Push changes to body milter on-disk artifacts. --->
<cfinclude template="./external_banner_write_and_reload.cfm" />

<cfif structKeyExists(session, "extBannerApplySuccess") AND NOT session.extBannerApplySuccess>
    <cfset session.ext_banner_msg = session.ext_banner_msg & " <br><strong>Warning:</strong> the database row was saved but the body-milter config write failed (#HTMLEditFormat(session.extBannerApplyError)#). The next successful save will retry; existing banners continue to apply until then.">
    <cfset session.ext_banner_msg_type = "warning">
</cfif>

<cflocation url="../view_external_banners.cfm" addtoken="no">
