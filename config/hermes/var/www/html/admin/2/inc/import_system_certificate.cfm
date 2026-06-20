
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">
    
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_hermes.cer"
  output = "#form.certificate#"> 
  
  
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_hermes.chain.cer"
  output = "#form.chain#">
  
  
  <cffile action="read" file="/opt/hermes/scripts/verify_certificate.sh" variable="verify">
     
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
  output = "#REReplace("#verify#","CHAINFILE","/opt/hermes/tmp/#customtrans3#_hermes.chain.cer","ALL")#"> 
      
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_verify_certificate.sh" variable="verify">
   
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
  output = "#REReplace("#verify#","CERTIFICATEFILE","/opt/hermes/tmp/#customtrans3#_hermes.cer","ALL")#"> 
      
   
  <cfexecute name = "/bin/chmod"
  arguments="+x /opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
  timeout = "60">
  </cfexecute>
  
  <cftry>
  
  <cfexecute name = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
  arguments="-inputformat none"
  variable="check"
  timeout = "120">
  </cfexecute>
  
  <cfcatch type="any">
  
  <cfif #cfcatch.detail# contains "certificate has expired">
  

<cfset step=0>
<cfset session.m="The Certifcate and Root and Intermediate CA Certificates field have failed verification because the certificate is expired">
<cfset session.alerttype="error">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>
  
  <cfelseif #cfcatch.detail# contains "Error loading">
  
<cfset step=0>
<cfset session.m="The Certifcate and Root and Intermediate CA Certificates field have failed verification because they don't seem to be valid certificates">
<cfset session.alerttype="error">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>
  
  <cfelseif #cfcatch.detail# contains "unable to get local issuer certificate">
  
<cfset step=0>
<cfset session.m="The Certifcate and Root and Intermediate CA Certificates field have failed verification because they don't seem to be valid certificates">
<cfset session.alerttype="error">
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>
  
  <cfelse>
  

<cfset step=0>
<cfset session.m="The Certifcate and Root and Intermediate CA Certificates field have failed verification with undefined exception">
<cfset session.alerttype="error">
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>
  
    
  </cfif>
  
  <!---
  <cfdump var="#cfcatch#">
  --->
  
  </cfcatch>
  
  <cfif FindNoCase("hermes.cer: OK", check)>
  
    <!--- CONCATENATE HERMES.CER AND HERMES.CHAIN.CER INTO HERMES.BUNDLE.CER --->
    
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes.cer" variable="cert">
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes.chain.cer" variable="chain">
    
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hermes.bundle.cer"
    output = "#cert#"> 
    
    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_hermes.bundle.cer"
    output = "#chain#">
      
  
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_verify_certificate.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
    
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_output">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
  
        
    <cfset step=1>
    
    <cfelse>
  
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_hermes.cer">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
    
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_hermes.chain.cer">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
    
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_verify_certificate.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
        
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_output">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
    

<cfset step=0>
<cfset session.m="The Certifcate and Root and Intermediate CA Certificates field have failed verification because the certificate is expired">
<cfset session.alerttype="error">

    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>
  
    
    <!--- /CFIF FindNoCase("hermes.cer: OK", check) --->
    </cfif>
    
  
  </cftry>
  
  
  <cfif #step# is "1">
  
  <!--- PARSE FINGERPRINT FROM CERTIFICATE --->
   <cftry>
    
    <cfexecute name = "/usr/bin/openssl"
    arguments="x509 -in /opt/hermes/tmp/#customtrans3#_hermes.cer -noout -fingerprint"
    variable="fingerprint"
    timeout = "120">
    </cfexecute>
  
  <cfoutput>
  <cfset fingerprint = REReplace("#fingerprint#","SHA1 Fingerprint=","","ALL")>
  <cfset fingerprint = #trim(fingerprint)#>
  </cfoutput>
  
    <cfcatch type="any">


<cfset step=0>
<cfset session.m="There was an error parsing certificate parameters">
<cfset session.alerttype="error">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>
    
    </cfcatch>
    
    </cftry>
  
  <cfquery name="checkexists" datasource="hermes">
  select fingerprint from system_certificates where fingerprint = '#fingerprint#'
  </cfquery>
  
  <cfif #checkexists.recordcount# LT 1>
  
  <!--- PARSE SUBJECT FROM CERTIFICATE --->
  <cftry>
  <cfexecute name = "/usr/bin/openssl"
  arguments="x509 -in /opt/hermes/tmp/#customtrans3#_hermes.cer -noout -subject"
  variable="subject"
  timeout = "120">
  </cfexecute>
  
  <cfoutput>
  <cfset subject = REReplace("#subject#","subject=","","ALL")>
  <cfset subject = #trim(subject)#>
  </cfoutput>
  
  <cfcatch type="any">
  
<cfset step=0>
<cfset session.m="There was an error parsing certificate parameters">
<cfset session.alerttype="error">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>
  
  </cfcatch>
  
  </cftry>
  
  <!--- PARSE ISSUER FROM CERTIFICATE --->
  <cftry>
  
    <cfexecute name = "/usr/bin/openssl"
    arguments="x509 -in /opt/hermes/tmp/#customtrans3#_hermes.cer -noout -issuer"
    variable="issuer"
    timeout = "120">
    </cfexecute>
  
  <cfoutput>
  <cfset issuer = REReplace("#issuer#","issuer=","","ALL")>
  <cfset issuer = #trim(issuer)#>
  </cfoutput>
    
    <cfcatch type="any">
    
<cfset step=0>
<cfset session.m="There was an error parsing certificate parameters">
<cfset session.alerttype="error">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>
    
    </cfcatch>
    
    </cftry>

    <!---
  
    <!--- PARSE STARTDATE FROM CERTIFICATE --->
    <cftry>
  
      <cfexecute name = "/usr/bin/openssl"
      arguments="x509 -in /opt/hermes/tmp/#customtrans3#_hermes.cer -noout -startdate"
      variable="startdate"
      timeout = "120">
      </cfexecute>
  
  
  <cfoutput>
  <cfset startdate = REReplace("#startdate#","notBefore=","","ALL")>
  <cfset startdate = #trim(startdate)#>
  </cfoutput>
      
      <cfcatch type="any">
  
<cfset step=0>
<cfset session.m="There was an error parsing certificate parameters">
<cfset session.alerttype="error">
        
        <cfoutput>
        <cflocation url="view_system_certificates.cfm" addtoken="no">
        </cfoutput>
      
      </cfcatch>
      
      </cftry>
    
   <!--- PARSE ENDDATE FROM CERTIFICATE --->
      <cftry>
    
        <cfexecute name = "/usr/bin/openssl"
        arguments="x509 -in /opt/hermes/tmp/#customtrans3#_hermes.cer -noout -enddate"
        variable="enddate"
        timeout = "120">
        </cfexecute>
  
        <cfoutput>
          <cfset enddate = REReplace("#enddate#","notAfter=","","ALL")>
          <cfset enddate = #trim(enddate)#>
          </cfoutput>
      
        
        <cfcatch type="any">
        
<cfset step=0>
<cfset session.m="There was an error parsing certificate parameters">
<cfset session.alerttype="error">
          
          <cfoutput>
          <cflocation url="view_system_certificates.cfm" addtoken="no">
          </cfoutput>
        
        </cfcatch>
        
        </cftry>
      --->
    
   <!--- PARSE SERIAL FROM CERTIFICATE --->
   <cftry>
    
    <cfexecute name = "/usr/bin/openssl"
    arguments="x509 -in /opt/hermes/tmp/#customtrans3#_hermes.cer -noout -serial"
    variable="serial"
    timeout = "120">
    </cfexecute>
  
    <cfoutput>
      <cfset serial = REReplace("#serial#","serial=","","ALL")>
      <cfset serial = #trim(serial)#>
      </cfoutput>
  
    
    <cfcatch type="any">
    
<cfset step=0>
<cfset session.m="There was an error parsing certificate parameters">
<cfset session.alerttype="error">
      
      <cfoutput>
      <cflocation url="view_system_certificates.cfm" addtoken="no">
      </cfoutput>
    
    </cfcatch>
    
    </cftry>
  
  
  
  
  <cfquery name="insertcert" datasource="hermes">
    INSERT INTO system_certificates
    (type, subject, issuer, serial, fingerprint, file_name, friendly_name)
    VALUES
    ('Imported',
     <cfqueryparam value="#subject#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#issuer#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#serial#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#fingerprint#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#customtrans3#" cfsqltype="cf_sql_varchar">,
     <cfqueryparam value="#form.certificate_name#" cfsqltype="cf_sql_varchar">)
  </cfquery>
  
  <cffile action="move" 
  source = "/opt/hermes/tmp/#customtrans3#_hermes.cer"
  destination="/opt/hermes/ssl/#customtrans3#_hermes.pem">
  
  <cffile action="move" 
  source = "/opt/hermes/tmp/#customtrans3#_hermes.chain.cer"
  destination="/opt/hermes/ssl/#customtrans3#_hermes.chain.pem">
  
  <cffile action="move" 
  source = "/opt/hermes/tmp/#customtrans3#_hermes.bundle.cer"
  destination="/opt/hermes/ssl/#customtrans3#_hermes.bundle.pem">
  
  <cffile action = "write"
  file = "/opt/hermes/ssl/#customtrans3#_hermes.key"
  output = "#form.key#">
  
  <!--- Run Dos2Unix on /opt/hermes/ssl/#customtrans3#_hermes.pem --->
  <cfexecute name = "/usr/bin/dos2unix"
  arguments="/opt/hermes/ssl/#customtrans3#_hermes.pem"
  timeout = "60">
  </cfexecute>
  
  <!--- Run Dos2Unix on /opt/hermes/ssl/#customtrans3#_hermes.bundle.pem --->
  <cfexecute name = "/usr/bin/dos2unix"
  arguments="/opt/hermes/ssl/#customtrans3#_hermes.bundle.pem"
  timeout = "60">
  </cfexecute>
  
  <!--- Run Dos2Unix on /opt/hermes/ssl/#customtrans3#_hermes.chain.pem --->
  <cfexecute name = "/usr/bin/dos2unix"
  arguments="/opt/hermes/ssl/#customtrans3#_hermes.chain.pem"
  timeout = "60">
  </cfexecute>
  
  <!--- Run Dos2Unix on /opt/hermes/ssl/#customtrans3#_hermes.key --->
  <cfexecute name = "/usr/bin/dos2unix"
  arguments="/opt/hermes/ssl/#customtrans3#_hermes.key"
  timeout = "60">
  </cfexecute>
  

<cfset step=0>
<cfset session.m="Certificate Imported successfully">
<cfset session.alerttype="success">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>
  
  <cfelseif #checkexists.recordcount# GTE 1>
  

<cfset step=0>
<cfset session.m="The certificate was not imported because it already exists">
<cfset session.alerttype="error">
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>
  
  <!--- #checkexists.recordcount# --->
  </cfif>
  
  <!--- /CFIF step 1 --->
  </cfif>
  
    