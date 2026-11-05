# Hash Blocklist

Admin path: **Content Checks > Hash Blocklist**
(`view_attachment_hash_blocklist.cfm`, `inc/add_attachment_hash_action.cfm`,
`inc/delete_attachment_hash_action.cfm`,
`inc/generate_attachment_hash_blocklist.cfm`).

This page blocks a known-bad file by its SHA-256 hash. ClamAV treats any
attachment with a listed hash as a virus, including files inside archives it
can open. The message then follows the **Virus Messages** setting under
[Antispam Settings](antispam-settings.md).

A hash matches one exact file. A file with even one changed byte has a
different hash and is not blocked, so this is for specific files you already
know about, such as one that got past filtering.

**Important:** use this for binary files and archives. A plain text attachment,
such as a `.txt` or a script, can have its line endings changed by the sender's
mail client, which changes its hash, so it may not match.

No third-party service is involved: hashes are kept on Hermes.

## Add a hash

1. Go to **Content Checks > Hash Blocklist**.
2. Click **Add Hash**.
3. In **SHA-256**, paste the 64-character hash.
4. In **File Size (bytes)**, enter the file's size if you know it. Leave it
   blank to match any size. Lookups are faster with a size.
5. In **Description**, enter a note for your own reference. This is optional.
6. Click **Add Hash**.

To get the hash and size of a file on Linux, where `suspect.pdf` is the file:

```bash
sha256sum suspect.pdf
stat -c %s suspect.pdf
```

## Remove a hash

Click the trash button on the row, then click **Remove**.

## How to recognize a match

Matched messages are reported with the virus name in the **Signature Name**
column, for example `Hermes.Blocklist.12.UNOFFICIAL`.

## How the list reaches ClamAV

Hermes writes the list to `/var/lib/clamav/hermes_hash_blocklist.hsb` in
`hermes_mail_filter`, then tells ClamAV to reload.

The new file is checked with `clamscan` before it replaces the current one,
because a malformed file stops ClamAV loading its signatures. If the check
fails, the change stays saved, ClamAV keeps using the previous list, and the
page shows an error. The reason is in the `hermes` log. When the list is empty,
the file is deleted, because ClamAV treats an empty file as malformed.
