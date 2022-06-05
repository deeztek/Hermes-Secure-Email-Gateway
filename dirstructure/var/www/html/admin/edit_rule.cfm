<!---
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
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Edit Rule</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script language="JavaScript">
if(document.images) image1 = new Image(); image1.src = 'ajax-loader.gif';
</script>

<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <br><br><br><br><br><br><br><br>
<body style="background-image: url(ajax-loader.gif); background-repeat: no-repeat; background-position: 50% 50%;">

</body>
</html>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS STARTS HERE --->
<cffile action="read" file="/opt/hermes/creds/hermes_username" variable="mysqlusernamehermes">
<cffile action="read" file="/opt/hermes/creds/hermes_password" variable="mysqlpasswordhermes">

<cfset mysqlusernamehermes = #TRIM(mysqlusernamehermes)#>
<cfset mysqlpasswordhermes = #TRIM(mysqlpasswordhermes)#>

<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS ENDS HERE --->


<cfset action="#form.action#">

<cfif #action# is "delete">
<cfif IsDefined("form.file") and not IsNumeric(form.file)>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>

<cfelseif NOT IsDefined ("form.file")>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
</cfif>

<cfquery name="checkexists" datasource="#datasource#">
SELECT file_id, priority from file_rule_components_temp where file_id='#form.file#' and action = '#form.template#'
</cfquery>

<cfif #checkexists.recordcount# GTE 1>

<cfquery name="gettotal" datasource="#datasource#">
SELECT * from file_rule_components_temp where action = '#form.template#'
</cfquery>

<cfif #gettotal.recordcount# EQ 1>
<cflocation url="edit_file_rule.cfm?m2=14" addtoken="no">

<cfelse>

<cfif #checkexists.priority# NEQ 1>

<cfquery name="deletefile" datasource="#datasource#">
delete from file_rule_components_temp where file_id = '#form.file#' and applied = '2' and action = '#form.template#'

</cfquery>

<cfquery name="getelements" datasource="#datasource#">
select * from file_rule_components_temp where applied = '2' and action = '#form.template#' order by priority asc
</cfquery>

<cfloop query="getelements">

<cfoutput>
<cfquery name="editpriority" datasource="#datasource#">
update file_rule_components_temp set priority = '#currentrow#' where file_id = '#file_id#' and action = '#form.template#' 
</cfquery>
</cfoutput>

</cfloop>


<cfelseif #checkexists.priority# EQ 1>

<cfquery name="deletefile" datasource="#datasource#" result="stSender">
delete from file_rule_components_temp where file_id = '#form.file#' and applied = '2' and action = '#form.template#' 
</cfquery>

<cfquery name="getelements" datasource="#datasource#">
select * from file_rule_components_temp where applied = '2' and action = '#form.template#' order by priority asc
</cfquery>

<cfloop query="getelements">

<cfoutput>
<cfquery name="editpriority" datasource="#datasource#">
update file_rule_components_temp set priority = '#currentrow#' where file_id = '#file_id#' and action = '#form.template#' 
</cfquery>
</cfoutput>

</cfloop>

</cfif>



<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=9" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=9" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=9" addtoken="no">
</cfif>

</cfif>

<cfelseif #checkexists.recordcount# LT 1> 

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>


</cfif>



<cfelseif #action# is "Move Up">
<cfif IsDefined("form.file") and not IsNumeric(form.file)>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
<cfelseif NOT IsDefined ("form.file")>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
</cfif>

<cfquery name="checkexists" datasource="#datasource#">
SELECT file_id, priority from file_rule_components_temp where file_id='#form.file#' and action = '#form.template#' 
</cfquery>

<cfif #checkexists.recordcount# GTE 1>

<cfquery name="getold" datasource="#datasource#">
select priority from file_rule_components_temp where file_id = '#form.file#' and applied = '2' and action = '#form.template#' 
</cfquery>

<cfset newpriority = #getold.priority# -1>
<cfif #newpriority# GTE 1>

<cfquery name="getexisting" datasource="#datasource#"> 
select priority, file_id from file_rule_components_temp where priority = '#newpriority#' and applied = '2' and action = '#form.template#' 
</cfquery>

<cfquery name="updatenew" datasource="#datasource#">
update file_rule_components_temp set priority = '#newpriority#' where file_id = '#form.file#' and action = '#form.template#' 
</cfquery>

<cfquery name="updateold" datasource="#datasource#">
update file_rule_components_temp set priority = '#getold.priority#' where file_id = '#getexisting.file_id#' and action = '#form.template#' 
</cfquery>

<cfquery name="getelements" datasource="#datasource#">
select * from file_rule_components_temp where applied = '2' and action = '#form.template#' order by priority asc 
</cfquery>

<cfloop query="getelements">

<cfoutput>
<cfquery name="editpriority" datasource="#datasource#">
update file_rule_components_temp set priority = '#currentrow#' where file_id = '#file_id#' and action = '#form.template#' 
</cfquery>
</cfoutput>

</cfloop>



<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=10" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=10" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=10" addtoken="no">
</cfif>



<cfelseif #newpriority# LT 1>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=12" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=12" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=12" addtoken="no">
</cfif>
</cfif>


<cfelseif #checkexists.recordcount# Lt 1> 
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
</cfif>





<cfelseif #action# is "Move Down">
<cfif IsDefined("form.file") and not IsNumeric(form.file)>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
<cfelseif NOT IsDefined ("form.file")>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>

</cfif>


<cfquery name="checkexists" datasource="#datasource#">
SELECT file_id, priority from file_rule_components_temp where file_id='#form.file#' and action = '#form.template#' 
</cfquery>

<cfquery name="getelements" datasource="#datasource#">
select * from file_rule_components_temp where applied = '2' and action = '#form.template#' order by priority asc
</cfquery>

<cfif #checkexists.recordcount# GTE 1>


<cfif #checkexists.priority# EQ #getelements.recordcount#>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=13" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=13" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=13" addtoken="no">
</cfif>

<cfelse>

<cfset newpriority = #checkexists.priority# +1>

<cfif #newpriority# GTE 1>

<cfquery name="getexisting" datasource="#datasource#">
select priority, file_id from file_rule_components_temp where priority = '#newpriority#' and applied = '2' and action = '#form.template#' 
</cfquery>

<cfquery name="updatenew" datasource="#datasource#">
update file_rule_components_temp set priority = '#newpriority#' where file_id = '#form.file#' and action = '#form.template#' 
</cfquery>

<cfquery name="updateold" datasource="#datasource#">
update file_rule_components_temp set priority = '#checkexists.priority#' where file_id = '#getexisting.file_id#' and action = '#form.template#' 
</cfquery>

<cfquery name="getelements" datasource="#datasource#">
select * from file_rule_components_temp where applied = '2' and action = '#form.template#' order by priority asc
</cfquery>

<cfloop query="getelements">

<cfoutput>
<cfquery name="editpriority" datasource="#datasource#">
update file_rule_components_temp set priority = '#currentrow#' where file_id = '#file_id#' and action = '#form.template#' 
</cfquery>
</cfoutput>

</cfloop>



<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=11" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=11" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=11" addtoken="no">
</cfif>

<cfelseif #newpriority# LT 1>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>

</cfif>

</cfif>

<cfelseif #checkexists.recordcount# LT 1> 
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
</cfif>




<cfelseif #action# is "add">
<cfif IsDefined("form.file")
and not IsNumeric(form.file)>
<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=1" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=1" addtoken="no">
</cfif>
</cfif>
<cfquery name="checkexists" datasource="#datasource#">
SELECT file_id from file_rule_components_temp where file_id='#form.file#' and action = '#form.template#' 
</cfquery>

<cfif #checkexists.recordcount# LT 1>
<cfif #form.type# is "allow">
<cfquery name="getdesc" datasource="#datasource#">
select id, description from files where id = '#form.file#'
</cfquery>
<cfelseif #form.type# is "ban">
<cfquery name="getdesc" datasource="#datasource#">
select id, description from files where id = '#form.file#'
</cfquery>
</cfif>

<cfquery name="getpri" datasource="#datasource#">
select max(priority) as max from file_rule_components_temp where applied = '2' and action = '#form.template#' 
</cfquery>
<cfif #getpri.max# is "">
<cfset next = 1>
<cfelse>
<cfset next = #getpri.max# + 1>
</cfif>

<cfif #form.template# is "edit">
<cfquery name="getruleid" datasource="#datasource#">
select rule_id from file_rule_components_temp where action = 'edit' limit 1
</cfquery>

<cfquery name="insertfile" datasource="#datasource#" result="stSender">
insert into file_rule_components_temp
(file_id, rule_id, description, action, type, applied, priority)
values
('#form.file#', '#getruleid.rule_id#', '#getdesc.description#', '#form.template#', '#form.type#', '2', '#next#')
</cfquery>

<cfelse>
<cfquery name="insertfile" datasource="#datasource#" result="stSender">
insert into file_rule_components_temp
(file_id, description, action, type, applied, priority)
values
('#form.file#', '#getdesc.description#', '#form.template#', '#form.type#', '2', '#next#')
</cfquery>
</cfif>


<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=4" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=4" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=4" addtoken="no">
</cfif>

<cfelseif #checkexists.recordcount# GTE 1> 

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=3" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=3" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=3" addtoken="no">
</cfif>
</cfif>



<cfelseif #action# is "Add Rule">
<cfif #form.rule_name# is "">

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=2" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=2" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=2" addtoken="no">
</cfif>

<cfelseif #form.rule_name# is not "">

<cfif REFind("[^_a-zA-Z0-9-]",form.rule_name) gt 0>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=16" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=16" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=16" addtoken="no">
</cfif>

<cfelse>

<cfquery name="checkname" datasource="#datasource#">
select rule_name from file_rule_components where rule_name = '#form.rule_name#'
</cfquery>

<cfif #checkname.recordcount# GTE 1>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=8" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=8" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=8" addtoken="no">
</cfif>
<cfelseif #checkname.recordcount# LT 1>
<cfquery name="getfiles" datasource="#datasource#">
select file_id, description, action, type, priority, applied from file_rule_components_temp where applied = '2' and action = '#form.template#' 
</cfquery>
<cfif #getfiles.recordcount# LT 1>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=5" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=5" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=5" addtoken="no">
</cfif>
<cfelseif #getfiles.recordcount# GTE 1>
<cfquery name="getmaxid" datasource="#datasource#">
select max(rule_id) as maxid from file_rule_components
</cfquery>

<cfif #getmaxid.maxid# is "">
<cfset maxid = 0>
<cfset next = #maxid#+1>
<cfelseif #getmaxid.maxid# is not "">
<cfset maxid = #getmaxid.maxid#>
<cfset next = #maxid#+1>
</cfif>

<cfloop query="getfiles">
<cfquery name="insertrule" datasource="#datasource#">
insert into file_rule_components
(file_id, rule_id, rule_name, description, type, priority, system)
values
('#file_id#', '#next#', '#form.rule_name#', '#description#', '#type#', '#priority#', '2')
</cfquery>
</cfloop>
<<cfquery name="deletetemp" datasource="#datasource#">
delete from file_rule_components_temp where applied = '2' and action = '#form.template#' 
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

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","FILE-RULES-GO-HERE","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule">
</cfif>


<!--- INSERT AMAVIS FILE RULES ABOVE --->


<cfset command="/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#50-user /etc/amavis/conf.d/50-user#chr(10)#/etc/init.d/amavis restart">

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "#command#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "120">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">


<!--- MODIFY /etc/amavis/conf.d/50-user above --->

<cflocation url="file_rules.cfm?m=7" addtoken="no">

</cfif>
</cfif>
</cfif>
</cfif>



<cfelseif #action# is "Cancel All">
<cfquery name="canceladd" datasource="#datasource#">
delete from file_rule_components_temp where action='add' and applied='2' and action = '#form.template#'  
</cfquery>


<cflocation url="file_rules.cfm?m=5" addtoken="no">





<cfelseif #action# is "Save Rule">

<cfif #form.rule_name# is "">

<cflocation url="edit_file_rule.cfm?m2=2" addtoken="no">

<cfelseif #form.rule_name# is not "">

<cfif REFind("[^_a-zA-Z0-9-]",form.rule_name) gt 0>

<cfif #form.template# is "add">
<cflocation url="create_file_rule.cfm?m2=16" addtoken="no">
<cfelseif #form.template# is "copy">
<cflocation url="copy_file_rule.cfm?m2=16" addtoken="no">
<cfelseif #form.template# is "edit">
<cflocation url="edit_file_rule.cfm?m2=16" addtoken="no">
</cfif>

<cfelse>


<cfquery name="checkname" datasource="#datasource#">
select rule_name from file_rule_components where rule_name = '#form.rule_name#' and rule_id <> '#form.rule_id#'
</cfquery>

<cfif #checkname.recordcount# GTE 1>

<cflocation url="edit_file_rule.cfm?m2=8" addtoken="no">

<cfelseif #checkname.recordcount# LT 1>
<cfquery name="getfiles" datasource="#datasource#">
select file_id, description, action, type, priority, applied from file_rule_components_temp where applied = '2' and action = '#form.template#' 
</cfquery>

<cfif #getfiles.recordcount# LT 1>

<cflocation url="edit_file_rule.cfm?m2=5" addtoken="no">

<cfelseif #getfiles.recordcount# GTE 1>

<cfquery name="getexistingname" datasource="#datasource#">
select rule_name from file_rule_components where rule_id='#form.rule_id#' limit 1
</cfquery>

<cfquery name="checkassigned" datasource="#datasource#">
select * from policy where banned_rulenames='#getexistingname.rule_name#'
</cfquery>

<cfif #checkassigned.recordcount# GTE 1>
<cfquery name="updateassigned" datasource="#datasource#">
update policy set banned_rulenames = '#form.rule_name#' where banned_rulenames='#getexistingname.rule_name#'
</cfquery>
</cfif>

<cfquery name="clearexisting" datasource="#datasource#">
delete from file_rule_components where rule_id = '#form.rule_id#'
</cfquery>




<cfquery name="updaterulename" datasource="#datasource#">
update file_rules set rule_name = '#form.rule_name#' where rule_id = '#form.rule_id#'
</cfquery>

<cfloop query="getfiles">
<cfquery name="insertrule" datasource="#datasource#">
insert into file_rule_components
(file_id, rule_id, rule_name, description, type, priority, system)
values
('#file_id#', '#form.rule_id#', '#form.rule_name#', '#description#', '#type#', '#priority#', '2')
</cfquery>
</cfloop>
<<cfquery name="deletetemp" datasource="#datasource#">
delete from file_rule_components_temp where applied = '2' and action = '#form.template#' 
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

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","FILE-RULES-GO-HERE","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule">
</cfif>


<!--- INSERT AMAVIS FILE RULE --->

<cfset command="/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#50-user /etc/amavis/conf.d/50-user#chr(10)#/etc/init.d/amavis restart">

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "#command#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "120">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">

<!--- MODIFY /etc/amavis/conf.d/50-user above --->


<cflocation url="file_rules.cfm?m=8" addtoken="no">

</cfif>
</cfif>
</cfif>
</cfif>



</cfif>
   