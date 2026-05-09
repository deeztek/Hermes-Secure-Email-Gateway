<!---
ORGANIZATIONAL SIGNATURE TEMPLATE: Banner with Logo (#226 Phase 2A)

Layout:
  ===========================================
  | [LOGO]                                  |  <- accent banner
  ===========================================
  Name (bold, larger)
  Title
  Phone | Email | Website
  Address (optional)
  [in] [tw] [gh]   (text-style social links)
  -------------------------------------------
  disclaimer (optional)

Full-width accent-colored banner row with logo at the top, then a
clean stacked contact block below. Logo-forward, dramatic.
--->

<cfscript>
template = {
    key:         "banner_with_logo",
    name:        "Banner with Logo",
    description: "Full-width accent-colored banner at the top with the logo, then a clean stacked contact block.",
    thumbnail:   "banner_with_logo.png",
    fields: [
        { name: "user_name", autoFill: true,      label: "Name",          type: "text",  default: "{{user.first_name}} {{user.last_name}}",
          placeholder: "Jane Smith" },
        { name: "user_title", autoFill: true,     label: "Title",         type: "text",  default: "{{user.title}}",
          placeholder: "Director of Engineering" },

        { name: "logo_url",       label: "Logo",          type: "image", default: "",
          help: "Upload a logo for the banner (PNG, JPG, GIF, or SVG, up to 1 MB). Banner renders as a solid accent color if blank." },
        { name: "logo_width",     label: "Logo width (px)", type: "text", default: "160",
          placeholder: "160",
          help: "Width in pixels. Outlook ignores max-width CSS so an explicit value is required. Banner height auto-fits." },

        { name: "accent_color",   label: "Accent color",  type: "color", default: "##d97706",
          help: "Banner background color, separator lines, and CTA button." },

        { name: "banner_height",  label: "Banner height", type: "text", default: "60",
          placeholder: "60",
          help: "Banner height in pixels. Common values: 50, 60, 80." },

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

        { name: "show_cta",       label: "Show call-to-action button", type: "checkbox", default: false },
        { name: "cta_label",      label: "CTA button text", type: "text", default: "Book a meeting",
          showIf: "show_cta" },
        { name: "cta_url",        label: "CTA button URL",  type: "url",  default: "",
          placeholder: "https://calendly.com/your-handle",
          showIf: "show_cta",
          help: "Must start with https:// or http://." },

        { name: "show_socials",   label: "Show social icons", type: "checkbox", default: true,
          help: "Leave any individual URL below blank to hide that platform's icon." },
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
<cfset bannerH = Val(fields.banner_height) GT 0 ? Val(fields.banner_height) : 60>
<cfoutput><div style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:##222;line-height:1.45;max-width:520px;">
<div style="background:#fields.accent_color#;height:#bannerH#px;padding:8px 16px;border-radius:4px 4px 0 0;display:flex;align-items:center;">
<cfif Len(Trim(fields.logo_url))>
<cfset bannerLogoW = Val(fields.logo_width) GT 0 ? Val(fields.logo_width) : 160>
<img src="#fields.logo_url#" alt="Logo" width="#bannerLogoW#" style="width:#bannerLogoW#px;height:auto;display:block;border:0;" />
</cfif>
</div>
<div style="padding:12px 4px 4px 4px;">
<div style="font-size:17px;font-weight:bold;color:##111;">#fields.user_name#</div>
<cfif Len(Trim(fields.user_title))>
<div style="color:##555;margin-bottom:6px;">#fields.user_title#</div>
</cfif>
<cfset contactBits = []>
<cfif fields.show_phone AND Len(Trim(fields.user_phone))><cfset ArrayAppend(contactBits, fields.user_phone)></cfif>
<cfif fields.show_email AND Len(Trim(fields.user_email))><cfset ArrayAppend(contactBits, '<a href="mailto:' & fields.user_email & '" style="color:##333;text-decoration:none;">' & fields.user_email & '</a>')></cfif>
<cfif fields.show_website AND Len(Trim(fields.org_website))>
    <cfset cleanWeb = Replace(Replace(fields.org_website, 'https://', '', 'one'), 'http://', '', 'one')>
    <cfset ArrayAppend(contactBits, '<a href="' & fields.org_website & '" style="color:##333;text-decoration:none;">' & cleanWeb & '</a>')>
</cfif>
<cfif ArrayLen(contactBits)>
<div style="margin:4px 0;">#ArrayToList(contactBits, ' &nbsp;<span style="color:' & fields.accent_color & ';">|</span>&nbsp; ')#</div>
</cfif>
<cfif fields.show_address AND Len(Trim(fields.org_address))>
<div style="color:##666;font-size:12px;margin:2px 0;">#fields.org_address#</div>
</cfif>
<cfif fields.show_cta AND Len(Trim(fields.cta_url)) AND Len(Trim(fields.cta_label))>
<div style="margin:8px 0;"><a href="#fields.cta_url#" style="display:inline-block;background:#fields.accent_color#;color:##ffffff;text-decoration:none;font-weight:bold;padding:7px 14px;border-radius:4px;font-size:12px;">#fields.cta_label#</a></div>
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
                <div style="margin-top:8px;">
            </cfif>
            <a href="#sp.url#" style="text-decoration:none;margin-right:6px;display:inline-block;"><img src="#iconUri#" alt="" width="20" height="20" style="vertical-align:middle;border:0;" /></a>
        </cfif>
    </cfif>
</cfloop>
<cfif NOT socialFirst></div></cfif>
</cfif>
<cfif fields.show_disclaimer AND Len(Trim(fields.disclaimer_text))>
<div style="margin-top:10px;padding-top:8px;border-top:1px solid ##eee;font-size:11px;color:##888;font-style:italic;">#fields.disclaimer_text#</div>
</cfif>
</div>
</div></cfoutput>
</cfif>
