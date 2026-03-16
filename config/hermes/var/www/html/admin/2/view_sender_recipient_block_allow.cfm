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
  <title>Hermes SEG | Sender/Recipient Block/Allow</title>

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
            <h1 class="m-0">Sender/Recipient Block/Allow</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Sender/Recipient Block/Allow</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not ""><cfset m = session.m></cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(url, "action")>
  <cfif url.action is not ""><cfset action = url.action></cfif>
</cfif>
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not ""><cfset action = form.action></cfif>
</cfif>

<!--- GET DATA --->
<cfinclude template="./inc/get_sender_recipient_block_allow.cfm">

<!--- ===================== --->
<!--- ACTION: ADD ENTRY --->
<!--- ===================== --->
<cfif action is "add_entry">
  <cfparam name="form.sender" default="">
  <cfparam name="form.recipient" default="">
  <cfparam name="form.entry_type" default="BLOCK">

  <cfset sender = trim(form.sender)>
  <cfset recipient = trim(form.recipient)>
  <cfset entryType = trim(form.entry_type)>

  <!--- Validate sender --->
  <cfif sender is "">
    <cfset session.m = 30>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Validate recipient --->
  <cfif recipient is "">
    <cfset session.m = 31>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Validate entry type --->
  <cfif entryType is not "BLOCK" AND entryType is not "ALLOW">
    <cfset session.m = 32>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Determine if sender is email or domain --->
  <cfif Find("@", sender) GT 0>
    <cfset senderType = "email">
  <cfelse>
    <cfset senderType = "domain">
  </cfif>

  <!--- Validate sender format --->
  <cfif senderType is "email">
    <cfif NOT IsValid("email", sender)>
      <cfset session.m = 33>
      <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
    </cfif>
  <cfelse>
    <!--- Domain validation: prepend bob@ to test validity --->
    <cfif Left(sender, 1) is ".">
      <cfset testEmail = "bob@temp" & sender>
    <cfelse>
      <cfset testEmail = "bob@" & sender>
    </cfif>
    <cfif NOT IsValid("email", testEmail)>
      <cfset session.m = 33>
      <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
    </cfif>
  </cfif>

  <!--- Look up recipient in recipients table --->
  <cfquery name="getRecipient" datasource="hermes">
    SELECT id, recipient, domain FROM recipients
    WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
    OR (domain = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
        AND <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar"> LIKE CONCAT('%', REPLACE(recipient, '@', ''), '%'))
    ORDER BY domain ASC
    LIMIT 1
  </cfquery>

  <cfif getRecipient.recordCount LT 1>
    <cfset session.m = 34>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Check sender/recipient domain mismatch (cannot be same domain) --->
  <cfif getRecipient.domain is "1">
    <cfset recipientDomain = REReplace(getRecipient.recipient, "@", "", "ALL")>
  <cfelse>
    <cfset recipientDomain = trim(ListGetAt(getRecipient.recipient, 2, "@"))>
  </cfif>

  <cfif senderType is "email">
    <cfset senderDomain = trim(ListGetAt(sender, 2, "@"))>
  <cfelse>
    <cfset senderDomain = sender>
  </cfif>

  <cfif CompareNoCase(senderDomain, recipientDomain) is 0>
    <cfset session.m = 35>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Format sender for storage (domains get @ prefix) --->
  <cfif senderType is "domain">
    <cfset senderStored = "@" & sender>
  <cfelse>
    <cfset senderStored = sender>
  </cfif>

  <!--- Check for duplicate --->
  <cfquery name="checkExists" datasource="hermes">
    SELECT id FROM mailaddr_temp
    WHERE receiver = <cfqueryparam value="#getRecipient.recipient#" cfsqltype="cf_sql_varchar">
      AND sender = <cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif checkExists.recordCount GTE 1>
    <cfset session.m = 36>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Check if sender already exists in mailaddr table --->
  <cfquery name="checkSenderAddr" datasource="hermes">
    SELECT id, email FROM mailaddr
    WHERE email = <cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif checkSenderAddr.recordCount LT 1>
    <!--- Insert sender into mailaddr --->
    <cfquery name="insertSenderAddr" datasource="hermes" result="stSender">
      INSERT INTO mailaddr (email)
      VALUES (<cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">)
    </cfquery>
    <cfset senderMailaddrId = stSender.GENERATED_KEY>
  <cfelse>
    <cfset senderMailaddrId = checkSenderAddr.id>
  </cfif>

  <!--- If recipient is a domain entry, add mapping for all recipients in that domain --->
  <cfif getRecipient.domain is "1">
    <cfquery name="getDomainRecipients" datasource="hermes">
      SELECT id, recipient FROM recipients
      WHERE recipient LIKE <cfqueryparam value="%#recipientDomain#%" cfsqltype="cf_sql_varchar">
        AND domain IS NULL
    </cfquery>
    <cfloop query="getDomainRecipients">
      <!--- Check if this specific mapping already exists --->
      <cfquery name="checkDomainDup" datasource="hermes">
        SELECT id FROM mailaddr_temp
        WHERE recipient_id = <cfqueryparam value="#getDomainRecipients.id#" cfsqltype="cf_sql_integer">
          AND mailaddr_id = <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfif checkDomainDup.recordCount LT 1>
        <cfquery datasource="hermes">
          INSERT INTO mailaddr_temp (recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
          VALUES (
            <cfqueryparam value="#getDomainRecipients.id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#entryType#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#getDomainRecipients.recipient#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
          )
        </cfquery>
      </cfif>
    </cfloop>
  <cfelse>
    <!--- Single recipient mapping --->
    <cfquery datasource="hermes">
      INSERT INTO mailaddr_temp (recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
      VALUES (
        <cfqueryparam value="#getRecipient.id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#senderStored#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#entryType#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#getRecipient.recipient#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
      )
    </cfquery>
  </cfif>

  <cfset session.m = 1>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE --->
<!--- ===================== --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      UPDATE mailaddr_temp
      SET action = <cfqueryparam value="delete" cfsqltype="cf_sql_varchar">,
          applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: BULK DELETE --->
<!--- ===================== --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          UPDATE mailaddr_temp
          SET action = <cfqueryparam value="delete" cfsqltype="cf_sql_varchar">,
              applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: EDIT --->
<!--- ===================== --->
<cfif action is "edit_entry">
  <cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
    <cfset editSender = trim(form.edit_sender)>
    <cfset editRecipient = trim(form.edit_recipient)>
    <cfset editType = trim(form.edit_type)>

    <!--- Validate --->
    <cfif editSender is "" OR editRecipient is "" OR (editType is not "BLOCK" AND editType is not "ALLOW")>
      <cfset session.m = 32>
      <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
    </cfif>

    <!--- Look up the existing entry to get mailaddr_id and recipient_id --->
    <cfquery name="getExisting" datasource="hermes">
      SELECT id, recipient_id, mailaddr_id, sender, receiver FROM mailaddr_temp
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif getExisting.recordCount GT 0>
      <!--- Determine if sender format changed --->
      <cfif Find("@", editSender) GT 0>
        <cfset editSenderStored = editSender>
      <cfelse>
        <cfset editSenderStored = "@" & editSender>
      </cfif>

      <!--- Update mailaddr entry if sender changed --->
      <cfif editSenderStored is not getExisting.sender>
        <!--- Check if new sender already in mailaddr --->
        <cfquery name="checkNewSender" datasource="hermes">
          SELECT id FROM mailaddr
          WHERE email = <cfqueryparam value="#editSenderStored#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif checkNewSender.recordCount LT 1>
          <cfquery name="insertNewSender" datasource="hermes" result="stNewSender">
            INSERT INTO mailaddr (email)
            VALUES (<cfqueryparam value="#editSenderStored#" cfsqltype="cf_sql_varchar">)
          </cfquery>
          <cfset newMailaddrId = stNewSender.GENERATED_KEY>
        <cfelse>
          <cfset newMailaddrId = checkNewSender.id>
        </cfif>
      <cfelse>
        <cfset newMailaddrId = getExisting.mailaddr_id>
      </cfif>

      <cfquery datasource="hermes">
        UPDATE mailaddr_temp
        SET sender = <cfqueryparam value="#editSenderStored#" cfsqltype="cf_sql_varchar">,
            receiver = <cfqueryparam value="#editRecipient#" cfsqltype="cf_sql_varchar">,
            wb = <cfqueryparam value="#editType#" cfsqltype="cf_sql_varchar">,
            mailaddr_id = <cfqueryparam value="#newMailaddrId#" cfsqltype="cf_sql_integer">,
            action = <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">,
            applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 5>
    </cfif>
  </cfif>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: CANCEL ADD --->
<!--- ===================== --->
<cfif action is "cancel_add">
  <cfquery datasource="hermes">
    DELETE FROM mailaddr_temp
    WHERE action = <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">
      AND applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfset session.m = 6>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: CANCEL DELETE --->
<!--- ===================== --->
<cfif action is "cancel_delete">
  <cfquery datasource="hermes">
    UPDATE mailaddr_temp
    SET action = <cfqueryparam value="NONE" cfsqltype="cf_sql_varchar">,
        applied = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
    WHERE action = <cfqueryparam value="delete" cfsqltype="cf_sql_varchar">
      AND applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfset session.m = 7>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: APPLY --->
<!--- ===================== --->
<cfif action is "apply">
  <!--- Get pending inserts --->
  <cfquery name="getInserts" datasource="hermes">
    SELECT id, recipient_id, mailaddr_id, wb FROM mailaddr_temp
    WHERE action = <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">
      AND applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
  </cfquery>

  <!--- Get pending deletes --->
  <cfquery name="getDeletes" datasource="hermes">
    SELECT id, recipient_id, mailaddr_id FROM mailaddr_temp
    WHERE action = <cfqueryparam value="delete" cfsqltype="cf_sql_varchar">
      AND applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
  </cfquery>

  <!--- Process inserts into wblist --->
  <cfloop query="getInserts">
    <cfquery datasource="hermes">
      INSERT INTO wblist (rid, sid, wb)
      VALUES (
        <cfqueryparam value="#getInserts.recipient_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#getInserts.mailaddr_id#" cfsqltype="cf_sql_integer">,
        <cfif getInserts.wb is "ALLOW"><cfqueryparam value="W" cfsqltype="cf_sql_varchar"><cfelse><cfqueryparam value="B" cfsqltype="cf_sql_varchar"></cfif>
      )
    </cfquery>
  </cfloop>

  <!--- Process deletes from wblist --->
  <cfloop query="getDeletes">
    <cfquery datasource="hermes">
      DELETE FROM wblist
      WHERE rid = <cfqueryparam value="#getDeletes.recipient_id#" cfsqltype="cf_sql_integer">
        AND sid = <cfqueryparam value="#getDeletes.mailaddr_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfloop>

  <!--- Mark inserts as applied --->
  <cfquery datasource="hermes">
    UPDATE mailaddr_temp
    SET applied = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">,
        action = <cfqueryparam value="NONE" cfsqltype="cf_sql_varchar">
    WHERE applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
      AND action = <cfqueryparam value="insert" cfsqltype="cf_sql_varchar">
  </cfquery>

  <!--- Remove deleted entries from mailaddr_temp --->
  <cfquery datasource="hermes">
    DELETE FROM mailaddr_temp
    WHERE applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
      AND action = <cfqueryparam value="delete" cfsqltype="cf_sql_varchar">
  </cfquery>

  <!--- Reload Amavis to pick up changes --->
  <cftry>
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
      timeout="30" />
    <cfset session.m = 3>
    <cfcatch type="any">
      <cfset session.m = 4>
    </cfcatch>
  </cftry>

  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_sender_recipient_block_allow.cfm">
<cfset session.m = "">

<!--- ===================== --->
<!--- ALERTS --->
<!--- ===================== --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Staged</h4>
    <p>Entry ready to be added. Click <strong>Apply Settings</strong> to activate.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Marked for Deletion</h4>
    <p>Click <strong>Apply Settings</strong> to confirm.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Settings Applied</h4>
    <p>Sender/Recipient block/allow configuration applied and Amavis reloaded.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Apply Failed</h4>
    <p>Changes were saved to the database but Amavis reload failed. Please check the mail filter container.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-edit"></i> Entry Updated</h4>
    <p>Click <strong>Apply Settings</strong> to activate.</p>
  </div>
</cfif>
<cfif m is 6>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-undo"></i> Pending Additions Cancelled</h4>
  </div>
</cfif>
<cfif m is 7>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-undo"></i> Pending Deletions Cancelled</h4>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The Sender Domain or Email Address field cannot be blank.</p>
  </div>
</cfif>
<cfif m is 31>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The Recipient field cannot be blank.</p>
  </div>
</cfif>
<cfif m is 32>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Invalid block/allow type specified.</p>
  </div>
</cfif>
<cfif m is 33>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The Sender field must be a valid email address or a valid domain.</p>
  </div>
</cfif>
<cfif m is 34>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The specified recipient was not found in the system.</p>
  </div>
</cfif>
<cfif m is 35>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The sender and recipient domains cannot be the same.</p>
  </div>
</cfif>
<cfif m is 36>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>This sender to recipient mapping already exists or is already staged for addition.</p>
  </div>
</cfif>

<!--- ===================== --->
<!--- PENDING CHANGES --->
<!--- ===================== --->
<cfif has_pending_changes>
  <cfif get_pending_adds.recordCount GT 0>
    <div class="card card-warning card-outline mb-4">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock"></i> Pending Additions (<cfoutput>#get_pending_adds.recordCount#</cfoutput>)</h3>
      </div>
      <div class="card-body">
        <cfoutput query="get_pending_adds">
          <span class="badge <cfif wb is 'ALLOW'>bg-success<cfelse>bg-danger</cfif> me-1">+ #encodeForHTML(sender)# &rarr; #encodeForHTML(receiver)# (#wb#)</span>
        </cfoutput>
        <div class="mt-3">
          <form method="post" class="d-inline">
            <input type="hidden" name="action" value="cancel_add">
            <button type="submit" class="btn btn-sm btn-secondary"><i class="fas fa-undo"></i> Cancel Additions</button>
          </form>
        </div>
      </div>
    </div>
  </cfif>
  <cfif get_pending_deletes.recordCount GT 0>
    <div class="card card-danger card-outline mb-4">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock"></i> Pending Deletions (<cfoutput>#get_pending_deletes.recordCount#</cfoutput>)</h3>
      </div>
      <div class="card-body">
        <cfoutput query="get_pending_deletes">
          <span class="badge bg-danger me-1">- #encodeForHTML(sender)# &rarr; #encodeForHTML(receiver)#</span>
        </cfoutput>
        <div class="mt-3">
          <form method="post" class="d-inline">
            <input type="hidden" name="action" value="cancel_delete">
            <button type="submit" class="btn btn-sm btn-secondary"><i class="fas fa-undo"></i> Cancel Deletions</button>
          </form>
        </div>
      </div>
    </div>
  </cfif>
  <div class="mb-4">
    <form method="post" class="d-inline">
      <input type="hidden" name="action" value="apply">
      <button type="submit" class="btn btn-danger btn-lg"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">
        <i class="fas fa-check-circle"></i> Apply Settings
      </button>
    </form>
  </div>
</cfif>

<!--- ===================== --->
<!--- ADD ENTRY CARD --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Sender/Recipient Entry</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-info mb-3">
      <p class="mb-0"><strong>Note:</strong> Allow entries only bypass Spam checks. Emails with Viruses, Banned Files, and Bad Headers will still be blocked. To block/allow an entire domain and all its sub-domains, enter <code>.domain.tld</code> (note the leading dot).</p>
    </div>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entry">
      <div class="row">
        <div class="col-md-4">
          <label for="sender" class="form-label"><strong>Sender Email or Domain</strong></label>
          <input type="text" class="form-control" id="sender" name="sender" maxlength="255"
            placeholder="user@example.com or .example.com">
          <small class="text-muted">Email address or domain (prefix with . for subdomains)</small>
        </div>
        <div class="col-md-4">
          <label for="recipient" class="form-label"><strong>Recipient</strong></label>
          <input type="text" class="form-control" id="recipient" name="recipient" maxlength="255" list="recipientList"
            placeholder="user@example.com or @example.com">
          <small class="text-muted">Type to search recipients</small>
          <!--- Populate datalist with recipients from the database --->
          <cfquery name="getAllRecipients" datasource="hermes">
            SELECT id, recipient, domain FROM recipients ORDER BY recipient ASC
          </cfquery>
          <datalist id="recipientList">
            <cfoutput query="getAllRecipients">
              <option value="#encodeForHTMLAttribute(recipient)#">
            </cfoutput>
          </datalist>
        </div>
        <div class="col-md-2">
          <label class="form-label"><strong>Action</strong></label>
          <div>
            <div class="form-check mb-2">
              <input class="form-check-input" type="radio" name="entry_type" id="type_block" value="BLOCK" checked>
              <label class="form-check-label" for="type_block"><i class="fas fa-ban text-danger"></i> Block</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="entry_type" id="type_allow" value="ALLOW">
              <label class="form-check-label" for="type_allow"><i class="fas fa-check text-success"></i> Allow</label>
            </div>
          </div>
        </div>
        <div class="col-md-2 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Entry
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!--- ===================== --->
<!--- ENTRIES TABLE --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-exchange-alt"></i> Sender/Recipient Entries</h3>
  </div>
  <div class="card-body">
    <form id="bulkDeleteForm" method="post">
      <input type="hidden" name="action" value="bulk_delete">
      <input type="hidden" name="selected_ids" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" class="btn btn-sm btn-danger" id="bulkDeleteBtn" disabled
          onclick="submitBulkDelete();">
          <i class="fas fa-trash"></i> Delete Selected
        </button>
      </div>

      <table id="senderRecipientTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 30%">Sender</th>
            <th style="width: 30%">Recipient</th>
            <th style="width: 10%">Type</th>
            <th style="width: 25%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_active_all">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(sender)#</td>
              <td>#encodeForHTML(receiver)#</td>
              <td>
                <cfif wb is "ALLOW">
                  <span class="badge bg-success">Allow</span>
                <cfelse>
                  <span class="badge bg-danger">Block</span>
                </cfif>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#id#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(receiver)#', '#encodeForJavaScript(wb)#');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(receiver)#');" title="Delete">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    </form>
  </div>
</div>

<!--- ===================== --->
<!--- EDIT MODAL --->
<!--- ===================== --->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Sender/Recipient Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_sender" class="form-label"><strong>Sender Email or Domain</strong></label>
            <input type="text" class="form-control" id="edit_sender" name="edit_sender" required>
          </div>
          <div class="mb-3">
            <label for="edit_recipient" class="form-label"><strong>Recipient</strong></label>
            <input type="text" class="form-control" id="edit_recipient" name="edit_recipient" required readonly>
            <small class="text-muted">Recipient cannot be changed. Delete and re-add if needed.</small>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Type</strong></label>
            <select class="form-select" name="edit_type" id="edit_type">
              <option value="BLOCK">Block</option>
              <option value="ALLOW">Allow</option>
            </select>
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

<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#senderRecipientTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 4] },
      { searchable: false, targets: [0, 4] }
    ]
  });

  var selectedIds = new Set();
  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.row-checkbox:visible').each(function() {
      this.checked = checked;
      if (checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    });
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  $(document).on('change', '.row-checkbox', function() {
    if (this.checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  window.submitBulkDelete = function() {
    if (selectedIds.size === 0) return;
    if (!confirm('Delete ' + selectedIds.size + ' selected entries?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function openEditModal(id, sender, recipient, wb) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_sender').value = sender;
  document.getElementById('edit_recipient').value = recipient;
  document.getElementById('edit_type').value = wb;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function deleteSingle(id, sender, recipient) {
  if (!confirm('Delete mapping "' + sender + ' \u2192 ' + recipient + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}
</script>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
