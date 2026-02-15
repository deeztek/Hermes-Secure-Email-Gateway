<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!--- Include retention policy functions (lightweight, no cleanup operations) --->
<cfinclude template="/schedule/retention_policy_functions.cfm">

<!--- Include manifest verification functions (Pro Edition tamper detection) --->
<cfinclude template="manifest_verify.cfm">

<!--- Get UUID from system --->
<cfexecute name="/opt/hermes/scripts/dmidecode" arguments="" timeout="10"></cfexecute>

<cffile action="read" file="/usr/share/UUID" variable="temp1">
<cfset temp2="#REReplace("#temp1#","#chr(10)#","","ALL")#">
<cfset temp3="#REReplace("#temp2#","#chr(13)#","","ALL")#">
<cfset temp4="#REReplace("#temp3#","","","ALL")#">
<cfset temp5="#REReplace("#temp4#","UUID:","","ALL")#">
<cfset theUuid = TRIM(temp5)>

<cffile action="write" file="/usr/share/UUID" output="#theUuid#" addnewline="no">

<!--- Get serial number from database --->
<cfquery name="getserial" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'serial'
</cfquery>
<cfset theSerial = "">
<cfif getserial.recordcount GT 0>
    <cfset theSerial = TRIM(getserial.value)>
</cfif>

<!--- Initialize session variables --->
<cfset session.license = "N/A">
<cfset session.edition = "Community">
<cfset session.reason = "">
<cfset session.licensevaliddays = "">
<cfset session.licenseexpires = "">
<cfset session.validationMode = "none"><!--- none, remote, cached --->

<!--- Check if we have a serial number to validate --->
<cfif Len(theSerial) GT 0>

    <!--- Get current policy from database --->
    <cfset currentPolicy = getRetentionPolicy()>

    <!--- Attempt remote validation --->
    <cfset remoteValidationSuccess = false>

    <cftry>
        <!--- GENERATE CUSTOMTRANS for secure transmission --->
        <cfinclude template="generate_customtrans.cfm">

        <!--- Create validation payload --->
        <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_validatefile"
            output="#theUuid##chr(64)##theSerial##chr(64)##currentPolicy.policyHash#" addnewline="no">

        <!--- Encrypt with public key --->
        <cfexecute name="/usr/bin/openssl"
            arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_validatefile -out /opt/hermes/tmp/#customtrans3#_validatefile.ssl"
            timeout="10">
        </cfexecute>

        <!--- Get build version and compute template fingerprint for tamper detection --->
        <cfset buildVersion = getBuildVersion()>
        <cfset templateFingerprint = getTemplateFingerprint()>

        <!--- Send to validation server (5 second timeout for fast fallback) --->
        <CFHTTP METHOD="Post" URL="https://validate.hermesseg.io" timeout="5">
            <CFHTTPPARAM TYPE="File" NAME="#customtrans3#_validatefile.ssl" FILE="/opt/hermes/tmp/#customtrans3#_validatefile.ssl">
            <CFHTTPPARAM TYPE="Formfield" VALUE="#customtrans3#" NAME="customtrans">
            <CFHTTPPARAM TYPE="Formfield" VALUE="#buildVersion#" NAME="version">
            <CFHTTPPARAM TYPE="Formfield" VALUE="#templateFingerprint#" NAME="template_fingerprint">
        </CFHTTP>

        <!--- Cleanup temp files --->
        <cfset validatefile = "/opt/hermes/tmp/#customtrans3#_validatefile">
        <cfif fileExists(validatefile)>
            <cffile action="delete" file="#validatefile#">
        </cfif>
        <cfset validatefile_ssl = "/opt/hermes/tmp/#customtrans3#_validatefile.ssl">
        <cfif fileExists(validatefile_ssl)>
            <cffile action="delete" file="#validatefile_ssl#">
        </cfif>

        <!--- Process server response --->
        <cfif cfhttp.status_code EQ "200">
            <cfset serverResponse = TRIM(cfhttp.FileContent)>

            <!--- Parse response: hash@expires[@fingerprint@signature] or ERROR/INVALID/REVOKED --->
            <cfif serverResponse contains chr(64)>
                <!--- Valid response format: hash@expires or hash@expires@fingerprint@signature --->
                <cfset responseParts = ListToArray(serverResponse, chr(64))>
                <cfset responseHash = TRIM(responseParts[1])>
                <cfset responseExpires = TRIM(responseParts[2])>

                <!--- Update retention policy in database --->
                <cfset updateRetentionPolicy("VALID", responseExpires, theSerial, responseHash)>
                <cfset remoteValidationSuccess = true>

                <!--- Calculate days remaining --->
                <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
                <cfset difference = datediff("d", datenow, responseExpires)>

                <!--- Set session variables --->
                <cfset session.license = "VALID">
                <cfset session.edition = "Pro">
                <cfset session.licensevaliddays = difference>
                <cfset session.licenseexpires = DateFormat(responseExpires, "mm/dd/yyyy")>
                <cfset session.validationMode = "remote">

                <!--- Store signed fingerprint for offline verification (format: hash@expires@fingerprint@signature) --->
                <cfif ArrayLen(responseParts) GTE 4>
                    <cftry>
                        <cfset responseFingerprint = TRIM(responseParts[3])>
                        <cfset responseSignature = TRIM(responseParts[4])>

                        <!--- Verify signature before storing --->
                        <cfif verifyFingerprintSignature(responseFingerprint, responseSignature)>
                            <cfset storeSignedFingerprint(responseFingerprint, responseSignature)>
                        </cfif>
                        <cfcatch>
                            <!--- Fingerprint storage error - log but don't fail validation --->
                        </cfcatch>
                    </cftry>
                </cfif>

            <cfelseif serverResponse EQ "REVOKED">
                <!--- License revoked --->
                <cfset clearRetentionPolicy()>
                <cfset session.license = "REVOKED">
                <cfset session.edition = "Community">
                <cfset remoteValidationSuccess = true>

            <cfelseif serverResponse EQ "EXPIRED">
                <!--- License expired --->
                <cfset clearRetentionPolicy()>
                <cfset session.license = "EXPIRED">
                <cfset session.edition = "Community">
                <cfset remoteValidationSuccess = true>

            <cfelseif serverResponse EQ "INVALID">
                <!--- Invalid/tampered license --->
                <cfset clearRetentionPolicy()>
                <cfset session.license = "INVALID">
                <cfset session.edition = "Community">
                <cfset remoteValidationSuccess = true>

            <cfelseif serverResponse CONTAINS "TAMPERED">
                <!--- Template files have been modified (Pro Edition tamper detection) --->
                <cfset session.license = "TAMPERED">
                <cfset session.edition = "Community">
                <cfif ListLen(serverResponse, "|") GTE 2>
                    <cfset session.tamperMessage = ListGetAt(serverResponse, 2, "|")>
                <cfelse>
                    <cfset session.tamperMessage = "Template integrity check failed">
                </cfif>
                <cfset remoteValidationSuccess = true>
            </cfif>
        </cfif>

        <cfcatch type="any">
            <!--- Remote validation failed (network error, timeout, etc.) --->
            <cfset remoteValidationSuccess = false>
        </cfcatch>
    </cftry>

    <!--- If remote validation failed, fall back to database cache --->
    <cfif NOT remoteValidationSuccess>
        <cfif currentPolicy.isValid AND currentPolicy.policyStatus EQ "VALID">
            <!--- Use cached database value --->
            <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>

            <cfif Len(currentPolicy.retentionDays) AND currentPolicy.retentionDays GTE datenow>
                <!--- License date is valid, now verify templates haven't been tampered with --->
                <cfset offlineVerification = verifyOfflineFingerprint()>

                <cfif offlineVerification.valid>
                    <!--- Templates verified - allow Pro mode --->
                    <cfset difference = datediff("d", datenow, currentPolicy.retentionDays)>
                    <cfset session.license = "VALID">
                    <cfset session.edition = "Pro">
                    <cfset session.licensevaliddays = difference>
                    <cfset session.licenseexpires = DateFormat(currentPolicy.retentionDays, "mm/dd/yyyy")>
                    <cfset session.validationMode = "cached">
                <cfelseif offlineVerification.reason EQ "No stored fingerprint">
                    <!--- No fingerprint stored - require online validation before offline mode is allowed --->
                    <cfset session.license = "PENDING_VALIDATION">
                    <cfset session.edition = "Community">
                    <cfset session.reason = "Online validation required to establish template fingerprint baseline">
                <cfelse>
                    <!--- Templates have been tampered with --->
                    <cfset session.license = "TAMPERED">
                    <cfset session.edition = "Community">
                    <cfset session.tamperMessage = offlineVerification.reason>
                </cfif>
            <cfelse>
                <!--- Cached license is expired --->
                <cfset session.license = "EXPIRED">
                <cfset session.edition = "Community">
            </cfif>
        <cfelse>
            <!--- No valid cached data, check legacy file-based system --->
            <cfset uuid2_file = "/usr/share/UUID2">

            <cfif fileExists(uuid2_file)>
                <!--- Legacy file-based license exists --->
                <cffile action="read" file="/usr/share/UUID" variable="uuid">
                <cffile action="read" file="/usr/share/UUID2" variable="uuid2">
                <cfset compare_uuid = Compare(TRIM(uuid), TRIM(uuid2))>

                <cfif compare_uuid EQ 0>
                    <!--- UUID match - check expiration --->
                    <cftry>
                        <cffile action="read" file="/usr/share/lt" variable="lt">
                        <cffile action="read" file="/usr/share/djigzo/ADDITIONAL-NOTES.TXT" variable="licenseDate">

                        <cfset lt2 = TRIM(lt)>
                        <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
                        <cfset timenow = TimeFormat(now(), "HH:mm:ss")>
                        <cfset difference = datediff("d", "#datenow# #timenow#", TRIM(licenseDate))>

                        <cfif difference GTE 1>
                            <cfset session.license = "VALID">
                            <cfset session.edition = "Pro">
                            <cfset session.licensevaliddays = difference>
                            <cfset session.licenseexpires = DateFormat(licenseDate, "mm/dd/yyyy")>
                            <cfset session.validationMode = "cached">

                            <!--- Migrate legacy data to database for future logins --->
                            <cfset updateRetentionPolicy("VALID", TRIM(licenseDate), theSerial, "LEGACY")>
                        <cfelse>
                            <cfset session.license = "EXPIRED">
                            <cfset session.edition = "Community">
                        </cfif>

                        <cfcatch type="any">
                            <cfset session.license = "N/A">
                            <cfset session.edition = "Community">
                        </cfcatch>
                    </cftry>
                <cfelse>
                    <!--- UUID mismatch - violation --->
                    <cfset session.license = "VIOLATION">
                    <cfset session.edition = "Community">
                </cfif>
            </cfif>
        </cfif>
    </cfif>

</cfif>
