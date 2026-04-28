# What Are App Passwords?

If you have just been told to "create an app password" to set up your email or calendar on your phone, this page explains what that is, why it exists, and what it does for you.

## The short version

An **app password** is a separate password that you create for each app or device you want to connect to your email, calendar, or contacts. It is not your main password. You can have as many as you want, and you can disable one at any time without affecting the others.

You use:

- Your **main password** (the one you use to log into the website) when you sign in to the user portal or webmail in your browser.
- An **app password** when you set up your email, calendar, or contacts inside an app on your phone, tablet, or computer.

That is the entire idea. The rest of this page is about *why* it works that way, and what to do if something is unclear.

## Why have a separate password at all?

Three reasons.

### 1. You can disable one device without changing the others

Imagine your only password is your main password, and you set it up on your phone, your laptop, and your home computer. Then you lose your phone.

To prevent the lost phone from accessing your email, you would have to **change your main password**, then go back to the laptop and the home computer and re-enter the new password on each. Anything you missed would stop working. And the password would now be different from what you use to log into the website too.

With app passwords:

- You created one called "iPhone" for your phone.
- You created one called "Laptop" for your laptop.
- You created one called "Home" for your home computer.
- You lost your phone — you sign in to the user portal, click **Revoke** next to "iPhone", and that's it.
- Your laptop, your home computer, and your main website login are completely unaffected.

### 2. Apps cannot do two-factor authentication

When you log into the website, you are sometimes asked for a second factor — a code from an app, or a tap on Duo Push. That extra step keeps your account safer.

Mail apps, calendar apps, and contacts apps cannot ask you for a second factor. They can only send a username and a password, once, and that's it. If you used your main password in those apps, you would be giving them a way around the second factor entirely.

App passwords solve this cleanly: the website still asks for the second factor (because it can), and your apps use a separate, scoped password that has no special powers beyond mail/calendar/contacts access.

### 3. App passwords have less power than your main password

Your main password is the key to your whole account. An app password can only be used to access mail, calendar, and contacts. It cannot change your password, change your settings, or access anything else.

So if an app password is somehow stolen, the attacker can read your mail — bad, but not catastrophic. If your main password is stolen, the attacker can do anything you can do.

## What an app password looks like

When you create one, the system generates a random string of about 30 characters that looks something like this:

```
xQ7kP2mN9vRtY8wJ3hF6aD1sZ4bC0nL5
```

You will see it **once**, on the screen, right after you create it. You should immediately:

1. Copy it, and
2. Paste it into the app or device where you want to use it (or save it in a password manager).

After you leave that page, **the system will not show it to you again**. This is intentional — even an administrator cannot retrieve it. If you lose it before you set up your device, just revoke it and create a new one. There is no penalty for doing this.

You do not need to remember an app password. You will probably never type it manually. The whole point is that you set it once on the device and then forget about it.

## How many app passwords should I have?

**One per device or app**, with a label that tells you which is which. For example:

```
iPhone               (created for the Mail app on your iPhone)
iPad                 (Mail and Calendar on your iPad)
Thunderbird          (the desktop mail client on your laptop)
Outlook on home PC   (the mail client on your personal computer)
Backup tool          (an automated mail backup tool, if you have one)
```

You can also use one app password for multiple things on the same device — for example, a single "iPhone" app password can be used by Mail, Calendar, and Contacts on that one phone — but the cleanest practice is one per device.

## When you would create a new one

- **Setting up a new device or app for the first time.** (e.g. you got a new phone)
- **Replacing an existing device.** (Create a new app password for the new phone, set it up, then revoke the old phone's app password.)
- **You forgot to copy one when you created it.** Just revoke that row and create a fresh one.

## When you would revoke one

- **You lost a device.** Revoke that device's app password immediately. The lost device is then locked out, and your main password and other devices are unaffected.
- **You stopped using a device or app.** Revoke its app password to keep your account tidy.
- **You suspect an app password was stolen.** Revoke it. Even if you are not sure, revoking and creating a new one takes about a minute.

## What about my main password?

You still have one, and you still use it for the website (and webmail, calendar, and contacts when you access them through the website). You should keep it strong, keep it private, and change it if you ever suspect it has been compromised.

What changes is that **your main password no longer has to live on every device you own**. It only ever leaves your head when you type it into the website. Your devices have their own credentials, and those credentials are limited to the apps they were created for.

## Common questions

**My phone is asking for a password I don't have. What do I enter?**
Sign in to the user portal, go to **My App Passwords**, click **Create**, label it for the device you're setting up, copy the password it shows you, and paste it into the phone. That's the password the phone is asking for.

**Why do I get a different password every time I create one?**
Because each one is unique. That is what lets you revoke them individually.

**Can I change an existing app password?**
No — app passwords are not changed, they are revoked and re-created. If you want to "change" the one your iPhone uses, create a new one labelled "iPhone (new)", set it up on the iPhone, then revoke the old "iPhone" row.

**I revoked the wrong app password. Can I undo it?**
Not directly. But it takes about a minute to create a new one and re-enter it on the device. Nothing is lost permanently.

**I see a row called "Initial Setup" that I don't remember creating. What is it?**
When your mailbox was first created, the system generated one app password for you so your existing devices could keep working during the transition. Once you have created proper per-device app passwords ("iPhone", "Laptop", etc.) and confirmed they work, you can safely revoke the "Initial Setup" row.

**Can I share an app password with someone else?**
Don't. App passwords are device-scoped, but they are still credentials to your mailbox. If you need someone else to access shared content (a shared inbox, a shared calendar), the administrator can grant that access without sharing any password.

## Where to next

- **Create an app password** — step-by-step (see *Create an App Password* in the same chapter)
- **Revoke an app password** — step-by-step (see *Revoke an App Password*)
- **Mobile setup** — using the iOS setup wizard to skip the manual app-password step (see the *Mobile Setup* chapter)
