<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>SPF Check Bypass</title>
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
              <td height="1283" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion27" style="background-image: url('./middle_988.png'); height: 1283px;">
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
                                <td width="506" id="Text485" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">SPF Check Bypass</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/spf-bypass/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="13" height="6"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="color: rgb(255,0,0);">I<b>mportant:</b></span> The settings below will have no effect unless <b>Sender Policy Framework (SPF) Checks</b> is set to <b>enabled</b> under <a href="./perimeter_configuration.cfm"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Content Checks --&gt; Perimenter Checks</span></b></a></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="952"><hr id="HRRule15" width="952" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="961">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="442"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text486" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add SPF Check Bypass Entry</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="710"></td>
                          <td colspan="2" width="948"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "m4" default = "0">
<cfparam name = "step" default = "0"> 

<!--- VALIDATE IP ADDRESS REGEX --->
<cfset pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

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

<cfparam name = "show_type" default = "ip"> 
<cfif IsDefined("form.type") is "True">
<cfif form.type is not "">
<cfset show_type = form.type>
</cfif></cfif> 

<cfparam name = "ip" default = ""> 
<cfif IsDefined("form.ip") is "True">
<cfif form.ip is not "">
<cfset ip = form.ip>
</cfif></cfif> 

<cfparam name = "network" default = ""> 
<cfif IsDefined("form.network") is "True">
<cfif form.network is not "">
<cfset network = form.network>
</cfif></cfif> 

<cfparam name = "helo" default = ""> 
<cfif IsDefined("form.helo") is "True">
<cfif form.helo is not "">
<cfset helo = form.helo>
</cfif></cfif> 

<cfparam name = "domain" default = ""> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif> 

<cfparam name = "ptr" default = ""> 
<cfif IsDefined("form.ptr") is "True">
<cfif form.ptr is not "">
<cfset ptr = form.ptr>
</cfif></cfif> 

<cfparam name = "subnet" default = ""> 
<cfif IsDefined("form.subnet") is "True">
<cfif form.subnet is not "">
<cfset subnet = form.subnet>
</cfif></cfif> 


<cfif #action# is "canceladd">
<cfquery name="canceldelete" datasource="#datasource#">
delete from spf_bypass where action='add' and applied='2'
</cfquery>
<cfset step=0>
<cfset m2=12>
<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
update spf_bypass set action='add', applied='1' where action='delete' and applied='2'
</cfquery>
<cfset step=0>
<cfset m1=5>
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="948" id="LayoutRegion5" style="height: 710px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text273" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Enter a Note identifying the entry,&nbsp; the IP, Network, HELO Host, Domain or PTR Doman entry you wish to add and click the Add button</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="710">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                      <td width="9"></td>
                                      <td width="93"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="108" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="spf_bypass.cfm" method="post">

                                                  <td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<cfoutput>
<input type="radio" name="type" value="ip" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="ip" style="height: 19px; width: 19px;" onclick="this.form.submit();"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">IP Address Bypass</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="spf_bypass.cfm" method="post">

                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<cfoutput>
<input type="radio" name="type" value="network" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="network" style="height: 19px; width: 19px;" onclick="this.form.submit();"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Network Address Bypass</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="spf_bypass.cfm" method="post">

                                                  <td id="Cell1036">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "helo">
<cfoutput>
<input type="radio" name="type" value="helo" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="helo" style="height: 19px; width: 19px;" onclick="this.form.submit();"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell1035">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">HELO Host Bypass</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="spf_bypass.cfm" method="post">

                                                  <td id="Cell1033">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "domain">
<cfoutput>
<input type="radio" name="type" value="domain" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="domain" style="height: 19px; width: 19px;" onclick="this.form.submit();"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell1034">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Domain Bypass</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="spf_bypass.cfm" method="post">

                                                  <td id="Cell1037">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "ptr">
<cfoutput>
<input type="radio" name="type" value="ptr" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="ptr" style="height: 19px; width: 19px;" onclick="this.form.submit();"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell1038">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">PTR Domain Bypass</span></p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td colspan="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="17"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="2" width="617"><cfif #show_type# is "ip">
<cfif #action# is "add">

<cfif #ip# is not "">
<cfif REFind(pattern,ip) GT 0>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m2=3>

<!--- /CFIF REFind --->
</cfif>

<cfelseif #ip# is "">
<cfset step=0>
<cfset m2=5>

<!--- /CFIF #ip# is --->
</cfif>


<cfif step is "1">
<cfset theEntry="#ip#">

<cfquery name="checkexists" datasource="#datasource#">
select * from spf_bypass where entry='#theEntry#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into spf_bypass
(entry_type, entry, action, applied, entry_note)
values
('#type#', '#theEntry#', 'add', '2', '#note#')
</cfquery>

<cfset m2=2>

<cfelse>
<cfset m2=1>

<!--- /CFIF #checkexists.recordcount# is --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<!--- /CFIF #action# is "add" --->
</cfif>

<!--- /CFIF #show_type# is "ip" --->
</cfif>



                                        <form name="ipoverride" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add"><input type="hidden" name="type" value="ip">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1027">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1028">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "ip">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
<cfelse>
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
</cfif>
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
                                              <td width="615"><cfoutput>
                                                <table id="Table93" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 40px;">
                                                  <tr style="height: 17px;">
                                                    <td width="256" id="Cell715">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">IP Address</span></p>
                                                    </td>
                                                    <td width="103" id="Cell708">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);"></span>&nbsp;</p>
                                                    </td>
                                                    <td width="256" id="Cell707">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell530">
                                                      <table width="246" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="ip" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#ip#">
<cfelse>
<input type="text" name="ip" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#ip#" disabled="disabled">
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell706">
                                                      <table width="78" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelse>
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell534">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="3" width="710"><cfif #show_type# is "network">
<cfif #action# is "add">

<cfif #network# is not "">
<cfif REFind(pattern,network) GT 0>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m2=3>

<!--- /CFIF REFind --->
</cfif>

<cfelseif #network# is "">
<cfset step=0>
<cfset m2=5>

<!--- /CFIF #network# is --->
</cfif>


<cfif step is "1">
<cfset theEntry="#network#/#subnet#">

<cfquery name="checkexists" datasource="#datasource#">
select * from spf_bypass where entry='#theEntry#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into spf_bypass
(entry_type, entry, action, applied, entry_note)
values
('#type#', '#theEntry#', 'add', '2', '#note#')
</cfquery>

<cfset m2=2>

<cfelse>
<cfset m2=1>

<!--- /CFIF #checkexists.recordcount# is --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<!--- /CFIF #action# is "add" --->
</cfif>

<!--- /CFIF #show_type# is "network" --->
</cfif>


                                        <form name="networkbypass" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add"><input type="hidden" name="type" value="network">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table186" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1031">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1032">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "network">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
<cfelse>
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
</cfif>
</cfoutput>
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
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="7"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="654"><cfoutput>
                                                <table id="Table98" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                                  <tr style="height: 17px;">
                                                    <td width="258" id="Cell724">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Network Address</span></p>
                                                    </td>
                                                    <td width="202" id="Cell717">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Subnet</span></p>
                                                    </td>
                                                    <td width="85" id="Cell716">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="109" id="Cell725">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 24px;">
                                                    <td id="Cell550">
                                                      <table width="247" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="network" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#network#">
<cfelse>
<input type="text" name="network" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#network#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell557">
                                                      <table width="192" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfquery name="getsubnet" datasource="#datasource#">
select * from subnet order by value2 asc
</cfquery>

<cfif #show_type# is "network">
<select name="subnet" style="height: 24px;">
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
<cfelse>
<select name="subnet" style="height: 24px;" disabled="disabled">
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell558">
                                                      <table width="68" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelse>
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell726">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="2" width="617"><cfif #show_type# is "helo">
<cfif #action# is "add">

<cfif #helo# is not "">
<cfset temp_email="bob@#helo#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>

<!--- /CFIF IsValid("email", temp_email)> --->
</cfif>


<cfelseif #helo# is "">
<cfset step=0>
<cfset m2=5>

<!--- /CFIF #helo# is --->
</cfif>


<cfif step is "1">
<cfset theEntry="#helo#">

<cfquery name="checkexists" datasource="#datasource#">
select * from spf_bypass where entry='#theEntry#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into spf_bypass
(entry_type, entry, action, applied, entry_note)
values
('#type#', '#theEntry#', 'add', '2', '#note#')
</cfquery>

<cfset m2=2>

<cfelse>
<cfset m2=1>

<!--- /CFIF #checkexists.recordcount# is --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<!--- /CFIF #action# is "add" --->
</cfif>

<!--- /CFIF #show_type# is "helo" --->
</cfif>




                                        <form name="helobypass" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add"><input type="hidden" name="type" value="helo">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1045">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1046">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "helo">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
<cfelse>
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
</cfif>
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
                                              <td width="615"><cfoutput>
                                                <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 40px;">
                                                  <tr style="height: 17px;">
                                                    <td width="256" id="Cell1039">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">HELO Host</span></p>
                                                    </td>
                                                    <td width="103" id="Cell1040">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);"></span>&nbsp;</p>
                                                    </td>
                                                    <td width="256" id="Cell1041">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell1042">
                                                      <table width="246" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "helo">
<input type="text" name="helo" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#helo#">
<cfelse>
<input type="text" name="helo" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#helo#" disabled="disabled">
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1043">
                                                      <table width="78" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "helo">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelse>
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1044">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="2" width="617"><cfif #show_type# is "domain">
<cfif #action# is "add">

<cfif #domain# is not "">
<cfset temp_email="bob@#domain#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>

<!--- /CFIF IsValid("email", temp_email)> --->
</cfif>


<cfelseif #domain# is "">
<cfset step=0>
<cfset m2=5>

<!--- /CFIF #domain# is --->
</cfif>


<cfif step is "1">
<cfset theEntry="#domain#">

<cfquery name="checkexists" datasource="#datasource#">
select * from spf_bypass where entry='#theEntry#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into spf_bypass
(entry_type, entry, action, applied, entry_note)
values
('#type#', '#theEntry#', 'add', '2', '#note#')
</cfquery>

<cfset m2=2>

<cfelse>
<cfset m2=1>

<!--- /CFIF #checkexists.recordcount# is --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<!--- /CFIF #action# is "add" --->
</cfif>

<!--- /CFIF #show_type# is "domain" --->
</cfif>



                                        <form name="domainbypass" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add"><input type="hidden" name="type" value="domain">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table198" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1090">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1091">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "domain">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
<cfelse>
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
</cfif>
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
                                              <td width="615"><cfoutput>
                                                <table id="Table197" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 40px;">
                                                  <tr style="height: 17px;">
                                                    <td width="256" id="Cell1084">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Domain</span></p>
                                                    </td>
                                                    <td width="103" id="Cell1085">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);"></span>&nbsp;</p>
                                                    </td>
                                                    <td width="256" id="Cell1086">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell1087">
                                                      <table width="246" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "domain">
<input type="text" name="domain" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#domain#">
<cfelse>
<input type="text" name="domain" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#domain#" disabled="disabled">
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1088">
                                                      <table width="78" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "domain">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelse>
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1089">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="2" width="617"><cfif #show_type# is "ptr">
<cfif #action# is "add">

<cfif #ptr# is not "">
<cfset temp_email="bob@#ptr#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>

<!--- /CFIF IsValid("email", temp_email)> --->
</cfif>


<cfelseif #ptr# is "">
<cfset step=0>
<cfset m2=5>

<!--- /CFIF #ptr# is --->
</cfif>


<cfif step is "1">
<cfset theEntry="#ptr#">

<cfquery name="checkexists" datasource="#datasource#">
select * from spf_bypass where entry='#theEntry#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into spf_bypass
(entry_type, entry, action, applied, entry_note)
values
('#type#', '#theEntry#', 'add', '2', '#note#')
</cfquery>

<cfset m2=2>

<cfelse>
<cfset m2=1>

<!--- /CFIF #checkexists.recordcount# is --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<!--- /CFIF #action# is "add" --->
</cfif>

<!--- /CFIF #show_type# is "ptr" --->
</cfif>



                                        <form name="ptrdomain" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add"><input type="hidden" name="type" value="ptr">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table200" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1098">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1099">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "ptr">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
<cfelse>
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
</cfif>
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
                                              <td width="615"><cfoutput>
                                                <table id="Table199" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 40px;">
                                                  <tr style="height: 17px;">
                                                    <td width="256" id="Cell1092">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">PTR Domain</span></p>
                                                    </td>
                                                    <td width="103" id="Cell1093">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);"></span>&nbsp;</p>
                                                    </td>
                                                    <td width="256" id="Cell1094">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell1095">
                                                      <table width="246" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ptr">
<input type="text" name="ptr" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#ptr#">
<cfelse>
<input type="text" name="ptr" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#ptr#" disabled="disabled">
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1096">
                                                      <table width="78" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ptr">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelse>
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1097">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                      <td></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td height="13"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="948"><hr id="HRRule5" width="948" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="531">
                                    <tr valign="top" align="left">
                                      <td width="531" height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="531" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">SPF Bypass Entries to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="948" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_spfbypass" datasource="#datasource#">
select * from spf_bypass where action='add' and applied='2' order by entry asc
</cfquery>
<cfif #get_spfbypass.recordcount# GTE 1>
<select name="spfbypass" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_spfbypass">
<option value="#id#">#entry# ---> #entry_type# --> #note# --> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No SPF Bypass Entries found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <form name="Table127FORM" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="canceladd">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="948" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_spfbypass.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_spfbypass.recordcount# LT 1>
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
                                      <td width="948" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;IP Address ready to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Network Address ready to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid. An valid IP address is in the form: 192.168.0.23</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid. An valid IP address is in the form: 192.168.0.23</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="949"><hr id="HRRule13" width="949" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="46"></td>
                          <td width="954"><cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "20"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfif #filter# is "">
<cfquery name="getmailaddrtemp" datasource="#datasource#">
select * from spf_bypass where applied='1' order by entry asc
</cfquery>
<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>
</cfif>
<cfif #checkkeywords.recordcount# LT 1>
<cfquery name="getmailaddrtemp" datasource="#datasource#">
select * from spf_bypass where applied='1' and entry like '%#filter#%' order by entry asc
</cfquery>

<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion21" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="623">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="spf_bypass_filter.cfm" method="post">
                                                <input type="hidden" name="setfilter" value="1">
                                                <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                                  <tr style="height: 25px;">
                                                    <td width="56" id="Cell864">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Filter By</span></p>
                                                    </td>
                                                    <td width="258" id="Cell865">
                                                      <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField41" name="filter" size="29" maxlength="29" style="width: 228px; white-space: pre;" value="#filter#"></cfoutput></p>
                                                    </td>
                                                    <td width="116" id="Cell866">
                                                      <table width="110" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Set Filter" style="height: 24px; width: 87px;">&nbsp;</p>
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
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="15"></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="spf_bypass_filter.cfm" method="post">
                                                <input type="hidden" name="clearfilter" value="1">
                                                <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="178" id="Cell868">
                                                      <table width="153" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear Filter" style="height: 24px; width: 105px;">&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text381" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m4# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m4# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="963">
                        <tr valign="top" align="left">
                          <td width="11" height="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="444"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="5" valign="middle" width="952"><hr id="HRRule12" width="952" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="506" id="Text530" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete SPF Check Bypass Entry</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="188"></td>
                          <td colspan="4" width="951"><cfparam name = "spf_bypass" default = ""> 
<cfif IsDefined("form.spf_bypass") is "True">
<cfif form.spf_bypass is not "">
<cfset spf_bypass = form.spf_bypass>
</cfif></cfif> 


<cfif #action# is "delete">
<cfif IsDefined("form.fieldnames")> 
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset theID = "#evaluate(thefield)#">
<cfquery name="delete" datasource="#datasource#">
update spf_bypass set applied='2', action='delete' where id='#theID#'
</cfquery>
</cfoutput>
</cfif>
</cfloop>

<cfset m1=2>
<cfoutput>
<cflocation url="spf_bypass.cfm?m1=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete" addtoken="no">
 </cfoutput>
<cfelse>
<cfoutput>
<cflocation url="spf_bypass.cfm?m1=1&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete" addtoken="no">
 </cfoutput>
</cfif>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion4" style="height: 188px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="452" id="Cell869">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="spf_bypass.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&filter=#filter#&action=#action###delete"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Records</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            <td width="9" id="Cell870">
                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                            </td>
                                            <td width="489" id="Cell871">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getmailaddrtemp.RecordCount>
<A HREF="spf_bypass.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&filter=#filter#&action=#action###delete"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getmailaddrtemp.RecordCount - Next) LT DisplayRows>
      #Evaluate((getmailaddrtemp.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Records&nbsp; &gt;&gt;</SPAN></b></P></A>
<CFELSE>
  
</CFIF>
</CFOUTPUT>&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getmailaddrtemp.RecordCount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getmailaddrtemp.RecordCount# total records.</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table cellpadding="0" cellspacing="0" border="0" width="192">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="89">
                                          <tr valign="top" align="left">
                                            <td width="89" height="3"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td height="17" width="89" id="Text458" class="TextObject">
                                              <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('delete', true);" href="javascript:void();"><span style="font-size: 10px;">Select All</span></a></b><span style="font-size: 10px;"></span>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="103">
                                          <tr valign="top" align="left">
                                            <td width="14" height="3"></td>
                                            <td width="89"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="89" id="Text462" class="TextObject">
                                              <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('delete', false);" href="javascript:void();"><span style="font-size: 10px;">None</span></a></b>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="951" id="Text266" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getmailaddrtemp.recordcount# GTE 1>
<form name="delete" action="<cfoutput>spf_bypass.cfm?action=delete&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete</cfoutput>" method="post">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Entry</span></b></p>
    </td>
   
  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type</span></b></p>
    </td>
   

  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Note</span></b></p>
    </td>
  
    
  </tr>


<cfoutput query="getmailaddrtemp" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">


  <tr style="height: 28px;">


     
<cfif #applied# is "1">
     
<td align="center">
<input type="checkbox" name="cbox#id#" value="#id#" style="height: 13px; width: 13px;">
</td>

<cfelseif #applied# is "2">
<td align="center">
<input type="checkbox" name="cbox#id#" value="#id#" style="height: 13px; width: 13px;" disabled="disabled">
</td>
</cfif>



    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#entry# </span></p>
</div>
    </td>
    


    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#entry_type#</span></p>
</div>
    </td>

     <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#entry_note#</span></p>
</div>
    </td>   


</cfoutput>
        </tr>
      </table>

<br><br>
<table id="Table155" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
  <tr style="height: 24px;">
    <td width="951" id="Cell940">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <table width="160" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="TextObject">
                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;"
 onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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

<cfelse>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No existing SPF Bypass entries found...</span></i></b></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="290" height="4"></td>
                                      <td width="660"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text416" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">SPF Check Bypass Entries&nbsp; to be deleted</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="950" id="Text417" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters3" datasource="#datasource#">
select * from spf_bypass where action='delete' and applied='2' order by entry asc
</cfquery>
<cfif #get_parameters3.recordcount# GTE 1>
<select name="parameters3" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters3">
<option value="#id#">#entry# --> #entry_type# --> #entry_note# --> TO BE DELETED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No SPF Bypass entries found ..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <form name="Table127FORM" action="spf_bypass.cfm?#delete" method="post">
                                          <input type="hidden" name="action" value="canceldelete">
                                          <table id="Table151" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="951" id="Cell875">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_parameters3.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_parameters3.recordcount# LT 1>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;SPF Bypass Entries ready to be deleted. Please click the Apply Settings to apply your changes</span></i></b></p>
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
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="2" valign="middle" width="949"><hr id="HRRule14" width="949" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="63"></td>
                          <td colspan="3" width="950"><cfif #action# is "apply">

<!-- GENERATE UNIQUE TRANSACTION NUMBER STARTS HERE -->
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

<!-- GENERATE UNIQUE TRANSACTION NUMBER ENDS HERE -->

<!-- GET SPF CONFIGURATION PARAMETERS FROM DATABASE STARTS HERE -->
<cfquery name="get_debugLevel" datasource="#datasource#">
select value2 from parameters2 where parameter='debugLevel' and module = 'spf'
</cfquery>

<cfquery name="get_TestOnly" datasource="#datasource#">
select value2 from parameters2 where parameter='TestOnly' and module = 'spf'
</cfquery>


<cfquery name="get_HELO_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='HELO_reject' and module = 'spf'
</cfquery>

<cfquery name="get_Mail_From_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='Mail_From_reject' and module = 'spf'
</cfquery>

<cfquery name="get_PermError_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='PermError_reject' and module = 'spf'
</cfquery>

<cfquery name="get_TempError_Defer" datasource="#datasource#">
select value2 from parameters2 where parameter='TempError_Defer' and module = 'spf'
</cfquery>

<!-- GET SPF CONFIGURATION PARAMETERS FROM DATABASE ENDS HERE -->

<!-- UPDATE SPF CONFIGURATION PARAMETERS IN policyd-spf.conf FILE STARTS HERE -->

<!-- READ /OPT/HERMES/TEMPLATES/POLICYD-SPF.CONF.HERMES TEMPLATE FILE -->

<cffile action="read" file="/opt/hermes/templates/policyd-spf.conf.HERMES" variable="spffile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#spffile#","DEBUG-LEVEL","#get_debugLevel.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="spffile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#spffile#","TEST-ONLY","#get_TestOnly.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="spffile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#spffile#","HELO-REJECT","#get_HELO_reject.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="spffile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#spffile#","MAIL-FROM-REJECT","#get_Mail_From_reject.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="spffile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#spffile#","PERMERROR-REJECT","#get_PermError_reject.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="spffile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#spffile#","TEMPERROR-REJECT","#get_TempError_Defer.value2#","ALL")#">

<!-- UPDATE SPF CONFIGURATION PARAMETERS ENDS HERE -->

<!-- ADD SPF BYPASS PARAMETERS STARTS HERE -->

<!-- RESET ALL APPLIED TO 2 -->
<cfquery name="resetall" datasource="#datasource#">
update spf_bypass set applied='2'
</cfquery>

<!-- GET ALL DELETE ACTIONS -->
<cfquery name="getdelete" datasource="#datasource#">
delete from spf_bypass where action='delete' and applied='2'
</cfquery>

<!-- GET ALL ADD IP ACTIONS -->
<cfquery name="getaddip" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='ip'
</cfquery>

<!-- GET ALL ADD NETWORK ACTIONS -->
<cfquery name="getaddnetwork" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='network'
</cfquery>

<!-- GET ALL ADD HELO ACTIONS -->
<cfquery name="getaddhelo" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='helo'
</cfquery>

<!-- GET ALL ADD DOMAIN ACTIONS -->
<cfquery name="getadddomain" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='domain'
</cfquery>

<!-- GET ALL ADD PTR ACTIONS -->
<cfquery name="getaddptr" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='ptr'
</cfquery>


<!-- CREATE FILEDATAADDIP VARIABLE AND INSERT ADD IP ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddIp = "">
<cfloop query="getaddip">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddip.currentrow# NEQ #getaddip.recordcount#> 
<cfset FileDataAddIp = FileDataAddIp & getaddip.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA NORMALLY, BUT SINCE THE IP AND NETWORK GO ON THE SAME LINE, WE ADD A COMMA HERE BECAUSE NETWORK ADDRESSES WILL FOLLOW -->
<cfelseif #getaddip.currentrow# EQ #getaddip.recordcount#>
<cfset FileDataAddIp = FileDataAddIp & getaddip.entry & #Chr(44)#>

<!-- /CFIF FOR GETADDIP.CURRENTROW -->
</cfif>

</cfloop>


<!-- CREATE FILEDATAADDNETWORK VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddNetwork = "">
<cfloop query="getaddnetwork">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddnetwork.currentrow# NEQ #getaddnetwork.recordcount#> 
<cfset FileDataAddNetwork = FileDataAddNetwork & getaddnetwork.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddnetwork.currentrow# EQ #getaddnetwork.recordcount#>
<cfset FileDataAddNetwork = FileDataAddNetwork & getaddNetwork.entry>

<!-- /CFIF FOR GETADDNETWORK.CURRENTROW -->
</cfif>

</cfloop>

<!-- CREATE FILEDATAADDHELO VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddHelo = "">
<cfloop query="getaddhelo">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddhelo.currentrow# NEQ #getaddhelo.recordcount#> 
<cfset FileDataAddHelo = FileDataAddHelo & getaddhelo.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddhelo.currentrow# EQ #getaddhelo.recordcount#>
<cfset FileDataAddHelo = FileDataAddHelo & getaddHelo.entry>

<!-- /CFIF FOR GETADDHELO.CURRENTROW -->
</cfif>

</cfloop>

<!-- CREATE FILEDATAADDDOMAIN VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddDomain = "">
<cfloop query="getadddomain">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getadddomain.currentrow# NEQ #getadddomain.recordcount#> 
<cfset FileDataAddDomain = FileDataAddDomain & getadddomain.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getadddomain.currentrow# EQ #getadddomain.recordcount#>
<cfset FileDataAddDomain = FileDataAddDomain & getadddomain.entry>

<!-- /CFIF FOR GETADDDOMAIN.CURRENTROW -->
</cfif>
</cfloop>

<!-- CREATE FILEDATAADDPTR VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddPtr = "">
<cfloop query="getaddptr">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddptr.currentrow# NEQ #getaddptr.recordcount#> 
<cfset FileDataAddPtr = FileDataAddPtr & getaddptr.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddptr.currentrow# EQ #getaddptr.recordcount#>
<cfset FileDataAddPtr = FileDataAddPtr & getaddptr.entry>

<!-- /CFIF FOR GETADDPTR.CURRENTROW -->
</cfif>

</cfloop>

<!-- READ /OPT/HERMES/TMP/#CUSTOMTRANS3_POLICYD-SPF.CONF FILE CREATED ABOVE -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- CREATE TEMP FILE AND REPLACE IP-NETWORK-WHITELIST PLACEHOLDER WITH IPS AND NETWORK ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","IP-NETWORK-WHITELIST","#FileDataAddIp##FileDataAddNetwork#","ALL")#"> 
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE HELO-WHITELIST PLACEHOLDER WITH HELO ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","HELO-WHITELIST","#FileDataAddHelo#","ALL")#">
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE DOMAIN-WHITELIST PLACEHOLDER WITH DOMAIN ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","DOMAIN-WHITELIST","#FileDataAddDomain#","ALL")#">
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE PTR-WHITELIST PLACEHOLDER WITH PTR ENTRIES -->  
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","PTR-WHITELIST","#FileDataAddPtr#","ALL")#">

<!-- ADD SPF BYPASS PARAMETERS ENDS HERE -->

<!-- CREATE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT AND INSERT MAKE A BACKUP OF EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE COMMAND -->

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/postfix-policyd-spf-python/policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<!--  APPEND MOVE AND REPLACE EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE COMMAND WITH ONE WE CREATED ABOVE COMMAND IN /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT CREATED ABOVE -->
<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#_policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf#chr(10)#"
addnewline="no">

<!-- APPEND CREATE POSTFIX RESTART COMMAND TO APPLY CHANGES IN /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT SCRIPT CREATED ABOVE -->

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/systemctl restart postfix #chr(10)#"
addnewline="no">


<!-- MAKE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT EXECUTABLE -->

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>


<!-- EXECUTE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT -->

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<!-- DELETE POSTFIX RESTART SCRIPT TO APPLY CHANGES -->

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">  
    

<!-- SET ALL SPF PARAMETERS TO APPLIED -->
<cfquery name="completespf" datasource="#datasource#">
update parameters2 set applied='1' where module = 'spf'
</cfquery>

<!-- SET ALL SPF BYPASS TO APPLIED -->
<cfquery name="spfapplied" datasource="#datasource#">
update spf_bypass set applied='1'
</cfquery>


<!-- SET SUCCESS -->
<cflocation url="spf_bypass.cfm?m3=7##apply" addtoken="no">
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <form name="apply_settings" action="spf_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="apply">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="950" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from spf_bypass where applied='2'
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text330" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m3# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Changes Applied</span></i></b></p>
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