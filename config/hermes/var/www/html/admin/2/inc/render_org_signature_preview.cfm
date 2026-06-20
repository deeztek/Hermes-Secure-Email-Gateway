<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
ORG SIGNATURE PREVIEW RENDER (#226 Phase 2A)

POST endpoint called by edit_org_signature.cfm's JS to preview the
selected template with the admin's current form values.

Inputs (form scope):
    template_key                - canonical key of the template to render
    field_<name>                - one entry per template field

Output: raw HTML (rendered template body), no head/wrapper.

The endpoint inspects the template's metadata to know the field list
and casts checkbox values to booleans (form scope only contains a
field_<name> entry when the checkbox was checked, so absence = false).
String fields fall back to their default if the form sent an empty
string AND the default exists; this matches what the save action
will store.
--->

<cfinclude template="../inc/setsession.cfm" />
<cfinclude template="./license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfheader statuscode="403" statustext="Forbidden">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Pro license required.</div></cfoutput>
    <cfabort>
</cfif>

<cfparam name="form.template_key" default="">

<cfinclude template="./org_signature_template_loader.cfm" />

<!--- Allowlist: only render templates that are in the registry AND
     exist on disk. Anything else returns an error so a tampered POST
     can't path-traverse into another file. --->
<cfif NOT ArrayContains(variables.orgSignatureTemplateRegistry, form.template_key)>
    <cfheader statuscode="400" statustext="Bad Request">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Unknown template: #HTMLEditFormat(form.template_key)#</div></cfoutput>
    <cfabort>
</cfif>

<cfset templatePath = variables.orgSignatureTemplateDir & form.template_key & ".cfm">
<cfif NOT FileExists(templatePath)>
    <cfheader statuscode="404" statustext="Not Found">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Template file not found.</div></cfoutput>
    <cfabort>
</cfif>

<!--- Load metadata so we know the field list (and types) before
     building the render-time `fields` struct. --->
<cfset template = {}>
<cfinclude template="org_signature_templates/#form.template_key#.cfm" />

<!--- Build the `fields` struct keyed by field.name. For checkboxes,
     a missing form key means unchecked = false. For string fields,
     fall back to default if form value is empty. Booleans are
     normalized so the template's <cfif fields.show_*> tests work. --->
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

<!--- Render. The template's <cfif IsDefined("renderTemplate") AND
     renderTemplate> block runs and emits HTML via cfoutput. --->
<cfset renderTemplate = true>
<cfsavecontent variable="renderedHtml"><cfinclude template="org_signature_templates/#form.template_key#.cfm" /></cfsavecontent>

<cfcontent type="text/html; charset=utf-8" reset="yes">
<cfoutput>#Trim(renderedHtml)#</cfoutput>
