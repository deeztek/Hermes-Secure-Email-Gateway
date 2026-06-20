# Shared Folders

This is where you let other people in your organization see one of your mailbox folders in their own mail app — and where you see folders that other people have shared with you.

## The short version

A **shared folder** is one of your mailbox folders — an Inbox subfolder, your Sent folder, a folder you made yourself — that you allow another person to also see in their own mail app. They get a copy of the same folder in their account; when new mail arrives in it, both of you see it. When one of you deletes a message, both of you see it gone. It is the same physical folder, viewed from two accounts.

A typical use is a team inbox. Say you have a folder called *Sales* under your Inbox where all the sales inquiries land. You can share it with two colleagues so that all three of you can read, file, and reply to those messages from your own mail app, without anyone having to forward anything or log in as somebody else.

This page lets you do four things:

- See which of your folders you've already shared, and with whom.
- Share another folder with another person in your organization.
- Stop sharing a folder.
- See which folders other people have shared with you.

You can only share with other mailbox users on the same domain. You can't share with someone at a different company, and you can't share a folder you don't own.

This page only exists for mailbox users, and only when your administrator has turned folder sharing on at the server. If sharing is off, the page tells you so and there's nothing else to do here.

## What the page shows

The page is split into two cards.

**My Shared Folders** (top card). This is everything you have shared with other people. It shows:

- A short reminder of how shared folders work and where they appear in the recipient's mail app (under a `Shared/` namespace).
- A note about Nextcloud Mail caching (covered below).
- A **Share a Folder** form with three fields: *Folder Path*, *Share With*, and *Permissions*.
- A table of your existing shares with one row per share:

| Column | What it shows |
| --- | --- |
| **Folder** | The path of the folder you shared (for example, `INBOX/Sales`). |
| **Shared With** | The email address of the person you shared it with. |
| **Permissions** | Coloured badges — **Read** (green), **Write** (yellow), **Delete** (red) — showing what they can do. |
| **Actions** | A red **Revoke** button that stops the share. |

If you haven't shared anything yet, the table is replaced with a short message.

**Shared With Me** (bottom card). This is everything other people have shared with you. It shows a short reminder about subscribing, and a table:

| Column | What it shows |
| --- | --- |
| **Owner** | The email address of the person who shared it. |
| **Folder** | The path of their folder. |
| **Permissions** | The same Read / Write / Delete badges, showing what they let you do. |

Note there is **no Revoke button** on this card. Only the person who owns the folder can stop a share. If a folder has been shared with you and you don't want to see it any more, ask the owner to revoke it, or unsubscribe from it in your mail app.

## Sharing a folder

1. In the **Folder Path** field, pick a folder. The dropdown autocompletes from the list of folders that already exist in your mailbox — start typing and it will narrow the list. If the folder you want isn't there yet, you can also type a custom path (for example, `INBOX/Projects/Acme`) and it will accept it.
2. In the **Share With** field, pick the person to share with. The list is restricted to other mailbox users in your domain. If the dropdown is empty, you're the only mailbox user in your domain and there's no one to share with.
3. In **Permissions**, check the boxes for what the recipient should be able to do:
   - **Read** — they can see messages in the folder and read them. This is checked by default and is the minimum useful permission.
   - **Write** — they can move messages into the folder and mark messages as read.
   - **Delete** — they can delete messages from the folder. If you also gave Write, they can move messages out, which is effectively a delete from the folder's point of view.
4. Click the blue **Share Folder** button. The page reloads and the new share appears in the My Shared Folders table below.

Pick the lowest permission level that does the job. If the recipient only needs to see what's in the folder, leave it at Read. If they're meant to help you process the folder, give Write and Delete too.

## Stopping a share

1. Find the row in the **My Shared Folders** table for the folder and person you want to stop sharing with.
2. Click the red **Revoke** button on the right.
3. A confirmation box appears asking *"Are you sure you want to revoke this folder share?"* — click **OK** to confirm or **Cancel** to back out.

The share is removed immediately. The next time the recipient's mail app refreshes, the folder disappears from their account. Their messages are not affected — the folder still exists in your mailbox, with everything in it. You've just taken the recipient's access away.

If you change your mind, you can share it again right away. Permissions and any earlier sharing arrangement are not remembered, so set the checkboxes again from scratch.

## When someone shares a folder with you

If somebody shares one of their folders with you, it shows up in the **Shared With Me** card on this page right away. Seeing it in your **mail app** takes one more step, and the step depends on which mail app you use.

**Nextcloud Mail (the built-in webmail).** Nextcloud Mail caches its folder list once when the account is first set up, and it does **not** automatically pick up folders that are shared with you later. If a folder appears in your Shared With Me list but you don't see it in Nextcloud Mail, do this:

1. Open the webmail.
2. Go to **Settings &rarr; Mail accounts**.
3. Find your account and remove it.
4. Add it back using the same credentials.

That fresh setup re-reads your full folder tree from the server, and the shared folder will show up under a `Shared/` heading along with the rest. You only have to do this when a *new* share is added; existing shares survive.

**Thunderbird.** Thunderbird sees shared folders the moment it refreshes its folder list. To refresh:

1. Right-click your account in the folder list on the left.
2. Choose **Subscribe**.
3. Click **Refresh**, tick the box next to the shared folder, and click **OK**.

The shared folder appears under a `Shared/` heading.

**Outlook (desktop).** Right-click your account, choose **IMAP Folders**, click **Query**, then highlight the new shared folder and click **Subscribe**. The folder appears in your account's folder tree.

**Apple Mail (iOS or macOS).** Pull-to-refresh in the Mailboxes screen, or go to the account's mailbox list and tap **Edit** to confirm the new folder is ticked.

If the folder still doesn't show up after the refresh step for your app, double-check the **Shared With Me** card on this page — if the share isn't there, it was never created (or was already revoked). If the share *is* there but your mail app isn't showing it, repeat the refresh step; for Nextcloud Mail specifically, do the remove-and-re-add.

## What this page does NOT do

A few things this page is not for:

- **You can only share folders you own.** You can't share somebody else's folder onward, and you can't share a folder that doesn't exist in your mailbox.
- **You can only share within your organization.** The Share With dropdown is limited to other mailbox users on your domain. There is no way to share with an external email address — for that, the right tool is forwarding (set up by the administrator) or simply copying the recipient on the original messages.
- **Sharing is not forwarding.** Both people see the same physical folder. There is no second copy, and messages are not duplicated. If the owner moves a message out of the folder, it disappears for everyone with access. If the owner deletes the folder entirely, the shares go with it.
- **Shared permissions stop at the folder.** Giving someone Read on your `INBOX/Sales` folder does not let them see your other folders, your account settings, or anything else. The permission is scoped to the one folder.
- **No recursive sharing.** Subfolders inside a shared folder are **not** automatically shared too. If you share `INBOX/Projects` and there's an `INBOX/Projects/Acme` subfolder, the recipient sees `Projects` but not `Acme`. Share the subfolder separately if you want them to see it.

## Common scenarios

**Sharing a team inbox with a colleague.**
You have an `INBOX/Sales` folder you use for incoming sales inquiries. Pick `INBOX/Sales` in the Folder Path dropdown, pick your colleague in the Share With dropdown, tick **Read**, **Write**, and **Delete**, and click Share Folder. Tell them to refresh their mail app (or, for Nextcloud Mail, remove and re-add their account) and they'll see the folder under `Shared/` and can file, reply, and clean up alongside you.

**Sharing a project folder with multiple people.**
Share the folder once with each person. Each person gets their own row in the My Shared Folders table, and each row can have different permissions if you want — for example, the project lead might get Read + Write + Delete, while a junior team member only gets Read.

**Stopping a share when someone leaves the team.**
Go to the My Shared Folders table, find every row that lists the departing person in the Shared With column, and click **Revoke** on each one. They lose access immediately on their next mail-app refresh.

**"I shared a folder but they say they can't see it."**
The most common cause is that they're using Nextcloud Mail and their folder list is cached. Walk them through removing and re-adding their account in **Webmail &rarr; Settings &rarr; Mail accounts**. If they're on Thunderbird or Outlook, walk them through the Subscribe step described above. If none of that works, check the My Shared Folders table on your end to confirm the share row is actually there with the right address spelled correctly.

**Cleaning up old shares.**
Skim the My Shared Folders table every now and then. Anyone who no longer needs access to a folder you shared a while back should be revoked, both to keep the list manageable and as a basic hygiene measure.

## Frequently asked questions

**Can I share with someone outside the company?**
No. The Share With dropdown only contains other mailbox users on your own domain. If you need to send mail outside your organization, that's regular email — not a shared folder.

**Can I share with someone who only has a relay account?**
No. Relay-only users have no mailbox here, so there's nothing for a shared folder to appear in on their end. Only mailbox users show up in the Share With dropdown.

**What happens to the shared folder if I delete it?**
Deleting your own folder also removes everyone's access to it, because there's nothing left to share. Empty the folder first (or move its contents elsewhere) if you want to keep the messages.

**Does the recipient see folders inside the shared folder?**
No. Sharing is per folder, not recursive. If you want them to see a subfolder too, share that subfolder separately.

**Does sharing my Sent folder share my drafts too?**
No. Sent and Drafts are separate folders. Sharing one does not affect the other.

**Can the recipient share the folder onward with someone else?**
No. Only the folder's owner can share it. If a third person also needs access, you have to share with them yourself.

**The recipient said they can't see the folder in Nextcloud Mail. Why?**
Nextcloud Mail caches its folder list when the account is first set up and does not refresh it when new folders are shared later. They have to go to **Webmail &rarr; Settings &rarr; Mail accounts**, remove their account, and add it back. After the fresh setup the shared folder appears under `Shared/`. This is a known limitation of Nextcloud Mail, not something you've done wrong.

**Where do shared folders appear in the recipient's mail app?**
Under a heading called `Shared/`, with one entry per share. The entry is named after the original folder path and the owner's address, so the recipient can tell who shared what.

**If I give someone Write but not Delete, can they still move messages?**
They can move messages **into** the folder, and they can mark messages as read. Moving a message **out** of the folder is effectively a delete from the folder's point of view, so that takes the Delete permission.

**Does the recipient see when new mail arrives in a shared folder?**
Yes, as soon as their mail app next refreshes that folder. Most apps poll every few minutes, so it's effectively live.

## Where to next

- **Mail Filters** — sort incoming mail into folders automatically so the folder you eventually share is already populated and organized.
- **My App Passwords** — if a recipient is having trouble connecting their mail app at all, they'll need an app password first before any folder you share with them is reachable.
- **Set Up Your Devices** — step-by-step mobile setup wizards. Useful to send to a recipient who hasn't set up their mail app yet and needs to before they can see anything you share.
