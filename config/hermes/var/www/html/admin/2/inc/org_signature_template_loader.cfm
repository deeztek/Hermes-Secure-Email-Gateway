<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
ORGANIZATIONAL SIGNATURE TEMPLATE LOADER (#226 Phase 2A)

Lightweight registry helper. Each template is a self-contained .cfm
file under inc/org_signature_templates/<key>.cfm and operates in two
modes via the `renderTemplate` flag:

  1. METADATA mode (default) - cfinclude with `renderTemplate` UNSET.
     The file's <cfif IsDefined("renderTemplate") AND renderTemplate>
     guard skips the HTML body and only the `template` struct is set.

  2. RENDER mode - cfinclude with `renderTemplate = true` plus a
     `fields` struct. The file emits HTML with #fields.<name>#
     substitutions and <cfif fields.show_*> blocks.

This file does NOT wrap include in functions because cfinclude inside
a cfscript function has scope-propagation edge cases on Lucee. Callers
do raw cfincludes; this loader just exposes the canonical registry
list and a couple of small helpers that don't include templates
themselves.

Public API after this include:

  variables.orgSignatureTemplateRegistry
        Array of template_keys in canonical display order. Files
        outside the registry are ignored even if present on disk.

  variables.orgSignatureTemplateDir
        Absolute path to the templates dir, useful for FileExists()
        guards before <cfinclude>.

Typical caller pattern:

    <cfinclude template="inc/org_signature_template_loader.cfm">
    <cfloop array="#variables.orgSignatureTemplateRegistry#" index="key">
        <cfset templatePath = variables.orgSignatureTemplateDir & key & ".cfm">
        <cfif FileExists(templatePath)>
            <cfset template = {}>  <!--- reset before each load --->
            <cfinclude template="inc/org_signature_templates/#key#.cfm">
            <!--- template struct now populated, render it as a gallery card --->
        </cfif>
    </cfloop>

To render a template:

    <cfset renderTemplate = true>
    <cfset fields = { user_name: "Alice", show_phone: true, ... }>
    <cfinclude template="inc/org_signature_templates/modern_card.cfm">
--->

<cfset variables.orgSignatureTemplateRegistry = [
    "modern_card",
    "two_column_pro",
    "with_social_bar",
    "banner_with_logo",
    "promo_footer",
    "compact_text"
]>

<!--- Anchor template dir to THIS file's own location so the loader can
     be cfincluded from any directory depth. ExpandPath("./...") would
     resolve relative to the request URL's directory, breaking when
     callers like render_org_signature_preview.cfm or
     save_org_signature_action.cfm (both under /admin/2/inc/) include
     the loader - they'd land on /admin/2/inc/inc/... --->
<cfset variables.orgSignatureTemplateDir = getDirectoryFromPath(getCurrentTemplatePath()) & "org_signature_templates/">

<!---
Social icon helper - shared across all templates.

Reads the brand-colored 24x24 PNG bundled under
/users/2/inc/social_icons/<slug>.png (committed in #226 Phase 1.5)
and returns it as a data: URI suitable for inline <img src="...">.

Returns "" if the slug is unknown so the template render can simply
do <cfif Len(uri)> to skip missing icons. The Phase 2B milter is
expected to extract these data: URIs to cid: refs at message-render
time, mirroring the user-portal signature pipeline in
users/2/inc/signature_write_and_reload.cfm.

Cached in request scope so repeated calls inside one render don't
re-read the same file.
--->
<cffunction name="orgSignatureIconDataUri" returntype="string" output="false">
    <cfargument name="slug" type="string" required="true">
    <cfset var cleanSlug = ReReplaceNoCase(arguments.slug, "[^a-z0-9_]", "", "all")>
    <cfif NOT Len(cleanSlug)>
        <cfreturn "">
    </cfif>
    <cfif NOT StructKeyExists(request, "orgSignatureIconCache")>
        <cfset request.orgSignatureIconCache = {}>
    </cfif>
    <cfif StructKeyExists(request.orgSignatureIconCache, cleanSlug)>
        <cfreturn request.orgSignatureIconCache[cleanSlug]>
    </cfif>
    <cfset var iconPath = ExpandPath("/users/2/inc/social_icons/" & cleanSlug & ".png")>
    <cfif NOT FileExists(iconPath)>
        <cfset request.orgSignatureIconCache[cleanSlug] = "">
        <cfreturn "">
    </cfif>
    <cfset var binData = "">
    <cffile action="readBinary" file="#iconPath#" variable="binData">
    <cfset var uri = "data:image/png;base64," & ToBase64(binData)>
    <cfset request.orgSignatureIconCache[cleanSlug] = uri>
    <cfreturn uri>
</cffunction>
