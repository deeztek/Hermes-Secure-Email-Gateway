

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

<cfquery name="server_ip" datasource="hermes">
    select * from parameters2 where parameter='server_ip' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_gateway" datasource="hermes">
    select * from parameters2 where parameter='server_gateway' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_dns1" datasource="hermes">
    select * from parameters2 where parameter='server_dns1' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_dns2" datasource="hermes">
    select * from parameters2 where parameter='server_dns2' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_dns3" datasource="hermes">
    select * from parameters2 where parameter='server_dns3' and module='network' and active='1'
    </cfquery>
    
    
    <cfquery name="server_name" datasource="hermes">
    select * from parameters2 where parameter='server_name' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_domain" datasource="hermes">
    select * from parameters2 where parameter='server_domain' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_subnet" datasource="hermes">
    select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="get_sa_spam_subject_tag" datasource="hermes">
    select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_virus_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_banned_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_spam_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_bad_header_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
    </cfquery>
