
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Unauthorized</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="681">
            <tr valign="top" align="left">
              <td width="20" height="24"></td>
              <td width="661"></td>
            </tr>
            <tr valign="top" align="left">
              <td></td>
              <td width="661" id="Text435" class="TextObject"><!--- Get IP using X-Forwarded-For --->
<cfset theIP=#GetHttpRequestData().headers['X-Forwarded-For']#>

<!--- If IP contains multiple IPs separated by comma due to reverse proxy in front of Hermes --->
<cfif #theIP# contains ",">
<!--- Get the left most value which is most likely the client IP --->
<cfset theIP = #trim(ListGetAt(theIP, 1, ","))#>
</cfif>

<cfoutput>

<p style="text-align: center;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);">You are not
 authorized to access this system</span></b></p>
<p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color:
 rgb(51,51,51);">Your IP Address is: #theIP#</span></b></p>
 
</cfoutput>
                <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);"></span>&nbsp;</p>
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