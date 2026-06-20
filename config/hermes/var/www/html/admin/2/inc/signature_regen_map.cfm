<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition (resolver
behavior is Pro-only; map regen still runs for Personal Signatures
on Community).
--->

<!---
SIGNATURE RESOLUTION + MAP/SENDER-DATA REGEN (#226 Phase 2B).

Walks all enabled mailboxes joined to their domain, picks the winning
signature per sender, and writes:

  /etc/hermes/body_milter/signatures/signature_by_sender
      sender -> option-name map for the milter SenderMap.
      Per-mailbox option is one of:
          user_<sanitized_email>   (Personal Signature)
          org_<orgsigs_id>         (Organizational Signature)

  /etc/hermes/body_milter/signatures/sender_data.json
      sender -> placeholder dict for milter substitution at message
      send time. Keys:
          user.first_name | user.last_name | user.title | user.phone
          user.mobile     | user.department | user.email
          org.name | org.phone | org.address | org.website | org.logo_url
          dept.name

      Empty values stay empty so missing data renders as blank, not
      as a literal {{...}} placeholder.

Resolution per mailbox:
  1. domains.allow_user_signatures = 1 AND user_signatures has an
     enabled non-empty row for mailboxes.username -> Personal Sig
  2. else mailboxes.department non-empty AND org_signatures matches
     (domain_id, department_label) AND enabled = 1 -> dept Org Sig
  3. else org_signatures matches (domain_id, department_label IS NULL)
     AND enabled = 1 -> domain default Org Sig
  4. else: not in map (no signature applied at message time)

Self-heal: also re-renders on disk every org_signatures row that
wins for at least one mailbox in this regen, via
inc/org_signature_write_files.cfm. So a deploy that wipes
/etc/hermes/body_milter/signatures/files/ recovers on next regen.

Caller variables (optional):
  signatureRegenSilent (bool, default false) - if true, skip the
      session.signatureApplySuccess / Error side effects so admin
      action handlers can manage their own flash state without
      stomping the user-portal Personal Sig editor's hooks.
--->

<cftry>

<cfset sigRegenRoot     = "/etc/hermes/body_milter/signatures">
<cfset sigRegenFilesDir = sigRegenRoot & "/files">
<cfset sigRegenMapFile  = sigRegenRoot & "/signature_by_sender">
<cfset sigRegenDataFile = sigRegenRoot & "/sender_data.json">

<cfif NOT DirectoryExists(sigRegenFilesDir)>
    <cfdirectory action="create" directory="#sigRegenFilesDir#" mode="755" />
</cfif>

<!--- All enabled-domain mailboxes with the columns the milter needs
     for substitution. ORDER BY username so the map is stable across
     regens (helps diff in audits). --->
<cfquery name="sigRegenMailboxes" datasource="hermes">
    SELECT m.username, m.domain_id,
           m.first_name, m.last_name, m.title, m.phone, m.mobile,
           m.department,
           d.allow_user_signatures,
           d.org_name, d.org_phone, d.org_address, d.org_website,
           d.org_logo_path
    FROM mailboxes m
    INNER JOIN domains d
        ON m.domain_id = d.id
       AND d.type = 'mailbox'
    ORDER BY m.username ASC
</cfquery>

<!--- Personal Sig presence by lowercased username. Only enabled rows
     with non-empty content count - matches the existing Personal Sig
     map-rebuild logic. --->
<cfquery name="sigRegenUserSigs" datasource="hermes">
    SELECT username, body_html, body_text
    FROM user_signatures
    WHERE enabled = 1
      AND (body_html IS NOT NULL OR body_text IS NOT NULL)
</cfquery>
<cfset sigRegenPersonalByEmail = {}>
<cfloop query="sigRegenUserSigs">
    <cfif Trim(body_html) NEQ "" OR Trim(body_text) NEQ "">
        <cfset sigRegenPersonalByEmail[LCase(Trim(username))] = true>
    </cfif>
</cfloop>

<!--- Org Sig lookup tables: by-department-per-domain + per-domain default. --->
<cfquery name="sigRegenOrgSigs" datasource="hermes">
    SELECT id, domain_id, department_label
    FROM org_signatures
    WHERE enabled = 1
</cfquery>
<cfset sigRegenOrgDept    = {}>   <!--- domain_id -> { lower(dept) -> id } --->
<cfset sigRegenOrgDefault = {}>   <!--- domain_id -> id --->
<cfloop query="sigRegenOrgSigs">
    <!--- NULL department_label = domain default. Lucee's default
         nullSupport=false maps NULL columns to "" so Trim/Len work
         the same as for empty strings here. --->
    <cfset sigRegenDeptRaw = Trim(department_label)>
    <cfif Len(sigRegenDeptRaw) EQ 0>
        <cfset sigRegenOrgDefault[domain_id] = id>
    <cfelse>
        <cfif NOT StructKeyExists(sigRegenOrgDept, domain_id)>
            <cfset sigRegenOrgDept[domain_id] = {}>
        </cfif>
        <cfset sigRegenOrgDept[domain_id][LCase(sigRegenDeptRaw)] = id>
    </cfif>
</cfloop>

<cfset sigRegenMapLines  = "">
<cfset sigRegenSenderData = {}>
<cfset sigRegenOrgUsedIds = {}>

<cfloop query="sigRegenMailboxes">
    <cfset sigRegenSender = LCase(Trim(username))>
    <cfif Len(sigRegenSender) EQ 0>
        <cfcontinue>
    </cfif>

    <!--- Resolve winner. --->
    <cfset sigRegenWinningOption = "">
    <cfif Val(allow_user_signatures) EQ 1
          AND StructKeyExists(sigRegenPersonalByEmail, sigRegenSender)>
        <cfset sigRegenWinningOption = "user_" & ReReplaceNoCase(Replace(sigRegenSender, "@", "_at_", "all"), "[^A-Za-z0-9_]", "_", "all")>
    <cfelse>
        <cfset sigRegenDeptKey = LCase(Trim(department))>
        <cfif Len(sigRegenDeptKey) GT 0
              AND StructKeyExists(sigRegenOrgDept, domain_id)
              AND StructKeyExists(sigRegenOrgDept[domain_id], sigRegenDeptKey)>
            <cfset sigRegenOsId = sigRegenOrgDept[domain_id][sigRegenDeptKey]>
            <cfset sigRegenWinningOption = "org_" & sigRegenOsId>
            <cfset sigRegenOrgUsedIds[sigRegenOsId] = true>
        <cfelseif StructKeyExists(sigRegenOrgDefault, domain_id)>
            <cfset sigRegenOsId = sigRegenOrgDefault[domain_id]>
            <cfset sigRegenWinningOption = "org_" & sigRegenOsId>
            <cfset sigRegenOrgUsedIds[sigRegenOsId] = true>
        </cfif>
    </cfif>

    <cfif Len(sigRegenWinningOption) EQ 0>
        <cfcontinue>
    </cfif>

    <cfset sigRegenMapLines = sigRegenMapLines & sigRegenSender & Chr(9) & sigRegenWinningOption & Chr(10)>

    <!--- Substitution dict. Trim() handles both Lucee nullSupport
         modes uniformly (NULL -> "" via the empty-string default). --->
    <cfset sigRegenSenderData[sigRegenSender] = {
        "user.first_name" = Trim(first_name),
        "user.last_name"  = Trim(last_name),
        "user.title"      = Trim(title),
        "user.phone"      = Trim(phone),
        "user.mobile"     = Trim(mobile),
        "user.department" = Trim(department),
        "user.email"      = sigRegenSender,
        "org.name"        = Trim(org_name),
        "org.phone"       = Trim(org_phone),
        "org.address"     = Trim(org_address),
        "org.website"     = Trim(org_website),
        "org.logo_url"    = Trim(org_logo_path),
        "dept.name"       = Trim(department)
    }>
</cfloop>

<!--- Always write the map and data files even when empty. The milter
     mtime-stats both paths and treats absence as a load failure. --->
<cffile action="write" file="#sigRegenMapFile#"  output="#sigRegenMapLines#"                   charset="utf-8" addnewline="no">
<cffile action="write" file="#sigRegenDataFile#" output="#SerializeJSON(sigRegenSenderData)#"  charset="utf-8" addnewline="no">

<!--- Self-heal: render any org sig file dir that the new map points
     at but is missing on disk. The save / delete action handlers
     re-render their own row eagerly, so this loop only fires on
     true drift (volume reset, deploy partial, manual rm). Skips
     the cffile work for the steady-state case. --->
<cfloop collection="#sigRegenOrgUsedIds#" item="sigRegenOsHealId">
    <cfset sigRegenHealDir = sigRegenFilesDir & "/org_" & sigRegenOsHealId>
    <cfif NOT FileExists(sigRegenHealDir & "/body.html")>
        <cfset orgSignatureWriteRowId = sigRegenOsHealId>
        <cfinclude template="org_signature_write_files.cfm" />
    </cfif>
</cfloop>

<cfif NOT (isDefined("signatureRegenSilent") AND signatureRegenSilent)>
    <cfset session.signatureApplySuccess = true>
    <cfset session.signatureApplyError   = "">
</cfif>

<cfcatch type="any">
    <cfif NOT (isDefined("signatureRegenSilent") AND signatureRegenSilent)>
        <cfset session.signatureApplySuccess = false>
        <cfset session.signatureApplyError   = cfcatch.message>
    </cfif>
</cfcatch>
</cftry>
