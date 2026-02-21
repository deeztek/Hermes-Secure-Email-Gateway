<cfsilent>
<!---
Hermes Secure Email Gateway - Retention Policy Functions
Lightweight include for license/retention policy management.
Use this instead of message_cleanup.cfm when you only need the functions.
--->

<!--- Generate a valid 256-bit AES key from passphrase by hashing with SHA-256 --->
<cfset variables.rtk_passphrase = "Msg#Chr(82)#tn#Chr(75)#y#DateFormat(CreateDate(2024,1,1),'yy')#">
<cfset variables.rtk = ToBase64(BinaryDecode(Hash(variables.rtk_passphrase, "SHA-256"), "hex"))>
<cfset variables.rta = "AES/CBC/PKCS5Padding">

<cffunction name="getRetentionPolicy" returntype="struct" access="public" output="false">
    <cfset var result = {}>
    <cfset var qPolicy = "">

    <cfquery name="qPolicy" datasource="hermes">
        SELECT value FROM system_settings WHERE parameter = 'cleanup_threshold'
    </cfquery>

    <cfif qPolicy.recordcount EQ 0 OR Len(Trim(qPolicy.value)) EQ 0>
        <cfset result.isValid = false>
        <cfset result.policyStatus = "NONE">
        <cfset result.retentionDays = "">
        <cfset result.policyId = "">
        <cfset result.policyHash = "">
        <cfset result.lastRemoteValidation = "">
        <cfreturn result>
    </cfif>

    <cftry>
        <cfset var decrypted = Decrypt(qPolicy.value, variables.rtk, variables.rta, "Base64")>
        <cfset var parts = ListToArray(decrypted, Chr(124))>

        <cfset result.policyStatus = parts[1]>
        <cfset result.retentionDays = parts[2]>
        <cfset result.policyId = parts[3]>
        <cfset result.policyHash = parts[4]>
        <!--- 5th field: last successful remote validation date (added for grace period tracking) --->
        <cfset result.lastRemoteValidation = ArrayLen(parts) GTE 5 ? parts[5] : "">
        <cfset result.isValid = true>

        <cfcatch type="any">
            <cfset result.isValid = false>
            <cfset result.policyStatus = "NONE">
            <cfset result.retentionDays = "">
            <cfset result.policyId = "">
            <cfset result.policyHash = "">
            <cfset result.lastRemoteValidation = "">
        </cfcatch>
    </cftry>

    <cfreturn result>
</cffunction>

<cffunction name="isRetentionEnabled" returntype="boolean" access="public" output="false">
    <cfset var policy = getRetentionPolicy()>

    <cfif NOT policy.isValid OR policy.policyStatus NEQ "VALID">
        <cfreturn false>
    </cfif>

    <cfif Len(Trim(policy.retentionDays)) AND policy.retentionDays GTE DateFormat(Now(), "yyyy-mm-dd")>
        <cfreturn true>
    </cfif>

    <cfreturn false>
</cffunction>

<cffunction name="getRetentionStatus" returntype="string" access="public" output="false">
    <cfset var policy = getRetentionPolicy()>
    <cfreturn policy.policyStatus>
</cffunction>

<cffunction name="getRetentionExpiry" returntype="string" access="public" output="false">
    <cfset var policy = getRetentionPolicy()>
    <cfreturn policy.retentionDays>
</cffunction>

<cffunction name="updateRetentionPolicy" returntype="void" access="public" output="false">
    <cfargument name="status" type="string" required="true">
    <cfargument name="expiry" type="string" required="true">
    <cfargument name="policyId" type="string" required="true">
    <cfargument name="policyHash" type="string" required="true">
    <cfargument name="lastRemoteValidation" type="string" required="false" default="">

    <!--- If no lastRemoteValidation provided, use today's date (for remote validation success) --->
    <cfif Len(arguments.lastRemoteValidation) EQ 0>
        <cfset arguments.lastRemoteValidation = DateFormat(Now(), "yyyy-mm-dd")>
    </cfif>

    <cfset var rawData = "#arguments.status#|#arguments.expiry#|#arguments.policyId#|#arguments.policyHash#|#arguments.lastRemoteValidation#">
    <cfset var encrypted = Encrypt(rawData, variables.rtk, variables.rta, "Base64")>

    <cfquery datasource="hermes">
        INSERT INTO system_settings (parameter, value)
        VALUES ('cleanup_threshold', <cfqueryparam value="#encrypted#" cfsqltype="cf_sql_varchar">)
        ON DUPLICATE KEY UPDATE value = <cfqueryparam value="#encrypted#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cffunction>

<cffunction name="clearRetentionPolicy" returntype="void" access="public" output="false">
    <cfquery datasource="hermes">
        DELETE FROM system_settings WHERE parameter = 'cleanup_threshold'
    </cfquery>
</cffunction>
</cfsilent>