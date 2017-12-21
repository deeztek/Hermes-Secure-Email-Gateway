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
<title>RBL Configuration</title>
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
<script type="text/javascript">
<!--
var hwndPopup_27b5;
function openpopup_27b5(url){
var popupWidth = 900;
var popupHeight = 780;
var popupTop = 300;
var popupLeft = 300;
var isFullScreen = false;
var isAutoCenter = false;
var popupTarget = "popupwin_27b5";
var popupParams = "toolbar=0, scrollbars=1, menubar=0, status=0, resizable=0";

if (isFullScreen) {
	popupParams += ", fullscreen=1";
} else if (isAutoCenter) {
	popupTop	= parseInt((window.screen.height - popupHeight)/2);
	popupLeft	= parseInt((window.screen.width - popupWidth)/2);
}

var ua = window.navigator.userAgent;
var isMac = (ua.indexOf("Mac") > -1);

//IE 5.1 PR on OSX 10.0.x does not support relative URLs in pop-ups the way they're handled below w/ document.writeln
if (isMac && url.indexOf("http") != 0) {
  url = location.href.substring(0,location.href.lastIndexOf('\/')) + "/" + url;
}

var isOpera = (ua.indexOf("Opera") > -1);
var operaVersion;
if (isOpera) {
	var i = ua.indexOf("Opera");
	operaVersion = parseFloat(ua.substring(i + 6, ua.indexOf(" ", i + 8)));
	if (operaVersion > 7.00) {
		var isAccessible = false;
		eval("try { isAccessible = ( (hwndPopup_27b5 != null) && !hwndPopup_27b5.closed ); } catch(exc) { } ");
		if (!isAccessible) {
			hwndPopup_27b5 = null;
		}
	}
}
if ( (hwndPopup_27b5 == null) || hwndPopup_27b5.closed ) {
	
	if (isOpera && (operaVersion < 7)) {
		if (url.indexOf("http") != 0) {
			hwndPopup_27b5 = window.open(url,popupTarget,popupParams + ((!isFullScreen) ? ", width=" + popupWidth +", height=" + popupHeight : ""));
			if (!isFullScreen) {
				hwndPopup_27b5.moveTo(popupLeft, popupTop);
			}
			hwndPopup_27b5.focus();
			return;
		}
	}
	if (!(window.navigator.appName == "Netscape" && !document.getElementById)) {
		//not ns4
		popupParams += ", width=" + popupWidth +", height=" + popupHeight + ", left=" + popupLeft + ", top=" + popupTop;
	} else {
		popupParams += ", left=" + popupLeft + ", top=" + popupTop;
	}
	//alert(popupParams);
	hwndPopup_27b5 = window.open("",popupTarget,popupParams);
	if (!isFullScreen) {
		hwndPopup_27b5.resizeTo(popupWidth, popupHeight);
		hwndPopup_27b5.moveTo(popupLeft, popupTop);
	}
	hwndPopup_27b5.focus();
	with (hwndPopup_27b5.document) {
		open();
    		write("<ht"+"ml><he"+"ad><\/he"+"ad><bo"+"dy onLoad=\"window.location.href='" + url + "'\"><\/bo"+"dy><\/ht"+"ml>");
		close();
	}
} else {
	if (isOpera && (operaVersion > 7.00)) {
		eval("try { hwndPopup_27b5.focus();	hwndPopup_27b5.location.href = url; } catch(exc) { hwndPopup_27b5 = window.open(\""+ url +"\",\"" + popupTarget +"\",\""+ popupParams + ", width=" + popupWidth +", height=" + popupHeight +"\"); } ");
	} else {
		hwndPopup_27b5.focus();
		hwndPopup_27b5.location.href = url;
	}
}

}

-->
</script>
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
              <td height="750" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion26" style="background-image: url('./middle_988.png'); height: 750px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="520">
                              <tr valign="top" align="left">
                                <td width="14" height="15"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text483" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">RBL Configuration</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text484" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Realtime Block/Allow Lists</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="450">
                              <tr valign="top" align="left">
                                <td width="425" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/rbl-configuration/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="13" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="341"></td>
                          <td width="952"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "show_type" default = "block"> 
<cfif IsDefined("url.type") is "True">
<cfif url.type is not "">
<cfset show_type = url.type>
</cfif></cfif> 

<cfparam name = "show_list" default = ""> 
<cfif IsDefined("form.list") is "True">
<cfif form.list is not "">
<cfset show_list = form.list>
</cfif></cfif> 

<cfparam name = "weight" default = ""> 
<cfif IsDefined("form.weight") is "True">
<cfif form.weight is not "">
<cfset weight = form.weight>
</cfif></cfif>

<cfparam name = "options" default = ""> 
<cfif IsDefined("form.options") is "True">
<cfif form.options is not "">
<cfset options = form.options>
</cfif></cfif>

<cfquery name="get_smtpd_recipient_restrictions_id" datasource="#datasource#">
select id from parameters where parameter='smtpd_recipient_restrictions' and child = '2'
</cfquery>

<cfquery name="get_reject_rbl_client" datasource="#datasource#">
select * from parameters where parameter like '%reject_rbl_client%' and child = '1'  and parent='#get_smtpd_recipient_restrictions_id.id#' and applied='1' order by order1 asc
</cfquery>

<cfquery name="get_permit_dnswl_client" datasource="#datasource#">
select * from parameters where parameter like '%permit_dnswl_client%' and child = '1'  and parent='#get_smtpd_recipient_restrictions_id.id#' and applied='1' order by order1 asc
</cfquery>

<cfquery name="get_postscreen_dnsbl_sites_id" datasource="#datasource#">
select id from parameters where parameter='postscreen_dnsbl_sites' and child = '2'
</cfquery>

<cfquery name="get_postscreen_dnsbl_sites" datasource="#datasource#">
select * from parameters where child = '1'  and parent='#get_postscreen_dnsbl_sites_id.id#' and applied='1' order by order1 asc
</cfquery>

<cfif #action# is "canceladd">
<cfquery name="canceladd" datasource="#datasource#">
delete from parameters where action='insert' and applied='2' and parent='#get_postscreen_dnsbl_sites_id.id#'   
</cfquery>
<cfquery name="canceladd" datasource="#datasource#">
delete from parameters where action='insert' and applied='2' and parent='#get_smtpd_recipient_restrictions_id.id#'   
</cfquery>
<cflocation url="rbl.cfm?m2=7">

<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
update parameters set action='NONE', applied='1' where action='delete' and applied='2' and parent='#get_postscreen_dnsbl_sites_id.id#'  
</cfquery>
<cfquery name="canceldelete" datasource="#datasource#">
update parameters set action='NONE', applied='1' where action='delete' and applied='2' and parent='#get_smtpd_recipient_restrictions_id.id#'  
</cfquery>
<cflocation url="rbl.cfm?m1=3##delete">
</cfif>




                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion5" style="height: 341px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text273" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select the type of entry (<b>Block List</b> or<b> Allow List</b>) you wish to add below and proceed adding your entry into the Real Time Block/Allow Lists. </span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="608">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="rbl.cfm?type=block" method="post">
                                                  <td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "block">
<cfoutput>
<input type="radio" name="type" value="block" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="block" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Block List</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="rbl.cfm?type=allow" method="post">
                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "allow">
<cfoutput>
<input type="radio" name="type" value="allow" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="allow" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Allow List</span></p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="11"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text310" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">When adding a <b>weight</b> for a <b>Block List</b> ensure the weight is a positive integer Ex. <b>4</b></span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="617">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="40" width="617"><cfif #show_type# is "block">
<cfif #action# is "add">

<cfif #show_list# is "">
<cfset step=0>
<cfset m2=2>
<cfelseif #show_list# is not "">
<cfset temp_email="bob@#show_list#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=1>
</cfif>
</cfif>

<cfif step is "1">
<cfif #weight# is not "">
<cfif isValid("regex", weight, "^{0,1}[1-9]+[\d]*")>
<cfset step=2>
<cfelseif NOT isValid("regex", weight, "^{0,1}[1-9]+[\d]*")>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #weight# is "">
<cfset step=2>
</cfif>
</cfif>

<cfif step is "2">

<cfquery name="checkexists" datasource="#datasource#">
select * from parameters where parameter like '%#list#%' and child='1'
</cfquery>


<cfif #checkexists.recordcount# LT 1>
<cfquery name="getmaxorder" datasource="#datasource#">
SELECT max(order1) as maximum FROM `parameters` where parent='#get_smtpd_recipient_restrictions_id.id#' and parameter like '%reject_rbl_client%'and child='1'
</cfquery>

<cfif #getmaxorder.maximum# is "">
<cfset max=1>
<cfelse>
<cfset max=#getmaxorder.maximum#>
</cfif>

<cfquery name="getmaxorder2" datasource="#datasource#">
SELECT max(order1) as maximum FROM `parameters` where parent='#get_postscreen_dnsbl_sites_id.id#' and child='1'
</cfquery>

<cfif #getmaxorder2.maximum# is "">
<cfset max2=0>
<cfelse>
<cfset max2=#getmaxorder2.maximum#>
</cfif>


<cfset nextup=#max#>
<cfset nextup2=#max2#+1>

<cfif #weight# is not "">
<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('reject_rbl_client #list#', 'postfix', '1', 'main.cf', '#get_smtpd_recipient_restrictions_id.id#', '1', '#nextup#', '2', '#weight#', '2', 'insert')
</cfquery>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('#list#*#weight#', 'postfix', '1', 'main.cf', '#get_postscreen_dnsbl_sites_id.id#', '1', '#nextup2#', '1', '#weight#', '2', 'insert')
</cfquery>

<cfelseif #weight# is "">
<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('reject_rbl_client #list#', 'postfix', '1', 'main.cf', '#get_smtpd_recipient_restrictions_id.id#', '1', '#nextup#', '2', '1', '2', 'insert')
</cfquery>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('#list#', 'postfix', '1', 'main.cf', '#get_postscreen_dnsbl_sites_id.id#', '1', '#nextup2#', '1', '1', '2', 'insert')
</cfquery>
</cfif>

<cfset m2=6>
<cflocation url="rbl.cfm?m2=6">

<cfelse>
<cfset m2=5>
</cfif>
</cfif>
</cfif>
</cfif>


                                        <form name="octet4" action="rbl.cfm?action=add&type=block" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="547"><cfoutput>
                                                <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                                  <tr style="height: 17px;">
                                                    <td width="210" id="Cell572">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Block List</span></p>
                                                    </td>
                                                    <td width="87" id="Cell571">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Weight </span></p>
                                                    </td>
                                                    <td width="250" id="Cell570">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell561">
                                                      <table width="196" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "block">
<input type="text" name="list" size="25" maxlength="255" style="width: 196px; white-space: pre;" value="#show_list#">
<cfelseif #show_type# is "allow">
<input type="text" name="list" size="25" maxlength="255" style="width: 196px; white-space: pre;" value="#show_list#" disabled="disabled">
</cfif>

&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell569">
                                                      <table width="72" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "block">
<input type="text" name="weight" size="9" maxlength="3" style="width: 68px; white-space: pre;" value="#weight#">
<cfelseif #show_type# is "allow">
<input type="text" name="weight" size="9" maxlength="3" style="width: 68px; white-space: pre;" value="#weight#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell568">
                                                      <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "block">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;">
<cfelseif #show_type# is "allow">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="14"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text309" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">When adding a weight for an <b>Allow List, </b>ensure the weight is a negative integer Ex. <b>-4. </b>Allow lists can also accept Arguments such as <b>=127.[0..255].[0..255].[2..255]</b>. Arguments are not required and greatly depend on the Allow List you are using.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="617">
                                    <tr valign="top" align="left">
                                      <td height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="40" width="617"><cfif #show_type# is "allow">
<cfif #action# is "add">

<cfif #show_list# is "">
<cfset step=0>
<cfset m3=2>
<cfelseif #show_list# is not "">
<cfset temp_email="bob@#show_list#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m3=1>
</cfif>
</cfif>

<cfif step is "1">
<cfif #weight# is not "">
<cfif isValid("regex", weight, "^-{0,1}[1-9]+[\d]*")>
<cfset step=2>
<cfelseif NOT isValid("regex", weight, "^-{0,1}[1-9]+[\d]*")>
<cfset step=0>
<cfset m3=3>
</cfif>
<cfelseif #weight# is "">
<cfset step=2>
</cfif>
</cfif>

<cfif step is "2">

<cfif #options# is "">
<cfquery name="checkexists" datasource="#datasource#">
select * from parameters where parameter = '#list#' and parent='#get_postscreen_dnsbl_sites_id.id#' and child='1'
</cfquery>

<cfelseif #options# is not "">
<cfquery name="checkexists" datasource="#datasource#">
select * from parameters where parameter = '#list##options#' and parent='#get_postscreen_dnsbl_sites_id.id#' and child='1'
</cfquery>
</cfif>

<cfif #checkexists.recordcount# LT 1>
<cfquery name="getmaxorder" datasource="#datasource#">
SELECT max(order1) as maximum FROM `parameters` where parent='#get_smtpd_recipient_restrictions_id.id#' and parameter like '%reject_rbl_client%'and child='1'
</cfquery>

<cfif #getmaxorder.maximum# is "">
<cfset max=1>
<cfelse>
<cfset max=#getmaxorder.maximum#>
</cfif>

<cfquery name="getmaxorder2" datasource="#datasource#">
SELECT max(order1) as maximum FROM `parameters` where parent='#get_postscreen_dnsbl_sites_id.id#' and child='1'
</cfquery>

<cfif #getmaxorder2.maximum# is "">
<cfset max2=0>
<cfelse>
<cfset max2=#getmaxorder2.maximum#>
</cfif>


<cfset nextup=#max#>
<cfset nextup2=#max2#+1>

<cfif #weight# is not "" and #options# is not "">
<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('permit_dnswl_client #list##options#', 'postfix', '1', 'main.cf', '#get_smtpd_recipient_restrictions_id.id#', '1', '#nextup#', '2', '#weight#', '2', 'insert')
</cfquery>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('#list##options#*#weight#', 'postfix', '1', 'main.cf', '#get_postscreen_dnsbl_sites_id.id#', '1', '#nextup2#', '1', '#weight#', '2', 'insert')
</cfquery>

<cfelseif #weight# is not "" and #options# is "">
<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('permit_dnswl_client #list#', 'postfix', '1', 'main.cf', '#get_smtpd_recipient_restrictions_id.id#', '1', '#nextup#', '2', '#weight#', '2', 'insert')
</cfquery>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('#list#*#weight#', 'postfix', '1', 'main.cf', '#get_postscreen_dnsbl_sites_id.id#', '1', '#nextup2#', '1', '#weight#', '2', 'insert')
</cfquery>

<cfelseif #weight# is "" and #options# is not "">
<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('permit_dnswl_client #list##options#', 'postfix', '1', 'main.cf', '#get_smtpd_recipient_restrictions_id.id#', '1', '#nextup#', '2', '1', '2', 'insert')
</cfquery>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('#list##options#', 'postfix', '1', 'main.cf', '#get_postscreen_dnsbl_sites_id.id#', '1', '#nextup2#', '1', '1', '2', 'insert')
</cfquery>

<cfelseif #weight# is "" and #options# is "">
<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('permit_dnswl_client #list#', 'postfix', '1', 'main.cf', '#get_smtpd_recipient_restrictions_id.id#', '1', '#nextup#', '2', '1', '2', 'insert')
</cfquery>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
values
('#list#', 'postfix', '1', 'main.cf', '#get_postscreen_dnsbl_sites_id.id#', '1', '#nextup2#', '1', '1', '2', 'insert')
</cfquery>

</cfif>

<cfset m3=6>
<cflocation url="rbl.cfm?m3=6">

<cfelse>
<cfset m3=5>
</cfif>
</cfif>
</cfif>
</cfif>


                                        <form name="octet4" action="rbl.cfm?action=add&type=allow" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="569"><cfoutput>
                                                <table id="Table102" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 40px;">
                                                  <tr style="height: 17px;">
                                                    <td width="208" id="Cell579">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Allow List</span></p>
                                                    </td>
                                                    <td width="207" id="Cell585">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Arguments</span></p>
                                                    </td>
                                                    <td width="83" id="Cell580">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Weight </span></p>
                                                    </td>
                                                    <td width="71" id="Cell581">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell582">
                                                      <table width="196" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "allow">
<input type="text" name="list" size="25" maxlength="255" style="width: 196px; white-space: pre;" value="#show_list#">
<cfelseif #show_type# is "block">
<input type="text" name="list" size="25" maxlength="255" style="width: 196px; white-space: pre;" value="#show_list#" disabled="disabled">
</cfif>

&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell586">
                                                      <table width="196" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "allow">
<input type="text" name="options" size="25" maxlength="255" style="width: 196px; white-space: pre;" value="#options#">
<cfelseif #show_type# is "block">
<input type="text" name="options" size="25" maxlength="255" style="width: 196px; white-space: pre;" value="#options#" disabled="disabled">
</cfif>

&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell583">
                                                      <table width="72" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "allow">
<input type="text" name="weight" size="9" maxlength="3" style="width: 68px; white-space: pre;" value="#weight#">
<cfelseif #show_type# is "block">
<input type="text" name="weight" size="9" maxlength="3" style="width: 68px; white-space: pre;" value="#weight#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell584">
                                                      <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "allow">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;">
<cfelseif #show_type# is "block">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="952"><hr id="HRRule1" width="952" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="290">
                                    <tr valign="top" align="left">
                                      <td width="290" height="12"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Realtime Block/Allow List(s)&nbsp; to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="952" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters2" datasource="#datasource#">
select * from parameters where action='insert' and applied='2' and parent='#get_postscreen_dnsbl_sites_id.id#' order by parameter asc
</cfquery>
<cfif #get_parameters2.recordcount# GTE 1>
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters2">
<option value="#id#">#parameter# ---> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Realtime Block/Allow List(s) found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952">
                                        <form name="Table127FORM" action="rbl.cfm?action=canceladd" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="952" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_parameters2.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_parameters2.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" disabled="disabled">
</cfif>&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Block List you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Block List cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Weight you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Weight cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Block List you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Block List ready to be added. Please click the Apply Settings to add the Block List to the system and apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Allow List you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Allow List cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Weight you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Weight cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Allow List you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Allow List ready to be added. Please click the Apply Settings to add the Allow List to the system and apply your changes</span></i></b></p>
</cfoutput>
</cfif>

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
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="953"><hr id="HRRule8" width="953" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="517">
                        <tr valign="top" align="left">
                          <td width="11" height="2"></td>
                          <td width="506"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text415" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete Realtime Block/Allow Lists</span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="189"></td>
                          <td width="954"><cfparam name = "rbl_entry" default = ""> 
<cfif IsDefined("form.rbl") is "True">
<cfif form.rbl is not "">
<cfset rbl_entry = form.rbl>
</cfif></cfif> 


<cfif #action# is "delete">
<cfif #rbl_entry# is not "">
<cfset step=1>
<cfelseif #rbl_entry# is "">
<cfset step=0>
<cfset m1=1>
</cfif>


<cfif #step# is "1">
<cfquery name="delete" datasource="#datasource#">
update parameters set applied='2', action='delete' where parameter like '%#rbl_entry#%'
</cfquery>

<cfset m1=2>
<cflocation url="rbl.cfm?m1=2##delete">
</cfif>
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion4" style="height: 189px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text272" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select entry from the list below and click the <b>Delete</b> button to remove a particular list. <b>NOTE</b>: The lists are shown with the weight assigned to each particular list.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="664">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="50" width="664">
                                        <form name="delete" action="rbl.cfm?action=delete" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="614">
                                                <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 50px;">
                                                  <tr style="height: 24px;">
                                                    <td width="614" id="Cell7">
                                                      <table width="614" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">
<select name="rbl" style="height: 88px;" size="300">
<option value="-666">==== BLOCK LISTS ====</option>
<cfoutput query="get_reject_rbl_client">
<option value="#trim(ListGetAt(parameter, 2, " "))#">#trim(ListGetAt(parameter, 2, " "))# // #weight#</option>
</cfoutput>
<option value="-666">==== ALLOW LISTS ====</option>
<cfoutput query="get_permit_dnswl_client">
<option value="#trim(ListGetAt(parameter, 2, " "))#">#trim(ListGetAt(parameter, 2, " "))# // #weight#</option>
</cfoutput>
</select>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 26px;">
                                                    <td id="Cell1">
                                                      <table width="68" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="954"><hr id="HRRule6" width="954" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="290">
                                    <tr valign="top" align="left">
                                      <td width="290" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text416" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Realtime Block/Allow List(s)&nbsp; to be deleted</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="954" id="Text417" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters2" datasource="#datasource#">
select * from parameters where action='delete' and applied='2' and parent='#get_postscreen_dnsbl_sites_id.id#' order by parameter asc
</cfquery>
<cfif #get_parameters2.recordcount# GTE 1>
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters2">
<option value="#id#">#parameter# ---> TO BE DELETED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Real Block/Allow List(s) found to be deleted..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954">
                                        <form name="Table127FORM" action="rbl.cfm?action=canceldelete" method="post">
                                          <table id="Table151" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="954" id="Cell875">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_parameters2.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_parameters2.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" disabled="disabled">
</cfif>&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Block/Allow List ready to be deleted. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="963">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td width="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td valign="middle" width="952"><hr id="HRRule9" width="952" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="63"></td>
                          <td colspan="2" width="953"><cfif #action# is "apply">
<cfquery name="checkdelete" datasource="#datasource#">
delete from parameters where applied='2' and action='delete'
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


<cfquery name="getmainparams" datasource="#datasource#">
select distinct(parameter), id, description, child, editable, enabled, conf_file from parameters where enabled='1' and child <> '1' and module='postfix'
</cfquery>

<cfloop query="getmainparams">
<cfoutput>
<cfquery name="getchildren" datasource="#datasource#">
select * from parameters where child='1' and parent = '#getmainparams.id#' and enabled = '1' order by order1 asc
</cfquery>

<cfquery name="insert" datasource="#datasource#">
insert into command 
(command, trans_id)
values
('/usr/sbin/postconf -e "#getmainparams.parameter# = #ValueList(getchildren.parameter,", ")#"#chr(10)#', '#customtrans3#')
</cfquery>

</cfoutput>
</cfloop> 

<cfquery name="getcommand" datasource="#datasource#">
select * from command where trans_id = '#customtrans3#'
</cfquery>

<cffile action = "write" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/postfix/main.cf /etc/postfix/main.cf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cfoutput query="getcommand">

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "#command#"
addnewline="no">

</cfoutput>

<cfquery name="deletecommand" datasource="#datasource#">
delete from command where trans_id = '#customtrans3#'
</cfquery>

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/usr/sbin/postfix reload#chr(10)#/etc/init.d/postfix restart"
addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /var/www/tasks/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/var/www/tasks/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/var/www/tasks/#customtrans3#_apply.sh">    

<cfquery name="updateparams" datasource="#datasource#">
update parameters set applied='1', action='NONE' where applied = '2'
</cfquery>

<cflocation url="rbl.cfm?action=applied##apply">
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="953">
                                        <form name="apply_settings" action="rbl.cfm?action=apply" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="953" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters where applied='2' and parent='#get_postscreen_dnsbl_sites_id.id#' 
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
</cfif>&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="953">
                                    <tr valign="top" align="left">
                                      <td width="953" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="953" id="Text330" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "applied">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>



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