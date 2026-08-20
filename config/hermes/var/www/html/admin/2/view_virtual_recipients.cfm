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
  <title>Hermes SEG | Virtual Recipients</title>
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
            <h1 class="m-0">Virtual Recipients</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Virtual Recipients</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">
<!--- errormessage carries the single verdict for an add. The four separate
     accumulating counters that used to live here (invalidemail, invaliddomain,
     alreadyexists and their HTML companions) existed only because the form
     submitted many addresses at once. --->
<cfparam name="errormessage" default="0">
<cfparam name="success" default="0">
<cfparam name="successrecipient" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLERS --->
<cfif action is "add">
  <cfif NOT StructKeyExists(form, "virtual_address") OR trim(form.virtual_address) is "">
    <cfset errormessage = 1>
  <cfelseif NOT StructKeyExists(form, "forwards_1") OR trim(form.forwards_1) is "">
    <cfset errormessage = 2>
  <cfelse>
    <!--- Delivers To may now hold SEVERAL destinations, so it can no longer
         be validated as a single address. Every entry must be a valid email;
         the first one that is not fails the whole submission, which is
         clearer than silently dropping it and reporting partial success. --->
    <cfset badForward = "">
    <cfloop index="fwdCheck" list="#Trim(form.forwards_1)#" delimiters=",; #chr(9)##chr(10)##chr(13)#">
      <cfif Trim(fwdCheck) is "">
        <cfcontinue>
      </cfif>
      <cfif NOT IsValid("email", Trim(fwdCheck))>
        <cfset badForward = Trim(fwdCheck)>
        <cfbreak>
      </cfif>
    </cfloop>
    <cfif badForward is not "">
      <cfset errormessage = 3>
    <cfelse>
      <cfinclude template="./inc/addvirtualrecipients.cfm">
    </cfif>
  </cfif>
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/editvirtualrecipient.cfm">
<cfelseif action is "deleterecipient">
  <cfif NOT StructKeyExists(form, "recipient_id") OR form.recipient_id is "">
    <cfset session.m = 1>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>
  <cfloop index="i" list="#form.recipient_id#" delimiters=",">
    <cfif IsValid("integer", i)>
      <cfset delete_id = i>
      <cfinclude template="./inc/delete_virtual_recipients.cfm">
    </cfif>
  </cfloop>
  <cfset session.m = 2>
  <cflocation url="view_virtual_recipients.cfm" addtoken="no">
</cfif>

<!--- Get data, ONE ROW PER ADDRESS

     This table has always allowed the same virtual address to appear more
     than once, each row naming a different destination, and Postfix
     concatenates the rows it gets back into a single recipient list. That
     is how a distribution list is expressed here, and installs in the field
     already contain lists built that way.

     Rendering the rows raw showed a twenty-member list as twenty
     near-identical lines, indistinguishable from twenty accidental
     duplicates. Collapsed here instead, with destinations as chips.

     dest_list feeds both the display chips and the edit modal, which loads
     the whole set at once. dest_ids is what the row's Delete button carries,
     so one click removes every row for that address: the delete caller
     already splits on comma and validates each as an integer. --->
<cfquery name="getvirtual" datasource="hermes">
  SELECT virtual_address,
         COUNT(*) AS dest_count,
         GROUP_CONCAT(id ORDER BY maps ASC)   AS dest_ids,
         GROUP_CONCAT(maps ORDER BY maps ASC) AS dest_list
  FROM virtual_recipients
  GROUP BY virtual_address
  ORDER BY virtual_address ASC
</cfquery>

<!--- Domains this gateway handles, used to flag a destination as external.
     External is allowed here and always has been, but it changes how the
     mail authenticates on the way out, so it is marked wherever a
     destination is shown rather than warned about once at creation. --->
<cfquery name="getLocalDomainsForVirtual" datasource="hermes">
  SELECT domain FROM domains
</cfquery>
<cfset localDomainList = ValueList(getLocalDomainsForVirtual.domain)>

<cfset session.m = "">

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Virtual Recipients</h5>
  <p class="mb-1">Virtual recipients forward email addresses on your <strong>relay domains</strong> to any email address, internal or external.</p>
  <ul class="mb-1">
    <li>Forward a specific address: <code>info@domain.com</code> &rarr; <code>bob@gmail.com</code></li>
    <li>Catch-all for a domain: <code>@domain.com</code> &rarr; <code>admin@domain.com</code></li>
  </ul>
  <p class="mb-0"><small>For mailbox domains (Email Server), use <a href="view_mailbox_aliases.cfm">Email Server &gt; Aliases</a> instead. Virtual recipients cannot be created for mailbox domains.</small></p>
</div>

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Nothing was deleted: the request carried no recipient to remove. Reload the page and
    try the Delete button on the row again.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Virtual recipient deleted successfully.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Recipient edited successfully.
  </div>
</cfif>
<cfif m is "10">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Virtual Address must be a valid email address or catch-all pattern (e.g., <code>@example.com</code>).
  </div>
</cfif>
<cfif m is "11">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field cannot be empty.
  </div>
</cfif>
<cfif m is "12">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field must be a valid email address.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain is not configured in the system.
  </div>
</cfif>
<cfif m is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The recipient you are attempting to save already exists.
  </div>
</cfif>
<cfif m is "15">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Enter at least one destination in <strong>Delivers To</strong>. Separate several with commas.
  </div>
</cfif>

<!--- ADD FORM ALERTS

     One address per submission means one verdict, so these are plain messages
     rather than the accumulating tallies the bulk textarea needed. --->
<cfif success GTE 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>Virtual recipient created with #success# destination<cfif success NEQ 1>s</cfif>:</cfoutput><br>
    <cfoutput>#successrecipient#</cfoutput>
  </div>
</cfif>
<cfif errormessage is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Virtual Address cannot be blank.
  </div>
</cfif>
<cfif errormessage is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field cannot be empty.
  </div>
</cfif>
<cfif errormessage is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    One of the destinations is not a valid email address.
  </div>
</cfif>
<cfif errormessage is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid email address format. Enter a full address such as <code>user@example.com</code>,
    or a catch-all pattern such as <code>@example.com</code>.
  </div>
</cfif>
<cfif errormessage is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    That domain does not exist in the system. Add it under Email Relay &gt; Domains first.
  </div>
</cfif>
<cfif errormessage is "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    That is a mailbox domain. Use Email Server &gt; Aliases for addresses on it.
  </div>
</cfif>
<cfif errormessage is "7">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This address already exists as a mailbox alias under Email Server. Remove it there first.
  </div>
</cfif>
<cfif errormessage is "8">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This virtual recipient already exists. To change where it delivers, or to add and
    remove destinations, use the Edit button on its row.
  </div>
</cfif>

<!--- The "bypassing ALL content checking" callout that used to sit here was
     removed: it was not true. content_filter in main.cf is global with no
     per-recipient exception, receive_override_options = no_address_mappings
     defers virtual alias expansion until AFTER amavis so the original address
     is what gets filtered, and adding a domain seeds an @domain row in
     `recipients` carrying the default policy. The wording dated back to
     build-220203 and described no part of this pipeline. The external
     forwarding caveat, which IS real, lives in the Add modal beside the field
     it applies to. --->

<!-- RECIPIENTS TABLE CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-envelope"></i> Virtual Recipients</h3>
  </div>
  <div class="card-body">
      <div class="mb-2">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRecipientModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Virtual Recipient</button>
      </div>

      <table id="sortTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 10%">Actions</th>
            <th>Recipient</th>
            <th>Delivers To</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getvirtual">
            <tr>
              <!--- One Edit and one Delete for the whole entry, matching Email
                   Server > Aliases. The select-all checkbox column that used to
                   lead this table is gone: it existed because the legacy view
                   rendered one row per destination, so an address with a large
                   destination set filled the screen and needed bulk selection.
                   The grouped query collapsed that to one row per address, and
                   dest_ids below still carries every underlying row id, so a
                   single Delete removes the whole entry. --->
              <td>
                <!--- The whole destination set is passed inline rather than
                     fetched over AJAX: the grouped query already has it, so an
                     endpoint would be a round trip for data that is on the
                     page. --->
                <div class="d-flex gap-1 flex-nowrap">
                <button type="button" class="btn btn-sm btn-primary" title="Edit this entry"
                  onclick="openEditModal('#encodeForJavaScript(virtual_address)#', '#encodeForJavaScript(dest_list)#'); return false;">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" title="Delete the whole entry"
                  onclick="confirmDeleteRecipient('#encodeForJavaScript(virtual_address)#', '#encodeForJavaScript(dest_ids)#', #dest_count#); return false;">
                  <i class="fas fa-trash"></i>
                </button>
                </div>
              </td>
              <td>#encodeForHTML(virtual_address)#</td>
              <td>
                <!--- Display only. Adding and removing happens in Edit, where
                     the same chips appear and can be changed as a set. --->
                <div class="d-flex flex-wrap gap-1">
                  <cfloop from="1" to="#ListLen(dest_list)#" index="vDestIdx">
                    <cfset vThisDest   = ListGetAt(dest_list, vDestIdx)>
                    <cfset vThisDomain = ListLast(vThisDest, "@")>
                    <cfset vIsExternal = (ListFindNoCase(localDomainList, vThisDomain) EQ 0)>
                    <span class="badge <cfif vIsExternal>bg-warning text-dark<cfelse>bg-light text-dark border</cfif>">
                      <cfif vIsExternal><i class="fas fa-external-link-alt me-1" title="Outside your domains"></i></cfif>#encodeForHTML(vThisDest)#
                    </span>
                  </cfloop>
                </div>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- ADD MODAL -->
<div class="modal fade" id="addRecipientModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="add">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Virtual Recipient</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Virtual Address</strong></label>
            <!--- One address, not a list. Was a textarea creating many at once,
                 which forced every outcome to be a per-row tally instead of a
                 plain answer. Matches Email Server > Aliases: one address in,
                 delivered to every destination below. --->
            <input type="text" class="form-control" id="virtual_address" name="virtual_address"
              placeholder="user@example.com" autocomplete="off" required>
            <small class="text-muted">
              A full email address (e.g., <code>user@example.com</code>) or a catch-all
              pattern (e.g., <code>@example.com</code>). The domain must already exist in the
              system and must be a relay domain.
            </small>
          </div>

          <div class="form-group mb-3">
            <label><strong>Delivers To</strong></label>
            <!--- Chips, not a comma-separated text box, so both destination
                 fields on this page are entered the same way. --->
            <select class="form-control" name="forwards_1" id="forwards_1" multiple
              placeholder="Pick a recipient, or type any address..."></select>
            <small class="text-muted">
              One or more destinations. Mail sent to the address above is delivered to every
              one of them, which is how a distribution list is made. Start typing to search
              your relay recipients, or type any address and press Enter.
            </small>

            <div class="alert alert-warning py-2 px-3 mt-2 mb-0">
              <i class="fas fa-external-link-alt me-1"></i>
              <strong>Destinations outside your own domains are allowed, with a caveat.</strong>
              Forwarded mail leaves with the original sender's address, so SPF fails at the
              receiving end, and if the message was modified on the way through the original
              DKIM signature no longer validates either. Senders whose domain publishes a
              strict DMARC policy may have mail to those destinations rejected. Local
              destinations are unaffected. Note that addresses on a relay domain are reachable
              from the internet by design, so a list here with external destinations can be
              mailed by anyone. If that matters, the list belongs on a mailbox domain, where
              it can be restricted to senders inside your own organisation.
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add Virtual Recipient</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <!--- Keyed on the ADDRESS, not a row id: the modal edits the whole
             entry, and the handler diffs the submitted destination set
             against what is stored. --->
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_original_address" id="edit_original_address" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Virtual Recipient</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_address" class="form-label"><strong>Virtual Address</strong></label>
            <input type="text" class="form-control" id="edit_address" name="edit_address" required>
            <small class="text-muted">Full email address or catch-all pattern (e.g., <code>@example.com</code>).</small>
          </div>
          <div class="mb-3">
            <label for="edit_forwards" class="form-label"><strong>Delivers To</strong></label>
            <select class="form-control" id="edit_forwards" name="edit_forwards" multiple placeholder="Pick a recipient, or type any address..."></select>
            <small class="text-muted">
              Every destination this address delivers to. Click the <strong>&times;</strong> on
              a chip to remove one, or type an address to add. Mail goes to all of them, which
              is how a distribution list is made.
            </small>
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

<!-- DELETE CONFIRMATION MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="deleterecipient">
        <input type="hidden" name="recipient_id" id="deleteRecipientIds" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete Virtual Recipient</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Delete <strong id="deleteRecipientAddress"></strong> and <span id="deleteRecipientCount"></span>?</p>
          <p class="mb-0 text-muted"><small>Mail sent to this address will no longer be forwarded anywhere. This cannot be undone.</small></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Yes, Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  $('#sortTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    // 0 Actions, 1 Recipient, 2 Delivers To.
    // Actions sits on the left, matching Email Server > Aliases.
    columnDefs: [
      { orderable: false, targets: [0] },
      { searchable: false, targets: [0] }
    ],
    // stateSave persists the sort by column INDEX, and this table lost its
    // leading checkbox column, so every index shifted. DataTables discards a
    // saved state whose column COUNT differs, which covers the 4-column
    // layouts, but not a state saved between the two 3-column revisions.
    // Reject any stored order pointing at the non-orderable Actions column.
    stateLoadParams: function (settings, data) {
      if (data.order && data.order.length && data.order[0][0] < 1) {
        data.order = [[1, 'asc']];
      }
    }
  });

  // One options builder for BOTH destination fields, Add and Edit, so the two
  // cannot drift apart again. Same behaviour as the alias page's chips.
  //
  // TomSelect's default value/text fields are kept rather than remapped, so
  // create() below and openEditModal()'s addOption() further down keep working
  // unchanged. The remote response is adapted in load() instead.
  function forwardsTomSelectOptions() {
    return {
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
      placeholder: 'Pick a recipient, or type any address...',
      // Fetch as soon as the field is focused, not only once the admin has
      // typed. The alias page's equivalent renders its options into the page
      // server-side, so clicking it shows the list immediately; these fields
      // fetch remotely and would otherwise look like plain text inputs until
      // you guessed that typing did something.
      preload: 'focus',
      // Relay recipient lists can be large, so options are searched on the
      // server rather than rendered into the page. Replaces the jQuery UI
      // autocomplete the old text input used, against the same endpoint.
      //
      // An empty query is passed through rather than short-circuited, because
      // that is exactly the focus case above. The endpoint caps its result set
      // so `LIKE '%%'` cannot return every recipient on the system.
      load: function(query, callback) {
        $.ajax({
          url: './inc/getintrecipients.cfm',
          type: 'post',
          dataType: 'json',
          data: { search: query, request: 1 },
          success: function(data) {
            // The endpoint returns {value: <recipients row id>, label:
            // <address>}. What TomSelect stores is what gets submitted, and
            // the handler writes it straight into virtual_recipients.maps, so
            // the ADDRESS has to become the value, not the row id.
            //
            // Read the key case-insensitively: this endpoint builds its
            // structs with bracket notation so the case survives, but Lucee
            // uppercases struct keys on serialization by default and one
            // refactor there would silently empty this list.
            callback((data || []).map(function(r) {
              var addr = r.label || r.LABEL || '';
              return { value: addr, text: addr };
            }).filter(function(o) { return o.value !== ''; }));
          },
          error: function() { callback(); }
        });
      }
    };
  }

  // Chips for the Add form's destination set.
  // Declared at script scope further down, alongside the edit instance.
  if (typeof TomSelect !== 'undefined') {
    addForwardsTS = new TomSelect('#forwards_1', forwardsTomSelectOptions());
  }

  // Chips for the edit modal's destination set. Declared at script scope
  // further down, because openEditModal() is global and would not see a
  // ready-scoped var.
  if (typeof TomSelect !== 'undefined') {
    editForwardsTS = new TomSelect('#edit_forwards', forwardsTomSelectOptions());
  }

  // The select-all / row-checkbox / Delete Selected machinery that used to
  // live here is gone with the checkbox column. Deleting is now one button per
  // row, matching Email Server > Aliases, and confirmDeleteRecipient() below
  // fills the same hidden field the bulk form used to.
  //
  // The jQuery UI autocomplete that used to bind to '.forwards' is gone with
  // the text input it served. Its endpoint is now called by the TomSelect
  // load() above, so recipient search still works and there is one code path
  // instead of two.
});

var addForwardsTS = null;
var editForwardsTS = null;

// Delete the whole entry. destIds is every underlying virtual_recipients row
// id for this address, comma joined by the grouped query; the handler already
// splits on comma and validates each as an integer, so one button removes the
// address and all of its destinations together.
function confirmDeleteRecipient(address, destIds, destCount) {
  document.getElementById('deleteRecipientIds').value = destIds;
  document.getElementById('deleteRecipientAddress').textContent = address;
  document.getElementById('deleteRecipientCount').textContent =
    destCount === 1 ? 'its 1 destination' : 'all ' + destCount + ' of its destinations';
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}

function openEditModal(address, destCsv) {
  document.getElementById('edit_original_address').value = address;
  document.getElementById('edit_address').value = address;

  // Load the entry's whole destination set as chips. Options are added before
  // items so an address that is not a known recipient, typed in earlier, still
  // renders rather than being dropped as an unknown value.
  //
  // clearOptions() is deliberately NOT called. It used to run here and wiped
  // every option the recipient search had already fetched, so reopening the
  // modal left the picker empty. Options are only suggestions; a stale one is
  // harmless, whereas an empty list makes the field look like a text box.
  if (editForwardsTS) {
    editForwardsTS.clear(true);
    (destCsv || '').split(',').forEach(function(d) {
      d = d.trim();
      if (!d) { return; }
      editForwardsTS.addOption({ value: d, text: d });
      editForwardsTS.addItem(d, true);
    });
    // Reset the typed query left behind by the programmatic adds, so the next
    // focus offers the whole list rather than a list filtered by whatever the
    // control still thinks was typed.
    editForwardsTS.setTextboxValue('');
    editForwardsTS.refreshOptions(false);
  }

  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

</body>
</html>
