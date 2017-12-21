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
<title>Run Restore</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-image: url('./top_blue.png'); margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0">
            <tr valign="top" align="left">
              <td width="9" height="53"></td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td></td>
              <td width="644">
                <table id="Table2" border="0" cellspacing="0" cellpadding="0" width="644" style="height: 56px;">
                  <tr style="height: 28px;">
                    <td width="644" id="Cell8">
                      <p style="margin-bottom: 0px;"><img id="Picture1" height="28" width="635" src="./background_635_trop.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_trop" title="background_635_trop"></p>
                    </td>
                  </tr>
                  <tr style="height: 264px;">
                    <td id="Cell9">
                      <table width="635" border="0" cellspacing="0" cellpadding="0" align="left">
                        <tr>
                          <td><cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cfif #action# is "run">
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">

<cfquery name="insertrestore" datasource="#datasource#">
insert into restore_jobs
(file_name,
server,
domain,
share,
directory,
username,
password,
status,
startdate)
values
('#form.file#', 
'#form.server#', 
'#form.domain#', 
'#form.share#', 
'#form.directory#', 
'#form.username#', 
'#form.password#', 
'running', 
'#datenow# #timenow#')
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


<cfif #form.file# contains "enc">     
<cffile action="read" file="/opt/hermes/templates/system_restore_encrypted.sh" variable="restore">
<cfelseif #form.file# does not contain "enc">
<cffile action="read" file="/opt/hermes/templates/system_restore.sh" variable="restore">
</cfif>



<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","SERVER","#form.server#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","SHARE","#form.share#","ALL")#">  
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","DIRECTORY","#form.directory#","ALL")#">  

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","DOMAIN","#form.domain#","ALL")#">  
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","USERNAME","#form.username#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","PASSWORD","#form.password#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","THE-FILE","#form.file#","ALL")#"> 
    

<cfquery name="getpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfquery name="getadmin" datasource="#datasource#">
select parameter, value from system_settings where parameter='admin_email'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","FROM","#getpostmaster.value#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","TO","#getadmin.value#","ALL")#"> 
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_restore.sh" variable="restore">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_restore.sh"
    output = "#REReplace("#restore#","THE-TRANSACTION","#customtrans3#","ALL")#"> 
    
  
  
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_system_restore.sh"
timeout = "60">
</cfexecute>

<cffile action="read" file="/opt/hermes/templates/restore_task.cfm" variable="restoretask">

<cffile action = "write"
    file = "/var/www/schedule/#customtrans3#_restore_task.cfm"
    output = "#REReplace("#restoretask#","THE-TRANSACTION","#customtrans3#","ALL")#"> 

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cfset theStamp="#datenow# #timenow#">
<cfset past=#DateAdd("d", -5, theStamp)#> 
<cfset date1="#dateformat(past, "mm/dd/yyyy")#">
<cfset time1="#timeformat(past, "HH:mm")#">

<cfschedule action="update"
task="restorejob_#customtrans3#"
operation="HTTPRequest"
startdate="#date1#"
starttime="#time1#"
requesttimeout="7200"
url="http://localhost:8080/schedule/#customtrans3#_restore_task.cfm"
interval="once">


<cfschedule  
action = "run"  
task = "restorejob_#customtrans3#"> 

   
<cflocation url="logout.cfm">

<cfelseif #action# is "cancel">
<cflocation url="system_restore.cfm">
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion4" style="background-image: url('./background_635_middle.png'); height: 264px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="628">
                                    <tr valign="top" align="left">
                                      <td width="14"></td>
                                      <td width="614" id="Text272" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><b>Are you sure you want to restore this Backup Job?</b></p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="614" id="Text462" class="TextObject">
                                        <p style="text-align: center;"><b><span style="color: rgb(255,0,0);">If you click YES, ALL DATA from the appliance will be deleted and replaced with the data contained in the backup job, you will be logged out and the system will reboot automatically when completed. You will not be allowed to log in until the operation is complete. This action is <u>irreversible. Are you sure you want to proceed?</u></span></b></p>
                                        <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;"><b>Before you start a System Restore, ensure Postmaster E-mail Address and the Admin E-mail Address under System --&gt; <a style="font-size: 12px;" href="system_settings.cfm">System Settings</a> are set correctly otherwise you will not be notified when the System Restore has completed.</b> </span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="11" height="34"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="615">
                                        <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="615" style="height: 10px;">
                                          <tr style="height: 24px;">
                                            <td width="615" id="Cell769">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="419" style="height: 24px;">
                                                      <tr style="height: 24px;">
                                                        <td width="218" id="Cell770">
                                                          <form name="Cell770FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="run"><input type="hidden" name="file" value="<cfoutput>#form.file#</cfoutput>"><input type="hidden" name="server" value="<cfoutput>#form.server#</cfoutput>"><input type="hidden" name="domain" value="<cfoutput>#form.domain#</cfoutput>"><input type="hidden" name="share" value="<cfoutput>#form.share#</cfoutput>"><input type="hidden" name="directory" value="<cfoutput>#form.directory#</cfoutput>"><input type="hidden" name="username" value="<cfoutput>#form.username#</cfoutput>"><input type="hidden" name="password" value="<cfoutput>#form.password#</cfoutput>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton11" name="FormsButton11" value="YES" style="height: 24px; width: 49px;"></td>
                                                              </tr>
                                                            </table>
                                                          </form>
                                                        </td>
                                                        <td width="200" id="Cell771">
                                                          <form name="Cell771FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton12" name="FormsButton12" value="NO" style="height: 24px; width: 39px;"></td>
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
                  <tr style="height: 32px;">
                    <td id="Cell10">
                      <p style="margin-bottom: 0px;"><img id="Picture2" height="32" width="635" src="./background_635_bottom.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_bottom" title="background_635_bottom"></p>
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