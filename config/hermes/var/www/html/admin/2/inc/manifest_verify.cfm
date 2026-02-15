<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Template Fingerprint Verification
Computes fingerprints and verifies Pro templates haven't been tampered with.
Supports offline verification using server-signed fingerprints.
--->

<cfsilent>

<!--- Public key for signature verification (distributed with install) --->
<cfset variables.manifestPublicKeyPath = "/opt/hermes/ssl/manifest_verify.pub">

<!--- Encryption keys for fingerprint storage --->
<cfset variables.fpk = "H3rm3s$3G!F1ng3rpr1ntK3y2024">
<cfset variables.fpa = "AES">

<!--- Load templates list from shared config (same file used by generate_manifest scripts) --->
<cfset variables.proTemplatesConfigPath = "/var/www/html/admin/2/inc/pro_templates.json">
<cfif FileExists(variables.proTemplatesConfigPath)>
    <cffile action="read" file="#variables.proTemplatesConfigPath#" variable="configJson">
    <cfset variables.proTemplatesConfig = DeserializeJSON(configJson)>
    <cfset variables.proTemplates = variables.proTemplatesConfig.templates>
<cfelse>
    <!--- Fallback to empty array if config not found --->
    <cfset variables.proTemplates = []>
</cfif>

<!--- ============================================================================
     TEMPLATE HASH COMPUTATION
     ============================================================================ --->

<cffunction name="computeTemplateHashes" returntype="struct" access="public" output="false">
    <cfset var hashes = {}>
    <cfset var basePath = "/var/www/html/">

    <cfloop array="#variables.proTemplates#" index="templatePath">
        <cfset var fullPath = basePath & templatePath>
        <cfif FileExists(fullPath)>
            <cffile action="read" file="#fullPath#" variable="content">
            <!--- Normalize line endings to LF for consistent hashing across platforms --->
            <cfset var normalizedContent = Replace(content, chr(13) & chr(10), chr(10), "all")>
            <cfset normalizedContent = Replace(normalizedContent, chr(13), chr(10), "all")>
            <cfset hashes[templatePath] = LCase(Hash(normalizedContent, "SHA-256"))>
        </cfif>
    </cfloop>

    <cfreturn hashes>
</cffunction>

<cffunction name="computeTemplateFingerprint" returntype="string" access="public" output="false"
    hint="Computes a single fingerprint hash from all template hashes (sorted by path, concatenated, then hashed)">
    <cfargument name="hashes" type="struct" required="false" default="#computeTemplateHashes()#">

    <!--- Get sorted list of template paths --->
    <cfset var sortedPaths = ListSort(StructKeyList(arguments.hashes), "text", "asc")>

    <!--- Concatenate all hashes in sorted order --->
    <cfset var concatenated = "">
    <cfloop list="#sortedPaths#" index="path">
        <cfset concatenated = concatenated & LCase(arguments.hashes[path])>
    </cfloop>

    <!--- Hash the concatenation to produce fingerprint --->
    <cfreturn LCase(Hash(concatenated, "SHA-256"))>
</cffunction>

<cffunction name="getTemplateFingerprint" returntype="string" access="public" output="false"
    hint="Returns the fingerprint for current template files">
    <cfreturn computeTemplateFingerprint()>
</cffunction>

<!--- ============================================================================
     SIGNED FINGERPRINT STORAGE (for offline verification)
     ============================================================================ --->

<cffunction name="storeSignedFingerprint" returntype="void" access="public" output="false"
    hint="Stores server-signed fingerprint for offline verification">
    <cfargument name="fingerprint" type="string" required="true">
    <cfargument name="signature" type="string" required="true">

    <!--- Store fingerprint|signature|date encrypted --->
    <cfset var rawData = "#arguments.fingerprint#|#arguments.signature#|#DateFormat(Now(),'yyyy-mm-dd')#">
    <cfset var encrypted = Encrypt(rawData, variables.fpk, variables.fpa, "Base64")>

    <cfquery datasource="hermes">
        INSERT INTO system_settings (parameter, value)
        VALUES ('signed_fingerprint', <cfqueryparam value="#encrypted#" cfsqltype="cf_sql_varchar">)
        ON DUPLICATE KEY UPDATE value = <cfqueryparam value="#encrypted#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cffunction>

<cffunction name="getStoredFingerprint" returntype="struct" access="public" output="false"
    hint="Retrieves stored signed fingerprint">
    <cfset var result = {exists = false}>

    <cfquery name="qFp" datasource="hermes">
        SELECT value FROM system_settings WHERE parameter = 'signed_fingerprint'
    </cfquery>

    <cfif qFp.recordcount EQ 0 OR Len(Trim(qFp.value)) EQ 0>
        <cfreturn result>
    </cfif>

    <cftry>
        <cfset var decrypted = Decrypt(qFp.value, variables.fpk, variables.fpa, "Base64")>
        <cfset var parts = ListToArray(decrypted, "|")>

        <cfif ArrayLen(parts) GTE 3>
            <cfset result.exists = true>
            <cfset result.fingerprint = parts[1]>
            <cfset result.signature = parts[2]>
            <cfset result.storedAt = parts[3]>
        </cfif>

        <cfcatch>
            <cfset result.exists = false>
        </cfcatch>
    </cftry>

    <cfreturn result>
</cffunction>

<!--- ============================================================================
     SIGNATURE VERIFICATION (using RSA public key)
     ============================================================================ --->

<cffunction name="verifyFingerprintSignature" returntype="boolean" access="public" output="false"
    hint="Verifies fingerprint was signed by the license server">
    <cfargument name="fingerprint" type="string" required="true">
    <cfargument name="signature" type="string" required="true">

    <cftry>
        <cfif NOT FileExists(variables.manifestPublicKeyPath)>
            <cfreturn false>
        </cfif>

        <cffile action="read" file="#variables.manifestPublicKeyPath#" variable="publicKeyPem">

        <!--- Use Java security classes for RSA verification --->
        <cfset var keyFactory = CreateObject("java", "java.security.KeyFactory")>
        <cfset var x509Spec = CreateObject("java", "java.security.spec.X509EncodedKeySpec")>
        <cfset var sig = CreateObject("java", "java.security.Signature")>

        <!--- Parse PEM public key --->
        <cfset var keyContent = ReReplace(publicKeyPem, "-----[A-Z ]+-----", "", "ALL")>
        <cfset keyContent = ReReplace(keyContent, "\s", "", "ALL")>
        <cfset var keyBytes = BinaryDecode(keyContent, "Base64")>

        <!--- Create public key object --->
        <cfset var pubKeySpec = x509Spec.init(keyBytes)>
        <cfset var rsaKeyFactory = keyFactory.getInstance("RSA")>
        <cfset var publicKey = rsaKeyFactory.generatePublic(pubKeySpec)>

        <!--- Verify signature (fingerprint was signed as raw text) --->
        <cfset var verifier = sig.getInstance("SHA256withRSA")>
        <cfset verifier.initVerify(publicKey)>
        <cfset verifier.update(ToBinary(ToBase64(arguments.fingerprint)))>

        <cfset var signatureBytes = BinaryDecode(arguments.signature, "Base64")>
        <cfreturn verifier.verify(signatureBytes)>

        <cfcatch>
            <cfreturn false>
        </cfcatch>
    </cftry>
</cffunction>

<!--- ============================================================================
     OFFLINE FINGERPRINT VERIFICATION
     ============================================================================ --->

<cffunction name="verifyOfflineFingerprint" returntype="struct" access="public" output="false"
    hint="Verifies current templates match stored signed fingerprint (for offline mode)">

    <cfset var result = {
        valid = false,
        reason = "",
        currentFingerprint = "",
        storedFingerprint = ""
    }>

    <!--- Get stored signed fingerprint --->
    <cfset var stored = getStoredFingerprint()>
    <cfif NOT stored.exists>
        <cfset result.reason = "No stored fingerprint">
        <cfreturn result>
    </cfif>

    <!--- Verify the stored signature is authentic (signed by server) --->
    <cfif NOT verifyFingerprintSignature(stored.fingerprint, stored.signature)>
        <cfset result.reason = "Invalid signature">
        <cfreturn result>
    </cfif>

    <!--- Compute current fingerprint --->
    <cfset result.currentFingerprint = getTemplateFingerprint()>
    <cfset result.storedFingerprint = stored.fingerprint>

    <!--- Compare fingerprints --->
    <cfif result.currentFingerprint NEQ result.storedFingerprint>
        <cfset result.reason = "Fingerprint mismatch - templates modified">
        <cfreturn result>
    </cfif>

    <!--- All checks passed --->
    <cfset result.valid = true>
    <cfset result.reason = "OK">
    <cfreturn result>
</cffunction>

<!--- ============================================================================
     UTILITY FUNCTIONS
     ============================================================================ --->

<cffunction name="getBuildVersion" returntype="string" access="public" output="false">
    <!--- Get build version from database --->
    <cfquery name="qBuild" datasource="hermes">
        SELECT value FROM system_settings WHERE parameter = 'build_no'
    </cfquery>

    <cfif qBuild.recordcount GT 0 AND Len(Trim(qBuild.value)) GT 0>
        <cfreturn Trim(qBuild.value)>
    </cfif>

    <cfreturn "">
</cffunction>

</cfsilent>
