# Personal Signature

This page lets you create the signature that gets added to the bottom of every email you send through Hermes.

## The short version

A personal signature is the little block at the end of a message that tells the recipient who you are — usually your name, your title, your contact details, sometimes a logo, sometimes a link or two. On this page you build that signature once, click Save, and from then on Hermes appends it to every message you send out through the system. You don't have to copy and paste it into each new message.

The editor lets you do the things you'd expect: type and format text, change colors, add bullet lists, insert images and tables, drop in links. There's a small gallery of starter templates so you don't have to build something from scratch unless you want to, and there's a Preview button so you can see what the signature will look like below an actual message before you save it.

You can turn the signature off at any time with a single toggle at the top of the page — your saved signature stays put, it just stops being appended to your outbound mail until you turn it back on.

## What the page shows

There's one card on the page, titled **Personal Signature**. From top to bottom it has:

- An **Append my personal signature to outbound messages** toggle. This is the master switch. When it's off, nothing else on the page matters — no signature gets added to your mail.
- A **Start from a template** dropdown with five curated layouts you can load with one click.
- The **editor itself** — a what-you-see-is-what-you-get area where you type and format your signature, with a toolbar across the top for bold, italics, headings, colors, lists, alignment, links, and image upload.
- **Insert table** buttons (2×2, 2×3, 3×3, 3×4) for adding a simple table layout below the editor.
- An **image Width** strip with preset buttons (100 px, 150 px, 200 px, 300 px), a custom-pixel input, and a Reset button.
- A help note listing the image format and size limits.
- A **Preview** button and a **Save Signature** button along the bottom.

If your administrator has turned off user-managed signatures for your domain, you'll see a grey **Personal Signatures Disabled** notice instead of the editor, and the Personal Signature item is also hidden from the sidebar. See "What this page does NOT do" below for what that means.

## Creating your first signature

The fastest way to get a working signature is to start from a template and edit the placeholder text. Here's the flow:

1. Pick a template from the **Start from a template** dropdown. The editor fills with that template's layout.
2. Edit the placeholder text — replace *Your Name*, *Your Title*, the example email address and phone number, the example URL, and so on, with your own information.
3. Adjust the formatting if you want — make a line bold, change a color, add a bullet list, insert an extra paragraph.
4. If the template includes a logo placeholder line, click the image icon in the toolbar to upload your actual logo, then click the inserted image and pick a width from the Width buttons below the editor.
5. Click **Preview** to see how the signature will look at the bottom of a sample message. Adjust if needed.
6. Click **Save Signature**.

You should see a green confirmation banner. From that point on, every new message you send through Hermes gets the signature appended at the bottom.

## Editing an existing signature

Open the page and your saved signature appears in the editor automatically. Change whatever you want and click **Save Signature** again. The new version replaces the old one immediately — the next message you send uses the updated signature.

To start completely over, pick a different template from the dropdown — it'll ask you to confirm before overwriting your current content, then loads the new template. You can also clear the editor by selecting all the text (Ctrl-A or Cmd-A) and pressing Delete.

To temporarily turn the signature off without losing it, untick **Append my personal signature to outbound messages** at the top of the card and click Save. Your signature stays saved; it just isn't appended to mail until you tick the toggle again.

## Adding images

Click the image icon in the editor toolbar to upload an image from your computer. The image is embedded directly in your signature and appears inline in outbound mail — the recipient sees it next to your text, not as a separate attachment.

There are a few limits to know about:

- **10 images maximum** per signature.
- **200 KB per image** (resize a large photo or logo before uploading).
- **1 MB total** across all images in your signature.
- **PNG, JPEG, and GIF only.** SVG and WebP aren't supported because not every mail client renders them reliably.

After inserting an image, **click it in the editor** to select it (it gets a thick blue ring and a "checkmark" badge to confirm it's selected), then pick a width from the **Width** buttons or type a custom pixel value into the input and click Apply. **Reset** clears the width and lets the image use its natural size. The width sticks to that image — if you have two logos at different sizes, click and resize each one separately.

If you skip the size limit, the save will fail with an explanation of which limit was hit. Just resize the image (or remove one) and try again.

## Using the templates

There are five starter templates in the dropdown. Each one drops a different layout into the editor, with example text you replace with your own:

- **Minimal — name + contact only.** Your name, title, email, phone. No frills, fits in three or four lines.
- **With logo placeholder.** Same as Minimal, plus a note at the top reminding you to upload your logo using the toolbar image button. Adds organization, web address.
- **With Schedule-a-Meeting link.** Compact contact block with a "Book time on my calendar" link suitable for Calendly, Outlook Bookings, or similar.
- **With social media icons.** Contact details plus a row of small (24-pixel) brand-colored icons for LinkedIn, X, GitHub, Instagram, Facebook, and a website link. Just edit the URLs.
- **Comprehensive — logo + contact + meeting + social.** Everything: logo placeholder, name and title, multiple phone numbers, address, scheduling link, and the row of social icons. Use this if you want the works and then trim what you don't need.

Picking a template replaces whatever is currently in the editor. If the editor already has content, you'll be asked to confirm before it gets overwritten.

The templates use generic placeholder text like *Your Name* and *you@domain.tld* on purpose. Replace it manually with your own information before saving.

## Adjusting image width

Hermes uses a click-then-pick model for resizing images, instead of drag handles. After inserting an image:

1. Click the image in the editor. A blue ring appears around it confirming it's selected, and the status line above the Width buttons updates to *"Image selected (current width: ...)"*.
2. Click one of the preset width buttons: **100 px**, **150 px**, **200 px**, or **300 px**.
3. Or type a custom width (between 10 and 2000 pixels) into the input box and click **Apply**.
4. Click **Reset** to remove the size override and let the image use its natural dimensions.

A few sensible widths to start with: **100 px** for small social icons, **150–200 px** for a typical organization logo, **300 px** for a wider banner image. If you're not sure, save it, send a test message to yourself, and adjust.

## Preview before sending

Click the **Preview** button (next to Save Signature) to see what your signature will look like in an actual email. A preview panel appears below the editor showing a short sample message body with your signature attached underneath, separated by a thin grey line — roughly the way it'll look when a recipient opens your mail.

The Preview is an approximation. Different mail clients (Gmail, Outlook, Apple Mail, Thunderbird) each render HTML slightly differently, so the exact appearance can vary. If exact fidelity matters, send a test message to yourself or to a colleague and check it in the actual mail app they use.

Click the X in the corner of the preview panel to close it.

## What this page does NOT do

A few honest limitations worth knowing about up front:

- **It only applies to mail you send through Hermes.** That means mail sent via Webmail in this portal, or via a mail app on your phone or computer that's set up to send through the Hermes mail server. If you also use a different mail provider for some of your mail — a personal Gmail, your old work account on another system — the signature on this page does not apply there.
- **The signature gets appended after your message body** — it isn't inserted as you compose. So when you're writing in Webmail or a desktop mail client, you'll see the message body without the signature. Hermes adds the signature at the moment the message leaves the mail server. The recipient sees it at the bottom of the mail; you won't see it in your Sent folder unless your mail client also fetches the delivered copy.
- **It applies to every outbound message** — new mail and replies alike. There's no option to add it only to new mail and skip replies.
- **It doesn't override an organizational signature your administrator may have set.** If your organization has a centrally-managed signature with the company logo, address, and disclaimer, that one is added by the mail server too — your personal signature appears on top of it, not instead of it. If you only want the organizational signature, just untick the **Append my personal signature** toggle and save.
- **Some advanced HTML doesn't survive the editor.** The editor is a rich-text editor, not a raw HTML tool — pasted code with custom CSS, styled buttons, or complex table layouts will be simplified to what the editor supports. If you need a precisely designed signature, work within the editor rather than pasting in something built elsewhere.

## Common scenarios

**Setting up your first signature.**
Pick **Minimal** or **With logo placeholder** from the template dropdown. Replace the placeholder text with your real name, title, email, and phone. If you picked the logo template, click the image icon in the toolbar, upload your organization's logo, click it, and pick **150 px** or **200 px** for the width. Click Preview. If it looks right, click Save Signature.

**Adding a company logo to a signature you already have.**
Click in the editor where you want the logo to go (usually at the top, on its own line). Click the image icon in the toolbar and upload the logo file. Click the inserted image to select it, then pick a width — 150 px is a safe starting point. Click Save Signature.

**Switching to a different template without losing your contact info.**
Picking a template overwrites everything in the editor, so before you switch, copy the lines you want to keep (highlight, Ctrl-C or Cmd-C). Pick the new template, then paste your saved lines into the appropriate place and delete the template's placeholder versions. Save.

**Using one signature on your phone and your computer.**
This page's signature is added by the Hermes mail server when your message goes out, so it shows up regardless of whether you sent the message from Webmail, from Apple Mail on your phone, or from Outlook on your laptop — as long as you're sending through Hermes. You don't need to configure a separate signature in each app. In fact, if you've previously set up signatures inside your phone's Mail app or your desktop client, you should delete those, or you'll get two signatures stacked on top of each other.

**Turning the signature off for a while without deleting it.**
Untick **Append my personal signature to outbound messages** at the top of the card and click Save Signature. Your signature content stays saved exactly as it was. Tick the toggle again and save when you want it back.

## Frequently asked questions

**Why doesn't my signature show up on my phone?**
Two possibilities. First, your phone may be set up to send mail through a different account (a personal Gmail, an old work account), not through Hermes — in which case Hermes never sees the message and can't add your signature. Check your phone's mail account settings. Second, your phone's own Mail app may have its own built-in signature setting that's overriding nothing here — Hermes still adds yours when the message arrives at the mail server, so the recipient sees it. The signature just won't appear inside your phone's compose window while you're writing.

**Can I have different signatures for different recipients or different domains?**
No — this page supports a single signature that applies to all your outbound mail. If you need different signatures for different audiences (internal vs. external, English vs. French), you'd need to add the alternative text manually before sending the message.

**Why is my image being shrunk or stretched?**
The width you pick with the Width buttons gets stored on the image itself. If the image looks wrong, click it in the editor (you'll see the blue selection ring), then pick a different width or click Reset to use the image's natural size. If the image still looks off, the source file might have an unusual aspect ratio — try resizing the original image with an image editor and re-uploading.

**Why does the preview look different from what arrives in the recipient's inbox?**
Different mail clients render HTML differently. The preview shows roughly what the signature will look like in a typical web mail client, but Outlook on Windows in particular has some quirky HTML rendering. For an exact check, send a test message to yourself and look at it in the same mail client your recipients use.

**How do I remove my signature entirely?**
Two ways. To turn it off but keep the content saved, untick **Append my personal signature to outbound messages** and click Save. To delete it completely, select all the text in the editor (Ctrl-A or Cmd-A), press Delete to empty the editor, then click Save.

**Does the recipient see images as inline pictures or as attachments?**
Inline. Hermes embeds the images directly into the message in a way that mail clients display next to your text, not as a list of attachments at the bottom of the message. If a recipient's mail client is configured to block remote images for privacy, they might see a placeholder until they click "Show images" — but the image data is part of the message, not loaded from an outside server.

**Can I include a clickable phone number or address?**
Yes. Highlight the text, click the link icon in the toolbar, and paste a `tel:+15555550100` URL for phone numbers or a `https://maps.google.com/?q=...` URL for an address. On phones and tablets, tapping the link will open the dialer or maps app.

**Can I include a quote or a small disclaimer at the bottom?**
Yes. The editor supports a blockquote style — highlight the text and click the blockquote button (it looks like a quotation mark) in the toolbar. For a plain disclaimer line, just type it as regular text. Keep in mind any organizational disclaimer your administrator has set will also be added by the mail server.

**I don't see the Personal Signature item in the sidebar.**
A few reasons. If your account isn't a mailbox user (for example, you're on a relay-only account), the page doesn't apply to you. If your administrator has disabled user-managed signatures for your whole domain, the page is hidden — in that case your organization's signature, if any, is added automatically and you don't manage it yourself. If you've recently enabled 2FA on a 2FA-required account but haven't completed enrollment, the rest of the portal is locked down until you finish.

## Where to next

- **Account Settings** — change your display name and email-related preferences. Your name and contact details in your signature aren't pulled from there automatically; you type them into the editor directly.
- **Webmail & Apps** — where you actually compose the mail your signature gets added to.
- **Set Up Your Devices** — guides for configuring your phone, tablet, and desktop mail apps to send through Hermes. (Heads up: signatures you configure on this page apply to mail sent through Hermes — so if your device is set up to send through a *different* mail server, the signature here won't appear on that mail.)
