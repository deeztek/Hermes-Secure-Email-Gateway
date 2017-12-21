<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete Rule</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="803">
    <tr valign="top" align="left">
      <td width="21" height="37"></td>
      <td width="782"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="782" id="Text1" class="TextObject">
        <p style="margin-bottom: 0px;"><cfif IsDefined("URL.ID")>
<cfif #url.id# is not "">
<cfquery name="checksystem" datasource="#datasource#">
select distinct(rule_name) from file_rule_components where rule_id='#url.id#' and system = '1'
</cfquery>

<cfif #checksystem.recordcount# GTE 1>
<cflocation url="file_rules.cfm?m=6">
</cfif>

<cfquery name="checkowner" datasource="#datasource#">
select distinct(rule_name) as RuleName from file_rule_components where rule_id='#url.id#'
</cfquery>

<cfif #checkowner.recordcount# LT 1>
<cflocation url="file_rules.cfm?m=9">
</cfif>

<cfquery name="checkassigned" datasource="#datasource#">
select * from policy where banned_rulenames='#checkowner.RuleName#'
</cfquery>

<cfif #checkassigned.recordcount# GTE 1>
<cflocation url="file_rules.cfm?m=11">
</cfif>

<cfquery name="delete" datasource="#datasource#">
delete from file_rules where rule_id='#url.id#'
</cfquery>

<cfquery name="delete2" datasource="#datasource#">
delete from file_rule_components where rule_id='#url.id#'
</cfquery>

<!--- MODIFY /etc/amavis/conf.d/50-user below --->

<cfquery name="server_name" datasource="#datasource#">
select * from parameters2 where parameter='server_name' and module='network' and active='1'
</cfquery>

<cfquery name="server_domain" datasource="#datasource#">
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
</cfquery>

<cfquery name="server_subnet" datasource="#datasource#">
select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
</cfquery>

<cfquery name="get_sa_spam_subject_tag" datasource="#datasource#">
select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
</cfquery>

<cfquery name="get_final_virus_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_banned_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_spam_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_bad_header_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
</cfquery>

<cfset ServerName="#server_name.value2#">
<cfset ServerDomain="#server_domain.value2#">
<cfset ServerSubnet="#server_subnet.value2#">

<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="#datasource#">
select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>



<cffile action="read" file="/opt/hermes/conf_files/50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">

<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","SERVER-DOMAIN","#ServerDomain#","ALL")#">

<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","sa-spam-subject-tag","#get_sa_spam_subject_tag.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","final-virus-destiny","#get_final_virus_destiny.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","final-banned-destiny","#get_final_banned_destiny.value#","ALL")#">

<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","final-spam-destiny","#get_final_spam_destiny.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","final-bad-header-destiny","#get_final_bad_header_destiny.value#","ALL")#">
    

<!--- INSERT AMAVIS FILE RULES BELOW --->

<cfquery name="getrules" datasource="#datasource#">
SELECT distinct(rule_id) as RuleID, rule_name FROM file_rule_components
</cfquery>



<cfloop query="getrules">

<cfquery name="getrulecomponents" datasource="#datasource#">
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

<cfquery name="getfile" datasource="#datasource#">
select ban as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#"
    addNewLine = "yes">

<cfelseif #type# is "allow">
<cfquery name="getfile" datasource="#datasource#">
select allow as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#"
    addNewLine = "yes">


</cfif>

<cfelseif #currentrow# NEQ #last#>


<cfif #type# is "ban">

<cfquery name="getfile" datasource="#datasource#">
select ban as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#,"
    addNewLine = "yes">

<cfelseif #type# is "allow">
<cfquery name="getfile" datasource="#datasource#">
select allow as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#,"
    addNewLine = "yes">


</cfif>

</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#" variable="theComponents">


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

<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#50-user.HERMES"
    output = "#REReplace("#user#","FILE-RULES-GO-HERE","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule">
</cfif>


<!--- INSERT AMAVIS FILE RULES ABOVE --->


<cfset command="/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP#chr(10)#/bin/mv /opt/hermes/conf_files/#customtrans3#50-user.HERMES /etc/amavis/conf.d/50-user#chr(10)#/etc/init.d/amavis restart">

<cffile action = "write" 
file = "/opt/hermes/conf_files/#customtrans3#_apply.sh" 
output = "#command#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/conf_files/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/conf_files/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "120">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/conf_files/#customtrans3#_apply.sh">

<!--- MODIFY /etc/amavis/conf.d/50-user above --->

<cflocation url="file_rules.cfm?m=12">

<cfelse>
<cflocation url="file_rules.cfm?m=8">
</cfif>

<cfelseif NOT IsDefined("URL.ID")>
<cflocation url="error.cfm">
</cfif>&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   