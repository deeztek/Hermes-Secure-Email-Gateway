# Dovecot 2.3 to 2.4 Migration Tracker

**GitHub Issue**: deeztek/Hermes-Secure-Email-Gateway#182
**Current Version**: 2.3.21.1 (pinned in `.env` as `DOVECOTVERSION`)
**Target Version**: 2.4.x (latest stable)
**Online Converter**: https://dovecot.org/upgrader/

---

## Migration Status

| Task | Status | Notes |
|------|--------|-------|
| Research breaking changes | DONE | See below |
| Run online converter on current config | TODO | |
| Create parallel config set (`config/dovecot-2.4/`) | TODO | |
| Update Dockerfile for 2.4.x base image | TODO | |
| Test on DEV with separate container/ports | TODO | |
| Verify LDAP auth (passdb) | TODO | |
| Verify SQL userdb (mailboxes table) | TODO | |
| Verify quota enforcement + warnings | TODO | |
| Verify Sieve filters | TODO | |
| Verify mail_crypt encryption | TODO | |
| Verify LZ4 compression | TODO | |
| Verify LMTP delivery from Postfix | TODO | |
| Verify Fail2ban filter compatibility | TODO | |
| Verify quota-warning.sh API calls | TODO | |
| Switch DEV to 2.4.x | TODO | |
| Update CFML GUI settings (if any) | TODO | |
| Update documentation | TODO | |

---

## Config File Migration Map

### dovecot.conf

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| *(missing)* | `dovecot_config_version = 2.4.0` | TODO - REQUIRED |
| *(missing)* | `dovecot_storage_version = 2.4.0` | TODO - REQUIRED |
| `protocols = imap pop3 submission sieve lmtp` | Same (verify) | TODO |
| `mail_home = /srv/mail/%d/%n` | `mail_home = /srv/mail/%{user\|domain}/%{user\|username}` | TODO |
| `mail_location = maildir:~/` | `mail_driver = maildir` + `mail_path = ~/` | TODO |
| `mail_uid = 1000` | Same | OK |
| `mail_gid = 1000` | Same | OK |
| `mail_privileged_group = mail` | Same | OK |
| `login_trusted_networks = 172.16.32.0/24` | Same | OK |
| `auth_debug = yes` | `log_debug = category=auth` | TODO |
| `mail_debug = yes` | `log_debug = category=mail` | TODO |
| `log_path = /logs/dovecot.log` | Same (verify) | TODO |
| `info_log_path = /logs/dovecot-info.log` | Same (verify) | TODO |
| `debug_log_path = /logs/dovecot-debug.log` | Same (verify) | TODO |
| `mail_plugins = $mail_plugins quota zlib mail_crypt` | `mail_plugins { quota = yes; zlib = yes; mail_crypt = yes }` | TODO |
| `plugin { quota = dict:... }` | Global scope, new quota syntax | TODO |
| `plugin { quota_rule = ... }` | `quota_storage_size = ...` | TODO |
| `plugin { quota_rule2 = Trash:storage=+10%% }` | Per-mailbox quota setting | TODO |
| `plugin { quota_warning = ... }` | `quota_warning { }` named blocks | TODO |
| `plugin { sieve = /srv/mail/sieve/%u.sieve }` | `sieve_script { }` named block | TODO |
| `plugin { zlib_save = lz4 }` | Global setting (verify name) | TODO |
| `plugin { mail_crypt_global_private_key = <... }` | Global, remove `<` prefix | TODO |
| `plugin { mail_crypt_global_public_key = <... }` | Global, remove `<` prefix | TODO |
| `plugin { mail_crypt_curve = prime256v1 }` | Global setting | TODO |
| `plugin { mail_crypt_save_version = 2 }` | Global setting | TODO |
| `service lmtp { inet_listener lmtp { port = 24 } }` | Same (verify) | TODO |
| `service auth { inet_listener { port = 9587 } }` | Same (verify) | TODO |
| `protocol imap { mail_plugins = ... }` | Protocol block with new plugin syntax | TODO |
| `protocol pop3 { ... }` | Same structure (verify) | TODO |
| `protocol lmtp { mail_plugins = quota sieve }` | Protocol block with new plugin syntax | TODO |
| `namespace inbox { separator = / }` | Same (verify) | TODO |
| `mailbox Trash { special_use = \Trash }` | Same (verify) | TODO |

### 10-ssl.conf

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| `ssl = required` | Same (verify) | TODO |
| `ssl_cert = </path/fullchain.pem` | `ssl_server_cert_file = /path/fullchain.pem` | TODO |
| `ssl_key = </path/privkey.pem` | `ssl_server_key_file = /path/privkey.pem` | TODO |
| `ssl_min_protocol = TLSv1.2` | Same (verify) | TODO |
| `ssl_cipher_list = ALL:!DH:...` | Same (verify) | TODO |
| `ssl_prefer_server_ciphers = yes` | `ssl_server_prefer_ciphers = server` | TODO |
| `ssl_options = no_compression no_ticket` | Verify equivalent | TODO |

### 10-auth.conf

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| `auth_mechanisms = plain` | Same (verify) | TODO |
| `disable_plaintext_auth` | `auth_allow_cleartext` (inverted logic) | TODO |
| `!include auth-system.conf.ext` | Inline or restructured | TODO |

### auth-system.conf.ext → inline

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| `passdb { driver = ldap; args = ... }` | `passdb ldap_auth { ... }` named, inline | TODO |
| `userdb { driver = sql; args = ... }` | `userdb sql_auth { ... }` named, inline | TODO |

### dovecot-ldap-user.conf → inline

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| `uris = ldap://hermes_ldap:389` | `ldap_urls = ldap://hermes_ldap:389` | TODO |
| `auth_bind = yes` | Same | TODO |
| `auth_bind_userdn = cn=%u,...` | `auth_bind_userdn = cn=%{user},...` | TODO |
| `base = ou=users,...` | `ldap_base = ou=users,...` | TODO |

### dovecot-sql-user.conf → inline

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| `driver = mysql` | `sql_driver = mysql` | TODO |
| `connect = host=... dbname=...` | `mysql name { host=...; dbname=... }` | TODO |
| `user_query = SELECT ... WHERE username = '%u'` | `query = SELECT ... WHERE username = '%{user}'` | TODO |
| `iterate_query = SELECT username AS user ...` | Verify equivalent | TODO |

### dovecot-dict-sql-quota.conf → inline

| 2.3 Setting | 2.4 Setting | Status |
|-------------|-------------|--------|
| `connect = "host=..."` | Inline connection block | TODO |
| `map { pattern = priv/quota/storage }` | Verify new dict syntax | TODO |

---

## Settings Inventory for Web GUI

These settings will need to be configurable from the admin console once the Email Server GUI is built.

### Email Server > Settings Page
- [ ] Protocols enabled (IMAP, POP3, Submission, ManageSieve, LMTP)
- [ ] SSL/TLS mode (required/yes/no)
- [ ] SSL certificate path (link to System Certificates)
- [ ] Minimum TLS version
- [ ] Cipher list
- [ ] Login trusted networks (Docker subnet)
- [ ] Mail encryption enabled/disabled
- [ ] Mail encryption curve
- [ ] Mail compression algorithm (LZ4/zstd/none)
- [ ] Quota warning thresholds
- [ ] Trash quota exception percentage
- [ ] Auth debug toggle
- [ ] Mail debug toggle

### Email Server > Domains Page
- [ ] Domain name
- [ ] Domain-level mailbox settings
- [ ] Default quota for new mailboxes
- [ ] Backend server (for hybrid relay/mailbox)

### Email Server > Mailboxes Page
- [ ] Username (email address)
- [ ] Display name
- [ ] Per-user quota (bytes)
- [ ] Active/disabled toggle
- [ ] Current usage (from quota2 table)
- [ ] Password management (via LDAP)

### Nextcloud Integration
- [ ] Nextcloud mail server settings (IMAP/SMTP)
- [ ] Nextcloud user provisioning
- [ ] Nextcloud app password generation
- [ ] Nextcloud admin credentials (Docker secrets)

---

## Removed Features in 2.4 (verify not in use)

| Feature | Status | Impact |
|---------|--------|--------|
| `dsync` symlink | NOT USED | No impact |
| `doveadm batch` | NOT USED | No impact |
| `director` | NOT USED | No impact |
| `replicator` | NOT USED | No impact |
| `fts-lucene` | NOT USED | No impact |
| `fts-squat` | NOT USED | No impact |
| XZ compression | NOT USED (using LZ4) | No impact |
| `checkpassword` auth | NOT USED (using LDAP) | No impact |
| `shadow` auth | NOT USED (using LDAP) | No impact |
| Memcached | NOT USED | No impact |

---

## Testing Checklist

- [ ] Container starts without errors
- [ ] `doveconf -n` shows no warnings
- [ ] IMAP login works (Thunderbird/Outlook)
- [ ] POP3 login works
- [ ] LMTP delivery from Postfix works
- [ ] Sieve filters apply on delivery
- [ ] ManageSieve connects (port 4190)
- [ ] Quota enforcement works (reject over-quota)
- [ ] Quota warnings fire at thresholds
- [ ] Mail encryption (mail_crypt) — new messages encrypted
- [ ] Mail encryption — old messages still readable
- [ ] LZ4 compression applied to new messages
- [ ] SSL/TLS works with Let's Encrypt certs
- [ ] Auth via LDAP (password verification)
- [ ] User lookup via SQL (home, quota)
- [ ] Fail2ban detects failed logins
- [ ] quota-warning.sh API calls work
- [ ] Special mailboxes auto-created (Trash, Sent, Drafts, Spam, Archive)
