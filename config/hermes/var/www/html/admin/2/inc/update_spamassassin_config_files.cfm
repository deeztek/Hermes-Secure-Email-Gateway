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

<cfquery name="get_use_bayes" datasource="hermes">
    select parameter, value from spam_settings where parameter='use_bayes' and active = '1'
    </cfquery>
    
    
    <cfquery name="get_bayes_auto_learn" datasource="hermes">
    select parameter, value from spam_settings where parameter='bayes_auto_learn' and active = '1'
    </cfquery>
    
    <cfquery name="get_bayes_auto_learn_threshold_spam" datasource="hermes">
    select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_spam' and active = '1'
    </cfquery>
    
    <cfquery name="get_bayes_auto_learn_threshold_nonspam" datasource="hermes">
    select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_nonspam' and active = '1'
    </cfquery>
    
    <cfquery name="get_use_dcc" datasource="hermes">
    select parameter, value from spam_settings where parameter='use_dcc' and active = '1'
    </cfquery>
    
    <cfquery name="get_use_razor2" datasource="hermes">
    select parameter, value from spam_settings where parameter='use_razor2' and active = '1'
    </cfquery>
    
    <cfquery name="get_use_pyzor" datasource="hermes">
    select parameter, value from spam_settings where parameter='use_pyzor' and active = '1'
    </cfquery>
    
    <cfinclude template="generate_customtrans.cfm">
    
    
    <!--- EDIT /ETC/SPAMASASSIN/LOCAL.CF BELOW --->
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/conf_files/local.cf.HERMES" variable="safile">
    
    <cfif #get_use_dcc.value# is "1">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-DCC","use_dcc 1","ALL")#">
    
    <cfelseif #get_use_dcc.value# is "0">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-DCC","use_dcc 0","ALL")#">


    </cfif>
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_use_pyzor.value# is "1">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-PYZOR","use_pyzor 1","ALL")#">
    
    <cfelseif #get_use_pyzor.value# is "0">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-PYZOR","use_pyzor 0","ALL")#">

    </cfif>
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_use_razor2.value# is "1">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-RAZOR2","use_razor2 1","ALL")#">
    
    <cfelseif #get_use_razor2.value# is "0">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-RAZOR2","use_razor2 0","ALL")#">

    </cfif>
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_use_bayes.value# is "1">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-BAYES","use_bayes 1","ALL")#">
    
    <cfelseif #get_use_bayes.value# is "0">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-BAYES","use_bayes 0","ALL")#">

    </cfif>
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_bayes_auto_learn.value# is "1">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYES-AUTO-LEARN","bayes_auto_learn 1","ALL")#">
    
    <cfelseif #get_bayes_auto_learn.value# is "0">

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYES-AUTO-LEARN","bayes_auto_learn 0","ALL")#">

    </cfif>
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYESAUTOLEARN-SPAM","bayes_auto_learn_threshold_spam #get_bayes_auto_learn_threshold_spam.value#","ALL")#">
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYESAUTOLEARN-HAM","bayes_auto_learn_threshold_nonspam #get_bayes_auto_learn_threshold_nonspam.value#","ALL")#">
    
    <!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM TESTS BELOW --->
    
    <cfquery name="gettests" datasource="hermes">
    SELECT parameter, value, spamfilter, active FROM spam_settings where spamfilter='1' and active = '1' order by parameter asc
    </cfquery>

    <cfif #gettests.recordcount# GTE 1>

    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
        output = ""
        addNewLine = "no">

    <cfloop query="gettests">

    <cffile charset="utf-8" action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
        output = "score #parameter# #value#"
        addNewLine = "yes">
    
    </cfloop>
    
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#_sa_tests" variable="theTests">
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","##CUSTOM-TESTS","#theTests#","ALL")#">
    
    
    <cfif FileExists("/opt/hermes/tmp/#customtrans3#_sa_tests")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_sa_tests">
    </cfif>
    
    <!--- /CFIF #gettests.recordcount# GTE 1 --->  
    </cfif>
    
    <!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM TESTS ABOVE --->
    
    <!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM MESSAGE RULES BELOW --->
    
    <cfquery name="getmessagerules" datasource="hermes">
    SELECT rule_name, rule_type, rule_desc, header, regex, score FROM message_rules order by rule_name asc
    </cfquery>
    
    <cfif #getmessagerules.recordcount# GTE 1>
    
    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = ""
        addNewLine = "no">
    
    <cfloop query="getmessagerules">

    <cfif #rule_type# is not "header">

    <cfif #rule_desc# is not "">

    <cffile charset="utf-8" action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #regex##chr(10)#score #rule_name# #score##chr(10)#describe #rule_name# #rule_desc##chr(10)#"
        addNewLine = "yes">

    <cfelseif #rule_desc# is "">

    <cffile charset="utf-8" action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #regex##chr(10)#score #rule_name# #score##chr(10)#"
        addNewLine = "yes">

    <!--- /CFIF #rule_desc# is --->
    </cfif>

    <cfelseif #rule_type# is "header">

    <cfif #rule_desc# is not "">

    <cffile charset="utf-8" action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #header# =#regex##chr(10)#score #rule_name# #score##chr(10)#describe #rule_name# #rule_desc##chr(10)#"
        addNewLine = "yes">

    <cfelseif #rule_desc# is "">

    <cffile charset="utf-8" action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #header# =#regex##chr(10)#score #rule_name# #score##chr(10)#"
        addNewLine = "yes">

    <!--- /CFIF #rule_desc# is --->
    </cfif>

    <!--- /CFIF #rule_type# is --->
    </cfif>

    </cfloop>
    
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#_message_rules" variable="theRules">
    
    <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile charset="utf-8" action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","##CUSTOM-MESSAGE-RULES","#theRules#","ALL")#">
    
    
    <cfif FileExists("/opt/hermes/tmp/#customtrans3#_message_rules")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_message_rules">
    </cfif>
    
    <!--- /CFIF #getmessagerules.recordcount# --->
    </cfif>
    
    <!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM MESSAGE RULES ABOVE --->
    
    
    <!--- EDIT /ETC/SPAMASASSIN/LOCAL.CF ABOVE --->

      <!--- MAKE BACKUP /ETC/SPAMASASSIN/LOCAL.CF --->
  <cfif fileExists("/etc/spamassassin/local.cf")>
    <cffile action="copy" source = "/etc/spamassassin/local.cf" destination = "/etc/spamassassin/local.cf.HERMES.BACKUP">
  </cfif>

  <!--- Install the new local.cf by writing INTO the existing file, not by
       moving a new one over it. hermes_mail_filter bind-mounts local.cf as a
       single FILE, which stays attached to the original inode: after a move
       it kept serving the previous contents until the container restarted,
       so the lint below (and the one in restart_spamassassin.cfm) checked
       the old file, not the new one. A write truncates the same inode, so
       both containers see the new contents immediately. --->
  <cffile charset="utf-8" action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="saNewConfig">
  <cffile charset="utf-8" action="write" file="/etc/spamassassin/local.cf" output="#saNewConfig#" addnewline="no">
  <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES">

  <!--- VALIDATE THE NEW local.cf, AND PUT THE PREVIOUS ONE BACK IF IT FAILS.

       The file is moved into place first because lint reads
       /etc/spamassassin from inside hermes_mail_filter. Before this, a bad
       rule (a legacy DCC line, a regex corrupted by encoding) stayed live:
       restart_spamassassin.cfm's lint aborted the save AFTER the swap, and
       apply_message_rules.cfm ignored lint entirely. Now a rejected file is
       replaced by the backup taken above, the working configuration stays,
       and the operator sees SpamAssassin's own reasons.

       Run through a script so stderr (where lint reports) is captured and
       the exit code read explicitly, rather than cfexecute throwing on any
       stderr output. --->
  <cfset saLintScript = "/opt/hermes/tmp/#customtrans3#_sa_validate.sh">
  <cffile action="write" file="#saLintScript#"
          output="docker exec hermes_mail_filter /usr/bin/spamassassin --lint 2>&1#chr(10)#echo HERMES_LINT_EXIT=$?#chr(10)#exit 0">
  <cfset saLintOutput = "">
  <cftry>
    <cfexecute name="/bin/bash" arguments="#saLintScript#" variable="saLintOutput" timeout="240" />
    <cfcatch type="any">
      <cfset saLintOutput = "lint could not be run: #cfcatch.message#">
    </cfcatch>
  </cftry>
  <cfif FileExists(saLintScript)>
    <cffile action="delete" file="#saLintScript#">
  </cfif>

  <cfif NOT FindNoCase("HERMES_LINT_EXIT=0", saLintOutput)>
    <cfset saLintReport = Trim(REReplace(saLintOutput, "HERMES_LINT_EXIT=[0-9]+", "", "ALL"))>
    <cfif FileExists("/etc/spamassassin/local.cf.HERMES.BACKUP")>
      <!--- Write into the same file for the same bind-mount reason. --->
      <cffile charset="utf-8" action="read" file="/etc/spamassassin/local.cf.HERMES.BACKUP" variable="saPrevConfig">
      <cffile charset="utf-8" action="write" file="/etc/spamassassin/local.cf" output="#saPrevConfig#" addnewline="no">
    </cfif>
    <cflog file="hermes" type="error"
           text="update_spamassassin_config_files: spamassassin --lint rejected the new local.cf; previous file restored. #saLintReport#">
    <cfif StructKeyExists(request, "generateQuiet") AND request.generateQuiet>
      <cfthrow message="update_spamassassin_config_files: spamassassin --lint rejected the new local.cf; previous file restored. #saLintReport#">
    <cfelse>
      <cfset m="Update SpamAssassin Configuration: SpamAssassin rejected the new configuration, so the previous one was kept and nothing was applied. Fix the setting or rule it names and save again. SpamAssassin reported: #encodeForHTML(saLintReport)#">
      <cfinclude template="error.cfm">
      <cfabort>
    </cfif>
  </cfif>

  <cfquery name="updateparams" datasource="hermes">
    update spam_settings set applied='1' where applied = '2' and spamfilter = '1'
    </cfquery> 

        
    