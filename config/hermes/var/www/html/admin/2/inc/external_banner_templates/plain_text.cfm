<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition (AGPLv3).
--->

<!---
EXTERNAL BANNER TEMPLATE: Plain Text (#228)

Minimal banner: no background, no border, no icon. Just a bold prefix
followed by the warning text. For organizations whose downstream MTAs
strip aggressive HTML or whose recipient base reads heavily on
text-only / minimal MUAs (Mutt, command-line clients).
--->

<cfscript>
template = {
    key:         "plain_text",
    name:        "Plain Text",
    description: "Minimal: bold prefix and text only, no background or border. Maximum cross-MUA compatibility, including text-only clients.",
    thumbnail:   "plain_text.png",
    fields: [
        { name: "prefix",   label: "Prefix",   type: "text", default: "[EXTERNAL]" },
        { name: "headline", label: "Headline", type: "text", default: "This message originated from outside your organization." },
        { name: "body",     label: "Body",     type: "text", default: "Do not click links or open attachments unless you recognize the sender." },

        { name: "show_learn_more",  label: "Show learn-more link", type: "checkbox", default: false },
        { name: "learn_more_url",   label: "Learn-more URL",       type: "url",      default: "",
          placeholder: "https://wiki.example.com/phishing",
          showIf: "show_learn_more" },
        { name: "learn_more_label", label: "Learn-more label",     type: "text",     default: "Learn more",
          showIf: "show_learn_more" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><div style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:##333;line-height:1.45;margin:0 0 12px 0;">
<strong>#fields.prefix#</strong> #fields.headline#
<cfif Len(Trim(fields.body))>
<br>#fields.body#
</cfif>
<cfif fields.show_learn_more AND Len(Trim(fields.learn_more_url)) AND Len(Trim(fields.learn_more_label))>
<br><a href="#fields.learn_more_url#" style="color:##0d6efd;text-decoration:underline;">#fields.learn_more_label#</a>
</cfif>
</div></cfoutput>
</cfif>
