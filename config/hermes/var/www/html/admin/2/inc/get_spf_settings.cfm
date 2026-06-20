
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

<cfquery name="get_smtpd_recipient_restrictions_id" datasource="hermes">
  select id from parameters where parameter='smtpd_recipient_restrictions' and child = '2'
  </cfquery>

<cfquery name="get_spf" datasource="hermes">
  select enabled from parameters where parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
  </cfquery>

<cfquery name="get_debugLevel" datasource="hermes">
  select value2 from parameters2 where parameter='debugLevel' and module = 'spf'
  </cfquery>
  
  <cfquery name="get_testonly" datasource="hermes">
  select value2 from parameters2 where parameter='TestOnly' and module = 'spf'
  </cfquery>
  
  
  <cfquery name="get_helo_reject" datasource="hermes">
  select value2 from parameters2 where parameter='HELO_reject' and module = 'spf'
  </cfquery>
  
  <cfquery name="get_mail_from_reject" datasource="hermes">
  select value2 from parameters2 where parameter='Mail_From_reject' and module = 'spf'
  </cfquery>
  
  <cfquery name="get_permerror_reject" datasource="hermes">
  select value2 from parameters2 where parameter='permerror_reject' and module = 'spf'
  </cfquery>
  
  <cfquery name="get_temperror_defer" datasource="hermes">
  select value2 from parameters2 where parameter='temperror_defer' and module = 'spf'
  </cfquery>

<cfparam name = "spfenabled" default = "#get_spf.enabled#"> 
<cfif IsDefined("form.spfenabled") is "True">
<cfif form.spfenabled is not "">
<cfset spfenabled = form.spfenabled>
</cfif></cfif> 

<cfparam name = "debuglevel" default = "#get_debugLevel.value2#"> 
<cfif IsDefined("form.debugLevel") is "True">
<cfif form.debugLevel is not "">
<cfset debugLevel = form.debugLevel>
</cfif></cfif> 

<cfparam name = "testonly" default = "#get_testonly.value2#"> 
<cfif IsDefined("form.testonly") is "True">
<cfif form.testonly is not "">
<cfset testonly = form.testonly>
</cfif></cfif> 


<cfparam name = "helo_reject" default = "#get_helo_reject.value2#"> 
<cfif IsDefined("form.helo_reject") is "True">
<cfif form.helo_reject is not "">
<cfset helo_reject = form.helo_reject>
</cfif></cfif> 

<cfparam name = "mail_from_reject" default = "#get_mail_from_reject.value2#"> 
<cfif IsDefined("form.mail_from_reject") is "True">
<cfif form.mail_from_reject is not "">
<cfset mail_from_reject = form.mail_from_reject>
</cfif></cfif> 

<cfparam name = "permerror_reject" default = "#get_permerror_reject.value2#"> 
<cfif IsDefined("form.permerror_reject") is "True">
<cfif form.permerror_reject is not "">
<cfset permerror_reject = form.permerror_reject>
</cfif></cfif> 

<cfparam name = "temperror_defer" default = "#get_temperror_defer.value2#"> 
<cfif IsDefined("form.temperror_defer") is "True">
<cfif form.temperror_defer is not "">
<cfset temperror_defer = form.temperror_defer>
</cfif></cfif> 
  
    


