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
<title>Publish Key</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
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
<body style="background-color: rgb(192,192,192); background-repeat: repeat; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./top_blue_3.png'); height: 131px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="709">
                        <tr valign="top" align="left">
                          <td width="45" height="92"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="13"></td>
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="483" width="988"><cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
<cfparam name = "m" default = "0">

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "10"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>


<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif></cfif>

<CFPARAM NAME="action" DEFAULT="">
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfif NOT IsDefined('url.type')>
<cfquery name="getkeyservers" datasource="#datasource#">
select * from pgp_keyservers order by keyserver asc
</cfquery>

<cfif #getkeyservers.recordcount# GTE 1>

<cfquery name="getkeydetails" datasource="#datasource#">
select user_id, pgp_key_id from recipient_keystores where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfquery name="getinfo" datasource="#datasource#">
select recipient from recipients where id='#getkeydetails.user_id#'
</cfquery>

<cfif #getinfo.recordcount# GTE 1>

<cfset type=1>

<cfelseif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getinfo.recordcount -->
</cfif>

<cfelseif #getkeyservers.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getkeyservers.recordcount -->
</cfif>

<cfelseif IsDefined('url.type')>

<cfif #url.type# is not "2">
<cfquery name="getkeyservers" datasource="#datasource#">
select * from pgp_keyservers order by keyserver asc
</cfquery>

<cfif #getkeyservers.recordcount# GTE 1>

<cfquery name="getkeydetails" datasource="#datasource#">
select user_id, pgp_key_id from recipient_keystores where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfquery name="getinfo" datasource="#datasource#">
select recipient from recipients where id='#getkeydetails.user_id#'
</cfquery>

<cfif #getinfo.recordcount# GTE 1>

<cfset type=1>

<cfelseif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getinfo.recordcount -->
</cfif>

<cfelseif #getkeyservers.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getkeyservers.recordcount -->
</cfif>

<cfelseif #url.type# is "2">

<cfquery name="getkeyservers" datasource="#datasource#">
select * from pgp_keyservers order by keyserver asc
</cfquery>

<cfif #getkeyservers.recordcount# GTE 1>

<cfquery name="getkeydetails" datasource="#datasource#">
select user_id, pgp_key_id from recipient_keystores where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfquery name="getinfo" datasource="#datasource#">
select email as recipient from external_recipients where id='#getkeydetails.user_id#'
</cfquery>


<cfif #getinfo.recordcount# GTE 1>

<cfset type=2>


<cfelseif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getinfo.recordcount -->
</cfif>

<cfelseif #getkeyservers.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">

<!-- /CFIF for getkeyservers.recordcount -->
</cfif>

<!-- /CFIF for url.type -->
</cfif>

<!-- /CFIF for IsDefined('url.type') -->
</cfif>


<cfif #action# is "publish">

<cfset ResultsArray = arrayNew(1)>

<!-- PUBLISH GPG KEY STARTS HERE -->
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset theId = listGetAt(form[thefield], 2, "_")>

<cfquery name="getkeyservername" datasource="#datasource#">
select keyserver from pgp_keyservers where id = '#theId#' 
</cfquery>

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


<cffile action="read" file="/opt/hermes/scripts/publish_pgp_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
    output = "#REReplace("#temp#","THE_KEY_ID","#getkeydetails.pgp_key_id#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
    output = "#REReplace("#temp#","THE-KEY-SERVER","#getkeyservername.keyserver#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
timeout = "240"
variable="publishresults"
arguments="-inputformat none">
</cfexecute>

<!-- delete /opt/hermes/tmp//opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


<!-- PUBLISH GPG KEY ENDS HERE -->


<CFSET TheResults=ArrayAppend(ResultsArray, #publishresults#) />    

</cfoutput>


<!-- /CFIF thefield contains cbox -->
</cfif>

</cfloop>

<cfoutput>
<cfset br = "#chr(13)##chr(10)#">
</cfoutput>
<cfset ArrayList = ArrayToList(ResultsArray,br)>

<cfif FindNoCase("keyserver send failed", ArrayList)> 

<cfset m=2>

<cfelseif #ArrayList# is "">
<cfset m=3>
<cfelse>
<cfset m=1>

<!-- /CFIF FindNoCase -->
</cfif>


<!-- /CFIF action -->
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 483px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="516">
                        <tr valign="top" align="left">
                          <td width="10" height="18"></td>
                          <td width="506"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Publish Recipient Public PGP Key</span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="10" height="1"></td>
                          <td width="957"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="957" id="Text215" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">The system will publish the PGP Public Key indicated below to any PGP Key Servers you select. By default, the system automatically selects all the PGP Key Servers in the inventory. If you wish to only publish to selected servers, select only the servers you wish to publish to below and click the <b>Publish Key</b> button. Once finished, click on the <b>Back to Recipient PGP Keyrings</b> button. </span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="10"></td>
                          <td width="957">
                            <form name="Table9FORM" action="" method="post">
                              <table id="Table9" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 10px;">
                                <tr style="height: 14px;">
                                  <td width="957" id="Cell408">
                                    <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
                                  </td>
                                </tr>
                                <tr style="height: 22px;">
                                  <cfoutput>
                                  <td id="Cell62">
                                    <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td align="center"><cfoutput><input type="text" id="FormsEditField5" name="email" size="35" maxlength="45" disabled="disabled" style="width: 276px; white-space: pre;" value="#getinfo.recipient#"></cfoutput></td>
                                        </tr>
                                      </table>
                                    </td>
                                    </cfoutput>
                                  </tr>
                                  <tr style="height: 14px;">
                                    <td id="Cell1034">
                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Key ID</span></b></p>
                                    </td>
                                  </tr>
                                  <tr style="height: 22px;">
                                    <td id="Cell1035">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td align="center"><cfoutput><input type="text" id="FormsEditField6" name="pgpkeyid" size="35" maxlength="45" disabled="disabled" style="width: 276px; white-space: pre;" value="#getkeydetails.pgp_key_id#"></cfoutput></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </form>
                            </td>
                          </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0" width="203">
                          <tr valign="top" align="left">
                            <td>
                              <table border="0" cellspacing="0" cellpadding="0" width="99">
                                <tr valign="top" align="left">
                                  <td width="10" height="1"></td>
                                  <td width="89"></td>
                                </tr>
                                <tr valign="top" align="left">
                                  <td height="17"></td>
                                  <td width="89" id="Text458" class="TextObject">
                                    <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('edit', true);" href="javascript:void();"><span style="font-size: 10px;">Select All</span></a></b><span style="font-size: 10px;"></span>&nbsp;</p>
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td>
                              <table border="0" cellspacing="0" cellpadding="0" width="104">
                                <tr valign="top" align="left">
                                  <td width="15" height="1"></td>
                                  <td width="89"></td>
                                </tr>
                                <tr valign="top" align="left">
                                  <td></td>
                                  <td width="89" id="Text462" class="TextObject">
                                    <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('edit', false);" href="javascript:void();"><span style="font-size: 10px;">None</span></a></b>&nbsp;</p>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
                        <table border="0" cellspacing="0" cellpadding="0" width="967">
                          <tr valign="top" align="left">
                            <td width="10" height="6"></td>
                            <td></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td height="76"></td>
                            <td width="957">
                              <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 76px;">
                                <tr align="left" valign="top">
                                  <td>
                                    <form name="edit" action="<cfoutput>publish_key.cfm?id=#url.id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                      <input type="hidden" name="action" value="publish">
                                      <table border="0" cellspacing="0" cellpadding="0" width="954">
                                        <tr valign="top" align="left">
                                          <td width="954" id="Text375" class="TextObject">
                                            <p style="text-align: center; margin-bottom: 0px;"><table border="0" cellspacing="4" cellpadding="0" width="954px" style="height: 102px;">
  <tr style="height: 14px;">
    <td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Key Server</span></b></p>
    </td>


<td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Note</span></b></p>
    </td>

        
  </tr>

<cfloop query="getkeyservers">
  <tr style="height: 36px;">

<cfoutput>


    <td  align="center">
     <input type="checkbox" name="cbox#id#" value="cbox_#id#" checked="checked">
    </td>


<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#keyserver#</span></p>
    </td>


<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#note#</span></p>
    </td>



    



</cfoutput>


</tr>         

</cfloop>
</table>

        
&nbsp;</p>
                                          </td>
                                        </tr>
                                      </table>
                                      <table border="0" cellspacing="0" cellpadding="0">
                                        <tr valign="top" align="left">
                                          <td height="4"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="957">
                                            <table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                              <tr style="height: 22px;">
                                                <td width="957" id="Cell435">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="206" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Sending, please wait...';this.form.submit();" name="FormsButton1" value="Publish Key" style="height: 24px; width: 144px;">&nbsp;</p>
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
                                      <table border="0" cellspacing="0" cellpadding="0" width="954">
                                        <tr valign="top" align="left">
                                          <td width="954" height="9"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="954" id="Text366" class="TextObject">
                                            <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Recient PGP Key was published to the specified Key Server(s)</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;An error occurred while publishing the PGP key to one or more Key Servers. The error appears below:<br><br>
#ArrayList#
</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;An error occurred while publishing the PGP key. No Key Servers were selected. Please select one or more servers and try again.<br><br>
#ArrayList#
</span></i></b></p>
</cfoutput>
</cfif>





&nbsp;</p>
                                          </td>
                                        </tr>
                                      </table>
                                    </form>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
                        <table border="0" cellspacing="0" cellpadding="0" width="968">
                          <tr valign="top" align="left">
                            <td width="10" height="1"></td>
                            <td width="1"></td>
                            <td width="955"></td>
                            <td width="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="2" height="30"></td>
                            <td colspan="2" valign="middle" width="957"><hr id="HRRule1" width="957" size="1"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="4" height="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td height="40"></td>
                            <td colspan="2" width="956">

                              <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                <tr align="left" valign="top">
                                  <td>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="9"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956">
                                          <form name="apply_settings" action="<cfoutput>view_pgp_keyrings.cfm?id=#getkeydetails.user_id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                            <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="956" id="Cell518">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="591" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Recipient PGP Keyrings" style="height: 24px; width: 357px;">
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
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr valign="top" align="left">
                <td height="49" width="988">
                  <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
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
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
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