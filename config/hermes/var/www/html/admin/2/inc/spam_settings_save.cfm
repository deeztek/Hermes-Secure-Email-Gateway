
<!---
Hermes Secure Email Gateway - Save Spam Settings Action Handler
Validates, saves all spam filter settings to spam_settings table,
then immediately updates Amavis/SpamAssassin config and restarts services.
--->

<cfset saveError = false>

<!--- Validate spam subject tag --->
<cfif NOT StructKeyExists(form, "sa_spam_subject_tag") OR Trim(form.sa_spam_subject_tag) EQ "">
  <cfset session.m = 2>
  <cfset saveError = true>
</cfif>

<!--- Validate Bayes auto-learn thresholds if auto-learn is enabled --->
<cfif NOT saveError AND StructKeyExists(form, "bayes_auto_learn") AND form.bayes_auto_learn EQ "1">
  <!--- Spam threshold: must be numeric and > 0 --->
  <cfif NOT StructKeyExists(form, "bayes_auto_learn_threshold_spam") OR Trim(form.bayes_auto_learn_threshold_spam) EQ "">
    <cfset session.m = 3>
    <cfset saveError = true>
  <cfelseif NOT IsNumeric(form.bayes_auto_learn_threshold_spam)>
    <cfset session.m = 5>
    <cfset saveError = true>
  <cfelseif Val(form.bayes_auto_learn_threshold_spam) LTE 0 OR Val(form.bayes_auto_learn_threshold_spam) GT 999>
    <cfset session.m = 4>
    <cfset saveError = true>
  </cfif>

  <!--- Non-spam threshold: must be numeric and < 0 --->
  <cfif NOT saveError>
    <cfif NOT StructKeyExists(form, "bayes_auto_learn_threshold_nonspam") OR Trim(form.bayes_auto_learn_threshold_nonspam) EQ "">
      <cfset session.m = 7>
      <cfset saveError = true>
    <cfelseif NOT IsNumeric(form.bayes_auto_learn_threshold_nonspam)>
      <cfset session.m = 10>
      <cfset saveError = true>
    <cfelseif Val(form.bayes_auto_learn_threshold_nonspam) GTE 0 OR Val(form.bayes_auto_learn_threshold_nonspam) LT -999>
      <cfset session.m = 8>
      <cfset saveError = true>
    </cfif>
  </cfif>
</cfif>

<cfif NOT saveError>
  <cftry>
    <!--- Save all settings --->
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.sa_spam_subject_tag)#">, applied='1'
      WHERE parameter='sa_spam_subject_tag'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'final_virus_destiny') ? form.final_virus_destiny : 'D_DISCARD'#">, applied='1'
      WHERE parameter='final_virus_destiny'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'final_banned_destiny') ? form.final_banned_destiny : 'D_DISCARD'#">, applied='1'
      WHERE parameter='final_banned_destiny'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'final_spam_destiny') ? form.final_spam_destiny : 'D_DISCARD'#">, applied='1'
      WHERE parameter='final_spam_destiny'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'final_bad_header_destiny') ? form.final_bad_header_destiny : 'D_DISCARD'#">, applied='1'
      WHERE parameter='final_bad_header_destiny'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'use_bayes') ? '1' : '0'#">, applied='1'
      WHERE parameter='use_bayes'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'bayes_auto_learn') ? '1' : '0'#">, applied='1'
      WHERE parameter='bayes_auto_learn'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'bayes_auto_learn_threshold_spam') ? Trim(form.bayes_auto_learn_threshold_spam) : '6.31'#">, applied='1'
      WHERE parameter='bayes_auto_learn_threshold_spam'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'bayes_auto_learn_threshold_nonspam') ? Trim(form.bayes_auto_learn_threshold_nonspam) : '-0.1'#">, applied='1'
      WHERE parameter='bayes_auto_learn_threshold_nonspam'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'use_dcc') ? '1' : '0'#">, applied='1'
      WHERE parameter='use_dcc'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'use_razor2') ? '1' : '0'#">, applied='1'
      WHERE parameter='use_razor2'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE spam_settings SET value=<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyExists(form,'use_pyzor') ? '1' : '0'#">, applied='1'
      WHERE parameter='use_pyzor'
    </cfquery>

    <!--- Apply immediately: update Amavis config and restart services --->
    <cfinclude template="update_amavis_config_files.cfm">
    <cfinclude template="restart_amavis.cfm">
    <cfinclude template="restart_spamassassin.cfm">

    <cfset session.m = 1>

    <cfcatch type="any">
      <cfset session.m = 9>
      <cfset session.saveError = cfcatch.message>
    </cfcatch>
  </cftry>
</cfif>

<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
