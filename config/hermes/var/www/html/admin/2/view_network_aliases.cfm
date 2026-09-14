<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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
  <title>Hermes SEG | Network Aliases</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Network Aliases</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Network Aliases</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
    <cfset m = session.m>
  </cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
  <cfset action = form.action>
</cfif>

<cfparam name="detail_alias_id" default="0">
<cfif StructKeyExists(url, "alias")>
  <cfif IsNumeric(url.alias)>
    <cfset detail_alias_id = url.alias>
  </cfif>
</cfif>

<!---
  Message codes for this page use the 60s so they cannot be confused with
  another page's codes if a redirect ever lands here with a stale session.m.
--->

<!--- ==================================================================
      VALIDATION HELPERS
      ==================================================================
      A CIDR is validated before it reaches the database rather than after,
      because these rows are rendered into Postfix and fail2ban lookup files
      where a malformed line is not rejected loudly, it just quietly fails to
      match. cfqueryparam covers injection; this covers correctness.
--->
<cffunction name="cidrFamily" returntype="string" output="false">
  <cfargument name="value" type="string" required="true">
  <cfset var v = Trim(arguments.value)>
  <cfset var parts = "">
  <cfset var addr = "">
  <cfset var prefix = "">
  <cfset var octets = "">
  <cfset var i = 0>

  <cfif NOT Find("/", v)>
    <cfreturn "">
  </cfif>
  <cfset parts = ListToArray(v, "/")>
  <cfif ArrayLen(parts) NEQ 2>
    <cfreturn "">
  </cfif>
  <cfset addr = parts[1]>
  <cfset prefix = parts[2]>
  <cfif NOT IsNumeric(prefix)>
    <cfreturn "">
  </cfif>

  <!--- IPv4 --->
  <cfif REFind("^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$", addr)>
    <cfif prefix LT 0 OR prefix GT 32>
      <cfreturn "">
    </cfif>
    <cfset octets = ListToArray(addr, ".")>
    <cfloop index="i" from="1" to="4">
      <cfif octets[i] LT 0 OR octets[i] GT 255>
        <cfreturn "">
      </cfif>
    </cfloop>
    <cfreturn "ip4">
  </cfif>

  <!--- IPv6: hex groups and colons, optional :: compression --->
  <cfif REFindNoCase("^[0-9a-f:]+$", addr) AND Find(":", addr)>
    <cfif prefix LT 0 OR prefix GT 128>
      <cfreturn "">
    </cfif>
    <cfreturn "ip6">
  </cfif>

  <cfreturn "">
</cffunction>

<cffunction name="aliasReferenceCount" returntype="numeric" output="false">
  <cfargument name="aliasId" type="numeric" required="true">
  <!---
    Guarded rather than cascading, matching #320: an alias in use cannot be
    deleted until the references are gone.

    Relay Networks is the first consumer. A relay-network row referencing an
    alias holds its NAME with network_entry = '2', so the count matches on name
    rather than id. Further consumers (the postscreen access list, the
    intrusion-prevention whitelist) add their own clause here.
  --->
  <cfset var refs = "">
  <cfquery name="refs" datasource="hermes">
    SELECT COUNT(*) AS c
    FROM parameters p
    JOIN network_aliases a ON a.name = p.parameter
    WHERE p.parent_name = 'mynetworks'
      AND p.child = '1'
      AND p.network_entry = '2'
      AND a.id = <cfqueryparam value="#arguments.aliasId#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfreturn refs.c>
</cffunction>

<!--- ==================================================================
      ACTIONS
      ==================================================================
      Every branch that sets session.m ends in a cflocation. Without it the
      redirect never happens and the alert never fires.
--->

<!--- ---- add an alias ---- --->
<cfif action is "add_alias">
  <cfset theName = Trim(form.alias_name)>
  <cfset theDesc = Trim(form.alias_description)>
  <cfset theType = Trim(form.source_type)>
  <cfset theSource = Trim(form.source_value)>
  <cfset theEnabled = 0>
  <cfif StructKeyExists(form, "alias_enabled")>
    <cfset theEnabled = 1>
  </cfif>

  <cfif theName is "">
    <cfset session.m = 60>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>
  <cfif theType is not "static" AND theType is not "spf">
    <cfset session.m = 60>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>
  <cfif theType is "spf" AND theSource is "">
    <cfset session.m = 61>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <cfquery name="check_alias_name" datasource="hermes">
    SELECT id FROM network_aliases
    WHERE name = <cfqueryparam value="#theName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif check_alias_name.recordcount GT 0>
    <cfset session.m = 62>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <cfquery name="insert_alias" datasource="hermes">
    INSERT INTO network_aliases (name, description, source_type, source_value, enabled)
    VALUES (
      <cfqueryparam value="#theName#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#theDesc#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#theType#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#theSource#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#theEnabled#" cfsqltype="cf_sql_integer">
    )
  </cfquery>

  <!--- Enabling an SPF alias should make it work, not leave it empty until 03:30. --->
  <cfif theEnabled EQ 1 AND theType is "spf">
    <cfquery name="get_new_alias_id" datasource="hermes">
      SELECT id FROM network_aliases
      WHERE name = <cfqueryparam value="#theName#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif get_new_alias_id.recordcount GTE 1>
      <cfset resolveOneAlias(get_new_alias_id.id)>
    </cfif>
  </cfif>

  <cfset session.m = 63>
  <cflocation url="view_network_aliases.cfm" addtoken="no">
</cfif>

<!--- ---- edit an alias ---- --->
<cfif action is "edit_alias">
  <cfset theId = form.alias_id>
  <cfset theName = Trim(form.alias_name)>
  <cfset theDesc = Trim(form.alias_description)>
  <cfset theType = Trim(form.source_type)>
  <cfset theSource = Trim(form.source_value)>
  <cfset theEnabled = 0>
  <cfif StructKeyExists(form, "alias_enabled")>
    <cfset theEnabled = 1>
  </cfif>

  <cfif NOT IsNumeric(theId) OR theName is "">
    <cfset session.m = 60>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>
  <cfif theType is "spf" AND theSource is "">
    <cfset session.m = 61>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <cfquery name="check_alias_name" datasource="hermes">
    SELECT id FROM network_aliases
    WHERE name = <cfqueryparam value="#theName#" cfsqltype="cf_sql_varchar">
    AND id <> <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif check_alias_name.recordcount GT 0>
    <cfset session.m = 62>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <cfquery name="update_alias" datasource="hermes">
    UPDATE network_aliases
    SET name = <cfqueryparam value="#theName#" cfsqltype="cf_sql_varchar">,
        description = <cfqueryparam value="#theDesc#" cfsqltype="cf_sql_varchar">,
        source_type = <cfqueryparam value="#theType#" cfsqltype="cf_sql_varchar">,
        source_value = <cfqueryparam value="#theSource#" cfsqltype="cf_sql_varchar">,
        enabled = <cfqueryparam value="#theEnabled#" cfsqltype="cf_sql_integer">,
        updated_at = NOW()
    WHERE id = <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif theEnabled EQ 1 AND theType is "spf">
    <cfset resolveOneAlias(theId)>
  </cfif>

  <cfset session.m = 64>
  <cflocation url="view_network_aliases.cfm" addtoken="no">
</cfif>

<!--- ---- delete an alias ---- --->
<cfif action is "delete_alias">
  <cfset theId = form.alias_id>
  <cfif NOT IsNumeric(theId)>
    <cfset session.m = 60>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <!---
    Guarded, not cascading. No consumer exists yet so this cannot currently
    refuse, but the path is written now so adopting the first consumer does not
    also mean revisiting delete. See #320 for the same shape on domain delete.
  --->
  <cfif aliasReferenceCount(theId) GT 0>
    <cfset session.m = 65>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <cfquery name="delete_alias_entries" datasource="hermes">
    DELETE FROM network_alias_entries
    WHERE alias_id = <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfquery name="delete_the_alias" datasource="hermes">
    DELETE FROM network_aliases
    WHERE id = <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfset session.m = 66>
  <cflocation url="view_network_aliases.cfm" addtoken="no">
</cfif>

<!---
  resolveOneAlias: trigger the scheduled resolver for a single alias.

  Used by the per-alias Resolve button and, more importantly, straight after an
  alias is enabled. Enabling something should make it work; nobody wants to enable
  an alias and then hunt for a second button to make it do anything.

  Best-effort by design. A failed resolve is recorded against the alias itself by
  the schedule page (last_status / last_message), which the row already displays,
  so swallowing the error here loses nothing.
--->
<cffunction name="resolveOneAlias" returntype="void" output="false">
  <cfargument name="aliasId" type="numeric" required="true">
  <cftry>
    <cfhttp method="GET"
            url="http://localhost:8888/schedule/refresh_network_aliases.cfm?alias=#arguments.aliasId#"
            timeout="120"
            result="oneResult">
    </cfhttp>
    <cfcatch type="any">
      <cflog file="hermes" type="error"
        text="view_network_aliases.cfm: resolve of alias #arguments.aliasId# failed: #cfcatch.message#">
    </cfcatch>
  </cftry>
</cffunction>

<!--- ---- resolve ONE alias on demand ---- --->
<cfif action is "resolve_one">
  <cfif IsNumeric(form.alias_id)>
    <cfset resolveOneAlias(form.alias_id)>
    <cfset session.m = 71>
  <cfelse>
    <cfset session.m = 60>
  </cfif>
  <cflocation url="view_network_aliases.cfm?alias=#form.alias_id#" addtoken="no">
</cfif>

<!--- ---- resolve every enabled SPF alias now ----
      The scheduled job runs nightly. Without this an admin who enables an alias sees
      an empty list and has nothing to click, on a page whose whole point is that it
      maintains itself. Same pattern as inc/run_update_check.cfm: call the schedule
      page over localhost and let it do the work, so there is one implementation. --->
<cfif action is "resolve_now">
  <cftry>
    <cfhttp method="GET"
            url="http://localhost:8888/schedule/refresh_network_aliases.cfm"
            timeout="180"
            result="resolveResult">
    </cfhttp>
    <cfif resolveResult.status_code NEQ 200>
      <cflog file="hermes" type="error"
        text="view_network_aliases.cfm: resolver returned status #resolveResult.status_code#">
      <cfset session.m = 70>
    <cfelse>
      <cfset session.m = 71>
    </cfif>
    <cfcatch type="any">
      <cflog file="hermes" type="error" text="view_network_aliases.cfm: resolver failed: #cfcatch.message#">
      <cfset session.m = 70>
    </cfcatch>
  </cftry>
  <cflocation url="view_network_aliases.cfm" addtoken="no">
</cfif>

<!--- ---- add ranges to a static alias ---- --->
<cfif action is "add_entries">
  <cfset theId = form.alias_id>
  <cfset rawEntries = form.entries>
  <cfif NOT IsNumeric(theId)>
    <cfset session.m = 60>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>

  <cfset addedCount = 0>
  <cfset badCount = 0>
  <cfloop list="#rawEntries#" index="oneEntry" delimiters="#Chr(10)##Chr(13)#,">
    <cfset oneEntry = Trim(oneEntry)>
    <cfif oneEntry is not "">
      <cfset theFamily = cidrFamily(oneEntry)>
      <cfif theFamily is "">
        <cfset badCount = badCount + 1>
      <cfelse>
        <cfquery name="insert_entry" datasource="hermes">
          INSERT IGNORE INTO network_alias_entries (alias_id, cidr, family, origin)
          VALUES (
            <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#oneEntry#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#theFamily#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="manual" cfsqltype="cf_sql_varchar">
          )
        </cfquery>
        <cfset addedCount = addedCount + 1>
      </cfif>
    </cfif>
  </cfloop>

  <cfif badCount GT 0>
    <cfset session.m = 67>
  <cfelse>
    <cfset session.m = 68>
  </cfif>
  <cflocation url="view_network_aliases.cfm?alias=#theId#" addtoken="no">
</cfif>

<!--- ---- remove one range ---- --->
<cfif action is "delete_entry">
  <cfset theEntryId = form.entry_id>
  <cfset theId = form.alias_id>
  <cfif NOT IsNumeric(theEntryId) OR NOT IsNumeric(theId)>
    <cfset session.m = 60>
    <cflocation url="view_network_aliases.cfm" addtoken="no">
  </cfif>
  <cfquery name="delete_one_entry" datasource="hermes">
    DELETE FROM network_alias_entries
    WHERE id = <cfqueryparam value="#theEntryId#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfset session.m = 69>
  <cflocation url="view_network_aliases.cfm?alias=#theId#" addtoken="no">
</cfif>

<cfinclude template="./inc/get_network_aliases.cfm">

<!--- ==================================================================
      ALERTS
      ================================================================== --->
<cfif m is "60">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>That request was missing something required. Nothing was changed.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "61">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>An SPF alias needs a hostname to resolve, for example <strong>_spf.google.com</strong>.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "62">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>An alias with that name already exists. Names are how other parts of the system refer to an alias, so they have to be unique.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "63">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Alias created.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "64">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Alias updated.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "65">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> In use</h4>
    <cfoutput>That alias is referenced elsewhere in the system and cannot be deleted until those references are removed.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "66">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Alias deleted.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "67">
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Some entries were skipped</h4>
    <cfoutput>Valid ranges were added. Anything that was not a valid CIDR was skipped, because a malformed range does not fail loudly in a Postfix lookup file, it just silently never matches.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "68">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Ranges added.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "69">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Range removed.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "70">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Resolve failed</h4>
    <cfoutput>The resolver could not be reached. Existing ranges were left untouched. Check the per-alias status below.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "71">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Done</h4>
    <cfoutput>Resolve finished. The status column below shows the result for each alias.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<!--- ==================================================================
      WHAT THIS PAGE IS, STATED ON THE PAGE
      ================================================================== --->
<div class="callout callout-info">
  <h5><i class="fas fa-info-circle"></i> What this page is for</h5>
  <p>
    Cloud mail providers publish the IP ranges their servers send from, and those ranges
    change. A range pasted in by hand goes stale silently: mail starts failing and the
    cause is not obvious.
  </p>
  <p>
    An alias is a named set of ranges that keeps itself current. Point it at a provider's
    published SPF record and it re-resolves on a schedule and emails you when the ranges
    move. <strong>Google Workspace</strong> and <strong>Microsoft 365</strong> are
    pre-loaded and switched off; enable one and its ranges are fetched straight away.
  </p>
  <p class="mb-0">
    <strong>Relay Networks</strong> can use an alias instead of pasted ranges &mdash; add
    it there once and there is nothing to retype when the provider changes. Nothing is
    applied on its own: when an alias moves you apply it on Relay Networks, so mail flow
    never changes without you. Other places that take IP ranges, such as the Network
    Block/Allow list, still need the ranges copied in for now.
  </p>
</div>

<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired"></i> Aliases</h3>
    <div class="card-tools d-flex align-items-center gap-1">
      <form method="post" class="m-0">
        <input type="hidden" name="action" value="resolve_now">
        <button type="submit" class="btn btn-secondary btn-sm"
                onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Resolving...';this.form.submit();">
          <i class="fas fa-sync"></i> Resolve All
        </button>
      </form>
      <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addAliasModal">
        <i class="fas fa-plus"></i> Add Alias
      </button>
    </div>
  </div>
  <div class="card-body">
    <table id="aliasTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Name</th>
          <th>Type</th>
          <th>Source</th>
          <th>Ranges</th>
          <th>Last resolved</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <cfoutput query="get_aliases">
        <tr>
          <td>
            <strong>#EncodeForHTML(name)#</strong>
            <cfif NOT enabled><span class="badge bg-secondary ms-1">disabled</span></cfif>
            <cfif Len(Trim(description))>
              <br><small class="text-muted">#EncodeForHTML(description)#</small>
            </cfif>
          </td>
          <td>
            <cfif source_type is "spf">
              <span class="badge bg-info">SPF</span>
            <cfelse>
              <span class="badge bg-secondary">Static</span>
            </cfif>
          </td>
          <td>
            <cfif Len(Trim(source_value))>
              <code>#EncodeForHTML(source_value)#</code>
            <cfelse>
              <span class="text-muted">hand-entered</span>
            </cfif>
          </td>
          <td>
            #ip4_count# IPv4
            <cfif ip6_count GT 0>
              <br><small class="text-muted">#ip6_count# IPv6, not used while IPv6 is disabled</small>
            </cfif>
          </td>
          <td>
            <cfif IsDate(last_resolved)>
              #DateFormat(last_resolved, "yyyy-mm-dd")# #TimeFormat(last_resolved, "HH:mm")#
            <cfelse>
              <span class="text-muted">never</span>
            </cfif>
          </td>
          <td>
            <cfif last_status is "ok">
              <span class="badge bg-success">ok</span>
            <cfelseif Len(Trim(last_status))>
              <span class="badge bg-danger" title="#EncodeForHTMLAttribute(last_message)#">#EncodeForHTML(last_status)#</span>
            <cfelse>
              <span class="text-muted">-</span>
            </cfif>
          </td>
          <td>
            <!--- d-flex so the <form> wrapping Resolve becomes a flex item rather than a
                 block that pushes the later buttons onto a second line. flex-nowrap keeps
                 the row intact when the column is narrow. align-items-center because the
                 default is stretch, which makes the form (and so its button) taller than
                 the plain sibling buttons. --->
            <div class="d-flex flex-nowrap align-items-center gap-1">
              <a href="view_network_aliases.cfm?alias=#id#" class="btn btn-info btn-sm" title="View ranges">
                <i class="fas fa-list"></i>
              </a>
              <cfif source_type is "spf" AND enabled>
                <form method="post" class="m-0">
                  <input type="hidden" name="action" value="resolve_one">
                  <input type="hidden" name="alias_id" value="#id#">
                  <button type="submit" class="btn btn-secondary btn-sm" title="Resolve this alias now"
                          onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i>';this.form.submit();">
                    <i class="fas fa-sync"></i>
                  </button>
                </form>
              </cfif>
              <button type="button" class="btn btn-warning btn-sm"
                      onclick="openEditAlias(#id#, '#JSStringFormat(name)#', '#JSStringFormat(description)#', '#JSStringFormat(source_type)#', '#JSStringFormat(source_value)#', #enabled#)"
                      title="Edit">
                <i class="fas fa-edit"></i>
              </button>
              <button type="button" class="btn btn-danger btn-sm"
                      onclick="openDeleteAlias(#id#, '#JSStringFormat(name)#')"
                      title="Delete">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </td>
        </tr>
      </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- ==================================================================
      RANGES FOR THE OPENED ALIAS
      ================================================================== --->
<cfif IsDefined("get_detail_alias") AND get_detail_alias.recordcount GT 0>
<cfoutput query="get_detail_alias">
<div class="card card-secondary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Ranges in #EncodeForHTML(name)#</h3>
    <div class="card-tools">
      <a href="view_network_aliases.cfm" class="btn btn-secondary btn-sm"><i class="fas fa-times"></i> Close</a>
    </div>
  </div>
  <div class="card-body">
    <cfif source_type is "spf">
      <cfif NOT enabled>
        <div class="callout callout-warning">
          <p class="mb-0">
            This alias is <strong>disabled</strong>, so it is not being resolved. Edit it and
            tick Enabled to have <code>#EncodeForHTML(source_value)#</code> re-resolved on
            schedule.
          </p>
        </div>
      <cfelseif NOT IsDate(last_resolved)>
        <div class="callout callout-warning">
          <p class="mb-0">
            Resolves from <code>#EncodeForHTML(source_value)#</code>, but has not run yet.
            The scheduled job runs nightly at 03:30. Any ranges listed below were entered
            by hand.
          </p>
        </div>
      <cfelseif last_status is "ok">
        <div class="callout callout-success">
          <p class="mb-0">
            Resolved from <code>#EncodeForHTML(source_value)#</code> on
            <strong>#DateFormat(last_resolved, "yyyy-mm-dd")# #TimeFormat(last_resolved, "HH:mm")#</strong>.
            Re-resolves nightly at 03:30; you are emailed if the ranges change.
          </p>
        </div>
      <cfelse>
        <div class="callout callout-danger">
          <p class="mb-0">
            <strong>Last resolve failed</strong>
            (#DateFormat(last_resolved, "yyyy-mm-dd")# #TimeFormat(last_resolved, "HH:mm")#):
            #EncodeForHTML(last_message)#
          </p>
          <p class="mb-0 mt-2">
            The ranges below are the ones from the last successful resolve and were left in
            place deliberately. A failed lookup never empties the list.
          </p>
        </div>
      </cfif>
    </cfif>

    <form action="view_network_aliases.cfm" method="post" class="mb-3">
      <input type="hidden" name="action" value="add_entries">
      <input type="hidden" name="alias_id" value="#id#">
      <div class="mb-2">
        <label for="entries" class="form-label">Add ranges, one per line</label>
        <textarea class="form-control" id="entries" name="entries" rows="3"
                  placeholder="209.85.128.0/17"></textarea>
        <div class="form-text">
          CIDR notation. Anything that is not a valid range is skipped rather than stored,
          because a malformed line in a Postfix lookup file never matches and never complains.
        </div>
      </div>
      <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Add</button>
    </form>

    <table class="table table-sm table-bordered">
      <thead>
        <tr><th>Range</th><th>Family</th><th>Origin</th><th>Last seen</th><th></th></tr>
      </thead>
      <tbody>
      <cfloop query="get_alias_entries">
        <tr>
          <td><code>#EncodeForHTML(get_alias_entries.cidr)#</code></td>
          <td>
            <cfif get_alias_entries.family is "ip6">
              <span class="badge bg-secondary" title="Stored, but filtered out while IPv6 is disabled in the mail containers">IPv6</span>
            <cfelse>
              <span class="badge bg-primary">IPv4</span>
            </cfif>
          </td>
          <td>#EncodeForHTML(get_alias_entries.origin)#</td>
          <td>
            <cfif IsDate(get_alias_entries.last_seen)>
              #DateFormat(get_alias_entries.last_seen, "yyyy-mm-dd")#
            <cfelse>
              <span class="text-muted">-</span>
            </cfif>
          </td>
          <td>
            <form action="view_network_aliases.cfm" method="post" class="d-inline">
              <input type="hidden" name="action" value="delete_entry">
              <input type="hidden" name="entry_id" value="#get_alias_entries.id#">
              <input type="hidden" name="alias_id" value="#id#">
              <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash"></i></button>
            </form>
          </td>
        </tr>
      </cfloop>
      <cfif get_alias_entries.recordcount is 0>
        <tr><td colspan="5" class="text-muted text-center">No ranges yet.</td></tr>
      </cfif>
      </tbody>
    </table>
  </div>
</div>
</cfoutput>
</cfif>

      </div>
    </div>
  </main>

<!--- main_footer.cfm closes the app-wrapper div itself; do not add another. --->
<cfinclude template="./inc/main_footer.cfm" />

<!--- ==================================================================
      MODALS
      ================================================================== --->
<div class="modal fade" id="addAliasModal" tabindex="-1">
  <div class="modal-dialog">
    <form action="view_network_aliases.cfm" method="post">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Add Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" value="add_alias">
          <div class="mb-3">
            <label for="add_name" class="form-label">Name</label>
            <input type="text" class="form-control" id="add_name" name="alias_name" maxlength="128" required>
            <div class="form-text">How other parts of the system will refer to this set of ranges.</div>
          </div>
          <div class="mb-3">
            <label for="add_description" class="form-label">Description</label>
            <input type="text" class="form-control" id="add_description" name="alias_description" maxlength="255">
          </div>
          <div class="mb-3">
            <label for="add_source_type" class="form-label">Source</label>
            <select class="form-select" id="add_source_type" name="source_type" onchange="toggleSource('add')">
              <option value="spf">Resolved from an SPF record</option>
              <option value="static">Hand-entered list</option>
            </select>
          </div>
          <div class="mb-3" id="add_source_wrap">
            <label for="add_source_value" class="form-label">SPF hostname</label>
            <input type="text" class="form-control" id="add_source_value" name="source_value" maxlength="255"
                   placeholder="_spf.google.com">
            <div class="form-text">The DNS name holding the SPF record, not a domain name.</div>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="add_enabled" name="alias_enabled" value="1">
            <label class="form-check-label" for="add_enabled">Enabled</label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Add</button>
        </div>
      </div>
    </form>
  </div>
</div>

<div class="modal fade" id="editAliasModal" tabindex="-1">
  <div class="modal-dialog">
    <form action="view_network_aliases.cfm" method="post">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Edit Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" value="edit_alias">
          <input type="hidden" name="alias_id" id="edit_alias_id">
          <div class="mb-3">
            <label for="edit_name" class="form-label">Name</label>
            <input type="text" class="form-control" id="edit_name" name="alias_name" maxlength="128" required>
          </div>
          <div class="mb-3">
            <label for="edit_description" class="form-label">Description</label>
            <input type="text" class="form-control" id="edit_description" name="alias_description" maxlength="255">
          </div>
          <div class="mb-3">
            <label for="edit_source_type" class="form-label">Source</label>
            <select class="form-select" id="edit_source_type" name="source_type" onchange="toggleSource('edit')">
              <option value="spf">Resolved from an SPF record</option>
              <option value="static">Hand-entered list</option>
            </select>
          </div>
          <div class="mb-3" id="edit_source_wrap">
            <label for="edit_source_value" class="form-label">SPF hostname</label>
            <input type="text" class="form-control" id="edit_source_value" name="source_value" maxlength="255">
          </div>
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="edit_enabled" name="alias_enabled" value="1">
            <label class="form-check-label" for="edit_enabled">Enabled</label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-warning">Save</button>
        </div>
      </div>
    </form>
  </div>
</div>

<div class="modal fade" id="deleteAliasModal" tabindex="-1">
  <div class="modal-dialog">
    <form action="view_network_aliases.cfm" method="post">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Delete Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" value="delete_alias">
          <input type="hidden" name="alias_id" id="delete_alias_id">
          <p>Delete <strong id="delete_alias_name"></strong> and all of its ranges?</p>
          <p class="text-muted mb-0">An alias referenced elsewhere cannot be deleted until those references are removed.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete</button>
        </div>
      </div>
    </form>
  </div>
</div>

<script>
function toggleSource(which) {
  var type = document.getElementById(which + '_source_type').value;
  var wrap = document.getElementById(which + '_source_wrap');
  wrap.hidden = (type !== 'spf');
}

function openEditAlias(id, name, description, sourceType, sourceValue, enabled) {
  document.getElementById('edit_alias_id').value = id;
  document.getElementById('edit_name').value = name;
  document.getElementById('edit_description').value = description;
  document.getElementById('edit_source_type').value = sourceType;
  document.getElementById('edit_source_value').value = sourceValue;
  document.getElementById('edit_enabled').checked = (enabled == 1);
  toggleSource('edit');
  new bootstrap.Modal(document.getElementById('editAliasModal')).show();
}

function openDeleteAlias(id, name) {
  document.getElementById('delete_alias_id').value = id;
  document.getElementById('delete_alias_name').textContent = name;
  new bootstrap.Modal(document.getElementById('deleteAliasModal')).show();
}

$(document).ready(function () {
  $('#aliasTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[0, 'asc']],
    columnDefs: [
      { orderable: false, targets: [6] },
      { searchable: false, targets: [6] }
    ]
  });
  toggleSource('add');
});
</script>

</body>

</html>
