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
EXTERNAL BANNER TEMPLATE LOADER (#228)

Mirrors inc/org_signature_template_loader.cfm. Each template is a
self-contained .cfm file under inc/external_banner_templates/<key>.cfm
and operates in two modes via the `renderTemplate` flag:

  1. METADATA mode (default) - cfinclude with `renderTemplate` UNSET.
     The file's <cfif IsDefined("renderTemplate") AND renderTemplate>
     guard skips the HTML body and only the `template` struct is set.

  2. RENDER mode - cfinclude with `renderTemplate = true` plus a
     `fields` struct. The file emits table-based HTML using
     #fields.<name># substitutions, with `bgcolor=` HTML attributes
     alongside inline CSS for Outlook-friendly styling.

Public API after this include:

  variables.externalBannerTemplateRegistry
        Array of template_keys in canonical display order.

  variables.externalBannerTemplateDir
        Absolute path to the templates dir.

Templates use ASCII-only content (HTML entities for any typographic
chars or icons) so they don't trip the no-non-ASCII rule that applies
to fingerprinted Pro template files - even though banners are both-tier
and not fingerprinted, keeping the convention uniform reduces mental
overhead.
--->

<cfset variables.externalBannerTemplateRegistry = [
    "warning_yellow",
    "critical_red",
    "subtle_info",
    "plain_text"
]>

<!--- Anchor template dir to THIS file's own location so the loader can
     be cfincluded from any directory depth (saves time chasing the
     ExpandPath gotcha that bit org_signature_template_loader). --->
<cfset variables.externalBannerTemplateDir = getDirectoryFromPath(getCurrentTemplatePath()) & "external_banner_templates/">
