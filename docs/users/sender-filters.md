# Sender Filters

This is where you tell Hermes to always let mail from a specific sender through, or to always silently drop it, regardless of what the spam filter would normally do.

## The short version

Hermes makes its own judgement about every incoming message. Most of the time it gets it right, but sometimes a newsletter you actually want ends up in quarantine, or a sender you've stopped caring about keeps trickling into your inbox. Sender Filters let you override that judgement for specific people or domains, just for your own mailbox.

You can do two things on this page:

- Add a sender to your **allow** list, so messages from them always get delivered to your inbox and never get held in quarantine for being spam.
- Add a sender to your **block** list, so messages from them get silently dropped and you never see them.

Your filters apply only to mail addressed to you. Other people in your company are not affected, and they have their own filter lists of their own.

## Why you would use this page

There are two situations where you'd come here.

**A sender you want keeps getting quarantined.** Maybe it's a newsletter you actually signed up for, or alerts from a vendor portal, or shipping notifications from a small online store. Every time one comes in you have to release it from quarantine. Add the sender to your allow list once and Hermes will stop second-guessing it.

**A sender you don't want keeps reaching your inbox.** Maybe a former contact still emails you, or a marketing list you can't unsubscribe from keeps slipping through. Add the sender to your block list and you won't see their messages anymore.

You don't need to use this page for normal day-to-day mail. The spam filter handles most senders correctly on its own. This page is for the cases where you want to take direct control.

## How the page is organized

When you open Sender Filters, you'll see two buttons at the top of the card:

- **Add Sender** — opens a small form for adding a new filter.
- **Delete Sender(s)** — removes any filters whose checkboxes you've ticked in the table below.

Below the buttons, there's a yellow note reminding you what an Allow filter does (and doesn't) — covered further down on this page.

Below that is a table listing all the filters you've already set up. Each row has:

| Column | What it shows |
| --- | --- |
| (checkbox) | Tick this if you want to delete the row. The header checkbox selects all rows at once. |
| **Sender** | The email address or domain you added the filter for. |
| **Receiver** | Your own email address (this is always you — your filters only apply to mail addressed to you). |
| **Action** | A green **Allow** badge or a red **Block** badge. |

If you haven't set up any filters yet, the table is replaced with a short message telling you to click Add Sender to create your first one.

## Adding an allowed sender

1. Click **Add Sender** at the top of the page. A small form appears.
2. In the **Sender E-mail Address or Domain** box, type either:
   - A full email address, like `newsletter@example.com` — the filter applies only to that one address.
   - A domain, like `example.com` — the filter applies to every sender at that domain.
   - A domain prefixed with a dot, like `.example.com` — the filter applies to that domain *and* every subdomain of it (so `mail.example.com`, `news.example.com`, and so on are all covered).
3. In the **Select Action to Take** dropdown, leave it on **Allow** (this is the default).
4. Click **Submit**.

The new filter appears in the table with a green **Allow** badge. From now on, mail from that sender will skip the spam filter and be delivered to your inbox.

## Adding a blocked sender

The steps are the same as adding an allowed sender, except in step 3 you choose **Block** from the dropdown instead.

The new filter appears with a red **Block** badge. From now on, mail from that sender will be silently discarded. You will not get a notification, the sender will not get a bounce, and the message will not appear in your Message History — it will simply not exist as far as your mailbox is concerned.

## Editing or removing a filter

There is no "edit" — if you want to change a filter (for example, switch a sender from Allow to Block, or correct a typo in an address), you remove the old one and add a new one.

To remove a filter:

1. Tick the checkbox in the leftmost column of the row you want to remove. You can tick more than one, or tick the header checkbox to select all of them.
2. Click **Delete Sender(s)** at the top of the page.
3. A red confirmation box appears asking "Are you sure?" Click **Yes** to confirm or **No** to back out.

Deletion is immediate and cannot be undone, but if you remove the wrong row by mistake you can just add it back.

## What this page does NOT do

A few important limits:

- **Allow does not let dangerous attachments through.** If a sender is on your allow list but sends you a message with a virus or a banned file type, the message is still blocked. Allow only tells the spam filter to back off — it does not turn off virus scanning or attachment rules.
- **Filters are per-user.** Adding `newsletter@example.com` to your allow list does not affect anyone else in your company. If a colleague has the same problem they need to add their own filter.
- **You can't filter yourself.** Hermes will not let you allow or block your own email address or your own email domain, because that would create odd situations with mail you send to yourself or to coworkers.
- **Blocked mail is gone for good.** Blocked messages are not put in quarantine — they are dropped. There is no "blocked items" folder to dig through later. If you might want the messages eventually, leave the sender alone and let the spam filter handle them normally.

## Common scenarios

**A newsletter you actually want keeps ending up in quarantine.**
Add the sender's email address (or their domain, with a leading dot to cover subdomains) with the **Allow** action. The next message they send will be delivered straight to your inbox.

**A marketing list won't stop emailing you and the unsubscribe link doesn't work.**
Add the sender's email address with the **Block** action. You'll stop seeing the messages immediately.

**You're suddenly getting spam from many different addresses, but they all end in `@spammydomain.tld`.**
Add `spammydomain.tld` with the **Block** action. Every sender at that domain is blocked in one go. If the spammers are also using subdomains, use `.spammydomain.tld` (with the leading dot) to catch those too.

**You changed your mind about a sender you blocked.**
Find them in the table, tick the checkbox, and click **Delete Sender(s)**. They'll go back to being filtered normally by the spam filter — they aren't automatically allowed; the block is just removed.

## Frequently asked questions

**Do I have to fill in the Receiver field?**
No. You don't see a Receiver field when adding a filter — it's always you. The Receiver column in the table just confirms that the filter belongs to your mailbox.

**What happens if I add the same sender twice?**
Hermes tells you the sender already exists and doesn't add a duplicate. If you want to change Allow to Block (or the other way around), delete the existing row first and then add it again with the new action.

**Can I use wildcards like `*@example.com`?**
You don't need to. Entering just `example.com` already matches every sender at that domain. Add a leading dot (`.example.com`) if you also want to match subdomains.

**Does an Allow filter mean the sender's mail bypasses virus scanning?**
No. Allow only bypasses the spam filter. Virus scanning, banned attachment types, and other safety rules still apply.

**Does a Block filter send a bounce back to the sender?**
No. Blocked messages are silently discarded — the sender gets no feedback either way. They have no way of knowing you've blocked them.

**Will I get a notification email when a blocked message is dropped?**
No. Blocked messages don't generate notifications and don't appear in Message History. From your point of view, they never arrived.

**Can my administrator see or change my sender filters?**
Your administrator can see them in the underlying system, but day-to-day they aren't managed by anyone but you. If you can't figure out why a particular sender is or isn't getting through, your administrator can investigate.

**I added a filter but it doesn't seem to be working. What now?**
Double-check that the sender's address in the row matches what's actually in the **From** of their messages — typos are easy to make. If it still doesn't behave the way you expect, contact your administrator; there may be other rules in the system (organization-wide policies) that take precedence over a personal filter.

## Where to next

- **Releasing a single message from quarantine without setting up a permanent filter** — see *Message History*
- **Turning the quarantine notification emails on or off** — see *Notification Settings*
- **Changing your password or other account preferences** — see *Account Settings*
