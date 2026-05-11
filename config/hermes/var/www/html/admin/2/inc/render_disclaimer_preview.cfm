<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER PREVIEW RENDER (#235)

POST endpoint called by edit_disclaimer.cfm's JS to preview the
selected template with the admin's current form values.

Mirrors render_external_banner_preview.cfm.

Inputs (form scope):
    template_key                - canonical key of the template to render
    field_<name>                - one entry per template field

Output: raw HTML (rendered template body), no head/wrapper.
--->

<cfinclude template="../inc/setsession.cfm" />

<!--- Pro license check. Disclaimers are Pro-gated; preview should
     reject if the install is not running Pro. --->
<cfif NOT StructKeyExists(session, "edition") OR session.edition NEQ "Pro">
    <cfheader statuscode="403" statustext="Forbidden">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Disclaimers require the Pro edition.</div></cfoutput>
    <cfabort>
</cfif>

<cfparam name="form.template_key" default="">

<cfinclude template="./disclaimer_template_loader.cfm" />

<cfif NOT ArrayContains(variables.disclaimerTemplateRegistry, form.template_key)>
    <cfheader statuscode="400" statustext="Bad Request">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Unknown template: #HTMLEditFormat(form.template_key)#</div></cfoutput>
    <cfabort>
</cfif>

<cfset templatePath = variables.disclaimerTemplateDir & form.template_key & ".cfm">
<cfif NOT FileExists(templatePath)>
    <cfheader statuscode="404" statustext="Not Found">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Template file not found.</div></cfoutput>
    <cfabort>
</cfif>

<cfset template = {}>
<cfinclude template="disclaimer_templates/#form.template_key#.cfm" />

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

<cfset renderTemplate = true>
<cfsavecontent variable="renderedHtml"><cfinclude template="disclaimer_templates/#form.template_key#.cfm" /></cfsavecontent>

<cfcontent type="text/html; charset=utf-8" reset="yes">
<cfoutput>#Trim(renderedHtml)#</cfoutput>
