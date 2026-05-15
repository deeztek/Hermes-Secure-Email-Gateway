<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition (AGPLv3).
--->

<!---
EXTERNAL BANNER TEMPLATE: Warning Yellow (#228)

Default banner. Yellow background with orange left border, dark text.
Industry-standard "external sender" warning style — same visual language
as Microsoft 365 transport rule banners, Mimecast, and most security
gateways.

Table-based layout for cross-mailclient compatibility. bgcolor= HTML
attribute is honored by Outlook even when CSS is stripped. Inline
styles are belt-and-suspenders for Gmail / Apple Mail / mobile.
--->

<cfscript>
template = {
    key:         "warning_yellow",
    name:        "Warning Yellow",
    description: "Yellow background with orange accent. Industry-standard external-sender warning. Default choice.",
    thumbnail:   "warning_yellow.png",
    fields: [
        { name: "prefix",   label: "Prefix",   type: "text", default: "[EXTERNAL]",
          help: "Short tag at the start of the banner. Bold-rendered. Plain ASCII recommended for Outlook compatibility." },
        { name: "headline", label: "Headline", type: "text", default: "This message originated from outside your organization.",
          help: "First line, regular weight." },
        { name: "body",     label: "Body",     type: "text", default: "Do not click links or open attachments unless you recognize the sender and were expecting this message.",
          help: "Second line, smaller text." },

        { name: "show_learn_more",  label: "Show learn-more link", type: "checkbox", default: false,
          help: "Optional link to internal phishing-awareness training or wiki." },
        { name: "learn_more_url",   label: "Learn-more URL",       type: "url",      default: "",
          placeholder: "https://wiki.example.com/phishing",
          showIf: "show_learn_more" },
        { name: "learn_more_label", label: "Learn-more label",     type: "text",     default: "Learn more about phishing",
          showIf: "show_learn_more" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;margin:0 0 12px 0;">
<tr>
<td bgcolor="##fff3cd" style="background:##fff3cd;padding:12px 16px;border-left:4px solid ##ffa500;font-family:Arial,Helvetica,sans-serif;color:##664d03;font-size:14px;line-height:1.5;">
<strong style="color:##664d03;">#fields.prefix#</strong> #fields.headline#<br>
<span style="color:##664d03;font-size:13px;">#fields.body#</span>
<cfif fields.show_learn_more AND Len(Trim(fields.learn_more_url)) AND Len(Trim(fields.learn_more_label))>
<br><a href="#fields.learn_more_url#" style="color:##664d03;font-weight:bold;text-decoration:underline;">#fields.learn_more_label#</a>
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
