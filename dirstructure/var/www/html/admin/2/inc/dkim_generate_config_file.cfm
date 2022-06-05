
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


<!--- CONFIGURE OPENDKIM.CONF FILE BELOW --->

<cffile action="read" file="/opt/hermes/conf_files/opendkim.conf.HERMES" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","HEADER-CANONICALIZATION","#form.headers_canonicalization#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","BODY-CANONICALIZATION","#form.body_canonicalization#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","DEFAULT-ACTION","#form.default_action#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","BADSIGNATURE-ACTION","#form.badsignature_action#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","DNSERROR-ACTION","#form.dnserror_action#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","INTERNALERROR-ACTION","#form.internalerror_action#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","NOSIGNATURE-ACTION","#form.nosignature_action#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","SECURITY-ACTION","#form.security_action#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendkim.conf" variable="dkimfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendkim.conf"
    output = "#REReplace("#dkimfile#","SIGNATURE-ALGORITHM","#form.signature_algorithm#","ALL")#">


<!--- Backup opendkim.conf file --->
<cffile action = "copy" source = "/etc/opendkim.conf" 
destination = "/etc/opendkim.HERMES">

<!--- Move /opt/hermes/tmp/#customtrans3#_opendkim.conf to /etc/opendkim.conf --->
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_opendkim.conf" 
destination = "/etc/opendkim.conf">
    
<!--- CONFIGURE OPENDKIM.CONF FILE ABOVE --->

    
