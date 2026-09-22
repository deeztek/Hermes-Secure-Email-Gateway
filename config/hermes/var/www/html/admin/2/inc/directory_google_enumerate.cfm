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
  directory_google_enumerate.cfm (#336)

  Reads users from Google Workspace through the Admin SDK Directory API.

  WHY THIS EXISTS ALONGSIDE THE LDAP CONNECTOR. Google Secure LDAP can already
  be enumerated with provider='ldap', but it is a Business Plus feature. The
  Admin SDK works on every Workspace tier, so this is the route that serves a
  customer who wants their recipient list read without paying to move up a
  plan. Auto-provisioning and SSO are separate needs and should not share a
  price.

  AUTH. A service account with domain-wide delegation, impersonating a super
  administrator. Google issues no password: you sign a JWT with the service
  account's private key and exchange it for an access token. That is the one
  genuinely fiddly part, and why this could not simply reuse cfhttp with a
  client secret the way Microsoft Graph will.

  Sets, for the caller:
    googleRows      - array of {email, first, last, display, dn}
    googleError     - empty on success, otherwise a message fit to show an admin
    googleRawCount  - how many user objects came back before any filtering
--->

<cfset googleRows     = []>
<cfset googleError    = "">
<cfset googleRawCount = 0>

<cfscript>
// Base64url, as JWT requires: standard Base64 with the two URL-unsafe
// characters swapped and the padding dropped.
function gB64Url(required any bytes) {
    var b = IsBinary(arguments.bytes) ? ToBase64(arguments.bytes) : ToBase64(arguments.bytes.getBytes("UTF-8"));
    b = Replace(b, "+", "-", "all");
    b = Replace(b, "/", "_", "all");
    return ReReplace(b, "=+$", "");
}
</cfscript>

<cftry>

  <cfif NOT Len(Trim(gSaJson))>
    <cfthrow message="No service account key is configured for this directory.">
  </cfif>
  <cfif NOT Len(Trim(gSubject))>
    <cfthrow message="No administrator to impersonate is configured. Domain-wide delegation requires one.">
  </cfif>
  <cfif NOT IsJSON(Trim(gSaJson))>
    <cfthrow message="The stored service account key is not valid JSON. Re-upload the key file Google gave you, unmodified.">
  </cfif>

  <cfset gSa = DeserializeJSON(Trim(gSaJson))>
  <cfif NOT StructKeyExists(gSa, "client_email") OR NOT StructKeyExists(gSa, "private_key")>
    <cfthrow message="The service account key is missing client_email or private_key. That is the JSON Google downloads when you create the key, not the OAuth client file.">
  </cfif>

  <!--- ============================================================
       1. Build and sign the assertion
       ============================================================ --->
  <cfset gNow    = Int(GetTickCount() / 1000)>
  <cfset gHeader = '{"alg":"RS256","typ":"JWT"}'>
  <cfset gClaims = SerializeJSON({
        "iss"   = gSa.client_email,
        "scope" = "https://www.googleapis.com/auth/admin.directory.user.readonly",
        "aud"   = "https://oauth2.googleapis.com/token",
        "sub"   = Trim(gSubject),
        "iat"   = gNow,
        "exp"   = gNow + 3600
  })>
  <cfset gSigningInput = gB64Url(gHeader) & "." & gB64Url(gClaims)>

  <!--- The key arrives PEM encoded with literal \n inside the JSON string.
       DeserializeJSON turns those into real newlines; strip the armour and
       whitespace either way and what is left is Base64 PKCS#8. --->
  <cfset gKeyPem = ReReplace(gSa.private_key, "-----[A-Z ]+-----", "", "ALL")>
  <cfset gKeyPem = ReReplace(gKeyPem, "\s", "", "ALL")>
  <cfset gKeyBytes = BinaryDecode(gKeyPem, "Base64")>

  <cfset gSpec    = CreateObject("java", "java.security.spec.PKCS8EncodedKeySpec").init(gKeyBytes)>
  <cfset gKeyFact = CreateObject("java", "java.security.KeyFactory").getInstance("RSA")>
  <cfset gPrivKey = gKeyFact.generatePrivate(gSpec)>

  <cfset gSigner = CreateObject("java", "java.security.Signature").getInstance("SHA256withRSA")>
  <cfset gSigner.initSign(gPrivKey)>
  <cfset gSigner.update(gSigningInput.getBytes("UTF-8"))>
  <cfset gAssertion = gSigningInput & "." & gB64Url(gSigner.sign())>

  <!--- ============================================================
       2. Exchange it for an access token
       ============================================================ --->
  <cfhttp method="post" url="https://oauth2.googleapis.com/token" timeout="30" result="gTokenCall">
    <cfhttpparam type="formfield" name="grant_type" value="urn:ietf:params:oauth:grant-type:jwt-bearer">
    <cfhttpparam type="formfield" name="assertion"  value="#gAssertion#">
  </cfhttp>

  <cfif NOT IsJSON(gTokenCall.fileContent)>
    <cfthrow message="Google returned an unreadable response when exchanging the key for a token (HTTP #gTokenCall.statusCode#).">
  </cfif>
  <cfset gTokenResp = DeserializeJSON(gTokenCall.fileContent)>

  <cfif StructKeyExists(gTokenResp, "error")>
    <!--- Google's token errors are terse and the causes are specific, so name
         the two that account for nearly all of them. --->
    <cfset gHint = "">
    <cfif FindNoCase("unauthorized_client", gTokenCall.fileContent) GT 0>
      <cfset gHint = " The service account is not authorised for this scope in the Workspace admin console. Add its client ID under Security, Access and data control, API controls, Domain-wide delegation, with the scope admin.directory.user.readonly.">
    <cfelseif FindNoCase("invalid_grant", gTokenCall.fileContent) GT 0>
      <cfset gHint = " Usually the impersonated account: it must be a real super administrator in this Workspace. A clock skew of more than a few minutes on this gateway will also do it.">
    </cfif>
    <cfthrow message="Google refused the service account key: #gTokenResp.error##gHint#">
  </cfif>

  <cfif NOT StructKeyExists(gTokenResp, "access_token")>
    <cfthrow message="Google accepted the request but returned no access token.">
  </cfif>
  <cfset gToken = gTokenResp.access_token>

  <!--- ============================================================
       3. Page through the directory
       ============================================================
       customer=my_customer means "the account this administrator belongs to",
       so no domain has to be configured. Addresses are filtered against the
       relay domains afterwards, exactly as the LDAP connector's results are.

       There is no delta endpoint for users, so this is a full list every run
       and the diff is done locally. The People API does offer sync tokens but
       returns the shared directory profile, which honours per-user visibility
       settings and can omit people entirely. For a mail gateway a missing
       address means someone quietly has no portal access, so it is the wrong
       trade. --->
  <cfset gPageToken = "">
  <cfset gPages     = 0>

  <cfloop condition="true">
    <cfset gUrl = "https://admin.googleapis.com/admin/directory/v1/users"
                & "?customer=my_customer&maxResults=500&projection=full&viewType=admin_view">
    <cfif Len(gPageToken)>
      <cfset gUrl = gUrl & "&pageToken=" & URLEncodedFormat(gPageToken)>
    </cfif>

    <cfhttp method="get" url="#gUrl#" timeout="60" result="gListCall">
      <cfhttpparam type="header" name="Authorization" value="Bearer #gToken#">
    </cfhttp>

    <cfif NOT IsJSON(gListCall.fileContent)>
      <cfthrow message="Google returned an unreadable directory response (HTTP #gListCall.statusCode#).">
    </cfif>
    <cfset gList = DeserializeJSON(gListCall.fileContent)>

    <cfif StructKeyExists(gList, "error")>
      <cfset gMsg = StructKeyExists(gList.error, "message") ? gList.error.message : "unknown error">
      <cfthrow message="Google rejected the directory request: #gMsg#">
    </cfif>

    <cfif StructKeyExists(gList, "users")>
      <cfloop array="#gList.users#" index="gU">
        <cfset gPrimary = StructKeyExists(gU, "primaryEmail") ? LCase(Trim(gU.primaryEmail)) : "">
        <cfif NOT Len(gPrimary)><cfcontinue></cfif>
        <cfset googleRawCount++>

        <!--- Suspended accounts still have a mailbox and still receive mail, so
             they are enumerated like anyone else. Archived ones are gone. --->
        <cfif StructKeyExists(gU, "archived") AND gU.archived><cfcontinue></cfif>

        <cfset gFirst = "">
        <cfset gLast  = "">
        <cfif StructKeyExists(gU, "name")>
          <cfif StructKeyExists(gU.name, "givenName")><cfset gFirst = Trim(gU.name.givenName)></cfif>
          <cfif StructKeyExists(gU.name, "familyName")><cfset gLast = Trim(gU.name.familyName)></cfif>
        </cfif>
        <cfset gDisplay = (Len(gFirst) AND Len(gLast)) ? gFirst & " " & gLast : gPrimary>

        <!--- Every address the account answers on: the primary plus aliases.
             Staged individually and filtered by relay domain downstream, the
             same shape the LDAP connector produces from proxyAddresses. --->
        <cfset gAddrs = [gPrimary]>
        <cfloop list="aliases,nonEditableAliases" index="gAliasKey">
          <cfif StructKeyExists(gU, gAliasKey) AND IsArray(gU[gAliasKey])>
            <cfloop array="#gU[gAliasKey]#" index="gAl">
              <cfset ArrayAppend(gAddrs, LCase(Trim(gAl)))>
            </cfloop>
          </cfif>
        </cfloop>

        <cfloop array="#gAddrs#" index="gAddr">
          <cfif Len(gAddr) AND gAddr CONTAINS "@">
            <cfset ArrayAppend(googleRows, {
              email   = gAddr,
              first   = gFirst,
              last    = gLast,
              display = gDisplay,
              dn      = ""
            })>
          </cfif>
        </cfloop>
      </cfloop>
    </cfif>

    <cfset gPages++>
    <cfif NOT StructKeyExists(gList, "nextPageToken") OR NOT Len(Trim(gList.nextPageToken))>
      <cfbreak>
    </cfif>
    <!--- A runaway page loop would hammer the API and never finish. 200 pages
         at 500 each is 100,000 accounts, well past any plausible tenant. --->
    <cfif gPages GTE 200><cfbreak></cfif>
    <cfset gPageToken = gList.nextPageToken>
  </cfloop>

  <cfcatch type="any">
    <cfset googleError = cfcatch.message>
    <cfset googleRows  = []>
  </cfcatch>
</cftry>
