<!DOCTYPE html>
<!--- Where Save and Cancel go back to. The same editor now serves two lists:
     Relay Recipients, and Mailboxes, where it is the only way to send a
     mailbox user's mail somewhere other than the local store.

     Matched against a fixed set rather than used as given. A return path
     taken from the query string and handed to cflocation is an open redirect
     if it is ever trusted verbatim. --->
<cfparam name="returnTo" default="">
<cfif StructKeyExists(url, "returnTo")>
    <cfset returnTo = url.returnTo>
<cfelseif StructKeyExists(form, "returnTo")>
    <cfset returnTo = form.returnTo>
</cfif>
<cfset backUrl   = (returnTo EQ "mailboxes") ? "view_mailboxes.cfm" : "view_internal_recipients.cfm">
<cfset backLabel = (returnTo EQ "mailboxes") ? "Back to Mailboxes"  : "Back to Recipients">
<!--- The Mailboxes row action is labelled "Edit Mail Delivery", so the page
     it opens should not be headed "Edit Backend Server". --->
<cfset pageTitle = (returnTo EQ "mailboxes") ? "Edit Mail Delivery" : "Edit Backend Server">

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <cfoutput><title>Hermes SEG | #pageTitle#</title></cfoutput>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput><h1 class="m-0">#pageTitle#</h1></cfoutput>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><cfoutput><a href="#backUrl#"><cfif returnTo EQ "mailboxes">Mailboxes<cfelse>Relay Recipients</cfif></a></cfoutput></li>
              <cfoutput><li class="breadcrumb-item active">#pageTitle#</li></cfoutput>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!--- PARAMETER VALIDATION --->
<cfparam name="m" default="0">
<cfif StructKeyExists(session, "backendMessage")>
    <cfset m = session.backendMessage>
    <cfset StructDelete(session, "backendMessage")>
</cfif>


<cfparam name="ids" default="">
<cfif StructKeyExists(url, "ids")>
    <cfset ids = url.ids>
<cfelseif StructKeyExists(form, "ids")>
    <cfset ids = form.ids>
</cfif>

<!--- Validate IDs --->
<cfif ids EQ "">
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">No recipients selected. Please select at least one recipient.</p>
    </div>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
    <cfabort>
</cfif>

<!--- Split IDs into array and validate each is integer --->
<cfset idArray = ListToArray(ids)>
<cfset validIds = []>
<cfloop array="#idArray#" item="thisId">
    <cfif IsValid("integer", thisId)>
        <cfset ArrayAppend(validIds, thisId)>
    </cfif>
</cfloop>

<cfif ArrayLen(validIds) EQ 0>
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">Invalid recipient IDs provided.</p>
    </div>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
    <cfabort>
</cfif>

<!--- Get selected recipients --->
<cfquery name="getSelectedRecipients" datasource="hermes">
    SELECT id, recipient, backend_server, backend_port, backend_tls
    FROM recipients
    WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
    ORDER BY recipient
</cfquery>

<!--- Prefill the form from what the selected recipients already have.

     The page previously rendered the fields blank and pre-checked "Use Domain
     Default" regardless, so editing an existing override meant retyping the
     server and port from scratch while the header displayed the very values
     being asked for. Worse, the port silently showed 25 rather than the one in
     force, so a careless save would quietly move the recipient to a different
     port.

     Bulk edit is why it was built this way: several recipients can be selected
     at once and they need not agree. So prefill only when they DO agree, and
     say plainly when they do not rather than showing one recipient's values as
     if they applied to all.

     A unit separator joins the three columns because none of them can contain
     it, unlike any character a hostname or TLS mode might legitimately use. --->
<cfset prefillServer = "">
<cfset prefillPort   = 25>
<cfset prefillTls    = "may">
<cfset prefillCustom = false>
<cfset prefillMixed  = false>

<cfset backendSigs = []>
<cfloop query="getSelectedRecipients">
    <cfif Len(Trim(getSelectedRecipients.backend_server))>
        <cfset ArrayAppend(backendSigs, Trim(getSelectedRecipients.backend_server) & Chr(31)
                                      & val(getSelectedRecipients.backend_port)    & Chr(31)
                                      & Trim(getSelectedRecipients.backend_tls))>
    <cfelse>
        <cfset ArrayAppend(backendSigs, "")>
    </cfif>
</cfloop>

<cfset backendAllSame = true>
<cfloop from="2" to="#ArrayLen(backendSigs)#" index="sigIdx">
    <cfif backendSigs[sigIdx] NEQ backendSigs[1]>
        <cfset backendAllSame = false>
        <cfbreak>
    </cfif>
</cfloop>

<!--- An override pointing at hermes_dovecot IS the built-in server; it is what
     choosing Built-in writes. Treating it as a Custom backend and filling the
     host and port boxes with it was true to the data and nonsense to read: the
     page reported a converted mailbox as a custom backend that happens to be
     us. --->
<cfset prefillBuiltin = false>
<cfif backendAllSame AND Len(backendSigs[1])
      AND FindNoCase("hermes_dovecot", ListFirst(backendSigs[1], Chr(31))) GT 0>
    <cfset prefillBuiltin = true>
</cfif>

<cfif backendAllSame AND Len(backendSigs[1]) AND NOT prefillBuiltin>
    <!--- includeEmptyFields, because an empty TLS mode would otherwise shift
         the port into its place. --->
    <cfset sigParts = ListToArray(backendSigs[1], Chr(31), true)>
    <cfset prefillServer = sigParts[1]>
    <cfset prefillPort   = sigParts[2]>
    <cfset prefillTls    = ArrayLen(sigParts) GTE 3 AND Len(sigParts[3]) ? sigParts[3] : "may">
    <cfset prefillCustom = true>
<cfelseif NOT backendAllSame>
    <cfset prefillMixed = true>
</cfif>

<!--- A failed save redisplays what was typed, not what is stored. --->
<cfif StructKeyExists(form, "backend_type")>
    <cfset prefillCustom  = (form.backend_type EQ "custom")>
    <cfset prefillBuiltin = (form.backend_type EQ "builtin")>
    <cfset prefillMixed   = false>
</cfif>
<cfif StructKeyExists(form, "custom_server")><cfset prefillServer = form.custom_server></cfif>
<cfif StructKeyExists(form, "custom_port") AND Len(Trim(form.custom_port))><cfset prefillPort = form.custom_port></cfif>
<cfif StructKeyExists(form, "custom_tls") AND Len(Trim(form.custom_tls))><cfset prefillTls = form.custom_tls></cfif>

<!--- Where "Use Domain Default" actually sends, and whether choosing it would
     orphan a mailbox.

     On a mailbox domain the domain default is lmtp to the built-in server, so
     clearing an override brings mail back to the local mailbox. On a hybrid
     domain the domain default is the provider, so clearing it sends mail away
     from a local mailbox that stays sitting there, active and quota'd,
     receiving nothing. The same option means opposite things and the page said
     neither.

     Still allowed, because sending a converted person back to the provider is
     a legitimate thing to want when they are leaving or you have changed your
     mind. It just has to say so. --->
<cfquery name="selectedDomains" datasource="hermes">
    SELECT d.domain, d.type,
           COALESCE(t.transport, '') AS domain_transport,
           SUM(CASE WHEN r.recipient_type = 'mailbox' THEN 1 ELSE 0 END) AS mailbox_count
      FROM recipients r
      JOIN domains d ON d.domain = SUBSTRING_INDEX(r.recipient, '@', -1)
      LEFT JOIN transport t ON t.id = d.transport_id
     WHERE r.id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
     GROUP BY d.domain, d.type, t.transport
     ORDER BY d.domain ASC
</cfquery>

<cfquery name="selectedMailboxes" datasource="hermes">
    SELECT COUNT(*) AS n FROM recipients
     WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
       AND recipient_type = 'mailbox'
</cfquery>
<cfset selectedMailboxCount = Val(selectedMailboxes.n)>

<!--- Nextcloud is a mailbox attribute: nextcloud_enabled exists on mailboxes
     and domains, never on recipients, and only the mailbox flows grant or
     remove cn=nextcloud. So a reverted recipient cannot keep it; there is no
     column to record it and nothing that would ever clean it up. --->
<cfquery name="selectedNcMailboxes" datasource="hermes">
    SELECT COUNT(*) AS n
      FROM recipients r
      JOIN mailboxes m ON m.username = r.recipient
     WHERE r.id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
       AND r.recipient_type = 'mailbox'
       AND m.nextcloud_enabled = 1
</cfquery>
<cfset selectedNcCount = Val(selectedNcMailboxes.n)>

<!--- Aliases that deliver INTO the selected mailboxes. A hybrid domain can have
     them: view_mailbox_aliases.cfm and add_mailbox_alias_action.cfm both accept
     'hybrid', so sales@ can be pointed at a converted mailbox.

     Reverting deletes them, which is right because the mailbox is going and
     they would deliver nowhere, and it is what deleting a mailbox already
     does. It should not be a surprise, so it is counted here and disclosed in
     the confirmation. --->
<cfquery name="selectedAliasesIn" datasource="hermes">
    SELECT ma.alias_address
      FROM mailbox_aliases ma
      JOIN recipients r ON r.recipient = ma.delivers_to
     WHERE r.id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
       AND r.recipient_type = 'mailbox'
     ORDER BY ma.alias_address ASC
</cfquery>
<cfset selectedAliasCount = selectedAliasesIn.recordcount>

<!--- Exemptions pointing an address at itself. Converting creates these to lift
     a recipient out of a domain catch-all, and only ever for addresses nobody
     had made an individual decision about.

     Reverting removes them, because otherwise reverting is not a revert: before
     the conversion the catch-all applied and mail went to its target, and
     leaving the entry behind means mail now goes to the domain's backend under
     the recipient's own name instead. A silent change in where someone's mail
     ends up, caused by undoing something.

     Identified by system = '3', which only the conversion writes, rather than
     by the row pointing at itself. There is no history of what a conversion
     did, so without a marker this would be a guess from the shape of the row,
     and it would take an exemption somebody created by hand along with it. --->
<!--- virtual_recipients only. A conversion can also write the exemption into
     mailbox_aliases, when that is where the catch-all lives, but those are
     already counted and removed by the alias handling above: a self-pointing
     alias has delivers_to equal to the address, so the existing "aliases
     delivering to this mailbox" query and deletion cover it. Counting it here
     too would report it twice. mailbox_aliases has no system column to mark
     either way. --->
<cfquery name="selectedSelfExempt" datasource="hermes">
    SELECT vr.virtual_address AS addr, 'virtual' AS src
      FROM virtual_recipients vr
      JOIN recipients r ON LOWER(r.recipient) = LOWER(vr.virtual_address)
     WHERE r.id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
       AND r.recipient_type = 'mailbox'
       AND vr.system = '3'
</cfquery>
<cfset selectedExemptCount = selectedSelfExempt.recordcount>

<cfquery name="overrideCount" datasource="hermes">
    SELECT COUNT(*) AS n FROM recipients
     WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
       AND backend_server IS NOT NULL AND backend_server <> ''
</cfquery>
<!--- Offering "Use Domain Default" when every selected recipient is already on
     it is an option that does nothing, and it then needs a paragraph
     explaining what it would do, competing with the decision actually being
     made. Shown only when there is an override to clear. --->
<cfset allOnDomainDefault = (Val(overrideCount.n) EQ 0)>

<!--- A mailbox on a domain whose default is not the built-in server can never
     receive mail: the domain sends it to the provider instead. There is no
     configuration in which that is what someone wanted, so it is not a warning,
     it is a state the page should not be able to produce. Sending a converted
     person back to the provider is still available, and better served by
     Revert, which also removes the mailbox that would otherwise sit there
     dead, or by Custom, which at least names the destination. Set below, once
     orphanWarnings is known. --->

<!--- Which selected addresses have their mail redirected before Postfix gets
     to decide where to deliver, split by whether anyone made a decision about
     that address specifically.

     Postfix expands virtual_alias_maps during cleanup, so a redirected address
     is rewritten before transport_maps is read and a Built-in conversion
     delivers nothing while every check passes. Computed here, at render time,
     rather than only on submit: the fix for the catch-all case is something to
     offer before the choice is made, not to report after it.

       redirectCatchAll   only the domain catch-all matches. Nobody decided
                          anything about this address, so exempting it is safe
                          to offer.
       redirectExplicit   the address has its own entry pointing elsewhere.
                          Someone deliberately forwards it, and overwriting
                          that silently would be wrong, so it is refused.

     Each row is address, source table, matched key, targets, Chr(31)
     separated. The two source tables are different features with different
     names in the console, Email Relay > Virtual Recipients and Email Server >
     Aliases, so which matched is carried through to the message. --->
<cfset redirectCatchAll  = "">
<cfset redirectExplicit  = "">

<cfquery name="selectedAddrs" datasource="hermes">
    SELECT recipient FROM recipients
     WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
     ORDER BY recipient ASC
</cfquery>

<cfloop query="selectedAddrs">
    <cfset rAddr   = LCase(Trim(selectedAddrs.recipient))>
    <cfset rDomain = ListLast(rAddr, "@")>

    <cfquery name="rSpecific" datasource="hermes">
        SELECT 'virtual' AS src, maps AS target FROM virtual_recipients
         WHERE LOWER(virtual_address) = <cfqueryparam value="#rAddr#" cfsqltype="cf_sql_varchar">
        UNION ALL
        SELECT 'alias' AS src, delivers_to AS target FROM mailbox_aliases
         WHERE LOWER(alias_address) = <cfqueryparam value="#rAddr#" cfsqltype="cf_sql_varchar">
           AND delivers_to <> 'discard:silently'
    </cfquery>

    <cfif rSpecific.recordcount GTE 1>
        <!--- An address mapped to itself is the standard way to exempt one
             recipient from a catch-all. Several targets including itself is
             also fine: the local copy still arrives. --->
        <cfset rKeepsLocal = false>
        <cfloop query="rSpecific">
            <cfloop list="#rSpecific.target#" index="rTarget">
                <cfif LCase(Trim(rTarget)) EQ rAddr><cfset rKeepsLocal = true></cfif>
            </cfloop>
        </cfloop>
        <cfif NOT rKeepsLocal>
            <cfset redirectExplicit = ListAppend(redirectExplicit,
                  rAddr & Chr(31) & rSpecific.src & Chr(31) & rAddr
                  & Chr(31) & ValueList(rSpecific.target), ";")>
        </cfif>
    <cfelse>
        <cfquery name="rCatchAll" datasource="hermes">
            SELECT 'virtual' AS src, maps AS target FROM virtual_recipients
             WHERE LOWER(virtual_address) = <cfqueryparam value="@#rDomain#" cfsqltype="cf_sql_varchar">
            UNION ALL
            SELECT 'alias' AS src, delivers_to AS target FROM mailbox_aliases
             WHERE LOWER(alias_address) = <cfqueryparam value="@#rDomain#" cfsqltype="cf_sql_varchar">
               AND delivers_to <> 'discard:silently'
        </cfquery>
        <cfif rCatchAll.recordcount GTE 1>
            <cfset redirectCatchAll = ListAppend(redirectCatchAll,
                  rAddr & Chr(31) & rCatchAll.src & Chr(31) & "@" & rDomain
                  & Chr(31) & ValueList(rCatchAll.target), ";")>
        </cfif>
    </cfif>
</cfloop>

<cfset redirectCatchAllCount = ListLen(redirectCatchAll, ";")>
<cfset redirectExplicitCount = ListLen(redirectExplicit, ";")>

<!--- One shared cause stated once beats the same sentence forty times, which
     is the size the bulk case actually is. --->
<cfset catchAllKey = "">
<cfset catchAllTo  = "">
<cfset catchAllSrc = "">
<cfif redirectCatchAllCount GT 0>
    <cfset firstRow    = ListFirst(redirectCatchAll, ";")>
    <cfset catchAllSrc = ListGetAt(firstRow, 2, Chr(31))>
    <cfset catchAllKey = ListGetAt(firstRow, 3, Chr(31))>
    <cfset catchAllTo  = ListGetAt(firstRow, 4, Chr(31))>
    <cfloop list="#redirectCatchAll#" index="rRow" delimiters=";">
        <cfif ListGetAt(rRow, 3, Chr(31)) NEQ catchAllKey><cfset catchAllKey = ""></cfif>
    </cfloop>
</cfif>

<cfset defaultGoesTo   = "">
<cfset orphanWarnings  = "">
<cfloop query="selectedDomains">
    <cfif selectedDomains.recordcount EQ 1 AND Len(Trim(selectedDomains.domain_transport))>
        <cfset defaultGoesTo = Trim(selectedDomains.domain_transport)>
    </cfif>
    <!--- Only a mailbox can be orphaned, and only where the domain default is
         not the built-in server. --->
    <cfif Val(selectedDomains.mailbox_count) GT 0
          AND FindNoCase("hermes_dovecot", selectedDomains.domain_transport) EQ 0>
        <cfset orphanWarnings = ListAppend(orphanWarnings,
              selectedDomains.domain & Chr(31) & Val(selectedDomains.mailbox_count)
              & Chr(31) & Trim(selectedDomains.domain_transport), ";")>
    </cfif>
</cfloop>

<cfset defaultWouldOrphan = Len(orphanWarnings) GT 0>

<cfif getSelectedRecipients.recordcount LT 1>
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">Selected recipients not found.</p>
    </div>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
    <cfabort>
</cfif>

<!--- PROCESS FORM SUBMISSION --->
<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
    <cfset action = form.action>
</cfif>

<cfif action EQ "save">
    <cfparam name="backend_type" default="default">
    <cfif StructKeyExists(form, "backend_type")>
        <cfset backend_type = form.backend_type>
    </cfif>

    <cfif backend_type EQ "default" AND defaultWouldOrphan>
        <!--- The radio is not rendered in this case, but a hidden control is
             not a validation. A mailbox whose domain default is not the
             built-in server would receive nothing. --->
        <cfset m = "error_default_would_orphan">

    <cfelseif backend_type EQ "default">
        <!--- Clear backend override (set to NULL) --->
        <cfquery datasource="hermes">
            UPDATE recipients
            SET backend_server = NULL,
                backend_port = NULL,
                backend_tls = NULL,
                backend_transport = NULL
            WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
        </cfquery>
        <!--- Regenerate the per-destination TLS policy map (#157).

             transport_maps is a live MySQL lookup, so routing needs nothing
             here. smtp_tls_policy_maps is a hash file, so a changed or
             cleared backend_tls only takes effect once this rewrites it and
             runs postmap.

             datasource is set first because generate_tls_policy.cfm reads it
             and does not default it, the same as every other caller. --->
        <cfset datasource = "hermes">
        <cfinclude template="inc/generate_tls_policy.cfm">
        <cfset session.backendMessage = "success_default">
        <cflocation url="#backUrl#" addtoken="no">

    <cfelseif backend_type EQ "custom">
        <!--- Validate custom backend fields --->
        <cfparam name="custom_server" default="">
        <cfparam name="custom_port" default="25">
        <cfparam name="custom_tls" default="may">

        <cfif StructKeyExists(form, "custom_server")>
            <cfset custom_server = Trim(form.custom_server)>
        </cfif>
        <cfif StructKeyExists(form, "custom_port")>
            <cfset custom_port = form.custom_port>
        </cfif>
        <cfif StructKeyExists(form, "custom_tls")>
            <cfset custom_tls = form.custom_tls>
        </cfif>

        <!--- Validate server --->
        <cfif custom_server EQ "">
            <cfset m = "error_server_empty">
        <cfelseif NOT IsValid("integer", custom_port) OR custom_port LT 1 OR custom_port GT 65535>
            <cfset m = "error_port_invalid">
        <cfelseif NOT ListFindNoCase("none,may,encrypt", custom_tls)>
            <cfset m = "error_tls_invalid">
        <cfelse>
            <!--- Save custom backend override --->
            <cfquery datasource="hermes">
                UPDATE recipients
                SET backend_server = <cfqueryparam value="#custom_server#" cfsqltype="cf_sql_varchar">,
                    backend_port = <cfqueryparam value="#custom_port#" cfsqltype="cf_sql_integer">,
                    backend_tls = <cfqueryparam value="#custom_tls#" cfsqltype="cf_sql_varchar">,
                    <!--- Explicit, not left as it was. A recipient switched
                         here from the built-in server still carries
                         backend_transport = 'lmtp', and lmtp spoken at an
                         ordinary SMTP backend does not work. --->
                    backend_transport = 'smtp'
                WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
            </cfquery>
            <!--- Regenerate the per-destination TLS policy map (#157).

                 transport_maps is a live MySQL lookup, so routing needs nothing
                 here. smtp_tls_policy_maps is a hash file, so a changed or
                 cleared backend_tls only takes effect once this rewrites it and
                 runs postmap.

                 datasource is set first because generate_tls_policy.cfm reads
                 it and does not default it, the same as every other caller. --->
            <cfset datasource = "hermes">
            <cfinclude template="inc/generate_tls_policy.cfm">
            <cfset session.backendMessage = "success_custom">
            <cflocation url="#backUrl#" addtoken="no">
        </cfif>

    <cfelseif backend_type EQ "revert">
        <!--- #290. Undo a conversion.

             Deactivate rather than delete. The maildir may hold mail, and a
             conversion reversed by mistake should cost nothing. active = 0
             stops Dovecot's userdb resolving the address, so nothing is
             delivered there and nothing can log into it, while the row and the
             messages stay exactly where they are.

             The LDAP entry stays too, and only its role changes: out of
             cn=mailboxes, back into cn=relays. The credential is untouched,
             the same as on the way in. --->
        <cfquery name="toRevert" datasource="hermes">
            SELECT id, recipient, enforce_mfa
              FROM recipients
             WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
               AND recipient_type = 'mailbox'
             ORDER BY recipient ASC
        </cfquery>

        <cfparam name="revert_confirm" default="0">
        <cfif StructKeyExists(form, "revert_confirm")><cfset revert_confirm = form.revert_confirm></cfif>

        <cfif toRevert.recordcount LT 1>
            <cfset m = "error_revert_none">
        <cfelseif revert_confirm NEQ "1">
            <!--- Checked on the server as well as the form. This deletes mail. --->
            <cfset m = "error_revert_unconfirmed">
        <cfelse>
            <cfset revertedCount = 0>
            <cfloop query="toRevert">
                <cfset ldapUsername = LCase(toRevert.recipient)>
                <cfparam name="ldapAccessControl" default="one_factor">
                <cfset ldapAccessControl = (Val(toRevert.enforce_mfa) EQ 1) ? "two_factor" : "one_factor">

                <cfinclude template="inc/ldap_remove_user_groups_mailbox.cfm">
                <cfinclude template="inc/ldap_add_user_groups_relay.cfm">

                <!--- Everything below is scoped to the MAILBOX. The recipient,
                     its LDAP account, its user_settings and its certificates
                     are deliberately untouched, because the recipient is not
                     going away: it goes back to being a relay recipient with
                     the same login and carries on receiving mail at the
                     domain's backend.

                     This is why delete_mailbox_action.cfm cannot be reused. It
                     is correct when the recipient IS the mailbox: it strips the
                     access-control groups, deletes the recipients row, deletes
                     the LDAP account and deletes user_settings. Running it here
                     would delete the person along with the mailbox. --->
                <cfset revertAddr = toRevert.recipient>

                <cfquery datasource="hermes">
                    DELETE FROM sender_login_maps WHERE login_user = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfquery datasource="hermes">
                    DELETE FROM shared_mailbox_permissions WHERE username = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfquery datasource="hermes">
                    DELETE FROM dovecot_acl_shared WHERE to_user = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                       OR from_user = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfquery datasource="hermes">
                    DELETE FROM dovecot_acl WHERE username = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                       OR mailbox LIKE <cfqueryparam value="#revertAddr#/%" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfquery datasource="hermes">
                    DELETE FROM user_folder_shares WHERE shared_with_username = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                       OR owner_username = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfquery datasource="hermes">
                    DELETE FROM mailbox_aliases WHERE delivers_to = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                </cfquery>

                <!--- The exemption a conversion created, identified by its
                     marker rather than by its shape. Removed so the domain
                     catch-all applies to this address again, which is where it
                     was before converting; leaving it behind would silently
                     change where the mail goes as a result of undoing
                     something.

                     system = '3' is only ever written by the conversion above,
                     so an entry you made by hand is never touched, whatever it
                     points at. --->
                <cfquery datasource="hermes">
                    DELETE FROM virtual_recipients
                     WHERE LOWER(virtual_address) = <cfqueryparam value="#LCase(revertAddr)#" cfsqltype="cf_sql_varchar">
                       AND system = '3'
                </cfquery>
                <cftry>
                    <cfquery datasource="hermes">
                        DELETE FROM user_vacation WHERE email = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                <cfcatch type="any"></cfcatch>
                </cftry>

                <!--- Nextcloud, the same two steps delete_mailbox_action.cfm
                     takes: leave cn=nextcloud, then occ user:delete, which
                     removes the account's files, mail accounts and app
                     passwords. A relay recipient has no nextcloud_enabled
                     column, so leaving either behind would be a state nothing
                     could see or undo. Non-fatal, as there. --->
                <cftry>
                    <cfset ldapUsername = LCase(revertAddr)>
                    <cfinclude template="inc/ldap_remove_user_groups_nextcloud.cfm">
                <cfcatch type="any"></cfcatch>
                </cftry>
                <cftry>
                    <cfexecute name="/usr/local/bin/docker"
                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:delete #revertAddr#"
                        variable="revertNcOut" errorVariable="revertNcErr" timeout="120">
                    </cfexecute>
                <cfcatch type="any"></cfcatch>
                </cftry>

                <cfquery datasource="hermes">
                    DELETE FROM mailboxes WHERE username = <cfqueryparam value="#revertAddr#" cfsqltype="cf_sql_varchar">
                </cfquery>

                <!--- The maildir, same path and method delete_mailbox_action.cfm
                     uses. Non-fatal: a missing directory is the end state we
                     wanted anyway. --->
                <cftry>
                    <cfset revertLocal  = ListFirst(revertAddr, "@")>
                    <cfset revertDomain = ListLast(revertAddr, "@")>
                    <cfexecute name="/usr/local/bin/docker"
                        arguments="exec hermes_dovecot rm -rf /srv/mail/#revertDomain#/#revertLocal#"
                        variable="revertRmOut" errorVariable="revertRmErr" timeout="120">
                    </cfexecute>
                <cfcatch type="any"></cfcatch>
                </cftry>

                <cfset revertedCount = revertedCount + 1>
            </cfloop>

            <!--- Routing cleared and the role put back, so the domain's own
                 transport applies again, which is what a relay recipient has
                 always used. --->
            <cfquery datasource="hermes">
                UPDATE recipients
                   SET recipient_type    = 'relay',
                       backend_transport = NULL,
                       backend_server    = NULL,
                       backend_port      = NULL,
                       backend_tls       = NULL
                 WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                   AND recipient_type = 'mailbox'
            </cfquery>

            <!--- The domain stays hybrid. Another mailbox may still be hosted
                 on it, and a domain that once hosted one is a domain someone
                 may host one on again. Nothing breaks from a hybrid domain
                 with no mailboxes: Postfix never saw the distinction, and the
                 relay recipients on it are unaffected. --->

            <cfset datasource = "hermes">
            <cfinclude template="inc/generate_tls_policy.cfm">

            <cfset session.backendMessage = "success_revert">
            <cfset session.revertCount    = revertedCount>
            <cflocation url="#backUrl#" addtoken="no">
        </cfif>

    <cfelseif backend_type EQ "builtin">
        <!--- #290. Host these recipients here instead of sending their mail on.

             Two halves. The mailbox has to exist before the routing points at
             it, or mail arrives at a userdb that does not know the address and
             Dovecot refuses it, so provisioning runs first and routing is
             written after the loop.

             The provisioning itself is not written here. It runs
             inc/mailbox_provision_core.cfm, the same file Add Mailbox runs,
             with provisionMode = "convert". A second implementation of those
             steps would have started out identical and drifted the first time
             only one was updated. --->
        <cfparam name="builtin_quota_gb" default="5">
        <cfparam name="builtin_nextcloud" default="0">
        <cfparam name="builtin_reports" default="YES">
        <cfparam name="builtin_train_bayes" default="0">
        <cfparam name="builtin_download_msg" default="0">
        <cfloop list="builtin_quota_gb,builtin_nextcloud,builtin_reports,builtin_train_bayes,builtin_download_msg" index="bfld">
            <cfif StructKeyExists(form, bfld)><cfset variables[bfld] = Trim(form[bfld])></cfif>
        </cfloop>

        <cfif NOT IsNumeric(builtin_quota_gb) OR builtin_quota_gb LTE 0>
            <cfset m = "error_builtin_quota">
        <cfelse>

            <!--- An address that is already a mailbox has nothing to convert,
                 and running the provisioning again would try to insert a
                 second mailboxes row for it. Reject the whole batch rather
                 than silently skipping part of it, so the admin knows what
                 they selected. --->
            <cfquery name="alreadyMailbox" datasource="hermes">
                SELECT recipient FROM recipients
                 WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                   AND recipient_type = 'mailbox'
            </cfquery>

            <cfif alreadyMailbox.recordcount GTE 1>
                <cfset m = "error_builtin_already">
                <cfset session.builtinAlready = ValueList(alreadyMailbox.recipient)>
            <cfelse>

            <!--- Queried here rather than further down, because the alias
                 guard below reads it and a guard has to run before anything is
                 written. --->
            <cfquery name="toConvert" datasource="hermes">
                SELECT id, recipient, policy_id, pdf_enabled, smime_enabled, pgp_enabled,
                       digital_sign, auth_type, remoteauth_domain, enforce_mfa,
                       SUBSTRING_INDEX(recipient, '@', -1) AS recipient_domain
                  FROM recipients
                 WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                 ORDER BY recipient ASC
            </cfquery>

            <!--- The split was computed at render time, above, because the
                 catch-all case is something to offer a fix for before the
                 choice is made rather than report after it. Enforced here
                 regardless of what the form said. --->
            <cfparam name="builtin_exempt_catchall" default="0">
            <cfif StructKeyExists(form, "builtin_exempt_catchall")>
                <cfset builtin_exempt_catchall = form.builtin_exempt_catchall>
            </cfif>

            <cfset aliasedAway = redirectExplicit>
            <cfif redirectCatchAllCount GT 0 AND builtin_exempt_catchall NEQ "1">
                <!--- Redirected by a catch-all and the admin declined to exempt
                     them, so the mailboxes would receive nothing. --->
                <cfset aliasedAway = ListAppend(aliasedAway, redirectCatchAll, ";")>
            </cfif>

            <cfif Len(aliasedAway)>
                <cfset m = "error_builtin_aliased">
                <cfset session.builtinAliased = aliasedAway>
            <cfelse>

                <cfset convertedCount = 0>
                <cfset exemptedCount  = 0>
                <cfset convertSkipped  = "">

                <cfloop query="toConvert">

                    <!--- The domain must be a row in domains, which it is for
                         any relay recipient, and it is looked up WITHOUT a
                         type filter: this is the one place that deliberately
                         accepts a relay domain as a mailbox host. --->
                    <cfquery name="getDomain" datasource="hermes">
                        SELECT id, domain, default_quota_mb
                          FROM domains
                         WHERE domain = <cfqueryparam value="#toConvert.recipient_domain#" cfsqltype="cf_sql_varchar">
                         LIMIT 1
                    </cfquery>

                    <cfif getDomain.recordcount LT 1>
                        <cfset convertSkipped = ListAppend(convertSkipped, toConvert.recipient)>
                        <cfcontinue>
                    </cfif>

                    <cfset recipientEmail = toConvert.recipient>

                    <!--- Name from what the directory already gave us. --->
                    <cfinclude template="inc/resolve_recipient_display_name.cfm">
                    <cfset displayName = resolvedDisplayName>

                    <cfset quotaBytes = Round(builtin_quota_gb * 1024 * 1024 * 1024)>

                    <!--- Carried over from the recipient, not asked for. --->
                    <cfset form.policy            = toConvert.policy_id>
                    <cfset form.pdf_enabled       = toConvert.pdf_enabled>
                    <cfset form.smime_enabled     = toConvert.smime_enabled>
                    <cfset form.pgp_enabled       = toConvert.pgp_enabled>
                    <cfset form.sign              = toConvert.digital_sign>
                    <cfset form.auth_type         = toConvert.auth_type>
                    <cfset form.remoteauth_domain = Len(Trim(toConvert.remoteauth_domain)) ? toConvert.remoteauth_domain : "">
                    <cfset form.enforce_mfa       = Val(toConvert.enforce_mfa)>

                    <!--- From the form, one value for the whole batch. --->
                    <cfset form.quota_gb          = builtin_quota_gb>
                    <cfset form.nextcloud_enabled = builtin_nextcloud>
                    <cfset form.reports           = builtin_reports>
                    <cfset form.train_bayes       = builtin_train_bayes>
                    <cfset form.download_msg      = builtin_download_msg>
                    <cfset form.timezone          = "">

                    <!--- Empty on purpose. Step 7 of the core is guarded on
                         form.ca being non-empty, so no certificate is minted
                         by a conversion. An existing one is untouched and a
                         new one can be issued afterwards as usual. --->
                    <cfset form.ca = "">

                    <!--- enforce_mfa drives which Authelia group the account
                         joins, the same as Add Mailbox. --->
                    <cfset ldapAccessControl = (Val(toConvert.enforce_mfa) EQ 1) ? "two_factor" : "one_factor">

                    <!--- Exempt this address from the domain catch-all, if it
                         was caught by one and the admin asked for it. A
                         specific entry wins over @domain in Postfix's own
                         resolution order, so the rest of the domain keeps
                         being redirected exactly as before. Only ever created
                         for addresses nobody made an individual decision
                         about: one with its own entry pointing elsewhere was
                         refused above rather than overwritten. --->
                    <cfif builtin_exempt_catchall EQ "1">
                        <cfloop list="#redirectCatchAll#" index="exRow" delimiters=";">
                            <cfif LCase(ListGetAt(exRow, 1, Chr(31))) EQ LCase(recipientEmail)>
                                <cfif ListGetAt(exRow, 2, Chr(31)) EQ "virtual">
                                    <cfquery name="exExists" datasource="hermes">
                                        SELECT COUNT(*) AS n FROM virtual_recipients
                                         WHERE LOWER(virtual_address) = <cfqueryparam value="#LCase(recipientEmail)#" cfsqltype="cf_sql_varchar">
                                    </cfquery>
                                    <cfif Val(exExists.n) LT 1>
                                        <!--- system = '3' marks this as created by a
                                             conversion, so reverting can remove exactly
                                             what converting added instead of guessing from
                                             the shape of the row. '1' is system-managed and
                                             '2' is user-created; Postfix does not read the
                                             column, and the Virtual Recipients list does not
                                             filter on it, so a '3' is still visible and
                                             editable like any other. --->
                                        <cfquery datasource="hermes">
                                            INSERT INTO virtual_recipients (virtual_address, maps, system)
                                            VALUES (<cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                                                    <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">, '3')
                                        </cfquery>
                                    </cfif>
                                <cfelse>
                                    <cfquery name="exExists" datasource="hermes">
                                        SELECT COUNT(*) AS n FROM mailbox_aliases
                                         WHERE LOWER(alias_address) = <cfqueryparam value="#LCase(recipientEmail)#" cfsqltype="cf_sql_varchar">
                                    </cfquery>
                                    <cfif Val(exExists.n) LT 1>
                                        <cfquery datasource="hermes">
                                            INSERT INTO mailbox_aliases (alias_address, delivers_to, domain_id)
                                            VALUES (<cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                                                    <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                                                    <cfqueryparam value="#getDomain.id#" cfsqltype="cf_sql_integer">)
                                        </cfquery>
                                    </cfif>
                                </cfif>
                                <cfset exemptedCount = exemptedCount + 1>
                            </cfif>
                        </cfloop>
                    </cfif>

                    <cfset provisionMode = "convert">
                    <cfinclude template="inc/mailbox_provision_core.cfm">

                    <cfset convertedCount = convertedCount + 1>
                </cfloop>

                <!--- Routing, after the mailboxes exist. lmtp to the built-in
                     server, which beats the domain's own transport because the
                     transport lookup asks for the recipient first. backend_tls
                     is NULL: this is a container-to-container hop inside the
                     Docker network and never leaves the host. --->
                <cfquery datasource="hermes">
                    UPDATE recipients
                       SET backend_transport = 'lmtp',
                           backend_server    = 'hermes_dovecot',
                           backend_port      = 24,
                           backend_tls       = NULL
                     WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                </cfquery>

                <!--- Mark every domain involved as hybrid, so the console stops
                     treating it as relay-only and its new mailboxes become
                     visible and manageable. Relay domains stay in Postfix's
                     relay_domains either way, because that lookup excludes
                     type='mailbox' only, so the recipients left on the
                     provider are unaffected. A domain that is already
                     type='mailbox' is left alone. --->
                <cfquery datasource="hermes">
                    UPDATE domains
                       SET type = 'hybrid'
                     WHERE domain IN (
                             SELECT DISTINCT SUBSTRING_INDEX(recipient, '@', -1)
                               FROM recipients
                              WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                           )
                       AND (type IS NULL OR type NOT IN ('mailbox', 'hybrid'))
                </cfquery>

                <!--- The TLS policy map is keyed by destination, and clearing
                     backend_tls above has to be reflected in it. --->
                <cfset datasource = "hermes">
                <cfinclude template="inc/generate_tls_policy.cfm">

                <cfset session.backendMessage = "success_builtin">
                <cfset session.builtinCount   = convertedCount>
                <cfset session.builtinSkipped  = convertSkipped>
                <cfset session.builtinExempted = exemptedCount>
                <cflocation url="#backUrl#" addtoken="no">
            </cfif>
            </cfif>
        </cfif>
    </cfif>
</cfif>

<!--- ERROR/SUCCESS MESSAGES --->
<cfif m EQ "error_builtin_quota">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The mailbox quota must be a number greater than zero.
    </div>
<cfelseif m EQ "error_default_would_orphan">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> That would leave the mailbox receiving nothing</h5>
        <p class="mb-1">The domain default on this domain is not the built-in server, so a mailbox
        set to it can never receive mail.</p>
        <p class="mb-0"><small>Choose <strong>Built-in Email Server</strong> to deliver here,
        <strong>Custom Backend Server</strong> to send it somewhere specific, or
        <strong>Revert to Relay Recipient</strong> if the mailbox is no longer wanted.
        Nothing was changed.</small></p>
    </div>
<cfelseif m EQ "error_revert_unconfirmed">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Not confirmed</h5>
        Reverting deletes the mailbox and everything in it, so the confirmation box has to be ticked.
        Nothing was changed.
    </div>
<cfelseif m EQ "error_revert_none">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Nothing to revert</h5>
        None of the selected recipients has a mailbox on this server, so there is no conversion to undo.
    </div>
<cfelseif m EQ "error_builtin_aliased">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Mail for these addresses is redirected elsewhere</h5>
        <p class="mb-1">A mailbox here would never receive anything, because the recipient is rewritten
        before Postfix decides where to deliver:</p>
        <ul class="mb-2">
            <cfoutput><cfloop list="#StructKeyExists(session, 'builtinAliased') ? session.builtinAliased : ''#" index="aliasLine" delimiters=";">
            <cfset aliasAddr = ListGetAt(aliasLine, 1, Chr(31))>
            <cfset aliasSrc  = ListGetAt(aliasLine, 2, Chr(31))>
            <cfset aliasKey  = ListGetAt(aliasLine, 3, Chr(31))>
            <cfset aliasTo   = ListGetAt(aliasLine, 4, Chr(31))>
            <li>
                <code>#HTMLEditFormat(aliasAddr)#</code> goes to <code>#HTMLEditFormat(aliasTo)#</code>
                <cfif Left(aliasKey, 1) EQ "@">
                    via the <strong>#HTMLEditFormat(aliasKey)#</strong> catch-all
                <cfelse>
                    via its own entry
                </cfif>
                <cfif aliasSrc EQ "virtual">
                    under <strong>Email Relay &gt; Virtual Recipients</strong>
                <cfelse>
                    under <strong>Email Server &gt; Aliases</strong>
                </cfif>
            </li>
            </cfloop></cfoutput>
        </ul>
        <p class="mb-1"><strong>Nothing was changed.</strong> To host these here, give each address an
        entry of its own that points at itself. A specific entry wins over a catch-all, so the rest of
        the domain keeps being redirected as before.</p>
        <p class="mb-0"><small><cfoutput><cfloop list="#StructKeyExists(session, 'builtinAliased') ? session.builtinAliased : ''#" index="aliasLine" delimiters=";">
        <cfset aliasAddr = ListGetAt(aliasLine, 1, Chr(31))>
        <cfset aliasSrc  = ListGetAt(aliasLine, 2, Chr(31))>
        <cfif aliasSrc EQ "virtual">
        <a href="view_virtual_recipients.cfm">Virtual Recipients</a>: add
        <code>#HTMLEditFormat(aliasAddr)#</code> &rarr; <code>#HTMLEditFormat(aliasAddr)#</code><br>
        <cfelse>
        <a href="view_mailbox_aliases.cfm">Aliases</a>: add
        <code>#HTMLEditFormat(aliasAddr)#</code> &rarr; <code>#HTMLEditFormat(aliasAddr)#</code><br>
        </cfif>
        </cfloop></cfoutput></small></p>
    </div>
    <cfset StructDelete(session, "builtinAliased")>
<cfelseif m EQ "error_builtin_already">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Nothing to convert</h5>
        <p class="mb-1">These already have a mailbox on this server, so there is nothing to create for them:</p>
        <p class="mb-0"><strong><cfoutput>#HTMLEditFormat(StructKeyExists(session, "builtinAlready") ? session.builtinAlready : "")#</cfoutput></strong></p>
        <p class="mb-0 mt-2"><small>Nothing was changed. Deselect them and try again. To change where an existing
        mailbox's mail goes, use <strong>Edit Mail Delivery</strong> on the Mailboxes page.</small></p>
    </div>
    <cfset StructDelete(session, "builtinAlready")>
<cfelseif m EQ "error_server_empty">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The Backend Server field cannot be empty when using custom backend.
    </div>
</cfif>

<cfif m EQ "error_port_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The Port must be a valid number between 1 and 65535.
    </div>
</cfif>

<cfif m EQ "error_tls_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        Invalid TLS setting selected.
    </div>
</cfif>

<!--- BACK BUTTON --->
<p>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
</p>

<!--- SELECTED RECIPIENTS CARD --->
<div class="card card-outline card-info mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-users me-2"></i>Selected Recipients (<cfoutput>#getSelectedRecipients.recordcount#</cfoutput>)</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <cfoutput query="getSelectedRecipients">
                <div class="col-md-4 col-sm-6 mb-2">
                    <span class="badge bg-secondary me-1"><i class="fas fa-envelope me-1"></i>#recipient#</span>
                    <cfif Len(Trim(backend_server)) GT 0>
                        <!--- Name it rather than print the container host. The
                             built-in server reading as "hermes_dovecot:24" is
                             accurate and tells an administrator nothing. --->
                        <cfif FindNoCase("hermes_dovecot", backend_server) GT 0>
                            <small class="text-success">(built-in email server)</small>
                        <cfelse>
                        <small class="text-primary">(#backend_server#:#backend_port#)</small>
                        </cfif>
                    <cfelse>
                        <small class="text-muted">(domain default)</small>
                    </cfif>
                </div>
            </cfoutput>
        </div>
    </div>
</div>

<!--- BACKEND SETTINGS FORM --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-server me-2"></i>Backend Server Settings</h3>
    </div>
    <div class="card-body">
        <form method="post" action="">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="ids" value="<cfoutput>#ArrayToList(validIds)#</cfoutput>">
            <input type="hidden" name="returnTo" value="<cfoutput>#EncodeForHTMLAttribute(returnTo)#</cfoutput>">

            <cfoutput><cfif allOnDomainDefault AND Len(defaultGoesTo)>
            <div class="alert <cfif selectedMailboxCount GT 0 AND FindNoCase("hermes_dovecot", defaultGoesTo) EQ 0>alert-danger<cfelse>alert-secondary</cfif> py-2">
                <strong>Currently</strong>
                <cfif ListLen(ArrayToList(validIds)) GT 1>mail for the selected recipients goes to<cfelse>mail for this recipient goes to</cfif>
                <code>#HTMLEditFormat(defaultGoesTo)#</code>, the domain default.
                <cfif selectedMailboxCount GT 0 AND FindNoCase("hermes_dovecot", defaultGoesTo) EQ 0>
                <br><strong><cfif selectedMailboxCount NEQ 1>#selectedMailboxCount# of them have mailboxes<cfelse>This recipient has a mailbox</cfif> on this server, receiving nothing.</strong>
                </cfif>
            </div>
            </cfif></cfoutput>

            <div class="mb-3">
                <label class="form-label"><strong><cfoutput><cfif allOnDomainDefault>Change delivery to<cfelse>Backend Server</cfif></cfoutput></strong></label>

                <!--- #290. The third destination is Hermes itself. Choosing it
                     does more than change routing: the address has no mailbox
                     to deliver into, so one is created, which is why this
                     option carries settings and the other two do not. --->
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_builtin" value="builtin"<cfoutput><cfif prefillBuiltin> checked</cfif></cfoutput>>
                    <label class="form-check-label" for="backend_builtin">
                        <strong>Built-in Email Server</strong>
                        <br><small class="text-muted">Host these recipients' mail on Hermes instead of sending it on. Creates a mailbox for each one, keeping their existing login.</small>
                    </label>
                </div>

                <cfoutput><cfif NOT allOnDomainDefault AND NOT defaultWouldOrphan>
                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_default" value="default"<cfif NOT prefillCustom> checked</cfif>>
                    <label class="form-check-label" for="backend_default">
                        <strong>Use Domain Default</strong><cfif Len(defaultGoesTo)> <span class="badge bg-secondary">#HTMLEditFormat(defaultGoesTo)#</span></cfif>
                        <br><small class="text-muted">Route to the backend server configured in the recipient's domain settings</small>
                    </label>
                </div>
                </cfif></cfoutput>


                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_custom" value="custom"<cfoutput><cfif prefillCustom> checked</cfif></cfoutput>>
                    <label class="form-check-label" for="backend_custom">
                        <strong>Custom Backend Server</strong>
                        <br><small class="text-muted">Override domain default with a specific backend server for these recipients</small>
                    </label>
                </div>

                <cfoutput><cfif selectedMailboxCount GT 0>
                <hr class="my-3">
                <label class="form-label"><strong>Change what this recipient is</strong></label>
                </cfif></cfoutput>

                <!--- #290. Reverting is a separate intention from redirecting,
                     and conflating them is what made "Use Domain Default" read
                     like an undo when it is not: that leaves a mailbox in
                     place, active and quota'd, quietly receiving nothing.
                     Shown only when something selected actually is a mailbox,
                     since there is nothing to revert otherwise. --->
                <cfoutput><cfif selectedMailboxCount GT 0>
                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_revert" value="revert">
                    <label class="form-check-label" for="backend_revert">
                        <strong>Revert to Relay Recipient</strong>
                        <br><small class="text-muted">Undo the conversion. Mail goes to the domain's backend again and the mailbox is deleted.</small>
                    </label>
                </div>

                <!--- ##dc3545, doubled: this block is inside a cfoutput, where a single #
                     opens an expression. --->
                <div id="revert_confirm_fields" style="display: none; padding-left: 25px; border-left: 3px solid ##dc3545;">
                    <div class="alert alert-danger py-2">
                        <small>
                            <strong>This deletes the <cfif selectedMailboxCount NEQ 1>#selectedMailboxCount# mailboxes<cfelse>mailbox</cfif> and everything in <cfif selectedMailboxCount NEQ 1>them<cfelse>it</cfif>.</strong>
                            Any mail delivered here since the conversion is removed and cannot be recovered.
                            <br><br>The <cfif selectedMailboxCount NEQ 1>recipients themselves are<cfelse>recipient itself is</cfif>
                            not deleted: <cfif selectedMailboxCount NEQ 1>they go<cfelse>it goes</cfif> back to being
                            a relay recipient, keeps the same login, and receives mail at the domain's backend again.
                            <cfif selectedExemptCount GT 0>
                            <br><br><strong>#selectedExemptCount# catch-all
                            <cfif selectedExemptCount NEQ 1>exemptions are<cfelse>exemption is</cfif> removed</strong>,
                            so the domain's catch-all applies to
                            <cfif selectedExemptCount NEQ 1>these addresses<cfelse>this address</cfif>
                            again, exactly as before the conversion.
                            </cfif>
                            <cfif selectedAliasCount GT 0>
                            <br><br><strong>#selectedAliasCount# alias<cfif selectedAliasCount NEQ 1>es</cfif>
                            delivering to <cfif selectedMailboxCount NEQ 1>these mailboxes<cfelse>this mailbox</cfif>
                            <cfif selectedAliasCount NEQ 1>are<cfelse>is</cfif> deleted too:</strong>
                            <cfloop query="selectedAliasesIn"><code>#HTMLEditFormat(selectedAliasesIn.alias_address)#</code> </cfloop>
                            Mail sent to <cfif selectedAliasCount NEQ 1>them<cfelse>it</cfif> would otherwise go nowhere.
                            </cfif>
                            <cfif selectedNcCount GT 0>
                            <br><br><strong>Nextcloud <cfif selectedNcCount NEQ 1>accounts are<cfelse>access is</cfif> removed too,</strong>
                            along with <cfif selectedNcCount NEQ 1>their<cfelse>its</cfif> files, calendars and contacts.
                            Nextcloud belongs to a mailbox, so a relay recipient cannot keep it.
                            </cfif>
                            <br><br><strong>If you need to keep this mail,</strong> cancel and use
                            <strong>Delete Mailbox &rarr; Convert to a shared mailbox</strong> on the Mailboxes page
                            instead. That keeps the address delivering here and the messages reachable.
                        </small>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="checkbox" name="revert_confirm" id="revert_confirm" value="1">
                        <label class="form-check-label" for="revert_confirm">
                            I understand the <cfif selectedMailboxCount NEQ 1>mailboxes<cfelse>mailbox</cfif> and <cfif selectedMailboxCount NEQ 1>their<cfelse>its</cfif> contents will be deleted
                        </label>
                    </div>
                </div>
                </cfif></cfoutput>

            </div>

            <cfoutput><cfif prefillMixed>
            <div class="alert alert-warning py-2">
                <small><strong>The selected recipients do not share one backend.</strong>
                The fields below are therefore blank rather than showing one recipient's
                settings as if they applied to all. Saving replaces the backend on every
                selected recipient.</small>
            </div>
            </cfif></cfoutput>

            <!--- Custom backend fields. Shown on load when an override is already
                 in force, since the JS below only reacts to a change event. --->
            <div id="custom_backend_fields" style="<cfoutput><cfif prefillCustom>display: block;<cfelse>display: none;</cfif></cfoutput> padding-left: 25px; border-left: 3px solid #007bff;">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="custom_server" class="form-label"><strong>Server Address</strong></label>
                        <input type="text" class="form-control" id="custom_server" name="custom_server" value="<cfoutput>#EncodeForHTMLAttribute(prefillServer)#</cfoutput>" placeholder="e.g., mail.example.com or 192.0.2.10">
                        <small class="text-muted">FQDN or IP address of the backend mail server</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="custom_port" class="form-label"><strong>Port</strong></label>
                        <input type="number" class="form-control" id="custom_port" name="custom_port" value="<cfoutput>#EncodeForHTMLAttribute(prefillPort)#</cfoutput>" min="1" max="65535">
                        <small class="text-muted">SMTP port (default: 25)</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="custom_tls" class="form-label"><strong>TLS Mode</strong></label>
                        <select class="form-control" id="custom_tls" name="custom_tls">
                            <cfoutput>
                            <option value="may"<cfif prefillTls EQ "may"> selected</cfif>>May (Opportunistic)</option>
                            <option value="encrypt"<cfif prefillTls EQ "encrypt"> selected</cfif>>Encrypt (Required)</option>
                            <option value="none"<cfif prefillTls EQ "none"> selected</cfif>>None (Disabled)</option>
                            </cfoutput>
                        </select>
                        <small class="text-muted">TLS encryption mode</small>
                    </div>
                </div>
            </div>

            <!--- Built-in mailbox settings. Deliberately short. Everything
                 that can be carried over from the recipient is carried over
                 rather than asked for: the spam policy, the encryption flags,
                 signing, MFA enforcement, and the authentication type with its
                 directory. What is left is what genuinely has no previous
                 value, and it is applied to every selected recipient.

                 Not asked for, and why:
                   display name   taken from what the directory already told us
                                  during provisioning, falling back to the
                                  address local part
                   password       not touched. A remote-auth recipient keeps
                                  authenticating against the provider, and a
                                  local one keeps the password it already has.
                                  Converting forty people must not reset forty
                                  passwords
                   certificates   no S/MIME is minted here. Existing
                                  certificates are untouched, and a new one can
                                  be issued afterwards as usual --->
            <div id="builtin_backend_fields" style="<cfoutput><cfif prefillBuiltin>display: block;<cfelse>display: none;</cfif></cfoutput> padding-left: 25px; border-left: 3px solid #198754;">
                <div class="alert alert-info py-2">
                    <small><strong>Each selected recipient gets a mailbox on this server.</strong>
                    Their existing login still works, nothing is sent to the old backend any more,
                    and the spam policy, encryption and authentication settings they already have
                    are kept. Their domain becomes a hybrid domain: the recipients you do not
                    convert carry on going to the provider exactly as before.</small>
                </div>
                <cfoutput><cfif redirectExplicitCount GT 0>
                <div class="alert alert-danger py-2">
                    <small>
                        <strong>#redirectExplicitCount# of these <cfif redirectExplicitCount NEQ 1>addresses are<cfelse>address is</cfif> deliberately redirected elsewhere</strong>
                        and cannot be hosted here until that is changed. Saving will be refused.
                        <ul class="mb-0 mt-1">
                        <cfloop list="#redirectExplicit#" index="rRow" delimiters=";">
                            <li><code>#HTMLEditFormat(ListGetAt(rRow, 1, Chr(31)))#</code> &rarr;
                            <code>#HTMLEditFormat(ListGetAt(rRow, 4, Chr(31)))#</code>, under
                            <cfif ListGetAt(rRow, 2, Chr(31)) EQ "virtual"><a href="view_virtual_recipients.cfm">Virtual Recipients</a><cfelse><a href="view_mailbox_aliases.cfm">Aliases</a></cfif></li>
                        </cfloop>
                        </ul>
                    </small>
                </div>
                </cfif></cfoutput>

                <cfoutput><cfif redirectCatchAllCount GT 0>
                <div class="alert alert-warning py-2">
                    <small>
                        <strong>#redirectCatchAllCount# of these <cfif redirectCatchAllCount NEQ 1>addresses have<cfelse>address has</cfif> mail redirected by a catch-all</strong><cfif Len(catchAllKey)>, <code>#HTMLEditFormat(catchAllKey)#</code> &rarr; <code>#HTMLEditFormat(catchAllTo)#</code></cfif>.
                        Postfix rewrites the recipient before it decides where to deliver, so without an
                        entry of their own the new <cfif redirectCatchAllCount NEQ 1>mailboxes<cfelse>mailbox</cfif>
                        would never receive anything.
                    </small>
                    <div class="form-check mt-2">
                        <input class="form-check-input" type="checkbox" name="builtin_exempt_catchall" id="builtin_exempt_catchall" value="1" checked>
                        <label class="form-check-label" for="builtin_exempt_catchall">
                            <small>Create a
                            <cfif catchAllSrc EQ "virtual">Virtual Recipient<cfelse>Alias</cfif>
                            for each one pointing at itself, so their mail is delivered here.
                            A specific entry wins over a catch-all, so the rest of the domain is unaffected.</small>
                        </label>
                    </div>
                </div>
                </cfif></cfoutput>

                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label for="builtin_quota_gb" class="form-label"><strong>Mailbox Quota (GB)</strong></label>
                        <input type="number" class="form-control" id="builtin_quota_gb" name="builtin_quota_gb" value="5" step="0.01" min="0.01">
                        <small class="text-muted">Applied to every selected recipient</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="builtin_nextcloud" class="form-label"><strong>Nextcloud Access</strong></label>
                        <select class="form-control" id="builtin_nextcloud" name="builtin_nextcloud">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                        <small class="text-muted">Files, calendar and contacts</small>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="builtin_reports" class="form-label"><strong>Quarantine Notices</strong></label>
                        <select class="form-control" id="builtin_reports" name="builtin_reports">
                            <option value="YES" selected>Yes</option>
                            <option value="NO">No</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="builtin_train_bayes" class="form-label"><strong>Bayes Training</strong></label>
                        <select class="form-control" id="builtin_train_bayes" name="builtin_train_bayes">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="builtin_download_msg" class="form-label"><strong>Message Download</strong></label>
                        <select class="form-control" id="builtin_download_msg" name="builtin_download_msg">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Saving...';this.form.submit();">
                    <i class="fas fa-save me-1"></i>Save Changes
                </button>
                <cfoutput><a href="#backUrl#" class="btn btn-secondary ms-2"></cfoutput>
                    <i class="fas fa-times me-1"></i>Cancel
                </a>
            </div>
        </form>
    </div>
</div>

      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>

<cfinclude template="./inc/main_footer.cfm" />

</div><!-- ./app-wrapper -->

<!--- JavaScript for showing/hiding custom backend fields --->
<script>
$(document).ready(function() {
    // Show the panel belonging to the selected destination, hide the other.
    // Only one can be open, so this does not toggle them independently.
    $('input[name="backend_type"]').on('change', function() {
        var v = $(this).val();
        if (v === 'custom') {
            $('#builtin_backend_fields').slideUp();
            $('#custom_backend_fields').slideDown();
        } else if (v === 'builtin') {
            $('#custom_backend_fields').slideUp();
            $('#revert_confirm_fields').slideUp();
            $('#builtin_backend_fields').slideDown();
        } else if (v === 'revert') {
            $('#custom_backend_fields').slideUp();
            $('#builtin_backend_fields').slideUp();
            $('#revert_confirm_fields').slideDown();
        } else {
            $('#custom_backend_fields').slideUp();
            $('#builtin_backend_fields').slideUp();
            $('#revert_confirm_fields').slideUp();
        }
    });
});
</script>

</body>
</html>
