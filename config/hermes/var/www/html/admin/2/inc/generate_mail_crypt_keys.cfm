
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE MAIL ENCRYPTION KEYS
Generates an EC key pair for Dovecot mail-crypt (encryption at rest).
The key pair is written to /opt/hermes/keys/ which is volume-mounted
into the Dovecot container at /keys/.

Only generates keys if they do NOT already exist. Once generated,
keys should never be regenerated from the UI — existing encrypted
mail would become unreadable without the original private key.

Called from: email_server_settings_action.cfm (when encryption is
enabled and keys don't exist yet)
--->

<cfparam name="keyCurve" default="prime256v1">

<cfset keyDir = "/opt/hermes/keys">
<cfset privKeyPath = keyDir & "/ecprivkey.pem">
<cfset pubKeyPath = keyDir & "/ecpubkey.pem">

<!--- Safety check: NEVER overwrite existing keys --->
<cfif FileExists(privKeyPath) OR FileExists(pubKeyPath)>
    <cfset keyGenResult = "exists">
<cfelse>
    <cfset keyGenResult = "">

    <!--- Generate EC private key --->
    <cftry>
        <cfexecute name="/usr/bin/openssl"
            arguments="ecparam -name #keyCurve# -genkey -noout -out #privKeyPath#"
            variable="genPrivResult"
            errorVariable="genPrivError"
            timeout="30" />

        <!--- Extract public key from private key --->
        <cfexecute name="/usr/bin/openssl"
            arguments="pkey -in #privKeyPath# -pubout -out #pubKeyPath#"
            variable="genPubResult"
            errorVariable="genPubError"
            timeout="30" />

        <!--- Set secure permissions --->
        <cfexecute name="/bin/chmod"
            arguments="600 #privKeyPath#"
            timeout="10" />
        <cfexecute name="/bin/chmod"
            arguments="644 #pubKeyPath#"
            timeout="10" />

        <cfset keyGenResult = "success">

    <cfcatch type="any">
        <!--- Clean up partial files on failure --->
        <cfif FileExists(privKeyPath)>
            <cffile action="delete" file="#privKeyPath#">
        </cfif>
        <cfif FileExists(pubKeyPath)>
            <cffile action="delete" file="#pubKeyPath#">
        </cfif>
        <cfset keyGenResult = "error">
        <cfset keyGenError = cfcatch.message>
    </cfcatch>
    </cftry>
</cfif>
