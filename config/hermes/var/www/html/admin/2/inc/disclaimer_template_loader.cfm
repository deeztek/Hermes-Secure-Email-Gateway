<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER TEMPLATE LOADER (#235)

Mirrors inc/external_banner_template_loader.cfm and inc/org_signature_template_loader.cfm.
Each template is a self-contained .cfm file under
inc/disclaimer_templates/<key>.cfm and operates in two modes via the
`renderTemplate` flag:

  1. METADATA mode (default) - cfinclude with `renderTemplate` UNSET.
     The file's <cfif IsDefined("renderTemplate") AND renderTemplate>
     guard skips the HTML body and only the `template` struct is set.

  2. RENDER mode - cfinclude with `renderTemplate = true` plus a
     `fields` struct. The file emits table-based HTML using
     #fields.<name># substitutions, with `bgcolor=` HTML attributes
     alongside inline CSS for Outlook-friendly styling.

Public API after this include:

  variables.disclaimerTemplateRegistry
        Array of template_keys in canonical display order.

  variables.disclaimerTemplateDir
        Absolute path to the templates dir.

Templates use ASCII-only content (HTML entities for any typographic
chars or icons) per Hermes Pro template convention. The disclaimer
feature is Pro-gated and the template files may be fingerprinted in
future builds.
--->

<cfset variables.disclaimerTemplateRegistry = [
    "confidentiality_standard",
    "legal_liability",
    "privacy_gdpr",
    "hipaa_phi",
    "simple_courtesy"
]>

<!--- Anchor template dir to THIS file's own location so the loader can
     be cfincluded from any directory depth (same defensive pattern as
     external_banner_template_loader). --->
<cfset variables.disclaimerTemplateDir = getDirectoryFromPath(getCurrentTemplatePath()) & "disclaimer_templates/">
