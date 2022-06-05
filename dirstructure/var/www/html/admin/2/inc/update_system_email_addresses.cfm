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

<cfquery name="updateadminemail" datasource="hermes">
    update system_settings set value='#form.admin_email#' where parameter='admin_email'
    </cfquery>
    
    <cfquery name="updatepostmaster" datasource="hermes">
    update system_settings set value='#form.postmaster#' where parameter='postmaster'
    </cfquery>
    
    <cfquery name="updatewizard" datasource="hermes">
    update system_settings set value='1' where parameter='wizard_settings'
    </cfquery>
    
    
    <cfquery name="deletesystemvirtual" datasource="hermes">
    delete from virtual_recipients where system='1'
    </cfquery>
    
    <cfquery name="deleteoldpostmastervirtual" datasource="hermes">
    delete from virtual_recipients where virtual_address='#form.postmaster#' and maps='#form.admin_email#'
    </cfquery>
    
    <cfquery name="insertpostmaster" datasource="hermes">
    insert into virtual_recipients
    (virtual_address, maps, system)
    values
    ('#form.postmaster#', '#form.admin_email#', '1')
    </cfquery>
    
    
    <cfset domainpart = #trim(ListGetAt(form.postmaster, 2, "@"))#>
    
    
    <cfquery name="deleteoldrootvirtual" datasource="hermes">
    delete from virtual_recipients where virtual_address='root@#domainpart#' and maps='#form.admin_email#'
    </cfquery>
    
    <cfquery name="insertroot" datasource="hermes">
    insert into virtual_recipients
    (virtual_address, maps, system)
    values
    ('root@#domainpart#', '#form.admin_email#', '1')
    </cfquery>
    
    
    <cfquery name="deleteoldabusevirtual" datasource="hermes">
    delete from virtual_recipients where virtual_address='abuse@#domainpart#' and maps='#form.admin_email#'
    </cfquery>
    
    <cfquery name="insertabuse" datasource="hermes">
    insert into virtual_recipients
    (virtual_address, maps, system)
    values
    ('abuse@#domainpart#', '#form.admin_email#', '1')
    </cfquery>
    