<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER TEMPLATE: Legal Liability / Privileged (#235)

Law firms, professional services, regulated industries. Combines
attorney-client privilege language with an optional "not legal/financial
advice" caveat. ASCII-only per Hermes Pro template convention.
--->

<cfscript>
template = {
    key:         "legal_liability",
    name:        "Legal / Privileged Communication",
    description: "Law firm and professional-services style. Attorney-client privilege language plus optional 'not legal advice' caveat.",
    thumbnail:   "legal_liability.png",
    icon:        "fas fa-gavel",
    fields: [
        { name: "firm_name",         label: "Firm or Organization Name", type: "text",     default: "",
          placeholder: "Acme Law Group, LLP",
          help: "Appears in the privilege notice. Leave blank to omit." },
        { name: "privileged_body",   label: "Privilege Notice",          type: "textarea", default: "This electronic mail message and any attachments are confidential and may be subject to the attorney-client privilege or constitute non-public information. It is intended solely for the named recipient. If you are not the intended recipient, you are hereby notified that any review, dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this in error, contact the sender by reply and permanently delete the original.",
          help: "Privilege/confidentiality body." },

        { name: "show_not_advice",   label: "Show 'not legal advice' caveat", type: "checkbox", default: false,
          help: "Add a separate paragraph stating the message is not intended as legal advice unless explicitly stated." },
        { name: "not_advice_body",   label: "Not-Advice Caveat Text",     type: "textarea", default: "Nothing in this communication is intended to constitute legal, tax, or financial advice unless expressly stated. No attorney-client relationship is formed by the transmission or receipt of this message.",
          showIf: "show_not_advice" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;border-top:2px solid ##8b0000;margin:24px 0 0 0;">
<tr>
<td style="padding:12px 0 0 0;font-family:Georgia,'Times New Roman',serif;color:##444444;font-size:11px;line-height:1.6;">
<strong style="color:##8b0000;text-transform:uppercase;letter-spacing:0.5px;">Privileged &amp; Confidential<cfif Len(Trim(fields.firm_name))> &mdash; #fields.firm_name#</cfif></strong><br>
#fields.privileged_body#
<cfif fields.show_not_advice AND Len(Trim(fields.not_advice_body))>
<br><br><em style="color:##666666;">#fields.not_advice_body#</em>
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
