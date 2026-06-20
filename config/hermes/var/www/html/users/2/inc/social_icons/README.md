# Social Icons

Brand-colored 24x24 PNG icons consumed by the Personal Signature template
gallery (`view_signature.cfm`). At template-pick time the editor fetches each
PNG, base64-encodes it client-side, and substitutes `{{ICON:name}}` placeholders
in template HTML with the resulting `data:` URLs. The existing cid: extraction
in `inc/signature_write_and_reload.cfm` then turns each into a real
`multipart/related` image attachment in delivered mail.

## Regenerating

Run `scripts/generate_social_icons.sh` from the repo root. Requires
`rsvg-convert` (librsvg) or ImageMagick `convert`. The script downloads the
SVGs from Simple Icons (MIT) for brand glyphs and Bootstrap Icons (MIT) for
generic glyphs (globe, envelope), then renders to 24x24 PNG.

## Adding a new icon

Edit `scripts/generate_social_icons.sh`:

- Brand icon: append to `ICONS=(...)` as `slug:hex_color` where `slug` matches
  the Simple Icons file name (search https://simpleicons.org/) and the color
  is the brand hex without `#`.
- Generic glyph: append to `BS_ICONS=(...)` similarly. The slug must match a
  Bootstrap Icons file name (https://icons.getbootstrap.com/).

Re-run the script. Templates can then reference the new icon as
`<img src="{{ICON:slug}}" alt="...">` in `view_signature.cfm`.

## Licensing

- Simple Icons: MIT, https://github.com/simple-icons/simple-icons
- Bootstrap Icons: MIT, https://github.com/twbs/icons

Brand icons are trademarks of their respective owners. Use must comply with
each platform's brand guidelines (e.g., LinkedIn, X, GitHub all publish them).
