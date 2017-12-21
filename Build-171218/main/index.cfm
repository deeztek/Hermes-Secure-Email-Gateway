
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>System Status</title>
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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="542" width="988"><cfparam name = "m" default = ""> 
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif> 

<cfif NOT IsDefined('session.wizard')>
<cfset wizard=2>
<cfelseif IsDefined('session.wizard')>
<cfif #session.wizard# is "1">
<cfset wizard=1>
<cfelseif #session.wizard# is not "1">
<cfset wizard=2>
</cfif>
</cfif>

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">







                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion15" style="background-image: url('./middle_988.png'); height: 542px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="3" width="619" id="Text185" class="TextObject">
                            <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Admin E-mail Address must be part of a domain that this system does NOT relay</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Admin E-mail Address must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Admin E-mail Address must must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must be part of a domain that this system relays</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! License Setup completed. You may now access and configure the rest of the system</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must accept the License Agreement</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you have entered an invalid Serial Number</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the serial number cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #wizard# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must enter a Postmaster Email adddress, a Admin Email Address, a Serial Number and you must accept the License Agreement as part of the first time setup. You will not be able to access any other parts of the system until all first time setup steps are completed</span></i></b></p>
</cfoutput>
</cfif>
&nbsp;</p>
                          </td>
                          <td colspan="8"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="7" height="5"></td>
                          <td width="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="499"></td>
                          <td width="119"></td>
                          <td width="249"></td>
                          <td width="85"></td>
                          <td width="1"></td>
                          <td width="3"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="11" width="961" id="Text440" class="TextObject">
                            <p style="text-align: justify; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Welcome to Hermes Secure Mail Gateway. Please use the menu options on top to configure the system. Any problems or questions should be directed to <a href="mailto:support@deeztek.com">support@deeztek.com</a></span></b></p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="10" valign="middle" width="960"><hr id="HRRule8" width="960" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="10"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td width="499" id="Text457" class="TextObject">
                            <p style="margin-bottom: 0px;"><b>System Services Status</b></p>
                          </td>
                          <td colspan="9"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td colspan="6" width="956" id="Text480" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfexecute name="/usr/sbin/service"
arguments="postfix status"
variable="postfix"
timeout="10" />


<cfexecute name="/usr/sbin/service"
arguments="amavis status"
variable="amavis"
timeout="10" />

<cfexecute name="/opt/hermes/scripts/djigzo_status.sh"
variable="djigzo"
timeout="10" />

<cfif #djigzo# is not "">
<cfset djigzo2 = "Running">
<cfelseif #djigzo# is "">
<cfset djigzo2 = "Not Running">
</cfif>


<table id="Table184" border="1" cellspacing="0" cellpadding="0" width="100%" style="height: 146px;">

  <tr style="height: 18px;">
    <td width="124" style="background-color: rgb(243,239,239);" id="Cell1017">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">SMTP Status</span></b></p>
    </td>
    
    
    <td width="123" style="background-color: rgb(243,239,239);" id="Cell1020">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Spam Filter Status</span></b></p>
    </td>
    <td width="124" style="background-color: rgb(243,239,239);" id="Cell1021">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Secure SMTP Status</span></b></p>
    </td>
  </tr>


  <tr style="height: 18px;">
<cfif #postfix# contains 'postfix is running'>
    <td style="background-color: rgb(0,255,0);" id="Cell1022">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Running</span></p>
    </td>

<cfelseif #postfix# does not contain 'postfix is running'>
  <td style="background-color: rgb(255,0,0);" id="Cell1022">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(243,239,239);">Stopped</span></p>
    </td>
</cfif>





<cfif #amavis# contains 'is running'>
    <td style="background-color: rgb(0,255,0);" id="Cell1025">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Running</span></p>
    </td>


<cfelseif #amavis# does not contain 'is running'>
<td style="background-color: rgb(255,0,0);" id="Cell1025">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(243,239,239);">Stopped</span></p>
    </td>
</cfif>

<cfif #djigzo2# is "Running">
    <td style="background-color: rgb(0,255,0);" id="Cell1026">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Running</span></p>
    </td>

<cfelseif #djigzo2# is "Not Running">
  <td style="background-color: rgb(255,0,0);" id="Cell1026">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(243,239,239);">Stopped</span></p>
    </td>
</cfif>

  </tr>


  <tr style="height: 32px;">
    <td id="Cell1027">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<form name="service" action="restart_service.cfm" method="post">
<cfif #postfix# contains 'postfix is running'>
<td align="center"><input type="submit" name="action" value="start" disabled="disabled" style="height: 24px; width: 49px;"></td>
<cfelseif #postfix# does not contain 'postfix is running'>
<td align="center"><input type="submit" name="action" value="start" style="height: 24px; width: 49px;">
</td>
</cfif>
<input type="hidden" name="service" value="postfix">
</form>

        </tr>
      </table>
    </td>
    
    
    <td id="Cell1030">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<form name="service" action="restart_service.cfm" method="post">
<cfif #amavis# contains 'is running'>
          <td align="center"><input type="submit" name="action" value="start" disabled="disabled" style="height: 24px; width: 49px;"></td>

<cfelseif #amavis# does not contain 'is running'>
<td align="center"><input type="submit" name="action" value="start" style="height: 24px; width: 49px;"></td>
</cfif>
<input type="hidden" name="service" value="amavis">
</form>
        </tr>
      </table>
    </td>
    <td id="Cell1031">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<form name="service" action="restart_service.cfm" method="post">
<cfif #djigzo2# is "Running">
          <td align="center"><input type="submit" name="action" value="start" disabled="disabled" style="height: 24px; width: 49px;"></td>

<cfelseif #djigzo2# is "Not Running">
<td align="center"><input type="submit" name="action" value="start" style="height: 24px; width: 49px;"></td>
</cfif>
<input type="hidden" name="service" value="djigzo">
</form>
        </tr>
      </table>
    </td>
  </tr>
  <tr style="height: 32px;">
    <td id="Cell1032">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<form name="service" action="restart_service.cfm" method="post">
<cfif #postfix# contains 'postfix is running'>
          <td align="center"><input type="submit" name="action" value="stop" style="height: 24px; width: 51px;"></td>
<cfelseif #postfix# does not contain 'postfix is running'>
<td align="center"><input type="submit" name="action" value="stop" disabled="disabled" style="height: 24px; width: 51px;"></td>
</cfif>
<input type="hidden" name="service" value="postfix">
</form>
        </tr>
      </table>
    </td>
    
    
    <td id="Cell1035">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<form name="service" action="restart_service.cfm" method="post">

<cfif #amavis# contains 'is running'>
          <td align="center"><input type="submit" name="action" value="stop" style="height: 24px; width: 51px;"></td>
<cfelseif #amavis# does not contain 'is running'>
<td align="center"><input type="submit" name="action" value="stop" disabled="disabled" style="height: 24px; width: 51px;"></td>
</cfif>
<input type="hidden" name="service" value="amavis">
</form>
        </tr>
      </table>
    </td>
    <td id="Cell1036">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<form name="service" action="restart_service.cfm" method="post">
<cfif #djigzo2# is "Running">
          <td align="center"><input type="submit" name="action" value="stop" style="height: 24px; width: 51px;"></td>
<cfelseif #djigzo2# is "Not Running">

          <td align="center"><input type="submit" name="action" value="stop" disabled="disabled" style="height: 24px; width: 51px;"></td>
</cfif>
<input type="hidden" name="service" value="djigzo">
</form>
        </tr>
      </table>
    </td>
  </tr>
  <tr style="height: 32px;">
    <td id="Cell1037">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<form name="service" action="restart_service.cfm" method="post">
          <td align="center"><input type="submit" name="action" value="restart" style="height: 24px; width: 73px;"></td>
<input type="hidden" name="service" value="postfix">
</form>
        </tr>
      </table>
    </td>
    
    
    <td id="Cell1040">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<form name="service" action="restart_service.cfm" method="post">
          <td align="center"><input type="submit" name="action" value="restart" style="height: 24px; width: 73px;"></td>
<input type="hidden" name="service" value="amavis">
</form>
        </tr>
      </table>
    </td>
    <td id="Cell1041">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<form name="service" action="restart_service.cfm" method="post">
          <td align="center"><input type="submit" name="action" value="restart" style="height: 24px; width: 73px;"></td>
<input type="hidden" name="service" value="djigzo">
</form>
        </tr>
      </table>
    </td>
  </tr>
</table>&nbsp;</p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="7" valign="middle" width="957"><hr id="HRRule9" width="957" size="1"></td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="10" width="960" id="Text442" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cffile action="read" file="/usr/share/djigzo/ADDITIONAL-NOTES.TXT" variable="date">
<cfif #date# is not "">
<cfset difference = #datediff("d", '#datenow# #timenow#', '#date#')#>
<cfelse>
</cfif>

<cfexecute name="/usr/bin/uptime"
variable="uptime"
timeout="10" />

<cfexecute name="/opt/hermes/scripts/getip.sh"
variable="ip"
timeout="10" />

<cfexecute name="/opt/hermes/scripts/disk_space_usage.sh"
arguments=""
variable="diskspace"
timeout="10" />

<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>

<b>Version & Build No:</b><br>
<cfoutput>#getversion.value#</cfoutput><br><br>
<b>License Status:</b><br>
<cfif #date# is not "">
<cfif #difference# GTE 1>
Your license is valid for another <cfoutput>#difference#</cfoutput> day(s)
<cfelse>
Your license is no longer valid. Please contact support@deeztek.com to obtain a new serial
</cfif>
<cfelseif #date# is "">
N/A
</cfif>
<br><br>
<b>System Uptime and Load Average:</b><br>
<cfoutput>#uptime#</cfoutput><br><br>
<b>Filesystem Usage:</b><br>
<cfoutput>#diskspace#</cfoutput><br><br>
<b>System IP Address:</b><br>
<cfoutput>#ip#</cfoutput><br>&nbsp;</p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="9" valign="middle" width="959"><hr id="HRRule7" width="959" size="1"></td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="10" width="960" id="Text498" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfquery name="getserial" datasource="#datasource#">
SELECT value FROM system_settings where parameter = 'serial'
</cfquery>

<cfif #getserial.value# is not "">
<cfquery name="getlatestlocal" datasource="#datasource#">
SELECT * FROM system_updates where status = '1' order by install_order desc limit 1
</cfquery>



<CFHTTP url="http://updates.deeztek.com/update.cfm?build=#getlatestlocal.build#&sn=#getserial.value#" method="GET" resolveurl="false"> 
</CFHTTP>

<cfset status2="#trim(ListGetAt(cfhttp.FileContent, 1, "#chr(64)#"))#">

<cfif #status2# contains 'SUCCESS'>
<cfset build2 = "#trim(ListGetAt(cfhttp.FileContent, 2, "#chr(64)#"))#">
<cfset released2 = "#trim(ListGetAt(cfhttp.FileContent, 3, "#chr(64)#"))#">
<cfset filename2 = "#trim(ListGetAt(cfhttp.FileContent, 4, "#chr(64)#"))#">
</cfif>

<b>Operating System Updates Status:</b><br>
<cfset reboot="/var/run/reboot-required">
<cfif NOT fileExists(reboot)> 
Operating System is up to date<br><br>
<cfelseif fileExists(reboot)>
The system must be rebooted in order to finish installing OS updates<br><br>
</cfif>
<b>Hermes SEG Updates Status:</b><br>

<cfif #status2# contains 'SUCCESS'>
<cfset compare_build = Compare(#build2#, #getlatestlocal.build#)>
<cfif #compare_build# is "0">
Hermes SEG is on the latest version
<cfelse>
<span style="color: rgb(255,0,0);">Hermes SEG Update Found!&nbsp&nbsp</span><a href="system_update.cfm">Click here to update</a><br>
<cfoutput>
Build: #build2#<br>
Date Released: #released2#
</cfoutput>
</cfif>
<cfelseif #status2# contains 'Connection'>
There was an error connecting to the update server. Please ensure you system has access to the Internet via HTTP/HTTPS and try again.
<cfelseif #status2# contains 'INVALID'>
Your system is not eligible to receive updates. 
<cfelseif #status2# contains 'NOUPDATE'>
Hermes SEG is on the latest version
</cfif>

<cfelseif #getserial.value# is "">
<b>Operating System Updates Status:</b><br>
<cfset reboot="/var/run/reboot-required">
<cfif NOT fileExists(reboot)> 
Operating System is up to date<br><br>
<cfelseif fileExists(reboot)>
The system must be rebooted in order to finish installing OS updates<br><br>
</cfif>
<b>Hermes SEG Updates Status:</b><br>
Your system is not eligible to receive updates

<!-- CFIF FOR GETSERIAL.VALUE -->
</cfif>

&nbsp;</p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="11" valign="middle" width="962"><hr id="HRRule11" width="962" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="6" width="871" id="Text477" class="TextObject"><cfquery name="getearliest" datasource="#datasource#">
SELECT min(time_iso) as earliest FROM msgs
</cfquery>

<cfif #getearliest.earliest# is "">
<cfset earliest="#datenow# #timenow#">
<cfelse>
<cfset earliest="#getearliest.earliest#">
</cfif>

<cfset maxdays = DateDiff("d", "#datenow#", "#earliest#")>

<cfparam name = "theInterval" default = "-30"> 
<cfif IsDefined("form.interval") is "True">
<cfset theInterval = form.interval>
</cfif>

<cfset theDate=#DateFormat(DateAdd('d', #theInterval#, datenow),'yyyy-mm-dd')#>
<cfset datenow2=#DateFormat(theDate,"mm/dd/yyyy")#>
<cfoutput>
<cfquery name="getmsgtypes" datasource="#datasource#">
SELECT count(*) as msgcount, msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds,  msg_content_type.content_type, msg_content_type.description FROM msg_content_type LEFT JOIN msgs ON msgs.content = binary(msg_content_type.content_type) LEFT JOIN msgrcpt
ON msgrcpt.mail_id = msgs.mail_id where msgs.time_iso between '#theDate# 00:00:00' and '#datenow# 23:59:59' group by msg_content_type.description
</cfquery>
</cfoutput>

<cfoutput>
<cfquery name="gettotalmsgs" datasource="#datasource#">
SELECT count(*) as totalmsgs, msgs.mail_id,  msgs.time_iso, msgrcpt.rid, msgrcpt.mail_id FROM msgrcpt LEFT JOIN msgs
ON msgs.mail_id = msgrcpt.mail_id where msgs.time_iso between '#theDate# 00:00:00' and '#datenow# 23:59:59'
</cfquery>
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>Message Statistics for past #Abs(theInterval)# Day(s) </b>(#gettotalmsgs.totalmsgs# total msgs)</span></p>
                            </cfoutput></td>
                          <td colspan="7"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="17"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="11" width="962" id="Text459" class="TextObject">
                            <p style="margin-bottom: 0px;">

<cfif #theInterval# is "-30">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>

            <option value="-30" selected="selected">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7">7 Days</option>
            <option value="-1">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 36px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelseif #theInterval# is "-15">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>

            <option value="-30">30 Days</option>
            <option value="-15" selected="selected">15 Days</option>
            <option value="-7">7 Days</option>
            <option value="-1">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 36px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelseif #theInterval# is "-7">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>

            <option value="-30">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7" selected="selected">7 Days</option>
            <option value="-1">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 36px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelseif #theInterval# is "-1">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
            <cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>
             <option value="-30">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7">7 Days</option>
            <option value="-1" selected="selected">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 36px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelse>
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">

<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#" selected="selected">#theDays# Days</option></cfoutput>
            <option value="-30">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7">7 Days</option>
<option value="-1">1 Day</option>
            
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 36px;"></p>
      </td>
    </tr>
  </table>
  </form>


</cfif>&nbsp;</p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="7" width="956" id="Text478" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfoutput>
<cfchart   
    format="png"  
    chartWidth="500" 
    chartHeight="300"
    xaxistitle="Message Type"  
    yaxistitle="Total Messages" 
    showlegend="yes" 
    show3d="no"  
    showxgridlines="yes"  
    fontsize="12"  
    sortxaxis="yes"  
    showygridlines="yes"  
    gridlines="5"  
    showborder="no" 
    seriesPlacement = "stacked" 
    >  

<cfchartseries
query="getmsgtypes"   
type="pie"
itemColumn="description"
valuecolumn="msgcount">
</cfchartseries>  
</cfchart>  

</cfoutput>

&nbsp;</p>
                          </td>
                          <td colspan="6"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="14" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="8" width="957" id="Text458" class="TextObject">
                            <p style="margin-bottom: 0px;"><table id="Table165" border="1" cellspacing="4" cellpadding="2" width="100%" style="height: 119px;">
  <tr style="height: 18px;">
    <td width="294" style="background-color: rgb(241,236,236);">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Message Type</span></b></p>
    </td>
    <td width="294" style="background-color: rgb(241,236,236);">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Total Messages</span></b></p>
    </td>

    
  </tr>
<cfoutput query="getmsgtypes">
  <tr style="height: 18px;">

    <td>
      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#description#</span></p>
    </td>
<td>
      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#msgcount#</span></p>
    </td>

    
  </tr>
</cfoutput>
  
</table>&nbsp;</p>
                          </td>
                          <td colspan="5"></td>
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
<cfoutput>
<span style="font-size: 12px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
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