
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



<cfquery name="checkdomain" datasource="hermes">
select id, domain, transport_id, senders_id, recipients_id from domains where id = <cfqueryparam value = #form.domain_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkdomain.recordcount# GTE 1>

<!--- SET theOriginalDomain variable to be used by delete_domain_djigzo.cfm --->
<cfoutput>
<cfset theOriginalDomain=#checkdomain.domain#>
</cfoutput>

<cfquery name="checkrecipients" datasource="#datasource#">
select * from recipients where recipient like '%#theOriginalDomain#%' and domain is NULL
</cfquery>

<cfquery name="checkvirtual" datasource="#datasource#">
    select * from virtual_recipients where virtual_address like '%#theOriginalDomain#%'
    </cfquery>

<cfquery name="checkpostmaster" datasource="#datasource#">
    select parameter, value from system_settings where parameter = 'postmaster' and value like '%#theOriginalDomain#%'
    </cfquery>


<cfquery name="checkdkim" datasource="#datasource#">
    select domain from dkim_sign where domain like '%#theOriginalDomain#%'
    </cfquery>


<cfif #checkrecipients.recordcount# GTE 1>

    <cfset session.m=1>
  
    <cfoutput>
      <cflocation url="view_domains.cfm" addtoken="no">
      </cfoutput>
  

<cfelseif #checkvirtual.recordcount# GTE 1>

    <cfset session.m=2>
  
    <cfoutput>
      <cflocation url="view_domains.cfm" addtoken="no">
      </cfoutput>


    <cfelseif #checkpostmaster.recordcount# GTE 1>

    <cfset session.m=3>
  
    <cfoutput>
      <cflocation url="view_domains.cfm" addtoken="no">
      </cfoutput>

    <cfelseif #checkdkim.recordcount# GTE 1>

    <cfset session.m=4>
  
    <cfoutput>
      <cflocation url="view_domains.cfm" addtoken="no">
      </cfoutput>

<cfelse>


<!--- DELETE RECIPIENTS --->
<cfquery name="delete_domains" datasource="hermes">
delete from domains
where id = <cfqueryparam value = #form.domain_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- DELETE TRANSPORT --->
<cfquery name="delete_transport" datasource="hermes">
    delete from transport
    where id = <cfqueryparam value = #checkdomain.transport_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

<!--- DELETE SENDERS --->
<cfquery name="delete_senders" datasource="hermes">
    delete from senders
    where id = <cfqueryparam value = #checkdomain.senders_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

<!--- DELETE RECIPIENTS --->
<cfquery name="delete_recipients" datasource="hermes">
    delete from recipients
    where id = <cfqueryparam value = #checkdomain.recipients_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>


<!--- GENERATE TRANSPORTS STARTS HERE --->
<cfinclude template="generate_transports.cfm">

<!--- GENERATE RELAY DOMAINS STARTS HERE --->
<cfinclude template="generate_relay_domains.cfm">

<!--- GENERATE /ETC/POSTFIX/SASL_PASSWD STARTS HERE --->
<cfinclude template="generate_sasl_password_transport.cfm">

<!--- DELETE DJIGZO DOMAIN STARTS HERE --->
<cfinclude template="delete_domain_djigzo.cfm">

    
<!--- /CFIF checkrecipients.recordcount checkvirtual.recordcount checkpostmaster.recordcount checkdkim.recordcount --->
</cfif>
        
<cfelseif #checkdomain.recordcount# LT 1>


<cfset m="/inc/deletedomain.cfm: checkdomain.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>


<!--- /CFIF checkdomain.recordcount --->
</cfif>









