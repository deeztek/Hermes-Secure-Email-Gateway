<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
DISCLAIMER WRITE (#214 Phase 3).

Regenerates the body_milter disclaimer file set from the disclaimers
table. The hermes_body_milter container watches these files via
mtime polling and reloads automatically on the next message it
processes - no force-reload, no docker exec, no service signal.

  /etc/hermes/body_milter/disclaimers/files/<option>.txt    plain-text
  /etc/hermes/body_milter/disclaimers/files/<option>.html   html
  /etc/hermes/body_milter/disclaimers/disclaimer_by_sender  sender->option map

Where <option> is "domain_<sanitized_domain>" or
"relay_<sanitized_address>" (non-alphanumerics replaced with _).

Pipeline placement: this fires AFTER the DB write in
save_disclaimer_action.cfm and disclaimer_delete.cfm. The body milter
sits in postfix's smtpd_milters chain, BEFORE amavis and Ciphermail,
modifying the body at message ingress. OpenDKIM at :10026 signs the
final composed message, so Hermes' DKIM covers the disclaimer. See
docs/admin/email-policies/disclaimers.md for full pipeline notes.

Reply-chain dedup is via the HERMES_DISCLAIMER_V1 sentinel marker
embedded in every generated file. The milter detects the marker and
skips when it's already present in the body.

Sets session.disclaimerApplySuccess = true/false.
session.disclaimerApplyError holds the error message if false.
--->

<cftry>

<!--- Pull all enabled disclaimers. Disabled rows are skipped - no
     map entry, no file written, milter never matches them. --->
<cfquery name="getDisclaimers" datasource="hermes">
    SELECT scope, scope_key, position, body_text, body_html
    FROM disclaimers
    WHERE enabled = 1
    ORDER BY scope ASC, scope_key ASC
</cfquery>

<!--- WIPE the per-scope files (NOT the directory itself) before
     regenerating. Catches deletions and scope_key renames in a single
     sweep so we never leak stale files. The directory itself is a
     Docker bind-mount target shared with hermes_body_milter; deleting
     and recreating the directory orphans the milter's view. Targeted
     file deletes preserve the dir inode. --->
<cfif NOT DirectoryExists("/etc/hermes/body_milter/disclaimers/files")>
    <cfdirectory action="create" directory="/etc/hermes/body_milter/disclaimers/files" mode="755" />
<cfelse>
    <cfset existingFiles = DirectoryList("/etc/hermes/body_milter/disclaimers/files", false, "name")>
    <cfloop array="#existingFiles#" index="oldFile">
        <cfif Right(oldFile, 4) EQ ".txt" OR Right(oldFile, 5) EQ ".html">
            <cffile action="delete" file="/etc/hermes/body_milter/disclaimers/files/#oldFile#" />
        </cfif>
    </cfloop>
</cfif>

<!--- Sentinel marker baked into every file. The body_milter detects
     this string in subsequent messages and skips so reply chains
     don't accumulate duplicate disclaimers. --->
<cfset sentinel = "HERMES_DISCLAIMER_V1">

<!--- Build the map content while looping. --->
<cfset mapLines = "">

<cfloop query="getDisclaimers">

    <!--- Option-name (filename) and sender key (lookup):
           Domain scope -> option=domain_<safe>, sender=@<domain>
           Relay scope  -> option=relay_<safe>,  sender=<full_address>
         Non-alphanumeric chars in the source key are replaced with _
         so the option-name is filename-safe. --->
    <cfif scope EQ "domain">
        <cfset optionName = "domain_" & ReReplaceNoCase(scope_key, "[^A-Za-z0-9_]", "_", "all")>
        <cfset senderKey = "@" & scope_key>
    <cfelse>
        <cfset optionName = "relay_" & ReReplaceNoCase(scope_key, "[^A-Za-z0-9_]", "_", "all")>
        <cfset senderKey = scope_key>
    </cfif>

    <!--- Auto-derive plain-text part if the admin didn't supply a
         separate body_text via the Quill "edit plain-text separately"
         toggle. Strip <br>/<p>/<li> to newlines, drop other tags,
         collapse runs of newlines. --->
    <cfif Trim(body_text) EQ "">
        <cfset txt = ReReplaceNoCase(body_html, "<br\s*/?>", Chr(10), "all")>
        <cfset txt = ReReplaceNoCase(txt, "</p>|</li>", Chr(10), "all")>
        <cfset txt = ReReplaceNoCase(txt, "<[^>]+>", "", "all")>
        <cfset txt = ReReplaceNoCase(txt, "(\r?\n){3,}", Chr(10) & Chr(10), "all")>
        <cfset txt = Trim(txt)>
    <cfelse>
        <cfset txt = body_text>
    </cfif>

    <!--- Append the sentinel as visible text in the plain-text part
         (square-bracketed for visibility) and as an HTML comment in
         the html part (invisible to the recipient). Both forms match
         the same way in the milter's body_has_sentinel() check. --->
    <cfset txtOut = txt & Chr(10) & Chr(10) & "[" & sentinel & "]" & Chr(10)>
    <cfset htmlOut = body_html & Chr(10) & "<!-- " & sentinel & " -->" & Chr(10)>

    <cffile action="write" file="/etc/hermes/body_milter/disclaimers/files/#optionName#.txt"  output="#txtOut#"  charset="utf-8" addnewline="no">
    <cffile action="write" file="/etc/hermes/body_milter/disclaimers/files/#optionName#.html" output="#htmlOut#" charset="utf-8" addnewline="no">

    <cfset mapLines = mapLines & senderKey & Chr(9) & optionName & Chr(10)>
</cfloop>

<!--- Always write the map file even when empty - the milter mtime-stats
     this path on every message and treats absence as a load failure.
     Empty file = no entries = no disclaimer applied to anyone. --->
<cffile action="write" file="/etc/hermes/body_milter/disclaimers/disclaimer_by_sender" output="#mapLines#" charset="utf-8" addnewline="no">

<!--- No force-reload needed. The body milter mtime-watches the map
     and per-scope files; the file write above is enough to make the
     change take effect on the next message. Compare to the legacy
     amavis approach (#214 Phase 3 v1) which required a force-reload
     via docker exec - that's gone, simpler, and impossible to desync. --->

<cfset session.disclaimerApplySuccess = true>
<cfset session.disclaimerApplyError = "">

<cfcatch type="any">
    <cfset session.disclaimerApplySuccess = false>
    <cfset session.disclaimerApplyError = cfcatch.message>
</cfcatch>
</cftry>
