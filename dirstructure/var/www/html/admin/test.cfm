
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>test</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="949">
    <tr valign="top" align="left">
      <td width="13" height="22"></td>
      <td width="936"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="936" id="Text442" class="TextObject">
        <p style="margin-bottom: 0px;"><cfschedule action="update"
task="dmarc_report"
operation="HTTPRequest"
startdate="2019-01-01"
starttime="01:00"
requesttimeout="7200"
url="http://localhost:8888/schedule/dmarc_report.cfm"
interval="daily">

<cfschedule
action = "pause"
task = "dmarc_report">&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   