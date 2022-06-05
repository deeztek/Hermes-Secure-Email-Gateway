
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


<cfquery name="customtrans" datasource="hermes" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 8
  </cfquery>
  
  <cfquery name="inserttrans" datasource="hermes" result="stResult">
  insert into salt
  (salt)
  values
  ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
  </cfquery>
  
  <cfquery name="gettrans" datasource="hermes">
  select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>
  
  <cfset customtrans3=#gettrans.customtrans2#>
  
  <cfquery name="deletetrans" datasource="hermes">
  delete from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>


<cfquery name="getsignenabled" datasource="hermes">
select id, domain, public, private, selector, enabled from dkim_sign where enabled='1'
</cfquery>
    
    <cfset KeyTable = "">
    <cfloop query="getsignenabled">

<cfoutput>
    <cfset KeyEntry="#selector#._domainkey.#domain# #domain#:#selector#:/opt/hermes/dkim/keys/#private#">
    <cfset KeyTable = KeyTable & #KeyEntry# & #Chr(13)#&#Chr(10)#>
</cfoutput>

    </cfloop>
    
<cfoutput>
<cffile action = "write" file = "/opt/hermes/tmp/#customtrans3#_KeyTable" output = "#KeyTable#" addnewline="no">

<!--- BACKUP EXISTING KEYTABLE --->
  <cffile action="copy" source = "/opt/hermes/dkim/KeyTable" destination = "/opt/hermes/dkim/KeyTable.HERMES">
  
  <!--- REPLACE EXISTING KEYTABLE WITH GENERATED ONE ABOVE  --->
  <cffile action="move" source = "/opt/hermes/tmp/#customtrans3#_KeyTable" destination = "/opt/hermes/dkim/KeyTable">
  </cfoutput>