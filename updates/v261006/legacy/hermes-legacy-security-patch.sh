#!/usr/bin/env bash
#
# Hermes SEG security patch for legacy (non-Docker) installations.
# GHSA-4p63-cq8w-q87g. Run once as root: sudo bash hermes-legacy-security-patch.sh
# Idempotent. Originals are saved under /opt/hermes/backup/.

set -euo pipefail

if [[ $EUID -ne 0 && -z "${HERMES_PATCH_ROOT:-}" ]]; then
    echo "Run as root." >&2
    exit 1
fi

R="${HERMES_PATCH_ROOT:-}"   # test prefix; empty on a real server
WEBROOT="${R}/var/www/html"
API="${WEBROOT}/hermes-api/index.cfm"
ADMIN_CFC="${WEBROOT}/admin/Application.cfc"
KEY="${R}/opt/hermes/keys/hermes.key"
PATTERN='^[[:space:]]*location[[:space:]]+([=^~*]+[[:space:]]+)?/hermes-api/?([[:space:]]|[{]|$)'

if [[ ! -f "$API" || ! -f "$ADMIN_CFC" || ! -d "${R}/etc/nginx" ]]; then
    echo "This does not look like a legacy Hermes SEG installation. Nothing changed." >&2
    exit 1
fi

BK="${R}/opt/hermes/backup/ghsa-4p63-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BK"
chmod 700 "$BK"
backup() { cp -a --parents "$1" "$BK/"; }

# ---------------------------------------------------------------- 1. nginx
targets=()
for f in "${R}"/etc/nginx/sites-available/* "${R}"/etc/nginx/sites-enabled/* "${R}"/opt/hermes/templates/*; do
    [[ -f "$f" && ! -L "$f" ]] || continue
    [[ "$(basename "$f")" == *.BACKUP* ]] && continue
    grep -qE "$PATTERN" "$f" && targets+=( "$f" )
done

if (( ${#targets[@]} > 0 )); then
    pre_ok=0
    nginx -t >/dev/null 2>&1 && pre_ok=1

    for f in "${targets[@]}"; do
        backup "$f"
        if ! awk -v pat="$PATTERN" '
            eat { eat = 0; if ($0 ~ /^[[:space:]]*$/) next }
            !skip && $0 ~ pat { skip = 1; depth = 0; opened = 0 }
            skip {
                line = $0; sub(/#.*/, "", line)
                o = gsub(/\{/, "{", line); c = gsub(/\}/, "}", line)
                depth += o - c
                if (o > 0) opened = 1
                if (opened && depth <= 0) { skip = 0; eat = 1 }
                next
            }
            { print }
            END { if (skip) exit 3 }
        ' "$f" > "${BK}/tmp.new"; then
            echo "ERROR: could not parse the /hermes-api/ block in $f. Nothing changed in it." >&2
            echo "Remove the 'location /hermes-api/ { ... }' block by hand." >&2
            exit 1
        fi
        cat "${BK}/tmp.new" > "$f"
        rm -f "${BK}/tmp.new"
        echo "nginx: removed /hermes-api/ from $f"
    done

    if nginx -t >/dev/null 2>&1; then
        systemctl reload nginx
        echo "nginx: reloaded"
    elif (( pre_ok )); then
        for f in "${targets[@]}"; do cp -a "${BK}${f}" "$f"; done
        echo "ERROR: nginx rejected the edited config. Originals restored." >&2
        echo "Run 'nginx -t' to see why, then remove the block by hand." >&2
        exit 1
    else
        echo "WARNING: nginx was already rejecting its config before this patch; not reloaded." >&2
    fi
else
    echo "nginx: /hermes-api/ already removed"
fi

# ---------------------------------------------------------------- 2. API relay
if grep -q "allowedTargets" "$API"; then
    echo "hermes-api: already patched"
else
    backup "$API"
    cat > "$API" <<'CFML'
<cfset reqHeaders = GetHttpRequestData().headers>

<cfset allowedTargets = "/admin/2/inc/check_system_update.cfm,/admin/2/inc/download_system_update.cfm,/admin/2/inc/verify_system_update.cfm,/admin/2/inc/update_console_ip.cfm,/admin/2/inc/edit_ciphermail_settings.cfm,/admin/2/inc/generate_authelia_configuration.cfm,/admin/2/inc/check_hibp.cfm">

<cfset theIP = cgi.remote_addr>

<cfif NOT StructKeyExists(reqHeaders, "X-Token") OR Trim(reqHeaders["X-Token"]) is "">
    <cfoutput>Invalid Request: X-Token is missing</cfoutput>
    <cfabort>
</cfif>
<cfset theToken = Trim(reqHeaders["X-Token"])>

<cfif NOT StructKeyExists(reqHeaders, "X-Original-URL") OR Trim(reqHeaders["X-Original-URL"]) is "">
    <cfoutput>Invalid Request: X-Original-URL is missing</cfoutput>
    <cfabort>
</cfif>
<cfset theUrl = Trim(reqHeaders["X-Original-URL"])>

<cfif NOT REFind("^/[A-Za-z0-9/_.-]+\.cfm(\?[A-Za-z0-9._~%&=+@:,*-]*)?$", theUrl) OR NOT ListFind(allowedTargets, ListFirst(theUrl, "?"))>
    <cfoutput>Invalid Request: X-Original-URL is not permitted</cfoutput>
    <cfabort>
</cfif>

<cfquery name="gettoken" datasource="hermes">
    select ip from api_tokens
    where BINARY token = <cfqueryparam value="#theToken#" cfsqltype="cf_sql_varchar">
    and active = 1
</cfquery>

<cfif gettoken.recordcount NEQ 1>
    <cfoutput>Unauthorized Access: Invalid Token</cfoutput>
    <cfabort>
</cfif>

<cfset ipAllowed = false>
<cfloop index="theIpAddress" list="#gettoken.ip#" delimiters=",">
    <cfif Compare(theIP, Trim(theIpAddress)) EQ 0>
        <cfset ipAllowed = true>
    </cfif>
</cfloop>

<cfif NOT ipAllowed>
    <cfoutput>Unauthorized Access: Invalid IP</cfoutput>
    <cfabort>
</cfif>

<cfquery name="customtrans" datasource="hermes" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 32
</cfquery>

<cfquery name="inserttrans" datasource="hermes" result="stResult">
insert into salt (salt) values ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="hermes">
select salt as customtrans2 from salt where id = <cfqueryparam value="#stResult.GENERATED_KEY#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset VerifyToken = gettrans.customtrans2>

<cfquery name="deletetrans" datasource="hermes">
delete from salt where id = <cfqueryparam value="#stResult.GENERATED_KEY#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="createverifytoken" datasource="hermes">
    update api_tokens set verify = <cfqueryparam value="#VerifyToken#" cfsqltype="cf_sql_varchar">
    where BINARY token = <cfqueryparam value="#theToken#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfhttp method="POST" url="http://127.0.0.1:8888#theUrl#" encodeurl="false" charset="utf-8" timeout="10" throwonerror="false">
    <cfhttpparam type="header" name="accept" value="*/*">
    <cfhttpparam type="header" name="X-Token" value="#theToken#">
    <cfhttpparam type="header" name="X-Verify-Token" value="#VerifyToken#">
</cfhttp>

<cfoutput>Authorized</cfoutput><br>
<cfoutput>#cfhttp.fileContent#</cfoutput>
CFML
    echo "hermes-api: patched"
fi

# ---------------------------------------------------------------- 3. admin token check
OLD="WHERE token like binary '#theToken#' and verify like binary '#VerifyToken#'"
NEW='WHERE BINARY token = <cfqueryparam value="#theToken#" cfsqltype="cf_sql_varchar"> AND BINARY verify = <cfqueryparam value="#VerifyToken#" cfsqltype="cf_sql_varchar"> AND active = 1'
if grep -qF "$OLD" "$ADMIN_CFC"; then
    backup "$ADMIN_CFC"
    OLD="$OLD" NEW="$NEW" perl -0pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' "$ADMIN_CFC"
    if grep -qF "$OLD" "$ADMIN_CFC"; then
        cp -a "${BK}${ADMIN_CFC}" "$ADMIN_CFC"
        echo "ERROR: could not patch $ADMIN_CFC. Original restored." >&2
        exit 1
    fi
    echo "admin: patched"
elif grep -q 'BINARY token = <cfqueryparam' "$ADMIN_CFC"; then
    echo "admin: already patched"
else
    echo "WARNING: $ADMIN_CFC does not contain the expected query; left unchanged." >&2
fi

# ---------------------------------------------------------------- 4. key permissions
if [[ -f "$KEY" ]]; then
    chmod 600 "$KEY"
    echo "key: $KEY set to 600"
fi

echo
echo "Done. Originals saved in $BK"
echo "Check from outside the server: curl -sk https://<your-console-host>/hermes-api/ | grep -c 'Invalid Request'"
echo "0 means the route is closed."
