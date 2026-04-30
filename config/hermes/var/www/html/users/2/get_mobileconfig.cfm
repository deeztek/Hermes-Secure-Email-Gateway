<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
TOKEN-VALIDATED MOBILECONFIG DOWNLOAD (#224 Phase 2c)

Single-use download endpoint for the Apple device setup wizard. The
flow:
  1. Wizard mints a profile, stores the bytes in mobile_setup_tokens
     with a random 64-char token + 30-min expiry.
  2. The result page shows a QR encoding this URL with ?token=<t>.
  3. Phone scans the QR, gets here. Authelia auth applies (the file
     lives under /users so Application.cfc enforces SSO). Token is
     the secondary check that gates the actual file delivery.
  4. We atomically claim the token (UPDATE ... WHERE used_at IS NULL
     AND expires_at > NOW()) so concurrent hits can't double-deliver.
  5. We require user_email = session.email so a leaked URL cannot be
     fetched by another user.

Failure modes (invalid format, no row, expired, already used, wrong
user) all render the same generic "link is no longer valid" page —
don't leak which case it was.
--->

<cfparam name="url.token" default="">

<cfset _gtToken = Trim(url.token)>

<!--- Format check: 64-char lowercase hex. Anything else is rejected
     before we even hit the database. --->
<cfif Len(_gtToken) NEQ 64 OR REFind("^[a-f0-9]{64}$", _gtToken) EQ 0>
    <cfinclude template="./inc/setup_apple_token_invalid.cfm">
    <cfabort>
</cfif>

<!--- Atomic single-use claim. The UPDATE either flips one row to used
     OR matches zero rows. recordcount tells us which. By doing this
     BEFORE the SELECT, we avoid a TOCTOU race where two scans of the
     same QR both pass validation and both serve the file. --->
<cfquery name="_gtClaim" datasource="hermes" result="_gtClaimResult">
    UPDATE mobile_setup_tokens
    SET used_at = NOW()
    WHERE token = <cfqueryparam value="#_gtToken#" cfsqltype="cf_sql_varchar">
      AND used_at IS NULL
      AND expires_at > NOW()
</cfquery>

<cfif _gtClaimResult.recordcount NEQ 1>
    <cfinclude template="./inc/setup_apple_token_invalid.cfm">
    <cfabort>
</cfif>

<!--- Fetch the just-claimed payload. user_email is checked against
     the current session so a leaked URL can't be fetched by anyone
     else. --->
<cfquery name="_gtRow" datasource="hermes">
    SELECT user_email, filename, content_type, payload_blob
    FROM mobile_setup_tokens
    WHERE token = <cfqueryparam value="#_gtToken#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif _gtRow.recordcount NEQ 1
   OR _gtRow.user_email NEQ session.email
   OR Len(_gtRow.payload_blob) EQ 0>
    <cfinclude template="./inc/setup_apple_token_invalid.cfm">
    <cfabort>
</cfif>

<cfset _gtFilename    = (Len(_gtRow.filename)     GT 0) ? _gtRow.filename     : "hermes.mobileconfig">
<cfset _gtContentType = (Len(_gtRow.content_type) GT 0) ? _gtRow.content_type : "application/x-apple-aspen-config">

<cfheader name="Content-Disposition" value="attachment; filename=""#_gtFilename#""">
<cfcontent reset="true" type="#_gtContentType#" variable="#_gtRow.payload_blob#">
<cfabort>
