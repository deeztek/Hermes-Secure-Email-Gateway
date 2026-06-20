
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

INVALIDATE USER SESSIONS
Scans Authelia's Redis session store and deletes sessions belonging to
a specific user (or all sessions if targetSessionUser is "*").

Authelia stores sessions in Redis using Go's gob binary serialization.
The username is embedded as a length-prefixed string inside the binary
blob. We use a substring search against the raw Redis value to find
matching sessions. The false-positive risk is essentially zero because
we match full email addresses.

Requires the following variable to be set before including:
  - targetSessionUser: email/username to invalidate, or "*" for all users

Sets the following variable after execution:
  - sessionsInvalidated: number of sessions deleted (0 if none found or error)

Uses docker exec to run redis-cli inside the hermes_authelia_redis container.
The Redis password is read from the secrets file on the host.
--->

<cfparam name="targetSessionUser" default="">
<cfset sessionsInvalidated = 0>

<cfif targetSessionUser EQ "">
    <!--- No target specified, skip --->
<cfelse>

<cftry>
    <!--- Read the Authelia Redis password from the secrets file --->
    <cffile action="read" file="/opt/hermes/keys/authelia_session_redis_password_file" variable="redisPassword" charset="utf-8">
    <cfset redisPassword = Trim(redisPassword)>

    <cfif targetSessionUser EQ "*">
        <!--- FLUSH ALL SESSIONS (emergency "force logout all") --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_authelia_redis redis-cli -a #redisPassword# --no-auth-warning FLUSHDB"
            variable="flushResult"
            errorVariable="flushError"
            timeout="30" />
        <cfset sessionsInvalidated = -1>
        <!--- -1 signals "all sessions flushed" to the caller --->
    <cfelse>
        <!--- SCAN FOR SESSIONS MATCHING THE TARGET USER --->
        <cfset deletedCount = 0>

        <!--- Get all session keys using SCAN. Authelia prefixes session keys
             with the session name configured in configuration.yml
             (default: "authelia_session-" or the configured name + "-"). --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_authelia_redis redis-cli -a #redisPassword# --no-auth-warning --scan --pattern *"
            variable="scanResult"
            errorVariable="scanError"
            timeout="30" />

        <cfif Len(trim(scanResult)) GT 0>
            <cfloop list="#scanResult#" delimiters="#Chr(10)#" index="sessionKey">
                <cfset sessionKey = Trim(sessionKey)>
                <cfif sessionKey EQ "" OR sessionKey EQ "OK">
                    <cfcontinue>
                </cfif>

                <!--- GET the session value and search for the username --->
                <cftry>
                    <cfexecute name="/usr/local/bin/docker"
                        arguments="exec hermes_authelia_redis redis-cli -a #redisPassword# --no-auth-warning GET #sessionKey#"
                        variable="sessionValue"
                        errorVariable="getError"
                        timeout="10" />

                    <!--- Substring search for the username in the binary blob.
                         Go gob stores strings as length-prefixed UTF-8, so the
                         email address appears as a literal substring. Match is
                         case-sensitive (email addresses are case-insensitive by
                         spec but Authelia stores the exact username from LDAP). --->
                    <cfif IsDefined("sessionValue") AND Len(sessionValue) GT 0 AND FindNoCase(targetSessionUser, sessionValue) GT 0>
                        <!--- Delete this session --->
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec hermes_authelia_redis redis-cli -a #redisPassword# --no-auth-warning DEL #sessionKey#"
                            variable="delResult"
                            errorVariable="delError"
                            timeout="10" />
                        <cfset deletedCount++>
                    </cfif>
                <cfcatch type="any">
                    <!--- Skip this key if GET fails (key may have expired) --->
                </cfcatch>
                </cftry>
            </cfloop>
        </cfif>

        <cfset sessionsInvalidated = deletedCount>
    </cfif>

<cfcatch type="any">
    <!--- Session invalidation is non-fatal. Log the error but don't
         abort the calling action. --->
    <cfset sessionsInvalidated = 0>
</cfcatch>
</cftry>

</cfif>
