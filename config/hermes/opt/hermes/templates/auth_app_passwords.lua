-- Hermes SEG — Dovecot 2.4 passdb lua: app_passwords authentication (#197)
--
-- Stock Dovecot passdb sql is single-row only — it cannot iterate multiple
-- password hashes for the same user. This script bridges that gap: queries
-- all non-revoked rows for the username, tries each hash, returns OK on
-- the first match. This is what makes per-device app passwords work
-- (a user with iPhone + iPad + Laptop has three rows; any one is valid).
--
-- See docs/admin/authentication/01-credential-model.md for the full design.
--
-- This file is rendered from /opt/hermes/templates/auth_app_passwords.lua at
-- config-generation time. The DB_USER and DB_PASS literals below are
-- placeholders that get substituted by generate_dovecot_configuration.cfm
-- and patched in place by rotate_db_credentials.sh. Do not edit by hand.

-- Dovecot 2.4's bundled Lua does not initialize package.cpath with the
-- standard Debian/Ubuntu lua paths, so require "luasql.mysql" fails
-- silently. Prepend the canonical Lua 5.3 cpath so the lua-sql-mysql
-- package (.so at /usr/lib/x86_64-linux-gnu/lua/5.3/luasql/mysql.so)
-- can be found.
package.cpath = "/usr/lib/x86_64-linux-gnu/lua/5.3/?.so;" .. (package.cpath or "")

local mysql_driver = require "luasql.mysql"

local DB_HOST = "hermes_db_server"
local DB_PORT = 3306
local DB_NAME = "hermes"
local DB_USER = "hermes_db_username"
local DB_PASS = "hermes_db_password"

-- Throttle last_used_at writes: refresh at most once per hour per row.
-- IMAP IDLE clients re-authenticate frequently; without this, every IDLE
-- renewal would generate an UPDATE.
local LAST_USED_REFRESH_SECONDS = 3600

-- Open a fresh connection per lookup. With use_worker = yes in the passdb
-- block, lookups serialize within a worker, so connection-per-call is safe
-- and avoids the protocol-corruption risks of shared persistent connections.
local function db_connect()
    local env = mysql_driver.mysql()
    local conn, err = env:connect(DB_NAME, DB_USER, DB_PASS, DB_HOST, DB_PORT)
    if not conn then
        return nil, nil, err
    end
    return env, conn, nil
end

local function db_close(env, conn)
    if conn then conn:close() end
    if env then env:close() end
end

function auth_passdb_lookup(req)
    local env, conn, err = db_connect()
    if not conn then
        req:log_error("app_passwords: DB connect failed: " .. tostring(err))
        db_close(env, conn)
        return dovecot.auth.PASSDB_RESULT_INTERNAL_FAILURE, "db connect failed"
    end

    local q = string.format(
        "SELECT id, password, " ..
        "       UNIX_TIMESTAMP(last_used_at) AS last_used_ts " ..
        "  FROM app_passwords " ..
        " WHERE username = '%s' AND revoked_at IS NULL",
        conn:escape(req.user))

    local cur, qerr = conn:execute(q)
    if not cur then
        req:log_error("app_passwords: query failed: " .. tostring(qerr))
        db_close(env, conn)
        return dovecot.auth.PASSDB_RESULT_INTERNAL_FAILURE, "db query failed"
    end

    local rows = {}
    local row = cur:fetch({}, "a")
    while row do
        table.insert(rows, {
            id           = tonumber(row.id),
            password     = row.password,
            last_used_ts = tonumber(row.last_used_ts) or 0
        })
        row = cur:fetch({}, "a")
    end
    cur:close()

    if #rows == 0 then
        db_close(env, conn)
        return dovecot.auth.PASSDB_RESULT_USER_UNKNOWN, "no app password"
    end

    for _, r in ipairs(rows) do
        local ok = req:password_verify(r.password, req.password)
        if ok > 0 then
            local now = os.time()
            if (now - r.last_used_ts) > LAST_USED_REFRESH_SECONDS then
                local _, uerr = conn:execute(string.format(
                    "UPDATE app_passwords SET last_used_at = NOW() WHERE id = %d",
                    r.id))
                if uerr then
                    req:log_warning("app_passwords: last_used_at update failed: "
                                    .. tostring(uerr))
                end
            end
            db_close(env, conn)
            req:log_info("app_passwords: auth ok for " .. req.user
                         .. " (row id=" .. tostring(r.id) .. ")")
            -- Dovecot requires the matched password hash in the return
            -- table even when we've already verified manually. Without
            -- the `password` key Dovecot has no hash to verify and
            -- rejects auth despite our return code being OK. Empirically
            -- confirmed against 2.4.3 on 2026-04-28.
            return dovecot.auth.PASSDB_RESULT_OK, {password = r.password}
        end
    end

    db_close(env, conn)
    return dovecot.auth.PASSDB_RESULT_PASSWORD_MISMATCH, "no matching app password"
end

-- ===== userdb lua (#342) ==================================================
--
-- The userdb lives in this script, not in a `userdb sql` block. Loading
-- luasql.mysql next to Dovecot's own SQL driver in one auth-worker process
-- corrupted the heap whenever Dovecot's pooled userdb connection went stale
-- (idle timeout or a DB restart): the worker crashed, LMTP returned 451 and
-- doveadm returned "User lookup failed". With both lookups here, the process
-- loads one MySQL library and every lookup opens a fresh connection, so there
-- is no pooled connection to go stale.
--
-- The fields below are the same ones the old sql_query returned.

local function split_user(user)
    local username, domain = string.match(user, "^(.*)@([^@]*)$")
    if not username then
        return user, ""
    end
    return username, domain
end

function auth_userdb_lookup(req)
    local env, conn, err = db_connect()
    if not conn then
        req:log_error("userdb: DB connect failed: " .. tostring(err))
        db_close(env, conn)
        return dovecot.auth.USERDB_RESULT_INTERNAL_FAILURE, "db connect failed"
    end

    local cur, qerr = conn:execute(string.format(
        "SELECT quota FROM mailboxes WHERE username = '%s' AND active = '1'",
        conn:escape(req.user)))
    if not cur then
        req:log_error("userdb: query failed: " .. tostring(qerr))
        db_close(env, conn)
        return dovecot.auth.USERDB_RESULT_INTERNAL_FAILURE, "db query failed"
    end

    local row = cur:fetch({}, "a")
    cur:close()
    db_close(env, conn)

    if not row then
        return dovecot.auth.USERDB_RESULT_USER_UNKNOWN, "no such mailbox"
    end

    local username, domain = split_user(req.user)
    local home = "/srv/mail/" .. domain .. "/" .. username
    local fields = {
        home = home,
        mail = "maildir:" .. home,
        uid  = "1000",
        gid  = "1000"
    }

    -- Dovecot 2.4 replaced quota_rule with quota_storage_size (#397). It
    -- ignores quota_rule without complaint, so a limit sent the old way is
    -- never applied. No field, or 0, means unlimited.
    local quota = tonumber(row.quota)
    if quota and quota > 0 then
        fields.quota_storage_size = string.format("%.0fB", quota)
    end

    return dovecot.auth.USERDB_RESULT_OK, fields
end

-- Used by doveadm -A and anything else that lists users. Same set as the
-- old sql_iterate_query (all mailboxes, active or not).
function auth_userdb_iterate()
    local users = {}
    local env, conn, err = db_connect()
    if not conn then
        db_close(env, conn)
        return users
    end

    local cur = conn:execute("SELECT username FROM mailboxes")
    if cur then
        local row = cur:fetch({}, "a")
        while row do
            table.insert(users, row.username)
            row = cur:fetch({}, "a")
        end
        cur:close()
    end
    db_close(env, conn)
    return users
end
