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

  
    <cfquery name="getsettings" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>

    
<cfmail from="#getsettings.value#" to="#getemail.email#" server="localhost" subject="[Hermes SEG] User Console Password Changed" port="10026"  type="html">

  <div align="center">

<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>



<h2>User Console Password Changed </h2>

Someone, presumbably you, has changed the Hermes SEG User Console Password. 

If you did initiate this change, you can safely ignore this message.<br><br>

If you <strong>did NOT</strong> initiate this change, please contact your Hermes SEG Administrator asap as this may indicate an account compromise.<br><br>

</div>
 
</cfmail>

    

<cfelseif #getemail.recordcount# LT 1>

    <cfset m="Send Changed Password Email: getemail.recordcount LT 1">
    <cfinclude template="error.cfm">
    <cfabort>
      
      <!-- /CFIF FOR GETEMAIL.RECORDCOUNT -->
      </cfif>