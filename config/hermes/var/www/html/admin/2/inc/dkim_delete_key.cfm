
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

<!--- DELETE DKIM KEY FILES --->

<cfquery name="getkeys" datasource="hermes">
 select public, private from dkim_sign where id = <cfqueryparam value = #form.key_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
    
<cfoutput>
<!--- CHECK FOR EXISTENCE OF /OPT/HERMES/DKIM/KEYS/PUBLIC --->
<cfset PublicFiletoDelete="/opt/hermes/dkim/keys/#getkeys.public#">
<cfif fileExists(#PublicFiletoDelete#)> 

<cffile action="delete" file="#PublicFiletoDelete#">

     
<!--- /CFIF fileExists(PublicFiletoDelete) --->
</cfif>


<!--- CHECK FOR EXISTENCE OF /OPT/HERMES/DKIM/KEYS/PRIVATE --->
<cfset PrivateFiletoDelete="/opt/hermes/dkim/keys/#getkeys.private#">
<cfif fileExists(#PrivateFiletoDelete#)> 

<cffile action="delete" file="#PrivateFiletoDelete#">

     
<!--- /CFIF fileExists(PrivateFiletoDelete) --->
</cfif>

</cfoutput>

<!--- DELETE DKIM KEY FROM DATABASE --->
<cfquery name="deletedkimkey" datasource="hermes">
delete from dkim_sign where id = <cfqueryparam value = #form.key_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
  
 