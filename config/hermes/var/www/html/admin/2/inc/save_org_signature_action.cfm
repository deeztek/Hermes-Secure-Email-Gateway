<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
SAVE ORGANIZATIONAL SIGNATURE (#226 Phase 2A).

POST handler for edit_org_signature.cfm. Validates inputs, renders the
template with admin-supplied field values, and INSERTs or UPDATEs the
org_signatures row.

The (domain_id, department_label) pair must be unique. NULL counts as
"domain default" (one per domain), but MariaDB treats NULLs as distinct
in UNIQUE indexes, so the uniqueness rule for NULL department is
enforced here in the application layer rather than at the DB level.

Phase 2B: this also kicks off body-milter file regen + map rebuild.
For now we just write the row; the milter wiring is a separate step.
--->

<cfinclude template="../inc/setsession.cfm" />
<cfinclude template="./license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset session.org_sig_msg = "<strong>Pro license required.</strong>">
    <cfset session.org_sig_msg_type = "warning">
    <cflocation url="../view_org_signatures.cfm" addtoken="no">
</cfif>

<cfparam name="form.mode"             default="add">
<cfparam name="form.id"               default="0">
<cfparam name="form.domain_id"        default="0">
<cfparam name="form.department_label" default="">
<cfparam name="form.template_key"     default="">
<cfparam name="form.enabled"          default="0">

<cfset mode = (form.mode EQ "edit") ? "edit" : "add">
<cfset rowId = Val(form.id)>
<cfset domainId = Val(form.domain_id)>
<cfset deptRaw = Trim(form.department_label)>
<cfset deptIsNull = (Len(deptRaw) EQ 0)>
<cfset templateKey = Trim(form.template_key)>
<cfset enabledFlag = (Trim(form.enabled) EQ "1") ? 1 : 0>

<!--- VALIDATION --->
<cfif domainId LTE 0>
    <cfset session.org_sig_msg = "<strong>Save failed.</strong> A domain is required.">
    <cfset session.org_sig_msg_type = "danger">
    <cflocation url="../edit_org_signature.cfm#(mode EQ 'edit' ? '?id=' & rowId : '')#" addtoken="no">
</cfif>

<cfquery name="checkDomain" datasource="hermes">
    SELECT id FROM domains
    WHERE id = <cfqueryparam value="#domainId#" cfsqltype="cf_sql_integer">
      AND type = 'mailbox'
</cfquery>
<cfif checkDomain.recordcount LT 1>
    <cfset session.org_sig_msg = "<strong>Save failed.</strong> The selected domain doesn't exist or isn't a mailbox-hosting domain.">
    <cfset session.org_sig_msg_type = "danger">
    <cflocation url="../view_org_signatures.cfm" addtoken="no">
</cfif>

<cfinclude template="./org_signature_template_loader.cfm" />

<cfif NOT ArrayContains(variables.orgSignatureTemplateRegistry, templateKey)>
    <cfset session.org_sig_msg = "<strong>Save failed.</strong> Invalid template selection.">
    <cfset session.org_sig_msg_type = "danger">
    <cflocation url="../view_org_signatures.cfm" addtoken="no">
</cfif>

<cfset templatePath = variables.orgSignatureTemplateDir & templateKey & ".cfm">
<cfif NOT FileExists(templatePath)>
    <cfset session.org_sig_msg = "<strong>Save failed.</strong> Template file is missing on disk.">
    <cfset session.org_sig_msg_type = "danger">
    <cflocation url="../view_org_signatures.cfm" addtoken="no">
</cfif>

<!--- DUPLICATE CHECK. (domain_id, department_label) must be unique.
     MariaDB UNIQUE allows multiple NULLs so we enforce here.
     `<=>` is NULL-safe equality but isn't portable; using explicit
     IS NULL branch instead. --->
<cfquery name="dupeCheck" datasource="hermes">
    SELECT id FROM org_signatures
    WHERE domain_id = <cfqueryparam value="#domainId#" cfsqltype="cf_sql_integer">
      <cfif deptIsNull>
        AND department_label IS NULL
      <cfelse>
        AND department_label = <cfqueryparam value="#deptRaw#" cfsqltype="cf_sql_varchar">
      </cfif>
      <cfif mode EQ "edit">
        AND id <> <cfqueryparam value="#rowId#" cfsqltype="cf_sql_integer">
      </cfif>
</cfquery>

<cfif dupeCheck.recordcount GTE 1>
    <cfset variantLabel = deptIsNull ? "domain default" : ("'" & deptRaw & "' department")>
    <cfset existingId = dupeCheck.id>
    <cfset session.org_sig_msg = "<strong>Save failed.</strong> A " & HTMLEditFormat(variantLabel) & " signature already exists for this domain. <a href=""edit_org_signature.cfm?id=" & existingId & """ class=""alert-link"">Edit the existing one</a> or pick a different department.">
    <cfset session.org_sig_msg_type = "danger">
    <!--- One-shot stash so the edit page can repopulate the admin's
         in-flight inputs after the redirect (otherwise everything they
         just typed gets wiped). We strip data: URIs because they can
         be 1+ MB each and session storage is in-memory; admin will
         need to re-pick the file in the unlikely case they uploaded
         AND hit a dupe slot in the same submit. --->
    <cfset restoreData = {}>
    <cfloop collection="#form#" item="restoreKey">
        <cfset restoreVal = form[restoreKey]>
        <cfif IsSimpleValue(restoreVal) AND Left(restoreVal, 5) EQ "data:">
            <!--- skip data: URIs (oversized, admin re-picks file) --->
        <cfelse>
            <cfset restoreData[restoreKey] = restoreVal>
        </cfif>
    </cfloop>
    <cfset session.org_sig_form_restore = restoreData>
    <cflocation url="../edit_org_signature.cfm#(mode EQ 'edit' ? '?id=' & rowId : '')#" addtoken="no">
</cfif>

<!--- BUILD FIELDS STRUCT FROM FORM. Same logic as render preview. --->
<cfset template = {}>
<cfinclude template="org_signature_templates/#templateKey#.cfm" />

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
<cfsavecontent variable="renderedHtml"><cfinclude template="org_signature_templates/#templateKey#.cfm" /></cfsavecontent>
<cfset renderedHtml = Trim(renderedHtml)>

<!--- INSERT or UPDATE --->
<cfif mode EQ "edit" AND rowId GT 0>
    <cfquery datasource="hermes">
        UPDATE org_signatures SET
            domain_id        = <cfqueryparam value="#domainId#"     cfsqltype="cf_sql_integer">,
            department_label = <cfqueryparam value="#deptRaw#"      cfsqltype="cf_sql_varchar" null="#deptIsNull#">,
            template_key     = <cfqueryparam value="#templateKey#"  cfsqltype="cf_sql_varchar">,
            fields_json      = <cfqueryparam value="#fieldsJson#"   cfsqltype="cf_sql_longvarchar">,
            rendered_html    = <cfqueryparam value="#renderedHtml#" cfsqltype="cf_sql_longvarchar">,
            enabled          = <cfqueryparam value="#enabledFlag#"  cfsqltype="cf_sql_tinyint">
        WHERE id = <cfqueryparam value="#rowId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.org_sig_msg = "<strong>Saved.</strong> Organizational Signature updated.">
<cfelse>
    <cfquery datasource="hermes" result="ins">
        INSERT INTO org_signatures
            (domain_id, department_label, template_key, fields_json, rendered_html, enabled)
        VALUES (
            <cfqueryparam value="#domainId#"     cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#deptRaw#"      cfsqltype="cf_sql_varchar" null="#deptIsNull#">,
            <cfqueryparam value="#templateKey#"  cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#fieldsJson#"   cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#renderedHtml#" cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="#enabledFlag#"  cfsqltype="cf_sql_tinyint">
        )
    </cfquery>
    <cfset session.org_sig_msg = "<strong>Saved.</strong> Organizational Signature created.">
</cfif>
<cfset session.org_sig_msg_type = "success">

<!--- Phase 2B: write per-row file to body milter signatures dir +
     regenerate resolution map. For now the row is in the database
     and the milter pipeline will pick it up once that wiring lands. --->

<cflocation url="../view_org_signatures.cfm" addtoken="no">
