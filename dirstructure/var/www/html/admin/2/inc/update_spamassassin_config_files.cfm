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
    
    <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    
    
    <!--- EDIT /ETC/SPAMASASSIN/LOCAL.CF BELOW --->
    
    <cffile action="read" file="/opt/hermes/conf_files/local.cf.HERMES" variable="safile">
    
    <cfif #get_use_dcc.value# is "1">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-DCC","use_dcc 1","ALL")#">
    
    <cfelseif #get_use_dcc.value# is "0">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-DCC","use_dcc 0","ALL")#">


    </cfif>
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_use_pyzor.value# is "1">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-PYZOR","use_pyzor 1","ALL")#">
    
    <cfelseif #get_use_pyzor.value# is "0">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-PYZOR","use_pyzor 0","ALL")#">

    </cfif>
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_use_razor2.value# is "1">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-RAZOR2","use_razor2 1","ALL")#">
    
    <cfelseif #get_use_razor2.value# is "0">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-RAZOR2","use_razor2 0","ALL")#">

    </cfif>
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_use_bayes.value# is "1">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-BAYES","use_bayes 1","ALL")#">
    
    <cfelseif #get_use_bayes.value# is "0">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","USE-BAYES","use_bayes 0","ALL")#">

    </cfif>
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cfif #get_bayes_auto_learn.value# is "1">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYES-AUTO-LEARN","bayes_auto_learn 1","ALL")#">
    
    <cfelseif #get_bayes_auto_learn.value# is "0">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYES-AUTO-LEARN","bayes_auto_learn 0","ALL")#">

    </cfif>
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYESAUTOLEARN-SPAM","bayes_auto_learn_threshold_spam #get_bayes_auto_learn_threshold_spam.value#","ALL")#">
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
        output = "#REReplace("#safile#","BAYESAUTOLEARN-HAM","bayes_auto_learn_threshold_nonspam #get_bayes_auto_learn_threshold_nonspam.value#","ALL")#">
    
    <!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM TESTS BELOW --->
    
    <cfquery name="gettests" datasource="hermes">
    SELECT parameter, value, spamfilter, active, score FROM spam_settings where spamfilter='1' and active = '1' order by parameter asc
    </cfquery>
    
    <cfif #gettests.recordcount# GTE 1>
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
        output = ""
        addNewLine = "no">
    
    <cfloop query="gettests">
    
    <cfif #score# is "1">
    
    <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
        output = "score #parameter# #value#"
        addNewLine = "yes">
    
    
    <cfelse>
    
      <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
        output = "#parameter# #value#"
        addNewLine = "yes">
    
    <!--- /CFIF #score# is "1" --->
    </cfif>
    
    </cfloop>
    
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_sa_tests" variable="theTests">
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile action = "write"
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
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = ""
        addNewLine = "no">
    
    <cfloop query="getmessagerules">
    
    <cfif #rule_type# is not "header">

    <cfif #rule_desc# is not "">

    <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #regex##chr(10)#score #rule_name# #score##chr(10)#describe #rule_name# #rule_desc##chr(10)#"
        addNewLine = "yes">

    <cfelseif #rule_desc# is "">

    <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #regex##chr(10)#score #rule_name# #score##chr(10)#"
        addNewLine = "yes">

    <!--- /CFIF #rule_desc# is --->
    </cfif>

    <cfelseif #rule_type# is "header">

    <cfif #rule_desc# is not "">

    <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #header# =#regex##chr(10)#score #rule_name# #score##chr(10)#describe #rule_name# #rule_desc##chr(10)#"
        addNewLine = "yes">

    <cfelseif #rule_desc# is "">

    <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_message_rules"
        output = "#rule_type# #rule_name# #header# =#regex##chr(10)#score #rule_name# #score##chr(10)#"
        addNewLine = "yes">

    <!--- /CFIF #rule_desc# is --->
    </cfif>

    <!--- /CFIF #rule_type# is --->
    </cfif>

    </cfloop>
    
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_message_rules" variable="theRules">
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">
    
    <cffile action = "write"
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
  <cffile action="copy" source = "/etc/spamassassin/local.cf" destination = "/etc/spamassassin/local.cf.HERMES.BACKUP">

  <!--- Move /opt/hermes/tmp/#customtrans3#local.cf.HERMES to /etc/spamassassin/local.cf --->
  <cffile action="move" source = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES" destination = "/etc/spamassassin/local.cf">

  <cfquery name="updateparams" datasource="hermes">
    update spam_settings set applied='1' where applied = '2' and spamfilter = '1'
    </cfquery> 

        
    