<!DOCTYPE html>

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
  <title>Hermes SEG | Email Server - Aliases</title>
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
            <h1 class="m-0">Email Server - Aliases</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Aliases</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLERS --->
<cfif action is "add_alias">
  <cfinclude template="./inc/add_mailbox_alias_action.cfm">
<cfelseif action is "edit_alias">
  <cfinclude template="./inc/edit_mailbox_alias_action.cfm">
<cfelseif action is "delete_alias">
  <cfinclude template="./inc/delete_mailbox_alias_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Alias created successfully.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Alias updated successfully.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Alias deleted successfully.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Alias address cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid email address format.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain is not a mailbox domain. Aliases can only be created for mailbox domains.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This address already exists as a mailbox. Use the Mailboxes page to manage it.
  </div>
<cfelseif m EQ 18>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Type does not match</h4>
    That address already exists with a different Type. An alias either forwards or
    discards, never both. Change the existing alias's Type first, or use a different
    address.
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Nothing to add</h4>
    Every destination you entered is already on this alias, so nothing changed. An alias
    address existing is not a problem in itself: entering it again is how you add members.
    Only an exact repeat of the same address <em>and</em> the same destination is skipped.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Delivers To address is required for forward aliases.
  </div>
<cfelseif m EQ 16>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    One of the destinations is not a valid email address.
  </div>
<cfelseif m EQ 17>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This address already exists as a virtual recipient under Email Relay. Remove it there first.
  </div>
<cfelseif m EQ 20>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
<cfelseif m EQ 21>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Alias not found.
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Aliases</h5>
  <p class="mb-1">Aliases are alternate email addresses on your <strong>mailbox domains</strong> that deliver mail elsewhere or silently discard it.</p>
  <ul class="mb-1">
    <li><strong>Forward</strong> &mdash; delivers to one or more destinations (e.g., <code>sales@domain.tld</code> &rarr; <code>tina@domain.tld</code>). Give it several and it becomes a distribution list: every destination receives a copy. Destinations outside your own domains are allowed, with the caveats noted when you add one.</li>
    <li><strong>Discard</strong> &mdash; silently drops all mail with no bounce (e.g., <code>noreply@domain.tld</code>).</li>
    <li><strong>Send-As</strong> is granted per mailbox under <strong>Mailboxes &rarr; Actions &rarr; Send As</strong>, not here, and does not depend on the mailbox being a destination.</li>
  </ul>
  <p class="mb-0"><small>To forward to external email addresses or for relay domains, use <a href="view_virtual_recipients.cfm">Email Relay &gt; Virtual Recipients</a> instead.</small></p>
</div>

<!--- GET ALL MAILBOX ALIASES, ONE ROW PER ALIAS

     An alias now holds one row per destination, so a twenty-member list is
     twenty rows. Rendering those raw would show twenty near-identical lines
     that an admin cannot tell apart from twenty accidental duplicates, so
     they are collapsed here and the destinations rendered as chips.

     dest_ids and dest_list are parallel lists in the same order, so
     position N in one lines up with position N in the other. That is what
     lets each chip carry its own row id for edit and delete.

     group_concat_max_len defaults to 1024, which is roughly forty addresses.
     A list longer than that would render truncated; worth raising the
     session variable here if anyone ever hits it. --->
<cfquery name="getAliases" datasource="hermes">
    SELECT ma.alias_address,
           MIN(ma.alias_type)    AS alias_type,
           MAX(ma.internal_only) AS internal_only,
           d.domain,
           COUNT(*) AS dest_count,
           GROUP_CONCAT(ma.id ORDER BY ma.delivers_to ASC)          AS dest_ids,
           GROUP_CONCAT(ma.delivers_to ORDER BY ma.delivers_to ASC) AS dest_list
    FROM mailbox_aliases ma
    INNER JOIN domains d ON d.id = ma.domain_id AND d.type = 'mailbox'
    GROUP BY ma.alias_address, d.domain
    ORDER BY ma.alias_address ASC
</cfquery>

<!--- Domains this gateway handles, used to mark a destination as external.
     External is permitted, but it changes how the mail authenticates on the
     way out, so it is flagged wherever a destination is shown rather than
     only warned about once at creation. --->
<cfquery name="getLocalDomainsForAliases" datasource="hermes">
    SELECT domain FROM domains
</cfquery>
<cfset localDomainList = ValueList(getLocalDomainsForAliases.domain)>

<!--- GET MAILBOX DOMAINS FOR DOMAIN FILTER --->
<cfquery name="getFilterDomains" datasource="hermes">
    SELECT DISTINCT d.domain FROM domains d
    INNER JOIN mailbox_aliases ma ON d.id = ma.domain_id
    WHERE d.type = 'mailbox'
    ORDER BY d.domain ASC
</cfquery>

<!--- GET ALL MAILBOXES FOR DELIVERS-TO DROPDOWN --->
<cfquery name="getMailboxes" datasource="hermes">
    SELECT username FROM mailboxes
    WHERE mailbox_type = 'user'
    ORDER BY username ASC
</cfquery>

<!--- ADD ALIAS BUTTON + DOMAIN FILTER --->
<div class="d-flex justify-content-between align-items-center mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAliasModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Alias</button>
  <cfif getFilterDomains.recordcount GTE 1>
  <div class="d-flex align-items-center gap-2">
    <label class="mb-0"><strong>Filter by Domain:</strong></label>
    <select class="form-control form-control-sm" id="domainFilter" style="width:auto;">
      <option value="">All Domains</option>
      <cfoutput query="getFilterDomains">
        <option value="#HTMLEditFormat(domain)#">#HTMLEditFormat(domain)#</option>
      </cfoutput>
    </select>
  </div>
  </cfif>
</div>

<!--- ALIASES DATATABLE --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-share me-2"></i>Aliases (<cfoutput>#getAliases.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="table-responsive">
    <table id="aliasesTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>Alias</th>
          <th>Domain</th>
          <th>Type</th>
          <th>Delivers To</th>
          <th>Reachable By</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getAliases">
        <tr>
          <td>
            <!--- One Edit for the whole alias. Everything about it, including
                 adding and removing destinations, happens in that modal, so
                 there is a single place to look rather than controls scattered
                 across the row and its chips. --->
            <div class="d-flex gap-1 flex-nowrap">
              <button type="button" class="btn btn-sm btn-primary" title="Edit this alias"
                      onclick="loadEditAliasModal(#ListFirst(dest_ids)#)">
                <i class="fas fa-edit"></i>
              </button>
              <button type="button" class="btn btn-sm btn-danger" title="Delete the whole alias"
                      onclick="confirmDeleteWholeAlias('#JSStringFormat(alias_address)#', #dest_count#)">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </td>
          <td>#HTMLEditFormat(alias_address)#</td>
          <td>#HTMLEditFormat(domain)#</td>
          <td>
            <cfif alias_type EQ "discard">
              <span class="badge bg-dark">Discard</span>
            <cfelse>
              <span class="badge bg-primary">Forward</span>
              <cfif dest_count GT 1>
                <span class="badge bg-info" title="#dest_count# destinations">#dest_count#</span>
              </cfif>
            </cfif>
          </td>
          <td>
            <cfif alias_type EQ "discard">
              <span class="text-muted"><i class="fas fa-ban me-1"></i>Silently dropped</span>
            <cfelse>
              <!--- Display only. Adding and removing happens in Edit, where
                   the same chips appear and can be changed as a set. --->
              <div class="d-flex flex-wrap gap-1">
                <cfloop from="1" to="#ListLen(dest_list)#" index="destIdx">
                  <cfset thisDest   = ListGetAt(dest_list, destIdx)>
                  <cfset thisDestDomain = ListLast(thisDest, "@")>
                  <cfset thisIsExternal = (ListFindNoCase(localDomainList, thisDestDomain) EQ 0)>
                  <span class="badge <cfif thisIsExternal>bg-warning text-dark<cfelse>bg-light text-dark border</cfif>">
                    <cfif thisIsExternal><i class="fas fa-external-link-alt me-1" title="Outside your domains"></i></cfif>#HTMLEditFormat(thisDest)#
                  </span>
                </cfloop>
              </div>
            </cfif>
          </td>
          <td>
            <cfif internal_only EQ 1>
              <span class="badge bg-secondary" title="Only senders in your own domains may mail this address">Internal only</span>
            <cfelse>
              <span class="badge bg-light text-dark border" title="Anyone may mail this address">Open</span>
            </cfif>
          </td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
    </div>
  </div>
</div>

<!--- ================================================================
     ADD ALIAS MODAL
     ================================================================ --->
<div class="modal fade" id="addAliasModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mailbox_aliases.cfm">
        <input type="hidden" name="action" value="add_alias">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Alias Address --->
          <div class="form-group mb-3">
            <label><strong>Alias Address</strong></label>
            <input type="email" class="form-control" name="alias_address" id="addAliasAddress" placeholder="noreply@domain.com" required>
            <small class="text-muted">To add members to an alias that already exists, enter the same address here. Existing destinations are kept.</small>
            <small class="text-muted">Must be on a mailbox domain. Cannot be an existing mailbox address.</small>
          </div>

          <!--- Alias Type --->
          <div class="form-group mb-3">
            <label><strong>Type</strong></label>
            <select class="form-control" name="alias_type" id="addAliasType">
              <option value="forward">Forward (deliver to mailbox)</option>
              <option value="discard">Discard (silently drop all mail)</option>
            </select>
          </div>

          <!--- Delivers To (shown for forward only) --->
          <div class="form-group mb-3" id="addDeliversToGroup">
            <label><strong>Delivers To</strong></label>
            <select class="form-control" name="delivers_to" id="addDeliversTo" multiple placeholder="Pick a mailbox, or type any address...">
              <cfoutput query="getMailboxes">
                <option value="#HTMLEditFormat(username)#">#HTMLEditFormat(username)#</option>
              </cfoutput>
            </select>
            <small class="text-muted">
              One or more destinations. Mail sent to the alias is delivered to every one of
              them, which is how a distribution list is made. Local mailboxes are listed;
              any other address can be typed in.
            </small>

            <div class="alert alert-warning py-2 px-3 mt-2 mb-0">
              <i class="fas fa-external-link-alt me-1"></i>
              <strong>Destinations outside your own domains are allowed, with a caveat.</strong>
              Forwarded mail leaves with the original sender's address, so SPF fails at the
              receiving end, and if the message was modified on the way through, by an
              External Banner or LinkGuard for instance, the original DKIM signature no
              longer validates either. Senders whose domain publishes a strict DMARC policy
              may have mail to those destinations rejected. Local destinations are unaffected.
            </div>
          </div>

          <div class="form-group mb-3">
            <label><strong>Reachable By</strong></label>
            <select class="form-control" name="internal_only">
              <option value="0">Anyone (default)</option>
              <option value="1">Only senders in your own domains</option>
            </select>
            <small class="text-muted">
              Controls who may send <em>to</em> this address, which is separate from where it
              delivers. Worth restricting on a list with external destinations, otherwise
              anyone on the internet can mail it and have this gateway relay to every member.
            </small>
          </div>

          <!--- Send-As pointer (shown for forward only).
               The permission itself moved to the mailbox. An alias can have
               several destinations, and a Yes/No here would have granted
               send-as to every one of them at once. --->
          <div class="form-group mb-3" id="addSendAsGroup">
            <label><strong>Allow Send-As</strong></label>
            <div class="alert alert-info mb-0">
              <i class="icon fas fa-info-circle"></i>
              Send-As is granted per mailbox, not here. To let a mailbox send using this
              address, go to <strong>Email Server &rarr; Mailboxes</strong>, open
              <strong>Actions &rarr; Send As</strong> on that mailbox, and add the address.
              It is independent of the destinations below: a mailbox does not have to
              receive this alias in order to send from it, and receiving it does not grant
              permission to send from it.
            </div>
          </div>

          <!--- Discard info (shown for discard only) --->
          <div class="form-group mb-3" id="addDiscardInfo" style="display:none;">
            <div class="alert alert-warning">
              <h5><i class="icon fas fa-exclamation-triangle"></i> Discard Mode</h5>
              <p class="mb-0">All mail sent to this address will be silently dropped. No bounce or error message will be sent to the sender. Use this for addresses like <code>noreply@</code> or <code>donotreply@</code>.</p>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Create Alias</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     EDIT ALIAS MODAL
     ================================================================ --->
<div class="modal fade" id="editAliasModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mailbox_aliases.cfm">
        <input type="hidden" name="action" value="edit_alias">
        <input type="hidden" name="alias_id" id="editAliasId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Alias Address (read-only) --->
          <div class="form-group mb-3">
            <label><strong>Alias Address</strong></label>
            <input type="text" class="form-control" id="editAliasAddress" readonly disabled>
          </div>

          <!--- Alias Type --->
          <div class="form-group mb-3">
            <label><strong>Type</strong></label>
            <select class="form-control" name="edit_alias_type" id="editAliasType">
              <option value="forward">Forward (deliver to mailbox)</option>
              <option value="discard">Discard (silently drop all mail)</option>
            </select>
          </div>

          <!--- Delivers To. Deliberately SINGLE-select: this edits one
               destination, not the whole set. Per-row editing avoids the
               window where a replace-the-set save has deleted the old rows
               and not yet written the new ones, and keeps created_at on
               members that did not change. --->
          <div class="form-group mb-3" id="editDeliversToGroup">
            <label><strong>Delivers To</strong></label>
            <select class="form-control" name="edit_delivers_to" id="editDeliversTo" multiple placeholder="Pick a mailbox, or type any address...">
              <cfoutput query="getMailboxes">
                <option value="#HTMLEditFormat(username)#">#HTMLEditFormat(username)#</option>
              </cfoutput>
            </select>
            <small class="text-muted">
              Every destination this alias delivers to. Click the
              <strong>&times;</strong> on a chip to remove one, or type an address to add.
              Local mailboxes are listed; any other address can be typed in. Mail is
              delivered to all of them, which is how a distribution list is made.
            </small>
          </div>

          <!--- Reachability is a property of the ADDRESS, so changing it here
               applies to every destination the alias has, not just this row. --->
          <div class="form-group mb-3">
            <label><strong>Reachable By</strong></label>
            <select class="form-control" name="edit_internal_only" id="editInternalOnly">
              <option value="0">Anyone</option>
              <option value="1">Only senders in your own domains</option>
            </select>
            <small class="text-muted">Applies to the whole alias, not just this destination.</small>
          </div>

          <!--- Send-As pointer. See the note on the Add modal above. --->
          <div class="form-group mb-3" id="editSendAsGroup">
            <label><strong>Allow Send-As</strong></label>
            <div class="alert alert-info mb-0">
              <i class="icon fas fa-info-circle"></i>
              Send-As is granted per mailbox, not here. Use
              <strong>Email Server &rarr; Mailboxes &rarr; Actions &rarr; Send As</strong>
              on the mailbox that should be allowed to send from this address.
            </div>
          </div>

          <!--- Discard info --->
          <div class="form-group mb-3" id="editDiscardInfo" style="display:none;">
            <div class="alert alert-warning">
              <h5><i class="icon fas fa-exclamation-triangle"></i> Discard Mode</h5>
              <p class="mb-0">All mail sent to this address will be silently dropped.</p>
            </div>
          </div>

          <!--- Shown only when switching an alias that HAS destinations over to
               Discard. That is destructive in a way the Discard notice above
               does not convey: the destinations are deleted, not parked, and
               switching back will not bring them back. --->
          <div class="form-group mb-3" id="editForwardToDiscardWarning" style="display:none;">
            <div class="alert alert-danger mb-0">
              <h5><i class="icon fas fa-exclamation-triangle"></i> This removes every destination</h5>
              <p class="mb-1">
                Saving as Discard deletes the
                <strong><span id="editDiscardLosingCount"></span> destination(s)</strong>
                this alias currently has:
              </p>
              <p class="mb-1"><code id="editDiscardLosingList"></code></p>
              <p class="mb-0">
                They are not kept anywhere. Switching back to Forward later gives you an
                empty alias, and the list has to be rebuilt by hand.
              </p>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     DELETE CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="deleteAliasModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailbox_aliases.cfm">
        <!--- Only one scope reaches this modal now: the whole alias. Removing
             a single destination is done by taking its chip off in Edit, so
             the per-destination branch this modal used to carry has gone.
             delete_scope is still sent because the handler supports both. --->
        <input type="hidden" name="action" value="delete_alias">
        <input type="hidden" name="delete_alias_address" id="deleteAliasWholeAddress">
        <input type="hidden" name="delete_scope" value="alias">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Delete the alias <strong id="deleteAliasAddressWhole"></strong> entirely?</p>
          <p class="text-muted mb-0">All <strong id="deleteWholeCount"></strong> destinations go with it, along with any send-as permissions and Amavis policy entries for this address. To remove just one destination, use Edit instead.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Alias</button>
        </div>
      </form>
    </div>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>

<script>
  // Tom Select instances (need references to set values programmatically)
  var addDeliversToTS, editDeliversToTS;

  // Initialize DataTable and Tom Select
  $(document).ready(function() {
    var table = $('#aliasesTable').DataTable({
      "order": [[1, "asc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [0] }
      ]
    });

    // Domain filter (column 2 = Domain)
    $('#domainFilter').on('change', function() {
      var val = $(this).val();
      table.column(2).search(val ? '^' + $.fn.dataTable.util.escapeRegex(val) + '$' : '', true, false).draw();
    });

    // Add: many destinations, and custom entries allowed so an address
    // outside your own domains can be typed rather than picked. Splits on
    // comma, semicolon, space and newline so a pasted list just works.
    addDeliversToTS = new TomSelect('#addDeliversTo', {
      create: function(input) {
        var v = input.trim().toLowerCase();
        // Only accept something that looks like an address. Keeps obvious
        // typos out before the server has to reject the whole save.
        if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(v)) { return false; }
        return { value: v, text: v };
      },
      createFilter: /^[^@\s]+@[^@\s]+\.[^@\s]+$/,
      persist: false,
      plugins: ['remove_button'],
      delimiter: ',',
      splitOn: /[,;\s\n]+/,
      sortField: { field: 'text', direction: 'asc' },
      placeholder: 'Pick a mailbox, or type any address...'
    });

    // Edit shows the alias's whole destination set as removable chips, the
    // same way the list renders it. Identical options to Add, so the two
    // behave the same.
    editDeliversToTS = new TomSelect('#editDeliversTo', {
      create: function(input) {
        var v = input.trim().toLowerCase();
        if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(v)) { return false; }
        return { value: v, text: v };
      },
      createFilter: /^[^@\s]+@[^@\s]+\.[^@\s]+$/,
      persist: false,
      plugins: ['remove_button'],
      delimiter: ',',
      splitOn: /[,;\s\n]+/,
      sortField: { field: 'text', direction: 'asc' },
      placeholder: 'Pick a mailbox, or type any address...'
    });
  });

  // Add modal: toggle forward/discard fields
  $('#addAliasType').on('change', function() {
    if ($(this).val() === 'discard') {
      $('#addDeliversToGroup').hide();
      $('#addSendAsGroup').hide();
      $('#addDiscardInfo').show();
      $('#addDeliversTo').prop('required', false);
    } else {
      $('#addDeliversToGroup').show();
      $('#addSendAsGroup').show();
      $('#addDiscardInfo').hide();
    }
  });

  // Edit modal: toggle forward/discard fields
  $('#editAliasType').on('change', function() {
    if ($(this).val() === 'discard') {
      $('#editDeliversToGroup').hide();
      $('#editSendAsGroup').hide();
      $('#editDiscardInfo').show();
      // Warn only when there is something to lose. Switching a discard alias
      // that is already discarding costs nothing and needs no alarm.
      var losing = editDeliversToTS ? editDeliversToTS.getValue() : [];
      if (typeof losing === 'string') { losing = losing ? losing.split(',') : []; }
      if (losing.length > 0) {
        $('#editDiscardLosingCount').text(losing.length);
        $('#editDiscardLosingList').text(losing.join(', '));
        $('#editForwardToDiscardWarning').show();
      } else {
        $('#editForwardToDiscardWarning').hide();
      }
    } else {
      $('#editDeliversToGroup').show();
      $('#editSendAsGroup').show();
      $('#editDiscardInfo').hide();
      $('#editForwardToDiscardWarning').hide();
    }
  });

  // Load edit modal via AJAX
  function loadEditAliasModal(aliasId) {
    $.post('./inc/get_mailbox_alias_json.cfm', { id: aliasId }, function(data) {
      try {
        var a = (typeof data === 'string') ? JSON.parse(data) : data;
        if (a.error) { alert('Error: ' + a.error); return; }
        $('#editAliasId').val(a.id);
        $('#editAliasAddress').val(a.alias_address);
        $('#editAliasType').val(a.alias_type).trigger('change');

        // Load the alias's whole destination set as chips. Options are added
        // first so addresses outside the mailbox list, typed in earlier, still
        // render rather than being silently dropped as unknown values.
        editDeliversToTS.clear(true);
        (a.destinations || []).forEach(function(d) {
          if (!editDeliversToTS.options[d]) {
            editDeliversToTS.addOption({ value: d, text: d });
          }
          editDeliversToTS.addItem(d, true);
        });

        $('#editInternalOnly').val(a.internal_only);
        new bootstrap.Modal(document.getElementById('editAliasModal')).show();
      } catch(e) { alert('Error loading alias data.'); }
    });
  }

  // Confirm delete

  // Remove the alias entirely, every destination it has.
  function confirmDeleteWholeAlias(address, destCount) {
    $('#deleteAliasWholeAddress').val(address);
    $('#deleteAliasAddressWhole').text(address);
    $('#deleteWholeCount').text(destCount);
    new bootstrap.Modal(document.getElementById('deleteAliasModal')).show();
  }

</script>

</html>
