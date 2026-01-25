 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfparam name="requestacme" default="0">
<cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
<cfset timenow = TimeFormat(Now(), "HH:mm:ss")>


<!--- Query for mailbox_domains without a corresponding system_certificates record --->
<cfquery name="getUncertifiedDomains" datasource="hermes">
    SELECT mailbox_domains.id, mailbox_domains.domain, mailbox_domains.mailbox_certificate
    FROM mailbox_domains
    LEFT JOIN system_certificates
      ON mailbox_domains.mailbox_certificate = system_certificates.id
    WHERE system_certificates.id IS NULL
</cfquery>

<cfquery name="getAdditionalSans" datasource="hermes">
    SELECT san FROM additional_sans
</cfquery>

<cfif getUncertifiedDomains.recordcount GT 0>



    <cfloop query="getUncertifiedDomains">

  <cfoutput> Found Uncertified Domain Name #getUncertifiedDomains.domain#. Creating new database ID for blank ID.</cfoutput><br>

        <!--- Determine next highest id for new certificate --->
        <cfquery name="getMaxCertID" datasource="hermes">
            SELECT MAX(id) AS maxid FROM system_certificates
        </cfquery>
        <cfif getMaxCertID.recordcount EQ 1 and Len(getMaxCertID.maxid) GT 0>
            <cfset nextCertID = getMaxCertID.maxid + 1>
        <cfelse>
            <cfset nextCertID = 1>
        </cfif>

       

        <!--- Create new certificate for this domain using nextCertID --->
        <cfquery datasource="hermes">
            INSERT INTO system_certificates (id, domain_name, acme_hash, type, file_name, friendly_name, san)
            VALUES (
                <cfqueryparam value="#nextCertID#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#getUncertifiedDomains.domain#" cfsqltype="cf_sql_varchar">,
                '',    <!--- Empty hash at creation --->
                'Acme',
                <cfqueryparam value="#getUncertifiedDomains.domain#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#getUncertifiedDomains.domain#" cfsqltype="cf_sql_varchar">, 
                '1'
            )
        </cfquery>

         <cfoutput>Added new system_certificates entry with ID #nextCertID# for Domain #getUncertifiedDomains.domain# in system_certificates.</cfoutput><br>

         <!--- Update mailbox_domains mailbox_certificate with nextCertID for this domain --->
         <cfquery datasource="hermes">
         update mailbox_domains set mailbox_certificate = '#nextCertID#' where id = '#getUncertifiedDomains.id#'       
         </cfquery>

         <cfoutput>Updated mailbox_certificate with ID #nextCertID# for Domain #getUncertifiedDomains.domain# in mailbox_domains.</cfoutput><br>

        <!--- For all subdomains, concatenate with domain and insert into mailbox_sans --->
        <cfloop query="getAdditionalSans">
            <cfset fqdn = "#getAdditionalSans.san#.#getUncertifiedDomains.domain#">
            <cfquery datasource="hermes">
                INSERT INTO mailbox_sans (certificate, mailbox_domain, subdomain, ip, dns, acme)
                VALUES (
                    <cfqueryparam value="#nextCertID#" cfsqltype="cf_sql_integer">,
                    '1',
                    <cfqueryparam value="#fqdn#" cfsqltype="cf_sql_varchar">,
                    'NO',
                    'NO',
                    '1'
                )
            </cfquery>

                <cfoutput>Added #getAdditionalSans.san# entry for Domain #getUncertifiedDomains.domain#.</cfoutput><br>

        <!--- /CFLOOP getAdditionalSans --->
        </cfloop>

    <!--- /CFLOOP getUncertifiedDomains --->
    </cfloop>
</cfif>




<!--- Add/Delete additional sans as necessary starts here --->


<!--- Step 1: Build list of valid FQDNs from additional_sans & mailbox_domains --->
<cfset validFqdns = []>

<cfquery name="getDomains" datasource="hermes">
    SELECT domain, mailbox_certificate FROM mailbox_domains
</cfquery>

<cfloop query="getDomains">
    <cfquery name="getAdditionalSans" datasource="hermes">
        SELECT san FROM additional_sans
    </cfquery>
    <cfloop query="getAdditionalSans">

<cfoutput>Building validFqdns array with: #getAdditionalSans.san#.#getDomains.domain#</cfoutput><br>

        <cfset ArrayAppend(validFqdns, "#getAdditionalSans.san#.#getDomains.domain#")>
    <!--- /CFLOOP getAdditionalSans --->
    </cfloop>
<!--- /CFLOOP getDomains --->
</cfloop>





<!--- Step 2: Get existing FQDNs from mailbox_sans --->
<cfquery name="getExistingSans" datasource="hermes">
    SELECT subdomain FROM mailbox_sans where mailbox_domain = '1'
</cfquery>

<!--- Step 3: Add any missing FQDNs from the valid list --->
<cfloop array="#validFqdns#" index="fqdn">
    <cfset found = false>
    <cfloop query="getExistingSans">

         <cfoutput>Checking: #fqdn# vs #getExistingSans.subdomain#</cfoutput><br>

      <cfif trim(lcase(fqdn)) EQ trim(lcase(getExistingSans.subdomain))>

 

    <cfset found = true>


            <cfbreak>   
      </cfif>

       <cfoutput>Verdict is: #found#</cfoutput><br>
    </cfloop>

          


    <cfif NOT found>

    <cfquery name="CheckifAcme" datasource="hermes">
      select id, type from system_certificates where id = '#getDomains.mailbox_certificate#'
    </cfquery>

    <cfif #CheckifAcme.type# is "Acme">
      <cfset Certtype = 1>
    <cfelse>
      <cfset Certtype = 2>
    </cfif>

      <cfoutput>Inserting new SAN: #getDomains.mailbox_certificate#</cfoutput><br>

        <cfquery datasource="hermes">
               INSERT INTO mailbox_sans (certificate, mailbox_domain, subdomain, ip, dns, acme)
                VALUES ('#getDomains.mailbox_certificate#', '1', <cfqueryparam value="#fqdn#" cfsqltype="cf_sql_varchar">, 'NO', 'NO', '#Certtype#')
        </cfquery>
    <!--- /CFIF NOT found --->
    </cfif>
<!--- /CFLOOP validFqdns --->
</cfloop>



<!--- Step 4: Delete any FQDNs in mailbox_sans that are not valid anymore --->
<cfloop query="getExistingSans">
    <cfif NOT ArrayFind(validFqdns, getExistingSans.subdomain)>
        <cfquery datasource="hermes">
            DELETE FROM mailbox_sans WHERE subdomain = <cfqueryparam value="#getExistingSans.subdomain#" cfsqltype="cf_sql_varchar"> and mailbox_domain = '1'
        </cfquery>
    <!--- /CFIF entry not valid --->
    </cfif>
<!--- /CFLOOP getExistingSans --->
</cfloop>

<!--- Add/Delete additional sans as necessary ends here --->


<!--- Validation and update of IP SANs for all subdomains --->
<cfquery name="getsubdomains" datasource="hermes">
    SELECT id, subdomain FROM mailbox_sans
</cfquery>


<cfif getsubdomains.recordcount GTE 1>
    <cfloop query="getsubdomains">

        <!--- GENERATE CUSTOMTRANS --->
        <cfinclude template="./inc/generate_customtrans.cfm">

        <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_verifyip" output="#subdomain#" addnewline="no">

        <cftry>
            <cfexecute name="/usr/bin/openssl"
                arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_verifyip -out /opt/hermes/tmp/#customtrans3#_verifyip.ssl"
                timeout="60">
            </cfexecute>
            <cfcatch type="any">
                <cfset m="/inc/acme_validate_ip.cfm: Error running /usr/bin/openssl">
                <cfinclude template="./inc/error.cfm">
                <cfabort>
            <!--- /CFIF cfcatch type="any" (openssl failure) --->
            </cfcatch>
        </cftry>
        <cftry>
            <cfhttp method="Post" url="https://verify.hermesseg.io" timeout="60">
                <cfhttpparam type="File" name="#customtrans3#_verifyip.ssl" file="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
                <cfhttpparam type="Formfield" value="#customtrans3#" name="customtrans">
            </cfhttp>
            <cfcatch type="any">
                <cfset m="/inc/acme_validate_ip.cfm: Error connecting to https://verify.hermesseg.io">
                <cfinclude template="./inc/error.cfm">
                <cfabort>
            <!--- /CFIF cfcatch type="any" (http failure) --->
            </cfcatch>
        </cftry>

        <cfif cfhttp.status_code EQ "200">
            <cfset verifyipfile = "/opt/hermes/tmp/#customtrans3#_verifyip">
            <cfif fileExists(verifyipfile)>
                <cffile action="delete" file="#verifyipfile#">
            <!--- /CFIF fileExists(verifyipfile) --->
            </cfif>
            <cfset verifyipfile_ssl = "/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
            <cfif fileExists(verifyipfile_ssl)>
                <cffile action="delete" file="#verifyipfile_ssl#">
            <!--- /CFIF fileExists(verifyipfile_ssl) --->
            </cfif>
            <cfset step = "1">
        <cfelse>
            <cfset verifyipfile = "/opt/hermes/tmp/#customtrans3#_verifyip">
            <cfif fileExists(verifyipfile)>
                <cffile action="delete" file="#verifyipfile#">
            <!--- /CFIF fileExists(verifyipfile) in else --->
            </cfif>
            <cfset verifyipfile_ssl = "/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
            <cfif fileExists(verifyipfile_ssl)>
                <cffile action="delete" file="#verifyipfile_ssl#">
            <!--- /CFIF fileExists(verifyipfile_ssl) in else --->
            </cfif>
            <cfabort>

        <!--- /CFIF cfhttp.status_code EQ "200" --->
        </cfif>

        <cfif step is "1">
            <cftry>
                <cfset serverResponse = trim(cfhttp.FileContent)>
                <cfcatch type="any">
                    <cfif cfcatch.message contains "invalid call of the function listGetAt">
                        <cfset m="/inc/acme_validate_ip.cfm: Error reading server response">
                        <cfinclude template="./inc/error.cfm">
                        <cfabort>
                    <!--- /CFIF cfcatch.message contains "invalid call of the function listGetAt" --->
                    </cfif>
                </cfcatch>
            </cftry>
            <cfset step = "2">

        <!--- /CFIF step is "1" --->
        </cfif>

        <cfif step is "2">

            <cfif serverResponse contains "ERROR">
                <cfquery name="updateauto" datasource="hermes">
                    UPDATE mailbox_sans SET ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#', ip = 'NO', DNS = 'NO', dns_result_datetime = '#datenow# #timenow#', dns_result_msg = ''
                    WHERE id = '#id#'
                </cfquery>


            <cfelseif serverResponse contains "SUCCESS">
                <cfquery name="updateauto" datasource="hermes">
                    UPDATE mailbox_sans SET ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#', ip = 'YES'
                    WHERE id = '#id#'
                </cfquery>

            <!--- /CFIF serverResponse contains "ERROR" or "SUCCESS" --->
            </cfif>

        <!--- /CFIF step is "2" --->
        </cfif>


    <!--- /CFLOOP query="getsubdomains" --->
    </cfloop>


<cfelse>
    <cfoutput>No SAN Domains found. Nothing to do. Exiting...</cfoutput><br>
    <cfabort>

<!--- /CFIF getsubdomains.recordcount GTE 1 --->
</cfif>


<!--- Step: Certificate hash workflow, only for validated subdomains --->
<cfquery name="getvalidatedip" datasource="hermes">
    SELECT DISTINCT(certificate) FROM mailbox_sans WHERE ip = 'YES' and acme = '1'
</cfquery>


<cfif getvalidatedip.recordcount GTE 1>
    <cfloop query="getvalidatedip">


        <cfset requestacme = 0>

        <cfset acmeCertId = getvalidatedip.certificate>
        <cfquery name="create_validated_hash" datasource="hermes">
            SELECT subdomain FROM mailbox_sans WHERE certificate = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer"> AND ip = 'YES' ORDER BY subdomain ASC
        </cfquery>

        <cfif create_validated_hash.recordcount GTE 1>
            <cfset san_list = ValueList(create_validated_hash.subdomain)>
            <cfset san_array = ListToArray(san_list, ",")>


            <cfloop index="i" from="1" to="#ArrayLen(san_array)#">
                <cfset san_array[i] = trim(san_array[i])>

            <!--- /CFLOOP index="i" from="1" to="#ArrayLen(san_array)#" --->
            </cfloop>


            <cfset san_list = ArrayToList(san_array, ",")>
            <cfset newHash = Hash(san_list, "SHA-256")>
            <cfoutput>New Hash: #newHash#</cfoutput><br>
            <cfquery name="getcert" datasource="hermes">
                SELECT acme_hash, domain_name FROM system_certificates WHERE id = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset certExists = getcert.recordcount GT 0>
            <cfif certExists>
                <cfset oldHash = getcert.acme_hash>
                <cfset theCertname = getcert.domain_name>
            <cfelse>

                <!-- Correction: Ensure theCertname is set to the first SAN domain -->
                <cfset oldHash = "">
                <cfset theCertname = ListFirst(san_list, ",")>

            <!--- /CFIF certExists --->
            </cfif>

            <cfoutput>Old Hash: #oldHash#</cfoutput><br>
            <cfoutput>Cert Name: #theCertname#</cfoutput><br>

            <cfif NOT certExists>


                <cfoutput>Certificate does not exist. Will attempt new certificate request...<br></cfoutput>


                <cfset requestacme = 1>


            <cfelse>


                <cfif oldHash EQ "">
                    <cfquery name="updatehash" datasource="hermes">
                        UPDATE system_certificates SET acme_hash = '#newHash#' WHERE id = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer">
                    </cfquery>

                    <cfoutput>SAN Domains Hash changed. Will attempt new certificate request...<br></cfoutput>
                    <cfset requestacme = 1>

                <cfelseif oldHash NEQ newHash>
                    <cfquery name="updatehash" datasource="hermes">
                        UPDATE system_certificates SET acme_hash = '#newHash#' WHERE id = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer">
                    </cfquery>

                    <cfoutput>SAN Domains Hash changed. Will attempt new certificate request...<br></cfoutput>
                    <cfset requestacme = 1>
                    
                <!--- /CFIF oldHash EQ "" or oldHash NEQ newHash --->
                </cfif>

            <!--- /CFIF NOT certExists --->
            </cfif>


            <cfif requestacme is "1">
                <cfset totalsubdomain = create_validated_hash.recordcount>


                <cfoutput>Total number of SANs is: #totalsubdomain#<br></cfoutput>


                <cfif totalsubdomain LT 100>


                    <cfoutput>The number of SANs is below 100. Proceeding with certificate request...<br></cfoutput>


                    <!--- Generate customtrans --->
                    <cfinclude template="./inc/generate_customtrans.cfm">


                    <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_san_domains" output="" addnewline="no">


                    <cfoutput query="create_validated_hash">
                        <cffile action="append" file="/opt/hermes/tmp/#customtrans3#_san_domains" output="-d #subdomain##chr(32)#" addNewLine="no">
                    </cfoutput>


                    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_san_domains" variable="theSan">


                    <cfset sansdomains = "/opt/hermes/tmp/#customtrans3#_san_domains">


                    <!--- Delete temp /opt/hermes/tmp/#customtrans3#_san_domains file --->
                    <cfif fileExists(sansdomains)>
                        <cffile action="delete" file="#sansdomains#">
                    <!--- /CFIF fileExists(sansdomains) --->
                    </cfif>


                    <cfoutput>Requesting new certificate for #theCertname# (ACME Cert ID #acmeCertId#)...<br></cfoutput>


                    <!--- Request new certificate --->
                    <cfinclude template="./inc/acme_request_san_certificate.cfm">


                    <cfoutput>Acme Output: #acmeOutput#<br></cfoutput>
                    <cfoutput>Docker Directory: #DockerDir#<br></cfoutput>


                    <cfif FindNoCase("Successfully received certificate", acmeOutput)>


                        <cfif NOT certExists>
                            <cfquery name="insertcert" datasource="hermes">
                                INSERT INTO system_certificates (id, domain_name, acme_hash)
                                VALUES (
                                    <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer">,
                                    <cfqueryparam value="#theCertname#" cfsqltype="cf_sql_varchar">,
                                    <cfqueryparam value="#newHash#" cfsqltype="cf_sql_varchar">
                                )
                            </cfquery>


                            <cfoutput>Created new system_certificates record for ACME Cert ID #acmeCertId# after successful ACME issuance.<br></cfoutput>
                        <!--- /CFIF NOT certExists after ACME issuance --->
                        </cfif>



                        <cfquery name="insertsuccess" datasource="hermes">
                            UPDATE mailbox_sans SET dns = 'YES', dns_result_msg = 'SUCCESS: Successfully Received SAN Certificate', dns_result_datetime = '#datenow# #timenow#'
                            WHERE certificate = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer"> and ip = 'YES'
                        </cfquery>

                        <cfoutput>Successfully obtained certificate for #theCertname#...<br></cfoutput>


<!--- Configure and Restart Nginx --->
<!--- <cfinclude template="./inc/generate_nginx_configuration.cfm"> --->
<!--- <cfinclude template="./inc/restart_nginx.cfm"> --->


                    <cfelse>

                        <cfquery name="insertfailure" datasource="hermes">
                            UPDATE mailbox_sans SET dns_result_msg = 'ERROR: #acmeOutput#', dns_result_datetime = '#datenow# #timenow#'
                            WHERE certificate = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer"> AND ip = 'YES' AND dns = 'NO'
                        </cfquery>
                        <cfoutput>Could not obtain certificate for #theCertname#. Error reported was: #acmeOutput#<br></cfoutput>


                    <!--- /CFIF FindNoCase("Successfully received certificate", acmeOutput) --->
                    </cfif>



                <cfelse>
                    <cfquery name="insertsanlimit" datasource="hermes">
                        UPDATE mailbox_sans SET dns_result_msg = 'ERROR: SAN limit reached', dns_result_datetime = '#datenow# #timenow#'
                        WHERE certificate = <cfqueryparam value="#acmeCertId#" cfsqltype="cf_sql_integer"> AND ip = 'YES' AND dns = 'NO'
                    </cfquery>
                    <cfoutput>SAN limit reached for certificate #theCertname#<br></cfoutput>
                <!--- /CFIF totalsubdomain LT 100 --->
                </cfif>


            <!--- /CFIF requestacme is "1" --->
            </cfif>


        <cfelse>
            <cfoutput>No validated subdomains for certificate #acmeCertId#. Skipping certificate request and hash update.<br></cfoutput>


        <!--- /CFIF create_validated_hash.recordcount GTE 1 --->
        </cfif>


    <!--- /CFLOOP getvalidatedip --->
    </cfloop>


<!--- /CFIF getvalidatedip.recordcount GTE 1 --->
</cfif>

