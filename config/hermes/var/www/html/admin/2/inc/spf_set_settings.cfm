
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

<!--- UPDATE SPF --->

<cfif #spfenabled# is "1">

  <cfquery name="spf" datasource="hermes">
    update parameters set 
    enabled='1',
    applied='1'
    where
    parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
    </cfquery>


<cfquery name="updatedebugLevel" datasource="hermes">
  update parameters2 set 
  value2='#form.debuglevel#',
  applied='1'
  where
  parameter='debugLevel' and module = 'spf'
  </cfquery>
  
  
  <cfquery name="updateTestOnly" datasource="hermes">
  update parameters2 set 
  value2='#form.testonly#',
  applied='1'
  where
  parameter='TestOnly' and module = 'spf'
  </cfquery>
  
  
  <cfquery name="updateHELO_reject" datasource="hermes">
  update parameters2 set 
  value2='#form.helo_reject#',
  applied='1'
  where
  parameter='HELO_reject' and module = 'spf'
  </cfquery>
  
  <cfquery name="updateMail_From_reject" datasource="hermes">
  update parameters2 set 
  value2='#form.mail_from_reject#',
  applied='1'
  where
  parameter='Mail_From_reject' and module = 'spf'
  </cfquery>
  
  <cfquery name="updatePermError_reject" datasource="hermes">
  update parameters2 set 
  value2='#form.permerror_reject#',
  applied='1'
  where
  parameter='PermError_reject' and module = 'spf'
  </cfquery>
  
  
  <cfquery name="updateTempError_Defer" datasource="hermes">
  update parameters2 set 
  value2='#form.temperror_defer#',
  applied='1'
  where
  parameter='TempError_Defer' and module = 'spf'
  </cfquery>
  

  
<cfinclude template="spf_generate_config_file.cfm">

<cfinclude template="restart_postfix.cfm">


<cfelseif #spfenabled# is "2">
  
  <cfquery name="spf" datasource="hermes">
    update parameters set 
    enabled='2',
    applied='1'
    where
    parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
    </cfquery>

<!--- SET PARAMETERS IN ORDER TO DISABLE DMARC --->

<cfinclude template="get_dmarc_settings.cfm" />

<cfset dmarcenabled = "2">
<cfset form.failurereports = "false">
<cfset form.rejectfailures = "false">
<cfset form.holdquarantinedmessages = "false">

<cfinclude template="dmarc_set_settings.cfm">

<cfinclude template="restart_postfix.cfm">
  
  <!--- /CFIF for #spfenabled# is --->
  </cfif>
  