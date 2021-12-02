
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

<!---
  <cfquery name="getrecipients" datasource="hermes">
    select id, recipient, policy_id, pdf_enabled, smime_enabled, pgp_enabled, digital_sign from recipients where domain is NULL
    </cfquery>
  --->

  <cfquery name="jwt_secret" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'jwt_secret'
    </cfquery>
      
    <cfquery name="access_control_rules_policy" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'access_control.rules.policy'
    </cfquery>
        
    <cfquery name="access_control_domain" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'access_control.domain'
    </cfquery>
      
    <cfquery name="authentication_backend_disable_reset_password" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'authentication_backend.disable_reset_password'
    </cfquery>
            
    <cfquery name="session_name" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.name'
    </cfquery>
    
    <cfquery name="session_secret" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.secret'
    </cfquery>
    
    <cfquery name="session_expiration" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.expiration'
    </cfquery>
    
    <cfquery name="session_inactivity" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.inactivity'
    </cfquery>
    
    <cfquery name="session_domain" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'session.domain'
    </cfquery>
    
    <cfquery name="notifier_smtp_host" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'notifier.smtp.host'
    </cfquery>
    
    <cfquery name="notifier_smtp_port" datasource="hermes">
    select value2 from parameters2 where module = 'authelia' and parameter = 'notifier.smtp.port'
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
    