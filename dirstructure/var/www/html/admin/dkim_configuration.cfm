<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DKIM Configuration</title>
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
              <td height="1082" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1082px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="514">
                              <tr valign="top" align="left">
                                <td width="8" height="18"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">DKIM Configuration</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="456">
                              <tr valign="top" align="left">
                                <td width="431" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/dkim-configuration/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="961">
                        <tr valign="top" align="left">
                          <td width="10" height="4"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="color: rgb(255,0,0);">I<b>mportant:</b></span> The settings below will have no effect unless <b>DKIM</b> (<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">DomainKeys Identified Mail Checks</span></b><b>)</b> is set to <b>enabled</b> under <a href="./perimeter_configuration.cfm"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Content Checks --&gt; Perimenter Checks</span></b></a></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="11" height="7"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="957"><hr id="HRRule5" width="957" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="977">
                        <tr valign="top" align="left">
                          <td width="12" height="12"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="813"></td>
                          <td width="965"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif>

<cfquery name="get_body_canonicalization" datasource="#datasource#">
select value2 from parameters2 where parameter='body_canonicalization' and module = 'dkim'
</cfquery>


<cfquery name="get_headers_canonicalization" datasource="#datasource#">
select value2 from parameters2 where parameter='headers_canonicalization' and module = 'dkim'
</cfquery>

<cfquery name="get_default_action" datasource="#datasource#">
select value2 from parameters2 where parameter='default_action' and module = 'dkim'
</cfquery>

<cfquery name="get_badsignature_action" datasource="#datasource#">
select value2 from parameters2 where parameter='badsignature_action' and module = 'dkim'
</cfquery>

<cfquery name="get_dnserror_action" datasource="#datasource#">
select value2 from parameters2 where parameter='dnserror_action' and module = 'dkim'
</cfquery>

<cfquery name="get_internalerror_action" datasource="#datasource#">
select value2 from parameters2 where parameter='internalerror_action' and module = 'dkim'
</cfquery>

<cfquery name="get_nosignature_action" datasource="#datasource#">
select value2 from parameters2 where parameter='nosignature_action' and module = 'dkim'
</cfquery>

<cfquery name="get_security_action" datasource="#datasource#">
select value2 from parameters2 where parameter='security_action' and module = 'dkim'
</cfquery>

<cfquery name="get_signature_algorithm" datasource="#datasource#">
select value2 from parameters2 where parameter='signature_algorithm' and module = 'dkim'
</cfquery>


<cfparam name = "body_canonicalization" default = "#get_body_canonicalization.value2#"> 
<cfif IsDefined("form.body_canonicalization") is "True">
<cfif form.body_canonicalization is not "">
<cfset body_canonicalization = form.body_canonicalization>
</cfif></cfif> 


<cfparam name = "headers_canonicalization" default = "#get_headers_canonicalization.value2#"> 
<cfif IsDefined("form.headers_canonicalization") is "True">
<cfif form.headers_canonicalization is not "">
<cfset headers_canonicalization = form.headers_canonicalization>
</cfif></cfif> 

<cfparam name = "default_action" default = "#get_default_action.value2#"> 
<cfif IsDefined("form.default_action") is "True">
<cfif form.default_action is not "">
<cfset default_action = form.default_action>
</cfif></cfif> 

<cfparam name = "badsignature_action" default = "#get_badsignature_action.value2#"> 
<cfif IsDefined("form.badsignature_action") is "True">
<cfif form.badsignature_action is not "">
<cfset badsignature_action = form.badsignature_action>
</cfif></cfif> 

<cfparam name = "dnserror_action" default = "#get_dnserror_action.value2#"> 
<cfif IsDefined("form.dnserror_action") is "True">
<cfif form.dnserror_action is not "">
<cfset dnserror_action = form.dnserror_action>
</cfif></cfif> 

<cfparam name = "internalerror_action" default = "#get_internalerror_action.value2#"> 
<cfif IsDefined("form.internalerror_action") is "True">
<cfif form.internalerror_action is not "">
<cfset internalerror_action = form.internalerror_action>
</cfif></cfif> 

<cfparam name = "nosignature_action" default = "#get_nosignature_action.value2#"> 
<cfif IsDefined("form.nosignature_action") is "True">
<cfif form.nosignature_action is not "">
<cfset nosignature_action = form.nosignature_action>
</cfif></cfif> 

<cfparam name = "security_action" default = "#get_security_action.value2#"> 
<cfif IsDefined("form.security_action") is "True">
<cfif form.security_action is not "">
<cfset security_action = form.security_action>
</cfif></cfif> 

<cfparam name = "signature_algorithm" default = "#get_signature_algorithm.value2#"> 
<cfif IsDefined("form.signature_algorithm") is "True">
<cfif form.signature_algorithm is not "">
<cfset signature_algorithm = form.signature_algorithm>
</cfif></cfif> 



<cfif #show_action# is "edit">

<cfquery name="updatebody_canonicalization" datasource="#datasource#">
update parameters2 set 
value2='#body_canonicalization#',
applied='2'
where
parameter='body_canonicalization' and module = 'dkim'
</cfquery>


<cfquery name="updateheaders_canonicalization" datasource="#datasource#">
update parameters2 set 
value2='#headers_canonicalization#',
applied='2'
where
parameter='headers_canonicalization' and module = 'dkim'
</cfquery>

<cfquery name="updatedefault_action" datasource="#datasource#">
update parameters2 set 
value2='#default_action#',
applied='2'
where
parameter='default_action' and module = 'dkim'
</cfquery>

<cfquery name="updatebadsignature_action" datasource="#datasource#">
update parameters2 set 
value2='#badsignature_action#',
applied='2'
where
parameter='badsignature_action' and module = 'dkim'
</cfquery>


<cfquery name="updatednserror_action" datasource="#datasource#">
update parameters2 set 
value2='#dnserror_action#',
applied='2'
where
parameter='dnserror_action' and module = 'dkim'
</cfquery>

<cfquery name="updateinternalerror_action" datasource="#datasource#">
update parameters2 set 
value2='#internalerror_action#',
applied='2'
where
parameter='internalerror_action' and module = 'dkim'
</cfquery>



<cfquery name="updatenosignature_action" datasource="#datasource#">
update parameters2 set 
value2='#nosignature_action#',
applied='2'
where
parameter='nosignature_action' and module = 'dkim'
</cfquery>


<cfquery name="updatesecurity_action" datasource="#datasource#">
update parameters2 set 
value2='#security_action#',
applied='2'
where
parameter='security_action' and module = 'dkim'
</cfquery>

<cfquery name="updatesignature_algorithm" datasource="#datasource#">
update parameters2 set 
value2='#signature_algorithm#',
applied='2'
where
parameter='signature_algorithm' and module = 'dkim'
</cfquery>


<cfset m=3>

<!-- /CFIF FOR ACTION -->
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="965" id="LayoutRegion11" style="height: 813px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 701px;">
                                            <tr style="height: 14px;">
                                              <td width="958" id="Cell1045">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Body Canonicalization</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1041">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table164" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1027">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #body_canonicalization# is "relaxed">
<cfoutput>
<input type="radio" checked="checked" name="body_canonicalization" value="relaxed" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #body_canonicalization# is not "relaxed">
<cfoutput>
<input type="radio" name="body_canonicalization" value="relaxed" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1028">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Relaxed</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1029">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #body_canonicalization# is "simple">
<cfoutput>
<input type="radio" checked="checked" name="body_canonicalization" value="simple" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #body_canonicalization# is not "simple">
<cfoutput>
<input type="radio" name="body_canonicalization" value="simple" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1030">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Simple</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1040">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Headers Canonicalization</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1039">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1034">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #headers_canonicalization# is "relaxed">
<cfoutput>
<input type="radio" checked="checked" name="headers_canonicalization" value="relaxed" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #headers_canonicalization# is not "relaxed">
<cfoutput>
<input type="radio" name="headers_canonicalization" value="relaxed" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1035">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Relaxed</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1036">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #headers_canonicalization# is "simple">
<cfoutput>
<input type="radio" checked="checked" name="headers_canonicalization" value="simple" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #headers_canonicalization# is not "simple">
<cfoutput>
<input type="radio" name="headers_canonicalization" value="simple" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1037">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Simple</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1038">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Default Message Action</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell565">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table106" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell604">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #default_action# is "accept">
<cfoutput>
<input type="radio" checked="checked" name="default_action" value="accept" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #default_action# is not "accept">
<cfoutput>
<input type="radio" name="default_action" value="accept" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell605">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">Accept</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell606">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #default_action# is "discard">
<cfoutput>
<input type="radio" checked="checked" name="default_action" value="discard" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #default_action# is not "discard">
<cfoutput>
<input type="radio" name="default_action" value="discard" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell607">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Discard</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1048">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #default_action# is "reject">
<cfoutput>
<input type="radio" checked="checked" name="default_action" value="reject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #default_action# is not "reject">
<cfoutput>
<input type="radio" name="default_action" value="reject" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1049">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Reject</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1050">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #default_action# is "tempfail">
<cfoutput>
<input type="radio" checked="checked" name="default_action" value="tempfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #default_action# is not "tempfail">
<cfoutput>
<input type="radio" name="default_action" value="tempfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1051">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Temp Fail</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1052">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #default_action# is "quarantine">
<cfoutput>
<input type="radio" checked="checked" name="default_action" value="quarantine" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #default_action# is not "quarantine">
<cfoutput>
<input type="radio" name="default_action" value="quarantine" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1053">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Quarantine</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell609">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bad Signature Action</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell611">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1054">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #badsignature_action# is "accept">
<cfoutput>
<input type="radio" checked="checked" name="badsignature_action" value="accept" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #badsignature_action# is not "accept">
<cfoutput>
<input type="radio" name="badsignature_action" value="accept" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1055">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">Accept</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1056">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #badsignature_action# is "discard">
<cfoutput>
<input type="radio" checked="checked" name="badsignature_action" value="discard" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #badsignature_action# is not "discard">
<cfoutput>
<input type="radio" name="badsignature_action" value="discard" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1057">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Discard</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1058">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #badsignature_action# is "reject">
<cfoutput>
<input type="radio" checked="checked" name="badsignature_action" value="reject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #badsignature_action# is not "reject">
<cfoutput>
<input type="radio" name="badsignature_action" value="reject" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1059">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Reject</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1060">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #badsignature_action# is "tempfail">
<cfoutput>
<input type="radio" checked="checked" name="badsignature_action" value="tempfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #badsignature_action# is not "tempfail">
<cfoutput>
<input type="radio" name="badsignature_action" value="tempfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1061">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Temp Fail</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1062">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #badsignature_action# is "quarantine">
<cfoutput>
<input type="radio" checked="checked" name="badsignature_action" value="quarantine" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #badsignature_action# is not "quarantine">
<cfoutput>
<input type="radio" name="badsignature_action" value="quarantine" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1063">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Quarantine</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell749">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">DNS Error Action</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell751">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table167" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1064">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #dnserror_action# is "accept">
<cfoutput>
<input type="radio" checked="checked" name="dnserror_action" value="accept" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dnserror_action# is not "accept">
<cfoutput>
<input type="radio" name="dnserror_action" value="accept" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1065">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">Accept</span> </span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1066">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #dnserror_action# is "discard">
<cfoutput>
<input type="radio" checked="checked" name="dnserror_action" value="discard" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dnserror_action# is not "discard">
<cfoutput>
<input type="radio" name="dnserror_action" value="discard" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1067">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Discard</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1068">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #dnserror_action# is "reject">
<cfoutput>
<input type="radio" checked="checked" name="dnserror_action" value="reject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dnserror_action# is not "reject">
<cfoutput>
<input type="radio" name="dnserror_action" value="reject" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1069">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Reject</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1070">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #dnserror_action# is "tempfail">
<cfoutput>
<input type="radio" checked="checked" name="dnserror_action" value="tempfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dnserror_action# is not "tempfail">
<cfoutput>
<input type="radio" name="dnserror_action" value="tempfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1071">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Temp Fail <span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(128,128,128); font-weight: normal;">(Recommended)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1072">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #dnserror_action# is "quarantine">
<cfoutput>
<input type="radio" checked="checked" name="dnserror_action" value="quarantine" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dnserror_action# is not "quarantine">
<cfoutput>
<input type="radio" name="dnserror_action" value="quarantine" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1073">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Quarantine</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell617">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Internal Error Action</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell616">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table168" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1074">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #internalerror_action# is "accept">
<cfoutput>
<input type="radio" checked="checked" name="internalerror_action" value="accept" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #internalerror_action# is not "accept">
<cfoutput>
<input type="radio" name="internalerror_action" value="accept" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1075">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51); font-weight: normal;">Accept</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1076">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #internalerror_action# is "discard">
<cfoutput>
<input type="radio" checked="checked" name="internalerror_action" value="discard" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #internalerror_action# is not "discard">
<cfoutput>
<input type="radio" name="internalerror_action" value="discard" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1077">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Discard</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1078">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #internalerror_action# is "reject">
<cfoutput>
<input type="radio" checked="checked" name="internalerror_action" value="reject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #internalerror_action# is not "reject">
<cfoutput>
<input type="radio" name="internalerror_action" value="reject" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1079">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Reject</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1080">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #internalerror_action# is "tempfail">
<cfoutput>
<input type="radio" checked="checked" name="internalerror_action" value="tempfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #internalerror_action# is not "tempfail">
<cfoutput>
<input type="radio" name="internalerror_action" value="tempfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1081">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Temp Fail <span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(128,128,128); font-weight: normal;">(Recommended)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1082">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #internalerror_action# is "quarantine">
<cfoutput>
<input type="radio" checked="checked" name="internalerror_action" value="quarantine" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #internalerror_action# is not "quarantine">
<cfoutput>
<input type="radio" name="internalerror_action" value="quarantine" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1083">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Quarantine</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell625">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">No Signature Action</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell624">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table169" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1084">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #nosignature_action# is "accept">
<cfoutput>
<input type="radio" checked="checked" name="nosignature_action" value="accept" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #nosignature_action# is not "accept">
<cfoutput>
<input type="radio" name="nosignature_action" value="accept" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1085">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">Accept</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1086">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #nosignature_action# is "discard">
<cfoutput>
<input type="radio" checked="checked" name="nosignature_action" value="discard" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #nosignature_action# is not "discard">
<cfoutput>
<input type="radio" name="nosignature_action" value="discard" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1087">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Discard</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1088">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #nosignature_action# is "reject">
<cfoutput>
<input type="radio" checked="checked" name="nosignature_action" value="reject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #nosignature_action# is not "reject">
<cfoutput>
<input type="radio" name="nosignature_action" value="reject" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1089">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Reject</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1090">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #nosignature_action# is "tempfail">
<cfoutput>
<input type="radio" checked="checked" name="nosignature_action" value="tempfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #nosignature_action# is not "tempfail">
<cfoutput>
<input type="radio" name="nosignature_action" value="tempfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1091">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Temp Fail</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1092">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #nosignature_action# is "quarantine">
<cfoutput>
<input type="radio" checked="checked" name="nosignature_action" value="quarantine" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #nosignature_action# is not "quarantine">
<cfoutput>
<input type="radio" name="nosignature_action" value="quarantine" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1093">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Quarantine</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell633">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Security Concern Action</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell632">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1094">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #security_action# is "accept">
<cfoutput>
<input type="radio" checked="checked" name="security_action" value="accept" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #security_action# is not "accept">
<cfoutput>
<input type="radio" name="security_action" value="accept" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1095">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51); font-weight: normal;">Accept</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1096">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #security_action# is "discard">
<cfoutput>
<input type="radio" checked="checked" name="security_action" value="discard" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #security_action# is not "discard">
<cfoutput>
<input type="radio" name="security_action" value="discard" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1097">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Discard</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1098">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #security_action# is "reject">
<cfoutput>
<input type="radio" checked="checked" name="security_action" value="reject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #security_action# is not "reject">
<cfoutput>
<input type="radio" name="security_action" value="reject" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1099">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Reject</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1100">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #security_action# is "tempfail">
<cfoutput>
<input type="radio" checked="checked" name="security_action" value="tempfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #security_action# is not "tempfail">
<cfoutput>
<input type="radio" name="security_action" value="tempfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1101">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Temp Fail <span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(128,128,128); font-weight: normal;">(Recommended)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1102">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #security_action# is "quarantine">
<cfoutput>
<input type="radio" checked="checked" name="security_action" value="quarantine" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #security_action# is not "quarantine">
<cfoutput>
<input type="radio" name="security_action" value="quarantine" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1103">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Quarantine</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell641">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Signature Algorithm</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell640">
                                                <table width="598" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table112" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell647">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #signature_algorithm# is "rsa-sha256">
<cfoutput>
<input type="radio" checked="checked" name="signature_algorithm" value="rsa-sha256" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #signature_algorithm# is not "rsa-sha256">
<cfoutput>
<input type="radio" name="signature_algorithm" value="rsa-sha256" style="height: 13px; width: 13px;">
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
                                                          <td width="543" id="Cell648">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">RSA-SHA256</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell649">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #signature_algorithm# is "rsa-sha1">
<cfoutput>
<input type="radio" checked="checked" name="signature_algorithm" value="rsa-sha1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #signature_algorithm# is not "rsa-sha1">
<cfoutput>
<input type="radio" name="signature_algorithm" value="rsa-sha1" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell650">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">RSA-SHA1</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell651">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="956">
                                      <tr valign="top" align="left">
                                        <td width="956" height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid Message Size Limit</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid RBL Block Score</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Message Size Limit must be greater than 0</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="4"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
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
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="12" height="3"></td>
                          <td></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="957"><hr id="HRRule3" width="957" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="63"></td>
                          <td width="955"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">
<cfset m2=16>

<cfquery name="get_body_canonicalization" datasource="#datasource#">
select value2 from parameters2 where parameter='body_canonicalization' and module = 'dkim'
</cfquery>


<cfquery name="get_headers_canonicalization" datasource="#datasource#">
select value2 from parameters2 where parameter='headers_canonicalization' and module = 'dkim'
</cfquery>

<cfquery name="get_default_action" datasource="#datasource#">
select value2 from parameters2 where parameter='default_action' and module = 'dkim'
</cfquery>

<cfquery name="get_badsignature_action" datasource="#datasource#">
select value2 from parameters2 where parameter='badsignature_action' and module = 'dkim'
</cfquery>

<cfquery name="get_dnserror_action" datasource="#datasource#">
select value2 from parameters2 where parameter='dnserror_action' and module = 'dkim'
</cfquery>

<cfquery name="get_internalerror_action" datasource="#datasource#">
select value2 from parameters2 where parameter='internalerror_action' and module = 'dkim'
</cfquery>

<cfquery name="get_nosignature_action" datasource="#datasource#">
select value2 from parameters2 where parameter='nosignature_action' and module = 'dkim'
</cfquery>

<cfquery name="get_security_action" datasource="#datasource#">
select value2 from parameters2 where parameter='security_action' and module = 'dkim'
</cfquery>

<cfquery name="get_signature_algorithm" datasource="#datasource#">
select value2 from parameters2 where parameter='signature_algorithm' and module = 'dkim'
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

<!--- ENABLE/DISABLE DKIM BELOW --NO LONGER USED --->

<!---
<cfif #get_dkim_enable.value2# is "yes">

<cffile action="read" file="/opt/hermes/scripts/enable_dkim_postfix.sh" variable="postfixdkim">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_enable_dkim_postfix.sh"
    output = "#postfixdkim#">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_enable_dkim_postfix.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_enable_dkim_postfix.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_enable_dkim_postfix.sh">  
 

<cfelseif #get_dkim_enable.value2# is "no">

<cffile action="read" file="/opt/hermes/scripts/disable_dkim_postfix.sh" variable="postfixdkim">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_disable_dkim_postfix.sh"
    output = "#postfixdkim#">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_disable_dkim_postfix.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_disable_dkim_postfix.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_disable_dkim_postfix.sh">  

</cfif>

--->

<!--- ENABLE/DISABLE DKIM ABOVE --NO LONGER USED --->

<!--- CONFIGURE OPENDKIM.CONF FILE BELOW --->

<cffile action="read" file="/opt/hermes/conf_files/opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","HEADER-CANONICALIZATION","#get_headers_canonicalization.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","BODY-CANONICALIZATION","#get_body_canonicalization.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","DEFAULT-ACTION","#get_default_action.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","BADSIGNATURE-ACTION","#get_badsignature_action.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","DNSERROR-ACTION","#get_dnserror_action.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","INTERNALERROR-ACTION","#get_internalerror_action.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","NOSIGNATURE-ACTION","#get_nosignature_action.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","SECURITY-ACTION","#get_security_action.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES"
    output = "#REReplace("#dkimfile#","SIGNATURE-ALGORITHM","#get_signature_algorithm.value2#","ALL")#">


<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/opendkim.conf /etc/opendkim.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#_opendkim.conf.HERMES /etc/opendkim.conf#chr(10)#"
addnewline="no">


<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/etc/init.d/opendkim restart#chr(10)#/etc/init.d/postfix restart"
addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">  
    
<!--- CONFIGURE OPENDKIM.CONF FILE ABOVE --->
    
    
<cfquery name="completedkim" datasource="#datasource#">
update parameters2 set applied='1' where module = 'dkim'
</cfquery>

<!-- /CFIF FOR ACTION -->
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="955">
                                        <form name="apply_settings" action="dkim_configuration.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="955" id="Cell753">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters2 where module='dkim' and applied='2'
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
<input type="hidden" name="action2" value="apply">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="955">
                                    <tr valign="top" align="left">
                                      <td width="8" height="4"></td>
                                      <td width="947"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="947" id="Text351" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
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