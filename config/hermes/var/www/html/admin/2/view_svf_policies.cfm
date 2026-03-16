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
  <title>Hermes SEG | SVF Policies</title>

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
            <h1 class="m-0">SVF Policies</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="#">Content Checks</a></li>
              <li class="breadcrumb-item active">SVF Policies</li>
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
<cfinclude template="./inc/get_svf_policies.cfm">

<!--- ======================== --->
<!--- ACTION: ADD POLICY      --->
<!--- ======================== --->
<cfif action is "add_policy">
  <cfset step = 0>

  <!--- Validate policy name not empty --->
  <cfif NOT StructKeyExists(form, "policy_name") OR trim(form.policy_name) is "">
    <cfset session.m = 30>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate policy name characters --->
  <cfif REFind("[^_a-zA-Z0-9\-@. ]", form.policy_name) GT 0>
    <cfset session.m = 31>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate policy name --->
  <cfquery name="checkDupPolicy" datasource="hermes">
    SELECT COUNT(*) as cnt FROM policy
    WHERE policy_name = <cfqueryparam value="#trim(form.policy_name)#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDupPolicy.cnt GT 0>
    <cfset session.m = 32>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate spam_tag2_level --->
  <cfif NOT StructKeyExists(form, "spam_tag2_level") OR trim(form.spam_tag2_level) is ""
        OR NOT IsValid("float", form.spam_tag2_level)>
    <cfset session.m = 33>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>
  <cfif form.spam_tag2_level GT 999 OR form.spam_tag2_level LT -999>
    <cfset session.m = 34>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate spam_kill_level --->
  <cfif NOT StructKeyExists(form, "spam_kill_level") OR trim(form.spam_kill_level) is ""
        OR NOT IsValid("float", form.spam_kill_level)>
    <cfset session.m = 35>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>
  <cfif form.spam_kill_level GT 999 OR form.spam_kill_level LT -999>
    <cfset session.m = 36>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate banned_rulenames --->
  <cfif NOT StructKeyExists(form, "banned_rulenames") OR trim(form.banned_rulenames) is "">
    <cfset session.m = 37>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Insert into policy table --->
  <cfquery name="insertPolicy" datasource="hermes" result="stResultPolicy">
    INSERT INTO policy
    (policy_name, virus_lover, spam_lover, banned_files_lover, bad_header_lover,
     bypass_virus_checks, bypass_spam_checks, bypass_banned_checks, bypass_header_checks,
     spam_tag_level, spam_tag2_level, spam_kill_level, spam_modifies_subj,
     banned_rulenames, warnbannedrecip, warnvirusrecip, warnbadhrecip)
    VALUES (
      <cfqueryparam value="#trim(form.policy_name)#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.virus_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.spam_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.banned_files_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.bad_header_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.bypass_virus_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.bypass_spam_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.bypass_banned_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.bypass_header_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="-999" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.spam_tag2_level#" cfsqltype="cf_sql_float">,
      <cfqueryparam value="#form.spam_kill_level#" cfsqltype="cf_sql_float">,
      <cfqueryparam value="Y" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.banned_rulenames)#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.warnbannedrecip#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.warnvirusrecip#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.warnbadhrecip#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <!--- Insert into spam_policies table --->
  <cfquery datasource="hermes">
    INSERT INTO spam_policies (policy_id, policy_name, custom, system, default_policy)
    VALUES (
      <cfqueryparam value="#stResultPolicy.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#trim(form.policy_name)#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="1" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="2" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <!--- Update amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfinclude template="./inc/restart_amavis.cfm">
    <cfset session.m = 1>
    <cfcatch type="any">
      <cfset session.m = 40>
    </cfcatch>
  </cftry>
  <cflocation url="view_svf_policies.cfm" addtoken="no">
</cfif>

<!--- ======================== --->
<!--- ACTION: EDIT POLICY     --->
<!--- ======================== --->
<cfif action is "edit_policy">
  <cfif NOT StructKeyExists(form, "edit_policy_id") OR NOT IsNumeric(form.edit_policy_id)>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate policy name not empty --->
  <cfif NOT StructKeyExists(form, "edit_policy_name") OR trim(form.edit_policy_name) is "">
    <cfset session.m = 30>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate policy name characters --->
  <cfif REFind("[^_a-zA-Z0-9\-@. ]", form.edit_policy_name) GT 0>
    <cfset session.m = 31>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate policy name (excluding self) --->
  <cfquery name="checkDupEdit" datasource="hermes">
    SELECT COUNT(*) as cnt FROM policy
    WHERE policy_name = <cfqueryparam value="#trim(form.edit_policy_name)#" cfsqltype="cf_sql_varchar">
      AND id <> <cfqueryparam value="#form.edit_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkDupEdit.cnt GT 0>
    <cfset session.m = 32>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate spam_tag2_level --->
  <cfif NOT StructKeyExists(form, "edit_spam_tag2_level") OR trim(form.edit_spam_tag2_level) is ""
        OR NOT IsValid("float", form.edit_spam_tag2_level)>
    <cfset session.m = 33>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>
  <cfif form.edit_spam_tag2_level GT 999 OR form.edit_spam_tag2_level LT -999>
    <cfset session.m = 34>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate spam_kill_level --->
  <cfif NOT StructKeyExists(form, "edit_spam_kill_level") OR trim(form.edit_spam_kill_level) is ""
        OR NOT IsValid("float", form.edit_spam_kill_level)>
    <cfset session.m = 35>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>
  <cfif form.edit_spam_kill_level GT 999 OR form.edit_spam_kill_level LT -999>
    <cfset session.m = 36>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Validate banned_rulenames --->
  <cfif NOT StructKeyExists(form, "edit_banned_rulenames") OR trim(form.edit_banned_rulenames) is "">
    <cfset session.m = 37>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Update policy table --->
  <cfquery datasource="hermes">
    UPDATE policy SET
      policy_name = <cfqueryparam value="#trim(form.edit_policy_name)#" cfsqltype="cf_sql_varchar">,
      virus_lover = <cfqueryparam value="#form.edit_virus_lover#" cfsqltype="cf_sql_varchar">,
      spam_lover = <cfqueryparam value="#form.edit_spam_lover#" cfsqltype="cf_sql_varchar">,
      banned_files_lover = <cfqueryparam value="#form.edit_banned_files_lover#" cfsqltype="cf_sql_varchar">,
      bad_header_lover = <cfqueryparam value="#form.edit_bad_header_lover#" cfsqltype="cf_sql_varchar">,
      bypass_virus_checks = <cfqueryparam value="#form.edit_bypass_virus_checks#" cfsqltype="cf_sql_varchar">,
      bypass_spam_checks = <cfqueryparam value="#form.edit_bypass_spam_checks#" cfsqltype="cf_sql_varchar">,
      bypass_banned_checks = <cfqueryparam value="#form.edit_bypass_banned_checks#" cfsqltype="cf_sql_varchar">,
      bypass_header_checks = <cfqueryparam value="#form.edit_bypass_header_checks#" cfsqltype="cf_sql_varchar">,
      spam_tag2_level = <cfqueryparam value="#form.edit_spam_tag2_level#" cfsqltype="cf_sql_float">,
      spam_kill_level = <cfqueryparam value="#form.edit_spam_kill_level#" cfsqltype="cf_sql_float">,
      banned_rulenames = <cfqueryparam value="#trim(form.edit_banned_rulenames)#" cfsqltype="cf_sql_varchar">,
      warnbannedrecip = <cfqueryparam value="#form.edit_warnbannedrecip#" cfsqltype="cf_sql_varchar">,
      warnvirusrecip = <cfqueryparam value="#form.edit_warnvirusrecip#" cfsqltype="cf_sql_varchar">,
      warnbadhrecip = <cfqueryparam value="#form.edit_warnbadhrecip#" cfsqltype="cf_sql_varchar">
    WHERE id = <cfqueryparam value="#form.edit_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Update spam_policies table --->
  <cfquery datasource="hermes">
    UPDATE spam_policies SET
      policy_name = <cfqueryparam value="#trim(form.edit_policy_name)#" cfsqltype="cf_sql_varchar">
    WHERE policy_id = <cfqueryparam value="#form.edit_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Handle default policy --->
  <cfif StructKeyExists(form, "edit_default_policy") AND form.edit_default_policy is "1">
    <cfquery datasource="hermes">
      UPDATE spam_policies SET default_policy = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_policies SET default_policy = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
      WHERE policy_id = <cfqueryparam value="#form.edit_policy_id#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfif>

  <!--- Update amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfinclude template="./inc/restart_amavis.cfm">
    <cfset session.m = 2>
    <cfcatch type="any">
      <cfset session.m = 40>
    </cfcatch>
  </cftry>
  <cflocation url="view_svf_policies.cfm" addtoken="no">
</cfif>

<!--- ======================== --->
<!--- ACTION: COPY POLICY     --->
<!--- ======================== --->
<cfif action is "copy_policy">
  <cfif NOT StructKeyExists(form, "copy_policy_id") OR NOT IsNumeric(form.copy_policy_id)>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Get the source policy --->
  <cfquery name="getSourcePolicy" datasource="hermes">
    SELECT * FROM policy WHERE id = <cfqueryparam value="#form.copy_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif getSourcePolicy.recordcount LT 1>
    <cfset session.m = 38>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Generate a unique copy name --->
  <cfset copyName = "Copy of " & getSourcePolicy.policy_name>
  <cfquery name="checkCopyName" datasource="hermes">
    SELECT COUNT(*) as cnt FROM policy
    WHERE policy_name = <cfqueryparam value="#copyName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkCopyName.cnt GT 0>
    <cfset copyName = copyName & " " & DateFormat(Now(), "yyyymmdd") & TimeFormat(Now(), "HHmmss")>
  </cfif>

  <!--- Insert copy into policy table --->
  <cfquery name="insertCopy" datasource="hermes" result="stResultCopy">
    INSERT INTO policy
    (policy_name, virus_lover, spam_lover, banned_files_lover, bad_header_lover,
     bypass_virus_checks, bypass_spam_checks, bypass_banned_checks, bypass_header_checks,
     spam_tag_level, spam_tag2_level, spam_kill_level, spam_modifies_subj,
     banned_rulenames, warnbannedrecip, warnvirusrecip, warnbadhrecip)
    VALUES (
      <cfqueryparam value="#copyName#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.virus_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.spam_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.banned_files_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.bad_header_lover#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.bypass_virus_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.bypass_spam_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.bypass_banned_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.bypass_header_checks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.spam_tag_level#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.spam_tag2_level#" cfsqltype="cf_sql_float">,
      <cfqueryparam value="#getSourcePolicy.spam_kill_level#" cfsqltype="cf_sql_float">,
      <cfqueryparam value="#getSourcePolicy.spam_modifies_subj#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.banned_rulenames#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.warnbannedrecip#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.warnvirusrecip#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#getSourcePolicy.warnbadhrecip#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <!--- Insert into spam_policies --->
  <cfquery datasource="hermes">
    INSERT INTO spam_policies (policy_id, policy_name, custom, system, default_policy)
    VALUES (
      <cfqueryparam value="#stResultCopy.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#copyName#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="1" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="2" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <cfset session.m = 5>
  <cflocation url="view_svf_policies.cfm" addtoken="no">
</cfif>

<!--- ======================== --->
<!--- ACTION: DELETE POLICY   --->
<!--- ======================== --->
<cfif action is "delete_policy">
  <cfif NOT StructKeyExists(form, "delete_policy_id") OR NOT IsNumeric(form.delete_policy_id)>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Cannot delete system policies --->
  <cfquery name="checkSystem" datasource="hermes">
    SELECT COUNT(*) as cnt FROM spam_policies
    WHERE policy_id = <cfqueryparam value="#form.delete_policy_id#" cfsqltype="cf_sql_integer">
      AND system = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkSystem.cnt GT 0>
    <cfset session.m = 10>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Cannot delete default policy --->
  <cfquery name="checkDefault" datasource="hermes">
    SELECT COUNT(*) as cnt FROM spam_policies
    WHERE policy_id = <cfqueryparam value="#form.delete_policy_id#" cfsqltype="cf_sql_integer">
      AND default_policy = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDefault.cnt GT 0>
    <cfset session.m = 11>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Cannot delete policy assigned to recipients --->
  <cfquery name="checkAssigned" datasource="hermes">
    SELECT COUNT(*) as cnt FROM recipients
    WHERE policy_id = <cfqueryparam value="#form.delete_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkAssigned.cnt GT 0>
    <cfset session.m = 12>
    <cflocation url="view_svf_policies.cfm" addtoken="no">
  </cfif>

  <!--- Delete from spam_policies --->
  <cfquery datasource="hermes">
    DELETE FROM spam_policies
    WHERE policy_id = <cfqueryparam value="#form.delete_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Delete from policy --->
  <cfquery datasource="hermes">
    DELETE FROM policy
    WHERE id = <cfqueryparam value="#form.delete_policy_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Update amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfinclude template="./inc/restart_amavis.cfm">
    <cfset session.m = 3>
    <cfcatch type="any">
      <cfset session.m = 40>
    </cfcatch>
  </cftry>
  <cflocation url="view_svf_policies.cfm" addtoken="no">
</cfif>

<!--- ======================== --->
<!--- ACTION: BULK DELETE     --->
<!--- ======================== --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfset bulkErrors = "">
    <cfset bulkDeleted = 0>
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <!--- Check system policy --->
        <cfquery name="chkSys" datasource="hermes">
          SELECT COUNT(*) as cnt FROM spam_policies
          WHERE policy_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
            AND system = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif chkSys.cnt GT 0><cfcontinue></cfif>

        <!--- Check default policy --->
        <cfquery name="chkDef" datasource="hermes">
          SELECT COUNT(*) as cnt FROM spam_policies
          WHERE policy_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
            AND default_policy = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif chkDef.cnt GT 0><cfcontinue></cfif>

        <!--- Check assigned recipients --->
        <cfquery name="chkAssign" datasource="hermes">
          SELECT COUNT(*) as cnt FROM recipients
          WHERE policy_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif chkAssign.cnt GT 0><cfcontinue></cfif>

        <cfquery datasource="hermes">
          DELETE FROM spam_policies
          WHERE policy_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfquery datasource="hermes">
          DELETE FROM policy
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset bulkDeleted = bulkDeleted + 1>
      </cfif>
    </cfloop>

    <cfif bulkDeleted GT 0>
      <cftry>
        <cfinclude template="./inc/update_amavis_config_files.cfm">
        <cfinclude template="./inc/restart_amavis.cfm">
        <cfset session.m = 3>
        <cfcatch type="any">
          <cfset session.m = 40>
        </cfcatch>
      </cftry>
    <cfelse>
      <cfset session.m = 13>
    </cfif>
  </cfif>
  <cflocation url="view_svf_policies.cfm" addtoken="no">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_svf_policies.cfm">
<cfset session.m = "">

<!--- ======================== --->
<!--- ALERTS                  --->
<!--- ======================== --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Policy Added</h4>
    <p>Policy created successfully. Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Policy Updated</h4>
    <p>Policy updated successfully. Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Policy Deleted</h4>
    <p>Policy deleted successfully. Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Policy Copied</h4>
    <p>Policy copied successfully. Edit the new policy to customize it, then assign relay recipients.</p>
  </div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>System policies cannot be deleted.</p>
  </div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The default policy cannot be deleted. Set another policy as the default first.</p>
  </div>
</cfif>
<cfif m is 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>This policy is assigned to relay recipients. Assign them to a different policy first.</p>
  </div>
</cfif>
<cfif m is 13>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Warning</h4>
    <p>No policies were deleted. System, default, and assigned policies are protected.</p>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Policy name is required.</p>
  </div>
</cfif>
<cfif m is 31>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Policy name may only contain letters, numbers, spaces, underscores, hyphens, @ symbols, and periods.</p>
  </div>
</cfif>
<cfif m is 32>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>A policy with that name already exists.</p>
  </div>
</cfif>
<cfif m is 33>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Spam Tag Score is required and must be a valid number.</p>
  </div>
</cfif>
<cfif m is 34>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Spam Tag Score must be between -999 and 999.</p>
  </div>
</cfif>
<cfif m is 35>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Spam Quarantine Score is required and must be a valid number.</p>
  </div>
</cfif>
<cfif m is 36>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Spam Quarantine Score must be between -999 and 999.</p>
  </div>
</cfif>
<cfif m is 37>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>A file rule must be selected.</p>
  </div>
</cfif>
<cfif m is 38>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Source policy not found.</p>
  </div>
</cfif>
<cfif m is 40>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Apply Failed</h4>
    <p>Policy was saved but Amavis configuration update or reload failed.</p>
  </div>
</cfif>

<!--- ============================================ --->
<!--- ADD POLICY FORM                              --->
<!--- ============================================ --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add SVF Policy</h3>
    <div class="card-tools">
      <button type="button" class="btn btn-tool" data-bs-toggle="collapse" data-bs-target="#addPolicyCollapse" aria-expanded="false">
        <i class="fas fa-minus"></i>
      </button>
    </div>
  </div>
  <div class="collapse" id="addPolicyCollapse">
    <div class="card-body">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="add_policy">

        <div class="row mb-3">
          <div class="col-md-4">
            <label for="policy_name" class="form-label"><strong>Policy Name</strong></label>
            <input type="text" class="form-control" id="policy_name" name="policy_name" maxlength="32" required
              placeholder="e.g. Custom Strict Policy">
          </div>
          <div class="col-md-4">
            <label for="spam_tag2_level" class="form-label"><strong>Spam Tag Score</strong></label>
            <input type="number" class="form-control" id="spam_tag2_level" name="spam_tag2_level" step="0.01" min="-999" max="999" value="6.31" required>
            <small class="text-muted">Score at which spam header is added (-999 to 999)</small>
          </div>
          <div class="col-md-4">
            <label for="spam_kill_level" class="form-label"><strong>Spam Quarantine Score</strong></label>
            <input type="number" class="form-control" id="spam_kill_level" name="spam_kill_level" step="0.01" min="-999" max="999" value="6.31" required>
            <small class="text-muted">Score at which spam is quarantined (-999 to 999)</small>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col-md-4">
            <label for="banned_rulenames" class="form-label"><strong>File Rule</strong></label>
            <select class="form-select" id="banned_rulenames" name="banned_rulenames" required>
              <cfoutput query="get_file_rules">
                <option value="#encodeForHTML(rule_name)#">#encodeForHTML(rule_name)#</option>
              </cfoutput>
            </select>
          </div>
        </div>

        <hr>
        <h6 class="mb-3"><strong>Accept Settings</strong></h6>
        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label"><strong>Accept Viruses</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="virus_lover" id="virus_lover_y" value="Y">
                <label class="form-check-label" for="virus_lover_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="virus_lover" id="virus_lover_n" value="N" checked>
                <label class="form-check-label" for="virus_lover_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label"><strong>Accept Spam</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="spam_lover" id="spam_lover_y" value="Y">
                <label class="form-check-label" for="spam_lover_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="spam_lover" id="spam_lover_n" value="N" checked>
                <label class="form-check-label" for="spam_lover_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label"><strong>Accept Banned Files</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="banned_files_lover" id="banned_files_lover_y" value="Y">
                <label class="form-check-label" for="banned_files_lover_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="banned_files_lover" id="banned_files_lover_n" value="N" checked>
                <label class="form-check-label" for="banned_files_lover_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label"><strong>Accept Bad Headers</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bad_header_lover" id="bad_header_lover_y" value="Y">
                <label class="form-check-label" for="bad_header_lover_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bad_header_lover" id="bad_header_lover_n" value="N" checked>
                <label class="form-check-label" for="bad_header_lover_n">No</label>
              </div>
            </div>
          </div>
        </div>

        <h6 class="mb-3"><strong>Bypass Checks</strong></h6>
        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label"><strong>Bypass Virus Checks</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_virus_checks" id="bypass_virus_y" value="Y">
                <label class="form-check-label" for="bypass_virus_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_virus_checks" id="bypass_virus_n" value="N" checked>
                <label class="form-check-label" for="bypass_virus_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label"><strong>Bypass Spam Checks</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_spam_checks" id="bypass_spam_y" value="Y">
                <label class="form-check-label" for="bypass_spam_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_spam_checks" id="bypass_spam_n" value="N" checked>
                <label class="form-check-label" for="bypass_spam_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label"><strong>Bypass Banned File Checks</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_banned_checks" id="bypass_banned_y" value="Y">
                <label class="form-check-label" for="bypass_banned_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_banned_checks" id="bypass_banned_n" value="N" checked>
                <label class="form-check-label" for="bypass_banned_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <label class="form-label"><strong>Bypass Header Checks</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_header_checks" id="bypass_header_y" value="Y">
                <label class="form-check-label" for="bypass_header_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="bypass_header_checks" id="bypass_header_n" value="N" checked>
                <label class="form-check-label" for="bypass_header_n">No</label>
              </div>
            </div>
          </div>
        </div>

        <h6 class="mb-3"><strong>Notifications</strong></h6>
        <div class="row mb-3">
          <div class="col-md-4">
            <label class="form-label"><strong>Notify Recipient on Banned File</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="warnbannedrecip" id="warnbanned_y" value="Y">
                <label class="form-check-label" for="warnbanned_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="warnbannedrecip" id="warnbanned_n" value="N" checked>
                <label class="form-check-label" for="warnbanned_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <label class="form-label"><strong>Notify Recipient on Virus</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="warnvirusrecip" id="warnvirus_y" value="Y">
                <label class="form-check-label" for="warnvirus_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="warnvirusrecip" id="warnvirus_n" value="N" checked>
                <label class="form-check-label" for="warnvirus_n">No</label>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <label class="form-label"><strong>Notify Recipient on Bad Header</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="warnbadhrecip" id="warnbadh_y" value="Y">
                <label class="form-check-label" for="warnbadh_y">Yes</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="warnbadhrecip" id="warnbadh_n" value="N" checked>
                <label class="form-check-label" for="warnbadh_n">No</label>
              </div>
            </div>
          </div>
        </div>

        <div class="mt-3">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Policy
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ============================================ --->
<!--- POLICIES TABLE                               --->
<!--- ============================================ --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> SVF Policies</h3>
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

      <table id="policiesTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 3%"><input type="checkbox" id="selectAll"></th>
            <th>Policy Name</th>
            <th style="width: 8%">System</th>
            <th style="width: 8%">Default</th>
            <th style="width: 10%">Spam Tag</th>
            <th style="width: 10%">Spam Quarantine</th>
            <th style="width: 12%">File Rule</th>
            <th style="width: 18%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_all_policies">
            <tr>
              <td>
                <cfif system is "1">
                  <input type="checkbox" class="row-checkbox" value="#policy_id#" disabled title="System policies cannot be deleted">
                <cfelse>
                  <input type="checkbox" class="row-checkbox" value="#policy_id#">
                </cfif>
              </td>
              <td>#encodeForHTML(policy_name)#</td>
              <td class="text-center">
                <cfif system is "1">
                  <span class="badge bg-info">Yes</span>
                <cfelse>
                  <span class="badge bg-secondary">No</span>
                </cfif>
              </td>
              <td class="text-center">
                <cfif default_policy is "1">
                  <span class="badge bg-success">Yes</span>
                <cfelse>
                  <span class="badge bg-secondary">No</span>
                </cfif>
              </td>
              <td class="text-center">#NumberFormat(spam_tag2_level, '____.__')#</td>
              <td class="text-center">#NumberFormat(spam_kill_level, '____.__')#</td>
              <td>#encodeForHTML(banned_rulenames)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" title="Edit Policy"
                  onclick="openEditModal(
                    '#policy_id#',
                    '#encodeForJavaScript(policy_name)#',
                    '#encodeForJavaScript(virus_lover)#',
                    '#encodeForJavaScript(spam_lover)#',
                    '#encodeForJavaScript(banned_files_lover)#',
                    '#encodeForJavaScript(bad_header_lover)#',
                    '#encodeForJavaScript(bypass_virus_checks)#',
                    '#encodeForJavaScript(bypass_spam_checks)#',
                    '#encodeForJavaScript(bypass_banned_checks)#',
                    '#encodeForJavaScript(bypass_header_checks)#',
                    '#spam_tag2_level#',
                    '#spam_kill_level#',
                    '#encodeForJavaScript(banned_rulenames)#',
                    '#encodeForJavaScript(warnbannedrecip)#',
                    '#encodeForJavaScript(warnvirusrecip)#',
                    '#encodeForJavaScript(warnbadhrecip)#',
                    '#default_policy#',
                    '#system#'
                  );">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-success" title="Copy Policy"
                  onclick="copyPolicy('#policy_id#', '#encodeForJavaScript(policy_name)#');">
                  <i class="fas fa-copy"></i>
                </button>
                <cfif system is not "1">
                  <button type="button" class="btn btn-sm btn-danger" title="Delete Policy"
                    onclick="deletePolicy('#policy_id#', '#encodeForJavaScript(policy_name)#');">
                    <i class="fas fa-trash"></i>
                  </button>
                </cfif>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    </form>
  </div>
</div>

<!--- ============================================ --->
<!--- EDIT MODAL                                   --->
<!--- ============================================ --->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_policy">
        <input type="hidden" name="edit_policy_id" id="edit_policy_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit SVF Policy</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-3">
            <div class="col-md-4">
              <label for="edit_policy_name" class="form-label"><strong>Policy Name</strong></label>
              <input type="text" class="form-control" id="edit_policy_name" name="edit_policy_name" maxlength="32" required>
            </div>
            <div class="col-md-4">
              <label for="edit_spam_tag2_level" class="form-label"><strong>Spam Tag Score</strong></label>
              <input type="number" class="form-control" id="edit_spam_tag2_level" name="edit_spam_tag2_level" step="0.01" min="-999" max="999" required>
            </div>
            <div class="col-md-4">
              <label for="edit_spam_kill_level" class="form-label"><strong>Spam Quarantine Score</strong></label>
              <input type="number" class="form-control" id="edit_spam_kill_level" name="edit_spam_kill_level" step="0.01" min="-999" max="999" required>
            </div>
          </div>

          <div class="row mb-3">
            <div class="col-md-4">
              <label for="edit_banned_rulenames" class="form-label"><strong>File Rule</strong></label>
              <select class="form-select" id="edit_banned_rulenames" name="edit_banned_rulenames" required>
                <cfoutput query="get_file_rules">
                  <option value="#encodeForHTML(rule_name)#">#encodeForHTML(rule_name)#</option>
                </cfoutput>
              </select>
            </div>
            <div class="col-md-4">
              <label class="form-label"><strong>Default Policy</strong></label>
              <select class="form-select" id="edit_default_policy" name="edit_default_policy">
                <option value="2">No</option>
                <option value="1">Yes</option>
              </select>
            </div>
          </div>

          <hr>
          <h6 class="mb-3"><strong>Accept Settings</strong></h6>
          <div class="row mb-3">
            <div class="col-md-3">
              <label class="form-label"><strong>Accept Viruses</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_virus_lover" id="edit_virus_lover_y" value="Y">
                  <label class="form-check-label" for="edit_virus_lover_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_virus_lover" id="edit_virus_lover_n" value="N">
                  <label class="form-check-label" for="edit_virus_lover_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label"><strong>Accept Spam</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_spam_lover" id="edit_spam_lover_y" value="Y">
                  <label class="form-check-label" for="edit_spam_lover_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_spam_lover" id="edit_spam_lover_n" value="N">
                  <label class="form-check-label" for="edit_spam_lover_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label"><strong>Accept Banned Files</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_banned_files_lover" id="edit_banned_files_lover_y" value="Y">
                  <label class="form-check-label" for="edit_banned_files_lover_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_banned_files_lover" id="edit_banned_files_lover_n" value="N">
                  <label class="form-check-label" for="edit_banned_files_lover_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label"><strong>Accept Bad Headers</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bad_header_lover" id="edit_bad_header_lover_y" value="Y">
                  <label class="form-check-label" for="edit_bad_header_lover_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bad_header_lover" id="edit_bad_header_lover_n" value="N">
                  <label class="form-check-label" for="edit_bad_header_lover_n">No</label>
                </div>
              </div>
            </div>
          </div>

          <h6 class="mb-3"><strong>Bypass Checks</strong></h6>
          <div class="row mb-3">
            <div class="col-md-3">
              <label class="form-label"><strong>Bypass Virus Checks</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_virus_checks" id="edit_bypass_virus_y" value="Y">
                  <label class="form-check-label" for="edit_bypass_virus_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_virus_checks" id="edit_bypass_virus_n" value="N">
                  <label class="form-check-label" for="edit_bypass_virus_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label"><strong>Bypass Spam Checks</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_spam_checks" id="edit_bypass_spam_y" value="Y">
                  <label class="form-check-label" for="edit_bypass_spam_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_spam_checks" id="edit_bypass_spam_n" value="N">
                  <label class="form-check-label" for="edit_bypass_spam_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label"><strong>Bypass Banned Checks</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_banned_checks" id="edit_bypass_banned_y" value="Y">
                  <label class="form-check-label" for="edit_bypass_banned_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_banned_checks" id="edit_bypass_banned_n" value="N">
                  <label class="form-check-label" for="edit_bypass_banned_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label"><strong>Bypass Header Checks</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_header_checks" id="edit_bypass_header_y" value="Y">
                  <label class="form-check-label" for="edit_bypass_header_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_bypass_header_checks" id="edit_bypass_header_n" value="N">
                  <label class="form-check-label" for="edit_bypass_header_n">No</label>
                </div>
              </div>
            </div>
          </div>

          <h6 class="mb-3"><strong>Notifications</strong></h6>
          <div class="row mb-3">
            <div class="col-md-4">
              <label class="form-label"><strong>Notify on Banned File</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_warnbannedrecip" id="edit_warnbanned_y" value="Y">
                  <label class="form-check-label" for="edit_warnbanned_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_warnbannedrecip" id="edit_warnbanned_n" value="N">
                  <label class="form-check-label" for="edit_warnbanned_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <label class="form-label"><strong>Notify on Virus</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_warnvirusrecip" id="edit_warnvirus_y" value="Y">
                  <label class="form-check-label" for="edit_warnvirus_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_warnvirusrecip" id="edit_warnvirus_n" value="N">
                  <label class="form-check-label" for="edit_warnvirus_n">No</label>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <label class="form-label"><strong>Notify on Bad Header</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_warnbadhrecip" id="edit_warnbadh_y" value="Y">
                  <label class="form-check-label" for="edit_warnbadh_y">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_warnbadhrecip" id="edit_warnbadh_n" value="N">
                  <label class="form-check-label" for="edit_warnbadh_n">No</label>
                </div>
              </div>
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

<!--- Hidden forms for copy and delete --->
<form id="copyForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="copy_policy">
  <input type="hidden" name="copy_policy_id" id="copy_policy_id" value="">
</form>

<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete_policy">
  <input type="hidden" name="delete_policy_id" id="delete_policy_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#policiesTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 7] },
      { searchable: false, targets: [0, 7] }
    ]
  });

  var selectedIds = new Set();
  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.row-checkbox:visible:not(:disabled)').each(function() {
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
    if (!confirm('Delete ' + selectedIds.size + ' selected policies? System, default, and assigned policies will be skipped.')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function setRadio(name, value) {
  var radios = document.getElementsByName(name);
  for (var i = 0; i < radios.length; i++) {
    radios[i].checked = (radios[i].value === value);
  }
}

function openEditModal(id, name, virusLover, spamLover, bannedFilesLover, badHeaderLover,
    bypassVirus, bypassSpam, bypassBanned, bypassHeader,
    spamTag2, spamKill, bannedRulenames, warnBanned, warnVirus, warnBadh,
    defaultPolicy, isSystem) {
  document.getElementById('edit_policy_id').value = id;
  document.getElementById('edit_policy_name').value = name;
  document.getElementById('edit_spam_tag2_level').value = spamTag2;
  document.getElementById('edit_spam_kill_level').value = spamKill;
  document.getElementById('edit_banned_rulenames').value = bannedRulenames;
  document.getElementById('edit_default_policy').value = defaultPolicy;

  // Set radio buttons
  setRadio('edit_virus_lover', virusLover);
  setRadio('edit_spam_lover', spamLover);
  setRadio('edit_banned_files_lover', bannedFilesLover);
  setRadio('edit_bad_header_lover', badHeaderLover);
  setRadio('edit_bypass_virus_checks', bypassVirus);
  setRadio('edit_bypass_spam_checks', bypassSpam);
  setRadio('edit_bypass_banned_checks', bypassBanned);
  setRadio('edit_bypass_header_checks', bypassHeader);
  setRadio('edit_warnbannedrecip', warnBanned);
  setRadio('edit_warnvirusrecip', warnVirus);
  setRadio('edit_warnbadhrecip', warnBadh);

  // Disable policy name for system policies
  document.getElementById('edit_policy_name').readOnly = (isSystem === '1');

  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function copyPolicy(id, name) {
  if (!confirm('Create a copy of "' + name + '"?')) return;
  document.getElementById('copy_policy_id').value = id;
  document.getElementById('copyForm').submit();
}

function deletePolicy(id, name) {
  if (!confirm('Delete policy "' + name + '"? This cannot be undone.')) return;
  document.getElementById('delete_policy_id').value = id;
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
