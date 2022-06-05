
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

<cfquery name="get_smtpd_milters_id" datasource="hermes">
select id from parameters where parameter='smtpd_milters' and child = '2'
</cfquery>

<cfquery name="get_non_smtpd_milters_id" datasource="hermes">
select id from parameters where parameter='non_smtpd_milters' and child = '2'
</cfquery>

<cfquery name="get_dkim" datasource="hermes">
select enabled from parameters where parameter='inet:127.0.0.1:8891' and child = '1' and parent='#get_smtpd_milters_id.id#'
</cfquery>


<cfquery name="get_default_action" datasource="hermes">
select value2 from parameters2 where parameter='default_action' and module = 'dkim'
</cfquery>

<cfquery name="get_dkim_enable" datasource="hermes">
select value2 from parameters2 where parameter='dkim_enable' and module = 'dkim'
</cfquery>
        
<cfquery name="get_body_canonicalization" datasource="hermes">
select value2 from parameters2 where parameter='body_canonicalization' and module = 'dkim'
</cfquery>

<cfquery name="get_badsignature_action" datasource="hermes">
select value2 from parameters2 where parameter='badsignature_action' and module = 'dkim'
</cfquery>

<cfquery name="get_dnserror_action" datasource="hermes">
select value2 from parameters2 where parameter='dnserror_action' and module = 'dkim'
</cfquery>

<cfquery name="get_internalerror_action" datasource="hermes">
select value2 from parameters2 where parameter='internalerror_action' and module = 'dkim'
</cfquery>
    
<cfquery name="get_nosignature_action" datasource="hermes">
select value2 from parameters2 where parameter='nosignature_action' and module = 'dkim'
</cfquery>

<cfquery name="get_security_action" datasource="hermes">
select value2 from parameters2 where parameter='security_action' and module = 'dkim'
</cfquery>

<cfquery name="get_signature_algorithm" datasource="hermes">
select value2 from parameters2 where parameter='signature_algorithm' and module = 'dkim'
</cfquery>

<cfquery name="get_headers_canonicalization" datasource="hermes">
select value2 from parameters2 where parameter='headers_canonicalization' and module = 'dkim'
</cfquery>

<cfparam name = "dkimenabled" default = "#get_dkim.enabled#"> 
<cfif IsDefined("form.dkimenabled") is "True">
<cfif form.dkimenabled is not "">
<cfset dkimenabled = form.dkimenabled>
</cfif></cfif> 

<cfparam name = "default_action" default = "#get_default_action.value2#"> 
<cfif IsDefined("form.default_action") is "True">
<cfif form.default_action is not "">
<cfset default_action = form.default_action>
</cfif></cfif> 

<cfparam name = "body_canonicalization" default = "#get_body_canonicalization.value2#"> 
<cfif IsDefined("form.body_canonicalization") is "True">
<cfif form.body_canonicalization is not "">
<cfset body_canonicalization = form.body_canonicalization>
</cfif></cfif> 

<cfparam name = "badsignature_action" default = "#get_badsignature_action.value2#"> 
<cfif IsDefined("form.badsignature_action") is "True">
<cfif form.badsignature_action is not "">
<cfset badsignature_action = form.badsignature_action>
</cfif></cfif> 

<cfparam name = "dnserror_action" default = "#get_dnserror_action.value2#"> 
<cfif IsDefined("form.dnserror_action") is "True">
<cfif form.dnserror_action is not "">
<cfset dnserror_action = form.dnserror_action>
</cfif></cfif> 

<cfparam name = "internalerror_action" default = "#get_internalerror_action.value2#"> 
<cfif IsDefined("form.internalerror_action") is "True">
<cfif form.internalerror_action is not "">
<cfset internalerror_action = form.internalerror_action>
</cfif></cfif> 

<cfparam name = "nosignature_action" default = "#get_nosignature_action.value2#"> 
<cfif IsDefined("form.nosignature_action") is "True">
<cfif form.nosignature_action is not "">
<cfset nosignature_action = form.nosignature_action>
</cfif></cfif> 

<cfparam name = "security_action" default = "#get_security_action.value2#"> 
<cfif IsDefined("form.security_action") is "True">
<cfif form.security_action is not "">
<cfset security_action = form.security_action>
</cfif></cfif> 

<cfparam name = "signature_algorithm" default = "#get_signature_algorithm.value2#"> 
<cfif IsDefined("form.signature_algorithm") is "True">
<cfif form.signature_algorithm is not "">
<cfset signature_algorithm = form.signature_algorithm>
</cfif></cfif> 

<cfparam name = "headers_canonicalization" default = "#get_headers_canonicalization.value2#"> 
<cfif IsDefined("form.headers_canonicalization") is "True">
<cfif form.headers_canonicalization is not "">
<cfset headers_canonicalization = form.headers_canonicalization>
</cfif></cfif> 




