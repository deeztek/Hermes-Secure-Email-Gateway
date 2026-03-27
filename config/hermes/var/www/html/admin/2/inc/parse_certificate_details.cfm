
    <!---
    Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
<!--- PARSE CERTIFICATE DETAILS STARTS HERE --->
<!--- Single openssl call to extract all certificate fields at once --->

<cftry>

  <cfexecute name="/usr/bin/openssl"
    arguments="x509 -in #path# -noout -fingerprint -subject -issuer -startdate -enddate -serial -ext subjectAltName"
    variable="certOutput"
    timeout="120">
  </cfexecute>

  <!--- Parse each field from the combined output --->
  <cfset fingerprint = "N/A">
  <cfset subject = "N/A">
  <cfset issuer = "N/A">
  <cfset thestartdate = "N/A">
  <cfset theenddate = "N/A">
  <cfset serial = "N/A">
  <cfset san = "N/A">
  <cfset sanList = []>

  <cfloop list="#certOutput#" delimiters="#chr(10)#" index="line">
    <cfset line = trim(line)>

    <cfif line contains "SHA1 Fingerprint=" OR line contains "sha1 Fingerprint=">
      <cfset fingerprint = REReplace(line, "(?i)SHA1 Fingerprint=", "", "ALL")>
      <cfset fingerprint = trim(fingerprint)>

    <cfelseif line contains "subject=" AND NOT line contains "subjectAltName">
      <cfset subject = REReplace(line, "subject=", "", "ONE")>
      <cfset subject = trim(subject)>

    <cfelseif line contains "issuer=">
      <cfset issuer = REReplace(line, "issuer=", "", "ONE")>
      <cfset issuer = trim(issuer)>

    <cfelseif line contains "notBefore=">
      <cfset thestartdate = REReplace(line, "notBefore=", "", "ONE")>
      <cfset thestartdate = trim(thestartdate)>

    <cfelseif line contains "notAfter=">
      <cfset theenddate = REReplace(line, "notAfter=", "", "ONE")>
      <cfset theenddate = trim(theenddate)>

    <cfelseif line contains "serial=">
      <cfset serial = REReplace(line, "serial=", "", "ONE")>
      <cfset serial = trim(serial)>

    <cfelseif line contains "DNS:">
      <!--- SAN line contains comma-separated DNS entries like "DNS:a.com, DNS:b.com" --->
      <cfset sanEntries = ListToArray(line, ",")>
      <cfloop array="#sanEntries#" index="entry">
        <cfset entry = trim(entry)>
        <cfif entry contains "DNS:">
          <cfset ArrayAppend(sanList, REReplace(entry, "DNS:", "", "ONE"))>
        </cfif>
      </cfloop>
    </cfif>
  </cfloop>

  <cfif ArrayLen(sanList) GT 0>
    <cfset san = ArrayToList(sanList, ", ")>
  </cfif>

  <cfcatch type="any">

    <cfset step = 0>
    <cfset session.m = "Parse Certificate: Error #cfcatch.detail# while parsing certificate details for #path#">
    <cfinclude template="error.cfm">
    <cfabort>

  </cfcatch>

</cftry>

<!--- PARSE CERTIFICATE DETAILS ENDS HERE --->
