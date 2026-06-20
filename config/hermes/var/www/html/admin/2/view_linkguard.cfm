<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
LINK GUARD (##186) -- time-of-click safe-links admin (Pro Edition).

Single-page admin. Action handlers run BEFORE any output: each mutates the DB,
calls inc/linkguard_write_and_reload.cfm to push config + keys to the body
milter (signer) and the hermes_linkguard container (verifier), sets
session.m/alerttype/alertmsg, and cflocations back (per the Hermes
action-handler convention).

Remote (off-box) instance mode is DESCOPED for v260612 (#274): this page drives
only the in-stack container.
--->

<cfparam name="form.lg_action" default="">

<cfif Len(form.lg_action)>
    <!--- Pro gate on the ACTION handlers (not just the page render below). --->
    <cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
        <cfset session.m = 1>
        <cfset session.alerttype = "danger">
        <cfset session.alertmsg = "Pro license required for Link Guard.">
        <cflocation url="view_linkguard.cfm" addtoken="false">
    </cfif>

    <!--- shared URL-rule validator (used by add_rule + edit_rule) --->
    <cfset lgRuleError = function(ruleType, rp) {
        if (NOT ListFindNoCase("allow,block", ruleType)) return "Choose allow or block.";
        if (NOT Len(rp)) return "Enter a host or host/path.";
        if (FindNoCase("://", rp)) return "Enter a host or host/path only -- drop the http:// or https:// prefix.";
        if (REFind("[[:space:]]", rp)) return "The pattern cannot contain spaces.";
        if (Find("*", rp)) return "Wildcards are not supported. A bare host already covers its subdomains.";
        if (NOT REFind("^([a-z0-9]([a-z0-9\-]*[a-z0-9])?\.)+[a-z]{2,}(/\S*)?$", rp)) return "That is not a valid host or host/path (examples: example.com or example.com/login).";
        return "";
    }>

    <!--- shared abused-host validator (used by add_abused_host) --->
    <cfset lgHostError = function(h) {
        if (NOT Len(h)) return "Enter a host.";
        if (FindNoCase("://", h)) return "Enter a host only -- drop the http:// or https:// prefix.";
        if (Find("/", h)) return "Enter a host only (no path).";
        if (REFind("[[:space:]]", h)) return "The host cannot contain spaces.";
        if (Find("*", h)) return "No wildcards -- a bare host already covers its subdomains.";
        if (NOT REFind("^([a-z0-9]([a-z0-9\-]*[a-z0-9])?\.)+[a-z]{2,}$", h)) return "That is not a valid host (example: badhost.example).";
        return "";
    }>

    <cftry>
    <cfswitch expression="#form.lg_action#">

        <cfcase value="save_settings">
            <cfset up = {
                "enabled": (StructKeyExists(form,'enabled') ? '1' : '0'),
                "redirect_base_url": Trim(form.redirect_base_url),
                "action_suspicious": form.action_suspicious,
                "action_malicious": form.action_malicious,
                "restore_outbound": (StructKeyExists(form,'restore_outbound') ? '1' : '0'),
                "token_ttl_days": Val(form.token_ttl_days),
                "max_inline_url": Val(form.max_inline_url),
                "rate_limit_per_min": Val(form.rate_limit_per_min),
                "flag_cloud_storage": (StructKeyExists(form,'flag_cloud_storage') ? '1' : '0'),
                "follow_redirects": (StructKeyExists(form,'follow_redirects') ? '1' : '0'),
                "follow_max_hops": Val(form.follow_max_hops),
                "feed_refresh_minutes": Val(form.feed_refresh_minutes),
                "clicks_retention_days": Val(form.clicks_retention_days),
                "cache_ttl_clean_hours": Val(form.cache_ttl_clean_hours),
                "cache_ttl_suspicious_hours": Val(form.cache_ttl_suspicious_hours),
                "cache_ttl_malicious_hours": Val(form.cache_ttl_malicious_hours)
            }>
            <cfloop collection="#up#" item="k">
                <cfquery datasource="hermes">
                    UPDATE parameters2 SET value2 = <cfqueryparam value="#up[k]#" cfsqltype="cf_sql_varchar">
                    WHERE module = 'linkguard' AND parameter = <cfqueryparam value="#k#" cfsqltype="cf_sql_varchar">
                </cfquery>
            </cfloop>
            <cfinclude template="./inc/linkguard_write_and_reload.cfm">
            <cfset session.m = 1>
            <cfif session.linkguardApplySuccess>
                <cfset session.alerttype = "success"><cfset session.alertmsg = "Link Guard settings saved and pushed to the engine.">
            <cfelse>
                <cfset session.alerttype = "danger"><cfset session.alertmsg = "Saved to database, but pushing config failed: " & session.linkguardApplyError>
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Save one provider's API key (from the Edit-key modal). A real key
             auto-enables the provider; clearing it disables + wipes; the masked
             ******** placeholder keeps the stored key untouched. --->
        <cfcase value="save_apikey">
            <cfset prov = LCase(Trim(form.provider))>
            <cfif ListFindNoCase("gsb,vt", prov)>
                <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
                <cfset fld = prov & "_api_key">
                <cfif StructKeyExists(form,'api_key') AND form.api_key NEQ "********">
                    <cfif Len(Trim(form.api_key))>
                        <cfquery datasource="hermes">
                            UPDATE parameters2 SET value2 = <cfqueryparam value="#Encrypt(Trim(form.api_key), authkey, 'AES', 'Base64')#" cfsqltype="cf_sql_varchar">
                            WHERE module = 'linkguard' AND parameter = <cfqueryparam value="#fld#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                        <cfquery datasource="hermes">
                            UPDATE parameters2 SET value2 = '1' WHERE module = 'linkguard' AND parameter = <cfqueryparam value="#prov#_enabled" cfsqltype="cf_sql_varchar">
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="hermes">
                            UPDATE parameters2 SET value2 = '' WHERE module = 'linkguard' AND parameter = <cfqueryparam value="#fld#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                        <cfquery datasource="hermes">
                            UPDATE parameters2 SET value2 = '0' WHERE module = 'linkguard' AND parameter = <cfqueryparam value="#prov#_enabled" cfsqltype="cf_sql_varchar">
                        </cfquery>
                    </cfif>
                    <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                </cfif>
            </cfif>
            <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Reputation API key saved.">
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Toggle a free local feed (urlhaus / openphish). --->
        <cfcase value="toggle_feed">
            <cfif ListFindNoCase("urlhaus,openphish", form.feed)>
                <cfquery datasource="hermes">
                    UPDATE parameters2 SET value2 = IF(value2 = '1', '0', '1')
                    WHERE module = 'linkguard' AND parameter = <cfqueryparam value="feed_#LCase(form.feed)#_enabled" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfinclude template="./inc/linkguard_write_and_reload.cfm">
            </cfif>
            <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Reputation source updated.">
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Toggle an API provider (gsb / vt). Cannot enable without a key. --->
        <cfcase value="toggle_api">
            <cfset prov = LCase(Trim(form.provider))>
            <cfif ListFindNoCase("gsb,vt", prov)>
                <cfquery name="cur" datasource="hermes">
                    SELECT
                        MAX(CASE WHEN parameter = <cfqueryparam value="#prov#_enabled" cfsqltype="cf_sql_varchar"> THEN value2 END) AS en,
                        MAX(CASE WHEN parameter = <cfqueryparam value="#prov#_api_key" cfsqltype="cf_sql_varchar"> THEN value2 END) AS k
                    FROM parameters2 WHERE module = 'linkguard'
                </cfquery>
                <cfset isOn = (cur.en EQ '1')>
                <cfset hasKey = (Len(Trim(cur.k)) GT 0)>
                <cfif NOT isOn AND NOT hasKey>
                    <cfset session.m = 1><cfset session.alerttype = "warning">
                    <cfset session.alertmsg = "Add an API key before enabling this provider.">
                <cfelse>
                    <cfquery datasource="hermes">
                        UPDATE parameters2 SET value2 = <cfqueryparam value="#(isOn ? '0' : '1')#" cfsqltype="cf_sql_varchar">
                        WHERE module = 'linkguard' AND parameter = <cfqueryparam value="#prov#_enabled" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                    <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Reputation source updated.">
                </cfif>
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <cfcase value="rotate_key">
            <cfset request.lgRotateKey = true>
            <cfinclude template="./inc/linkguard_write_and_reload.cfm">
            <cfset session.m = 1>
            <cfif session.linkguardApplySuccess>
                <cfset session.alerttype = "success"><cfset session.alertmsg = "HMAC key rotated. Links already delivered stay valid through the token-TTL overlap window.">
            <cfelse>
                <cfset session.alerttype = "danger"><cfset session.alertmsg = "Key rotation failed: " & session.linkguardApplyError>
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Protected recipient domains: rewrite the set from the checklist. --->
        <cfcase value="save_domains">
            <cfquery datasource="hermes">DELETE FROM linkguard_domains</cfquery>
            <cfif StructKeyExists(form,'protect_all')>
                <cfquery datasource="hermes">
                    INSERT INTO linkguard_domains (domain, enabled) VALUES ('_default', 1)
                </cfquery>
            <cfelseif StructKeyExists(form,'domains') AND Len(Trim(form.domains))>
                <cfloop list="#form.domains#" index="d">
                    <cfset dd = LCase(Trim(d))>
                    <cfif Len(dd)>
                        <cfquery datasource="hermes">
                            INSERT IGNORE INTO linkguard_domains (domain, enabled)
                            VALUES (<cfqueryparam value="#dd#" cfsqltype="cf_sql_varchar">, 1)
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
            <cfinclude template="./inc/linkguard_write_and_reload.cfm">
            <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Protected domains updated.">
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <cfcase value="add_rule">
            <cfset rp = LCase(Trim(form.pattern))>
            <cfset ruleType = (StructKeyExists(form,'rule_type') ? form.rule_type : "")>
            <cfset errMsg = lgRuleError(ruleType, rp)>
            <cfif Len(errMsg)>
                <cfset session.m = 1><cfset session.alerttype = "danger"><cfset session.alertmsg = errMsg>
            <cfelse>
                <cfquery datasource="hermes">
                    INSERT IGNORE INTO linkguard_url_rules (rule_type, pattern, note)
                    VALUES (<cfqueryparam value="#ruleType#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#rp#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#Trim(form.note)#" cfsqltype="cf_sql_varchar">)
                </cfquery>
                <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "URL rule added.">
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <cfcase value="edit_rule">
            <cfset rp = LCase(Trim(form.pattern))>
            <cfset ruleType = (StructKeyExists(form,'rule_type') ? form.rule_type : "")>
            <cfset errMsg = lgRuleError(ruleType, rp)>
            <cfif Len(errMsg)>
                <cfset session.m = 1><cfset session.alerttype = "danger"><cfset session.alertmsg = errMsg>
            <cfelse>
                <cfquery datasource="hermes">
                    UPDATE linkguard_url_rules
                    SET rule_type = <cfqueryparam value="#ruleType#" cfsqltype="cf_sql_varchar">,
                        pattern   = <cfqueryparam value="#rp#" cfsqltype="cf_sql_varchar">,
                        note      = <cfqueryparam value="#Trim(form.note)#" cfsqltype="cf_sql_varchar">
                    WHERE id = <cfqueryparam value="#Val(form.id)#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "URL rule updated.">
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Bulk delete selected URL rules (checkbox-driven). --->
        <cfcase value="bulk_delete_rules">
            <cfset cleanIds = "">
            <cfif StructKeyExists(form,'rule_ids')>
                <cfloop list="#form.rule_ids#" index="rid">
                    <cfif Val(rid) GT 0><cfset cleanIds = ListAppend(cleanIds, Val(rid))></cfif>
                </cfloop>
            </cfif>
            <cfif Len(cleanIds)>
                <cfquery datasource="hermes">
                    DELETE FROM linkguard_url_rules
                    WHERE id IN (<cfqueryparam value="#cleanIds#" list="true" cfsqltype="cf_sql_integer">)
                </cfquery>
                <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Selected URL rules removed.">
            <cfelse>
                <cfset session.m = 1><cfset session.alerttype = "warning"><cfset session.alertmsg = "No rules selected.">
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Add an abused / redirector host (warn list). --->
        <cfcase value="add_abused_host">
            <cfset ah = LCase(Trim(form.host))>
            <cfset errMsg = lgHostError(ah)>
            <cfif Len(errMsg)>
                <cfset session.m = 1><cfset session.alerttype = "danger"><cfset session.alertmsg = errMsg>
            <cfelse>
                <cfquery datasource="hermes">
                    INSERT IGNORE INTO linkguard_abused_hosts (host, note)
                    VALUES (<cfqueryparam value="#ah#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#Trim(form.note)#" cfsqltype="cf_sql_varchar">)
                </cfquery>
                <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Host added and applied to the engine.">
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Bulk delete selected abused hosts (checkbox-driven). --->
        <cfcase value="bulk_delete_abused_hosts">
            <cfset cleanIds = "">
            <cfif StructKeyExists(form,'host_ids')>
                <cfloop list="#form.host_ids#" index="hid">
                    <cfif Val(hid) GT 0><cfset cleanIds = ListAppend(cleanIds, Val(hid))></cfif>
                </cfloop>
            </cfif>
            <cfif Len(cleanIds)>
                <cfquery datasource="hermes">
                    DELETE FROM linkguard_abused_hosts
                    WHERE id IN (<cfqueryparam value="#cleanIds#" list="true" cfsqltype="cf_sql_integer">)
                </cfquery>
                <cfinclude template="./inc/linkguard_write_and_reload.cfm">
                <cfset session.m = 1><cfset session.alerttype = "success"><cfset session.alertmsg = "Selected hosts removed and applied to the engine.">
            <cfelse>
                <cfset session.m = 1><cfset session.alerttype = "warning"><cfset session.alertmsg = "No hosts selected.">
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- "Check a URL" diagnostic: ask the engine how it would treat a URL
             right now. No DB change, no cache write, no click logged -- the
             result is stashed in session and rendered in the Check card after
             the redirect (per the page's POST -> cflocation convention). --->
        <cfcase value="check_url">
            <cfset session.lgCheckUrl = Trim(form.check_url)>
            <cfset StructDelete(session, "lgCheck")>
            <cfset StructDelete(session, "lgCheckErr")>
            <cfif Len(Trim(form.check_url))>
                <cftry>
                    <cfif FileExists("/opt/hermes/keys/linkguard_api_key")>
                        <cfset lgApiC = Trim(FileRead("/opt/hermes/keys/linkguard_api_key"))>
                        <cfhttp method="POST" url="http://hermes_linkguard:8895/api/check" timeout="10" throwonerror="false" result="ckr">
                            <cfhttpparam type="header" name="Authorization" value="Bearer #lgApiC#">
                            <cfhttpparam type="header" name="Content-Type" value="application/json">
                            <cfhttpparam type="body" value='{"url":#SerializeJSON(Trim(form.check_url))#}'>
                        </cfhttp>
                        <cfif IsDefined("ckr.statuscode") AND Left(ckr.statuscode,3) EQ "200">
                            <cfset session.lgCheck = DeserializeJSON(ckr.filecontent)>
                        <cfelse>
                            <cfset session.lgCheckErr = "Engine not reachable (HTTP " & (IsDefined("ckr.statuscode") ? ckr.statuscode : "?") & ").">
                        </cfif>
                    <cfelse>
                        <cfset session.lgCheckErr = "Engine API key not found yet -- save Link Guard settings once to initialize it.">
                    </cfif>
                <cfcatch type="any"><cfset session.lgCheckErr = "Check failed: " & cfcatch.message></cfcatch>
                </cftry>
            </cfif>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

        <!--- Manual FULL cache flush (power-user). Clears the ENTIRE verdict cache
             in the engine (incl. feed / GSB / VirusTotal-derived) -- forces a
             complete re-evaluation on next click. Distinct from the automatic
             scoped purge that runs on every config change. --->
        <cfcase value="clear_cache">
            <cftry>
                <cfif FileExists("/opt/hermes/keys/linkguard_api_key")>
                    <cfset lgApiCC = Trim(FileRead("/opt/hermes/keys/linkguard_api_key"))>
                    <cfhttp method="POST" url="http://hermes_linkguard:8895/api/cache-clear" timeout="10" throwonerror="false" result="ccr">
                        <cfhttpparam type="header" name="Authorization" value="Bearer #lgApiCC#">
                    </cfhttp>
                    <cfif IsDefined("ccr.statuscode") AND Left(ccr.statuscode,3) EQ "200">
                        <cfset ccData = DeserializeJSON(ccr.filecontent)>
                        <cfset session.alerttype = "success"><cfset session.alertmsg = "Verdict cache cleared (" & (IsStruct(ccData) AND StructKeyExists(ccData,'cleared') ? ccData.cleared : 0) & " entries). Links are re-evaluated on next click.">
                    <cfelse>
                        <cfset session.alerttype = "danger"><cfset session.alertmsg = "Cache clear failed (engine HTTP " & (IsDefined("ccr.statuscode") ? ccr.statuscode : "?") & ").">
                    </cfif>
                <cfelse>
                    <cfset session.alerttype = "danger"><cfset session.alertmsg = "Engine API key not found yet -- save Link Guard settings once to initialize it.">
                </cfif>
                <cfcatch type="any"><cfset session.alerttype = "danger"><cfset session.alertmsg = "Cache clear failed: " & cfcatch.message></cfcatch>
            </cftry>
            <cfset session.m = 1>
            <cflocation url="view_linkguard.cfm" addtoken="false">
        </cfcase>

    </cfswitch>
    <cfcatch type="any">
        <cfset session.m = 1><cfset session.alerttype = "danger">
        <cfset session.alertmsg = "Action failed: " & cfcatch.message>
        <cflocation url="view_linkguard.cfm" addtoken="false">
    </cfcatch>
    </cftry>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | Link Guard</title>
<cfinclude template="./inc/html_head.cfm" />
<script>
function lgToggleSecret(id, btn){var f=document.getElementById(id);if(f.type==='password'){f.type='text';btn.innerHTML='<i class="fa fa-eye-slash"></i>';}else{f.type='password';btn.innerHTML='<i class="fa fa-eye"></i>';}}
function lgSelectAllDomains(master){document.querySelectorAll('.lg-dom-cb').forEach(function(cb){if(!cb.disabled){cb.checked=master.checked;}});}
function lgProtectAllToggle(cb){var dis=cb.checked;document.querySelectorAll('.lg-dom-cb').forEach(function(x){x.disabled=dis;});var sa=document.getElementById('lgSelectAll');if(sa){sa.disabled=dis;}}
function lgOpenKey(provider,label,hasKey){document.getElementById('lgKeyProvider').value=provider;document.getElementById('lgKeyModalLabel').textContent='API key: '+label;var f=document.getElementById('lgKeyField');f.value=hasKey?'********':'';f.type='password';new bootstrap.Modal(document.getElementById('lgKeyModal')).show();}
function lgOpenRule(id,type,pattern,note){document.getElementById('lgRuleId').value=id||'';document.getElementById('lgRuleAction').value=id?'edit_rule':'add_rule';document.getElementById('lgRuleModalLabel').textContent=id?'Edit URL rule':'Add URL rule';document.getElementById('lgRuleType').value=type||'allow';document.getElementById('lgRulePattern').value=pattern||'';document.getElementById('lgRuleNote').value=note||'';new bootstrap.Modal(document.getElementById('lgRuleModal')).show();}
function lgRuleSelectAll(master){document.querySelectorAll('.lg-rule-cb').forEach(function(cb){cb.checked=master.checked;});}
function lgHostSelectAll(master){document.querySelectorAll('.lg-host-cb').forEach(function(cb){cb.checked=master.checked;});}
function lgOpenHost(){document.getElementById('lgHostName').value='';document.getElementById('lgHostNote').value='';new bootstrap.Modal(document.getElementById('lgHostModal')).show();}
$(function(){ $('#lgRules').DataTable({dom:'lfrtip', order:[[1,'asc']], columnDefs:[{orderable:false,targets:[0,4]}], lengthMenu:[[25,50,-1],['25','50','All']]}); if(document.getElementById('lgHosts')){$('#lgHosts').DataTable({dom:'lfrtip', order:[[1,'asc']], columnDefs:[{orderable:false,targets:[0]}], lengthMenu:[[25,50,-1],['25','50','All']]});} if(document.getElementById('lgClicks')){$('#lgClicks').DataTable({order:[[0,'desc']], lengthMenu:[[25,50,100,-1],['25','50','100','All']]});} var pa=document.getElementById('protect_all'); if(pa){lgProtectAllToggle(pa);}
  $('#toggleLgTroubleshoot').on('click',function(){$('#lgTroubleshoot').collapse('toggle');});
  $('#lgTroubleshoot').on('shown.bs.collapse',function(){$('#toggleLgTroubleshoot').find('i').removeClass('fa-chevron-down').addClass('fa-chevron-up');$('#toggleLgTroubleshoot').attr('title','Collapse');});
  $('#lgTroubleshoot').on('hidden.bs.collapse',function(){$('#toggleLgTroubleshoot').find('i').removeClass('fa-chevron-up').addClass('fa-chevron-down');$('#toggleLgTroubleshoot').attr('title','Expand');});
});
</script>
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">
<cfinclude template="./inc/top_navbar.cfm" />
<cfinclude template="./inc/main_sidebar.cfm" />

<main class="app-main">
<div class="content-header"><div class="container-fluid"><div class="row mb-2">
    <div class="col-sm-6"><h1 class="m-0">Link Guard</h1></div>
    <div class="col-sm-6"><ol class="breadcrumb float-sm-end">
        <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
        <li class="breadcrumb-item">Email Policies</li>
        <li class="breadcrumb-item active">Link Guard</li>
    </ol></div>
</div></div></div>

<section class="content"><div class="container-fluid">

<cfinclude template="./inc/license_check.cfm" />
<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset proFeatureName = "Email Policies > Link Guard">
    <cfinclude template="./inc/license_pro_required.cfm">
    <cfabort>
</cfif>

<!--- session alert --->
<cfif StructKeyExists(session,"m") AND session.m IS 1 AND StructKeyExists(session,"alertmsg")>
    <cfoutput>
    <div class="alert alert-#session.alerttype# alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        #session.alertmsg#
    </div>
    </cfoutput>
    <cfset session.m = 0>
</cfif>

<!--- load config (parameters2, module='linkguard') --->
<cfquery name="ss" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE module = 'linkguard'
</cfquery>
<cfset S = {}>
<cfloop query="ss"><cfset S[ss.parameter] = (IsNull(ss.value2) ? "" : ss.value2)></cfloop>
<cfset gv = function(k,d){ return (StructKeyExists(S,k) AND Len(S[k])) ? S[k] : d; }>
<cfset gsbSet = (StructKeyExists(S,"gsb_api_key") AND Len(S["gsb_api_key"]))>
<cfset vtSet  = (StructKeyExists(S,"vt_api_key") AND Len(S["vt_api_key"]))>

<!--- Redirect base URL defaults to this console's host (parameters2 console.host) --->
<cfquery name="chQ" datasource="hermes">SELECT value2 FROM parameters2 WHERE parameter='console.host' AND module='console'</cfquery>
<cfset consoleHost = (chQ.recordcount AND Len(Trim(chQ.value2))) ? Trim(chQ.value2) : cgi.server_name>
<cfset defaultBaseUrl = "https://" & consoleHost & "/lg/">

<!--- reputation source rows (defined outside cfoutput) --->
<cfset repFeeds = [ {"k":"urlhaus","n":"URLhaus (abuse.ch)","lim":"Bulk list; refreshed on your interval (fair use)"},
                    {"k":"openphish","n":"OpenPhish","lim":"Bulk list; refreshed on your interval (fair use)"} ]>
<cfset repApis  = [ {"k":"gsb","n":"Google Safe Browsing","set":gsbSet,"lim":"Free tier ~10,000 URLs/day"},
                    {"k":"vt","n":"VirusTotal","set":vtSet,"lim":"Free tier 4/min, 500/day"} ]>

<!--- protected domains: current set + hosted-domain union (relay + mailbox) --->
<cfquery name="protQ" datasource="hermes">SELECT domain FROM linkguard_domains WHERE enabled = 1</cfquery>
<cfset protectedSet = {}>
<cfloop query="protQ"><cfset protectedSet[LCase(Trim(protQ.domain))] = true></cfloop>
<cfset protectAllOn = StructKeyExists(protectedSet,"_default")>

<cfquery name="hostedQ" datasource="hermes">
    SELECT domain FROM domains WHERE domain IS NOT NULL AND domain <> ''
    UNION
    SELECT domain FROM mailbox_domains WHERE domain IS NOT NULL AND domain <> ''
    ORDER BY domain
</cfquery>

<cfquery name="rulesQ" datasource="hermes">SELECT id, rule_type, pattern, note FROM linkguard_url_rules ORDER BY rule_type, pattern</cfquery>
<cfquery name="abusedQ" datasource="hermes">SELECT id, host, note FROM linkguard_abused_hosts ORDER BY host</cfquery>

<!--- best-effort container stats + recent clicks (in-stack mgmt API; remote mode descoped) --->
<cfset stats = "">
<cfset feedStat = {}>
<cfset clicksData = []>
<cftry>
    <cfif FileExists("/opt/hermes/keys/linkguard_api_key")>
        <cfset lgApi = Trim(FileRead("/opt/hermes/keys/linkguard_api_key"))>
        <cfhttp method="GET" url="http://hermes_linkguard:8895/api/stats?days=30" timeout="5" throwonerror="false" result="sr">
            <cfhttpparam type="header" name="Authorization" value="Bearer #lgApi#">
        </cfhttp>
        <cfif IsDefined("sr.statuscode") AND Left(sr.statuscode,3) EQ "200"><cfset stats = DeserializeJSON(sr.filecontent)></cfif>
        <cfhttp method="GET" url="http://hermes_linkguard:8895/api/clicks?limit=200" timeout="6" throwonerror="false" result="clr">
            <cfhttpparam type="header" name="Authorization" value="Bearer #lgApi#">
        </cfhttp>
        <cfif IsDefined("clr.statuscode") AND Left(clr.statuscode,3) EQ "200">
            <cfset clkResp = DeserializeJSON(clr.filecontent)>
            <cfif IsStruct(clkResp) AND StructKeyExists(clkResp,"clicks") AND IsArray(clkResp.clicks)><cfset clicksData = clkResp.clicks></cfif>
        </cfif>
    </cfif>
    <cfif IsStruct(stats) AND StructKeyExists(stats,"feeds") AND IsArray(stats.feeds)>
        <cfloop array="#stats.feeds#" index="f"><cfset feedStat[LCase(f.source)] = f></cfloop>
    </cfif>
    <cfcatch></cfcatch>
</cftry>

<!--- one-shot "Check a URL" result (set by the check_url action), read + cleared --->
<cfset lgCheck    = (StructKeyExists(session,"lgCheck") AND IsStruct(session.lgCheck)) ? session.lgCheck : "">
<cfset lgCheckUrl = StructKeyExists(session,"lgCheckUrl") ? session.lgCheckUrl : "">
<cfset lgCheckErr = StructKeyExists(session,"lgCheckErr") ? session.lgCheckErr : "">
<cfset StructDelete(session,"lgCheck")><cfset StructDelete(session,"lgCheckUrl")><cfset StructDelete(session,"lgCheckErr")>

<!--- render helpers for the Check + Activity views --->
<cfset srcLabel = { "admin":"Admin rule", "local":"Local feed (URLhaus / OpenPhish)", "heuristic":"Structural heuristic", "gsb":"Google Safe Browsing", "vt":"VirusTotal", "none":"Default (no source flagged it)", "scheme":"Unsupported address type" }>
<cfset srcOf = function(s){ var x = LCase(Trim(arguments.s)); return StructKeyExists(srcLabel, x) ? srcLabel[x] : arguments.s; }>
<cfset vBadge = function(v){ var x = LCase(Trim(arguments.v)); return (x EQ 'clean') ? 'success' : ((x EQ 'suspicious') ? 'warning text-dark' : ((x EQ 'malicious') ? 'danger' : 'secondary')); }>
<cfset aBadge = function(a){ var x = LCase(Trim(arguments.a)); return (x EQ 'redirected' OR x EQ 'proceeded') ? 'success' : ((x EQ 'warned') ? 'warning text-dark' : ((x EQ 'blocked') ? 'danger' : 'secondary')); }>
<cfset sval = function(st,k){ if (NOT StructKeyExists(arguments.st, arguments.k)) return ""; var vv = arguments.st[arguments.k]; return IsNull(vv) ? "" : vv; }>

<cfoutput>

<!--- Maintenance toolbar (canonical style, cf. view_mail_queue.cfm): solid button
     + Bootstrap modal confirm. Modal "No" = dismiss (no form submit, so no stuck
     preloader); "Yes" = submit + reload. --->
<div class="mb-3">
  <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="##clearCacheModal">
    <i class="fas fa-broom"></i> Clear Verdict Cache
  </button>
</div>

<!--- ===== Troubleshooting commands (collapsible, matches the SpamAssassin Regex Helper pattern) ===== --->
<div class="card card-outline card-secondary mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleLgTroubleshoot" title="Expand"><i class="fas fa-chevron-down"></i></button>
      <i class="fas fa-terminal me-1"></i>Troubleshooting commands
    </h3>
  </div>
  <div class="collapse" id="lgTroubleshoot">
    <div class="card-body">
      <p class="mb-2">Run these on the Docker host to inspect the Link Guard engine, the link-reference store, and the mail-path rewrite/restore. The container is pure Python (no <code>wget</code>/<code>curl</code>), so health checks use <code>python3</code>.</p>
      <p class="mt-2 mb-2"><strong>Engine &amp; link-reference store</strong></p>
      <div class="table-responsive">
        <table class="table table-sm table-bordered mb-0">
          <thead class="table-light"><tr><th style="width:62%">Command</th><th>What it shows</th></tr></thead>
          <tbody>
            <tr><td><code>docker ps --filter name=hermes_linkguard --format '{{.Status}}'</code></td><td>Engine container health</td></tr>
            <tr><td><code>docker exec hermes_linkguard python3 -c "import urllib.request;print(urllib.request.urlopen('http://localhost:8894/healthz',timeout=3).read().decode())"</code></td><td>Engine liveness endpoint (expect <code>{"status":"ok"}</code>)</td></tr>
            <tr><td><code>docker exec hermes_linkguard ls -la /var/lib/linkguard/url_map.db</code></td><td>Confirm the token store exists (created on first rewrite; <code>-rw-r--r-- root root</code>)</td></tr>
            <tr><td><code>docker exec hermes_linkguard python3 -c "import sqlite3;c=sqlite3.connect('file:/var/lib/linkguard/url_map.db?mode=ro',uri=True);print('mappings:',c.execute('SELECT COUNT(*) FROM url_map').fetchone()[0])"</code></td><td>Count of active link mappings (rewritten links)</td></tr>
            <tr><td><code>docker exec hermes_linkguard python3 -c "import sqlite3;c=sqlite3.connect('file:/var/lib/linkguard/url_map.db?mode=ro',uri=True);print(c.execute('SELECT original_url,recipient_domain,expires_at FROM url_map WHERE id=?',('PASTE_ID',)).fetchone())"</code></td><td>Resolve a wrapped link &mdash; replace <code>PASTE_ID</code> with the part after <code>?t=2.</code> in the rewritten URL</td></tr>
            <tr><td><code>docker exec hermes_linkguard python3 -c "import sqlite3;c=sqlite3.connect('/var/lib/linkguard/linkguard.db');print('feed url entries:',c.execute('SELECT COUNT(*) FROM blocklist WHERE match_type=?',('url',)).fetchone()[0])"</code></td><td>Local feed (URLhaus/OpenPhish) entry count</td></tr>
          </tbody>
        </table>
      </div>
      <p class="mt-3 mb-2"><strong>Click verdicts &amp; mail-path logs</strong></p>
      <div class="table-responsive">
        <table class="table table-sm table-bordered mb-0">
          <thead class="table-light"><tr><th style="width:62%">Command</th><th>What it shows</th></tr></thead>
          <tbody>
            <tr><td><code>docker exec hermes_linkguard python3 -c "import sqlite3;c=sqlite3.connect('/var/lib/linkguard/linkguard.db');[print(r) for r in c.execute('SELECT clicked_at,url_host,verdict,source,action FROM clicks ORDER BY id DESC LIMIT 20')]"</code></td><td>Recent click verdicts (same data as the Recent activity card below)</td></tr>
            <tr><td><code>docker logs --tail 50 hermes_linkguard</code></td><td>Engine logs (feed refreshes, errors)</td></tr>
            <tr><td><code>docker logs --tail 50 hermes_body_milter | grep 'linkguard:'</code></td><td>Inbound rewrite log &mdash; watch <code>over_length_skipped</code> (should be 0)</td></tr>
            <tr><td><code>docker logs --tail 50 hermes_body_milter | grep linkguard_restore</code></td><td>Outbound restore log (links unwrapped for external recipients)</td></tr>
          </tbody>
        </table>
      </div>
      <p class="text-muted mt-2 mb-0"><small><i class="fas fa-info-circle"></i> <strong>Tip:</strong> the milter writes <code>url_map.db</code> (short id &rarr; original URL); the engine reads it read-only to resolve clicks. If clicks return &ldquo;invalid/expired&rdquo; right after deploy, the store may not exist yet &mdash; send one inbound message to a protected domain to mint the first token.</small></p>
    </div>
  </div>
</div>

<!--- ===== Settings ===== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-cog me-2"></i>Settings</h3></div>
  <form method="post" action="view_linkguard.cfm">
  <input type="hidden" name="lg_action" value="save_settings">
  <div class="card-body">
    <div class="form-check form-switch mb-3">
      <input class="form-check-input" type="checkbox" id="enabled" name="enabled" #(gv('enabled','0') EQ '1' ? 'checked' : '')#>
      <label class="form-check-label" for="enabled"><strong>Enable Link Guard</strong> (rewrite inbound links for protected domains)</label>
    </div>
    <div class="mb-3">
      <label class="form-label">Redirect base URL <small class="text-muted">-- this gateway's public /lg/ endpoint (defaults to the console host)</small></label>
      <input type="text" class="form-control" name="redirect_base_url" placeholder="#defaultBaseUrl#" value="#gv('redirect_base_url', defaultBaseUrl)#">
    </div>
    <div class="row">
      <div class="col-md-6 mb-3">
        <label class="form-label">Action on <strong>suspicious</strong> link</label>
        <select class="form-select" name="action_suspicious">
          <cfloop list="warn,allow,block" index="o"><option value="#o#" #(gv('action_suspicious','warn') EQ o ? 'selected' : '')#>#o#</option></cfloop>
        </select>
      </div>
      <div class="col-md-6 mb-3">
        <label class="form-label">Action on <strong>malicious</strong> link</label>
        <select class="form-select" name="action_malicious">
          <cfloop list="block,block_override,warn" index="o"><option value="#o#" #(gv('action_malicious','block') EQ o ? 'selected' : '')#>#o#</option></cfloop>
        </select>
      </div>
    </div>
    <div class="form-check form-switch mb-3">
      <input class="form-check-input" type="checkbox" id="restore_outbound" name="restore_outbound" #(gv('restore_outbound','1') EQ '1' ? 'checked' : '')#>
      <label class="form-check-label" for="restore_outbound">Restore original links on <strong>outbound</strong> mail (external recipients get clean URLs)</label>
    </div>
    <div class="row">
      <div class="col-md-3 mb-3"><label class="form-label">Token TTL (days)</label><input type="number" class="form-control" name="token_ttl_days" value="#gv('token_ttl_days','14')#"></div>
      <div class="col-md-3 mb-3"><label class="form-label">Max link length <small class="text-muted">(fallback)</small></label><input type="number" class="form-control" name="max_inline_url" value="#gv('max_inline_url','1200')#"><small class="text-muted d-block">Only used if the compact link-reference store is unavailable (e.g. an off-box engine); normal links have no length limit.</small></div>
      <div class="col-md-3 mb-3"><label class="form-label">Rate limit /min</label><input type="number" class="form-control" name="rate_limit_per_min" value="#gv('rate_limit_per_min','120')#"></div>
      <div class="col-md-3 mb-3"><label class="form-label">Feed refresh (min)</label><input type="number" class="form-control" name="feed_refresh_minutes" value="#gv('feed_refresh_minutes','60')#"></div>
    </div>
    <hr>
    <p class="mb-2"><strong>Redirect detection</strong> <small class="text-muted">-- catch links that hide behind open redirects or trusted cloud-storage hosts before bouncing to phishing.</small></p>
    <div class="form-check form-switch mb-2">
      <input class="form-check-input" type="checkbox" id="flag_cloud_storage" name="flag_cloud_storage" #(gv('flag_cloud_storage','1') EQ '1' ? 'checked' : '')#>
      <label class="form-check-label" for="flag_cloud_storage">Warn on <strong>cloud-storage / redirector hosts</strong> <small class="text-muted">(the curated list below -- storage.googleapis.com, *.web.app, blob storage, etc., commonly abused to host or bounce to phishing)</small></label>
    </div>
    <div class="form-check form-switch mb-2">
      <input class="form-check-input" type="checkbox" id="follow_redirects" name="follow_redirects" #(gv('follow_redirects','0') EQ '1' ? 'checked' : '')#>
      <label class="form-check-label" for="follow_redirects"><strong>Follow redirect chains at click time</strong> <small class="text-muted">-- resolves the real destination through server-side redirects and checks ITS reputation; catches trusted-host links that bounce to phishing. The engine makes a guarded outbound request (private/internal addresses are refused) and it adds a little latency per click.</small></label>
    </div>
    <div class="row">
      <div class="col-md-3 mb-2"><label class="form-label">Max redirect hops</label><input type="number" class="form-control" name="follow_max_hops" value="#gv('follow_max_hops','5')#"></div>
    </div>
    <hr>
    <p class="mb-2"><strong>Advanced</strong> <small class="text-muted">-- verdict cache lifetime (how long a checked URL is reused before re-checking the sources) and click-log retention.</small></p>
    <div class="row">
      <div class="col-md-3 mb-2"><label class="form-label">Cache: clean (hrs)</label><input type="number" class="form-control" name="cache_ttl_clean_hours" value="#gv('cache_ttl_clean_hours','24')#"></div>
      <div class="col-md-3 mb-2"><label class="form-label">Cache: suspicious (hrs)</label><input type="number" class="form-control" name="cache_ttl_suspicious_hours" value="#gv('cache_ttl_suspicious_hours','6')#"></div>
      <div class="col-md-3 mb-2"><label class="form-label">Cache: malicious (hrs)</label><input type="number" class="form-control" name="cache_ttl_malicious_hours" value="#gv('cache_ttl_malicious_hours','168')#"></div>
      <div class="col-md-3 mb-2"><label class="form-label">Click log retention (days)</label><input type="number" class="form-control" name="clicks_retention_days" value="#gv('clicks_retention_days','90')#"></div>
    </div>
  </div>
  <div class="card-footer"><button type="submit" class="btn btn-primary">Save &amp; Reload</button></div>
  </form>
</div>

<!--- ===== Reputation sources ===== --->
<div class="card card-secondary card-outline mb-4">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-shield-alt me-2"></i>Reputation sources</h3></div>
  <div class="card-body">
    <p class="text-muted">Checked at click time, on top of the structural heuristics, with results cached. Free feeds need no key; the two API providers offer free tiers and only run once you add a key and enable them.</p>
    <table class="table table-bordered table-hover align-middle">
      <thead><tr><th style="width:90px">Enabled</th><th>Source</th><th>Type</th><th>Status</th><th>Limits</th><th class="text-end">API key</th></tr></thead>
      <tbody>
        <!--- free feeds --->
        <cfloop array="#repFeeds#" index="fd">
          <cfset fEnabled = (gv('feed_#fd.k#_enabled','1') EQ '1')>
          <tr>
            <td class="text-center">
              <form method="post" action="view_linkguard.cfm" style="display:inline;">
                <input type="hidden" name="lg_action" value="toggle_feed"><input type="hidden" name="feed" value="#fd.k#">
                <button type="submit" class="btn btn-sm #(fEnabled?'btn-success':'btn-outline-secondary')#" title="#(fEnabled?'Enabled - click to disable':'Disabled - click to enable')#"><i class="fas #(fEnabled?'fa-toggle-on':'fa-toggle-off')#"></i></button>
              </form>
            </td>
            <td>#fd.n#</td>
            <td><span class="badge bg-secondary">Free feed</span></td>
            <td>
              <cfif NOT fEnabled><span class="badge bg-secondary">disabled</span>
              <cfelseif StructKeyExists(feedStat, fd.k)><span class="badge bg-success">#(IsNull(feedStat[fd.k].entry_count)?'?':feedStat[fd.k].entry_count)# entries</span> <small class="text-muted">#feedStat[fd.k].last_status#</small>
              <cfelse><span class="badge bg-success">enabled</span> <small class="text-muted">awaiting first refresh</small></cfif>
            </td>
            <td><small class="text-muted">#fd.lim#</small></td>
            <td class="text-end"><span class="text-muted">-</span></td>
          </tr>
        </cfloop>
        <!--- API providers --->
        <cfloop array="#repApis#" index="ap">
          <cfset aEnabled = (gv('#ap.k#_enabled','0') EQ '1')>
          <tr>
            <td class="text-center">
              <form method="post" action="view_linkguard.cfm" style="display:inline;">
                <input type="hidden" name="lg_action" value="toggle_api"><input type="hidden" name="provider" value="#ap.k#">
                <button type="submit" class="btn btn-sm #(aEnabled?'btn-success':'btn-outline-secondary')#" #(NOT ap.set AND NOT aEnabled ? 'disabled title="Add a key first"' : '')#><i class="fas #(aEnabled?'fa-toggle-on':'fa-toggle-off')#"></i></button>
              </form>
            </td>
            <td>#ap.n#</td>
            <td><span class="badge bg-info">API key</span></td>
            <td>
              <cfif NOT ap.set><span class="badge bg-warning text-dark">no key</span>
              <cfelseif aEnabled><span class="badge bg-success">enabled</span>
              <cfelse><span class="badge bg-secondary">disabled</span></cfif>
            </td>
            <td><small class="text-muted">#ap.lim#</small></td>
            <td class="text-end"><button type="button" class="btn btn-sm btn-primary" onclick="lgOpenKey('#ap.k#','#JSStringFormat(ap.n)#',#(ap.set?'true':'false')#)"><i class="fas fa-key me-1"></i>Edit</button></td>
          </tr>
        </cfloop>
      </tbody>
    </table>
  </div>
</div>

<!--- ===== Protected domains ===== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-globe me-2"></i>Protected recipient domains</h3></div>
  <form method="post" action="view_linkguard.cfm">
  <input type="hidden" name="lg_action" value="save_domains">
  <div class="card-body">
    <p class="text-muted">Link Guard rewrites inbound links only for mail addressed to the domains you select here.</p>
    <div class="form-check form-switch mb-3">
      <input class="form-check-input" type="checkbox" id="protect_all" name="protect_all" onchange="lgProtectAllToggle(this)" #(protectAllOn ? 'checked' : '')#>
      <label class="form-check-label" for="protect_all"><strong>Protect all current &amp; future recipient domains</strong></label>
    </div>
    <cfif hostedQ.recordCount EQ 0>
      <div class="alert alert-info mb-0">This server has no recipient domains configured yet. Add a relay or mailbox domain first, or use <strong>Protect all</strong> above.</div>
    <cfelse>
      <div class="form-check mb-2">
        <input class="form-check-input" type="checkbox" id="lgSelectAll" onclick="lgSelectAllDomains(this)">
        <label class="form-check-label" for="lgSelectAll"><em>Select all</em></label>
      </div>
      <div class="row">
        <cfloop query="hostedQ">
          <cfset dlc = LCase(Trim(hostedQ.domain))>
          <div class="col-md-4 col-sm-6">
            <div class="form-check">
              <input class="form-check-input lg-dom-cb" type="checkbox" name="domains" value="#HTMLEditFormat(dlc)#" id="dom_#HTMLEditFormat(dlc)#" #(StructKeyExists(protectedSet, dlc) ? 'checked' : '')#>
              <label class="form-check-label" for="dom_#HTMLEditFormat(dlc)#">#HTMLEditFormat(hostedQ.domain)#</label>
            </div>
          </div>
        </cfloop>
      </div>
    </cfif>
  </div>
  <div class="card-footer"><button type="submit" class="btn btn-primary">Save protected domains</button></div>
  </form>
</div>

<!--- ===== URL allow / block ===== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-tasks me-2"></i>URL allow / block rules</h3>
    <div class="card-tools float-end"><button type="button" class="btn btn-sm btn-success" onclick="lgOpenRule('','','','')"><i class="fas fa-plus me-1"></i>Add rule</button></div>
  </div>
  <div class="card-body">
    <div class="alert alert-light border">
      <p class="mb-1">Manual overrides, checked <strong>before</strong> the feeds, heuristics and reputation APIs:</p>
      <ul class="mb-1">
        <li><span class="badge bg-success">allow</span> &mdash; always treat the link as <strong>clean</strong> (a trusted host you don't want flagged).</li>
        <li><span class="badge bg-danger">block</span> &mdash; always treat the link as <strong>malicious</strong>.</li>
      </ul>
      <p class="mb-0"><small class="text-muted">A bare host (e.g. <code>example.com</code>) also covers its subdomains; or use a <code>host/path</code> prefix (e.g. <code>example.com/login</code>). No <code>http://</code> prefix, no wildcards.</small></p>
    </div>
    <form method="post" action="view_linkguard.cfm" onsubmit="return confirm('Delete the selected URL rules?');">
    <input type="hidden" name="lg_action" value="bulk_delete_rules">
    <div class="mb-2"><button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash me-1"></i>Delete selected</button></div>
    <table id="lgRules" class="table table-bordered table-hover table-striped" style="width:100%">
      <thead><tr>
        <th style="width:40px" class="text-center"><input type="checkbox" onclick="lgRuleSelectAll(this)" title="Select all"></th>
        <th>Type</th><th>Pattern</th><th>Note</th><th style="width:80px" class="text-end">Edit</th>
      </tr></thead>
      <tbody>
        <cfloop query="rulesQ">
        <tr>
          <td class="text-center"><input type="checkbox" class="lg-rule-cb" name="rule_ids" value="#rulesQ.id#"></td>
          <td><cfif rulesQ.rule_type EQ 'allow'><span class="badge bg-success">allow</span><cfelse><span class="badge bg-danger">block</span></cfif></td>
          <td>#HTMLEditFormat(rulesQ.pattern)#</td>
          <td>#HTMLEditFormat(rulesQ.note)#</td>
          <td class="text-end"><button type="button" class="btn btn-sm btn-primary" onclick="lgOpenRule(#rulesQ.id#,'#rulesQ.rule_type#','#JSStringFormat(rulesQ.pattern)#','#JSStringFormat(rulesQ.note)#')"><i class="fas fa-edit"></i></button></td>
        </tr>
        </cfloop>
      </tbody>
    </table>
    </form>
  </div>
</div>

<!--- ===== Abused / redirector hosts ===== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-cloud me-2"></i>Abused / redirector hosts</h3>
    <div class="card-tools float-end"><button type="button" class="btn btn-sm btn-success" onclick="lgOpenHost()"><i class="fas fa-plus me-1"></i>Add host</button></div>
  </div>
  <div class="card-body">
    <div class="alert alert-light border">
      <p class="mb-1">Hosts that get <strong>warned</strong> on &mdash; trusted-looking platforms (cloud storage, static-site / app hosting, tunnels) commonly abused to host or bounce to phishing. The <strong>Warn on cloud-storage / redirector hosts</strong> switch above gates this whole list. Ships pre-seeded with a curated baseline; add or remove as you like &mdash; <strong>changes here apply immediately</strong> (no Save needed). The master switch and other settings above need the <strong>Save &amp; reload settings</strong> button.</p>
      <p class="mb-0"><small class="text-muted">A bare host (e.g. <code>storage.googleapis.com</code>) also covers its subdomains. To <strong>suppress</strong> one you trust, delete it here &mdash; or add a specific <code>host/path</code> to the URL allow rules (allow wins).</small></p>
    </div>
    <form method="post" action="view_linkguard.cfm" onsubmit="return confirm('Delete the selected hosts?');">
    <input type="hidden" name="lg_action" value="bulk_delete_abused_hosts">
    <div class="mb-2"><button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash me-1"></i>Delete selected</button></div>
    <table id="lgHosts" class="table table-bordered table-hover table-striped" style="width:100%">
      <thead><tr>
        <th style="width:40px" class="text-center"><input type="checkbox" onclick="lgHostSelectAll(this)" title="Select all"></th>
        <th>Host</th><th>Note</th>
      </tr></thead>
      <tbody>
        <cfloop query="abusedQ">
        <tr>
          <td class="text-center"><input type="checkbox" class="lg-host-cb" name="host_ids" value="#abusedQ.id#"></td>
          <td><code>#HTMLEditFormat(abusedQ.host)#</code></td>
          <td>#HTMLEditFormat(abusedQ.note)#</td>
        </tr>
        </cfloop>
      </tbody>
    </table>
    </form>
  </div>
</div>

<!--- ===== Check a URL (diagnostic) ===== --->
<div class="card card-info card-outline mb-4">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-search me-2"></i>Check a URL</h3></div>
  <form method="post" action="view_linkguard.cfm">
    <input type="hidden" name="lg_action" value="check_url">
    <div class="card-body">
      <p class="text-muted">See how Link Guard would treat a link right now &mdash; the verdict, which layer decided it, and the resolved host. This checks the URL exactly as written; it does <strong>not</strong> follow redirects, and it does not change the verdict cache.</p>
      <div class="input-group">
        <input type="text" class="form-control" name="check_url" placeholder="https://example.com/path" value="#HTMLEditFormat(lgCheckUrl)#">
        <button type="submit" class="btn btn-primary"><i class="fas fa-search me-1"></i>Check</button>
      </div>
      <cfif IsStruct(lgCheck) AND StructKeyExists(lgCheck,"verdict")>
        <table class="table table-sm table-bordered mt-3 mb-0" style="max-width:680px">
          <tr><th style="width:180px">Verdict</th><td><span class="badge bg-#vBadge(lgCheck.verdict)#">#HTMLEditFormat(lgCheck.verdict)#</span></td></tr>
          <tr><th>Resulting action</th><td><span class="badge bg-#aBadge(sval(lgCheck,'action'))#">#HTMLEditFormat(sval(lgCheck,'action'))#</span></td></tr>
          <tr><th>Decided by</th><td>#HTMLEditFormat(srcOf(sval(lgCheck,'source')))#</td></tr>
          <cfif Len(sval(lgCheck,'detail'))><tr><th>Detail</th><td>#HTMLEditFormat(sval(lgCheck,'detail'))#</td></tr></cfif>
          <tr><th>Resolved host</th><td><code>#HTMLEditFormat(sval(lgCheck,'host'))#</code></td></tr>
        </table>
      <cfelseif Len(lgCheckErr)>
        <div class="alert alert-warning mt-3 mb-0">#HTMLEditFormat(lgCheckErr)#</div>
      </cfif>
    </div>
  </form>
</div>

<!--- ===== Recent activity ===== --->
<div class="card card-info card-outline mb-4">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-stream me-2"></i>Recent activity</h3></div>
  <div class="card-body">
    <p class="text-muted">The most recent link clicks Link Guard evaluated. Only the URL <em>host</em> is recorded &mdash; never the full link &mdash; and IP addresses are stored hashed for privacy.</p>
    <cfif ArrayLen(clicksData) EQ 0>
      <div class="alert alert-light border mb-0">No clicks recorded yet, or the engine is not reachable. Once recipients click protected links, each evaluation appears here.</div>
    <cfelse>
      <table id="lgClicks" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead><tr><th>Time</th><th>Recipient domain</th><th>Host</th><th>Verdict</th><th>Decided by</th><th>Detail</th><th>Action</th></tr></thead>
        <tbody>
          <cfloop array="#clicksData#" index="ck">
            <cfset ckEpoch = Val(sval(ck,'clicked_at'))>
            <cfset ckDt = DateConvert("utc2Local", DateAdd("s", ckEpoch, CreateDateTime(1970,1,1,0,0,0)))>
            <tr>
              <td data-order="#ckEpoch#">#DateTimeFormat(ckDt, "yyyy-mm-dd HH:nn:ss")#</td>
              <td>#HTMLEditFormat(sval(ck,'recipient_domain'))#</td>
              <td>#HTMLEditFormat(sval(ck,'url_host'))#</td>
              <td><span class="badge bg-#vBadge(sval(ck,'verdict'))#">#HTMLEditFormat(sval(ck,'verdict'))#</span></td>
              <td>#HTMLEditFormat(srcOf(sval(ck,'source')))#</td>
              <td><small>#HTMLEditFormat(sval(ck,'detail'))#</small></td>
              <td><span class="badge bg-#aBadge(sval(ck,'action'))#">#HTMLEditFormat(sval(ck,'action'))#</span></td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </cfif>
  </div>
</div>

<!--- ===== Signing key + Engine status (side by side) ===== --->
<div class="row">
  <div class="col-md-6">
    <div class="card card-warning card-outline mb-4">
      <div class="card-header"><h3 class="card-title"><i class="fas fa-key me-2"></i>Signing key</h3></div>
      <div class="card-body">
        <p class="mb-2">The HMAC key is what stops outsiders from forging safe-links. Rotating it keeps existing delivered links working through the token-TTL overlap window.</p>
        <p class="text-muted mb-3">Last rotated: #(Len(gv('hmac_key_rotated_at','')) ? gv('hmac_key_rotated_at','') : 'never')#</p>
        <form method="post" action="view_linkguard.cfm" onsubmit="return confirm('Rotate the Link Guard signing key now?');">
          <input type="hidden" name="lg_action" value="rotate_key">
          <button type="submit" class="btn btn-warning"><i class="fa fa-key me-1"></i>Rotate key</button>
        </form>
      </div>
    </div>
  </div>
  <div class="col-md-6">
    <div class="card card-info card-outline mb-4">
      <div class="card-header"><h3 class="card-title"><i class="fas fa-chart-bar me-2"></i>Engine status</h3></div>
      <div class="card-body">
        <cfif IsStruct(stats)>
          <p class="mb-1"><strong>#stats.total_clicks#</strong> clicks (30d)</p>
          <ul class="mb-0">
            <cfloop collection="#stats.by_verdict#" item="vk"><li>#vk#: #stats.by_verdict[vk]#</li></cfloop>
          </ul>
        <cfelse>
          <p class="text-muted mb-0">Engine not reachable yet. Once <code>hermes_linkguard</code> is running and Link Guard is enabled, click stats appear here.</p>
        </cfif>
      </div>
    </div>
  </div>
</div>

</cfoutput>

<!--- ===== Modals (static; JS populates) ===== --->
<div class="modal fade" id="lgKeyModal" tabindex="-1">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="view_linkguard.cfm">
      <input type="hidden" name="lg_action" value="save_apikey">
      <input type="hidden" name="provider" id="lgKeyProvider">
      <div class="modal-header"><h5 class="modal-title" id="lgKeyModalLabel">API key</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">
        <label class="form-label">API key</label>
        <div class="input-group">
          <input type="password" class="form-control" id="lgKeyField" name="api_key" autocomplete="off">
          <button class="btn btn-outline-secondary" type="button" onclick="lgToggleSecret('lgKeyField',this)"><i class="fa fa-eye"></i></button>
        </div>
        <small class="text-muted">Entering a key enables this provider. Leave the masked <code>********</code> to keep the stored key; clear the field to disable the provider and remove its key.</small>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-primary">Save key</button></div>
    </form>
  </div></div>
</div>

<div class="modal fade" id="lgRuleModal" tabindex="-1">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="view_linkguard.cfm">
      <input type="hidden" name="lg_action" id="lgRuleAction" value="add_rule">
      <input type="hidden" name="id" id="lgRuleId">
      <div class="modal-header"><h5 class="modal-title" id="lgRuleModalLabel">Add URL rule</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">
        <div class="mb-3"><label class="form-label">Type</label>
          <select class="form-select" id="lgRuleType" name="rule_type"><option value="allow">allow (force clean)</option><option value="block">block (force malicious)</option></select></div>
        <div class="mb-3"><label class="form-label">Pattern</label>
          <input type="text" class="form-control" id="lgRulePattern" name="pattern" placeholder="example.com or example.com/path">
          <small class="text-muted">Bare host (covers subdomains) or host/path. No scheme, no wildcards.</small></div>
        <div class="mb-3"><label class="form-label">Note <small class="text-muted">(optional)</small></label>
          <input type="text" class="form-control" id="lgRuleNote" name="note"></div>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-primary">Save rule</button></div>
    </form>
  </div></div>
</div>

<div class="modal fade" id="lgHostModal" tabindex="-1">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="view_linkguard.cfm">
      <input type="hidden" name="lg_action" value="add_abused_host">
      <div class="modal-header"><h5 class="modal-title">Add abused / redirector host</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">
        <div class="mb-3"><label class="form-label">Host</label>
          <input type="text" class="form-control" id="lgHostName" name="host" placeholder="badhost.example">
          <small class="text-muted">Bare host only (covers subdomains). No scheme, no path, no wildcards.</small></div>
        <div class="mb-3"><label class="form-label">Note <small class="text-muted">(optional)</small></label>
          <input type="text" class="form-control" id="lgHostNote" name="note"></div>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-primary">Add host</button></div>
    </form>
  </div></div>
</div>

<!-- CLEAR VERDICT CACHE MODAL -->
<div class="modal fade" id="clearCacheModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_linkguard.cfm">
        <input type="hidden" name="lg_action" value="clear_cache">
        <div class="modal-header bg-warning">
          <h5 class="modal-title">Clear Verdict Cache</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Clear the <strong>entire</strong> verdict cache? Every protected link will be re-evaluated from scratch on its next click.</p>
          <div class="alert alert-warning mb-2">
            <i class="fas fa-exclamation-triangle me-1"></i>
            This also drops cached <strong>Google Safe Browsing</strong> and <strong>VirusTotal</strong> results, so those links get <strong>re-queried against the provider APIs</strong> &mdash; consuming additional lookups against your daily / rate-limit quota.
          </div>
          <p class="mb-0 text-muted">You don't normally need this &mdash; removing a host or changing a rule already clears the affected cache automatically. Use this only to force a full re-check.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-warning">Yes, Clear Cache</button>
        </div>
      </form>
    </div>
  </div>
</div>

</div></section>
</main>
<cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
