
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


<!--- Identity Validation JWT Secret --->
<cffile action="read" file="/opt/hermes/keys/authelia_identity_validation_reset_password_jwt_secret_file" variable="jwt_secret">
<cfset jwt_secret="#trim(jwt_secret)#">
<cfset jwt_secret = Right(jwt_secret, 4)>
<cfset jwt_secret = "********************#jwt_secret#">
      
    <cfquery name="access_control_rules_policy" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'access_control.rules.policy'
    </cfquery>
        
<!---        
    <cfquery name="access_control_domain" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'access_control.domain'
    </cfquery>
  ---> 
    <cfquery name="authentication_backend_disable_reset_password" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'authentication_backend.disable_reset_password'
    </cfquery>
            
    <cfquery name="session_name" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.name'
    </cfquery>

<!--- Session Secret --->
<cffile action="read" file="/opt/hermes/keys/authelia_session_secret_file" variable="session_secret">
<cfset session_secret="#trim(session_secret)#">
<cfset session_secret = Right(session_secret, 4)>
<cfset session_secret = "********************#session_secret#">


<!--- Redis Password --->
<cffile action="read" file="/opt/hermes/keys/authelia_session_redis_password_file" variable="redis_password">
<cfset redis_password="#trim(redis_password)#">
<cfset redis_password = Right(redis_password, 4)>
<cfset redis_password = "********************#redis_password#">

    
    <cfquery name="session_expiration" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.expiration'
    </cfquery>
    
    <cfquery name="session_inactivity" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.inactivity'
    </cfquery>
    
    <cfquery name="session_domain" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.domain'
    </cfquery>
    
    <cfquery name="notifier_smtp_sender" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'notifier.smtp.sender'
    </cfquery>
    
    <cfquery name="notifier_smtp_subject" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'notifier.smtp.subject'
    </cfquery>
      
    <cfquery name="regulation_max_retries" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'regulation.max_retries'
    </cfquery>
    
    <cfquery name="regulation_find_time" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'regulation.find_time'
    </cfquery>
    
    <cfquery name="regulation_ban_time" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'regulation.ban_time'
    </cfquery>
    
    <cfquery name="log_level" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'log.level'
    </cfquery>
    
    <cfquery name="log_format" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'log.format'
    </cfquery>
    
    <cfquery name="duo_disable" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'duo.disable'
    </cfquery>

<cfquery name="duo_hostname" datasource="hermes">
  select value2 from parameters2 where module = 'authelia' and parameter = 'duo.hostname'
  </cfquery>

<!--- Duo Intergration Key --->
<cffile action="read" file="/opt/hermes/keys/authelia_duo_api_integration_key_file" variable="duo_integration_key">
<cfset duo_integration_key="#trim(duo_integration_key)#">
<cfset duo_integration_key = Right(duo_integration_key, 4)>
<cfset duo_integration_key = "********************#duo_integration_key#">

<!--- Duo Secret Key --->
<cffile action="read" file="/opt/hermes/keys/authelia_duo_api_secret_key_file" variable="duo_secret_key">
<cfset duo_secret_key="#trim(duo_secret_key)#">
<cfset duo_secret_key = Right(duo_secret_key, 4)>
<cfset duo_secret_key = "********************#duo_secret_key#">

<cfquery name="duo_self_enrollment" datasource="hermes">
  select value2 from parameters2 where module = 'authelia' and parameter = 'duo.self_enrollment'
  </cfquery>

<!--- Storage Encryption Key --->
<cffile action="read" file="/opt/hermes/keys/authelia_storage_encryption_key_file" variable="storage_encryption_key">
<cfset storage_encryption_key="#trim(storage_encryption_key)#">
<cfset storage_encryption_key = Right(storage_encryption_key, 4)>
<cfset storage_encryption_key = "********************#storage_encryption_key#">

<!--- OIDC HMAC Secret --->
<cffile action="read" file="/opt/hermes/keys/authelia_identity_providers_oidc_hmac_secret_file" variable="oidc_hmac_secret">
<cfset oidc_hmac_secret="#trim(oidc_hmac_secret)#">
<cfset oidc_hmac_secret = Right(oidc_hmac_secret, 4)>
<cfset oidc_hmac_secret = "********************#oidc_hmac_secret#">

<!--- OIDC Key --->
<cffile action="read" file="/opt/hermes/keys/authelia_identity_providers_oidc_jwks_file" variable="oidc_key">
<cfset oidc_key="#trim(oidc_key)#">
<cfset oidc_key="#REReplace("#oidc_key#","-----BEGIN RSA PRIVATE KEY-----","","ALL")#">
<cfset oidc_key="#REReplace("#oidc_key#","-----END RSA PRIVATE KEY-----","","ALL")#">
<cfset oidc_key="#REReplace("#oidc_key#","-----BEGIN PRIVATE KEY-----","","ALL")#">
<cfset oidc_key="#REReplace("#oidc_key#","-----END PRIVATE KEY-----","","ALL")#">
<cfset oidc_key = Right(oidc_key, 10)>
<cfset oidc_key = "**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************#oidc_key#">

<!--- Webmail OIDC Client Secret Plain --->
<cffile action="read" file="/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_plain_file" variable="oidc_client_secret">
<cfset oidc_client_secret="#trim(oidc_client_secret)#">
<cfset oidc_client_secret = Right(oidc_client_secret, 4)>
<cfset oidc_client_secret = "********************#oidc_client_secret#">


<!--- GET DATABASE CREDENTIALS FROM /OPT/HERMES/CREDS STARTS HERE - NOT USED YET 
<cffile action="read" file="/opt/hermes/creds/hermes_username" variable="mysqlusernamehermes">
<cffile action="read" file="/opt/hermes/creds/hermes_password" variable="mysqlpasswordhermes">
--->