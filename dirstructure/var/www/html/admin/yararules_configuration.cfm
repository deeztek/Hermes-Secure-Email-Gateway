<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>YaraRules Configuration</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

<script type="text/javascript" language="javascript">// <![CDATA[
function checkAll(formname, checktoggle)
{
  var checkboxes = new Array();
  checkboxes = document[formname].getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = checktoggle;
    }
  }
}
// ]]></script>


<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(192,192,192); background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu2',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu2.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="131" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion32" style="background-image: url('./top_blue_3.png'); height: 131px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="709">
                        <tr valign="top" align="left">
                          <td width="45" height="92"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="13"></td>
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="679" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 679px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="977">
                        <tr valign="top" align="left">
                          <td width="7" height="13"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="452"></td>
                          <td width="3"></td>
                          <td width="1"></td>
                          <td width="4"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td width="506" id="Text291" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">YaraRules Feed Configuration</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="3" width="961" id="Text454" class="TextObject">
                            <p><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">This project covers the need of a group of IT Security Researches to have a single repository where different Yara signatures are compiled, classified and kept as up to date as possible, and begin as an open source community for collecting Yara rules. The Yara ruleset is under the GNU-GPLv2 license and open to any user or organization, as long as you use it under this license. More information can be found at <a href="https://github.com/Yara-Rules/rules">https://github.com/Yara-Rules/rules</a></span></p>
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Enable and disable YaraRules databases below as needed. The databased marked as LOW False Positive Risk are the safest ones to enable.&nbsp; </span></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="959"><hr id="HRRule1" width="959" size="1"></td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="254"></td>
                          <td colspan="6" width="964"><cfparam name = "m" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "action" default = ""> 

<cfquery name="getunapplied" datasource="#datasource#">
select applied from malware_databases where applied = '2'
</cfquery>

<cfif #getunapplied.recordcount# GT 0>
<cfset m=9>
</cfif>

<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>


<cfquery name="getyararules" datasource="#datasource#">
select name, enabled, update_int from malware_feeds where name = 'yararules'
</cfquery>



<cfparam name = "yararules" default = "#getyararules.enabled#"> 
<cfif IsDefined("form.yararules") is "True">
<cfset yararules = form.yararules>
</cfif>

<cfparam name = "update_int" default = "#getyararules.update_int#"> 
<cfif IsDefined("form.update_int") is "True">
<cfset update_int = form.update_int>
</cfif>


<cfif #action# is "Save Settings">

<!--
<cfoutput>
ACTION: #form.action#<br>
</cfoutput>
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
CHECKBOX:#thefield#<br>
<cfset theId = listGetAt(form[thefield], 2, "_")>
TheID: #theId#<br>

</cfoutput>
</cfif>
</cfloop>

-->

<cfquery name="updateyararules" datasource="#datasource#">
update malware_feeds set enabled = '#yararules#', update_int = '#update_int#' where name = 'yararules'
</cfquery>


<cfquery name="setdatabasesfalse" datasource="#datasource#">
update malware_databases set active = 'false' where feed = 'yararules'
</cfquery>

<!-- START ROUTINE TO ENABLE/DISABLE DATABASES -->
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset theId = listGetAt(form[thefield], 2, "_")>

<cfquery name="updatedatabases" datasource="#datasource#">
update malware_databases set active = 'true' where id = '#theId#' and feed = 'yararules'
</cfquery>

</cfoutput>
</cfif>
</cfloop>

<!-- STOP ROUTINE TO ENABLE/DISABLE DATABASES -->

<!-- START ROUTINE TO DELETE DATABASES -->

<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cboxdelete'>
<cfoutput>
<cfset thedeleteId = listGetAt(form[thefield], 2, "_")>

<cfquery name="getdbname" datasource="#datasource#">
select db from malware_databases where id = '#thedeleteId#' and feed = 'yararules'
</cfquery>

<cfset Thedb="#getdbname.db#">

<cfif REFind("[/]",Thedb) gt 0>

<cfset Thedb2 = #trim(ListGetAt(Thedb, 2, "/"))#>

<cfelse>

<cfset Thedb2="#Thedb#">

</cfif>

<cfif FileExists("/var/lib/clamav/#Thedb2#")>

<cffile
    action = "delete"
    file = "/var/lib/clamav/#Thedb2#">
</cfif>

<cfquery name="updatedatabases" datasource="#datasource#">
delete from malware_databases where id = '#thedeleteId#' and feed = 'yararules'
</cfquery>

</cfoutput>
</cfif>
</cfloop>

<cfexecute name = "/etc/init.d/clamav-daemon"
arguments="force-reload"
timeout = "240"
outputfile = "/dev/null">
</cfexecute>



<!-- STOP ROUTINE TO DELETE DATABASES -->

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


<!-- START SANESECURITY-->
<cfquery name = "sanesecurityconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'sanesecurity'
</cfquery>

<cffile action="read" file="/opt/hermes/conf_files/user.conf" variable="temp">

<cfif #sanesecurityconf.enabled# is "true">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SANESECURITY-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #sanesecurityconf.enabled# is "false">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SANESECURITY-ENABLED","no","ALL")#" addnewline="no">

<!-- /CFIF sanesecurity.enabled -->
</cfif>

<!-- START SANESECURITY DBS-->
<cfquery name = "sanesecuritydbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'sanesecurity' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_sanesecuritydbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="sanesecuritydbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_sanesecuritydbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_sanesecuritydbs" variable="sanesecuritydbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SANESECURITY-DBS","#sanesecuritydbsfile#","ALL")#" addnewline="no">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_sanesecuritydbs")>
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_sanesecuritydbs">
</cfif>

<!-- END SANESECURITY DBS-->

<!-- END SANESECURITY-->

<!-- START SECURITEINFO -->
<cfquery name = "securiteinfoconf" datasource="#datasource#">
select enabled, update_int, code from malware_feeds where name = 'securiteinfo'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #securiteinfoconf.enabled# is "true">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-AUTHORIZATION-SIGNATURE","#securiteinfoconf.code#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-UPDATE","#securiteinfoconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #securiteinfoconf.enabled# is "false">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-AUTHORIZATION-SIGNATURE","#securiteinfoconf.code#","ALL")#" addnewline="no">

    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-UPDATE","#securiteinfoconf.update_int#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-ENABLED","no","ALL")#" addnewline="no">

<!-- /CFIF securiteinfoconf.enabled -->
</cfif>

<!-- START SECURITEINFO DBS-->
<cfquery name = "securiteinfodbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'securiteinfo' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_securiteinfodbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="securiteinfodbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_securiteinfodbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_securiteinfodbs" variable="securiteinfodbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURERITEINFO-DBS","#securiteinfodbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_securiteinfodbs")>
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_securiteinfodbs">
    
</cfif>
    
<!-- END SECURITEINFO DBS-->

<!-- END SECURITEINFO -->


<!-- START MALWAREPATROL-->
<cfquery name = "malwarepatrolconf" datasource="#datasource#">
select enabled, update_int, code, product, list, malwarepatrol_free from malware_feeds where name = 'malwarepatrol'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #malwarepatrolconf.enabled# is "true">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-RECEIPT-CODE","#malwarepatrolconf.code#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-PRODUCT-CODE","#malwarepatrolconf.product#","ALL")#" addnewline="no">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-LIST","#malwarepatrolconf.list#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-FREE","#malwarepatrolconf.malwarepatrol_free#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-UPDATE","#malwarepatrolconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #malwarepatrolconf.enabled# is "false">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-RECEIPT-CODE","","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-PRODUCT-CODE","","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-LIST","#malwarepatrolconf.list#","ALL")#" addnewline="no">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-FREE","#malwarepatrolconf.malwarepatrol_free#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-UPDATE","#malwarepatrolconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-ENABLED","no","ALL")#" addnewline="no">

<!-- /CFIF malwarepatrol.enabled -->
</cfif>

<!-- END MALWAREPATROL-->


<!-- START LINUXMALWAREDETECT -->
<cfquery name = "linuxmalwaredetectconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'linuxmalwaredetect'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #linuxmalwaredetectconf.enabled# is "true">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-UPDATE","#linuxmalwaredetectconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #linuxmalwaredetectconf.enabled# is "false">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-UPDATE","#linuxmalwaredetectconf.update_int#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-ENABLED","no","ALL")#" addnewline="no">

<!-- /CFIF linuxmalwaredetect.enabled -->
</cfif>

<!-- START LINUXMALWAREDETECT DBS-->
<cfquery name = "linuxmalwaredetectdbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'linuxmalwaredetect' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="linuxmalwaredetectdbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs" variable="linuxmalwaredetectdbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-DBS","#linuxmalwaredetectdbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs")>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs">

</cfif>
    
<!-- END LINUXMALWAREDETECT DBS-->


<!-- END LINUXMALWAREDETECT -->


<!-- START YARARULES -->
<cfquery name = "yararulesconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'yararules'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #yararulesconf.enabled# is "true">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-UPDATE","#yararulesconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #yararulesconf.enabled# is "false">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-UPDATE","#yararulesconf.update_int#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-ENABLED","no","ALL")#" addnewline="no">

<!-- /CFIF yararulesCONF.enabled -->
</cfif>

<!-- START YARRARULES DBS-->
<cfquery name = "yararulesdbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'yararules' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_yararulesdbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="yararulesdbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_yararulesdbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_yararulesdbs" variable="yararulesdbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-DBS","#yararulesdbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_yararulesdbs")>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_yararulesdbs">
    
</cfif>   
    
<!-- END YARRARULES DBS-->

<!-- END YARARULES -->

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_user.conf")>

<cfexecute name = "/bin/cp"
arguments="/etc/clamav-unofficial-sigs/user.conf /etc/clamav-unofficial-sigs/user.HERMES"
timeout = "60">
</cfexecute>

<cfexecute name = "/bin/cp"
arguments="/opt/hermes/tmp/#customtrans3#_user.conf /etc/clamav-unofficial-sigs/user.conf"
timeout = "60">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf">

<cfquery name="updatedatabases" datasource="#datasource#">
update malware_databases set applied = '1'
</cfquery>


<cfset m=7>

<cfelse>

<cfset m=8>

<!-- /CFIF FileExists /opt/hermes/tmp/#customtrans3#_user.conf -->
</cfif>


<!-- /CFIF action-->
</cfif>

<table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion11" style="background-image: url('file:///C:/Users/dino.edwards/Dropbox/graphics/hermes/background_635_middle.png'); height: 330px;" </readonly>

                            <table border="0" cellspacing="0" cellpadding="0" width="964" id="LayoutRegion11" style="height: 254px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <input type="hidden" name="action" value="Save Settings">
                                    <table border="0" cellspacing="0" cellpadding="0" width="964">
                                      <tr valign="top" align="left">
                                        <td width="964" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Secure Portal Address cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Encryption by e-mail subject keyword field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Settings Applied. If any databases were added or deleted the changes will not take effect until the next scheduled database update. Database updates times vary. </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;An error occured while setting up user.conf file. Please contact support for assistance</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;There are unapplied changes in the Malware Databases. Please click on the Apply Settings button on the bottom of this page.</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="964"><form name="edit" action="encryption_settings.cfm" method="post">
                                          <table id="Table70" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 41px;">
                                            <tr style="height: 14px;">
                                              <td width="960" id="Cell469">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">YaraRules Feed</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 38px;">
                                              <td id="Cell468">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table80" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 38px;">
                                                        <tr style="height: 19px;">
                                                          <td width="45" id="Cell470">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #yararules# is "true">
<cfoutput>
<input type="radio" checked="checked" name="yararules" value="true" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #yararules# is "false">
<cfoutput>
<input type="radio" name="yararules" value="true" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="438" id="Cell471">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell472">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #yararules# is "true">
<cfoutput>
<input type="radio" name="yararules" value="false" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #yararules# is "false">
<cfoutput>
<input type="radio" checked="checked" name="yararules" value="false" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell473">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1032">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">YaraRules Database Update Interval <span style="font-weight: normal;">(Default is 24 Hours for a total of 1 downloads a day. Change with caution, changing the interval can get you banned)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1031">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #update_int# is "1">
<select name="update_int" style="height: 24px;">
    <option value="1" selected="selected">1 Hour</option>
  <option value="2">2 Hours</option>
  <option value="4">4 Hours</option>
  <option value="8">8 Hours</option>
  <option value="12">12 Hours</option>
  <option value="24">24 Hours</option>
</select>

<cfelseif #update_int# is "2">
<select name="update_int" style="height: 24px;">
    <option value="2" selected="selected">2 Hours</option>
  <option value="1">1 Hour</option>
  <option value="4">4 Hours</option>
  <option value="8">8 Hours</option>
  <option value="12">12 Hours</option>
  <option value="24">24 Hours</option>
</select>


<cfelseif #update_int# is "4">
<select name="update_int" style="height: 24px;">
    <option value="4" selected="selected">4 Hours</option>
  <option value="1">1 Hour</option>
  <option value="2">2 Hours</option>
  <option value="8">8 Hours</option>
  <option value="12">12 Hours</option>
  <option value="24">24 Hours</option>
</select>

<cfelseif #update_int# is "8">
<select name="update_int" style="height: 24px;">
    <option value="8" selected="selected">8 Hours</option>
  <option value="1">1 Hour</option>
  <option value="2">2 Hours</option>
  <option value="4">4 Hours</option>
  <option value="12">12 Hours</option>
  <option value="24">24 Hours</option>
</select>


<cfelseif #update_int# is "12">
<select name="update_int" style="height: 24px;">
    <option value="12" selected="selected">12 Hours</option>
  <option value="1">1 Hour</option>
  <option value="2">2 Hours</option>
  <option value="4">4 Hours</option>
  <option value="8">8 Hours</option>
  <option value="24">24 Hours</option>
</select>

<cfelseif #update_int# is "24">
<select name="update_int" style="height: 24px;">
    <option value="24" selected="selected">24 Hours</option>
  <option value="1">1 Hour</option>
  <option value="2">2 Hours</option>
  <option value="4">4 Hours</option>
  <option value="8">8 Hours</option>
  <option value="12">12 Hours</option>
</select>

</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          

</form></td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="964">
                                      <tr valign="top" align="left">
                                        <td height="30" colspan="3" valign="middle" width="964"><hr id="HRRule32" width="964" size="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="506" height="1"></td>
                                        <td width="453"></td>
                                        <td width="5"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="2" width="959" id="Text522" class="TextObject">
                                          <p style="text-align: center; margin-bottom: 0px;"><form name="adddatabase" action="add_signature_database.cfm" method="post">
 <input type="hidden" name="feed" value="yararules"> 


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Add YaraRules Database" style="height: 24px; width: 357px;">


&nbsp;</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  


</form>

&nbsp;</p>
                                        </td>
                                        <td></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="3" height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td height="30" colspan="3" valign="middle" width="964"><hr id="HRRule31" width="964" size="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="3" height="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="506" id="Text482" class="TextObject">
                                          <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">YaraRules Databases</span></b></p>
                                        </td>
                                        <td colspan="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="3" height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="3" width="964" id="Text521" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfquery name="getfp" datasource="#datasource#">
select distinct(fp) as thefp from malware_databases where feed = 'yararules'
</cfquery>

<cfquery name="checkdatabases" datasource="#datasource#">
select * from malware_databases where feed = 'yararules'
</cfquery>



<cfif #checkdatabases.recordcount# LT 1>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);  font-size: 12px;">No Databases found...</span></i></b></p>

<cfelseif #checkdatabases.recordcount# GTE 1>

<table id="Table71" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;" class="bottomBorder">
  <tr style="height: 14px;">
    
<td width="112" style="background-color: rgb(241,236,236);" id="Cell402">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Enabled</span></b></p>
    </td>

    <td width="48" style="background-color: rgb(241,236,236);" id="Cell764">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Database Name</span></b></p>
    </td>
    <td width="109" style="background-color: rgb(241,236,236);" id="Cell416">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Description</span></b></p>
    </td>
    
    <td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">False Positive Risk</span></b></p>
    </td>

<td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete (Check to Delete)</span></b></p>
    </td>



  </tr>

<cfloop query = "getfp">

<cfquery name="getdatabases" datasource="#datasource#">
select * from malware_databases where feed = 'yararules' and fp = '#thefp#'
</cfquery>

<cfoutput query="getdatabases">
  <tr style="height: 19px;">

<cfif #active# is "true">

<td align="center">
<input type="checkbox" name="cbox#id#" value="cbox_#id#" checked="checked" style="height: 13px; width: 13px;">
</td>

<cfelseif #active# is "false">

<td align="center">
<input type="checkbox" name="cbox#id#" value="cbox_#id#" style="height: 13px; width: 13px;">
</td>

</cfif>


    <td id="Cell406">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#db#</span></p>
    </td>

    <td id="Cell407">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#description#</span></p>
    </td>
   
<cfif #fp# is "low">
<td id="Cell408" style="background-color: rgb(0,255,0);">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(0,0,0);">LOW</span></p>
    </td>

<cfelseif #fp# is "medium">
<td id="Cell408" style="background-color: rgb(255,255,0);">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(0,0,0);">MEDIUM</span></p>
    </td>

<cfelseif #fp# is "high">
<td id="Cell408" style="background-color: rgb(255,0,0);">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(0,0,0);">HIGH</span></p>
    </td>

</cfif>

<td align="center">
<input type="checkbox" name="cboxdelete#id#" value="cboxdelete_#id#" style="height: 13px; width: 13px;">
</td>
    

  </tr>
</cfoutput>
</cfloop>
</table>
</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="3" height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="3" width="964" id="Text385" class="TextObject">
                                          <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please Wait...';this.form.submit();" value="Apply Settings" style="height: 24px; width: 200px;">
&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="7" valign="middle" width="968"><hr id="HRRule30" width="968" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="42"></td>
                          <td colspan="7" width="969">

                            <table border="0" cellspacing="0" cellpadding="0" width="969" id="LayoutRegion18" style="height: 42px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="969">
                                        <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
                                          <tr style="height: 28px;">
                                            <td width="969" id="Cell1025">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="302" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><form name="antivirussignfeeds" action="antivirus_signature_feeds.cfm" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Antivirus Signature Feeds" style="height: 24px; width: 357px;">


&nbsp;</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  


</form>

&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
                
           </td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><cfset theYear=#DateFormat(Now(),"yyyy")#>
<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>
<cfquery name="getbuild" datasource="#datasource#">
SELECT value from system_settings where parameter = 'build_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
   