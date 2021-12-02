
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

<cfquery name="get_sa_spam_subject_tag" datasource="hermes">
    select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_virus_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_banned_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_spam_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_bad_header_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
    </cfquery>

<cffile action="read" file="/opt/hermes/conf_files/50-user.HERMES" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","SERVER-NAME","#ServerName#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","sa-spam-subject-tag","#get_sa_spam_subject_tag.value#","ALL")#">
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","final-virus-destiny","#get_final_virus_destiny.value#","ALL")#">
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","final-banned-destiny","#get_final_banned_destiny.value#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","final-spam-destiny","#get_final_spam_destiny.value#","ALL")#">
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","final-bad-header-destiny","#get_final_bad_header_destiny.value#","ALL")#">
      
  <!--- INSERT HERMES MYSQL DATABASE USERNAME AND PASSWORD BELOW --->    
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#">
  
  <!--- INSERT HERMES MYSQL DATABASE USERNAME AND PASSWORD ABOVE --->    
  
  <!--- INSERT AMAVIS FILE RULES BELOW --->
  
  <cfquery name="getrules" datasource="hermes">
  SELECT distinct(rule_id) as RuleID, rule_name FROM file_rule_components
  </cfquery>
  
  
  
  <cfloop query="getrules">
  
  <cfquery name="getrulecomponents" datasource="hermes">
  select file_id, type from file_rule_components where rule_id='#RuleID#' order by priority asc
  </cfquery>
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#"
      output = "'#rule_name#' => new_RE( RULES ),"
      addNewLine = "yes">
  
  
  
  <cfset last = #getrulecomponents.recordcount#>
  
  <cfloop query="getrulecomponents">
  
  <cfif #currentrow# EQ #last#>
  
  <cfif #type# is "ban">
  
  <cfquery name="getfile" datasource="hermes">
  select ban as theType from files where id='#file_id#'
  </cfquery>
  
  <cffile action = "append"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
      output = "#getfile.theType#"
      addNewLine = "yes">
  
  <cfelseif #type# is "allow">
  <cfquery name="getfile" datasource="hermes">
  select allow as theType from files where id='#file_id#'
  </cfquery>
  
  <cffile action = "append"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
      output = "#getfile.theType#"
      addNewLine = "yes">
  
  
  </cfif>
  
  <cfelseif #currentrow# NEQ #last#>
  
  
  <cfif #type# is "ban">
  
  <cfquery name="getfile" datasource="hermes">
  select ban as theType from files where id='#file_id#'
  </cfquery>
  
  <cffile action = "append"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
      output = "#getfile.theType#,"
      addNewLine = "yes">
  
  <cfelseif #type# is "allow">
  <cfquery name="getfile" datasource="hermes">
  select allow as theType from files where id='#file_id#'
  </cfquery>
  
  <cffile action = "append"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
      output = "#getfile.theType#,"
      addNewLine = "yes">
  
  
  </cfif>
  
  </cfif>
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
   variable="theComponents">
  
  
  </cfloop>
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#" variable="theRule">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#"
      output = "#REReplace("#theRule#","RULES","#chr(10)##theComponents#","ALL")#"
      addNewLine = "no">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#" variable="theRule">
  
  <cffile action = "append"
      file = "/opt/hermes/tmp/#customtrans3#_amavis_rule"
      output = "#theRule#"
      addNewLine = "yes">
  
  <cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#")>
  <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#">
  </cfif>
  
  <cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#")>
  <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#">
  </cfif>
  
  
  </cfloop>
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule" variable="theRules">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#50-user"
      output = "#REReplace("#user#","FILE-RULES-GO-HERE","#theRules#","ALL")#">
  
  
  <cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule")>
  <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule">
  </cfif>
  
  
  <!--- INSERT AMAVIS FILE RULES ABOVE --->