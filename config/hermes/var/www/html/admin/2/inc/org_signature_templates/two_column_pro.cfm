<!---
ORGANIZATIONAL SIGNATURE TEMPLATE: Two-Column Pro (#226 Phase 2A)

Layout:
  +-----------------+  +-----------------+
  |  Name (bold)    |  |  [LOGO]         |
  |  Title          |  |  Website        |
  |  Phone          |  |  Address        |
  |  Email          |  |  [CTA button]   |
  +-----------------+  +-----------------+
        socials inline below (optional)

Two equal columns separated by a vertical accent bar. Left = personal
contact, right = organization block. Heavier on visual weight than
Modern Card; suited to executive / sales signatures.
--->

<cfscript>
template = {
    key:         "two_column_pro",
    name:        "Two-Column Pro",
    description: "Personal contact on the left, organization block + CTA on the right. Polished, business-card style.",
    thumbnail:   "two_column_pro.png",
    fields: [
        { name: "user_name", autoFill: true,      label: "Name",          type: "text",  default: "{{user.first_name}} {{user.last_name}}",
          placeholder: "Jane Smith" },
        { name: "user_title", autoFill: true,     label: "Title",         type: "text",  default: "{{user.title}}",
          placeholder: "Director of Engineering" },

        { name: "logo_url",       label: "Logo",          type: "image", default: "",
          help: "Upload a logo (PNG, JPG, GIF, or SVG, up to 1 MB). Leave blank to render without a logo." },
        { name: "logo_width",     label: "Logo width (px)", type: "text", default: "140",
          placeholder: "140",
          help: "Width in pixels. Outlook ignores max-width CSS so an explicit value is required." },

        { name: "accent_color",   label: "Accent color",  type: "color", default: "##d97706",
          help: "Used for the divider, label colors, and CTA button." },

        { name: "show_phone",     label: "Show phone",    type: "checkbox", default: true },
        { name: "user_phone", autoFill: true,     label: "Phone",         type: "text",  default: "{{user.phone}}",
          placeholder: "+1 (555) 123-4567",
          showIf: "show_phone" },

        { name: "show_mobile",    label: "Show mobile",   type: "checkbox", default: false },
        { name: "user_mobile", autoFill: true,    label: "Mobile",        type: "text",  default: "{{user.mobile}}",
          placeholder: "+1 (555) 987-6543",
          showIf: "show_mobile" },

        { name: "show_email",     label: "Show email",    type: "checkbox", default: true },
        { name: "user_email", autoFill: true,     label: "Email",         type: "email", default: "{{user.email}}",
          placeholder: "name@example.com",
          showIf: "show_email" },

        { name: "show_website",   label: "Show website",  type: "checkbox", default: true },
        { name: "org_website", autoFill: true,    label: "Website",       type: "url",   default: "{{org.website}}",
          placeholder: "https://www.example.com",
          showIf: "show_website" },

        { name: "show_address",   label: "Show address",  type: "checkbox", default: true },
        { name: "org_address", autoFill: true,    label: "Address",       type: "text",  default: "{{org.address}}",
          placeholder: "123 Main St, Suite 200, Springfield IL 62701",
          showIf: "show_address" },

        { name: "show_cta",       label: "Show call-to-action button", type: "checkbox", default: true,
          help: "Prominent button under the organization block." },
        { name: "cta_label",      label: "CTA button text", type: "text", default: "Book a meeting",
          showIf: "show_cta" },
        { name: "cta_url",        label: "CTA button URL",  type: "url",  default: "",
          placeholder: "https://calendly.com/your-handle",
          showIf: "show_cta",
          help: "Must start with https:// or http://." },

        { name: "show_socials",   label: "Show social icons", type: "checkbox", default: true,
          help: "Toggle the social icon row on/off. Leave any individual URL below blank to hide that platform's icon." },
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
<cfoutput><table cellpadding="0" cellspacing="0" border="0" style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:##222;line-height:1.45;border-collapse:collapse;">
<tr>
<!--- LEFT COLUMN: personal contact --->
<td valign="top" style="padding:0 18px 0 0;border-right:2px solid #fields.accent_color#;min-width:200px;">
<div style="font-size:17px;font-weight:bold;color:##111;">#fields.user_name#</div>
<cfif Len(Trim(fields.user_title))>
<div style="color:##555;margin:2px 0 10px 0;">#fields.user_title#</div>
</cfif>
<cfif fields.show_phone AND Len(Trim(fields.user_phone))>
<div style="margin:3px 0;"><span style="color:#fields.accent_color#;font-weight:bold;">P</span> &nbsp;#fields.user_phone#</div>
</cfif>
<cfif fields.show_mobile AND Len(Trim(fields.user_mobile))>
<div style="margin:3px 0;"><span style="color:#fields.accent_color#;font-weight:bold;">M</span> &nbsp;#fields.user_mobile#</div>
</cfif>
<cfif fields.show_email AND Len(Trim(fields.user_email))>
<div style="margin:3px 0;"><span style="color:#fields.accent_color#;font-weight:bold;">E</span> &nbsp;<a href="mailto:#fields.user_email#" style="color:##333;text-decoration:none;">#fields.user_email#</a></div>
</cfif>
</td>

<!--- RIGHT COLUMN: organization block + CTA --->
<td valign="top" style="padding:0 0 0 18px;min-width:220px;">
<cfif Len(Trim(fields.logo_url))>
<cfset twoColLogoW = Val(fields.logo_width) GT 0 ? Val(fields.logo_width) : 140>
<div style="margin-bottom:8px;"><img src="#fields.logo_url#" alt="Logo" width="#twoColLogoW#" style="width:#twoColLogoW#px;height:auto;display:block;border:0;" /></div>
</cfif>
<cfif fields.show_website AND Len(Trim(fields.org_website))>
<div style="margin:3px 0;"><a href="#fields.org_website#" style="color:#fields.accent_color#;text-decoration:none;font-weight:bold;">#Replace(Replace(fields.org_website, 'https://', '', 'one'), 'http://', '', 'one')#</a></div>
</cfif>
<cfif fields.show_address AND Len(Trim(fields.org_address))>
<div style="margin:3px 0;color:##555;font-size:12px;">#fields.org_address#</div>
</cfif>
<cfif fields.show_cta AND Len(Trim(fields.cta_url)) AND Len(Trim(fields.cta_label))>
<div style="margin-top:10px;"><a href="#fields.cta_url#" style="display:inline-block;background:#fields.accent_color#;color:##ffffff;text-decoration:none;font-weight:bold;padding:8px 16px;border-radius:4px;font-size:12px;">#fields.cta_label# &raquo;</a></div>
</cfif>
</td>
</tr>
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
                <tr><td colspan="2" style="padding-top:10px;">
            </cfif>
            <a href="#sp.url#" style="text-decoration:none;margin-right:6px;display:inline-block;"><img src="#iconUri#" alt="" width="20" height="20" style="vertical-align:middle;border:0;" /></a>
        </cfif>
    </cfif>
</cfloop>
<cfif NOT socialFirst></td></tr></cfif>
</cfif>
<cfif fields.show_disclaimer AND Len(Trim(fields.disclaimer_text))>
<tr><td colspan="2" style="padding-top:10px;border-top:1px solid ##eee;font-size:11px;color:##888;font-style:italic;">#fields.disclaimer_text#</td></tr>
</cfif>
</table></cfoutput>
</cfif>
