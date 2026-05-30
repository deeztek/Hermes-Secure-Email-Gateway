# Webmail & Apps

This is the link in the sidebar that takes you into Hermes's web-based mail, calendar, contacts, and file storage — all in one place, with no second login to remember.

## The short version

Click **Webmail & Apps** in the sidebar and a brief *Connecting to Webmail...* screen appears. A second or two later you land inside Nextcloud, the application Hermes uses for webmail and the other day-to-day apps. You're already signed in — Hermes has handed your identity over to Nextcloud behind the scenes, so you skip the login screen entirely.

Once you're in, you'll see a row of app icons across the top of the page. Four of them are the ones you'll use day to day: **Mail**, **Files**, **Calendar**, and **Contacts**. Click any of them to switch into that app. You can come back to this app row from anywhere in Nextcloud by clicking the Nextcloud logo in the top-left corner.

This sidebar entry is essentially a shortcut. It does the same thing as visiting your mail server's web address and signing in, except the sign-in part is already taken care of for you.

## What you find inside

**Mail.** Webmail for your Hermes mailbox. Your primary account is already configured — when you open Mail for the first time, your Inbox is right there. You can read messages, reply, compose new mail, organize folders, and search. If you also want to read mail from another account (a personal Gmail address, for example), Nextcloud Mail can add it as an extra account, but it isn't required.

**Files.** Your private cloud storage. Upload, download, organize folders, and share files with other people in your organization. There's also a shared area for files other people in your organization have shared with you. Files you upload here are also available on your phone and computer if you install the Nextcloud client app (covered below).

**Calendar.** A personal calendar that lives on the server, so it shows up the same everywhere. You can create events, set reminders, and subscribe to other people's calendars if they share one with you. This calendar also syncs to your phone — see *Set Up Your Devices* for the connection details.

**Contacts.** A personal address book that syncs the same way. Contacts you add here can show up in the Phone or Mail app on your phone if you connect your device, so a number you save once on the web is on your phone the next time you open it.

## Signing in (it just happens)

You don't need to enter a password when you click **Webmail & Apps**. You're already signed into the user portal, so Hermes hands your identity to Nextcloud automatically using single sign-on. From Nextcloud's point of view, Hermes has already confirmed who you are.

The very first time you visit, your Nextcloud account is created behind the scenes — this takes a moment longer than usual, but it's a one-time delay. From your second visit on, you go straight in.

If you ever sign out of Nextcloud explicitly (there's a *Log out* option under the user menu in the top-right corner inside Nextcloud), you can come straight back via this sidebar entry and you'll be signed in again automatically. Signing out of Nextcloud does **not** sign you out of the Hermes user portal, and signing out of the Hermes user portal does sign you out of Nextcloud the next time it asks the server.

## About that "Connecting to Webmail..." screen

The brief spinner you see on the way in is doing real work, not just decoration. It's giving your browser a moment to set up the small piece of state that Nextcloud needs to recognise the sign-on hand-off cleanly, and then forwarding you to the right page. Normally it's gone in under a second. If you ever see it sit there for more than a few seconds without moving on, that's a sign the browser couldn't reach Nextcloud — refresh the page, and if it still hangs, let your administrator know.

## Getting Nextcloud on your phone or laptop

Nextcloud has free desktop apps for Windows, Mac, and Linux, plus mobile apps for iPhone and Android. They sync your **Files** so they appear like a regular folder on your computer or in a regular app on your phone.

You can download them from the official Nextcloud download page:

<https://nextcloud.com/install/#install-clients>

To sign in on those apps, you'll need a server address and a username, and you'll either sign in through your browser when prompted (the easiest path on desktop) or paste an app password (the easiest path on mobile). See *Set Up Your Devices* for the exact server settings and *My App Passwords* for how to generate a credential the app can use.

## Where to learn more

Nextcloud is a separate application with its own documentation. The four apps above each have a chapter that covers everything they can do in much more depth than makes sense to duplicate here. The official user manual is at:

<https://docs.nextcloud.com/server/latest/user_manual/en/>

If you want to know how to share a file with a link that expires in 7 days, how to set a calendar reminder to also send an email, how to import contacts from a vCard file, or any other in-app question, that's the place to look.

## What this entry does NOT do

- It doesn't show you a new screen inside the Hermes user portal — it launches you out into a separate app (Nextcloud) in the same browser tab.
- It's not where you change your password, set up two-factor authentication, or create app passwords. Those live in *Account Settings* and *My App Passwords* in this user portal.
- It's not where you configure mail filters, your vacation reply, or sender allow/block lists. Those live in *Mail Filters*, *Vacation / Auto-Reply*, and *Sender Filters*.
- It's just a shortcut. Visiting Nextcloud directly at the URL your administrator gave you would land you in exactly the same place — this sidebar link only saves you from typing the URL and signing in again.

## Common scenarios

**First-time visit.**
Click **Webmail & Apps**. The connecting screen lasts a moment longer than usual because Hermes is creating your Nextcloud account on the fly. When the page settles, you'll be in Nextcloud's main view. Click **Mail** in the top app row to see your inbox.

**Daily mail check.**
Click **Webmail & Apps**. By the time you've looked back at your screen, you're in. Click **Mail**. Your inbox loads.

**Sharing a file with a colleague.**
Click **Webmail & Apps**, then **Files** in the top app row. Upload or open the file you want to share. Click the share icon next to the file, type the colleague's name or email address, choose whether they can view or also edit, and click **Share**. The colleague will see the file in their own **Files** app the next time they open it.

**Adding the Nextcloud app on your phone.**
Install the Nextcloud mobile app from the App Store or Google Play. When it asks for the server address, enter the URL your administrator gave you for the mail server (the same one you use to reach this user portal). Sign in when prompted — for mobile, the cleanest approach is to use an app password from *My App Passwords*. Once it's connected, your Files appear like a regular folder on the phone, and you can save photos straight into them.

**Sharing a calendar with a colleague.**
Open Webmail & Apps, click **Calendar**, hover over the calendar you want to share in the left-hand list, click the share icon that appears, and type the colleague's name or email. They'll see the shared calendar in their own Calendar app right away, and on their phone the next time it syncs.

**Webmail & Apps takes me to a login screen — what happened?**
Usually this means your single sign-on session has expired (it happens after a long idle period) or you signed out of Nextcloud explicitly at some point. Sign in once with your normal email and password and you'll be back to one-click access from then on. If the login screen keeps coming back even right after signing in, see the FAQ below.

## Frequently asked questions

**Why does my username look strange inside Nextcloud?**
Nextcloud may show a long internal ID as your username (something like a UUID, or your email address with extra characters). That's normal — Hermes assigns Nextcloud a stable internal ID for each user so that renaming your email address later doesn't lose your files. Your **display name** (what other people see) is your real name and email, and that's what shows up on shared files, calendar invitations, and so on.

**Can I use my own webmail instead?**
Yes. Webmail & Apps is one of several ways to reach your mail. You can also use any standards-based mail app — Apple Mail, Thunderbird, Outlook, K-9 on Android, and so on — by following *Set Up Your Devices*. The webmail in here is just convenient when you're at a browser and don't want to set anything up.

**How do I sign out of Nextcloud?**
Click your user icon in the top-right corner of any Nextcloud page and choose **Log out**. You'll be signed out of Nextcloud but you'll stay signed into the Hermes user portal. To sign back in, click **Webmail & Apps** again — you'll go straight back in without typing a password.

**Why doesn't a file I uploaded show up on my phone?**
If you uploaded a file in Nextcloud Files and don't see it in the Nextcloud mobile app, either the mobile app hasn't synced yet (pull down to refresh) or it isn't configured to sync the folder you uploaded into. The mobile app lets you choose which folders to keep locally and which to leave on the server. Check the app's settings.

**Where do the calendars and contacts I create here live?**
On the Hermes server, in your Nextcloud account. They're available everywhere you sign into Nextcloud — webmail, the Nextcloud mobile app, and any CalDAV/CardDAV-compatible app you've connected (see *Set Up Your Devices*). They're not stored on any third-party service.

**What if my administrator turned off Files, Calendar, or Contacts for my account?**
You may see fewer apps in the top row, or one of the apps may show a blank or restricted view. That's a server-level decision and isn't something you can change yourself. Contact your administrator if you need access to an app you don't see.

**Webmail & Apps isn't in my sidebar — where is it?**
The entry only appears if your account is allowed to use Nextcloud. If it's missing entirely, your administrator hasn't enabled Webmail & Apps for your account. Contact them if you think you should have it.

**I'm being asked to sign in to Nextcloud even after clicking Webmail & Apps.**
This usually points to a stale or expired sign-on session. Sign in once with your normal Hermes email and password. If it keeps prompting you on every visit, let your administrator know — there may be a configuration issue with single sign-on that they need to look at.

**Will signing into Nextcloud from a phone or laptop app count as a separate sign-in?**
Yes. The Nextcloud mobile and desktop apps use an app password to sign in to your account, not single sign-on. That's why *My App Passwords* exists — each device gets its own credential, and you can revoke any one of them without affecting the others.

## Where to next

- **Set Up Your Devices** — server settings and step-by-step instructions for connecting Nextcloud's mobile and desktop apps (and standard mail apps) to your account.
- **My App Passwords** — generate per-device credentials so the Nextcloud mobile app, mail apps, and calendar apps can sign in.
- **Account Settings** — change your main password and manage two-factor authentication. The same password and 2FA also protect Webmail & Apps, because Nextcloud trusts the user portal's sign-in.
