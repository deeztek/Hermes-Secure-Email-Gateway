
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


<!--- CONFIGURE POLICYD-SPF.CONF FILE BELOW --->

<cffile action="read" file="/opt/hermes/templates/policyd-spf.conf.HERMES" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","DEBUG-LEVEL","#form.debuglevel#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","TEST-ONLY","#form.testonly#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","HELO-REJECT","#form.helo_reject#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","MAIL-FROM-REJECT","#form.mail_from_reject#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","PERMERROR-REJECT","#form.permerror_reject#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","TEMPERROR-REJECT","#form.temperror_defer#","ALL")#">

<!-- UPDATE SPF CONFIGURATION PARAMETERS ENDS HERE -->

<!-- ADD SPF BYPASS PARAMETERS HERE -->

<!--- NO LONGER USED SINCE IP AND NETWORK ARE NOW THE SAME TYPE --->

<!---
<!-- GET ALL ADD IP ACTIONS -->
<cfquery name="getaddip" datasource="hermes">
select entry from spf_bypass where entry_type='ip'
</cfquery>
--->


<!-- GET ALL ADD NETWORK ACTIONS -->
<cfquery name="getaddnetwork" datasource="hermes">
select entry from spf_bypass where entry_type='ip'
</cfquery>


<!-- GET ALL ADD HELO ACTIONS -->
<cfquery name="getaddhelo" datasource="hermes">
select entry from spf_bypass where entry_type='helo'
</cfquery>

<!-- GET ALL ADD DOMAIN ACTIONS -->
<cfquery name="getadddomain" datasource="hermes">
select entry from spf_bypass where entry_type='domain'
</cfquery>

<!-- GET ALL ADD PTR ACTIONS -->
<cfquery name="getaddptr" datasource="hermes">
select entry from spf_bypass where entry_type='ptr'
</cfquery>

<!--- NO LONGER USED SINCE IP AND NETWORK ARE SAME TYPE --->
<!---

<!-- CREATE FILEDATAADDIP VARIABLE AND INSERT ADD IP ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddIp = "">

<cfloop query="getaddip">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddip.currentrow# NEQ #getaddip.recordcount#> 
<cfset FileDataAddIp = FileDataAddIp & getaddip.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA NORMALLY, BUT SINCE THE IP AND NETWORK GO ON THE SAME LINE, WE ADD A COMMA HERE BECAUSE NETWORK
 ADDRESSES WILL FOLLOW -->
<cfelseif #getaddip.currentrow# EQ #getaddip.recordcount#>
<cfset FileDataAddIp = FileDataAddIp & getaddip.entry & #Chr(44)#>

<!-- /CFIF FOR GETADDIP.CURRENTROW -->
</cfif>

</cfloop>
--->


<!-- CREATE FILEDATAADDNETWORK VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddNetwork = "">
<cfloop query="getaddnetwork">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddnetwork.currentrow# NEQ #getaddnetwork.recordcount#> 
<cfset FileDataAddNetwork = FileDataAddNetwork & getaddnetwork.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddnetwork.currentrow# EQ #getaddnetwork.recordcount#>
<cfset FileDataAddNetwork = FileDataAddNetwork & getaddNetwork.entry>

<!-- /CFIF FOR GETADDNETWORK.CURRENTROW -->
</cfif>

</cfloop>

<!-- CREATE FILEDATAADDHELO VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddHelo = "">
<cfloop query="getaddhelo">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddhelo.currentrow# NEQ #getaddhelo.recordcount#> 
<cfset FileDataAddHelo = FileDataAddHelo & getaddhelo.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddhelo.currentrow# EQ #getaddhelo.recordcount#>
<cfset FileDataAddHelo = FileDataAddHelo & getaddHelo.entry>

<!-- /CFIF FOR GETADDHELO.CURRENTROW -->
</cfif>

</cfloop>

<!-- CREATE FILEDATAADDDOMAIN VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddDomain = "">
<cfloop query="getadddomain">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getadddomain.currentrow# NEQ #getadddomain.recordcount#> 
<cfset FileDataAddDomain = FileDataAddDomain & getadddomain.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getadddomain.currentrow# EQ #getadddomain.recordcount#>
<cfset FileDataAddDomain = FileDataAddDomain & getadddomain.entry>

<!-- /CFIF FOR GETADDDOMAIN.CURRENTROW -->
</cfif>
</cfloop>

<!-- CREATE FILEDATAADDPTR VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddPtr = "">
<cfloop query="getaddptr">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddptr.currentrow# NEQ #getaddptr.recordcount#> 
<cfset FileDataAddPtr = FileDataAddPtr & getaddptr.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddptr.currentrow# EQ #getaddptr.recordcount#>
<cfset FileDataAddPtr = FileDataAddPtr & getaddptr.entry>

<!-- /CFIF FOR GETADDPTR.CURRENTROW -->
</cfif>

</cfloop>

<!-- READ /OPT/HERMES/TMP/#CUSTOMTRANS3_POLICYD-SPF.CONF FILE CREATED ABOVE -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- CREATE TEMP FILE AND REPLACE IP-NETWORK-WHITELIST PLACEHOLDER WITH IPS AND NETWORK ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","IP-NETWORK-WHITELIST","#FileDataAddNetwork#","ALL")#"> 
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE HELO-WHITELIST PLACEHOLDER WITH HELO ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","HELO-WHITELIST","#FileDataAddHelo#","ALL")#">
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE DOMAIN-WHITELIST PLACEHOLDER WITH DOMAIN ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","DOMAIN-WHITELIST","#FileDataAddDomain#","ALL")#">
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE PTR-WHITELIST PLACEHOLDER WITH PTR ENTRIES -->  
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","PTR-WHITELIST","#FileDataAddPtr#","ALL")#">


<!-- ADD SPF BYPASS ENDS HERE -->

<!--- CONFIGURE POLICYD-SPF.CONF FILE ABOVE --->


    <!--- Backup policyd-spf.conf file --->
    <cffile action = "copy" source = "/etc/postfix-policyd-spf-python/policyd-spf.conf" 
    destination = "/etc/postfix-policyd-spf-python/policyd-spf.conf.HERMES">
    
    <!--- Move /opt/hermes/tmp/#customtrans3#_policyd-spf.conf to /etc/opendmarc/opendmarc.conf --->
    <cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" 
    destination = "/etc/postfix-policyd-spf-python/policyd-spf.conf">

    
