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

 <!--- Get myorigin parent parameter id --->
 <cfquery name="getmyoriginparent" datasource="hermes">
    select id from parameters where parameter='myorigin' and module='postfix' and conf_file='main.cf' and
     child='2'
    </cfquery>
    
    <!--- Update myorigin child parameter --->
    <cfquery name="updatemyorigin" datasource="hermes">
    update parameters set parameter='#ServerDomain#' where parent='#getmyoriginparent.id#' and child='1' and
     module='postfix' and conf_file='main.cf'
    </cfquery>
    
    <!--- Get myhostname parent parameter id --->
    <cfquery name="getmyhostnameparent" datasource="hermes">
    select id from parameters where parameter='myhostname' and module='postfix' and conf_file='main.cf' and
     child='2'
    </cfquery>
    
    <!--- Update myhostname child parameter --->
    <cfquery name="updatemyhostname" datasource="hermes">
    update parameters set parameter='#ServerName#' where parent='#getmyhostnameparent.id#' and child='1' and
     module='postfix' and conf_file='main.cf'
    </cfquery>