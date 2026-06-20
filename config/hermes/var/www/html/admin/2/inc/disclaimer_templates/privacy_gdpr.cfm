<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER TEMPLATE: Privacy / GDPR (#235)

Data-controller / GDPR / UK-GDPR style notice. Includes DPO contact +
privacy policy link. Suitable for any org processing personal data
of EU/UK data subjects, or any org that voluntarily adopts GDPR-style
notices. ASCII-only per Hermes Pro template convention.
--->

<cfscript>
template = {
    key:         "privacy_gdpr",
    name:        "Privacy / GDPR Notice",
    description: "GDPR / UK GDPR data-protection notice. Includes Data Controller contact, optional DPO email, and privacy policy link.",
    thumbnail:   "privacy_gdpr.png",
    icon:        "fas fa-user-shield",
    fields: [
        { name: "controller_name",   label: "Data Controller Name",   type: "text",     default: "",
          placeholder: "Acme Corporation Limited",
          help: "Legal name of the data controller (your organization)." },
        { name: "body",              label: "Notice Body",            type: "textarea", default: "This communication and any personal data it contains are processed in accordance with our Privacy Policy and applicable data-protection law (including the EU GDPR and UK GDPR where relevant). You have the right to access, rectify, restrict, or object to processing of your personal data, and the right to lodge a complaint with a supervisory authority.",
          help: "Main body. One paragraph; line breaks not preserved." },

        { name: "show_dpo",          label: "Show DPO contact",       type: "checkbox", default: false,
          help: "If checked, includes a 'Data Protection Officer:' line with email." },
        { name: "dpo_email",         label: "DPO Email",              type: "email",    default: "",
          placeholder: "dpo@example.com",
          showIf: "show_dpo" },

        { name: "show_policy",       label: "Show privacy policy link", type: "checkbox", default: true,
          help: "Append a link to your published privacy policy." },
        { name: "policy_url",        label: "Privacy Policy URL",     type: "url",      default: "",
          placeholder: "https://example.com/privacy",
          showIf: "show_policy" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;border-top:1px solid ##2563eb;margin:24px 0 0 0;">
<tr>
<td style="padding:12px 0 0 0;font-family:Arial,Helvetica,sans-serif;color:##555555;font-size:11px;line-height:1.6;">
<strong style="color:##2563eb;">DATA PROTECTION NOTICE<cfif Len(Trim(fields.controller_name))> &mdash; #fields.controller_name#</cfif></strong><br>
#fields.body#
<cfif (fields.show_dpo AND Len(Trim(fields.dpo_email))) OR (fields.show_policy AND Len(Trim(fields.policy_url)))>
<br><br>
<cfif fields.show_dpo AND Len(Trim(fields.dpo_email))>
Data Protection Officer:&nbsp;<a href="mailto:#fields.dpo_email#" style="color:##2563eb;text-decoration:none;">#fields.dpo_email#</a><cfif fields.show_policy AND Len(Trim(fields.policy_url))>&nbsp;&middot;&nbsp;</cfif>
</cfif>
<cfif fields.show_policy AND Len(Trim(fields.policy_url))>
<a href="#fields.policy_url#" style="color:##2563eb;text-decoration:none;">Privacy Policy</a>
</cfif>
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
