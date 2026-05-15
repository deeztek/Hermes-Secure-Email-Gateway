<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition (AGPLv3).
--->

<!---
EXTERNAL BANNER TEMPLATE: Critical Red (#228)

Higher-severity variant. Red background, white text. For high-risk
deployments (financial services, healthcare with PHI, government) where
the standard yellow warning isn't aggressive enough to cut through user
banner-blindness.
--->

<cfscript>
template = {
    key:         "critical_red",
    name:        "Critical Red",
    description: "Red background, white text. High-severity variant for phishing-prone industries or post-incident periods.",
    thumbnail:   "critical_red.png",
    fields: [
        { name: "prefix",   label: "Prefix",   type: "text", default: "[EXTERNAL]",
          help: "Short tag at the start of the banner." },
        { name: "headline", label: "Headline", type: "text", default: "CAUTION: This message originated outside your organization." },
        { name: "body",     label: "Body",     type: "text", default: "Verify the sender and content before clicking any links, opening attachments, or replying with sensitive information." },

        { name: "show_learn_more",  label: "Show learn-more link", type: "checkbox", default: false },
        { name: "learn_more_url",   label: "Learn-more URL",       type: "url",      default: "",
          placeholder: "https://wiki.example.com/phishing",
          showIf: "show_learn_more" },
        { name: "learn_more_label", label: "Learn-more label",     type: "text",     default: "Phishing awareness",
          showIf: "show_learn_more" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;margin:0 0 12px 0;">
<tr>
<td bgcolor="##b71c1c" style="background:##b71c1c;padding:12px 16px;border-left:4px solid ##7f0000;font-family:Arial,Helvetica,sans-serif;color:##ffffff;font-size:14px;line-height:1.5;">
<strong style="color:##ffffff;">#fields.prefix#</strong> #fields.headline#<br>
<span style="color:##ffffff;font-size:13px;">#fields.body#</span>
<cfif fields.show_learn_more AND Len(Trim(fields.learn_more_url)) AND Len(Trim(fields.learn_more_label))>
<br><a href="#fields.learn_more_url#" style="color:##ffe082;font-weight:bold;text-decoration:underline;">#fields.learn_more_label#</a>
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
