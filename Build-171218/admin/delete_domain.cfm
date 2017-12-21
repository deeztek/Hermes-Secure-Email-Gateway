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
<title>Delete Domain</title>
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
                <table id="Table2" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 56px;">
                  <tr style="height: 28px;">
                    <td width="644" id="Cell8">
                      <p style="margin-bottom: 0px;"><img id="Picture1" height="28" width="635" src="./background_635_trop.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_trop" title="background_635_trop"></p>
                    </td>
                  </tr>
                  <tr style="height: 132px;">
                    <td id="Cell9">
                      <table width="635" border="0" cellspacing="0" cellpadding="0" align="left">
                        <tr>
                          <td><cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cfif #action# is "delete">
<cfquery name="getotherid" datasource="#datasource#">
select domain, transport_id, senders_id, recipients_id, domain from domains where id='#form.id#'
</cfquery>

<cfquery name="delete_transport_domain" datasource="#datasource#">
delete from transport where id='#getotherid.transport_id#'
</cfquery>

<cfquery name="delete_senders_domain" datasource="#datasource#">
delete from senders where id='#getotherid.senders_id#'
</cfquery>

<cfquery name="delete_recipients_domain" datasource="#datasource#">
delete from recipients where id='#getotherid.recipients_id#'
</cfquery>

<cfquery name="delete_domain" datasource="#datasource#">
delete from domains where id='#form.id#'
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


<cffile action="read" file="/opt/hermes/scripts/delete_domain_djigzo.sh" variable="deletedomain">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_delete_domain_djigzo.sh"
    output = "#REReplace("#deletedomain#","THE-DOMAIN","#getotherid.domain#","ALL")#"> 

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_delete_domain_djigzo.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_delete_domain_djigzo.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_delete_domain_djigzo.sh"> 
    
<cfquery name="getdomains" datasource="#datasource#">
select * from domains
</cfquery>

<cfset FileDomain = "">
<cfloop query="getdomains">
<cfset FileDomain = FileDomain & getdomains.domain & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/relay_domains" output = "#FileDomain#" addnewline="no">


<cfquery name="gettransports" datasource="#datasource#">
select * from transport
</cfquery>

<cfset FileData = "">
<cfloop query="gettransports">
<cfset FileData = FileData & gettransports.domain & #Chr(9)# & #Chr(9)# & gettransports.transport & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/transport" output = "#FileData#" addnewline="no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
    output = "/usr/sbin/postmap /etc/postfix/transport" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_postmap.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_postmap.sh">

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>


<cfquery name="dropusers" datasource="#datasource#">
drop table users
</cfquery>

<cfquery name="createusers" datasource="#datasource#">
CREATE TABLE users LIKE recipients
</cfquery>

<cfquery name="copyusers" datasource="#datasource#">
INSERT INTO users SELECT * FROM recipients
</cfquery>

<cfquery name="alterusers" datasource="#datasource#">
alter table users change recipient email VARBINARY(255)
</cfquery>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

    
<cflocation url="relay_domains_new.cfm?m1=7">
<cfelseif #action# is "cancel">
<cflocation url="relay_domains_new.cfm">
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion4" style="background-image: url('./background_635_middle.png'); height: 132px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="628">
                                    <tr valign="top" align="left">
                                      <td width="14"></td>
                                      <td width="614" id="Text272" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><b>Are you sure you want to delete this Relay Domain?</b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="14" height="11"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="615">
                                        <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 10px;">
                                          <tr style="height: 24px;">
                                            <td width="615" id="Cell769">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="178" style="height: 24px;">
                                                      <tr style="height: 24px;">
                                                        <td width="93" id="Cell770">
                                                          <form name="Cell770FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<cfoutput>#form.id#</cfoutput>"><input type="hidden" name="domain" value="<cfoutput>#form.domain#</cfoutput>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton11" name="FormsButton11" value="YES" style="height: 24px; width: 49px;"></td>
                                                              </tr>
                                                            </table>
                                                          </form>
                                                        </td>
                                                        <td width="85" id="Cell771">
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