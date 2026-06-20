<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition (AGPLv3).
--->

<!---
EXTERNAL BANNER TEMPLATE: Subtle Info (#228)

Light gray bar with blue accent. Less alarming than the yellow/red
variants. For organizations whose users have heavy inbound external
mail flows (e.g., support teams, sales) where aggressive banners would
cause "alert fatigue" and condition users to ignore them.
--->

<cfscript>
template = {
    key:         "subtle_info",
    name:        "Subtle Info",
    description: "Light gray with blue accent. Less alarming for high-volume inbound (support / sales) where alert fatigue is a concern.",
    thumbnail:   "subtle_info.png",
    fields: [
        { name: "prefix",   label: "Prefix",   type: "text", default: "[External]",
          help: "Short tag at the start of the banner." },
        { name: "headline", label: "Headline", type: "text", default: "This message is from outside your organization." },
        { name: "body",     label: "Body",     type: "text", default: "Verify unfamiliar senders before acting on links or attachments." },

        { name: "show_learn_more",  label: "Show learn-more link", type: "checkbox", default: false },
        { name: "learn_more_url",   label: "Learn-more URL",       type: "url",      default: "",
          placeholder: "https://wiki.example.com/phishing",
          showIf: "show_learn_more" },
        { name: "learn_more_label", label: "Learn-more label",     type: "text",     default: "More info",
          showIf: "show_learn_more" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;margin:0 0 12px 0;">
<tr>
<td bgcolor="##eef2f6" style="background:##eef2f6;padding:10px 14px;border-left:3px solid ##0d6efd;font-family:Arial,Helvetica,sans-serif;color:##334155;font-size:13px;line-height:1.45;">
<strong style="color:##0d6efd;">#fields.prefix#</strong> <span style="color:##334155;">#fields.headline#</span>
<cfif Len(Trim(fields.body))>
<br><span style="color:##64748b;font-size:12px;">#fields.body#</span>
</cfif>
<cfif fields.show_learn_more AND Len(Trim(fields.learn_more_url)) AND Len(Trim(fields.learn_more_label))>
<br><a href="#fields.learn_more_url#" style="color:##0d6efd;text-decoration:underline;font-size:12px;">#fields.learn_more_label#</a>
</cfif>
</td>
</tr>
</table></cfoutput>
</cfif>
