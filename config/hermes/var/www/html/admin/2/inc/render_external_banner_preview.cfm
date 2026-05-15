<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition (AGPLv3).
--->

<!---
EXTERNAL BANNER PREVIEW RENDER (#228)

POST endpoint called by edit_external_banner.cfm's JS to preview the
selected template with the admin's current form values.

Mirrors render_org_signature_preview.cfm but for banners. No license
check (banners are both-tier).

Inputs (form scope):
    template_key                - canonical key of the template to render
    field_<name>                - one entry per template field

Output: raw HTML (rendered template body), no head/wrapper.
--->

<cfinclude template="../inc/setsession.cfm" />

<cfparam name="form.template_key" default="">

<cfinclude template="./external_banner_template_loader.cfm" />

<cfif NOT ArrayContains(variables.externalBannerTemplateRegistry, form.template_key)>
    <cfheader statuscode="400" statustext="Bad Request">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Unknown template: #HTMLEditFormat(form.template_key)#</div></cfoutput>
    <cfabort>
</cfif>

<cfset templatePath = variables.externalBannerTemplateDir & form.template_key & ".cfm">
<cfif NOT FileExists(templatePath)>
    <cfheader statuscode="404" statustext="Not Found">
    <cfoutput><div style="padding:20px;color:##b91c1c;">Template file not found.</div></cfoutput>
    <cfabort>
</cfif>

<cfset template = {}>
<cfinclude template="external_banner_templates/#form.template_key#.cfm" />

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
<cfsavecontent variable="renderedHtml"><cfinclude template="external_banner_templates/#form.template_key#.cfm" /></cfsavecontent>

<cfcontent type="text/html; charset=utf-8" reset="yes">
<cfoutput>#Trim(renderedHtml)#</cfoutput>
