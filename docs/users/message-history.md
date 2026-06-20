# Message History

This is where you find messages Hermes has handled for you — including ones it put in quarantine, ones it delivered, and ones it blocked.

## The short version

Hermes keeps a record of every message it has processed for your mailbox. Message History is the page where you can look through that record, find a specific message, see what Hermes did with it, and take action on it.

The most common reason to come here is to **release a message from quarantine** that you actually wanted. Maybe an order confirmation got held back, or a newsletter you subscribed to keeps getting flagged. You find it in the list, tick the checkbox, and tell Hermes to deliver it.

If you have **Quarantine Notifications** turned on (see *Notification Settings*), you usually don't need to visit this page at all — you can release a quarantined message directly from the notification email, with one click. Message History is here for the times when you didn't get a notification, deleted it by mistake, or want to look through a batch of messages all at once.

## What the page shows

The page is split into two cards.

**Search Messages** is at the top. It lets you choose the time window and how many results to bring back. You'll see:

- **Start Date/Time** and **End Date/Time** — the window to search. The default is the last 24 hours. Click the calendar icon next to either field to pick a date and time visually.
- **Search Results Limit** — how many messages to load. The default is **1000**, with options up to **15000**. A higher number takes longer to load, so only raise it if 1000 isn't enough to find what you're looking for.
- **Fetch Messages** — runs the search and refreshes the table below.

**Message History** is the results table. Each row is one message Hermes processed for you, sorted with the newest at the top:

| Column | What it shows |
| --- | --- |
| (checkbox) | Tick this to select the row for a bulk action. The header checkbox selects every row. |
| **View** | A magnifying-glass button that opens the message so you can see its contents and headers. |
| **Archived** | **Y** if the message has been moved to long-term archive storage, **N** if it's still in the active quarantine area. |
| **Date/Time** | When Hermes processed the message. |
| **Sender IP** | The IP address that the message came from. |
| **Return-Path** | The technical "envelope" address the sender's mail server used. Sometimes different from the From address. |
| **From** | The From address as you'd see it in your inbox. |
| **To** | The recipient address — usually you, or one of your domain's addresses if you're a catch-all recipient. |
| **Subject** | The subject line of the message. |
| **Score** | The spam score Hermes calculated. Higher means more suspicious. |
| **Type** | A short description of what Hermes classified the message as — Clean, Spam, Banned (had a forbidden attachment), Infected (virus), and so on. |
| **Action** | What Hermes did with it: **Delivered** (sent to your inbox), **Blocked** (held in quarantine or rejected), or **N/A** if the status doesn't fit either bucket. |

Above the table you'll see a row of export buttons (**Copy**, **CSV**, **Excel**, **PDF**, **Print**), a **Search** box that filters the rows you're already showing, and a page-size picker (50, 75, 100, or all). Those tools work on whatever the search has already loaded — they don't go back to the database.

If no messages match your date range, the table is replaced with a small info note saying so.

## Releasing a message from quarantine

There are three different ways to release a message, depending on what you have in front of you.

**From the notification email (easiest).** If quarantine notifications are turned on, each notification has a Release Message button. Click it and the message is delivered to your inbox. You don't have to log in, and you don't need to come to this page at all.

**One message at a time from this page.** Find the row, tick its checkbox, click **Message Actions**, pick **Release Message(s) to Mailbox** from the dropdown, and click **Submit**. The message is delivered to your inbox within a minute or two.

**Several messages at once.** Tick the checkboxes for every message you want to release (or tick the header checkbox to select them all), click **Message Actions**, pick **Release Message(s) to Mailbox**, and submit. Hermes releases each selected message in turn and shows a green summary listing the ones it released.

Released messages arrive in your inbox just like any other email. There's no way to "un-release" a message — if you release something by mistake, just delete it from your inbox.

## Looking at a message before releasing it

If you're not sure whether a message is really legitimate, click the magnifying-glass button in the **View** column. That opens the message itself so you can see what's in it before deciding.

The view page shows you:

- The subject, From address, Return-Path, To address, CC, and the date and time.
- The body of the message, as HTML if it has one, or as plain text in a textbox.
- The full message **Headers** in a textbox at the bottom — useful if you want to verify where the message actually came from.

Buttons at the top let you go back to Message History, print the message, and (if your administrator has enabled it) download the raw message as a file.

Viewing a message does **not** release it — it just lets you read it. To get the message into your inbox after viewing, go back to Message History, tick its checkbox, and use the Release Message action as described above.

## Searching and filtering

The **Search** box above the table filters the rows that are already loaded. Type any part of an address, subject, or other field and the table narrows down as you type. Clear the box to see everything again.

To search a *different time window* — say, last week instead of the last 24 hours — change the **Start Date/Time** and **End Date/Time** in the top card and click **Fetch Messages**. That re-runs the underlying query against the database.

If you're hunting for a specific message and you know roughly when it should have arrived, set the date range tightly around that time and keep the limit at 1000. That's faster and easier than loading the maximum.

## What you CAN'T do from this page

A few honest limitations:

- **Messages from blocked senders don't appear here.** If you've added a sender to your Block list under *Sender Filters*, their messages are silently dropped — they never get logged for your mailbox. Message History will not show them.
- **You can't re-quarantine a message that's already been delivered.** Once a message lands in your inbox, this page doesn't take it back. Use your mail client's normal tools (delete, mark as spam) instead.
- **You can't recover messages older than the retention window.** Quarantined messages are deleted after a fixed period set by your administrator. If a message has been purged, Message History won't show it and there's no way to get it back.
- **You can't act on someone else's messages.** Even if you're a catch-all recipient for a domain, the actions you take only affect mail that's queued against your mailbox or the catch-all addresses you cover.

## Common scenarios

**You're expecting an order confirmation that never arrived.**
Open Message History, leave the date range on the default 24 hours, and skim the list for the sender. If it's there, tick the checkbox, click **Message Actions**, pick **Release Message(s) to Mailbox**, and submit. If the same store's mail keeps getting quarantined, add their address to your allow list under *Sender Filters* so it doesn't happen again.

**You want to release several legitimate newsletters all at once.**
Tick all of their checkboxes (or click the header checkbox to select everything and untick the ones you don't want), then use **Message Actions** with **Release Message(s) to Mailbox**.

**You want to read a quarantined message before deciding what to do with it.**
Click the magnifying-glass icon in the View column. The page that opens shows the body and headers. Hit the Back button to return to Message History, then release it (or just leave it in quarantine to expire on its own).

**You want to make sure something didn't sneak through that shouldn't have.**
Set the date range to a longer period (say, the last week), click **Fetch Messages**, and look through the table. The **Score** and **Type** columns tell you what Hermes thought of each message; the **Action** column tells you what it did.

**Your administrator told you to "train" a message.**
If your account has training enabled, the Message Actions dropdown shows extra options: **Train Message(s) as Spam**, **Train Message(s) as Ham (NOT Spam)**, and **Remove Message(s) Previous Training**. These tell the spam filter to learn from specific examples. Use them only when an administrator asks you to — they affect the filter's behaviour for everyone on the system, not just for you.

## Frequently asked questions

**How long do quarantined messages stay around?**
That's set by your administrator, not by you. It's typically a few weeks. Once the retention window passes, the message is deleted and cannot be recovered.

**A message I released didn't arrive in my inbox. What now?**
Wait a couple of minutes — release isn't instant. If after five minutes it still hasn't arrived, check your mail client's spam or junk folder; once Hermes lets it through, your mail client may filter it independently. If it's nowhere to be found, contact your administrator.

**Why doesn't the table show messages from a sender I know I've been blocking?**
Mail from senders on your block list is dropped silently — there's no record of it in Message History. That's deliberate. If you want to see those messages instead of having them dropped, remove the sender from your Sender Filters block list.

**The date pickers default to the last 24 hours. Can I change the default?**
No — every visit starts on the last 24 hours. Use the date fields and **Fetch Messages** to look further back.

**What's the difference between "Blocked" and "N/A" in the Action column?**
"Blocked" means the message was held in quarantine or rejected outright. "N/A" is for messages whose status doesn't fit those buckets cleanly — usually transient or partial states. Both are uncommon if you're just looking for normal mail.

**Why does the same message sometimes appear twice with different scores?**
It doesn't, normally. But if a sender sent the same mail to you under multiple addresses (for example, your real address and a catch-all on your domain), you may see one row per delivery. The **To** column tells you which address each row was actually for.

**Can I bulk-release everything from the last 24 hours?**
Yes — load the page, tick the header checkbox to select every visible row, then click **Message Actions** and choose **Release Message(s) to Mailbox**. Be careful: this will release real spam too, and you'll have to clean those out of your inbox by hand. Most people prefer to release only what they recognize.

**Will Hermes remember that I released a message, so it doesn't quarantine the same sender again?**
No. A release just delivers that one message. If you want a sender to skip quarantine permanently, add them to your allow list under *Sender Filters*.

**I'm a catch-all recipient for my domain. Will I see messages addressed to other people?**
You'll see messages addressed to addresses on your domain that don't belong to any real user — that's what "catch-all" means. You won't see messages addressed to your colleagues' real mailboxes; those belong to their own Message History.

**Why is the "Export" or "Print" button only showing what's already on screen?**
The export buttons act on the rows the page has loaded into the table. If you want a wider export, raise the **Search Results Limit** in the top card before fetching, then export.

## Where to next

- **Turn quarantine notifications on or off** — see *Notification Settings*
- **Make a specific sender skip quarantine for good** — see *Sender Filters*
- **Change your password, recovery email, or timezone** — see *Account Settings*
