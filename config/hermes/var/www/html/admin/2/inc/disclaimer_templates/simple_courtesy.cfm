<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
DISCLAIMER TEMPLATE: Simple Courtesy (#235)

Brief, low-visual-weight courtesy note. Optional environmental
"please consider before printing" line. Suitable for orgs that want
a soft footer without legal/regulatory language. ASCII-only per
Hermes Pro template convention.
--->

<cfscript>
template = {
    key:         "simple_courtesy",
    name:        "Simple Courtesy",
    description: "Brief, soft-tone footer. No legal language. Optional environmental note. Suitable when a full legal disclaimer is overkill.",
    thumbnail:   "simple_courtesy.png",
    icon:        "fas fa-handshake",
    fields: [
        { name: "message",                label: "Message",                   type: "textarea", default: "Thank you for your message.",
          help: "Short courtesy text. One or two lines max." },

        { name: "show_environmental",     label: "Show environmental note",   type: "checkbox", default: true,
          help: "Append the classic 'Please consider the environment before printing' line." },
        { name: "environmental_text",     label: "Environmental Note Text",   type: "text",     default: "Please consider the environment before printing this email.",
          showIf: "show_environmental" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;border-top:1px solid ##e5e7eb;margin:24px 0 0 0;">
<tr>
<td style="padding:12px 0 0 0;font-family:Arial,Helvetica,sans-serif;color:##777777;font-size:11px;line-height:1.5;font-style:italic;">
#fields.message#
<cfif fields.show_environmental AND Len(Trim(fields.environmental_text))>
<br><span style="color:##16a34a;">&##127807;</span>&nbsp;#fields.environmental_text#
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
