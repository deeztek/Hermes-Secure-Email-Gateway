
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

<cfif #form.request# is "1">
       


    <cfquery name = "gettimezones" datasource="hermes">
        select id, timezone from timezones where timezone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.search#%">
         </cfquery>
        

        
    <cfif #gettimezones.recordcount# GTE 1>
        


        <cfset dataArray = [] />
        <cfloop query="gettimezones">
            
                <cfscript> 
                dataStruct = {};
                dataStruct["value"] = gettimezones.id;
                dataStruct["label"] = gettimezones.timezone;
                dataArray.append(dataStruct);
                </cfscript> 
         
        </cfloop>
       
       
       
        <cfset response = serializejson(dataArray)>
       
        <cfoutput>#response#</cfoutput>
    
<cfelse>

</cfif>

<cfelseif #form.request# is "2">
<cfquery name = "gettimezones" datasource="hermes">
select id, timezone from timezones where id = <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #gettimezones.recordcount# GTE 1>

    <cfset dataArray = [] />
    <cfloop query="gettimezones">

        <cfscript> 
            dataStruct = {};
            dataStruct["id"] = gettimezones.id;
            dataStruct["timezone"] = gettimezones.timezone;
            dataArray.append(dataStruct);
            </cfscript> 
       
    </cfloop>

   <cfset certificates_arr = serializejson(dataArray)>
   
    <cfoutput>#certificates_arr#</cfoutput>
<cfelse>

</cfif>

</cfif>