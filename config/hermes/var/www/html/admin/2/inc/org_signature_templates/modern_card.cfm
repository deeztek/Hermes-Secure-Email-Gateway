<!---
ORGANIZATIONAL SIGNATURE TEMPLATE: Modern Card (#226 Phase 2A)

Layout:
  +----------+  Name (bold, larger)
  |  LOGO    |  Title
  |          |  ---- accent bar ----
  +----------+  Phone | Mobile | Email | Website
                LinkedIn | Twitter | etc.

Two-column table; logo left, contact info right with a colored accent
bar separating name+title from contact fields. Table-based layout for
cross-mailclient compatibility (Outlook etc).

Placeholder strategy: defaults reference {{user.*}}/{{org.*}} which the
admin can replace with literal values OR keep as placeholders for the
milter to substitute at message time.
--->

<cfscript>
template = {
    key:         "modern_card",
    name:        "Modern Card",
    description: "Logo on the left, accent bar, contact details on the right. Clean and professional.",
    thumbnail:   "modern_card.png",
    fields: [
        { name: "user_name",      label: "Name",          type: "text",  default: "",
          placeholder: "Jane Smith" },
        { name: "user_title",     label: "Title",         type: "text",  default: "",
          placeholder: "Director of Engineering" },

        { name: "logo_url",       label: "Logo",          type: "image", default: "",
          help: "Upload a logo (PNG, JPG, GIF, or SVG, up to 1 MB). Leave blank to render without a logo." },

        { name: "accent_color",   label: "Accent color",  type: "color", default: "##d97706",
          help: "Pick from the brand palette or enter a custom hex code. Used for the divider, label colors, CTA button, and small accents." },

        { name: "show_phone",     label: "Show phone",    type: "checkbox", default: true },
        { name: "user_phone",     label: "Phone",         type: "text",  default: "",
          placeholder: "+1 (555) 123-4567",
          showIf: "show_phone" },

        { name: "show_mobile",    label: "Show mobile",   type: "checkbox", default: false },
        { name: "user_mobile",    label: "Mobile",        type: "text",  default: "",
          placeholder: "+1 (555) 987-6543",
          showIf: "show_mobile" },

        { name: "show_email",     label: "Show email",    type: "checkbox", default: true },
        { name: "user_email",     label: "Email",         type: "email", default: "",
          placeholder: "name@example.com",
          showIf: "show_email" },

        { name: "show_website",   label: "Show website",  type: "checkbox", default: true },
        { name: "org_website",    label: "Website",       type: "url",   default: "",
          placeholder: "https://www.example.com",
          showIf: "show_website" },

        { name: "show_address",   label: "Show address",  type: "checkbox", default: false },
        { name: "org_address",    label: "Address",       type: "text",  default: "",
          placeholder: "123 Main St, Suite 200, Springfield IL 62701",
          showIf: "show_address" },

        { name: "show_cta",       label: "Show call-to-action button", type: "checkbox", default: false,
          help: "Small accent-colored button above the social icons. Use for 'Book a meeting', a survey link, etc." },
        { name: "cta_label",      label: "CTA button text", type: "text", default: "Book a meeting",
          showIf: "show_cta" },
        { name: "cta_url",        label: "CTA button URL",  type: "url",  default: "",
          placeholder: "https://calendly.com/your-handle",
          showIf: "show_cta",
          help: "Where the button should link to (Calendly, Bookings, survey, etc.). Must start with https:// or http://." },

        { name: "show_socials",   label: "Show social icons", type: "checkbox", default: true,
          help: "Toggle the social icon row on/off. Leave any individual URL below blank to hide that platform's icon - only the platforms with a URL will appear in the signature." },
        { name: "linkedin_url",   label: "LinkedIn URL",  type: "url", default: "",
          placeholder: "https://www.linkedin.com/in/your-handle",
          showIf: "show_socials" },
        { name: "x_url",          label: "X (Twitter) URL", type: "url", default: "",
          placeholder: "https://x.com/your-handle",
          showIf: "show_socials" },
        { name: "github_url",     label: "GitHub URL",    type: "url", default: "",
          placeholder: "https://github.com/your-handle",
          showIf: "show_socials" },
        { name: "youtube_url",    label: "YouTube URL",   type: "url", default: "",
          placeholder: "https://youtube.com/@your-handle",
          showIf: "show_socials" },
        { name: "instagram_url",  label: "Instagram URL", type: "url", default: "",
          placeholder: "https://instagram.com/your-handle",
          showIf: "show_socials" },
        { name: "facebook_url",   label: "Facebook URL",  type: "url", default: "",
          placeholder: "https://facebook.com/your-handle",
          showIf: "show_socials" },

        { name: "show_disclaimer", label: "Show confidentiality line", type: "checkbox", default: false },
        { name: "disclaimer_text", label: "Confidentiality text",      type: "text",
          default: "This message and any attachments are confidential and intended solely for the addressee.",
          showIf: "show_disclaimer" }
    ]
};
</cfscript>

<cfif IsDefined("renderTemplate") AND renderTemplate>
<cfset hasLogo = Len(Trim(fields.logo_url)) GT 0>
<cfset rightPad = hasLogo ? "16px" : "0">
<cfoutput><table cellpadding="0" cellspacing="0" border="0" style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:##222;line-height:1.4;">
<tr>
<cfif hasLogo>
<td valign="top" style="padding:0 16px 0 0;border-right:3px solid #fields.accent_color#;">
<img src="#fields.logo_url#" alt="Logo" style="max-width:120px;height:auto;display:block;" />
</td>
</cfif>
<td valign="top" style="padding:0 0 0 #rightPad#;">
<div style="font-size:16px;font-weight:bold;color:##111;">#fields.user_name#</div>
<cfif Len(Trim(fields.user_title))>
<div style="color:##555;margin:2px 0 8px 0;">#fields.user_title#</div>
</cfif>
<div style="border-top:2px solid #fields.accent_color#;width:60px;margin:6px 0 8px 0;"></div>
<cfif fields.show_phone AND Len(Trim(fields.user_phone))>
<div><span style="color:#fields.accent_color#;font-weight:bold;">P:</span> #fields.user_phone#</div>
</cfif>
<cfif fields.show_mobile AND Len(Trim(fields.user_mobile))>
<div><span style="color:#fields.accent_color#;font-weight:bold;">M:</span> #fields.user_mobile#</div>
</cfif>
<cfif fields.show_email AND Len(Trim(fields.user_email))>
<div><span style="color:#fields.accent_color#;font-weight:bold;">E:</span> <a href="mailto:#fields.user_email#" style="color:##333;text-decoration:none;">#fields.user_email#</a></div>
</cfif>
<cfif fields.show_website AND Len(Trim(fields.org_website))>
<div><span style="color:#fields.accent_color#;font-weight:bold;">W:</span> <a href="#fields.org_website#" style="color:##333;text-decoration:none;">#fields.org_website#</a></div>
</cfif>
<cfif fields.show_address AND Len(Trim(fields.org_address))>
<div style="margin-top:4px;color:##555;">#fields.org_address#</div>
</cfif>
<cfif fields.show_cta AND Len(Trim(fields.cta_url)) AND Len(Trim(fields.cta_label))>
<div style="margin-top:10px;"><a href="#fields.cta_url#" style="display:inline-block;background:#fields.accent_color#;color:##ffffff;text-decoration:none;font-weight:bold;padding:6px 14px;border-radius:4px;font-size:12px;">#fields.cta_label#</a></div>
</cfif>
<cfif fields.show_socials>
<cfset socialPairs = [
    {slug: "linkedin",  url: fields.linkedin_url,  alt: "LinkedIn"},
    {slug: "x",         url: fields.x_url,         alt: "X"},
    {slug: "github",    url: fields.github_url,    alt: "GitHub"},
    {slug: "youtube",   url: fields.youtube_url,   alt: "YouTube"},
    {slug: "instagram", url: fields.instagram_url, alt: "Instagram"},
    {slug: "facebook",  url: fields.facebook_url,  alt: "Facebook"}
]>
<cfset socialFirst = true>
<cfloop array="#socialPairs#" index="sp">
    <cfif Len(Trim(sp.url))>
        <cfset iconUri = orgSignatureIconDataUri(sp.slug)>
        <cfif Len(iconUri)>
            <cfif socialFirst>
                <cfset socialFirst = false>
                <span style="display:inline-block;margin-top:8px;">
            </cfif>
            <a href="#sp.url#" style="text-decoration:none;margin-right:6px;display:inline-block;"><img src="#iconUri#" alt="#sp.alt#" width="20" height="20" style="vertical-align:middle;border:0;" /></a>
        </cfif>
    </cfif>
</cfloop>
<cfif NOT socialFirst></span></cfif>
</cfif>
</td>
</tr>
<cfif fields.show_disclaimer AND Len(Trim(fields.disclaimer_text))>
<tr>
<td colspan="2" style="padding-top:10px;border-top:1px solid ##eee;font-size:11px;color:##888;font-style:italic;">#fields.disclaimer_text#</td>
</tr>
</cfif>
</table></cfoutput>
</cfif>
