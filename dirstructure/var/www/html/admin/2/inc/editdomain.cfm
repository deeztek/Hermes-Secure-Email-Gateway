
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



<cfoutput>
    <cfset domain_name = #LCase(form.domain_name)#>
    <cfset domain_name = #trim(domain_name)#>
    
    
    <cfset destination_address = #LCase(form.destination_address)#>
    <cfset destination_address = #trim(destination_address)#>
    
    
    
    <!--- ENABLE BELOW FOR DEBUG ONLY --->
    <!---
    Domain Name: #domain_name#<br>
    Destination Address: #destination_address#
    --->
    </cfoutput>

<cfif #form.delivery_method# is "smtp">


<cfquery name="checkdomain" datasource="hermes">
select domain from domains where domain = '#domain_name#' and id <> <cfqueryparam value = #theDomainID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
        
<cfif #checkdomain.recordcount# GTE 1>
    
<cfset step=0>
<cfset session.m=8>

    
<cfelseif #checkdomain.recordcount# LT 1>

<cfif #form.destination_authentication# is "YES">

<!--- ENCRYPTION MECHANISM FOR USERNAME/PASSWORD --->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT USERNAME AND PASSWORD -->
<cfset encryptedUsername=encrypt(form.destination_username, #theKey#, "AES", "Base64")>
<cfset encryptedPassword=encrypt(form.destination_password, #theKey#, "AES", "Base64")>

<!--- UPDATE AUTHENTICATION FIELDS --->
<cfquery name="update_transport" datasource="hermes">
    update transport
    set
    authentication = '#form.destination_authentication#',
    authentication_username = '#encryptedUsername#',
    authentication_password = '#encryptedPassword#'
    where id = <cfqueryparam value = #theTransportID# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>


<!--- GENERATE /ETC/POSTFIX/SASL_PASSWD STARTS HERE --->
<cfinclude template="generate_sasl_password_transport.cfm">
<!--- GENERATE /ETC/POSTFIX/SASL_PASSWD ENDS HERE --->

<cfelseif #form.destination_authentication# is "NO">

<!--- UPDATE AUTHENTICATION FIELDS --->
<cfquery name="update_transport" datasource="hermes">
    update transport
    set
    authentication = '#form.destination_authentication#'
    where id = <cfqueryparam value = #theTransportID# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

<!--- GENERATE /ETC/POSTFIX/SASL_PASSWD STARTS HERE --->
<cfinclude template="generate_sasl_password_transport.cfm">
<!--- GENERATE /ETC/POSTFIX/SASL_PASSWD ENDS HERE --->

<!--- /CFIF form.destination_authentication is "YES" --->
</cfif>


<cfif #form.destination_mx# is "NO">
        
        <cfquery name="update_transport" datasource="hermes">
        update transport
        set
        domain = '#domain_name#', 
        transport = '#form.delivery_method#:[#destination_address#]:#form.destination_port#',
        destination = '#destination_address#',
        method = '#form.delivery_method#',
        port = '#form.destination_port#',
        mx = '#form.destination_mx#'
        where id = <cfqueryparam value = #theTransportID# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>

    <cfelse>

        <cfquery name="update_transport" datasource="hermes">
            update transport
            set
            domain = '#domain_name#', 
            transport = '#form.delivery_method#:#destination_address#:#form.destination_port#',
            destination = '#destination_address#',
            method = '#form.delivery_method#',
            port = '#form.destination_port#',
            mx = '#form.destination_mx#'
            where id = <cfqueryparam value = #theTransportID# CFSQLType = "CF_SQL_INTEGER">
            </cfquery>      

<!--- /CFIF #form.destination_mx# --->
</cfif>
        
        
    <cfquery name="update_senders_domain" datasource="hermes">
       update senders
       set
       sender = '#domain_name#',
       action = 'OK'
       where id = <cfqueryparam value = #theSenderID# CFSQLType = "CF_SQL_INTEGER">
    
        </cfquery>
        
        <cfquery name="update_recipients_domain" datasource="hermes">
        update recipients
        set
        recipient = '@#domain_name#',
        domain = '1',
        status = '#form.recipient_delivery#'
        where id = <cfqueryparam value = #theRecipientID# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        
        <cfquery name="update_hermes_domain" datasource="hermes">
        update domains
        set
        domain = '#domain_name#'
        where id = <cfqueryparam value = #theDomainID# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>


<cfset compare_domain = CompareNoCase(#theOriginalDomain#, #domain_name#)>

<cfif #compare_domain# is "1" OR #compare_domain# is "-1">



    <!--- DELETE DJIGZO DOMAIN STARTS HERE --->
    <cfinclude template="delete_domain_djigzo.cfm">

    <!--- DELETE DJIGZO DOMAIN ENDS HERE --->

    <!--- ADD DJIGZO DOMAIN STARTS HERE --->
    <cfinclude template="add_domain_djigzo.cfm">

   <!--- ADD DJIGZO DOMAIN ENDS HERE --->

    <!--- /CFIF compare_domain is 1 or -1 --->
    </cfif>


    <!--- GENERATE RELAY DOMAINS STARTS HERE --->
    <cfinclude template="generate_relay_domains.cfm">

   <!--- GENERATE RELAY DOMAINS ENDS HERE --->

       <!--- GENERATE TRANSPORTS STARTS HERE --->
       <cfinclude template="generate_transports.cfm">

       <!--- GENERATE TRANSPORTS ENDS HERE --->
              
    <!--- /CFIF #checkdomain.recordcount# --->
    </cfif>

<cfelseif #form.delivery_method# is "discard">

    <cfquery name="checkdomain" datasource="hermes">
        select domain from domains where domain = '#domain_name#' and id <> <cfqueryparam value = #theDomainID# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
                
        <cfif #checkdomain.recordcount# GTE 1>
            
        <cfset step=0>
        <cfset session.m=8>
        
            
        <cfelseif #checkdomain.recordcount# LT 1>
        
                
                <cfquery name="update_transport" datasource="hermes">
                update transport
                set
                domain = '#domain_name#', 
                transport = 'discard:Discard Email Silently',
                destination = '',
                method = 'discard',
                port = '25',
                mx = 'NO'
                where id = <cfqueryparam value = #theTransportID# CFSQLType = "CF_SQL_INTEGER">
                </cfquery>
                        
                
            <cfquery name="update_senders_domain" datasource="hermes">
               update senders
               set
               sender = '#domain_name#',
               action = 'OK'
               where id = <cfqueryparam value = #theSenderID# CFSQLType = "CF_SQL_INTEGER">
            
                </cfquery>
                
                <cfquery name="update_recipients_domain" datasource="hermes">
                update recipients
                set
                recipient = '@#domain_name#',
                domain = '1'
                where id = <cfqueryparam value = #theRecipientID# CFSQLType = "CF_SQL_INTEGER">
                </cfquery>
                
                <cfquery name="update_hermes_domain" datasource="hermes">
                update domains
                set
                domain = '#domain_name#'
                where id = <cfqueryparam value = #theDomainID# CFSQLType = "CF_SQL_INTEGER">
                </cfquery>


    <!--- GENERATE RELAY DOMAINS STARTS HERE --->
    <cfinclude template="generate_relay_domains.cfm">

   <!--- GENERATE RELAY DOMAINS ENDS HERE --->

       <!--- GENERATE TRANSPORTS STARTS HERE --->
       <cfinclude template="generate_transports.cfm">

       <!--- GENERATE TRANSPORTS ENDS HERE --->
              
    <!--- /CFIF #checkdomain.recordcount# --->
    </cfif>


<!--- /CFIF #form.delivery_method# is --->
</cfif>

        







