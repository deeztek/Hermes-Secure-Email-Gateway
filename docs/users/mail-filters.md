# Mail Filters

This is where you build rules that automatically sort, mark, forward, or delete your incoming mail as it arrives.

## The short version

Mail Filters are personal rules that act on every new message that lands in your mailbox. You write a rule like *"if the Subject contains the word newsletter, move it to my Newsletters folder"* once, and from then on Hermes does it for you on every matching message that comes in.

This page is **not the same** as Sender Filters. The two pages sound similar and they're both about taming your inbox, but they do different jobs at different points in the pipeline:

- **Sender Filters** tell the spam engine whether to accept or reject mail from a specific sender in the first place. The effect is on the spam decision.
- **Mail Filters** (this page) decide what to do with a message *after* Hermes has already decided to deliver it — file it in a folder, mark it as read, forward a copy, drop it on the floor. The effect is on the layout of your mailbox.

You'll often use both pages together, but for different problems. The next section makes the difference more explicit.

## Mail Filters vs Sender Filters

| | Sender Filters | Mail Filters (this page) |
| --- | --- | --- |
| **What it controls** | Whether the spam engine accepts the message at all | What happens to a message that has already been accepted |
| **When it runs** | Before the message reaches your mailbox | After the message has reached your mailbox |
| **What it can do** | Allow a sender (skip spam check) or block a sender (silently drop) | Move to folder, mark as read, forward a copy, delete silently |
| **What it matches on** | The sender's address or domain | The Subject, From, To, Cc, Bcc, or message size |
| **Acts on quarantined mail?** | Yes — that's the whole point | No — quarantined mail never reaches the filter |
| **Typical use** | "Stop quarantining this newsletter." / "I never want to see this sender again." | "File all newsletters in a Newsletters folder." / "Mark mail from my manager as important." |

Rule of thumb: if you want a message to **arrive** when it currently doesn't (or to **not arrive** when it currently does), that's Sender Filters. If the message *does* arrive but you want it to land somewhere other than the inbox, that's Mail Filters.

## What the page shows

At the top is an **Add Filter** button and an informational note that reminds you how filters work.

Below that is the **My Mail Filters** card. If you haven't created any filters yet, you'll see a short message inviting you to click **Add Filter**. Once you have one or more filters, you'll see a table with one row per filter:

| Column | What it shows |
| --- | --- |
| **Actions** | A row of buttons: **Move Up** / **Move Down** (change the filter's position in the list), **Toggle** (turn the filter on or off without deleting it), **Edit** (open the filter to change it), **Delete** (remove it). |
| **Filter Name** | The label you gave the filter when you created it. |
| **Match** | **ALL** if every condition has to match, **ANY** if just one condition has to match. |
| **Conditions** | A plain-English summary of the conditions in the filter. |
| **Actions** | A summary of what the filter does — Move to, Mark read, Redirect to, Delete. |
| **Status** | **Active** (the filter is running) or **Disabled** (the filter is set up but turned off). |

## Creating a rule

1. Click **Add Filter** at the top of the page. A large dialog opens.
2. In the **Filter Name** field, give the filter a short label that will remind you later what it does — for example, *Newsletters to folder* or *Manager to Important*.
3. In **Match Type**, pick either:
   - **Match ALL conditions (AND)** — every condition has to match before the filter fires. Use this when you want to be specific (for example, *From contains "@example.com" AND Subject contains "Invoice"*).
   - **Match ANY condition (OR)** — the filter fires as soon as one condition matches. Use this when you want a wider net (for example, *From contains "alice@" OR From contains "bob@"*).
4. Under **IF (Conditions)**, set up one or more conditions. Each condition has a **Field**, a **Match** operator, and a **Value**. Click **Add Condition** to add more rows, or the red **×** button to remove one.

   The available fields are:

   - **Subject** — the message's subject line
   - **From** — the sender's address (the one you see in your inbox)
   - **To** — who the message was addressed to
   - **Cc** — who was copied
   - **Bcc** — who was blind-copied (see the warning below)
   - **Size** — how big the message is

   For text fields (Subject, From, To, Cc, Bcc), the match operators are **Contains**, **Equals (case-insensitive)**, and **Does not contain**. For Size, the operators are **Is over** and **Is under**, and the value is a number optionally followed by `K`, `M`, or `G` — for example, `10M` for ten megabytes.

   **A note about Bcc:** mail servers usually strip the Bcc header off a message before delivering it, because hiding the Bcc recipients is the whole point of Bcc. A filter matching on Bcc almost never fires in practice. It's listed for completeness but you should not rely on it.

5. Under **THEN (Actions)**, set up one or more actions. Each action has an **Action** type and (depending on the action) a value. Click **Add Action** to add more, or the red **×** to remove one.

   The available actions are:

   - **Move to folder** — file the message into a folder in your mailbox instead of leaving it in the inbox. Pick an existing folder from the dropdown or type a new folder name to create it. Use `/` to nest folders, like `Work/Projects`.
   - **Mark as read** — keep the message but flag it as already-read, so it doesn't add to your unread count.
   - **Redirect to address** — send a copy of the message on to another address. The address must be a mailbox in your own domain — external redirects are not allowed.
   - **Delete silently** — drop the message. No notification, no copy in Trash, no way to get it back. This one asks you to confirm before saving.

6. Click **Save Filter**. The dialog closes and the new filter appears at the bottom of the list.

## Editing or removing a rule

To **edit** a rule, click the blue pencil button in its row. The same dialog opens, pre-filled with the rule as it stands. Make your changes and click **Save Filter**.

To **turn a rule off temporarily without deleting it**, click the green toggle button in the rule's row. The badge in the Status column changes from **Active** to **Disabled**, and the rule stops firing on new mail. Click the toggle again to switch it back on.

To **delete a rule**, click the red trash button. A confirmation dialog appears showing the rule's name; click **Delete Filter** to remove it permanently or **Cancel** to back out.

To **change the order** rules run in, use the up- and down-arrow buttons in the leftmost column. Each click moves the rule one position. Order matters — see the next section.

## How rules are evaluated

Every new message that lands in your mailbox is checked against your rule list, in order, from top to bottom. Each enabled rule runs in turn, and the actions of any rule whose conditions match are applied to the message.

This means:

- A message can be matched by more than one rule. For example, a message from your manager about a project could match both *Manager to Important* (mark as read) and *Project mail to Project folder* (move to a folder). Both actions happen.
- The **order** matters when the actions interact. If one rule moves a message to a folder and a later rule deletes it, the move-then-delete order applies — the message ends up deleted. Reorder rules so the most important action runs at the position you expect.
- Disabled rules are skipped entirely. A disabled rule is as if it didn't exist for that message.

If you've added a rule and it doesn't seem to be doing anything, the most common causes are: the rule is disabled, the rule's conditions don't actually match (typos in the value, wrong field), or an earlier rule has already deleted or moved the message somewhere you weren't looking for it.

## Common scenarios

**File all newsletters from a particular sender into a folder.**
Add a filter named *Newsletters*. One condition: **From** **contains** `@newsletter.example.com`. One action: **Move to folder** `Newsletters`. Match type: ALL.

**Flag mail from your manager as already-read so it doesn't clutter your unread count.**
Add a filter named *Manager*. One condition: **From** **is exactly** `manager@example.com`. One action: **Mark as read**. Match type: ALL. (Most people would not actually want this — but it's a good illustration of the **Mark as read** action.)

**Forward a copy of all project alias mail to a colleague.**
Add a filter named *Project alias to Bob*. One condition: **To** **contains** `project@`. One action: **Redirect to address** `bob@example.com`. Match type: ALL. Note that the target has to be a mailbox in your own domain.

**Auto-delete a noisy alerts list you can't unsubscribe from.**
First, consider whether *Sender Filters* is a better fit — a block on that sender there will drop the mail before it ever reaches your mailbox. If you need it here for some reason: add a filter named *Drop alerts*. One condition: **From** **contains** `alerts@noisysystem.example.com`. One action: **Delete silently**. Match type: ALL. Be sure: deleted messages can't be recovered.

**Move large messages to a separate folder so they don't clog your inbox.**
Add a filter named *Large messages*. One condition: **Size** **is over** `10M`. One action: **Move to folder** `Large`. Match type: ALL.

**Match either of two senders.**
Add a filter with two **From** conditions and set the match type to **Match ANY condition (OR)**.

## Things this page does NOT do

A few important limits:

- **Filters do not act on quarantined mail.** If a message is held in quarantine because the spam engine flagged it, your filters never see it. Use Sender Filters or release the message manually from Message History.
- **Filters only act on new arrivals.** Mail that's already sitting in your inbox is not retroactively re-filtered when you add a new rule. Only mail that arrives *after* you save the rule is affected.
- **Deleting a rule does not undo its past effects.** If a rule has been moving messages to a folder for a month and you delete the rule, those messages stay where they were moved. The rule just stops acting on new arrivals.
- **Filters only act on incoming mail.** They do not touch mail you send.
- **Redirects must stay within your domain.** You cannot redirect to a personal Gmail or any other external address.

## Frequently asked questions

**My rule isn't firing. Why not?**
Check, in order: is the rule **Active** (not Disabled)? Does the **Value** exactly match what's in the real message — including spelling, spacing, and the right field (a sender's name is in **From**, not **To**)? Is an earlier rule in the list already moving or deleting the message before this one gets a chance? Send yourself a test message that should match and see what happens.

**Two of my rules match the same message. Which one wins?**
Both. Each enabled rule that matches is applied, in top-to-bottom order. The final state of the message reflects all of them. If two rules conflict (one moves to Folder A, another moves to Folder B), the last one to run takes effect — so the order in your list matters.

**Can I turn a rule off for a while without deleting it?**
Yes. Click the toggle button in its row. The badge changes to **Disabled** and the rule is skipped until you toggle it back on.

**If a rule redirects a message, do I still get a copy?**
Yes. A redirect sends a copy on to the other address; the original still lands in your mailbox where your other rules can act on it.

**Does the redirect action work with my Vacation Auto-Reply?**
They're independent. Vacation Auto-Reply still triggers on the original delivery to your mailbox; the redirect just sends a separate copy onward.

**Can I match on a field that isn't in the list — like a custom header?**
Not from this page. The available fields are Subject, From, To, Cc, Bcc, and Size. If you need something more advanced, talk to your administrator.

**My rule's value is showing up wrong in the summary column.**
The summary shows what's stored. If it doesn't look right, open the rule with the pencil button and check the Value field — what you see in **Edit** is the truth.

**Can my administrator see my rules?**
They can see them in the underlying system, but day-to-day they aren't managed by anyone but you. If a rule isn't behaving the way you expect, you can ask an administrator to take a look.

**I picked Delete silently and now I'm worried I'll lose mail I wanted.**
You can. That action drops the message with no copy kept anywhere. If you have any doubt at all, use **Move to folder** to a folder called something like `_Maybe Spam` instead — you can review the folder occasionally and delete from there.

**Is there a daily summary or limit on how many rules I can have?**
There's no daily summary. There's no specific count limit you'll run into in normal use, but a long list of rules can get hard to keep track of — periodically review your list and delete or disable rules you no longer need.

## Where to next

- **Sender Filters** — different page, different purpose. Use Sender Filters when you want to change whether a message arrives at all; use Mail Filters when you want to change where it goes once it has.
- **Vacation Auto-Reply** — for setting an automatic reply while you're away, on a separate page.
- **Account Settings** — for your password, recovery email, timezone, and two-factor authentication.
