<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER TEMPLATE: Confidentiality Standard (#235)

Generic catch-all confidentiality notice. Most-common variant in
corporate email (financial services, consulting, professional services).
Industry-standard "if received in error, notify sender and delete"
language. ASCII-only content per Hermes Pro template convention.
--->

<cfscript>
template = {
    key:         "confidentiality_standard",
    name:        "Confidentiality (Standard)",
    description: "Generic confidentiality notice. Most-common corporate variant. Includes optional contact for misdirected messages.",
    thumbnail:   "confidentiality_standard.png",
    icon:        "fas fa-lock",
    fields: [
        { name: "heading",         label: "Heading",          type: "text",     default: "CONFIDENTIALITY NOTICE",
          help: "Short emphasized prefix. Plain ASCII recommended." },
        { name: "body",            label: "Body Text",        type: "textarea", default: "This email and any attachments are confidential and intended solely for the addressee. If you have received this message in error, please notify the sender immediately and permanently delete the original. Any unauthorized review, use, disclosure, or distribution of this message is prohibited.",
          help: "Main body of the notice. One paragraph; line breaks not preserved." },

        { name: "show_contact",    label: "Show contact email",  type: "checkbox", default: false,
          help: "If checked, appends a 'For questions, contact:' line." },
        { name: "contact_email",   label: "Contact email",       type: "email",    default: "",
          placeholder: "privacy@example.com",
          showIf: "show_contact" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;border-top:1px solid ##cccccc;margin:24px 0 0 0;">
<tr>
<td style="padding:12px 0 0 0;font-family:Arial,Helvetica,sans-serif;color:##666666;font-size:11px;line-height:1.5;">
<strong style="color:##333333;">#fields.heading#</strong>&nbsp;&mdash;&nbsp;#fields.body#
<cfif fields.show_contact AND Len(Trim(fields.contact_email))>
<br><span style="color:##666666;">For questions, contact:&nbsp;<a href="mailto:#fields.contact_email#" style="color:##0d6efd;text-decoration:none;">#fields.contact_email#</a></span>
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
