<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER TEMPLATE: HIPAA / PHI (#235)

Healthcare Protected Health Information notice for HIPAA-covered
entities and business associates. Emphasizes federal protection
status, misdirected-message contact, and PHI destruction. ASCII-only
per Hermes Pro template convention.
--->

<cfscript>
template = {
    key:         "hipaa_phi",
    name:        "HIPAA / PHI Notice",
    description: "Healthcare Protected Health Information disclaimer for HIPAA-covered entities and business associates. Includes misdirected-message contact.",
    thumbnail:   "hipaa_phi.png",
    fields: [
        { name: "organization_name", label: "Organization Name", type: "text",     default: "",
          placeholder: "Acme Health Services",
          help: "Name of your healthcare organization or covered entity. Leave blank to omit." },
        { name: "body",              label: "Notice Body",       type: "textarea", default: "This electronic message may contain Protected Health Information (PHI) protected under the U.S. Health Insurance Portability and Accountability Act (HIPAA), 45 CFR Parts 160 and 164. The information is intended only for the use of the individual or entity named above. If you are not the intended recipient, any review, retransmission, dissemination, or other use of, or taking any action in reliance upon this information, is prohibited.",
          help: "Main body. One paragraph; line breaks not preserved." },

        { name: "show_misdirected_contact", label: "Show misdirected-message contact",  type: "checkbox", default: true,
          help: "Append a contact line for recipients who received PHI in error." },
        { name: "contact_phone",     label: "Contact Phone",     type: "text",     default: "",
          placeholder: "(555) 555-5555",
          showIf: "show_misdirected_contact" },
        { name: "contact_email",     label: "Contact Email",     type: "email",    default: "",
          placeholder: "privacy@example.com",
          showIf: "show_misdirected_contact" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;border-top:2px solid ##047857;margin:24px 0 0 0;">
<tr>
<td style="padding:12px 0 0 0;font-family:Arial,Helvetica,sans-serif;color:##444444;font-size:11px;line-height:1.6;">
<strong style="color:##047857;text-transform:uppercase;letter-spacing:0.5px;">Confidentiality Notice &mdash; HIPAA<cfif Len(Trim(fields.organization_name))> &mdash; #fields.organization_name#</cfif></strong><br>
#fields.body#
<cfif fields.show_misdirected_contact AND (Len(Trim(fields.contact_phone)) OR Len(Trim(fields.contact_email)))>
<br><br>
<span style="color:##333333;font-weight:bold;">If you received this in error:</span>&nbsp;contact us immediately at<cfif Len(Trim(fields.contact_phone))> #fields.contact_phone#</cfif><cfif Len(Trim(fields.contact_phone)) AND Len(Trim(fields.contact_email))> or</cfif><cfif Len(Trim(fields.contact_email))> <a href="mailto:#fields.contact_email#" style="color:##047857;text-decoration:none;">#fields.contact_email#</a></cfif>, then permanently destroy the original message and any copies.
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
