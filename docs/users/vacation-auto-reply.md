# Vacation Auto-Reply

This is where you set up an automatic reply that goes out to people who email you while you're away.

## The short version

A vacation auto-reply is a short message Hermes sends back automatically when mail arrives for you — to let the sender know you're not reading mail right now and when you'll be back. Most people set one up the day before they leave on vacation, fill in a start and end date, write a one-paragraph message, click Save, and then forget about it. Hermes turns it on at the start time, sends replies while you're away, and turns it off again at the end time.

You get a single Settings card on this page. From top to bottom you'll find a master on/off switch, a Subject and Message for the reply itself, an optional restriction on which of your addresses it should fire for, the dates and times when it should be active, and a couple of advanced toggles for unusual cases. There's a banner at the top of the page that tells you, at a glance, whether the auto-reply is currently active.

This page is **mailbox users only**. If you sign in as a relay-only user you'll see a "Not Available" notice instead.

## What the page shows

At the top, a banner that reflects the current state of your auto-reply:

- **Green banner — Auto-reply is currently ACTIVE.** The auto-reply is turned on and right now is between your start and end dates. The banner tells you when it stops.
- **Grey banner — Auto-reply is enabled but not currently active.** You've turned it on, but the start date hasn't arrived yet (or the end date is already in the past). The banner explains which.
- **No banner.** The auto-reply is turned off.

Below that, the **Settings** card has these fields:

| Field | What it does |
| --- | --- |
| **Enable vacation auto-reply** | The master switch. When off, none of the other fields matter — no replies will be sent. |
| **Subject** | The subject line of the reply that goes back to the sender. Required when enabled, up to 255 characters. |
| **Message** | The body of the reply. Plain text only. Required when enabled. |
| **Reply only when message is addressed to** | Optional. A multi-select of your primary address plus any aliases. Empty means reply to any message that reaches you. Pick one or more to restrict the auto-reply to only fire when mail is sent *directly* to those addresses (so for example you can auto-reply when someone writes to `sales@` but not when you're just Cc'd on something else). |
| **Start date and time** | Optional. The exact moment the auto-reply starts. If left empty, the auto-reply is active from the moment you save. |
| **End date and time** | Optional. The exact moment the auto-reply stops. If left empty, the auto-reply stays active until you turn it off manually. |
| **Reply interval (days)** | How long to wait before replying to the same sender a second time. Default 7. See "How auto-reply decides whether to send" below. |
| **Also reply to external senders** | Off by default. When off, only people inside your own organization get an auto-reply. When on, anyone who emails you gets one — see the warning below. |
| **Delete incoming messages while away** | Off by default. When on, every message that triggered an auto-reply is *also* permanently deleted from your inbox. Use with care — see "Common scenarios" for when this might be appropriate. |

When you're done, click **Save Settings**. The change takes effect immediately — Hermes regenerates your mail filtering script as part of the save.

## Setting up an auto-reply

1. Turn on **Enable vacation auto-reply** at the top of the card.
2. Edit the **Subject** if the default ("Out of office") doesn't suit you.
3. Edit the **Message** body. Keep it short — three or four sentences is plenty. State that you're out, when you'll be back, and who to contact in the meantime if it's urgent.
4. Leave **Reply only when message is addressed to** empty unless you have a specific reason to restrict it.
5. Pick a **Start date and time** and an **End date and time** using the date/time pickers. You can leave either or both empty — see the next section for what that means.
6. Leave **Reply interval (days)** at 7 unless you have a reason to change it.
7. Leave **Also reply to external senders** and **Delete incoming messages while away** off unless you've read the warnings below and have a specific need.
8. Click **Save Settings**. You should see a green "Saved!" banner, and the banner at the top of the page should now show your auto-reply state.

That's it. You can close the page and forget about it — Hermes handles the rest.

## Date scoping and timezone

Two things to know about how dates work on this page.

**Start and end dates are inclusive and use date *and* time, not just date.** The pickers are date-and-time pickers — you set the exact hour and minute the auto-reply starts and stops. This is more flexible than the on/off toggle you may have used on other systems: you can set it to start at 5:00 PM on a Friday and end at 8:00 AM on a Monday, and it will turn itself on and off at exactly those times. You don't have to remember to flip a switch.

**Either date is optional.** Leave them both empty and the auto-reply is active from the moment you save until you turn it off manually. Set just a start and the auto-reply runs from that moment until you turn it off. Set just an end and the auto-reply runs from now until that moment. Set both and you've defined a window.

**All times use your mailbox timezone.** The card shows a small banner that reads *"Times below are interpreted in your timezone: ..."* with your current timezone listed. So if it says `America/New_York` and you set an end time of `6:00 PM`, the auto-reply stops at 6:00 PM Eastern, regardless of where in the world you actually are while you're away.

**This matters if your timezone is wrong.** If the banner shows a timezone that doesn't match where you live, click the **Change timezone** link in that banner — it takes you to **Account Settings**, where you can fix it. Otherwise your auto-reply could start hours earlier or later than you expect.

## What recipients see

When someone emails you while the auto-reply is active, they get a separate reply email that comes from your address with the Subject and Message you set on this page. There's no "Auto:" prefix added — the subject is exactly what you typed.

The original message still lands in your mailbox normally (unless you've turned on **Delete incoming messages while away**, in which case it gets dropped after the reply is sent). The auto-reply does not get sent to *you*; it gets sent to whoever wrote to you.

Keep the message conversational and don't include sensitive information — anyone who emails your address will receive it, including people you don't know.

## How auto-reply decides whether to send

A vacation responder that replied to every single incoming message would be a disaster — it would reply to mailing lists, bounce notifications, the daily newsletter, your colleague's "lunch?" question (five times if they emailed five times), and to other people's vacation auto-replies, sometimes creating endless loops. Hermes is more careful than that. A reply is *only* sent if all of the following are true:

- The auto-reply is **enabled** and the current time is between the start and end dates (if set).
- The sender hasn't already received an auto-reply from you in the last **N days**, where N is the **Reply interval (days)** value (default 7). So if Alice emails you on Monday and again on Wednesday, Alice gets one reply on Monday, not two.
- The message looks like personal mail, not bulk mail. Hermes uses the same checks as standard vacation responders: it skips mailing-list messages (anything with `List-Id`, `List-Unsubscribe`, or similar headers), bounce notifications, and messages with auto-submitted or precedence headers indicating they're machine-generated.
- If you set **Reply only when message is addressed to**, the message must be addressed *directly* to one of the addresses you picked — being Cc'd or Bcc'd doesn't count.
- If **Also reply to external senders** is off, the sender's address must be inside one of the domains your organization owns. External senders are silently skipped.

If any one of those is false, the message reaches your mailbox normally but no auto-reply is sent.

## Common scenarios

**Going on a 1-week vacation.**
Enable the auto-reply. Subject: *"Out of office — back [date]"*. Message: a couple of sentences explaining when you'll return and who to contact for urgent matters. Start date: 5:00 PM the day you leave. End date: 8:00 AM the day you return. Reply interval: 7 days. Leave the rest at defaults. Save.

**Half-day out of the office.**
Same as above, just with a shorter window — for example, start at 12:00 PM and end at 5:00 PM the same day. The date-and-time pickers handle this naturally.

**Recurring weekly availability (e.g., out every Friday).**
This page doesn't support recurring schedules — you'd have to enable and disable it manually each week. For something this regular, consider whether a brief signature line in your normal mail ("Note: I don't reply to mail on Fridays") would do the job better.

**Extending an active auto-reply.**
Come back to this page, change the **End date and time** to the new return date, and click **Save Settings**. The auto-reply stays active without interruption.

**Out of the office and you don't want a pile of mail to deal with on return.**
Enable **Delete incoming messages while away**. Each sender still gets the auto-reply telling them you're out, but the original messages are permanently deleted from your inbox. *Be careful here* — this is irreversible, and if you forget to disable it when you come back, you will keep losing mail. Only use it if you're sure you don't need to read what comes in.

## Frequently asked questions

**Will my auto-reply fire when I'm Cc'd?**
Yes, by default — Hermes treats anything that reaches your mailbox the same way. If you don't want that, use **Reply only when message is addressed to** and pick just your primary address. Then only messages addressed directly to that address (not Cc or Bcc) trigger a reply.

**Does it reply to internal mail or just external?**
By default, only internal senders (people inside your organization) get an auto-reply. External senders are silently skipped. If you want external senders to get a reply too, enable **Also reply to external senders** — but read the warning the page shows when you do. Confirming your address to spammers and announcing your absence publicly are both real risks.

**What happens if I set the end date in the past?**
The auto-reply stays in the "enabled but not currently active" state, and the banner at the top of the page tells you the end date has passed. No replies are sent. To fix it, either update the dates or turn the auto-reply off entirely.

**Can I delete the auto-reply instead of leaving an end date?**
The page doesn't have a Delete button — you turn the auto-reply *off* by unticking **Enable vacation auto-reply** and clicking **Save Settings**. Your subject, message, dates, and other settings are kept so you can re-enable them later without typing everything in again. If you really want to wipe the slate clean, blank out the subject, body, and dates before saving.

**Why didn't a sender get my auto-reply?**
Most common causes, in order: they emailed you in the last N days (the reply interval) so they were skipped; their address is external and **Also reply to external senders** is off; their message looks like bulk or mailing-list mail; you set **Reply only when message is addressed to** and their message went to a different address; or your start or end date excludes the moment they emailed you. The banner at the top of the page tells you whether the auto-reply is active *right now*.

**Does the auto-reply reply to itself if two people both have it on?**
No. Mail-system-generated messages (including vacation auto-replies) carry headers that mark them as auto-submitted, and Hermes' responder skips those.

**Does the auto-reply reply to my own messages I send to myself?**
No — your own address is excluded from the auto-reply, the same way mailing lists and bots are.

**Will senders get the auto-reply every time they email me, or just once?**
Once per **Reply interval (days)** period. With the default of 7, a sender who emails you five times during a week-long vacation gets exactly one auto-reply.

**Can I include HTML or images in the message?**
No — the message is plain text only. It's intentionally simple: short, machine-readable, and friendly to every mail client.

**The auto-reply is on but the banner says it isn't active. What's wrong?**
Either your start date is still in the future (the banner will say so), or your end date is already in the past (it'll say that too). Update the dates so "now" falls between them, or leave them both empty for an indefinite window.

**I changed my timezone after setting up the auto-reply. Do my dates still mean the same thing?**
The wall-clock numbers (like "6:00 PM") stay the same, but they're now evaluated in your new timezone — so the absolute time shifts. Account Settings shows a warning about this when you change timezones with an active auto-reply. If you're not sure, come back to this page and double-check the dates.

## Where to next

- **Account Settings** — set your timezone so auto-reply dates are interpreted correctly.
- **Mail Filters** — for more elaborate handling of incoming mail while you're away (auto-file, redirect, mark as read).
- **Notification Settings** — turn quarantine notifications off (or leave them on) for the period you're away.
