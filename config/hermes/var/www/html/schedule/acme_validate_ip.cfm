 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- ACME SAN validation runs on all editions (#282). --->

<cfparam name = "requestacme" default = "0">

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">

<cfscript>
    // Normalise a raw error string for the varchar(255) *_result_msg columns:
    // collapse whitespace so the Certificates table stays on one line,
    // guarantee an ERROR: prefix, and cap the length. Storing raw output
    // unbounded and unbound was how an apostrophe in "Let's Encrypt" could
    // take down the whole job.
    function sanErrMsg(required string raw) {
        var msg = trim(reReplace(arguments.raw, "[[:space:]]+", " ", "all"));
        if (!len(msg)) { msg = "unknown error"; }
        if (ucase(left(msg, 6)) != "ERROR:") { msg = "ERROR: " & msg; }
        if (len(msg) > 255) { msg = left(msg, 252) & "..."; }
        return msg;
    }
</cfscript>


  <cfquery name="getsubdomains" datasource="hermes">
select id, certificate, mailbox_domain, subdomain, ip from mailbox_sans
  </cfquery>


<cfif #getsubdomains.recordcount# GTE 1>

<cfloop query="getsubdomains">

<!--- Reset per row. step was never cleared between iterations, so a value left
     over from a previous name could be read by the branches below. --->
<cfset step = "0">
<cfset sanRowFailed = false>
<cfset sanFailReason = "">


<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="../admin/2/inc/generate_customtrans.cfm">
  
<!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY STARTS HERE --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_verifyip"
output = "#subdomain#" addnewline="no">
  

  <cftry> 

  <cfexecute name = "/usr/bin/openssl"
    arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_verifyip -out /opt/hermes/tmp/#customtrans3#_verifyip.ssl"
    timeout = "60">
    </cfexecute>
    
    <cfcatch type="any">
 
        <cfset sanRowFailed = true>
        <cfset sanFailReason = "could not encrypt the verification payload. " & cfcatch.message>


    </cfcatch>
    </cftry>

<!--- Row-level bail out. Clean up this row's temp files, record why it could
     not be verified where the Certificates page will show it, and move to the
     next name.

     Every one of these paths used to <cfabort>. The abort killed the whole
     request, and the issuance loop further down never ran, so one name that
     could not be verified silently blocked certificate issuance for every
     certificate on the box, with no message anywhere because Ofelia discards
     stdout.

     'ip' is deliberately left as it was. A transient network failure must not
     un-validate a name that verified previously, because that would force an
     unnecessary re-request and can reach a rate limit. --->
<cfif sanRowFailed>

  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_verifyip")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_verifyip">
  </cfif>
  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_verifyip.ssl")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
  </cfif>

  <cfset sanFailReason = sanErrMsg(sanFailReason)>

  <cfquery datasource="hermes">
    UPDATE mailbox_sans
    SET ip_result_msg = <cfqueryparam value="#sanFailReason#" cfsqltype="cf_sql_varchar">,
        ip_result_datetime = <cfqueryparam value="#datenow# #timenow#" cfsqltype="cf_sql_timestamp">
    WHERE id = <cfqueryparam value="#getsubdomains.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfoutput>#encodeForHTML(getsubdomains.subdomain)#: #encodeForHTML(sanFailReason)#</cfoutput><br>

  <cfcontinue>

</cfif>

    
 <!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY ENDS HERE --->
  

 <cftry> 


      <CFHTTP METHOD="Post" URL="https://verify.hermesseg.io" timeout="60">
      
      <CFHTTPPARAM TYPE="File"
              NAME="#customtrans3#_verifyip.ssl"
              FILE="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
              
      <CFHTTPPARAM TYPE="Formfield"
              VALUE="#customtrans3#"
              NAME="customtrans">
              
      </CFHTTP>


    <cfcatch type="any">
 
        <cfset sanRowFailed = true>
        <cfset sanFailReason = "could not reach https://verify.hermesseg.io. " & cfcatch.message>


    </cfcatch>
    </cftry>

<!--- Row-level bail out. See the note on the first one above. --->
<cfif sanRowFailed>

  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_verifyip")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_verifyip">
  </cfif>
  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_verifyip.ssl")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
  </cfif>

  <cfset sanFailReason = sanErrMsg(sanFailReason)>

  <cfquery datasource="hermes">
    UPDATE mailbox_sans
    SET ip_result_msg = <cfqueryparam value="#sanFailReason#" cfsqltype="cf_sql_varchar">,
        ip_result_datetime = <cfqueryparam value="#datenow# #timenow#" cfsqltype="cf_sql_timestamp">
    WHERE id = <cfqueryparam value="#getsubdomains.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfoutput>#encodeForHTML(getsubdomains.subdomain)#: #encodeForHTML(sanFailReason)#</cfoutput><br>

  <cfcontinue>

</cfif>

    
 <!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY ENDS HERE --->
  
 <!--- Uncomment below to debug --->
 <!---
<cfoutput> #cfhttp.status_code# </cfoutput>      
 --->

      <cfif #cfhttp.status_code# EQ "200">

 <!---  Delete Temp Files --->     

      <cfset verifyipfile="/opt/hermes/tmp/#customtrans3#_verifyip">
      <cfif fileExists(verifyipfile)>
      
      <cffile action = "delete" file = "#verifyipfile#">
      
      <!--- /CFIF fileExists(verifyipfile)> --->
      </cfif>
      
      <cfset verifyipfile_ssl="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
      <cfif fileExists(verifyipfile_ssl)>
      
      <cffile action = "delete" file = "#verifyipfile_ssl#">
      
      <!--- /CFIF fileExists(verifyipfile_ssl)> --->
      </cfif>

   
      <cfset step="1">



    <cfelse>

<!--- Verification service did not answer 200. --->
<cfset sanRowFailed = true>
<cfset sanFailReason = "verification service returned HTTP " & cfhttp.status_code>

<!--- Row-level bail out. See the note on the first one above. --->
<cfif sanRowFailed>

  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_verifyip")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_verifyip">
  </cfif>
  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_verifyip.ssl")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
  </cfif>

  <cfset sanFailReason = sanErrMsg(sanFailReason)>

  <cfquery datasource="hermes">
    UPDATE mailbox_sans
    SET ip_result_msg = <cfqueryparam value="#sanFailReason#" cfsqltype="cf_sql_varchar">,
        ip_result_datetime = <cfqueryparam value="#datenow# #timenow#" cfsqltype="cf_sql_timestamp">
    WHERE id = <cfqueryparam value="#getsubdomains.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfoutput>#encodeForHTML(getsubdomains.subdomain)#: #encodeForHTML(sanFailReason)#</cfoutput><br>

  <cfcontinue>

</cfif>

<!--- /CFIF  #cfhttp.status_code# EQ "200" --->
  </cfif>
 

<cfif #step# is "1">

  <cftry>
    <cfset serverResponse="#trim(cfhttp.FileContent)#">
     
    <cfcatch type="any">
    
    
    <cfif #cfcatch.message# contains "invalid call of the function listGetAt">
    
    
        <cfoutput>#encodeForHTML(getsubdomains.subdomain)#: could not read the verification response.</cfoutput><br>
    
    <!-- /CFIF cfcatch.message -->
    </cfif>
    
    
    </cfcatch>

    <!---
    <cfoutput>#serverResponse#</cfoutput></br>
    --->
    
    <cfset step="2">
    
    </cftry>


<!--- /CFIF #step# is "1" --->
</cfif>

<cfif #step# is "2">

<cfif #serverResponse# contains "ERROR">



 <cfquery name="updateauto" datasource="hermes">
  update mailbox_sans set ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#'
  where id = '#id#'
  </cfquery>

<cfelseif #serverResponse# contains "SUCCESS">


 <cfquery name="updateauto" datasource="hermes">
  update mailbox_sans set ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#', ip = 'YES'
  where id = '#id#'
  </cfquery>


<!--- /CFIF #serverresponse# contains --->
</cfif>



<!--- /CFIF #step# is "2" --->
</cfif>

<!--- /CFLOOP getsubdomains --->
</cfloop>

<cfelse>

<cfoutput>No SAN Domains found. Nothing to do. Exiting...</cfoutput><br>

<cfabort>

<!--- /CFIF #getsubdomains.recordcount# --->
</cfif>


<!--- Get all validated ip san subdomains --->
<cfquery name="getvalidatedip" datasource="hermes">
select distinct(certificate) from mailbox_sans where ip = 'YES'
</cfquery>


<cfloop query = "getvalidatedip">

<!--- Ensure requestacme=0  --->
<cfset requestacme=0>

<!--- Create validated ip subdomain hash starts here --->
<cfquery name="create_validated_hash" datasource="hermes">
  select subdomain from mailbox_sans where certificate = '#certificate#' and ip = 'YES' order by subdomain asc
</cfquery>

<!--- If records exist --->
<cfif #create_validated_hash.recordcount# GTE 1>

<!--- Generate the current SAN Subdomain string out of the previous query --->
<cfset san_list = ValueList(create_validated_hash.subdomain)>

<!--- Convert List to Array --->
<cfset san_array = ListToArray(san_list, ",")>

<!--- Iterate through the array and remove any white spaces from each element --->
<cfloop index="i" from="1" to="#ArrayLen(san_array)#">
    <cfset san_array[i] = trim(san_array[i])>
</cfloop>

<!-- Convert array back to string for further use -->
<cfset san_list = ArrayToList(san_array, ",")>

<!--- Create current SAN Hash --->
<cfset newHash = Hash(san_list, "SHA-256")>
<cfoutput>New Hash: #newHash#</cfoutput><br>



<!--- Create validated ip subdomain hash ends here --->

<!--- Get previous validatedip hash if it exists --->
<cfquery name="getprevioushash" datasource="hermes">
select acme_hash from system_certificates where id = '#certificate#'
</cfquery>

<cfset oldHash = #getprevioushash.acme_hash#>
<cfoutput>Old Hash: #oldHash#</cfoutput><br>

<!--- The hash is banked ONLY after a request succeeds, further down, next to
     the "Congratulations" check.

     It used to be written here, before the request was attempted. A request
     that then failed, or that was never going to succeed because the
     certificate is an Imported one rather than an Acme one, left the hash on
     the record anyway. Every later run read it back, found it matched, and
     took the "already covered" branch below. One failed attempt therefore
     convinced the system the work was done, permanently: the certificate
     stayed Pending and its SANs stayed marked validated, with no retry ever
     attempted. Seen in the field on a certificate stuck for six days.

     Writing it only on success makes a failure retryable, which is what the
     30 minute schedule is for. --->
<cfif #oldHash# is "">

<cfoutput>No SAN Domains Hash found. Will attempt new certificate request..</cfoutput><br>
<cfset requestacme=1>

<cfelse>

<!--- If Old hash does not equal new hash then set requestacme=1 so that it will request new Acme cert --->
<cfif #oldHash# NEQ #newHash#>
<cfset requestacme=1>
<cfoutput>SAN Domains Hash changed. Will attempt new certificate request...</cfoutput><br>

<!--- /CFIF #oldHash# NEQ #newHash# --->
</cfif>

<!--- /CFIF #oldHash# is "" --->
</cfif>

<cfif #requestacme# is "1">

<!--- Count the number of subdomains from previous create_validated_hash query from above --->
<cfset totalsubdomain = #create_validated_hash.recordcount#>

<cfoutput>Total number of SANs is: #totalsubdomain#</cfoutput><br>

<cfif #totalsubdomain# LT 100>

<cfoutput>The number of SANs is below 100. Proceeding with certificate request...</cfoutput><br>

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="../admin/2/inc/generate_customtrans.cfm">

  <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_san_domains"
        output = "" addnewline="no">

<!--- Create SAN subdomain list from create_validated_hash query above --->
<cfoutput query="create_validated_hash">

    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_san_domains"
    output = "-d #subdomain##chr(32)#"
    addNewLine = "no">

</cfoutput>


<!--- GET CERTIFICATE NAME --->
<cfquery name="getcertname" datasource="hermes">
 select domain_name from system_certificates where id = '#certificate#'
</cfquery>  


<cfset theCertname = "#getcertname.domain_name#">



<!--- READ THE SAN_DOMAINS OUTPUT FILE --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_san_domains" variable="theSan">


 <!--- DELETE /opt/hermes/tmp/#customtrans3#_san_domains --->
 <cfset sansdomains="/opt/hermes/tmp/#customtrans3#_san_domains">
 <cfif fileExists(sansdomains)>
 
 <cffile action = "delete" file = "#sansdomains#">
 
 <!-- /CFIF fileExists(sansdomains)> -->
 </cfif>


 <cfoutput>Requesting new certificate for certificate #theCertname#...</cfoutput><br>

<!--- REQUEST SAN CERTIFICATE--->
<cfinclude template="../admin/2/inc/acme_request_san_certificate.cfm">

<cfoutput>Acme Output: #acmeOutput#</cfoutput><br>

<cfoutput>Docker Directory: #DockerDir#</cfoutput><br>

<cfif FindNoCase("Successfully received certificate", acmeOutput)>

<cfquery name="insertsuccess" datasource="hermes">
update mailbox_sans set dns = 'YES', dns_result_msg = 'SUCCESS: Successfully Received SAN Certificate', dns_result_datetime = '#datenow# #timenow#' where certificate = '#certificate#' and ip = 'YES'
</cfquery>

<!--- Bank the hash HERE, and only here. Writing it before the request meant a
     failure was recorded as success for every run that followed. --->
<cfquery name="updatehash" datasource="hermes">
update system_certificates set acme_hash = '#newHash#' where id = '#certificate#'
</cfquery>

<cfoutput>Successfully obtained certificate for #theCertname#...</cfoutput><br>

<!--- GENERATE NGINX CONFIGURATION (includes SNI configs) --->
<cfinclude template="../admin/2/inc/generate_nginx_configuration.cfm">

<!--- RESTART NGINX --->
<cfinclude template="../admin/2/inc/restart_nginx.cfm">

<!--- GENERATE SMTP SNI CONFIGURATION --->
<cfinclude template="generate_smtp_sni.cfm">

<!--- GENERATE POSTFIX CONFIGURATION (includes SMTP SNI parameter if enabled) --->
<cfinclude template="../admin/2/inc/generate_postfix_configuration.cfm">

<cfelse>

<!--- Record why it failed, on the rows the Certificates page shows.

     This used to interpolate the raw certbot output straight into the SQL.
     Two ways that broke: certbot output routinely contains an apostrophe
     ("Let's Encrypt" alone is enough), which is a syntax error that killed
     the whole scheduled job; and dns_result_msg is varchar(255) while certbot
     output runs to many lines. Collapse the whitespace so the table stays
     readable, cap it, and bind it. --->
<cfif Len(Trim(acmeOutput))>
  <cfset acmeErrMsg = sanErrMsg(acmeOutput)>
<cfelse>
  <cfset acmeErrMsg = sanErrMsg("certbot produced no output")>
</cfif>

<cfquery name="insertfailure" datasource="hermes">
update mailbox_sans
set dns_result_msg = <cfqueryparam value="#acmeErrMsg#" cfsqltype="cf_sql_varchar">,
    dns_result_datetime = <cfqueryparam value="#datenow# #timenow#" cfsqltype="cf_sql_timestamp">
where certificate = <cfqueryparam value="#certificate#" cfsqltype="cf_sql_integer">
and ip = 'YES' and dns = 'NO'
</cfquery>

<cfoutput>Could not obtain certificate for #theCertname#. Error reported was: #acmeOutput#</cfoutput><br>

<!--- /CFIF FindNoCase("Congratulations", acmeOutput) --->
</cfif>


<cfelse>

<cfquery name="insertsanlimit" datasource="hermes">
update mailbox_sans set dns_result_msg = 'ERROR: SAN limit reached', dns_result_datetime = '#datenow# #timenow#' where certificate = '#certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>

<cfoutput>SAN limit reached for certificate #theCertname#</cfoutput><br>


<!--- /CFIF #totalsubdomain# LT 100 --->
</cfif>

<cfelse>

<!--- Hash unchanged. That used to be treated as proof the certificate already
     covers these SANs, and it is not: the hash is computed over the SAN NAMES
     alone and stored per certificate, so it says the requested set has not
     changed and nothing whatever about what the certificate contains.

     The consequence was rows marked 'verified against existing certificate'
     against a certificate that did not contain them. Observed on a mailbox
     domain whose mailbox_certificate was the bootstrap certificate, whose
     SANs are localhost and hermes-bootstrap.local: two domain.tld names
     were marked validated against it, which then stopped any new certificate
     ever being requested and switched on tls_server_sni_maps pointing at a
     certificate covering none of those names.

     So ask the certificate. A matching hash now only earns the chance to
     check, and every name is verified against the SAN list before its row is
     marked validated.

     Deliberately FAILS OPEN: if the certificate cannot be read or parsed, the
     previous behaviour is kept. Being wrong in the strict direction would
     re-request certificates unnecessarily and could reach a rate limit, which
     is worse than leaving a row as it was. --->
<cfquery name="checkStuckDns" datasource="hermes">
  SELECT id, subdomain FROM mailbox_sans
  WHERE certificate = '#certificate#'
  AND ip = 'YES'
  AND dns = 'NO'
</cfquery>

<cfif checkStuckDns.recordcount GT 0>

<!--- Read the SAN list once for this certificate. --->
<cfset certSanNames = "">
<cfset certSanReadable = false>
<cftry>
    <!--- Fetched here rather than reused: getcertname is only defined in the
         request branch above, which did not run on this path. --->
    <cfquery name="sanCertDetails" datasource="hermes">
        SELECT type, file_name FROM system_certificates
        WHERE id = <cfqueryparam value="#certificate#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset sanCertPath = "">
    <cfif sanCertDetails.recordcount GTE 1 AND sanCertDetails.type IS "Acme">
        <cfset sanCertPath = "/etc/letsencrypt/live/" & sanCertDetails.file_name & "/fullchain.pem">
    <cfelseif sanCertDetails.recordcount GTE 1 AND sanCertDetails.type IS "Imported">
        <cfset sanCertPath = "/opt/hermes/ssl/" & sanCertDetails.file_name & "_hermes.bundle.pem">
    </cfif>
    <cfif Len(sanCertPath) AND FileExists(sanCertPath)>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_postfix_dkim openssl x509 -noout -ext subjectAltName -in #sanCertPath#"
            variable="sanOut" timeout="20"/>
        <cfif Len(Trim(sanOut))>
            <cfloop index="sanTok" list="#Trim(sanOut)#" delimiters=",#chr(10)##chr(13)#">
                <cfset sanTok = Trim(sanTok)>
                <cfif Left(sanTok, 4) IS "DNS:">
                    <cfset certSanNames = ListAppend(certSanNames, LCase(Trim(Mid(sanTok, 5, Len(sanTok)))))>
                </cfif>
            </cfloop>
            <cfif ListLen(certSanNames)>
                <cfset certSanReadable = true>
            </cfif>
        </cfif>
    </cfif>
<cfcatch type="any">
    <cfset certSanReadable = false>
</cfcatch>
</cftry>

<cfif NOT certSanReadable>
    <cfoutput>Could not read the SAN list for certificate ###certificate#; leaving #checkStuckDns.recordcount# row(s) unchanged rather than guessing.</cfoutput><br>
<cfelse>
<cfset sanVerified = "">
<cfset sanRejected = "">
<cfloop query="checkStuckDns">
    <cfset thisFqdn = LCase(Trim(checkStuckDns.subdomain))>
    <cfset thisParent = ListRest(thisFqdn, ".")>
    <cfif ListFindNoCase(certSanNames, thisFqdn) GT 0
          OR (Len(thisParent) AND ListFindNoCase(certSanNames, "*." & thisParent) GT 0)>
        <cfset sanVerified = ListAppend(sanVerified, checkStuckDns.id)>
    <cfelse>
        <cfset sanRejected = ListAppend(sanRejected, thisFqdn)>
    </cfif>
</cfloop>

<cfif ListLen(sanRejected)>
    <cfoutput>Certificate ###certificate# does not cover: #encodeForHTML(sanRejected)#. Left unvalidated so a certificate can be requested for them.</cfoutput><br>
</cfif>

<cfif ListLen(sanVerified)>
<cfquery datasource="hermes">
  UPDATE mailbox_sans
  SET dns = 'YES',
      dns_result_msg = 'SUCCESS: SAN present in the existing certificate',
      dns_result_datetime = '#datenow# #timenow#'
  WHERE id IN (<cfqueryparam value="#sanVerified#" list="true" cfsqltype="cf_sql_integer">)
</cfquery>

<cfoutput>Verified #ListLen(sanVerified)# SAN(s) against the existing certificate. Regenerating Nginx...</cfoutput><br>

<!--- /CFIF ListLen(sanVerified) --->
</cfif>

<!--- /CFIF NOT certSanReadable --->
</cfif>

<!--- GENERATE NGINX CONFIGURATION --->
<cfinclude template="../admin/2/inc/generate_nginx_configuration.cfm">

<!--- RESTART NGINX --->
<cfinclude template="../admin/2/inc/restart_nginx.cfm">

<cfelse>
<cfoutput>No changes to SAN Domains found. Nothing to do.</cfoutput><br>
</cfif>

<!--- /CFIF #requestacme# is "1" --->
</cfif>

<!--- /CFIF #create_validated_hash.recordcount# GTE 1 --->
</cfif>

<!--- /CFLOOP query = "getvalidatedip" --->
</cfloop>


