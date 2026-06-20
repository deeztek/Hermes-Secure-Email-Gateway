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
