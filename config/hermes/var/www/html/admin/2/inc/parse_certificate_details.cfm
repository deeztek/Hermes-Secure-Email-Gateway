
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
<!--- PARSE CERTIFICATE DETAILS STARTS HERE --->

  <!--- PARSE FINGERPRINT FROM CERTIFICATE --->
   <cftry>
    
    <cfexecute name = "/usr/bin/openssl"
    arguments="x509 -in #path# -noout -fingerprint"
    variable="fingerprint"
    timeout = "120">
    </cfexecute>
  

  <cfset fingerprint = REReplace("#fingerprint#","SHA1 Fingerprint=","","ALL")>
  <cfset fingerprint = #trim(fingerprint)#>


    <cfcatch type="any">
    

<cfset step=0>
<cfset session.m="Parse Certificate: Error #cfcatch.detail# while parsing certificate fingerprint">    
<cfinclude template="error.cfm">
<cfabort>
    
    </cfcatch>
    
    </cftry>
  
  <!--- PARSE SUBJECT FROM CERTIFICATE --->
  <cftry>
  <cfexecute name = "/usr/bin/openssl"
  arguments="x509 -in #path# -noout -subject"
  variable="subject"
  timeout = "120">
  </cfexecute>
  

  <cfset subject = REReplace("#subject#","subject=","","ALL")>
  <cfset subject = #trim(subject)#>

  
  <cfcatch type="any">
  
<cfset step=0>
<cfset session.m="Parse Certificate: Error #cfcatch.detail# while parsing certificate subject">
<cfinclude template="error.cfm">
<cfabort>
  
  </cfcatch>
  
  </cftry>
  
  <!--- PARSE ISSUER FROM CERTIFICATE --->
  <cftry>
  
    <cfexecute name = "/usr/bin/openssl"
    arguments="x509 -in #path# -noout -issuer"
    variable="issuer"
    timeout = "120">
    </cfexecute>
  

  <cfset issuer = REReplace("#issuer#","issuer=","","ALL")>
  <cfset issuer = #trim(issuer)#>

    
    <cfcatch type="any">
    
<cfset step=0>
<cfset session.m="Parse Certificate: Error #cfcatch.detail# while parsing certificate startdate">
<cfinclude template="error.cfm">
<cfabort>
    
    </cfcatch>
    
    </cftry>


<!--- PARSE STARTDATE FROM CERTIFICATE --->
 <cftry>
  
<cfexecute name = "/usr/bin/openssl"
arguments="x509 -in #path# -noout -startdate"
variable="thestartdate"
timeout = "120">
</cfexecute>


<cfset thestartdate = REReplace("#thestartdate#","notBefore=","","ALL")>
<cfset thestartdate = #trim(thestartdate)#>

  
<cfcatch type="any">

<cfset m="Parse Certificate: Error #cfcatch.detail# while parsing certificate startdate">
<cfinclude template="error.cfm">
<cfabort>
  
</cfcatch>
  
</cftry>

<!--- PARSE ENDDATE FROM CERTIFICATE --->
<cftry>
  
  <cfexecute name = "/usr/bin/openssl"
  arguments="x509 -in #path# -noout -enddate"
  variable="theenddate"
  timeout = "120">
  </cfexecute>
  

  <cfset theenddate = REReplace("#theenddate#","notAfter=","","ALL")>
  <cfset theenddate = #trim(theenddate)#>
  
    
  <cfcatch type="any">
  
  <cfset m="Parse Certificate: Error #cfcatch.detail# while parsing certificate enddate">
  <cfinclude template="error.cfm">
  <cfabort>
    
  </cfcatch>
    
  </cftry>



   <!--- PARSE SERIAL FROM CERTIFICATE --->
   <cftry>
    
    <cfexecute name = "/usr/bin/openssl"
    arguments="x509 -in #path# -noout -serial"
    variable="serial"
    timeout = "120">
    </cfexecute>
  

      <cfset serial = REReplace("#serial#","serial=","","ALL")>
      <cfset serial = #trim(serial)#>

  
    
    <cfcatch type="any">
    
<cfset step=0>
<cfset session.m="Parse Certificate: Error #cfcatch.detail# while parsing certificate serial">     
<cfinclude template="error.cfm">
<cfabort>
    
    </cfcatch>
    
    </cftry>

<cfinclude template="generate_customtrans.cfm" />

<cffile action="read" file="/opt/hermes/scripts/parse_san_certificate.sh" variable="theSan">


<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh"
output = "#REReplace("#theSan#","THE-PATH","#trim(path)#","ALL")#" addnewline="no">



<cftry>  
   
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh"
    timeout = "60">
    </cfexecute>
  
  <cfcatch type="any">
  
      <!--- DEBUG --->
    <!---
    <cfdump var="#cfcatch#">
      --->

      <cfset m="Parse Certificate: Error #cfcatch.detail# while executing /bin/chmod +x on /opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh">
      <cfinclude template="error.cfm">
      <cfabort>  
  
    </cfcatch>
  
  </cftry>

<!--- PARSE SAN FROM CERTIFICATE --->
   <cftry>
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh"
    variable="san"
    timeout = "120">
    </cfexecute>
  
<cfif #san# is "">

<cfset san = "N/A">

<cfelse>


<cfset san = #trim(san)#>
   

<!--- /CFIF #san# is ""--->
</cfif>
  
    
    <cfcatch type="any">
    
<cfset step=0>
<cfset session.m="Parse Certificate: Error #cfcatch.detail# while executing /bin/chmod +x on /opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh">
<cfinclude template="error.cfm">
<cfabort>
    
    </cfcatch>
    
    </cftry>

<!--- Delete /opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh File  --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_parse_san_certificate.sh">
    </cfif>
<!--- /CFIF #checkexists.recordcount# --->




<!--- PARSE CERTIFICATE DETAILS ENDS HERE --->
  