<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
  <title>Hermes SEG | Add Relay Recipient(s)</title>
  
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
            <cfoutput>
            <h1 class="m-0">Add Relay Recipient(s)
            </h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Add Relay Recipient(s)</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!-- CFML CODE STARTS HERE -->

<cfparam name = "step" default = "0"> 
<cfparam name = "errormessage" default = "0">
<cfparam name = "emptyrecipients" default = "0">
<cfparam name = "emptyemail" default = "0">
<cfparam name = "invalidemail" default = "0">
<cfparam name = "invalidemailrecipient" default = "">
<cfparam name = "alreadyexists" default = "0">
<cfparam name = "alreadyexistsrecipient" default = "">
<cfparam name = "invaliddomain" default = "0">
<cfparam name = "invaliddomainrecipient" default = "">
<cfparam name = "success" default = "0">
<cfparam name = "successrecipient" default = "">
<cfparam name = "djigzonotadded" default = "0">
<cfparam name = "djigzonotaddedrecipient" default = "">



<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif>
</cfif>  

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(url, "action")>
<cfif url.action is not "">
<cfset action = url.action>
</cfif>
</cfif> 

<cfparam name = "show_recipient" default = ""> 
<cfif StructKeyExists(form, "recipient")>
<cfif form.recipient is not "">
<cfset show_recipient = #LCase(FORM.recipient)#>
</cfif>
</cfif>

<!--- VALIDATE PARAMETERS BELOW --->

<!--- SHOW_POLICY --->
<cfparam name = "show_policy" default = ""> 

<cfif StructKeyExists(form, "policy")>

<cfif form.policy is not "">

<cfquery name="checkpolicy" datasource="hermes">
select id from policy where id = <cfqueryparam value = #form.policy# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkpolicy.recordcount# LT 1>

<cfset m="Add Relay Recipients: checkpolicy.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset show_policy = #form.policy#>

<!--- /CFIF #checkpolicy.recordcount# --->
</cfif>

<!--- /CFIF form.policy is not "" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "policy")--->
</cfif>

<!--- SHOW_REPORTS (Quarantine Notifications: YES or NO) --->
<cfparam name = "show_reports" default = "">

<cfif StructKeyExists(form, "reports")>
<cfif ListFindNoCase("YES,NO", form.reports)>
<cfset show_reports = form.reports>
<cfelse>
<cfset m="Add Internal Recipients: form.reports is not YES or NO">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>
</cfif>




<!--- SHOW_TRAIN_BAYES --->
<cfparam name = "show_train_bayes" default = ""> 

<cfif StructKeyExists(form, "train_bayes")>

<cfif #form.train_bayes# is "0" OR #form.train_bayes# is "1">

<cfset show_train_bayes = #form.train_bayes#>

<cfelse>

<cfset m="Add Relay Recipients: form.train_bayes is not 0 or 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.train_bayes# is not "0" OR #form.train_bayes# is not "1" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "train_bayes") --->
</cfif>

<!--- SHOW_DOWNLOAD_MSG --->
<cfparam name = "show_download_msg" default = ""> 

<cfif StructKeyExists(form, "download_msg")>

<cfif #form.download_msg# is "0" OR #form.download_msg# is "1">

<cfset show_download_msg = #form.download_msg#>

<cfelse>

<cfset m="Add Relay Recipients: form.download_msg is not 0 or 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.download_msg# is not "0" OR #form.download_msg# is not "1" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "download_msg") --->
</cfif>

<!--- SHOW_PDF_ENABLED --->
<cfparam name = "show_pdf_enabled" default = ""> 

<cfif StructKeyExists(form, "pdf_enabled")>

<cfif #form.pdf_enabled# is "1" OR #form.pdf_enabled# is "2">

  <cfset show_pdf_enabled = #form.pdf_enabled#>

<cfelse>

<cfset m="Add Relay Recipients: form.pdf_enabled is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.pdf_enabled# is not "1" OR #form.pdf_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pdf_enabled") --->
</cfif>

<!--- SHOW_SMIME_ENABLED --->
<cfparam name = "show_smime_enabled" default = ""> 

<cfif StructKeyExists(form, "smime_enabled")>

<cfif #form.smime_enabled# is "1" OR #form.smime_enabled# is "2">

  <cfset show_smime_enabled = #form.smime_enabled#>

<cfelse>

<cfset m="Add Relay Recipients: form.smime_enabled is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>  

<!--- #form.smime_enabled# is not "1" OR #form.smime_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "smime_enabled") --->
</cfif>

<!--- SHOW_SIGN --->
<cfparam name = "show_sign" default = ""> 

<cfif StructKeyExists(form, "sign")>

<cfif #form.sign# is "1" OR #form.sign# is "2">

  <cfset show_sign = #form.sign#>

<cfelse>

<cfset m="Add Relay Recipients: form.sign is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.sign# is not "1" OR #form.sign# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "sign") --->
</cfif>

<!--- SHOW_PGP_ENABLED --->
<cfparam name = "show_pgp_enabled" default = ""> 

<cfif StructKeyExists(form, "pgp_enabled")>

<cfif #form.pgp_enabled# is "1" OR #form.pgp_enabled# is "2">

<cfset show_pgp_enabled = #form.pgp_enabled#>

<cfelse>

<cfset m="Add Relay Recipients: form.pgp_enabled is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.pgp_enabled# is not "1" OR #form.pgp_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pgp_enabled") --->
</cfif>

<!--- SHOW_CA (S/MIME Certificate Authority) --->
<cfparam name = "show_ca" default = "">

<cfif StructKeyExists(form, "ca")>
<cfif form.ca is not "">
<cfquery name="checkca" datasource="hermes">
  SELECT id FROM ca_settings WHERE id = <cfqueryparam value="#form.ca#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif checkca.recordcount LT 1>
<cfset m="Add Relay Recipients: invalid CA">
<cfinclude template="./inc/error.cfm">
<cfabort>
<cfelse>
<cfset show_ca = form.ca>
</cfif>
</cfif>
</cfif>

<!--- SHOW_VALIDITY (S/MIME Certificate Validity) --->
<cfparam name = "show_validity" default = "1825">

<cfif StructKeyExists(form, "validity")>
<cfif NOT ListFind("365,730,1095,1460,1825", form.validity)>
<cfset m="Add Relay Recipients: invalid validity period">
<cfinclude template="./inc/error.cfm">
<cfabort>
<cfelse>
<cfset show_validity = form.validity>
</cfif>
</cfif>

<!--- SHOW_CERT_ENCRYPTION (S/MIME Key Length) --->
<cfparam name = "show_cert_encryption" default = "2048">

<cfif StructKeyExists(form, "cert_encryption")>
<cfif form.cert_encryption NEQ "2048" AND form.cert_encryption NEQ "4096">
<cfset m="Add Relay Recipients: invalid certificate key length">
<cfinclude template="./inc/error.cfm">
<cfabort>
<cfelse>
<cfset show_cert_encryption = form.cert_encryption>
</cfif>
</cfif>

<!--- SHOW_CERT_ALGORITHM (S/MIME Hash Algorithm) --->
<cfparam name = "show_cert_algorithm" default = "sha256">

<cfif StructKeyExists(form, "cert_algorithm")>
<cfif NOT ListFind("sha256,sha512", form.cert_algorithm)>
<cfset m="Add Relay Recipients: invalid certificate hash algorithm">
<cfinclude template="./inc/error.cfm">
<cfabort>
<cfelse>
<cfset show_cert_algorithm = form.cert_algorithm>
</cfif>
</cfif>

<!--- SHOW_PGP_ENCRYPTION (PGP Key Size) --->
<cfparam name = "show_pgp_encryption" default = "2048">

<cfif StructKeyExists(form, "pgp_encryption")>
<cfif form.pgp_encryption NEQ "2048" AND form.pgp_encryption NEQ "4096">
<cfset m="Add Relay Recipients: invalid PGP key size">
<cfinclude template="./inc/error.cfm">
<cfabort>
<cfelse>
<cfset show_pgp_encryption = form.pgp_encryption>
</cfif>
</cfif>

<!--- SHOW_AUTH_TYPE --->
<cfparam name="show_auth_type" default="local">

<cfif StructKeyExists(form, "auth_type")>
<cfif form.auth_type EQ "local" OR form.auth_type EQ "remote">
<cfset show_auth_type = form.auth_type>
<cfelse>
<cfset m="Add Relay Recipients: form.auth_type is not local or remote">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>
</cfif>

<!--- SHOW_REMOTEAUTH_DOMAIN --->
<cfparam name="show_remoteauth_domain" default="">

<cfif StructKeyExists(form, "remoteauth_domain")>
<cfif form.remoteauth_domain is not "">
<cfquery name="checkRemoteauthDomain" datasource="hermes">
    SELECT id FROM remoteauth_mappings
    WHERE domain_name = <cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar">
    AND enabled = 1
</cfquery>
<cfif checkRemoteauthDomain.recordcount LT 1>
<cfset m="Add Relay Recipients: invalid RemoteAuth domain">
<cfinclude template="./inc/error.cfm">
<cfabort>
<cfelse>
<cfset show_remoteauth_domain = form.remoteauth_domain>
</cfif>
</cfif>
</cfif>

<!--- VALIDATE: If auth_type is remote, remoteauth_domain is required --->
<cfif show_auth_type EQ "remote" AND show_remoteauth_domain EQ "">
<cfset m="Add Relay Recipients: RemoteAuth domain is required when auth type is Remote">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>

<!--- VALIDATE PARAMETERS ABOVE --->

<!--- CHECK IF REMOTEAUTH IS AVAILABLE (Pro edition + enabled + has compatible mappings) --->
<cfset remoteauthAvailable = false>
<cfset remoteauthDomains = []>
<cfset remoteauthDisabledReason = "">
<cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">

<cfif isPro>
    <!--- Check if remoteauth is enabled --->
    <cfquery name="getRemoteauthStatus" datasource="hermes">
        SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'enabled'
    </cfquery>
    <!--- Get compatible domains (exclude patterns with {firstname} or {lastname}) --->
    <cfquery name="getRemoteauthDomains" datasource="hermes">
        SELECT domain_name, server_address, remote_dn_pattern FROM remoteauth_mappings
        WHERE enabled = 1
        AND remote_dn_pattern NOT LIKE '%{firstname}%'
        AND remote_dn_pattern NOT LIKE '%{lastname}%'
        ORDER BY domain_name
    </cfquery>

    <cfif getRemoteauthStatus.recordcount EQ 0 OR getRemoteauthStatus.setting_value NEQ "1">
        <cfset remoteauthDisabledReason = "RemoteAuth is not enabled. Enable it in <a href='view_remoteauth.cfm'>Remote Authentication</a> settings.">
    <cfelseif getRemoteauthDomains.recordcount EQ 0>
        <cfset remoteauthDisabledReason = "No compatible domain mappings found. Add a domain mapping with a <code>{username}</code> or <code>{email}</code> DN pattern in <a href='view_remoteauth.cfm'>Remote Authentication</a>.">
    <cfelse>
        <cfset remoteauthAvailable = true>
        <cfloop query="getRemoteauthDomains">
            <cfset arrayAppend(remoteauthDomains, {domain: getRemoteauthDomains.domain_name, server: getRemoteauthDomains.server_address, pattern: getRemoteauthDomains.remote_dn_pattern})>
        </cfloop>
    </cfif>
</cfif>

<cfif #action# is "add">

<cfif #show_recipient# is "">
<cfset emptyrecipients=1>
<cfelse>
<cfinclude template="./inc/add_internal_recipients_manual.cfm">
</cfif> 


<!---
<cfinclude template="./inc/add_internal_recipients_djigzo.cfm">
--->

  <!--- /CFIF #action# --->
</cfif>

<!-- ERROR MESSAGES STARTS HERE -->

<cfif #emptyrecipients# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Recipient(s) field cannot be blank</cfoutput>
  </div>

</cfif>


<cfif #success# GTE "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The following #success# Recipients were added successfully:</cfoutput><br>
    <cfoutput>#successrecipient#</cfoutput>
  </div>
</cfif>
 

<cfif #errormessage# is "2">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>Errors were encountered while adding recipients. Please see below</cfoutput>
    </div>

</cfif>



<cfif #emptyemail# is not "0">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
      <cfoutput>There were #emptyemail# blank recipient(s)</cfoutput>
    </div>

</cfif>

<cfif #invalidemail# is not "0">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
      <cfoutput>The following #invalidemail# entries had invalid e-mail address(es):</cfoutput><br>
      <cfoutput>#invalidemailrecipient#</cfoutput>
    </div>

</cfif>

<cfif #alreadyexists# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #alreadyexists# recipient(s) already existed:</cfoutput><br>
    <cfoutput>#alreadyexistsrecipient#</cfoutput>
  </div>

</cfif>

<cfif #invaliddomain# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #invaliddomain# recipient(s) entries had domains the system does not relay:</cfoutput><br>
    <cfoutput>#invaliddomainrecipient#</cfoutput>
  </div>

</cfif>



<cfif #djigzonotadded# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #djigzonotadded# recipient(s) entries had problems setting encryption:</cfoutput><br>
    <cfoutput>#djigzonotaddedrecipient#</cfoutput>
  </div>

</cfif>


<!-- ERROR MESSAGES ENDS HERE -->

<span>
  <p>       

<!--- BACK TO RECIPIENTS BUTTON STARTS HERE --->
<a href="view_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Relay Recipients</a>

<!--- BACK TO RECIPIENTS BUTTON ENDS HERE --->





</p>


</span>


<!-- ADD RECIPIENT FORM STARTS HERE -->


<!-- form start -->

  <form name="add_internal_recipients.cfm" method="post" action="">
  <input type="hidden" name="action" value="add">
    <div class="box-body">
       
      <cfoutput>
        <div class="form-horizontal">
          <label for="recipients"><strong>Recipient(s)</strong></label>
          <div class="form-group">
              
                
                  <textarea class="form-control" name="recipient" rows="10" placeholder="Enter recipient e-mail address(es) each in its own line" required></textarea>
                  <div class="alert alert-warning mt-2">
                    <h5><i class="icon fas fa-clock"></i> Bulk Add Performance Notice</h5>
                    <p class="mb-1">Adding recipients requires creating LDAP accounts and configuring encryption settings for each entry. Large batches may take several minutes to process (e.g., 25 recipients takes under 6 minutes). Please wait for the loading indicator to finish and do not close or navigate away from the page until the operation completes.</p>
                    <p class="mb-0"><strong>Tip:</strong> Ensure you have checked the <strong>"Remember me"</strong> checkbox on the login screen before attempting large batch operations to prevent session timeout.</p>
                  </div>
          </div>

           <!--- RECIPIENT POLICY STARTS HERE --->

          <cfquery name="getdefaultpolicy" datasource="hermes">
            select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
            </cfquery>

          <cfquery name="getuserpolicies" datasource="hermes">
            select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'#getdefaultpolicy.policy_id#' order by policy_name asc
            </cfquery>

<cfif #getuserpolicies.recordcount# LT 1>



            <div class="form-group">
                <label><strong>SVF Policy to Assign</strong></label>
                <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                        style="width: 100%;">
                  <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                    </select>

                  <cfelseif #getuserpolicies.recordcount# GTE 1>
                    <div class="form-group">
                      <label><strong>SVF Policy to Assign</strong></label>
                      <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                              style="width: 100%;">
                        <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                        <cfoutput query="getuserpolicies">
                          <option value="#policy_id#">#policy_name#</option>
                        
                          </cfoutput>
                          </select>
      <!--- /CFIF #getuserpolicies.recordcount# --->
                        </cfif>

                       
      </div>
      </cfoutput>

       <!--- RECIPIENT POLICY ENDS HERE --->



 <!--- QUARANTINE NOTIFICATIONS STARTS HERE --->

 <div class="form-group">
  <label><strong>Quarantine Notifications</strong></label>
  <p class="help-block">When enabled, users receive an email notification each time a message is quarantined, with a one-click release button.</p>
<select class="form-control" name="reports" style="width: 100%">
<option value="YES" selected="selected">Enabled</option>
<option value="NO">Disabled</option>
</select>
</div>

  <!--- QUARANTINE NOTIFICATIONS ENDS HERE --->

<!--- TRAIN BAYES STARTS HERE --->

<div class="form-group">
  <label><strong>Train Bayes Filter from User Portal</strong></label>

  <div class="alert alert-danger">
    <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
    <p>Ensure you do <strong>NOT</strong> enable for inexperienced recipients. Improperly training Bayes Filter will affect ALL recipients</p>
    </div>

<select class="form-control" name="train_bayes" data-placeholder="train_bayes" style="width: 100%">                  
<option value="0" selected="selected">Disable</option>
<option value="1">Enable</option>


</select> 
</div>


<!--- TRAIN BAYES AND DOWNLOAD MESSAGES  ENDS HERE --->

<!--- DOWNLOAD MESSAGES STARTS HERE --->

<div class="form-group">

  <label><strong>Download Messages from User Portal</strong></label>
  <div class="alert alert-danger">
  <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
  <p>Enabling can expose recipients to malware</p>
  </div>
<select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">                  
<option value="0" selected="selected">Disable</option>
<option value="1">Enable</option>


</select> 
</div>


<!--- DOWNLOAD MESSAGES  ENDS HERE --->

<!--- AUTHENTICATION TYPE (Pro Edition + RemoteAuth Only) STARTS HERE --->
<cfif remoteauthAvailable>

<div class="form-group">
  <label><strong>Authentication Type</strong></label>
  <div class="alert alert-info">
    <h5><i class="icon fas fa-info-circle"></i> Remote Authentication</h5>
    <p class="mb-0">Select <strong>Remote</strong> to authenticate recipients against an external AD/LDAP server. Recipients will use their existing organization credentials - no local password will be created.</p>
  </div>
  <select class="form-control" name="auth_type" id="authType" style="width: 100%;">
    <option value="local" selected>Local</option>
    <option value="remote">Remote</option>
  </select>
</div>

<!--- RemoteAuth Domain Selection (shown when Remote is selected) --->
<div class="form-group mt-3" id="remoteauthDomainGroup" style="display:none;">
  <label><strong>RemoteAuth Domain</strong></label>
  <select class="form-control" name="remoteauth_domain" id="remoteauthDomain" style="width: 100%;">
    <option value="">-- Select Domain --</option>
    <cfloop array="#remoteauthDomains#" index="domainItem">
      <cfoutput>
      <option value="#domainItem.domain#" data-pattern="#HTMLEditFormat(domainItem.pattern)#">#domainItem.domain# (#domainItem.server#)</option>
      </cfoutput>
    </cfloop>
  </select>
  <small class="text-muted">Select the domain recipients will authenticate against</small>
</div>

<!--- DN Pattern Guidance (shown when a domain is selected) --->
<div class="form-group mt-3" id="dnPatternGuidance" style="display:none;">
  <div class="alert alert-secondary">
    <h5><i class="icon fas fa-sitemap"></i> DN Pattern</h5>
    <p>Recipients will be authenticated against the remote server using this DN pattern:</p>
    <p><code id="dnPatternDisplay"></code></p>
    <p class="mb-0"><small><strong>How placeholders are resolved from the recipient's email address:</strong><br>
    For a recipient with email <em>jsmith@example.com</em>:<br>
    <code>{username}</code> &rarr; <em>jsmith</em> (local part extracted automatically) &rarr; DN becomes <code>cn=jsmith,...</code><br>
    <code>{email}</code> &rarr; <em>jsmith@example.com</em> (full address used as-is) &rarr; DN becomes <code>cn=jsmith@example.com,...</code></small></p>
  </div>
</div>

<cfelseif isPro>
<!--- Pro Edition but RemoteAuth not fully configured - show disabled toggle --->
<div class="form-group">
  <label><strong>Authentication Type</strong></label>
  <select class="form-control" name="auth_type" id="authType" style="width: 100%;" disabled>
    <option value="local" selected>Local</option>
    <option value="remote">Remote</option>
  </select>
  <cfoutput><small class="text-muted">#remoteauthDisabledReason#</small></cfoutput>
</div>

<cfelse>
<!--- Community Edition - no toggle --->
<input type="hidden" name="auth_type" value="local">
</cfif>
<!--- AUTHENTICATION TYPE ENDS HERE --->


  <div class="alert alert-info">

    <h5><i class="icon fas fa-info-circle"></i> Please Note!</h5>
    <cfoutput>When S/MIME or PGP Encryption is enabled, certificates and keyrings will be generated in the background after recipients are added. You can monitor progress from the Relay Recipients page.</cfoutput>
  </div>

  <!--- PDF ENCRYPTION STARTS HERE --->

  <div class="form-group">
    <label><strong>PDF Encryption</strong></label>
  <!---
    <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
  <option value="2" selected="selected">Disable</option>
  <option value="1">Enable</option>
 
  
  </select> 
  </div>

  <!--- PDF ENCRYPTION ENDS HERE --->

    <!--- SMIME ENCRYPTION STARTS HERE --->

    <div class="form-group">
      <label><strong>S/MIME Encryption</strong></label>
    <select class="form-control" name="smime_enabled" id="smime_enabled" data-placeholder="smime_enabled" style="width: 100%">
    <option value="2" selected="selected">Disable</option>
    <option value="1">Enable</option>
    </select>
    </div>

    <!--- SMIME OPTIONS (shown when S/MIME enabled) --->
    <cfquery name="getdefaultca" datasource="hermes">
      SELECT id, ca_commonname FROM ca_settings WHERE default2='1'
    </cfquery>
    <cfquery name="getotherca" datasource="hermes">
      SELECT id, ca_commonname FROM ca_settings WHERE id <> '#getdefaultca.id#' ORDER BY ca_commonname ASC
    </cfquery>

    <div id="smime_options" style="display:none;">

      <div class="form-group">
        <label><strong>Certificate Authority</strong></label>
        <select class="form-control select2" name="ca" data-placeholder="Certificate Authority" style="width: 100%;">
          <cfoutput><option value="#getdefaultca.id#" selected="selected">#getdefaultca.ca_commonname#</option></cfoutput>
          <cfoutput query="getotherca">
            <option value="#id#">#ca_commonname#</option>
          </cfoutput>
        </select>
      </div>

      <div class="form-group">
        <label><strong>Certificate Validity Period</strong></label>
        <select class="form-control" name="validity" style="width: 100%;">
          <option value="1825" selected="selected">5 Years</option>
          <option value="1460">4 Years</option>
          <option value="1095">3 Years</option>
          <option value="730">2 Years</option>
          <option value="365">1 Year</option>
        </select>
      </div>

      <div class="form-group">
        <label><strong>Certificate Key Length</strong></label>
        <select class="form-control" name="cert_encryption" style="width: 100%;">
          <option value="2048" selected="selected">2048-bit (Recommended)</option>
          <option value="4096">4096-bit (High Security)</option>
        </select>
      </div>

      <div class="form-group">
        <label><strong>Certificate Hash Algorithm</strong></label>
        <select class="form-control" name="cert_algorithm" style="width: 100%;">
          <option value="sha256" selected="selected">SHA-256 (Recommended)</option>
          <option value="sha512">SHA-512 (High Security)</option>
        </select>
      </div>

    </div>
    <!--- /SMIME OPTIONS --->

    <!--- SMIME ENCRYPTION ENDS HERE --->

    
    <!--- SMIME SIGN STARTS HERE --->

    <div class="form-group">
      <label><strong>S/MIME SIGNATURE</strong></label>
    
      <p class="help-block">Effective only when S/MIME Certificate present</p>
    
    <select class="form-control" name="sign" data-placeholder="sign" style="width: 100%">                  
    <option value="2" selected="selected">Sign Encrypted Messages Only</option>
    <option value="1">Sign all messages</option>
   
    
    </select> 
    </div>
  
    <!--- SMIME SIGN ENDS HERE --->


        <!--- PGP ENCRYPTION STARTS HERE --->

        <div class="form-group">
          <label><strong>PGP Encryption</strong></label>
        <select class="form-control" name="pgp_enabled" id="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">
        <option value="2" selected="selected">Disable</option>
        <option value="1">Enable</option>
        </select>
        </div>

        <!--- PGP OPTIONS (shown when PGP enabled) --->
        <div id="pgp_options" style="display:none;">

          <div class="form-group">
            <label><strong>PGP Key Size</strong></label>
            <select class="form-control" name="pgp_encryption" style="width: 100%;">
              <option value="2048" selected="selected">2048-bit (Recommended)</option>
              <option value="4096">4096-bit (High Security)</option>
            </select>
          </div>

          <div class="alert alert-info">
            <i class="icon fas fa-info-circle"></i>
            The local part of each recipient's e-mail address will be automatically used as the PGP key Real Name (e.g., "jsmith" from "jsmith@example.com").
          </div>

        </div>
        <!--- /PGP OPTIONS --->

        <!--- PGP ENCRYPTION ENDS HERE --->

      <div class="box-footer">
        <!--- <p class="help-block">Help Block Text</p> --->
       
        <!---
              <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
        --->
        
              <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  

            </div>      

  

    
  </form>

  <div>&nbsp;</div>


<!-- ADD RECIPIENT FORM ENDS HERE -->

</div>
</div>

<div id="loader"></div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />



<!-- ./wrapper -->


  

</body>

<!--- SCRIPT TO SHOW/HIDE FORM OPTIONS  --->

<script>

  // Show/hide S/MIME options when S/MIME encryption is toggled
  $('#smime_enabled').on('change', function() {
    if ($(this).val() === '1') {
      $('#smime_options').show();
    } else {
      $('#smime_options').hide();
    }
  });

  // Show/hide PGP options when PGP encryption is toggled
  $('#pgp_enabled').on('change', function() {
    if ($(this).val() === '1') {
      $('#pgp_options').show();
    } else {
      $('#pgp_options').hide();
    }
  });

  // Show/hide RemoteAuth options when auth type is toggled
  $('#authType').on('change', function() {
    if ($(this).val() === 'remote') {
      $('#remoteauthDomainGroup').show();
    } else {
      $('#remoteauthDomainGroup').hide();
      $('#dnPatternGuidance').hide();
      $('#remoteauthDomain').val('');
    }
  });

  // Show DN pattern guidance when a domain is selected
  $('#remoteauthDomain').on('change', function() {
    var selected = $(this).find(':selected');
    var pattern = selected.data('pattern');
    if (pattern) {
      $('#dnPatternDisplay').text(pattern);
      $('#dnPatternGuidance').show();
    } else {
      $('#dnPatternGuidance').hide();
    }
  });

  </script>

<!--- /SCRIPT TO SHOW/HIDE FORM OPTIONS  --->

</html>