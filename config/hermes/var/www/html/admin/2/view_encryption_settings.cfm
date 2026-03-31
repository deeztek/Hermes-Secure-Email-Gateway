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
  <title>Hermes SEG | Encryption Settings</title>
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
            <h1 class="m-0">Encryption Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Encryption Settings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m_enc") AND session.m_enc is not "">
  <cfset m = session.m_enc>
  <cfset session.m_enc = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Load current settings --->
<cfquery name="get_subjectenable" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.subjectTriggerEnabled'
</cfquery>
<cfquery name="get_subject_trigger" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.subjectTrigger'
</cfquery>
<cfquery name="get_removesubjecttrigger" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.subjectTriggerRemovePattern'
</cfquery>
<cfquery name="get_portal_url" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'console.host' AND module = 'console'
</cfquery>
<cfquery name="get_pdfreply_sender" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.pdf.replySender'
</cfquery>

<!--- Decrypt secret keywords --->
<cfquery name="get_serverkeyword" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.serverSecret'
</cfquery>
<cfquery name="get_clientkeyword" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.clientSecret'
</cfquery>
<cfquery name="get_mailkeyword" datasource="hermes">
  SELECT value FROM encryption_settings WHERE property = 'user.systemMailSecret'
</cfquery>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<cfset theServerKeyword = "">
<cfif get_serverkeyword.value is not "">
  <cftry>
    <cfset theServerKeyword = decrypt(get_serverkeyword.value, hermeskey, "AES", "Base64")>
    <cfcatch><cfset theServerKeyword = ""></cfcatch>
  </cftry>
</cfif>

<cfset theClientKeyword = "">
<cfif get_clientkeyword.value is not "">
  <cftry>
    <cfset theClientKeyword = decrypt(get_clientkeyword.value, hermeskey, "AES", "Base64")>
    <cfcatch><cfset theClientKeyword = ""></cfcatch>
  </cftry>
</cfif>

<cfset theMailKeyword = "">
<cfif get_mailkeyword.value is not "">
  <cftry>
    <cfset theMailKeyword = decrypt(get_mailkeyword.value, hermeskey, "AES", "Base64")>
    <cfcatch><cfset theMailKeyword = ""></cfcatch>
  </cftry>
</cfif>

<!--- Set display values --->
<cfset show_subjectenable = get_subjectenable.value>
<cfset show_subject_trigger = get_subject_trigger.value>
<cfset show_removesubjecttrigger = get_removesubjecttrigger.value>
<cfset show_portal_url = "https://" & get_portal_url.value2 & "/web/portal">
<cfset show_pdfreply_sender = get_pdfreply_sender.value>
<cfset show_serverkeyword = theServerKeyword>
<cfset show_clientkeyword = theClientKeyword>
<cfset show_mailkeyword = theMailKeyword>

<!--- Mask keywords for display (show last 4 chars only) --->
<cfset masked_serverkeyword = IIF(Len(theServerKeyword) GTE 4, DE("********************" & Right(theServerKeyword, 4)), DE(theServerKeyword))>
<cfset masked_clientkeyword = IIF(Len(theClientKeyword) GTE 4, DE("********************" & Right(theClientKeyword, 4)), DE(theClientKeyword))>
<cfset masked_mailkeyword = IIF(Len(theMailKeyword) GTE 4, DE("********************" & Right(theMailKeyword, 4)), DE(theMailKeyword))>

<!--- Override with form values if submitted --->
<cfif StructKeyExists(form, "subjectenable")><cfset show_subjectenable = form.subjectenable></cfif>
<cfif StructKeyExists(form, "subject_trigger")><cfset show_subject_trigger = form.subject_trigger></cfif>
<cfif StructKeyExists(form, "removesubjecttrigger")><cfset show_removesubjecttrigger = form.removesubjecttrigger></cfif>
<cfif StructKeyExists(form, "pdfreply_sender")><cfset show_pdfreply_sender = form.pdfreply_sender></cfif>

<!--- ===================== --->
<!--- ACTION: GENERATE     --->
<!--- ===================== --->
<cfif action is "generate_server" OR action is "generate_client" OR action is "generate_mail">
  <!--- Generate 64-character random keyword by concatenating multiple rounds --->
  <cfset generatedKeyword = "">
  <cfloop from="1" to="8" index="i">
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cfset generatedKeyword = generatedKeyword & LCase(customtrans3)>
  </cfloop>
  <cfset generatedKeyword = Left(generatedKeyword, 64)>
  <cfset encrypted_generated = encrypt(generatedKeyword, hermeskey, "AES", "Base64")>

  <!--- Save immediately to DB and apply to Ciphermail --->
  <cfif action is "generate_server">
    <cfquery datasource="hermes">
      UPDATE encryption_settings SET value = <cfqueryparam value="#encrypted_generated#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.serverSecret'
    </cfquery>
    <cfset show_serverkeyword = generatedKeyword>
  </cfif>
  <cfif action is "generate_client">
    <cfquery datasource="hermes">
      UPDATE encryption_settings SET value = <cfqueryparam value="#encrypted_generated#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.clientSecret'
    </cfquery>
    <cfset show_clientkeyword = generatedKeyword>
  </cfif>
  <cfif action is "generate_mail">
    <cfquery datasource="hermes">
      UPDATE encryption_settings SET value = <cfqueryparam value="#encrypted_generated#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.systemMailSecret'
    </cfquery>
    <cfset show_mailkeyword = generatedKeyword>
  </cfif>

  <!--- Apply all current keywords to Ciphermail (legacy write-read-write pattern) --->
  <cfinclude template="./inc/generate_customtrans.cfm">
  <cffile action="read" file="/opt/hermes/scripts/edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'PDFREPLY-SENDER', trim(show_pdfreply_sender), 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'PORTAL-URL', show_portal_url, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'SUBJECT-TRIGGER', trim(show_subject_trigger), 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'SUBJECT-ENABLE', show_subjectenable, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'TRIGGER-REMOVE', show_removesubjecttrigger, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'SERVER-SECRET', show_serverkeyword, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'CLIENT-SECRET', show_clientkeyword, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'MAIL-SECRET', show_mailkeyword, 'ALL')#" addnewline="no">

  <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" timeout="60"></cfexecute>
  <cftry>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
      timeout="240"
      variable="ciphermailOutput2"
      errorVariable="ciphermailError2">
    </cfexecute>
    <cfcatch type="any"></cfcatch>
  </cftry>
  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh">
  </cfif>

  <cfset session.m_enc = 12>
  <cflocation url="view_encryption_settings.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: SAVE         --->
<!--- ===================== --->
<cfif action is "save_settings">
  <!--- Validation --->
  <cfif trim(show_subject_trigger) is "">
    <cfset session.m_enc = 4>
    <cflocation url="view_encryption_settings.cfm" addtoken="no">
  </cfif>
  <cfif trim(show_pdfreply_sender) is "">
    <cfset session.m_enc = 3>
    <cflocation url="view_encryption_settings.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsValid("email", trim(show_pdfreply_sender))>
    <cfset session.m_enc = 2>
    <cflocation url="view_encryption_settings.cfm" addtoken="no">
  </cfif>
  <!--- Update database (keywords managed separately via generate) --->
  <cfquery datasource="hermes">
    UPDATE encryption_settings SET value = <cfqueryparam value="#trim(show_pdfreply_sender)#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.pdf.replySender'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE encryption_settings SET value = <cfqueryparam value="#show_portal_url#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.portal.baseURL'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE encryption_settings SET value = <cfqueryparam value="#trim(show_subject_trigger)#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.subjectTrigger'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE encryption_settings SET value = <cfqueryparam value="#show_subjectenable#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.subjectTriggerEnabled'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE encryption_settings SET value = <cfqueryparam value="#show_removesubjecttrigger#" cfsqltype="cf_sql_varchar"> WHERE property = 'user.subjectTriggerRemovePattern'
  </cfquery>

  <!--- Apply to Ciphermail via temp script (legacy write-read-write pattern) --->
  <cfinclude template="./inc/generate_customtrans.cfm">
  <cffile action="read" file="/opt/hermes/scripts/edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'PDFREPLY-SENDER', trim(show_pdfreply_sender), 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'PORTAL-URL', show_portal_url, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'SUBJECT-TRIGGER', trim(show_subject_trigger), 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'SUBJECT-ENABLE', show_subjectenable, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'TRIGGER-REMOVE', show_removesubjecttrigger, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'SERVER-SECRET', show_serverkeyword, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'CLIENT-SECRET', show_clientkeyword, 'ALL')#" addnewline="no">
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output="#REReplace(temp, 'MAIL-SECRET', show_mailkeyword, 'ALL')#" addnewline="no">

  <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" timeout="60"></cfexecute>
  <cftry>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
      timeout="240"
      variable="ciphermailOutput"
      errorVariable="ciphermailError">
    </cfexecute>
    <cfcatch type="any">
      <cfif fileExists("/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh")>
        <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh">
      </cfif>
      <cfset session.m_enc = 11>
      <cflocation url="view_encryption_settings.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh">
  </cfif>

  <cfset session.m_enc = 7>
  <cflocation url="view_encryption_settings.cfm" addtoken="no">
</cfif>

<!--- ALERTS --->
<cfif m is 2>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The PDF Reply Sender is not a valid email address.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The PDF Reply Sender email cannot be empty.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Subject Trigger keyword cannot be empty.</p></div>
</cfif>
<cfif m is 7>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Encryption settings saved and applied to Ciphermail.</p></div>
</cfif>
<cfif m is 8>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Server Secret Keyword must be at least 10 characters with lowercase letters and numbers.</p></div>
</cfif>
<cfif m is 9>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Client Secret Keyword must be at least 10 characters with lowercase letters and numbers.</p></div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Mail Secret Keyword must be at least 10 characters with lowercase letters and numbers.</p></div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Settings saved to database but failed to apply to Ciphermail. Please check the logs.</p></div>
</cfif>
<cfif m is 12>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Secret keyword generated and applied to Ciphermail.</p></div>
</cfif>

<!--- PAGE GUIDE --->
<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-1">Configure Ciphermail encryption settings including subject-triggered encryption, PDF reply sender, and secret keywords used for secure portal communication.</p>
  <p class="mb-0">The <strong>Subject Trigger</strong> allows users to trigger email encryption by including a keyword in the subject line. <strong>Secret Keywords</strong> are used by Ciphermail for server, client, and mail authentication -- use the generate button to create new keywords.</p>
</div>

<!--- SETTINGS FORM --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-cogs"></i> Encryption Settings</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">

      <!--- Subject Trigger Settings --->
      <h6 class="mb-3"><strong>Subject Trigger Settings</strong></h6>
      <p class="text-muted mb-2">When enabled, users can trigger encryption by including the subject trigger keyword in the email subject line.</p>

      <div class="row mb-3">
        <div class="col-md-3">
          <label class="form-label">Trigger Encryption by Subject</label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="subjectenable" id="subjectenable_y" value="true" <cfif show_subjectenable is "true">checked</cfif>>
              <label class="form-check-label" for="subjectenable_y">Enabled</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="subjectenable" id="subjectenable_n" value="false" <cfif show_subjectenable is "false">checked</cfif>>
              <label class="form-check-label" for="subjectenable_n">Disabled</label>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <label for="subject_trigger" class="form-label">Subject Trigger Keyword</label>
          <cfoutput><input type="text" class="form-control" id="subject_trigger" name="subject_trigger" maxlength="75" value="#encodeForHTMLAttribute(show_subject_trigger)#" required></cfoutput>
          <small class="text-muted">e.g. [encrypt]</small>
        </div>
        <div class="col-md-3">
          <label class="form-label">Remove Trigger After Encryption</label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="removesubjecttrigger" id="removetrigger_y" value="true" <cfif show_removesubjecttrigger is "true">checked</cfif>>
              <label class="form-check-label" for="removetrigger_y">Yes</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="removesubjecttrigger" id="removetrigger_n" value="false" <cfif show_removesubjecttrigger is "false">checked</cfif>>
              <label class="form-check-label" for="removetrigger_n">No</label>
            </div>
          </div>
          <small class="text-muted">Recommended: Yes</small>
        </div>
        <div class="col-md-3">
          <label for="pdfreply_sender" class="form-label">PDF Reply Sender Email</label>
          <cfoutput><input type="email" class="form-control" id="pdfreply_sender" name="pdfreply_sender" maxlength="255" value="#encodeForHTMLAttribute(show_pdfreply_sender)#" required></cfoutput>
          <small class="text-muted">Sender address for PDF encrypted replies</small>
        </div>
      </div>

      <hr>

      <!--- Secret Keywords --->
      <h6 class="mb-3"><strong>Secret Keywords</strong></h6>
      <p class="text-muted mb-2">Use the <i class="fas fa-sync-alt"></i> button to generate a new keyword. Keywords are auto-generated and cannot be edited manually.</p>

      <div class="row mb-3">
        <div class="col-md-4">
          <label class="form-label">Server Secret Keyword</label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#encodeForHTMLAttribute(masked_serverkeyword)#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generate_server', 'Server Secret Keyword');" title="Generate Server Keyword">
              <i class="fas fa-sync-alt"></i>
            </button>
          </div>
        </div>
        <div class="col-md-4">
          <label class="form-label">Client Secret Keyword</label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#encodeForHTMLAttribute(masked_clientkeyword)#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generate_client', 'Client Secret Keyword');" title="Generate Client Keyword">
              <i class="fas fa-sync-alt"></i>
            </button>
          </div>
        </div>
        <div class="col-md-4">
          <label class="form-label">Mail Secret Keyword</label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#encodeForHTMLAttribute(masked_mailkeyword)#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generate_mail', 'Mail Secret Keyword');" title="Generate Mail Keyword">
              <i class="fas fa-sync-alt"></i>
            </button>
          </div>
        </div>
      </div>

      <hr>

      <button type="submit" class="btn btn-primary btn-lg"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
        <i class="fas fa-save"></i> Save Settings
      </button>
    </form>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


<!-- GENERATE SECRET MODAL (reusable) -->
<div class="modal fade" id="generateModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" id="generateAction" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title" id="generateTitle">Generate Secret</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to generate a new <strong id="generateLabel"></strong>?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger"
            onclick="this.disabled=true;this.innerHTML='Generating...';this.form.submit();">Yes, Generate</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function showGenerateModal(action, label) {
  document.getElementById('generateAction').value = action;
  document.getElementById('generateTitle').textContent = 'Generate ' + label;
  document.getElementById('generateLabel').textContent = label;
  new bootstrap.Modal(document.getElementById('generateModal')).show();
}
</script>

</body>
</html>
