
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

<!--- UPDATE DKIM --->

<cfif #dkimenabled# is "1">

  <cfquery name="dkimsmtpd" datasource="hermes">
  update parameters set 
  enabled='1',
  applied='1'
  where
  parameter='inet:127.0.0.1:8891' and child = '1' and parent='#get_smtpd_milters_id.id#'
  </cfquery>
  
  <cfquery name="dkimnonsmtpd" datasource="hermes">
  update parameters set 
  enabled='1',
  applied='1'
  where
  parameter='inet:127.0.0.1:8891' and child = '1' and parent='#get_non_smtpd_milters_id.id#'
  </cfquery>


<cfquery name="update_body_canonicalization" datasource="hermes">
  update parameters2 set 
  value2='#form.body_canonicalization#',
  applied='1'
  where
  parameter='body_canonicalization' and module = 'dkim'
  </cfquery>
  

  <cfquery name="update_headers_canonicalization" datasource="hermes">
    update parameters2 set 
    value2='#form.headers_canonicalization#',
    applied='1'
    where
    parameter='headers_canonicalization' and module = 'dkim'
    </cfquery>
    

    <cfquery name="update_default_action" datasource="hermes">
      update parameters2 set 
      value2='#form.default_action#',
      applied='1'
      where
      parameter='default_action' and module = 'dkim'
      </cfquery>

<cfquery name="update_badsignature_action" datasource="hermes">
  update parameters2 set 
  value2='#form.badsignature_action#',
  applied='1'
  where
  parameter='badsignature_action' and module = 'dkim'
  </cfquery>

<cfquery name="update_dnserror_action" datasource="hermes">
  update parameters2 set 
  value2='#form.dnserror_action#',
  applied='1'
  where
  parameter='dnserror_action' and module = 'dkim'
  </cfquery>


<cfquery name="update_internalerror_action" datasource="hermes">
  update parameters2 set 
  value2='#form.internalerror_action#',
  applied='1'
  where
  parameter='internalerror_action' and module = 'dkim'
  </cfquery>


<cfquery name="update_nosignature_action" datasource="hermes">
  update parameters2 set 
  value2='#form.nosignature_action#',
  applied='1'
  where
  parameter='nosignature_action' and module = 'dkim'
  </cfquery>

<cfquery name="update_security_action" datasource="hermes">
  update parameters2 set 
  value2='#form.security_action#',
  applied='1'
  where
  parameter='security_action' and module = 'dkim'
  </cfquery>

<cfquery name="update_signature_algorithm" datasource="hermes">
  update parameters2 set 
  value2='#form.signature_algorithm#',
  applied='1'
  where
  parameter='signature_algorithm' and module = 'dkim'
  </cfquery>


<cfinclude template="dkim_generate_config_file.cfm">

<cfinclude template="restart_opendkim.cfm">

<cfinclude template="restart_postfix.cfm">




<cfelseif #dkimenabled# is "2">
  
  <cfquery name="dkimsmtpd" datasource="hermes">
  update parameters set 
  enabled='2',
  applied='1'
  where
  parameter='inet:127.0.0.1:8891' and child = '1' and parent='#get_smtpd_milters_id.id#'
  </cfquery>
  
  <cfquery name="dkimnonsmtpd" datasource="hermes">
  update parameters set 
  enabled='2',
  applied='1'
  where
  parameter='inet:127.0.0.1:8891' and child = '1' and parent='#get_non_smtpd_milters_id.id#'
  </cfquery>

<!--- SET PARAMETERS IN ORDER TO DISABLE DMARC --->
<cfset dmarcenabled = "2">
<cfset form.failurereports = "false">
<cfset form.rejectfailures = "false">
<cfset form.holdquarantinedmessages = "false">

<cfinclude template="dmarc_set_settings.cfm">

<cfinclude template="restart_opendkim.cfm">

<cfinclude template="restart_postfix.cfm">
  
  <!--- /CFIF for #dkimenabled# is --->
  </cfif>
  