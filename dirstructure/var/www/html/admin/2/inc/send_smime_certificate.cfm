
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

<cfquery name="getsettings" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>

        
    <cfquery name="getencryptiondetails" datasource="hermes">
     select * from recipients where id = <cfqueryparam value = #getcerts.user_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

    <cfif #getencryptiondetails.recordcount# LT 1>

      <cfset step=0>
      <cfset m="Send Recipient Certificate: getencryptiondetails.recordcount LT 1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

    <cfelse>

<!--- SEND THE PFX FILE E-MAIL --->       
<cfmail from="#getsettings.value#" to="#getencryptiondetails.recipient#" server="localhost" subject="Your PFX Certificate File" port="10026">
*** Please do not reply to this email. This email account is not monitored ***

Your PFX Certificate File is attached to this e-mail. 

Please follow the link below which contains detailed instructions on how to install the certificate and configure Outlook to send S/MIME encrypted email:

https://docs.deeztek.com/books/hosted/page/how-to-sendreceive-encrypted-email-from-microsoft-outlook

<cfif #getcerts.external_ca# is "1">
<cfmailparam file="/opt/hermes/HermesExternalCACerts/#getcerts.pfx_certificate_name#"> 
<cfelseif #getcerts.external_ca# is not "1">
<cfquery name="getcadetails" datasource="hermes">
select id, ca_directory from ca_settings where id='#getcerts.ca_id#'
</cfquery>
<cfmailparam file="/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/PFX/#getcerts.pfx_certificate_name#"> 
</cfif>

</cfmail>

  <!--- /CFIF #getencryptiondetails.recordcount# --->
    </cfif>