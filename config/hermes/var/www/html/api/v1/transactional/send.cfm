<cfcontent type="application/json">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">

<cfscript>
function txRespond(required numeric statusCode, required boolean ok, string code="", string message="", struct data={}) {
    cfheader(statuscode=arguments.statusCode, statustext="");
    var payload = {"success": arguments.ok};
    if (arguments.ok) {
        structAppend(payload, arguments.data, true);
    } else {
        payload["error"] = {"code": arguments.code, "message": arguments.message};
    }
    writeOutput(serializeJSON(payload));
    abort;
}

function txNormalizeList(required string rawVal) {
    var seen = structNew();
    var out = [];
    for (var p in listToArray(trim(arguments.rawVal), ",")) {
        var v = lcase(trim(p));
        if (v NEQ "" AND NOT structKeyExists(seen, v)) {
            seen[v] = 1;
            arrayAppend(out, v);
        }
    }
    return out;
}

function txClientIp() {
    var req = getHttpRequestData();
    if (isStruct(req) AND structKeyExists(req, "headers") AND isStruct(req.headers) AND structKeyExists(req.headers, "X-Forwarded-For")) {
        var xff = trim(req.headers["X-Forwarded-For"]);
        if (xff NEQ "") {
            return trim(listFirst(xff, ","));
        }
    }
    return trim(cgi.remote_addr);
}

function txInetBytes(required string ip) {
    var inet = createObject("java", "java.net.InetAddress").getByName(arguments.ip);
    return inet.getAddress();
}

function txIpInCidr(required string ip, required string cidr) {
    var parts = listToArray(trim(arguments.cidr), "/");
    if (arrayLen(parts) EQ 0) { return false; }
    var networkIp = trim(parts[1]);
    var prefix = (arrayLen(parts) GTE 2) ? val(parts[2]) : -1;

    var ipBytes = txInetBytes(arguments.ip);
    var netBytes = txInetBytes(networkIp);
    if (arrayLen(ipBytes) NEQ arrayLen(netBytes)) { return false; }

    var maxBits = arrayLen(ipBytes) * 8;
    if (prefix LT 0 OR prefix GT maxBits) { return false; }

    var whole = int(prefix / 8);
    var remain = prefix mod 8;

    for (var i=1; i LTE whole; i++) {
        if (bitAnd(bitOr(ipBytes[i], 256), 255) NEQ bitAnd(bitOr(netBytes[i], 256), 255)) {
            return false;
        }
    }

    if (remain GT 0) {
        var mask = bitXor(255, (2 ^ (8-remain)) - 1);
        var ipPart = bitAnd(bitOr(ipBytes[whole+1], 256), 255);
        var netPart = bitAnd(bitOr(netBytes[whole+1], 256), 255);
        if (bitAnd(ipPart, mask) NEQ bitAnd(netPart, mask)) {
            return false;
        }
    }

    return true;
}

function txIpAllowed(required string clientIp, required numeric anyIp, string ipAllowlist="") {
    if (arguments.anyIp EQ 1) { return true; }
    var allowItems = txNormalizeList(arguments.ipAllowlist);
    if (arrayLen(allowItems) EQ 0) { return false; }
    for (var candidate in allowItems) {
        if (find("/", candidate)) {
            try {
                if (txIpInCidr(arguments.clientIp, candidate)) { return true; }
            } catch (any e) {}
        } else if (candidate EQ lcase(arguments.clientIp)) {
            return true;
        }
    }
    return false;
}

function txAudit(required struct row) {
    queryExecute(
        "INSERT INTO transactional_email_audit (created_at, auth_method, auth_identifier, source_ip, sender, recipient, subject, message_id, result, rejection_reason) VALUES (NOW(), :auth_method, :auth_identifier, :source_ip, :sender, :recipient, :subject, :message_id, :result, :rejection_reason)",
        {
            auth_method: {value: row.auth_method, cfsqltype: "cf_sql_varchar"},
            auth_identifier: {value: row.auth_identifier, cfsqltype: "cf_sql_varchar"},
            source_ip: {value: row.source_ip, cfsqltype: "cf_sql_varchar", null: (trim(row.source_ip) EQ "")},
            sender: {value: row.sender, cfsqltype: "cf_sql_varchar", null: (trim(row.sender) EQ "")},
            recipient: {value: row.recipient, cfsqltype: "cf_sql_varchar", null: (trim(row.recipient) EQ "")},
            subject: {value: row.subject, cfsqltype: "cf_sql_varchar", null: (trim(row.subject) EQ "")},
            message_id: {value: row.message_id, cfsqltype: "cf_sql_varchar", null: (trim(row.message_id) EQ "")},
            result: {value: row.result, cfsqltype: "cf_sql_varchar"},
            rejection_reason: {value: row.rejection_reason, cfsqltype: "cf_sql_varchar", null: (trim(row.rejection_reason) EQ "")}
        },
        {datasource: "hermes"}
    );
}
</cfscript>

<cfif StructKeyExists(url, "token") OR StructKeyExists(url, "api_token")>
  <cfset txRespond(400, false, "TOKEN_IN_QUERY_NOT_ALLOWED", "API tokens must be sent in the Authorization header.")>
</cfif>

<cfset reqData = getHttpRequestData()>
<cfset authHeader = "">
<cfif IsStruct(reqData) AND StructKeyExists(reqData, "headers") AND IsStruct(reqData.headers) AND StructKeyExists(reqData.headers, "Authorization")>
  <cfset authHeader = trim(reqData.headers["Authorization"])>
</cfif>

<cfif Left(authHeader, 7) NEQ "Bearer ">
  <cfset txRespond(401, false, "AUTHENTICATION_FAILED", "Authentication failed.")>
</cfif>

<cfset bearerToken = trim(Mid(authHeader, 8, Len(authHeader)-7))>
<cfif bearerToken EQ "">
  <cfset txRespond(401, false, "AUTHENTICATION_FAILED", "Authentication failed.")>
</cfif>

<cfquery name="getActiveApiTokens" datasource="hermes">
  SELECT id, token_hash, token_salt, allowed_senders, allowed_domains, any_ip, ip_allowlist, active
  FROM transactional_api_tokens
  WHERE active = 1
</cfquery>

<cfset foundToken = false>
<cfset tokenRow = StructNew()>
<cfloop query="getActiveApiTokens">
  <cfset probeHash = hash(bearerToken & ":" & token_salt, "SHA-256", "UTF-8")>
  <cfif probeHash EQ token_hash>
    <cfset foundToken = true>
    <cfset tokenRow = {
      "id": id,
      "allowed_senders": allowed_senders,
      "allowed_domains": allowed_domains,
      "any_ip": any_ip,
      "ip_allowlist": ip_allowlist
    }>
    <cfbreak>
  </cfif>
</cfloop>

<cfif NOT foundToken>
  <cfset txRespond(401, false, "AUTHENTICATION_FAILED", "Authentication failed.")>
</cfif>

<cfquery name="getServiceEnabled" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE module='transactional_email' AND parameter='enabled' LIMIT 1
</cfquery>
<cfif getServiceEnabled.recordcount EQ 0 OR getServiceEnabled.value2 NEQ "1">
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=txClientIp(), sender="", recipient="", subject="", message_id="", result="rejected", rejection_reason="TRANSACTIONAL_DISABLED"})>
  <cfset txRespond(403, false, "TRANSACTIONAL_DISABLED", "Transactional email service is disabled.")>
</cfif>

<cfset sourceIp = txClientIp()>
<cfif NOT txIpAllowed(sourceIp, val(tokenRow.any_ip), tokenRow.ip_allowlist)>
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender="", recipient="", subject="", message_id="", result="rejected", rejection_reason="IP_NOT_ALLOWED"})>
  <cfset txRespond(403, false, "IP_NOT_ALLOWED", "The request source IP is not authorized for this API token.")>
</cfif>

<cftry>
  <cfset body = deserializeJSON(ToString(reqData.content))>
<cfcatch type="any">
  <cfset txRespond(400, false, "INVALID_JSON", "Invalid JSON payload.")>
</cfcatch>
</cftry>

<cfif NOT IsStruct(body)>
  <cfset txRespond(400, false, "INVALID_REQUEST", "JSON object payload is required.")>
</cfif>

<cfset fromAddress = "">
<cfset recipientList = []>
<cfset messageSubject = "">
<cfset messageText = "">
<cfset messageHtml = "">

<cfif StructKeyExists(body, "from")><cfset fromAddress = LCase(Trim(body.from))></cfif>
<cfif StructKeyExists(body, "to")>
  <cfif IsArray(body.to)><cfset recipientList = body.to>
  <cfelseif IsSimpleValue(body.to)><cfset recipientList = [body.to]>
  </cfif>
</cfif>
<cfif StructKeyExists(body, "subject")><cfset messageSubject = Left(Trim(ToString(body.subject)), 255)></cfif>
<cfif StructKeyExists(body, "text")><cfset messageText = ToString(body.text)></cfif>
<cfif StructKeyExists(body, "html")><cfset messageHtml = ToString(body.html)></cfif>

<cfif fromAddress EQ "" OR NOT IsValid("email", fromAddress)>
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient="", subject=messageSubject, message_id="", result="rejected", rejection_reason="INVALID_FROM"})>
  <cfset txRespond(400, false, "INVALID_FROM", "A valid from address is required.")>
</cfif>

<cfset cleanRecipients = []>
<cfloop array="#recipientList#" index="r">
  <cfset rr = LCase(Trim(ToString(r)))>
  <cfif rr NEQ "" AND IsValid("email", rr)><cfset ArrayAppend(cleanRecipients, rr)></cfif>
</cfloop>
<cfif ArrayLen(cleanRecipients) EQ 0>
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient="", subject=messageSubject, message_id="", result="rejected", rejection_reason="INVALID_RECIPIENT"})>
  <cfset txRespond(400, false, "INVALID_RECIPIENT", "At least one valid recipient is required.")>
</cfif>

<cfset fromDomain = lcase(listLast(fromAddress, "@"))>
<cfquery name="getAuthorizedDomain" datasource="hermes">
  SELECT id FROM domains WHERE LOWER(domain) = <cfqueryparam value="#fromDomain#" cfsqltype="cf_sql_varchar"> LIMIT 1
</cfquery>
<cfif getAuthorizedDomain.recordcount EQ 0>
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=arrayToList(cleanRecipients), subject=messageSubject, message_id="", result="rejected", rejection_reason="DOMAIN_NOT_ALLOWED"})>
  <cfset txRespond(403, false, "DOMAIN_NOT_ALLOWED", "The sender domain is not authorized in Hermes.")>
</cfif>

<cfset tokenAllowedSenders = txNormalizeList((isNull(tokenRow.allowed_senders) ? "" : tokenRow.allowed_senders))>
<cfif ArrayLen(tokenAllowedSenders) GT 0 AND NOT ArrayContains(tokenAllowedSenders, fromAddress)>
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=arrayToList(cleanRecipients), subject=messageSubject, message_id="", result="rejected", rejection_reason="SENDER_NOT_ALLOWED"})>
  <cfset txRespond(403, false, "SENDER_NOT_ALLOWED", "The sender address is not authorized for this API token.")>
</cfif>

<cfset tokenAllowedDomains = txNormalizeList((isNull(tokenRow.allowed_domains) ? "" : tokenRow.allowed_domains))>
<cfif ArrayLen(tokenAllowedDomains) GT 0 AND NOT ArrayContains(tokenAllowedDomains, fromDomain)>
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=arrayToList(cleanRecipients), subject=messageSubject, message_id="", result="rejected", rejection_reason="DOMAIN_NOT_ALLOWED"})>
  <cfset txRespond(403, false, "DOMAIN_NOT_ALLOWED", "The sender domain is not authorized for this API token.")>
</cfif>

<cfquery name="getTxnRateSettings" datasource="hermes">
  SELECT parameter, value2
  FROM parameters2
  WHERE module='transactional_email'
    AND parameter IN ('messages_per_minute','messages_per_hour','messages_per_day')
</cfquery>
<cfset rateSettings = {"messages_per_minute"=60,"messages_per_hour"=5000,"messages_per_day"=50000}>
<cfloop query="getTxnRateSettings"><cfset rateSettings[parameter] = val(value2)></cfloop>

<cfquery name="getRateUsage" datasource="hermes">
  SELECT
    SUM(CASE WHEN created_at >= DATE_SUB(NOW(), INTERVAL 1 MINUTE) THEN 1 ELSE 0 END) AS cpm,
    SUM(CASE WHEN created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR) THEN 1 ELSE 0 END) AS cph,
    SUM(CASE WHEN created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY) THEN 1 ELSE 0 END) AS cpd
  FROM transactional_email_audit
  WHERE auth_method='api'
    AND auth_identifier = <cfqueryparam value="#'token:' & tokenRow.id#" cfsqltype="cf_sql_varchar">
    AND result='accepted'
</cfquery>

<cfif val(getRateUsage.cpm) GTE rateSettings["messages_per_minute"] OR val(getRateUsage.cph) GTE rateSettings["messages_per_hour"] OR val(getRateUsage.cpd) GTE rateSettings["messages_per_day"]>
  <cfheader name="Retry-After" value="60">
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=arrayToList(cleanRecipients), subject=messageSubject, message_id="", result="rejected", rejection_reason="RATE_LIMIT_EXCEEDED"})>
  <cfset txRespond(429, false, "RATE_LIMIT_EXCEEDED", "Rate limit exceeded. Please retry later.")>
</cfif>

<cfif messageText EQ "" AND messageHtml EQ "">
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=arrayToList(cleanRecipients), subject=messageSubject, message_id="", result="rejected", rejection_reason="MISSING_CONTENT"})>
  <cfset txRespond(400, false, "MISSING_CONTENT", "Either text or html content must be provided.")>
</cfif>

<cfset messageId = createUUID() & "@" & fromDomain>
<cfset toList = arrayToList(cleanRecipients, ",")>

<cftry>
  <cfmail to="#toList#" from="#fromAddress#" subject="#messageSubject#" charset="utf-8" failto="#fromAddress#" type="html">
<cfif messageText NEQ ""><cfmailpart type="text/plain" charset="utf-8"><cfoutput>#messageText#</cfoutput></cfmailpart></cfif>
<cfif messageHtml NEQ ""><cfmailpart type="text/html" charset="utf-8"><cfoutput>#messageHtml#</cfoutput></cfmailpart><cfelse><cfoutput>#messageText#</cfoutput></cfif>
<cfmailparam name="Message-ID" value="<#messageId#>">
  </cfmail>
<cfcatch type="any">
  <cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=toList, subject=messageSubject, message_id=messageId, result="rejected", rejection_reason="DELIVERY_FAILED"})>
  <cfset txRespond(500, false, "DELIVERY_FAILED", "Message could not be queued for delivery.")>
</cfcatch>
</cftry>

<cfquery datasource="hermes">
  UPDATE transactional_api_tokens SET last_used_at = NOW()
  WHERE id = <cfqueryparam value="#tokenRow.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset txAudit({auth_method="api", auth_identifier="token:" & tokenRow.id, source_ip=sourceIp, sender=fromAddress, recipient=toList, subject=messageSubject, message_id=messageId, result="accepted", rejection_reason=""})>
<cfset txRespond(202, true, "", "", {"message":"Message accepted for delivery.", "message_id":messageId})>
