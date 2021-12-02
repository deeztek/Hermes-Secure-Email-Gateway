
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

<!--- CREATE CUSTOMTRANS BELOW --->
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

     <!--- CREATE CUSTOMTRANS ABOVE --->

<!--- GET ANY EXISTING CERTIFICATES FROM DJIGZO --->
<cfquery name="getdjigzocertificates" datasource="djigzo">
select * from cm_certificates_email where cm_email='#recipient#'
</cfquery>

<!--- IF CERTIFICATES EXIST DUMP THEM INTO THE TEMP_TABLE FOR LATER COMPARISON --->
<cfif #getdjigzocertificates.recordcount# GTE 1>

  <cfloop query="getdjigzocertificates">
  
  <cfoutput>
  <cfquery name="insertcerts" datasource="hermes">
  insert into temp_table 
  (session_id, djigzo_certificate_id, recipient_id)
  values
  ('#customtrans3#', '#cm_certificates_id#', '#form.recipient_id#')
  </cfquery>
  </cfoutput>
  
  </cfloop>

  <!--- /CFIF #getdjigzocertificates.recordcount# GTE 1 --->
  </cfif>

<cffile action="read" file="/opt/hermes/scripts/import_pfx_file.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#password1#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh"
    output = "#REReplace("#temp#","THE-FILE","#theCertificateName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_import_pfx_file.sh"
timeout = "60">
</cfexecute>

<cftry>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh"
timeout = "240"
variable ="import"
arguments="">
</cfexecute>

<cfcatch>

<!--- IF THE ERROR IS WRONG PASSWORD OR CORRUPTED FILE --->
<cfif FindNoCase("wrong password or corrupted file", cfcatch.Detail)>

    <!--- DELETE SCRIPT --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh">

<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>


<!--- DELETE CERTIFICATE --->
<cfset FiletoDelete="/opt/hermes/tmp/#theCertificateName#">
<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>

<cfset session.m = 8>
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>
<cfabort>
   
<!--- IF THE ERROR IS UNDEFINED --->
<cfelse>

<!--- DELETE SCRIPT --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh">

<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>


<!--- DELETE CERTIFICATE --->
<cfset FiletoDelete="/opt/hermes/tmp/#theCertificateName#">
<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>

    <cfset session.m = 10>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>


<!--- /CFIF FindNoCase --->
</cfif>

</cfcatch>

<!--- IF COMMAND OUTPUT IS 0 NEW KEY(S) IMPORTED PROBABLY ALREADY EXISTS  --->
<cfif FindNoCase("0 new key(s) imported", import)>

<!--- DELETE SCRIPT --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh">

<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>


<!--- DELETE CERTIFICATE --->
<cfset FiletoDelete="/opt/hermes/tmp/#theCertificateName#">
<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>
  
    <cfset session.m = 9>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

  </cfif>
  
</cftry>

<!---
<cfscript> 
thread = CreateObject("java", "java.lang.Thread"); 
thread.sleep(5000); 
</cfscript>
--->

<!---
<cfquery name="getcertcount2" datasource="djigzo">
select count(cm_certificates_id) as certcount2 from cm_certificates_email where cm_email='#recipient#'
</cfquery>

<cfset nextcount=#getcertcount2.certcount2#>

<cfif #nextcount# GT #getdjigzocertificates.recordcount#>
--->

<cfset FiletoMove="/opt/hermes/tmp/#theCertificateName#">

<cfif fileExists(FiletoMove)> 

<cfoutput>
<cfexecute name = "/bin/mv"
arguments="/opt/hermes/tmp/#theCertificateName# /opt/hermes/HermesExternalCACerts/#customtrans3#_#recipient#.pfx"
timeout = "60">
</cfexecute>
</cfoutput>

<cfelse>

<!--- DELETE SCRIPT --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh">

<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>

<cfset session.m = 11>
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>
<cfabort>    

<!--- /CFIF fileExists(FiletoMove) --->
</cfif>

<!--- DELETE SCRIPT --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pfx_file.sh">

<cfif fileExists(FiletoDelete)> 
<cfoutput>
<cffile action="delete" 
file = "#FiletoDelete#">
</cfoutput>

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>


<cfquery name="getdjigzocertificates2" datasource="djigzo">
select * from cm_certificates_email where cm_email='#recipient#'
</cfquery>

<cfloop query="getdjigzocertificates2">

<cfquery name="exists" datasource="hermes">
select djigzo_certificate_id, recipient_id, session_id from temp_table where session_id='#customtrans3#' 
and recipient_id='#url.id#' and djigzo_certificate_id='#cm_certificates_id#'
</cfquery>

<cfif #exists.recordcount# LT 1>

<cfquery name="getcertprint" datasource="djigzo">
select * from cm_certificates where cm_id='#cm_certificates_id#'
</cfquery>

<cfset thumbprint="#getcertprint.cm_thumbprint#">
<cfset djigzo_certificate_id="#getcertprint.cm_id#">

<!--- /CFIF #exists.recordcount# LT 1 --->
</cfif>

</cfloop>

<cfif #ctl# is "1">

<cfquery name="getmax" datasource="djigzo">
SELECT max(cm_id) as maxid FROM cm_ctl
</cfquery>

<cfif #getmax.maxid# is "">
<cfset maxid2=0>
<cfset nextid=#maxid2#+1>

<cfelseif #getmax.maxid# is not "">

<cfset nextid=#getmax.maxid#+1>

<!--- /CFIF #getmax.maxid# is ""/#getmax.maxid# is not "" --->
</cfif>

<cfquery name="insertctl" datasource="djigzo">
insert into cm_ctl (cm_id, cm_name, cm_thumbprint) values ('#nextid#', 'global', '#thumbprint#')
</cfquery>

<cfquery name="insertctlnamewhitelisted" datasource="djigzo">
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'whitelisted', 'status')
</cfquery>

<cfquery name="insertctlnameexpired" datasource="djigzo">
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'false', 'allowExpired')
</cfquery>

<!--- /CFIF #ctl# is "1" --->
</cfif>


<cfquery name="deletetemp" datasource="hermes">
delete from temp_table where session_id='#customtrans3#'
</cfquery>


<cfset issuerfriendlyCN = rereplace(getcertprint.cm_issuer_friendly, "CN=", "", "all")>
<cfset issuerfriendlyOU = rereplace(issuerfriendlyCN, "OU=", "", "all")>
<cfset issuerfriendlyO = rereplace(issuerfriendlyOU, "O=", "", "all")>
<cfset external_ca_name = rereplace(issuerfriendlyO, "C=", "", "all")>
<cfset smime_certificate_expiration = #DateFormat(getcertprint.cm_not_after, "yyyy-mm-dd")#>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(password1, #theKey#, "AES", "Base64")>

<cfif #url.type# is "1">
<cfquery name="insert" datasource="hermes">
insert into recipient_certificates
(user_id, external_ca, pfx_certificate_name, smime_certificate_password, external_ca_name, smime_certificate_expiration, thumbprint, djigzo_certificate_id)
values
('#url.id#', '1', '#customtrans3#_#recipient#.pfx', '#encryptedPassword#', '#external_ca_name#', '#smime_certificate_expiration#', '#getcertprint.cm_thumbprint#', '#getcertprint.cm_id#')
</cfquery>

<cfelseif #url.type# is "2">
<cfquery name="insert" datasource="hermes">
insert into recipient_certificates
(user_id, external_ca, pfx_certificate_name, smime_certificate_password, external_ca_name, smime_certificate_expiration, thumbprint, djigzo_certificate_id, external)
values
('#url.id#', '1', '#customtrans3#_#recipient#.pfx', '#encryptedPassword#', '#external_ca_name#', '#smime_certificate_expiration#', '#getcertprint.cm_thumbprint#', '#getcertprint.cm_id#', '1')
</cfquery>

<!--- /CFIF #url.type# is "1"/#url.type# is "2" --->
</cfif>

<cfset password1="">
<cfset encryptedPassword="">

<!---

<cfelseif #nextcount# LTE #getdjigzocertificates.recordcount#>


<cfset FiletoDelete="/opt/hermes/tmp/#theCertificateName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>



<cfset session.m = 3>
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>
<cfabort>

<!---

<cfset m="Import Certificate: nextcount LTE getdjigzocertificates.recordcount">
<cfinclude template="error.cfm">
<cfabort>

--->

<!--- /CFIF  #nextcount# LTE #getdjigzocertificates.recordcount#/#nextcount# GT #getdjigzocertificates.recordcount#  --->
</cfif>

--->
