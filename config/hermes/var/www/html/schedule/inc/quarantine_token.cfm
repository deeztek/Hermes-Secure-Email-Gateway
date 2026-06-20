<!---
Quarantine Release Token Functions
Generates and validates HMAC-SHA256 tokens for one-click quarantine release.
Token format: base64url(HMAC-SHA256(mail_id|secret_id|recipient_email|expiry, key))~expiry
--->

<cfscript>
/**
 * Get or generate the HMAC key for quarantine release tokens.
 * Key is stored at /opt/hermes/keys/quarantine_release_key
 */
function getQuarantineReleaseKey() {
    var keyFile = "/opt/hermes/keys/quarantine_release_key";
    if (fileExists(keyFile)) {
        return trim(fileRead(keyFile));
    }
    // Generate a 64-character hex key on first use
    var newKey = hash(createUUID() & now() & randRange(100000, 999999), "SHA-256");
    fileWrite(keyFile, newKey);
    return newKey;
}

/**
 * Generate a tokenized release URL for a quarantined message.
 * @param mailId The mail_id from msgs table
 * @param secretId The secret_id from msgs table
 * @param recipientEmail The recipient's email address
 * @param consoleHost The console hostname for URL generation
 * @param expiryHours Hours until token expires (default 72)
 * @return Full release URL with token
 */
function generateQuarantineReleaseUrl(required string mailId, required string secretId, required string recipientEmail, required string consoleHost, numeric expiryHours = 72) {
    var key = getQuarantineReleaseKey();
    var expiry = dateDiff("s", createDate(1970, 1, 1), dateAdd("h", expiryHours, now()));
    var payload = arguments.mailId & "|" & arguments.secretId & "|" & lCase(arguments.recipientEmail) & "|" & expiry;
    var signature = hmac(payload, key, "HmacSHA256");
    var token = toBase64(arguments.mailId) & "." & toBase64(toString(expiry)) & "." & signature;
    return "https://" & arguments.consoleHost & "/user-auth/quarantine_release.cfm?token=" & urlEncodedFormat(token);
}

/**
 * Validate a quarantine release token and return the mail_id if valid.
 * @param token The token from the URL
 * @return Struct with keys: valid (boolean), mailId, error (string)
 */
function validateQuarantineReleaseToken(required string token) {
    var result = {valid: false, mailId: "", error: ""};

    try {
        var parts = listToArray(arguments.token, ".");
        if (arrayLen(parts) NEQ 3) {
            result.error = "Invalid token format";
            return result;
        }

        var mailId = toString(toBinary(parts[1]));
        var expiry = val(toString(toBinary(parts[2])));
        var providedSignature = parts[3];

        // Check expiry
        var nowEpoch = dateDiff("s", createDate(1970, 1, 1), now());
        if (nowEpoch > expiry) {
            result.error = "expired";
            return result;
        }

        // Look up the message to get secret_id and recipient
        var q = queryExecute(
            "SELECT m.mail_id, m.secret_id, ma.email AS recipient_email
             FROM msgs m
             INNER JOIN msgrcpt mr ON m.mail_id = mr.mail_id
             INNER JOIN maddr ma ON mr.rid = ma.id
             WHERE m.mail_id = :mailId",
            {mailId: {value: mailId, cfsqltype: "cf_sql_varchar"}},
            {datasource: "hermes"}
        );

        if (q.recordCount LT 1) {
            result.error = "Message not found";
            return result;
        }

        // Validate signature against each recipient (message may have multiple)
        var key = getQuarantineReleaseKey();
        var validForRecipient = false;
        for (var row in q) {
            var payload = mailId & "|" & row.secret_id & "|" & lCase(row.recipient_email) & "|" & expiry;
            var expectedSignature = hmac(payload, key, "HmacSHA256");
            if (compareNoCase(providedSignature, expectedSignature) EQ 0) {
                validForRecipient = true;
                result.recipientEmail = toString(row.recipient_email);
                result.secretId = toString(row.secret_id);
                break;
            }
        }

        if (!validForRecipient) {
            result.error = "Invalid token";
            return result;
        }

        result.valid = true;
        result.mailId = toString(mailId);
        return result;

    } catch (any e) {
        result.error = "Invalid token";
        return result;
    }
}
</cfscript>
