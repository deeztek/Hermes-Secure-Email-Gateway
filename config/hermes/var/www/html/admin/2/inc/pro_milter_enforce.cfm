<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
PRO MILTER ENFORCEMENT (#276) -- license-lapse teardown for body-milter Pro
features.

The body milter has no license awareness: it acts whenever the dispatch
map/key files written by the (Pro-gated, fingerprinted) console exist. So a box
that loses its Pro license would keep applying disclaimers and rewriting Link
Guard links indefinitely, because nothing clears those files on downgrade.

This teardown is NON-DESTRUCTIVE: it stops NEW Pro activity by blanking only the
dispatch MAPS; it NEVER touches the HMAC keys (not the milter copies, not the
container copies, not the canonical key). So links already in mailboxes keep
verifying + redirecting and age out naturally via the token TTL, and a renew /
re-enable resumes minting with the SAME key -- nothing ever breaks. (Destroying
keys would orphan every in-flight safe-link; only ever harmful, so we don't.)

It is itself a fingerprinted Pro template (pro_templates.json), so editing it out
trips tamper detection. It runs ONLY on a server-confirmed license loss
(REVOKED / EXPIRED / INVALID). It is deliberately NOT run on TAMPERED (usually a
benign fingerprint mismatch during an upgrade before the manifest is republished,
not piracy) nor the transient states (N/A / PENDING_VALIDATION /
GRACE_PERIOD_EXPIRED) -- those gate the UI + show the alert, no teardown.

Scope: the three body-modification Pro features.
  - Disclaimers    -> blank disclaimer_by_sender (stop appending disclaimers)
  - Link Guard     -> blank linkguard_by_recipient_domain (stop rewriting NEW
                      inbound links). Keys untouched -> in-flight links resolve.
  - Org Signatures -> SELECTIVE: org sigs share SignatureModifier + the
                      signature_by_sender map with PERSONAL signatures (free).
                      Map is "<sender>\t<option>"; org entries are "org_<id>",
                      personal are "user_<...>". Drop only org_ lines.

Caller: setsession.cfm (login-time, server-confirmed loss). No-login backstop:
schedule/message_cleanup.cfm (edition-neutral host) gated on NOT isRetentionEnabled().
NOT in scope: RemoteAuth (pass-through auth; teardown would lock users out -- gate
+ alert only).

Idempotent: only rewrites a file that currently has content.
--->

<cftry>
    <!--- Stop NEW Pro activity by blanking ONLY the dispatch maps. HMAC keys are
         never touched, so already-delivered Link Guard links keep resolving and
         age out via the token TTL; renew/re-enable repopulates the scope map and
         minting resumes with the same key. --->
    <cfset teardownFiles = [
        "/etc/hermes/body_milter/disclaimers/disclaimer_by_sender",
        "/etc/hermes/body_milter/linkguard/linkguard_by_recipient_domain"
    ]>
    <cfset proMilterTornDown = false>
    <cfloop array="#teardownFiles#" index="pf">
        <cfif FileExists(pf) AND Len(Trim(FileRead(pf)))>
            <cffile action="write" file="#pf#" output="" charset="utf-8" addnewline="no">
            <cfset proMilterTornDown = true>
        </cfif>
    </cfloop>

    <!--- Org signatures (SELECTIVE): the signature_by_sender map mixes Pro org
         entries (option "org_<id>") with free personal entries (option
         "user_<...>"). Drop only the org_ lines; keep personal sigs intact. --->
    <cfset sigMapFile = "/etc/hermes/body_milter/signatures/signature_by_sender">
    <cfif FileExists(sigMapFile)>
        <cfset sigRaw = FileRead(sigMapFile, "utf-8")>
        <cfset sigKept = "">
        <cfset sigDroppedOrg = false>
        <cfloop list="#sigRaw#" index="sigLn" delimiters="#Chr(10)#">
            <cfif Len(Trim(sigLn))>
                <cfset sigParts = ListToArray(sigLn, Chr(9))>
                <cfif ArrayLen(sigParts) GTE 2 AND Left(Trim(sigParts[2]), 4) EQ "org_">
                    <cfset sigDroppedOrg = true><!--- org sig: drop --->
                <cfelse>
                    <cfset sigKept &= sigLn & Chr(10)><!--- personal sig: keep --->
                </cfif>
            </cfif>
        </cfloop>
        <cfif sigDroppedOrg>
            <cffile action="write" file="#sigMapFile#" output="#sigKept#" charset="utf-8" addnewline="no">
            <cfset proMilterTornDown = true>
        </cfif>
    </cfif>

    <cfcatch type="any">
        <!--- never let enforcement break login; it retries on the next request --->
    </cfcatch>
</cftry>
