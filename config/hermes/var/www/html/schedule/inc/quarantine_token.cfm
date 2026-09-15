<!---
Quarantine Action Token Functions
Generates and validates HMAC-SHA256 tokens for one-click quarantine actions.
--->

<cfscript>
/**
 * Get or generate the HMAC key for quarantine action tokens.
 * Key is stored at /opt/hermes/keys/quarantine_release_key
 */
function getQuarantineReleaseKey() {
    var keyFile = "/opt/hermes/keys/quarantine_release_key";
    if (fileExists(keyFile)) {
        return trim(fileRead(keyFile));
    }
    var newKey = generateSecretKey("AES");
    fileWrite(keyFile, newKey);
    return newKey;
}

/**
 * Generate a tokenized quarantine action URL.
 */
function generateQuarantineActionUrl(required string mailId, required string secretId, required string recipientEmail, required string consoleHost, string action = "release", numeric expiryHours = 72) {
    var normalizedAction = lCase(trim(arguments.action));
    if (!listFindNoCase("release,view,block", normalizedAction)) {
        normalizedAction = "release";
    }

    var key = getQuarantineReleaseKey();
    var expiry = dateDiff("s", createDate(1970, 1, 1), dateAdd("h", expiryHours, now()));
    var payload = normalizedAction & "|" & arguments.mailId & "|" & arguments.secretId & "|" & lCase(arguments.recipientEmail) & "|" & expiry;
    var signature = hmac(payload, key, "HmacSHA256");
    var token = toBase64(normalizedAction) & "." & toBase64(arguments.mailId) & "." & toBase64(toString(expiry)) & "." & signature;
    return "https://" & arguments.consoleHost & "/user-auth/quarantine_" & normalizedAction & ".cfm?token=" & urlEncodedFormat(token);
}

/**
 * Backward-compatible release URL generator.
 */
function generateQuarantineReleaseUrl(required string mailId, required string secretId, required string recipientEmail, required string consoleHost, numeric expiryHours = 72) {
    return generateQuarantineActionUrl(arguments.mailId, arguments.secretId, arguments.recipientEmail, arguments.consoleHost, "release", arguments.expiryHours);
}

/**
 * Validate a quarantine action token.
 */
function validateQuarantineActionToken(required string token, string expectedAction = "") {
    var result = {valid: false, mailId: "", secretId: "", recipientEmail: "", action: "", error: ""};

    try {
        var parts = listToArray(arguments.token, ".");
        var action = "release";
        var mailId = "";
        var expiry = 0;
        var providedSignature = "";
        var isLegacyToken = false;
        var matchedSecretId = "";
        var matchedRecipientEmail = "";

        if (arrayLen(parts) EQ 4) {
            action = lCase(toString(toBinary(parts[1])));
            mailId = toString(toBinary(parts[2]));
            expiry = val(toString(toBinary(parts[3])));
            providedSignature = parts[4];
        } else if (arrayLen(parts) EQ 3) {
            isLegacyToken = true;
            mailId = toString(toBinary(parts[1]));
            expiry = val(toString(toBinary(parts[2])));
            providedSignature = parts[3];
        } else {
            result.error = "Invalid token format";
            return result;
        }

        if (!listFindNoCase("release,view,block", action)) {
            result.error = "Invalid token";
            return result;
        }

        if (len(trim(arguments.expectedAction)) AND compareNoCase(arguments.expectedAction, action) NEQ 0) {
            result.error = "Invalid token";
            return result;
        }

        var nowEpoch = dateDiff("s", createDate(1970, 1, 1), now());
        if (nowEpoch GT expiry) {
            result.error = "expired";
            return result;
        }

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

        var key = getQuarantineReleaseKey();
        var validForRecipient = false;
        for (var row in q) {
            var payload = "";
            if (isLegacyToken) {
                payload = mailId & "|" & row.secret_id & "|" & lCase(row.recipient_email) & "|" & expiry;
            } else {
                payload = action & "|" & mailId & "|" & row.secret_id & "|" & lCase(row.recipient_email) & "|" & expiry;
            }
            var expectedSignature = hmac(payload, key, "HmacSHA256");
            if (compareNoCase(providedSignature, expectedSignature) EQ 0) {
                validForRecipient = true;
                matchedRecipientEmail = toString(row.recipient_email);
                matchedSecretId = toString(row.secret_id);
                break;
            }
        }

        if (!validForRecipient) {
            result.error = "Invalid token";
            return result;
        }

        result.valid = true;
        result.mailId = toString(mailId);
        result.secretId = matchedSecretId;
        result.recipientEmail = matchedRecipientEmail;
        result.action = action;
        return result;
    } catch (any e) {
        result.error = "Invalid token";
        return result;
    }
}

/**
 * Backward-compatible release token validator.
 */
function validateQuarantineReleaseToken(required string token) {
    return validateQuarantineActionToken(arguments.token, "release");
}
</cfscript>
