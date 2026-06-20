<!---
ORGANIZATIONAL SIGNATURE TEMPLATE: Compact Text (#226 Phase 2A)

Layout:
  Name | Title
  Phone | Email | Website
  Address (optional)
  --
  disclaimer (optional)

Plain text-only, monospace-friendly, no images, no colors. Right
choice for high-volume operational accounts (no-reply, alerts, system
mail) where image attachments are unnecessary overhead and recipients
just want the data. Tiny footprint = friendlier to mailbox quotas.
--->

<cfscript>
template = {
    key:         "compact_text",
    name:        "Compact Text",
    description: "Minimal plain-text signature. No images, no colors. Best for operational / no-reply / system mail accounts.",
    thumbnail:   "compact_text.png",
    fields: [
        { name: "user_name", autoFill: true,      label: "Name",          type: "text",  default: "{{user.first_name}} {{user.last_name}}",
          placeholder: "Jane Smith" },
        { name: "user_title", autoFill: true,     label: "Title",         type: "text",  default: "{{user.title}}",
          placeholder: "Director of Engineering" },

        { name: "show_phone",     label: "Show phone",    type: "checkbox", default: true },
        { name: "user_phone", autoFill: true,     label: "Phone",         type: "text",  default: "{{user.phone}}",
          placeholder: "+1 (555) 123-4567",
          showIf: "show_phone" },

        { name: "show_email",     label: "Show email",    type: "checkbox", default: true },
        { name: "user_email", autoFill: true,     label: "Email",         type: "email", default: "{{user.email}}",
          placeholder: "name@example.com",
          showIf: "show_email" },

        { name: "show_website",   label: "Show website",  type: "checkbox", default: true },
        { name: "org_website", autoFill: true,    label: "Website",       type: "url",   default: "{{org.website}}",
          placeholder: "https://www.example.com",
          showIf: "show_website" },

        { name: "show_address",   label: "Show address",  type: "checkbox", default: false },
        { name: "org_address", autoFill: true,    label: "Address",       type: "text",  default: "{{org.address}}",
          placeholder: "123 Main St, Suite 200, Springfield IL 62701",
          showIf: "show_address" },

        { name: "show_disclaimer", label: "Show confidentiality line", type: "checkbox", default: false },
        { name: "disclaimer_text", label: "Confidentiality text",      type: "text",
          default: "This message and any attachments are confidential and intended solely for the addressee.",
          showIf: "show_disclaimer" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><div style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:##333;line-height:1.45;">
<cfset firstLineBits = []>
<cfif Len(Trim(fields.user_name))><cfset ArrayAppend(firstLineBits, '<strong>' & fields.user_name & '</strong>')></cfif>
<cfif Len(Trim(fields.user_title))><cfset ArrayAppend(firstLineBits, fields.user_title)></cfif>
<cfif ArrayLen(firstLineBits)>
<div>#ArrayToList(firstLineBits, ' | ')#</div>
</cfif>
<cfset contactBits = []>
<cfif fields.show_phone AND Len(Trim(fields.user_phone))><cfset ArrayAppend(contactBits, fields.user_phone)></cfif>
<cfif fields.show_email AND Len(Trim(fields.user_email))><cfset ArrayAppend(contactBits, '<a href="mailto:' & fields.user_email & '" style="color:##333;text-decoration:underline;">' & fields.user_email & '</a>')></cfif>
<cfif fields.show_website AND Len(Trim(fields.org_website))>
    <cfset cleanWeb = Replace(Replace(fields.org_website, 'https://', '', 'one'), 'http://', '', 'one')>
    <cfset ArrayAppend(contactBits, '<a href="' & fields.org_website & '" style="color:##333;text-decoration:underline;">' & cleanWeb & '</a>')>
</cfif>
<cfif ArrayLen(contactBits)>
<div>#ArrayToList(contactBits, ' | ')#</div>
</cfif>
<cfif fields.show_address AND Len(Trim(fields.org_address))>
<div>#fields.org_address#</div>
</cfif>
<cfif fields.show_disclaimer AND Len(Trim(fields.disclaimer_text))>
<div style="margin-top:6px;font-size:11px;color:##777;font-style:italic;">--<br>#fields.disclaimer_text#</div>
</cfif>
</div></cfoutput>
</cfif>
