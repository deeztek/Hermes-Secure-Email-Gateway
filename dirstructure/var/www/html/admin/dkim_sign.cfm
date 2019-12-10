<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">
<cfparam name = "error" default = "0">
<cfparam name = "success" default = "0">

<cfparam name = "m1" default = "0"> 
<cfif IsDefined("url.m1") is "True">
<cfif url.m1 is not "">
<cfset m1 = url.m1>
</cfif></cfif> 

<cfparam name = "domain_entry" default = ""> 
<cfif IsDefined("form.relay_domain") is "True">
<cfif form.relay_domain is not "">
<cfset domain_entry = form.relay_domain>
</cfif></cfif> 

<cfparam name = "show_type" default = "ip"> 
<cfif IsDefined("url.type") is "True">
<cfif url.type is not "">
<cfset show_type = url.type>
</cfif></cfif> 

<cfparam name = "octet1" default = ""> 
<cfif IsDefined("form.octet1") is "True">
<cfif form.octet1 is not "">
<cfset octet1 = form.octet1>
</cfif></cfif> 

<cfparam name = "octet2" default = ""> 
<cfif IsDefined("form.octet2") is "True">
<cfif form.octet2 is not "">
<cfset octet2 = form.octet2>
</cfif></cfif> 

<cfparam name = "octet3" default = ""> 
<cfif IsDefined("form.octet3") is "True">
<cfif form.octet3 is not "">
<cfset octet3 = form.octet3>
</cfif></cfif> 

<cfparam name = "octet4" default = ""> 
<cfif IsDefined("form.octet4") is "True">
<cfif form.octet4 is not "">
<cfset octet4 = form.octet4>
</cfif></cfif> 

<cfparam name = "domain" default = ""> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif> 

<cfparam name = "host_name" default = ""> 
<cfif IsDefined("form.host_name") is "True">
<cfif form.host_name is not "">
<cfset host_name = form.host_name>
</cfif></cfif> 

<cfparam name = "host_domain" default = ""> 
<cfif IsDefined("form.host_domain") is "True">
<cfif form.host_domain is not "">
<cfset host_domain = form.host_domain>
</cfif></cfif>


<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfif #action# is "canceladd">
<cfquery name="canceldelete" datasource="#datasource#">
delete from domains_temp where action='insert' and applied='2'
</cfquery>
<cfset step=0>
<cfset m2=12>
<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
delete from domains_temp where action='delete' and applied='2'
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
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DKIM Sign</title>
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
              <td height="519" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>

<CFPARAM NAME="m" DEFAULT="0">
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif>

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion29" style="background-image: url('./middle_988.png'); height: 519px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="422">
                              <tr valign="top" align="left">
                                <td width="18" height="11"></td>
                                <td width="404"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="404" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">DKIM Sign</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="548">
                              <tr valign="top" align="left">
                                <td width="523" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/dkim-sign/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="19" height="1"></td>
                          <td width="946"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="946" id="Text276" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! DKIM Sign enabled for the specified domain. Ensure you add a DNS TXT Record with the contents of your DKIM Public Key</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;There was an error retrieving the DKIM Key. It's recommended that you disable and re-enable DKIM Sign for the domain you selected and try again. If the error persists, please contact support</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! DKIM Sign disabled for the specified domain. Ensure you remove the DNS TXT Record from your DNS configuration</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Relay  domain deleted</span></i></b></p>
</cfoutput>
</cfif>




&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="18" height="1"></td>
                          <td width="946"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="946" id="Text464" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfquery name="get_domains" datasource="#datasource#">
select * from domains order by domain asc
</cfquery>

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Domain</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Enable DKIM Sign</span></b></p>
    </td>

   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">View Private</span></b></p>
    </td>


   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">View Public</span></b></p>
    </td>


   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Disable DKIM Sign</span></b></p>
    </td>
   
  
    
  </tr>


<cfoutput query="get_domains">

  <tr style="height: 28px;">


     




    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#domain# </span></p>
</div>
    </td>
    

<cfquery name="checkdkim" datasource="#datasource#">
select enabled from dkim_sign where domain = '#domain#'
</cfquery>

<cfif #checkdkim.recordcount# GTE 1>
<td align="center"><input type="image" id="FormsButton13" name="configure" src="enable_icon_off.png"></td>

<cfelseif #checkdkim.recordcount# LT 1>

<form name="generatekeys" action="enable_dkim_sign.cfm" method="post">
<input type="hidden" name="id" value="#id#">
<input type="hidden" name="domain" value="#domain#">
<td align="center"><input type="image" id="FormsButton13" name="Enable DKIM Sign" src="enable_icon.png"></td>
</form>

<!-- /CFIF for checkdkim.recordcount --> 
</cfif>


<cfif #checkdkim.recordcount# GTE 1>

<form name="viewprivate" action="view_dkim.cfm" method="post">
<input type="hidden" name="id" value="#id#">
<input type="hidden" name="domain" value="#domain#">
<input type="hidden" name="type" value="private">
<td align="center"><input type="image" id="FormsButton13" name="View DKIM Private" src="view_icon.png"></td>
</form>

<cfelseif #checkdkim.recordcount# LT 1>

<td align="center"><input type="image" id="FormsButton13" name="No DKIM Private Key Available" src="view_icon_off.png"></td>

<!-- /CFIF -->
</cfif>


<cfif #checkdkim.recordcount# GTE 1>

<form name="viewprivate" action="view_dkim.cfm" method="post">
<input type="hidden" name="id" value="#id#">
<input type="hidden" name="domain" value="#domain#">
<input type="hidden" name="type" value="public">
<td align="center"><input type="image" id="FormsButton13" name="View DKIM Private" src="view_icon.png"></td>
</form>

<cfelseif #checkdkim.recordcount# LT 1>
<td align="center"><input type="image" id="FormsButton13" name="No DKIM Public Key Available" src="view_icon_off.png"></td>

<!-- /CFIF -->
</cfif>



<cfif #checkdkim.recordcount# GTE 1>

<form name="disabledkim" action="disable_dkim_sign.cfm" method="post">
<input type="hidden" name="id" value="#id#">
<input type="hidden" name="domain" value="#domain#">
<input type="hidden" name="type" value="public">
<td align="center"><input type="image" id="FormsButton13" name="Disable DKIM" src="disable_icon.png"></td>
</form>

<cfelseif #checkdkim.recordcount# LT 1>
<td align="center"><input type="image" id="FormsButton13" name="DKIM Not Enabled" src="disable_icon_off.png"></td>

<!-- /CFIF -->
</cfif>







</cfoutput>
        </tr>
      </table>&nbsp;</p>
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