<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DKIM Sender Bypass</title>
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
              <td height="751" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion28" style="background-image: url('./middle_988.png'); height: 751px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="523">
                              <tr valign="top" align="left">
                                <td width="17" height="18"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text489" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">DKIM Sender Bypass</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="447">
                              <tr valign="top" align="left">
                                <td width="422" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/dkim-sender-bypass/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="17" height="2"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="color: rgb(255,0,0);">I<b>mportant:</b></span> The settings below will have no effect unless <b>DKIM</b> (<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">DomainKeys Identified Mail Checks</span></b><b>)</b> is set to <b>enabled</b> under <a href="./perimeter_configuration.cfm"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Content Checks --&gt; Perimenter Checks</span></b></a></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="16" height="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="504"></td>
                          <td width="2"></td>
                          <td width="438"></td>
                          <td width="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="6" valign="middle" width="947"><hr id="HRRule17" width="947" size="1"></td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="3" width="506" id="Text490" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add&nbsp; DKIM Sender Bypass</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="233"></td>
                          <td colspan="6" width="948"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "m4" default = "0">
<cfparam name = "step" default = "0">

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cfparam name = "note" default = ""> 
<cfif IsDefined("form.note") is "True">
<cfif form.note is not "">
<cfset note = form.note>
</cfif></cfif> 

<cfparam name = "dkim_entry" default = ""> 
<cfif IsDefined("form.dkim_entry") is "True">
<cfif form.dkim_entry is not "">
<cfset dkim_entry = form.dkim_entry>
</cfif></cfif> 

<cfparam name = "domain" default = ""> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif> 

<cfif #action# is "canceladd">
<cfquery name="canceldelete" datasource="#datasource#">
delete from dkim_bypass where action='insert' and applied='2'
</cfquery>
<cfset step=0>
<cfset m2=5>
<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
update dkim_bypass set action='NONE', applied='1' where action = 'delete' and applied = '2'
</cfquery>
<cfset step=0>
<cfset m1=5>
</cfif>

<script>

/*
Auto tabbing script- By JavaScriptKit.com
http://www.javascriptkit.com
This credit MUST stay intact for use
*/

function autotab(original,destination){
if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
destination.focus()
}

</script>
                            <table border="0" cellspacing="0" cellpadding="0" width="948" id="LayoutRegion5" style="height: 233px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text273" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Enter a Note identifying the entry,&nbsp; the Domain name&nbsp; you wish to bypass and click the Add button</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="794">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" width="794"><cfif #action# is "add">


<cfif #domain# is not "">
<cfset step=1>
<cfelseif #domain# is "">
<cfset step=0>
<cfset m2=1>
</cfif>


<cfif step is "1">
<cfset temp_email="bob@#domain#">
<cfif IsValid("email", temp_email)>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m2=2>

<!-- /CFIF IsValid("email", temp_email) -->
</cfif>

<!-- /CFIF step is "1" -->
</cfif>



<cfif step is "2">

<cfquery name="checkexists" datasource="#datasource#">
select * from dkim_bypass where entry='#domain#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into dkim_bypass
(entry, applied, note, action)
values
('#domain#', '2', '#note#', 'insert')
</cfquery>

<cfset m2=4>

<cfelse>
<cfset m2=3>

<!-- /CFIF for checkexists.recordcount -->
</cfif>

<!-- /CFIF for step is "2" -->
</cfif>

<!-- /CFIF for action -->
</cfif>


                                        <form name="host" action="dkim_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="544" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1051">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1052">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
</cfoutput>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="7"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="768"><cfoutput>
                                                <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="769" style="height: 40px;">
                                                  <tr style="height: 17px;">
                                                    <td width="254" id="Cell1033">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Domain name</span></p>
                                                    </td>
                                                    <td width="514" id="Cell1041">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell1042">
                                                      <table width="243" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="domain" size="30" maxlength="255" value="#domain#">
</cfoutput>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1050">
                                                      <table width="83" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" value="Add" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="948"><hr id="HRRule5" width="948" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="531">
                                    <tr valign="top" align="left">
                                      <td width="531" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="531" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">DKIM Sender Bypass Entries&nbsp; to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="948" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_dkimbypass" datasource="#datasource#">
select * from dkim_bypass where action='insert' and applied='2' order by entry asc
</cfquery>
<cfif #get_dkimbypass.recordcount# GTE 1>
<select name="dkim" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_dkimbypass">
<option value="#id#">#entry# ---> #note# --> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No DKIM Bypass Entries found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <form name="Table127FORM" action="dkim_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="canceladd">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="948" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="948" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_dkimbypass.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_dkimbypass.recordcount# LT 1>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Domain cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Domain you are attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Domain you attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Domain set to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="10" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="30"></td>
                          <td colspan="5" valign="middle" width="947"><hr id="HRRule14" width="947" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td colspan="2" width="506" id="Text419" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete DKIM Sender Bypass Entry</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="189"></td>
                          <td colspan="6" width="948"><cfif #action# is "delete">
<cfif #dkim_entry# is not "">
<cfset step=1>
<cfelseif #dkim_entry# is "">
<cfset step=0>
<cfset m1=1>
</cfif>

<cfif #step# is 1>
<cfquery name="delete" datasource="#datasource#">
update dkim_bypass set action ='delete', applied='2' where id='#dkim_entry#'
</cfquery>




<cfset m1=3>

</cfif>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="948" id="LayoutRegion4" style="height: 189px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="684">
                                    <tr valign="top" align="left">
                                      <td height="53" width="684">
                                        <form name="delete" action="dkim_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="delete">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="597">
                                                <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="597" style="height: 31px;">
                                                  <tr style="height: 24px;">
                                                    <td width="597" id="Cell7">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="left">
                                                            <table width="581" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfquery name="get_dkim_bypass" datasource="#datasource#">
select * from dkim_bypass where applied='1'
</cfquery>

<cfif #get_dkim_bypass.recordcount# GTE 1>

<p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select entry from the list below and click the <b>Delete</b> button to remove them
 from the DKIM Trusted Hosts listing</span></p>
 

<select name="dkim_entry" style="height: 88px;" size="60">
<cfoutput query="get_dkim_bypass">
<option value="#id#">#entry# ---> #note#</option>
</cfoutput>
</select>

<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No DKIM Bypass Entries Found ..</span></p>
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
                                                  <tr style="height: 24px;">
                                                    <td id="Cell1">
                                                      <table width="68" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #get_dkim_bypass.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td height="18"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="948"><hr id="HRRule7" width="948" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="609">
                                    <tr valign="top" align="left">
                                      <td width="531" height="3"></td>
                                      <td width="78"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="531" id="Text420" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">DKIM Sender Bypass Entries to be deleted</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="609" id="Text421" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_dkim_delete" datasource="#datasource#">
select * from dkim_bypass where action ='delete' and applied='2' order by entry asc
</cfquery>
<cfif #get_dkim_delete.recordcount# GTE 1>
<select name="dkimdelete" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_dkim_delete">
<option value="#id#">#entry# ---> #note# --> TO BE DELETED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No DKIM Bypass Entries Found to be deleted..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <form name="Table127FORM" action="dkim_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="canceldelete">
                                          <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="948" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="948" id="Cell739">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_dkim_delete.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_dkim_delete.recordcount# LT 1>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry to delete before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Entry marked for deletion. Please click the Apply Settings button below to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="5" valign="middle" width="947"><hr id="HRRule15" width="947" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="63"></td>
                          <td colspan="5" width="946"><cfif #action# is "apply">

<cfquery name="updateinsert" datasource="#datasource#">
update dkim_bypass set applied='1', action='NONE' where applied='2' and action='insert'
</cfquery>


<cfquery name="updatedelete" datasource="#datasource#">
delete from dkim_bypass where applied='2' and action='delete'
</cfquery>


<cfquery name="get" datasource="#datasource#">
select entry from dkim_bypass
</cfquery>

<cfset FileData = "">
<cfloop query="get">
<cfset FileData = FileData & get.entry &#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/opt/hermes/dkim/ExemptDomains" output = "#FileData#" addnewline="no">

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


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_restart_opendkim.sh"
    output = "/usr/sbin/service opendkim reload#chr(10)#/usr/sbin/service opendkim restart" addnewline="no">


<cfexecute name ="/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_restart_opendkim.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_restart_opendkim.sh"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_restart_opendkim.sh">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_restart_postfix.sh"
    output = "/usr/sbin/service postfix reload#chr(10)#/usr/sbin/service postfix restart" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_restart_postfix.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_restart_postfix.sh"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_restart_postfix.sh">





<cflocation url="dkim_sender_bypass.cfm" addToken = "no">
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="946" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="946">
                                        <form name="apply_settings" action="dkim_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="apply">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="946" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="946" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from dkim_bypass where applied='2'
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="946">
                                    <tr valign="top" align="left">
                                      <td width="946" height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="946" id="Text330" class="TextObject">
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
                          <td colspan="3"></td>
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