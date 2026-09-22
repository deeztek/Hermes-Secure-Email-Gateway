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
  directory_graph_enumerate.cfm (#337)

  Reads users from Microsoft 365 through the Microsoft Graph /users endpoint.

  WHY THERE IS NO LDAP OPTION HERE. Unlike Google, Microsoft 365 cannot be
  enumerated over LDAP at all. Entra ID exposes no LDAP endpoint, and Entra
  Domain Services is a separate paid product that needs an Azure virtual
  network and a password change for every cloud-only user. Graph is the route.

  AUTH. An app registration with a client secret, using the client credentials
  grant. Simpler than Google, which has no password of any kind and makes you
  sign a JWT with a private key instead. The application permission needed is
  User.Read.All, granted with admin consent; a delegated permission will not
  work because nobody is signed in when Ofelia runs this.

  Requires the following variables to be set before including:
    msTenant   - directory (tenant) ID, or the tenant's domain name
    msClientId - application (client) ID of the app registration
    msSecret   - client secret VALUE, already decrypted

  Sets, for the caller:
    graphRows      - array of {email, first, last, display, dn}
    graphError     - empty on success, otherwise a message fit to show an admin
    graphRawCount  - how many user objects came back before any filtering
--->

<cfset graphRows     = []>
<cfset graphError    = "">
<cfset graphRawCount = 0>

<cftry>

  <cfif NOT Len(Trim(msTenant))>
    <cfthrow message="No tenant is configured for this directory.">
  </cfif>
  <cfif NOT Len(Trim(msClientId))>
    <cfthrow message="No application (client) ID is configured for this directory.">
  </cfif>
  <cfif NOT Len(Trim(msSecret))>
    <cfthrow message="No client secret is configured for this directory, or the stored one could not be decrypted.">
  </cfif>

  <!--- ============================================================
       1. Client credentials grant
       ============================================================
       scope=.default means "every application permission already consented
       for this app", so the scope never has to be kept in step with what an
       administrator granted in the portal. --->
  <cfhttp method="post" url="https://login.microsoftonline.com/#URLEncodedFormat(Trim(msTenant))#/oauth2/v2.0/token" timeout="30" result="msTokenCall">
    <cfhttpparam type="formfield" name="grant_type"    value="client_credentials">
    <cfhttpparam type="formfield" name="client_id"     value="#Trim(msClientId)#">
    <cfhttpparam type="formfield" name="client_secret" value="#Trim(msSecret)#">
    <cfhttpparam type="formfield" name="scope"         value="https://graph.microsoft.com/.default">
  </cfhttp>

  <cfif NOT IsJSON(msTokenCall.fileContent)>
    <cfthrow message="Microsoft returned an unreadable response when requesting a token (HTTP #msTokenCall.statusCode#). Check that the tenant is correct.">
  </cfif>
  <cfset msTokenResp = DeserializeJSON(msTokenCall.fileContent)>

  <cfif StructKeyExists(msTokenResp, "error")>
    <!--- Entra returns an AADSTS code that names the cause precisely, but
         buries it in a paragraph with a correlation ID and a timestamp. Pull
         out the four that account for nearly every failed setup. --->
    <cfset msBody = msTokenCall.fileContent>
    <cfset msHint = "">
    <cfif FindNoCase("AADSTS7000215", msBody) GT 0>
      <cfset msHint = " The client secret is wrong. Note that Entra shows the secret VALUE only once, at creation: if what you have is the Secret ID instead, create a new secret and copy the Value column.">
    <cfelseif FindNoCase("AADSTS7000222", msBody) GT 0>
      <cfset msHint = " The client secret has expired. Create a new one on the app registration under Certificates and secrets.">
    <cfelseif FindNoCase("AADSTS700016", msBody) GT 0>
      <cfset msHint = " No application with that client ID exists in this tenant. Either the Application (client) ID is wrong, or it belongs to a different tenant.">
    <cfelseif FindNoCase("AADSTS90002", msBody) GT 0>
      <cfset msHint = " That tenant does not exist. Use the Directory (tenant) ID from the app registration's Overview page, or the tenant's domain name.">
    </cfif>
    <cfset msErrText = StructKeyExists(msTokenResp, "error_description") ? ListFirst(msTokenResp.error_description, Chr(13) & Chr(10)) : msTokenResp.error>
    <cfthrow message="Microsoft refused the credentials: #msErrText##msHint#">
  </cfif>

  <cfif NOT StructKeyExists(msTokenResp, "access_token")>
    <cfthrow message="Microsoft accepted the request but returned no access token.">
  </cfif>
  <cfset msToken = msTokenResp.access_token>

  <!--- ============================================================
       2. Page through the directory
       ============================================================
       proxyAddresses is not in the default property set, so it has to be named
       in $select or the aliases silently do not arrive. $top=999 is the
       documented maximum for /users.

       Graph does have a delta endpoint for users. It is not used: this runs on
       a schedule against a list that is small by API standards, and a delta
       token that expires or is lost turns into a silent partial sync, which
       for a mail gateway means someone quietly has no portal access. A full
       list every run and a local diff cannot drift. --->
  <cfset msUrl   = "https://graph.microsoft.com/v1.0/users"
                 & "?$select=mail,userPrincipalName,proxyAddresses,givenName,surname,displayName,accountEnabled"
                 & "&$top=999">
  <cfset msPages = 0>

  <cfloop condition="true">

    <cfhttp method="get" url="#msUrl#" timeout="60" result="msListCall">
      <cfhttpparam type="header" name="Authorization" value="Bearer #msToken#">
      <cfhttpparam type="header" name="Accept"        value="application/json">
    </cfhttp>

    <!--- Graph throttles per tenant. A 429 is not a misconfiguration and does
         not need an admin to do anything, so say so plainly rather than
         reporting it as a failure they should investigate. The next scheduled
         run picks up where this left off, and rule 1 holds: a failed
         enumeration stages nothing and leaves previous results untouched. --->
    <cfif val(msListCall.statusCode) EQ 429>
      <cfthrow message="Microsoft is currently throttling requests for this tenant. Nothing was changed; the next scheduled sync will retry.">
    </cfif>

    <cfif NOT IsJSON(msListCall.fileContent)>
      <cfthrow message="Microsoft returned an unreadable directory response (HTTP #msListCall.statusCode#).">
    </cfif>
    <cfset msList = DeserializeJSON(msListCall.fileContent)>

    <cfif StructKeyExists(msList, "error")>
      <cfset msMsg = (IsStruct(msList.error) AND StructKeyExists(msList.error, "message")) ? msList.error.message : "unknown error">
      <cfset msHint2 = "">
      <cfif FindNoCase("Authorization_RequestDenied", msListCall.fileContent) GT 0>
        <cfset msHint2 = " The app registration is missing the User.Read.All APPLICATION permission, or it was added but never granted admin consent. Both steps are required.">
      </cfif>
      <cfthrow message="Microsoft rejected the directory request: #msMsg##msHint2#">
    </cfif>

    <cfif StructKeyExists(msList, "value") AND IsArray(msList.value)>
      <cfloop array="#msList.value#" index="msU">

        <cfset msMail = (StructKeyExists(msU, "mail") AND IsSimpleValue(msU.mail)) ? LCase(Trim(msU.mail)) : "">
        <cfset msUpn  = (StructKeyExists(msU, "userPrincipalName") AND IsSimpleValue(msU.userPrincipalName)) ? LCase(Trim(msU.userPrincipalName)) : "">

        <!--- Guests. Their UPN is mangled (user_contoso.com#EXT#@tenant) and
             their mail is an address at someone else's company, so they are
             not recipients this gateway relays for. Skipped by shape rather
             than left to the relay-domain filter, because a guest invited
             from a domain Hermes does relay for would otherwise slip through
             and be provisioned as though they were staff. --->
        <cfif FindNoCase("##EXT##", msUpn) GT 0><cfcontinue></cfif>

        <!--- mail, with the UPN as fallback. mail is empty on accounts that
             have never been assigned a mailbox, and in most tenants the UPN
             is the address anyway. Anything that is not in a relay domain is
             discarded downstream regardless. --->
        <cfset msPrimary = Len(msMail) ? msMail : msUpn>
        <cfif NOT Len(msPrimary) OR NOT (msPrimary CONTAINS "@")><cfcontinue></cfif>
        <cfset graphRawCount++>

        <!--- accountEnabled=false is not a reason to skip anyone. It blocks
             sign-in, not delivery: the mailbox still exists and still receives
             mail, which is precisely when quarantine matters. Same call the
             Google connector makes about suspended accounts. --->

        <cfset msFirst = (StructKeyExists(msU, "givenName") AND IsSimpleValue(msU.givenName)) ? Trim(msU.givenName) : "">
        <cfset msLast  = (StructKeyExists(msU, "surname")   AND IsSimpleValue(msU.surname))   ? Trim(msU.surname)   : "">
        <cfif StructKeyExists(msU, "displayName") AND IsSimpleValue(msU.displayName) AND Len(Trim(msU.displayName))>
          <cfset msDisplay = Trim(msU.displayName)>
        <cfelse>
          <cfset msDisplay = (Len(msFirst) AND Len(msLast)) ? msFirst & " " & msLast : msPrimary>
        </cfif>

        <!--- Every address the account answers on. proxyAddresses mixes
             schemes: SMTP: (primary), smtp: (alias), plus x500:, sip: and
             SPO: entries that are not mail addresses at all. Only the smtp
             ones are addresses, and the case distinction is meaningless here
             because the primary is already in the list. --->
        <cfset msAddrs = [msPrimary]>
        <cfif StructKeyExists(msU, "proxyAddresses") AND IsArray(msU.proxyAddresses)>
          <cfloop array="#msU.proxyAddresses#" index="msPa">
            <!--- EQ is case insensitive in CFML, so this catches SMTP: and
                 smtp: alike without testing for both. --->
            <cfif IsSimpleValue(msPa) AND Left(msPa, 5) EQ "smtp:">
              <cfset ArrayAppend(msAddrs, LCase(Trim(Mid(msPa, 6, Len(msPa)))))>
            </cfif>
          </cfloop>
        </cfif>

        <cfloop array="#msAddrs#" index="msAddr">
          <cfif Len(msAddr) AND msAddr CONTAINS "@">
            <cfset ArrayAppend(graphRows, {
              email   = msAddr,
              first   = msFirst,
              last    = msLast,
              display = msDisplay,
              dn      = ""
            })>
          </cfif>
        </cfloop>
      </cfloop>
    </cfif>

    <cfset msPages++>
    <!--- Graph hands back a complete URL to follow, query string and skip
         token included, so it is used verbatim rather than rebuilt. --->
    <cfif NOT StructKeyExists(msList, "@odata.nextLink") OR NOT Len(Trim(msList["@odata.nextLink"]))>
      <cfbreak>
    </cfif>
    <!--- A runaway page loop would hammer the API and never finish. 200 pages
         at 999 each is nearly 200,000 accounts, well past any plausible
         tenant. --->
    <cfif msPages GTE 200><cfbreak></cfif>
    <cfset msUrl = msList["@odata.nextLink"]>
  </cfloop>

  <cfcatch type="any">
    <cfset graphError = cfcatch.message>
    <cfset graphRows  = []>
  </cfcatch>
</cftry>
