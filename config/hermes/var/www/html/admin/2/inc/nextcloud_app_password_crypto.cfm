
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD APP PASSWORD CRYPTO
Replaces the token hash and re-encrypts the private key and password
in oc_authtoken so the user's email password works for DAV auth.

Requires before including:
  - ncCryptoTokenId: the oc_authtoken row ID to update
  - ncCryptoPassword: the plaintext password to set
  - ncCryptoUser: the NC username (for logging)

Sets after execution:
  - ncCryptoResult: "success" or "error"
  - ncCryptoError: error message (if any)
--->

<cfparam name="ncCryptoTokenId" default="">
<cfparam name="ncCryptoPassword" default="">
<cfparam name="ncCryptoUser" default="">

<cfset ncCryptoResult = "error">
<cfset ncCryptoError = "">

<cfset cryptoOutput = "">
<cfset cryptoError = "">
<cfset updateResult = "">
<cfset updateError = "">

<cfif ncCryptoTokenId EQ "" OR ncCryptoPassword EQ "">
    <cfset ncCryptoError = "Missing token ID or password">
<cfelse>
<cftry>

<cfscript>
    // Use a temp PHP script inside the NC container to do the crypto.
    // This is the most reliable approach — NC's own PHP crypto functions
    // handle the exact key derivation, encryption, and format.

    phpScript = '<?php' & chr(10) &
        'define("OC_CONSOLE", true);' & chr(10) &
        'require_once "/var/www/html/lib/base.php";' & chr(10) &
        '' & chr(10) &
        '$password = getenv("NC_CRYPTO_PASS");' & chr(10) &
        '$tokenId = (int)$argv[1];' & chr(10) &
        '' & chr(10) &
        '// Get NC crypto and config' & chr(10) &
        '$crypto = \OC::$server->getCrypto();' & chr(10) &
        '$config = \OC::$server->getConfig();' & chr(10) &
        '$secret = $config->getSystemValueString("secret");' & chr(10) &
        '' & chr(10) &
        '// Compute token hash' & chr(10) &
        '$tokenHash = hash("sha512", $password . $secret);' & chr(10) &
        '' & chr(10) &
        '// Generate RSA keypair' & chr(10) &
        '$keyConfig = ["digest_alg" => "sha512", "private_key_bits" => 2048, "private_key_type" => OPENSSL_KEYTYPE_RSA];' & chr(10) &
        '$res = openssl_pkey_new($keyConfig);' & chr(10) &
        'openssl_pkey_export($res, $privateKey, null, $keyConfig);' & chr(10) &
        '$publicKeyDetails = openssl_pkey_get_details($res);' & chr(10) &
        '$publicKey = $publicKeyDetails["key"];' & chr(10) &
        '' & chr(10) &
        '// Encrypt private key using NC crypto (AES-256-CBC + HKDF + HMAC)' & chr(10) &
        '$encryptedPrivateKey = $crypto->encrypt($privateKey, $password . $secret);' & chr(10) &
        '' & chr(10) &
        '// Encrypt password with RSA public key (OAEP padding)' & chr(10) &
        'openssl_public_encrypt($password, $encryptedPassword, $publicKey, OPENSSL_PKCS1_OAEP_PADDING);' & chr(10) &
        '$encryptedPasswordB64 = base64_encode($encryptedPassword);' & chr(10) &
        '' & chr(10) &
        '// Hash password (NC uses PASSWORD_ARGON2ID)' & chr(10) &
        '$passwordHash = "";' & chr(10) &
        'if (defined("PASSWORD_ARGON2ID")) {' & chr(10) &
        '    $passwordHash = "3|" . password_hash($password, PASSWORD_ARGON2ID);' & chr(10) &
        '}' & chr(10) &
        '' & chr(10) &
        '// Output as JSON' & chr(10) &
        'echo json_encode([' & chr(10) &
        '    "token" => $tokenHash,' & chr(10) &
        '    "private_key" => $encryptedPrivateKey,' & chr(10) &
        '    "public_key" => $publicKey,' & chr(10) &
        '    "password" => $encryptedPasswordB64,' & chr(10) &
        '    "password_hash" => $passwordHash' & chr(10) &
        ']);' & chr(10);

    // Write PHP script to shared /opt/hermes/tmp/ volume
    include template="generate_customtrans.cfm";
    phpFile = "/opt/hermes/tmp/" & customtrans3 & "_nc_crypto.php";
    fileWrite(phpFile, phpScript, "utf-8");

    // Execute inside NC container via shared volume
    // Password passed via environment variable to avoid shell escaping issues
    shellScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_crypto.sh";
    fileWrite(shellScript,
        chr(35) & "!/bin/bash" & chr(10) &
        "docker exec -e NC_CRYPTO_PASS=""" & ncCryptoPassword & """ -u www-data hermes_nextcloud php /opt/hermes/tmp/" & customtrans3 & "_nc_crypto.php " & ncCryptoTokenId & chr(10),
        "utf-8");
</cfscript>

<cfexecute name="/bin/chmod" arguments="+x #shellScript#" timeout="10" />
<cfexecute name="#shellScript#"
    variable="cryptoOutput"
    errorVariable="cryptoError"
    timeout="60" />
<cftry><cffile action="delete" file="#phpFile#"><cfcatch type="any"></cfcatch></cftry>
<cftry><cffile action="delete" file="#shellScript#"><cfcatch type="any"></cfcatch></cftry>

<cfscript>
    // Debug log
    fileWrite("/opt/hermes/tmp/nc_crypto_debug.log",
        "PHP output: " & Left(cryptoOutput, 500) & chr(10) &
        "PHP error: " & cryptoError & chr(10) &
        "---" & chr(10),
        "utf-8");

    // Parse JSON output
    cryptoOutput = Trim(cryptoOutput);
    if (NOT IsJSON(cryptoOutput)) {
        throw(message="PHP crypto script did not return valid JSON: " & Left(cryptoOutput, 200));
    }

    cryptoData = DeserializeJSON(cryptoOutput);

    // Read NC DB credentials
    ncDbUserRaw = fileRead("/opt/hermes/creds/nextcloud_mysql_username", "utf-8");
    ncDbUser2 = Trim(ncDbUserRaw);
    ncDbPassRaw = fileRead("/opt/hermes/creds/nextcloud_mysql_password", "utf-8");
    ncDbPass2 = Trim(ncDbPassRaw);
</cfscript>

<!--- Update oc_authtoken with the crypto data --->
<cfinclude template="generate_customtrans.cfm">
<cfset updateScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_crypto_update.sh">

<!--- Write the SQL values to a temp SQL file to avoid shell escaping issues --->
<cfset sqlFile = "/opt/hermes/tmp/" & customtrans3 & "_nc_crypto.sql">
<cfscript>
    sqlContent = "UPDATE oc_authtoken SET " &
        "token='" & cryptoData.token & "', " &
        "name='Hermes System', " &
        "private_key='" & Replace(cryptoData.private_key, "'", "''", "ALL") & "', " &
        "public_key='" & Replace(cryptoData.public_key, "'", "''", "ALL") & "', " &
        "password='" & Replace(cryptoData.password, "'", "''", "ALL") & "', " &
        "password_hash=" & (Len(cryptoData.password_hash) GT 0 ? "'" & Replace(cryptoData.password_hash, "'", "''", "ALL") & "'" : "NULL") & " " &
        "WHERE id=" & ncCryptoTokenId & ";";
    fileWrite(sqlFile, sqlContent, "utf-8");

    // Write SQL to file, then execute via docker exec reading from shared volume
    fileAppend("/opt/hermes/tmp/nc_crypto_debug.log",
        "SQL content length: " & Len(sqlContent) & chr(10) &
        "SQL first 200: " & Left(sqlContent, 200) & chr(10) &
        "---" & chr(10),
        "utf-8");

    fileWrite(updateScript,
        chr(35) & "!/bin/bash" & chr(10) &
        "docker exec hermes_db_server mysql -u """ & ncDbUser2 & """ -p""" & ncDbPass2 & """ nextcloud -e ""source " & sqlFile & """ 2>&1" & chr(10),
        "utf-8");
</cfscript>

<cfexecute name="/bin/chmod" arguments="+x #updateScript#" timeout="10" />
<cfexecute name="#updateScript#"
    variable="updateResult"
    errorVariable="updateError"
    timeout="30" />
<cftry><cffile action="delete" file="#updateScript#"><cfcatch type="any"></cfcatch></cftry>
<cftry><cffile action="delete" file="#sqlFile#"><cfcatch type="any"></cfcatch></cftry>

<cfscript>
    fileAppend("/opt/hermes/tmp/nc_crypto_debug.log",
        "SQL update result: " & updateResult & chr(10) &
        "SQL update error: " & updateError & chr(10) &
        "---" & chr(10),
        "utf-8");
</cfscript>

<cfset ncCryptoResult = "success">

<cfcatch type="any">
    <cfset ncCryptoResult = "error">
    <cfset ncCryptoError = cfcatch.message & " | " & cfcatch.detail>
    <cfscript>
        fileWrite("/opt/hermes/tmp/nc_crypto_debug.log",
            "EXCEPTION in crypto" & chr(10) &
            "Message: " & cfcatch.message & chr(10) &
            "Detail: " & cfcatch.detail & chr(10) &
            "---" & chr(10),
            "utf-8");
    </cfscript>
</cfcatch>
</cftry>
</cfif>
