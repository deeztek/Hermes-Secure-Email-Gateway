<!---
ORGANIZATIONAL SIGNATURE TEMPLATE: Promo Footer (#226 Phase 2A)

Layout:
  Name (bold)
  Title
  Phone | Email | Website
  ---- accent line ----
  +-----------------------------------+
  |  [PROMO IMAGE]                    |  <- click-through image
  +-----------------------------------+
  socials inline (small)

Standard contact block on top, prominent promotional image with link
wrapper below. Use case: "New whitepaper", "Webinar this week", "Limited
sale" - any signature-as-marketing-asset scenario.
--->

<cfscript>
template = {
    key:         "promo_footer",
    name:        "Promo Footer",
    description: "Contact block on top, click-through promotional image below. Signature-as-marketing-asset.",
    thumbnail:   "promo_footer.png",
    fields: [
        { name: "user_name", autoFill: true,      label: "Name",          type: "text",  default: "{{user.first_name}} {{user.last_name}}",
          placeholder: "Jane Smith" },
        { name: "user_title", autoFill: true,     label: "Title",         type: "text",  default: "{{user.title}}",
          placeholder: "Director of Engineering" },

        { name: "accent_color",   label: "Accent color",  type: "color", default: "##d97706",
          help: "Used for the divider line, label colors, and CTA accents." },

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

        { name: "promo_image_url", label: "Promo image",  type: "image", default: "",
          help: "Upload the promotional image (PNG, JPG, GIF, up to 1 MB). This is the visual focus of the template - tall narrow banner images work best (e.g. 600x150)." },

        { name: "promo_link_url",  label: "Promo link URL", type: "url",  default: "",
          placeholder: "https://www.example.com/landing-page",
          help: "Where the promo image clicks through to. Must start with https:// or http://. Leave blank for a non-clickable image." },

        { name: "promo_alt",       label: "Promo image alt text", type: "text", default: "",
          placeholder: "Read our latest whitepaper",
          help: "Accessible alt text for the promo image. Some recipients see this if images are blocked." },

        { name: "show_socials",   label: "Show social icons", type: "checkbox", default: true,
          help: "Small social icons below the promo image. Leave any individual URL below blank to hide that platform's icon." },
        { name: "linkedin_url",   label: "LinkedIn URL",  type: "url", default: "", placeholder: "https://www.linkedin.com/in/your-handle", showIf: "show_socials" },
        { name: "x_url",          label: "X (Twitter) URL", type: "url", default: "", placeholder: "https://x.com/your-handle", showIf: "show_socials" },
        { name: "github_url",     label: "GitHub URL",    type: "url", default: "", placeholder: "https://github.com/your-handle", showIf: "show_socials" },
        { name: "youtube_url",    label: "YouTube URL",   type: "url", default: "", placeholder: "https://youtube.com/@your-handle", showIf: "show_socials" },
        { name: "instagram_url",  label: "Instagram URL", type: "url", default: "", placeholder: "https://instagram.com/your-handle", showIf: "show_socials" },
        { name: "facebook_url",   label: "Facebook URL",  type: "url", default: "", placeholder: "https://facebook.com/your-handle", showIf: "show_socials" },

        { name: "show_disclaimer", label: "Show confidentiality line", type: "checkbox", default: false },
        { name: "disclaimer_text", label: "Confidentiality text",      type: "text",
          default: "This message and any attachments are confidential and intended solely for the addressee.",
          showIf: "show_disclaimer" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfoutput><div style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:##222;line-height:1.45;max-width:520px;">
<div style="font-size:16px;font-weight:bold;color:##111;">#fields.user_name#</div>
<cfif Len(Trim(fields.user_title))>
<div style="color:##555;margin-bottom:4px;">#fields.user_title#</div>
</cfif>
<cfset contactBits = []>
<cfif fields.show_phone AND Len(Trim(fields.user_phone))><cfset ArrayAppend(contactBits, fields.user_phone)></cfif>
<cfif fields.show_email AND Len(Trim(fields.user_email))><cfset ArrayAppend(contactBits, '<a href="mailto:' & fields.user_email & '" style="color:##333;text-decoration:none;">' & fields.user_email & '</a>')></cfif>
<cfif fields.show_website AND Len(Trim(fields.org_website))>
    <cfset cleanWeb = Replace(Replace(fields.org_website, 'https://', '', 'one'), 'http://', '', 'one')>
    <cfset ArrayAppend(contactBits, '<a href="' & fields.org_website & '" style="color:##333;text-decoration:none;">' & cleanWeb & '</a>')>
</cfif>
<cfif ArrayLen(contactBits)>
<div style="margin:3px 0;">#ArrayToList(contactBits, ' &nbsp;<span style="color:' & fields.accent_color & ';">|</span>&nbsp; ')#</div>
</cfif>
<div style="border-top:2px solid #fields.accent_color#;margin:10px 0;width:100%;"></div>
<cfif Len(Trim(fields.promo_image_url))>
<cfset altText = Len(Trim(fields.promo_alt)) ? fields.promo_alt : "Promotion">
<div style="margin:8px 0;">
<cfif Len(Trim(fields.promo_link_url))>
<a href="#fields.promo_link_url#" style="text-decoration:none;display:block;"><img src="#fields.promo_image_url#" alt="#altText#" style="max-width:100%;height:auto;border:0;display:block;" /></a>
<cfelse>
<img src="#fields.promo_image_url#" alt="#altText#" style="max-width:100%;height:auto;border:0;display:block;" />
</cfif>
</div>
</cfif>
<cfif fields.show_socials>
<cfset socialPairs = [
    {slug: "linkedin",  url: fields.linkedin_url},
    {slug: "x",         url: fields.x_url},
    {slug: "github",    url: fields.github_url},
    {slug: "youtube",   url: fields.youtube_url},
    {slug: "instagram", url: fields.instagram_url},
    {slug: "facebook",  url: fields.facebook_url}
]>
<cfset socialFirst = true>
<cfloop array="#socialPairs#" index="sp">
    <cfif Len(Trim(sp.url))>
        <cfset iconUri = orgSignatureIconDataUri(sp.slug)>
        <cfif Len(iconUri)>
            <cfif socialFirst>
                <cfset socialFirst = false>
                <div style="margin-top:6px;">
            </cfif>
            <a href="#sp.url#" style="text-decoration:none;margin-right:6px;display:inline-block;"><img src="#iconUri#" alt="" width="18" height="18" style="vertical-align:middle;border:0;" /></a>
        </cfif>
    </cfif>
</cfloop>
<cfif NOT socialFirst></div></cfif>
</cfif>
<cfif fields.show_disclaimer AND Len(Trim(fields.disclaimer_text))>
<div style="margin-top:10px;padding-top:8px;border-top:1px solid ##eee;font-size:11px;color:##888;font-style:italic;">#fields.disclaimer_text#</div>
</cfif>
</div></cfoutput>
</cfif>
