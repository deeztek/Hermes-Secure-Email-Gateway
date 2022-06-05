
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

    <!--- GET MAIL QUEUE SETTINGS STARTS HERE --->

    <cfquery name="get_bounce_queue_lifetime" datasource="hermes">
      select id from parameters where parameter='bounce_queue_lifetime' and child = '2'
      </cfquery>
      
      <cfquery name="get_bounce_queue_lifetime_children" datasource="hermes">
      select * from parameters where parent='#get_bounce_queue_lifetime.id#' and child = '1' order by order1 asc
      </cfquery>
      
      <cfquery name="get_maximal_queue_lifetime" datasource="hermes">
      select id from parameters where parameter='maximal_queue_lifetime' and child = '2'
      </cfquery>
      
      <cfquery name="get_maximal_queue_lifetime_children" datasource="hermes">
      select * from parameters where parent='#get_maximal_queue_lifetime.id#' and child = '1' order by order1 asc
      </cfquery>
      
      <cfparam name = "bouncequeue" default = "#get_bounce_queue_lifetime_children.parameter#"> 
      <cfif IsDefined("form.bouncequeue") is "True">
      <cfif form.bouncequeue is not "">
      <cfset bouncequeue = form.bouncequeue>
      </cfif></cfif> 
      
      <cfparam name = "maxqueue" default = "#get_maximal_queue_lifetime_children.parameter#"> 
      <cfif IsDefined("form.maxqueue") is "True">
      <cfif form.maxqueue is not "">
      <cfset maxqueue = form.maxqueue>
      </cfif></cfif> 
      
      
    <!--- GET MAIL QUEUE SETTINGS ENDS HERE --->