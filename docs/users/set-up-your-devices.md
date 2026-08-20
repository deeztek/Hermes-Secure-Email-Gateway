# Set Up Your Devices

This page walks you through connecting your phone, tablet, or desktop email program to your Hermes mailbox — so that messages, calendar events, and contacts all show up in the apps you already use.

## The short version

Setting up a device means telling Mail, Calendar, and Contacts on that device where your server is and giving them a credential they can use to sign in. The Set Up Your Devices wizard turns that into a pick-list: you choose what kind of device you have, and it gives you exactly the right instructions for it.

There are seven options on the picker:

- **iPhone, iPad, or Mac (Apple apps)** — generates a downloadable profile that sets up Mail, Calendar, and Contacts in one tap. The wizard mints the app password for you automatically.
- **Android** — install two apps (DAVx5 for calendar/contacts, K-9 Mail or Thunderbird for Android for mail), then sign in with one app password.
- **Thunderbird (Windows / Mac / Linux)** — Thunderbird auto-discovers everything from your email address; you just paste the app password.
- **Microsoft Outlook (Windows)** — Outlook autodiscovers mail; the free CalDAV Synchronizer add-in handles calendar and contacts.
- **Microsoft Outlook (Mac)** — Outlook handles mail only; the built-in macOS Calendar and Contacts apps handle the rest (Outlook for Mac has no calendar/contacts sync of its own).
- **Linux desktop** — a reference card with server, port, and encryption settings for Evolution, KMail, Geary, Claws, or any other Linux client.
- **Web only** — skip device setup entirely and use webmail in your browser. No app password needed.

Whichever you pick, the goal is the same: one **app password** per device, used for mail, calendar, and contacts together. If you've never heard of app passwords before, see *My App Passwords* — but for the Apple path you don't have to think about it; the wizard handles it for you.

## Before you start

A few things go more smoothly if you have them ready:

- **Your full email address.** This is your username for every device.
- **The device you're setting up, ideally within reach.** For the Apple path, you'll scan a QR code with the device's camera; for the other paths you'll paste an app password into the device.
- **A label in mind for this device** — something like *iPhone*, *Work laptop*, *Sarah's iPad*. It only has to make sense to you; it shows up later in *My App Passwords* so you can revoke that device's access by name.
- **Two-factor authentication already set up on your account** (recommended). Device setup itself doesn't depend on it, but if you don't have 2FA on yet, doing it before you set up devices avoids backtracking. See *Account Settings*.

## Setting up iPhone or iPad (and Mac with Apple Mail)

This is the smoothest path on Hermes: one downloadable profile sets up Mail, Calendar, and Contacts together, and the wizard mints and embeds the app password for you so you never see it.

1. On the device picker, click **iPhone, iPad, or Mac (Apple apps)**.
2. Fill in the form:
   - **Device label** — a name you'll recognize (the default is *iPhone*; change it if needed). This shows up in *My App Passwords* later.
   - **Display name** *(optional)* — how the account appears inside Mail/Calendar/Contacts on the device. Defaults to your email address if left blank.
3. Click **Generate Setup Profile**. Hermes mints a fresh app password for this device, builds and signs a `.mobileconfig` profile containing the IMAP, SMTP, CalDAV, and CardDAV settings, and then opens the result page.
4. The result page shows two ways to get the profile onto your device. **Pick one, not both** — the link works exactly once and expires after 30 minutes.

   - **Scan with your phone or iPad** — if you ran the wizard on a desktop computer, point your phone's camera at the QR code on screen. Tap the link that pops up to open it in your phone's browser. You may be asked to sign in (use your normal email and password as you would for this portal). The profile downloads automatically.
   - **Install on this device** — if you're already on the iPhone, iPad, or Mac you want to set up, just click the **Download profile** button.
5. **On the device, install the profile.**
   - **iPhone or iPad:** Open **Settings**, then **General**, then **VPN & Device Management**. Tap the *Hermes* profile and tap **Install**. iOS will ask for your iPhone passcode to confirm — this is iOS protecting itself, not a Hermes password. Tap **Install** again to confirm.
   - **macOS:** Open **System Settings**, then **Privacy & Security**, then **Profiles**. Double-click the profile and click **Install**.
6. Within a minute or two, the Mail, Calendar, and Contacts apps on the device will show your new account. You don't need to enter any other passwords — the profile carries them.

If you accidentally close the result page, miss the install prompt, or burn the link by clicking the wrong option, just go back to the wizard and generate a fresh profile. There's no penalty for redoing it.

## Setting up Android

Android needs two apps: **DAVx5** for calendar and contacts, plus a mail app for email. Both work with the same app password.

1. On the device picker, click **Android**.
2. **Mint an app password first.** Open *My App Passwords* in the sidebar, click **Create App Password**, label it for this device (e.g. *Pixel 8*), and copy the password it shows you. You'll paste this into both apps below. Keep the password handy; it's only shown to you once.
3. Install **DAVx5** from F-Droid or Google Play.
4. Install **K-9 Mail** or **Thunderbird for Android** (these are the same app — Thunderbird for Android is K-9 rebranded — so just pick whichever name you prefer).
5. **Set up email.** Open the mail app, choose *Add account*, enter your full email address and the app password. The app autodiscovers IMAP and SMTP. Tap *Done*.
6. **Set up calendar and contacts.** Open DAVx5, tap the **+** button, choose **Login with URL and username**, and fill in:
   - **Base URL** — shown on the wizard page for you (it's `https://your-mail-server/nc/remote.php/dav/`).
   - **Username** — your full email address.
   - **Password** — the same app password from step 2.

   Tap *Login*. DAVx5 discovers your calendars and address books. On the next screen, enable Calendar and Contacts sync and grant DAVx5 the permissions Android asks for — that's how the synced data shows up in Android's built-in Calendar and Contacts apps.

## Setting up Thunderbird (Windows / Mac / Linux)

Thunderbird is the easiest desktop path: it auto-discovers mail, calendar, and contacts. You won't type a single server name.

1. On the device picker, click **Thunderbird (Windows/Mac/Linux)**.
2. **Mint an app password** for this computer in *My App Passwords*, label it (e.g. *Work laptop*), and copy the password.
3. In Thunderbird, choose **File** → **New** → **Existing Mail Account** (or use the first-run setup on a fresh install).
4. Enter your name (how you want messages to be signed), your email address, and paste the app password. Click *Continue*. Thunderbird discovers IMAP and SMTP automatically.
5. After mail finishes, Thunderbird usually shows a **"Connect your linked services"** page listing Calendar and Address Book. Click *Connect* on each; paste the same app password if asked.

If "Connect your linked services" doesn't appear (some Thunderbird versions skip it), the wizard page tells you exactly how to add Calendar and Address Book manually — the URL is shown on screen.

## Setting up Microsoft Outlook (Windows)

Outlook on Windows handles email natively. For calendar and contacts you'll install the free **CalDAV Synchronizer** add-in.

1. On the device picker, click **Microsoft Outlook (Windows)**.
2. **Mint an app password** for this computer and copy it.
3. In Outlook, choose **File** → **Add Account**, enter your full email address, and paste the app password when prompted.
4. Close Outlook, download **CalDAV Synchronizer** from the link on the wizard page, and run the installer.
5. Re-open Outlook. A new *CalDav Synchronizer* ribbon tab appears. Open **Synchronization Profiles** → **Add new Profile**, pick **Nextcloud** as the profile type, and fill in your email and the same app password.
6. Click *Test or discover settings* — you'll see a list of your calendars and address books. Pick one calendar (or address book) per profile, choose the matching Outlook folder, save, and repeat for each one you want to sync.

## Setting up Microsoft Outlook (Mac)

Outlook for Mac doesn't speak CalDAV or CardDAV at all, so calendar and contacts have to live in macOS's own Calendar and Contacts apps. The wizard page walks you through all three apps in order. If you only use Apple Mail, Calendar, and Contacts on the Mac, the **iPhone, iPad, or Mac (Apple apps)** path is faster — one downloadable profile sets up all three.

## Setting up a Linux desktop

The wizard's Linux page is a settings reference card — server name, ports, encryption type — that works for any Linux mail or PIM client (Evolution, KMail, Geary, Claws, and so on). Mint an app password from *My App Passwords*, then plug the values shown on the wizard page into your client's account setup. For Thunderbird on Linux, use the dedicated Thunderbird walkthrough — it auto-discovers everything.

## Just using the webmail

If you don't want to set up any apps at all, pick **Web only** on the device picker. The wizard gives you a single button that opens webmail in your browser. **No app password is needed for webmail** — it uses your normal login. Webmail is fully responsive and works on phones and tablets too, so you can use it from anywhere with a browser.

## Sending from an alias

If your administrator has given you permission to send from another address, a
team address like `sales@yourdomain.tld` for example, that permission is set on
the server. Your mail app still has to be told the address exists before it will
offer it to you.

This catches nearly everybody out: the permission is granted, nothing appears to
change, and it looks like it did not work. It did. The app simply does not know
about it yet, because there is no way for the server to tell it.

**In webmail (Nextcloud Mail)**

1. Open **Mail**, then the **settings gear** beside your account, or go to
   **Account settings**.
2. Find **Aliases** and click **Add alias**.
3. Enter the address, and the name you want on messages sent from it.
4. Compose a new message. The **From** field is now a dropdown.

**In Thunderbird**

1. **Account Settings**, select your account, then **Manage Identities** and **Add**.
2. Enter the alias address and the display name. Leave the outgoing server as it is.
3. The **From** dropdown appears in the compose window once there is more than one
   identity.

**In Apple Mail, Outlook and others**

Same idea, different menu. Look for a second email address, an alternate identity,
or an alias in the account's settings.

### If it is refused when you send

You will get a message like:

```
Sender address rejected: not owned by user you@yourdomain.tld
```

That means the address was added in your app but the permission has not been
granted on the server, or has been removed. Nothing you can change in the app will
fix it. Ask your administrator to grant Send As for that address.

The check is deliberate. It is what stops anyone sending mail as one of your
colleagues.

## What gets created behind the scenes

For the Apple path, the wizard mints a brand-new app password for that device and embeds it in the downloadable profile. You never see the password — it lives inside the profile, which iOS or macOS hands directly to the Mail, Calendar, and Contacts apps. The new app password also shows up as a row in *My App Passwords* under the label you chose.

For every other path, **you** create the app password manually in *My App Passwords* before plugging it into the device. Either way, the result is the same: one app password per device, identified by its label, listed in *My App Passwords*, and revocable in a single click.

## Removing a device's setup

To stop a device from being able to fetch mail, calendars, or contacts:

1. Open *My App Passwords* in the sidebar.
2. Find the row matching the device's label.
3. Click **Revoke** and confirm.

Within seconds, the device is locked out. Your other devices and your portal login are completely unaffected. If you want to re-add that device later, just run the setup wizard again with a fresh label.

## Common scenarios

**First-time phone setup.**
Pick the path for your phone (iPhone/iPad or Android). The wizard does everything in one go for Apple devices; for Android you'll create an app password first and then plug it into two apps.

**You got a new phone and want to move setup over.**
Run the wizard fresh for the new phone — pick a new label like *iPhone (new)*. Confirm mail, calendar, and contacts all work on the new device, then go to *My App Passwords* and revoke the old device's row. Old phone is now locked out; new phone keeps working.

**You want to add a tablet that uses the same mailbox.**
Run the wizard separately for the tablet, with its own label (*iPad*). One app password per device is the cleanest model.

**The QR code didn't scan.**
Try moving the phone closer or farther, or use better lighting. If it still won't scan, click the **Download profile** button instead. If you're not on the same device, you can save the file, then AirDrop or email it to the phone. The token still has to be used within 30 minutes either way.

**The 30-minute link expired before you got to install.**
Run the Apple wizard again — it'll generate a fresh profile and a fresh link. The old app password row will still be in *My App Passwords*; if you don't want it cluttering the list, revoke it.

## Frequently asked questions

**What is a configuration profile? Is it safe?**
A configuration profile is a small file that tells iOS or macOS exactly how to set up an account. The one Hermes generates only configures Mail, Calendar, and Contacts to talk to your mailbox — it doesn't install software, change settings outside of those three apps, or send anything outside your network. The profile is digitally signed by Hermes, so iOS will identify it as coming from your mail server rather than as an unknown profile.

**Why does iPhone ask for my passcode when I install the profile?**
That's iOS confirming that you — the person physically holding the phone — are the one installing it. It's an iOS protection that applies to every configuration profile, regardless of where it came from. The passcode you enter is your iPhone unlock code; Hermes never sees it.

**Can I set up Apple Mail without scanning the QR code?**
Yes. Click **Install on this device** instead of scanning. That downloads the `.mobileconfig` file directly. If you're already on the iPhone, iPad, or Mac you want to set up, that's the quickest path. The QR exists for the case where the wizard is open on your desktop and you need the profile on a different device.

**What if I lose my phone?**
Go to *My App Passwords*, find the lost device's row, and click **Revoke**. The lost phone is locked out within seconds. Your other devices and your main login are unaffected. When you get a new phone, run the setup wizard again for it.

**Do I have to redo this every time I get a new phone?**
Yes — each device gets its own app password tied to its own label, so a new phone needs a new run through the wizard. It only takes a minute or two for the Apple path.

**Why am I being asked for a "password" on the device when the profile is supposed to contain it?**
For the Apple path, the profile contains the password and the device shouldn't ask. If iOS does ask, it's usually safe to tap **Skip** — iOS will pull the password out of the profile automatically. If skip isn't offered, paste the password from the profile note. (For non-Apple devices, the password is the app password you just minted in *My App Passwords*.)

**I see two rows in My App Passwords for the same device. Why?**
You probably ran the wizard twice. Each run mints a fresh app password whether or not the old one is still working. The newest one is in use; you can safely revoke the older row once you've confirmed the device is happy.

**Can my administrator see the app password the wizard created?**
No. Even the system itself doesn't store the actual password — only a scrambled fingerprint of it, which is enough to check sign-ins but not enough to reveal the password. For the Apple path the plaintext lives only inside the signed profile file that gets handed to the device.

**My device says my password is wrong even though I just set it up.**
For non-Apple paths, the most common cause is a copy-paste mistake — a stray space or a missed character. Revoke that row in *My App Passwords*, mint a fresh one, and try again. For the Apple path, generate a fresh profile and reinstall — the old app password can be revoked afterward.

**Will setting up a new device disconnect my old ones?**
No. Each device has its own independent app password. Setting up a new one doesn't affect anything that's already working.

## Where to next

- *My App Passwords* — manage the per-device credentials created by this wizard, see when each device last connected, and revoke any device's access in one click.
- *Account Settings* — set up two-factor authentication, change your password, set a recovery email. Ideally done before setting up devices.
- *Vacation Auto-Reply* — set an out-of-office message that runs on the server, so it works whether or not your devices are online.
