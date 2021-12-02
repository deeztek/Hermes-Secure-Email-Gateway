
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
       

    <cfquery name = "getcertificates" datasource="hermes">
        select * from system_certificates where (type like  '%#form.search#%') or (subject like  '%#form.search#%') or (issuer like  '%#form.search#%') or (serial like  '%#form.search#%') or (fingerprint like  '%#form.search#%') or (friendly_name like  '%#form.search#%')
        </cfquery>

        
    <cfif #getcertificates.recordcount# GTE 1>
        


        <cfset dataArray = [] />
        <cfloop query="getcertificates">
            
                <cfscript> 
                dataStruct = {};
                dataStruct["value"] = getcertificates.id;
                dataStruct["label"] = getcertificates.friendly_name;
                dataArray.append(dataStruct);
                </cfscript> 
         
        </cfloop>
       
       
       
        <cfset response = serializejson(dataArray)>
       
        <cfoutput>#response#</cfoutput>
    
<cfelse>

</cfif>

<cfelseif #form.request# is "2">
    <cfquery name = "getcertificates" datasource="hermes">
        select * from system_certificates where id like binary '#form.id#'
        </cfquery>

<cfif #getcertificates.recordcount# GTE 1>

    <cfset dataArray = [] />
    <cfloop query="getcertificates">

        <cfscript> 
            dataStruct = {};
            dataStruct["id"] = getcertificates.id;
            dataStruct["type"] = getcertificates.type;
            dataStruct["subject"] = getcertificates.subject;
            dataStruct["issuer"] = getcertificates.issuer;
            dataStruct["serial"] = getcertificates.serial;
            dataStruct["fingerprint"] = getcertificates.fingerprint;
            dataStruct["friendlyname"] = getcertificates.friendly_name;
            dataArray.append(dataStruct);
            </cfscript> 
       
    </cfloop>

   <cfset certificates_arr = serializejson(dataArray)>
   
    <cfoutput>#certificates_arr#</cfoutput>
<cfelse>

</cfif>

</cfif>