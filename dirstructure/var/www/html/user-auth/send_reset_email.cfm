<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
--->

<cfquery name="getemail" datasource="hermes">
    select email, password, password_set, train_bayes, download_msg from user_settings where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
    </cfquery>

<cfif #getemail.recordcount# GTE 1>

  <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 24
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    
    <cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
    <cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
    
    
    <cfquery name="insertpasswordcode" datasource="hermes">
    update user_settings 
    set
    reset_password_code='#gettrans.customtrans2#', 
    reset_password_datetime='#datenow# #timenow#', 
    reset_password_ip='#GetHttpRequestData().headers['X-Forwarded-For']#', 
    password_set='0'
    where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
    </cfquery>
    
    <cfquery name="getsettings" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>

<cfquery name="getconsolehost" datasource="hermes">
  select parameter, value2 from parameters2 where parameter='console.host' and module='console'
  </cfquery>

    
    <cfmail from="#getsettings.value#" to="#getemail.email#" server="localhost" subject="[Hermes SEG] Set User Console Password" port="10026"  type="html">

      <div align="center">

  <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>



<h2>Set User Console Password </h2>
    
Someone, presumbably you, has requested to set a new User Console Password. 

If you did <strong>NOT</strong> initiate this request, you can safely ignore this message and no action will be taken.<br><br>

If you did initiate this request, please click the link below to set a new password:<br><br>


<a href="https://#getconsolehost.value2#/user-auth/change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#gettrans.customtrans2#">Reset Password</a><br><br>



If you are unable to click on the link above, simply copy and paste the address below in a browser window:<br><br>

https://#getconsolehost.value2#/user-auth/change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#gettrans.customtrans2#<br><br>

<b>*** Please note that the above link is only valid for 15 minutes ***</b>

</div>
     
    </cfmail>

    <CFSET session.reason = 2>

    <cfoutput>
    <cflocation url="set_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no">
  </cfoutput>


<cfelseif #getemail.recordcount# LT 1>

    <cfset m="User Forgot Password: getemail.recordcount LT 1">
    <cfinclude template="error.cfm">
    <cfabort>
      
      <!-- /CFIF FOR GETEMAIL.RECORDCOUNT -->
      </cfif>