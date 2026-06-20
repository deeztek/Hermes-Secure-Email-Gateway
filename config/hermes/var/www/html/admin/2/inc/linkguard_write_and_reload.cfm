<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
LINK GUARD WRITE-AND-RELOAD (#186).

Single source that pushes all Link Guard config from the DB (parameters2
module='linkguard' rows + linkguard_domains + linkguard_url_rules) out to the
two consumers:

  1. body_milter (the SIGNER) -- files in the shared body_milter mount:
       /etc/hermes/body_milter/linkguard_hmac_key            current HMAC key
       /etc/hermes/body_milter/linkguard_hmac_key_previous   previous (rotation)
       /etc/hermes/body_milter/linkguard/linkguard_by_recipient_domain  scope map
       /etc/hermes/body_milter/linkguard/settings            base_url/ttl/etc

  2. hermes_linkguard (the VERIFIER) -- files in the linkguard mount:
       /etc/linkguard/config.json    settings + scope + url allow/block + api keys
       /etc/linkguard/api_key        management API bearer secret
       /etc/linkguard/keys/current.key, /etc/linkguard/keys/previous.key

Both containers mtime-watch their files and reload -- no docker exec, no signal.
For a REMOTE linkguard instance (linkguard_remote_mgmt_url set), the same
config + keys are also POSTed to the container's management API.

Canonical secrets live in /opt/hermes/keys/:
   linkguard_hmac_key, linkguard_hmac_key_previous, linkguard_api_key

Pass request.lgRotateKey = true to rotate the HMAC key (current -> previous,
generate a new current). Existing links stay valid through the token-TTL
overlap window because the verifier accepts current OR previous.

Sets session.linkguardApplySuccess (boolean) and session.linkguardApplyError.
--->

<cftry>

<!--- ---------- canonical key paths ---------- --->
<cfset keyCur      = "/opt/hermes/keys/linkguard_hmac_key">
<cfset keyPrev     = "/opt/hermes/keys/linkguard_hmac_key_previous">
<cfset apiKeyFile  = "/opt/hermes/keys/linkguard_api_key">

<!--- ---------- HMAC key: ensure / rotate ---------- --->
<cfset doRotate = (StructKeyExists(request, "lgRotateKey") AND request.lgRotateKey)>

<cfif doRotate AND FileExists(keyCur)>
    <!--- rotate: current -> previous, then generate a fresh current --->
    <cffile action="write" file="#keyPrev#" output="#Trim(FileRead(keyCur))#" charset="utf-8" addnewline="no">
    <cfset newKey = Hash(CreateUUID() & GetTickCount() & RandRange(100000, 999999), "SHA-256")>
    <cffile action="write" file="#keyCur#" output="#LCase(newKey)#" charset="utf-8" addnewline="no">
    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#DateTimeFormat(Now(), 'yyyy-mm-dd HH:nn:ss')#" cfsqltype="cf_sql_varchar">
        WHERE module = 'linkguard' AND parameter = 'hmac_key_rotated_at'
    </cfquery>
<cfelseif NOT FileExists(keyCur)>
    <!--- first run: generate the current key; no previous yet --->
    <cfset newKey = Hash(CreateUUID() & GetTickCount() & RandRange(100000, 999999), "SHA-256")>
    <cffile action="write" file="#keyCur#" output="#LCase(newKey)#" charset="utf-8" addnewline="no">
    <cfif NOT FileExists(keyPrev)>
        <cffile action="write" file="#keyPrev#" output="" charset="utf-8" addnewline="no">
    </cfif>
</cfif>

<cfset curKeyVal  = Trim(FileRead(keyCur))>
<cfset prevKeyVal = "">
<cfif FileExists(keyPrev)><cfset prevKeyVal = Trim(FileRead(keyPrev))></cfif>

<!--- ---------- management API key: ensure ---------- --->
<cfif NOT FileExists(apiKeyFile)>
    <cfset newApi = Hash(CreateUUID() & GetTickCount() & RandRange(100000, 999999), "SHA-256")>
    <cffile action="write" file="#apiKeyFile#" output="#LCase(newApi)#" charset="utf-8" addnewline="no">
</cfif>
<cfset apiKeyVal = Trim(FileRead(apiKeyFile))>

<!--- ---------- pull config from DB ---------- --->
<cfquery name="ss" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE module = 'linkguard'
</cfquery>
<cfset cfg = {}>
<cfloop query="ss"><cfset cfg[ss.parameter] = (IsNull(ss.value2) ? "" : ss.value2)></cfloop>
<cfset getC = function(k, d) { return (StructKeyExists(cfg, k) AND Len(cfg[k])) ? cfg[k] : d; }>

<!--- decrypt GSB/VT API keys (stored AES/Base64 with hermes.key) --->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
<cfset decKey = function(enc) {
    if (NOT Len(Trim(enc))) return "";
    try { return Decrypt(enc, authkey, "AES", "Base64"); } catch (any e) { return ""; }
}>
<cfset gsbKey = decKey(getC("gsb_api_key", ""))>
<cfset vtKey  = decKey(getC("vt_api_key", ""))>

<!--- scope domains (enabled) --->
<cfquery name="doms" datasource="hermes">
    SELECT domain FROM linkguard_domains WHERE enabled = 1 ORDER BY domain
</cfquery>
<cfset scopeList = []>
<cfloop query="doms"><cfset ArrayAppend(scopeList, LCase(Trim(doms.domain)))></cfloop>

<!--- url allow / block rules --->
<cfquery name="rules" datasource="hermes">
    SELECT rule_type, pattern FROM linkguard_url_rules
</cfquery>
<cfset allowList = []><cfset blockList = []>
<cfloop query="rules">
    <cfif rules.rule_type EQ "allow"><cfset ArrayAppend(allowList, LCase(Trim(rules.pattern)))>
    <cfelse><cfset ArrayAppend(blockList, LCase(Trim(rules.pattern)))></cfif>
</cfloop>

<!--- abused / redirector hosts (operator-managed, seeded) --->
<cfquery name="abused" datasource="hermes">
    SELECT host FROM linkguard_abused_hosts WHERE enabled = 1 ORDER BY host
</cfquery>
<cfset abusedList = []>
<cfloop query="abused"><cfset ArrayAppend(abusedList, LCase(Trim(abused.host)))></cfloop>

<!--- ---------- 1. body_milter config ---------- --->
<cfset lgDir = "/etc/hermes/body_milter/linkguard">
<cfif NOT DirectoryExists(lgDir)><cfdirectory action="create" directory="#lgDir#" mode="755"></cfif>

<!--- Master "Enable Link Guard" switch. The milter's applies_to gates on
     base_url + scope presence (it has no enabled flag of its own), so when the
     switch is OFF we write an empty scope map and empty base_url -> the milter
     stops rewriting NEW inbound mail. The HMAC keys are kept below so links
     ALREADY delivered keep resolving through their token TTL (graceful off);
     a license lapse does the harder key teardown via pro_milter_enforce.cfm. --->
<cfset lgEnabled = (getC("enabled", "0") EQ "1")>

<!--- scope map: "<domain>\t1" per enabled domain (presence = enabled) --->
<cfset mapLines = "">
<cfif lgEnabled>
    <cfloop array="#scopeList#" index="d"><cfset mapLines &= d & Chr(9) & "1" & Chr(10)></cfloop>
</cfif>
<cffile action="write" file="#lgDir#/linkguard_by_recipient_domain" output="#mapLines#" charset="utf-8" addnewline="no">

<!--- milter settings (key=value) --->
<cfset settingsTxt = "">
<cfset settingsTxt &= "base_url = " & (lgEnabled ? getC("redirect_base_url", "") : "") & Chr(10)>
<cfset settingsTxt &= "token_ttl_days = " & getC("token_ttl_days", "14") & Chr(10)>
<cfset settingsTxt &= "max_inline_url = " & getC("max_inline_url", "1200") & Chr(10)>
<cfset settingsTxt &= "restore_outbound = " & getC("restore_outbound", "1") & Chr(10)>
<cffile action="write" file="#lgDir#/settings" output="#settingsTxt#" charset="utf-8" addnewline="no">

<!--- HMAC keys into the body_milter mount (signer reads current; restore reads both) --->
<cffile action="write" file="/etc/hermes/body_milter/linkguard_hmac_key" output="#curKeyVal#" charset="utf-8" addnewline="no">
<cffile action="write" file="/etc/hermes/body_milter/linkguard_hmac_key_previous" output="#prevKeyVal#" charset="utf-8" addnewline="no">

<!--- ---------- 2. linkguard container config ---------- --->
<cfset lgcDir = "/etc/linkguard">
<cfset lgcKeys = "/etc/linkguard/keys">
<cfif NOT DirectoryExists(lgcDir)><cfdirectory action="create" directory="#lgcDir#" mode="755"></cfif>
<cfif NOT DirectoryExists(lgcKeys)><cfdirectory action="create" directory="#lgcKeys#" mode="755"></cfif>

<cfset settingsStruct = {
    "enabled": (getC("enabled","0") EQ "1"),
    "action_clean": getC("action_clean","redirect"),
    "action_suspicious": getC("action_suspicious","warn"),
    "action_malicious": getC("action_malicious","block"),
    "token_ttl_days": Val(getC("token_ttl_days","14")),
    "max_inline_url": Val(getC("max_inline_url","1200")),
    "rate_limit_per_min": Val(getC("rate_limit_per_min","120")),
    "follow_redirects": (getC("follow_redirects","0") EQ "1"),
    "follow_max_hops": Val(getC("follow_max_hops","5")),
    "flag_cloud_storage": (getC("flag_cloud_storage","1") EQ "1"),
    "cache_ttl_clean_hours": Val(getC("cache_ttl_clean_hours","24")),
    "cache_ttl_suspicious_hours": Val(getC("cache_ttl_suspicious_hours","6")),
    "cache_ttl_malicious_hours": Val(getC("cache_ttl_malicious_hours","168")),
    "feed_refresh_minutes": Val(getC("feed_refresh_minutes","60")),
    "clicks_retention_days": Val(getC("clicks_retention_days","90")),
    "feed_urlhaus_enabled": (getC("feed_urlhaus_enabled","1") EQ "1"),
    "feed_openphish_enabled": (getC("feed_openphish_enabled","1") EQ "1"),
    "gsb_enabled": (getC("gsb_enabled","0") EQ "1"),
    "vt_enabled": (getC("vt_enabled","0") EQ "1"),
    "gsb_api_key": gsbKey,
    "vt_api_key": vtKey,
    "brand_name": "Hermes Secure Email Gateway",
    "support_contact": ""
}>
<cfset cfgStruct = {
    "settings": settingsStruct,
    "scope_domains": scopeList,
    "url_allow": allowList,
    "url_block": blockList,
    "abused_hosts": abusedList
}>
<!--- The container lowercases top-level keys on load, so SerializeJSON's
     uppercasing is harmless. --->
<cffile action="write" file="#lgcDir#/config.json" output="#SerializeJSON(cfgStruct)#" charset="utf-8" addnewline="no">
<cffile action="write" file="#lgcDir#/api_key" output="#apiKeyVal#" charset="utf-8" addnewline="no">
<cffile action="write" file="#lgcKeys#/current.key" output="#curKeyVal#" charset="utf-8" addnewline="no">
<cffile action="write" file="#lgcKeys#/previous.key" output="#prevKeyVal#" charset="utf-8" addnewline="no">

<!--- ---------- remote instance push: DESCOPED for v260612 (#186) ----------
     An off-box Link Guard container has no way to bootstrap the shared
     management api_key (the entrypoint doesn't generate one and nothing seeds
     it remotely), so every /api/config|keys|stats POST 401'd. Remote mode is
     deferred to a follow-up; only the in-stack file push above runs. --->

<cfset session.linkguardApplySuccess = true>
<cfset session.linkguardApplyError = "">

<cfcatch type="any">
    <cfset session.linkguardApplySuccess = false>
    <cfset session.linkguardApplyError = cfcatch.message & " " & cfcatch.detail>
</cfcatch>
</cftry>
