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
  ldap_build_ca_bundle.cfm (#335)

  Builds the trust store a TLS LDAP connection actually verifies against:
  whatever the administrator uploaded, plus the container's public roots.

  WHY. Setting tls_cacert REPLACES the system trust store rather than adding
  to it. OpenLDAP falls back to the public roots only when no CA is configured
  at all, so uploading a private CA for an internal directory silently costs
  you every public one. Verifying ldap.google.com then fails, and OpenLDAP
  reports that as "can't contact LDAP server", which sends an administrator to
  check a firewall that is fine.

  The manual workaround was to find the right public root and concatenate it
  by hand. That is a documented step nobody should have to perform, and it has
  to be repeated whenever a root rotates.

  WHAT IS AND IS NOT STORED. The uploaded file is kept exactly as given and is
  the only thing the console reads: "Installed" must mean "you uploaded this".
  The combined file is derived, named separately, rebuilt on every apply, and
  never written back to the settings column. Conflating them would have the
  console claim a certificate the administrator never provided.

  Rebuilt each time rather than cached, so a container image carrying updated
  roots takes effect without anyone re-uploading anything.

  Expects:
    caSourceDir     - directory holding the uploaded file, and where the
                      derived file is written
    caUploadedFile  - filename of the uploaded bundle, or "" for none
    caEffectiveName - filename to write the derived bundle as

  Sets:
    caEffectivePath - absolute path for tls_cacert, or "" if it could not be
                      built, in which case the caller should omit tls_cacert
                      and let OpenLDAP use its own default
--->

<cfparam name="caSourceDir"     default="">
<cfparam name="caUploadedFile"  default="">
<cfparam name="caEffectiveName" default="ca_effective.pem">

<cfset caEffectivePath = "">

<!--- Nothing uploaded means nothing to combine. Returning "" makes the caller
     omit tls_cacert entirely, so OpenLDAP uses its own trust store directly
     rather than a copy of it.

     That matters beyond tidiness: a copy is a snapshot. The container's roots
     move when the image is rebuilt, and a derived file sitting on the host
     would keep the old set until somebody happened to re-apply. Using the
     store in place cannot go stale. --->
<cfif NOT Len(Trim(caUploadedFile))>
  <cfexit>
</cfif>

<cftry>
  <cfif NOT Len(Trim(caSourceDir))>
    <cfthrow message="No certificate directory given">
  </cfif>
  <cfif NOT DirectoryExists(caSourceDir)>
    <cfdirectory action="create" directory="#caSourceDir#" mode="755">
  </cfif>

  <cfset caOut = caSourceDir & "/" & caEffectiveName>
  <cfset caUp  = caSourceDir & "/" & Trim(caUploadedFile)>
  <cfif NOT FileExists(caUp)>
    <cfthrow message="Uploaded CA bundle is missing from disk">
  </cfif>

  <!--- The public roots come from hermes_ldap, because that is the container
       whose slapd does the verifying. Reading commandbox's own copy would
       usually match but is not the same file. --->
  <cfset caTmpSh = "/opt/hermes/tmp/" & LCase(Left(Replace(CreateUUID(), "-", "", "all"), 10)) & "_cabundle.sh">

  <cfsavecontent variable="caShBody"><cfoutput>##!/bin/bash
set -u
OUT='#caOut#'
: > "$OUT"
if [ -s '#caUp#' ]; then cat '#caUp#' >> "$OUT"; echo >> "$OUT"; fi
/usr/local/bin/docker exec hermes_ldap cat /etc/ssl/certs/ca-certificates.crt >> "$OUT" 2>/dev/null
exit 0
</cfoutput></cfsavecontent>

  <cffile action="write" file="#caTmpSh#" output="#caShBody#" charset="utf-8" mode="700" addNewLine="no">
  <cfexecute name="/bin/bash" arguments="#caTmpSh#" timeout="60" variable="caShOut" errorVariable="caShErr"></cfexecute>
  <cftry><cffile action="delete" file="#caTmpSh#"><cfcatch></cfcatch></cftry>

  <!--- A file with no certificate in it is worse than none: tls_cacert would
       point at something that can verify nothing, and every TLS mapping would
       fail. Better to omit the option and let OpenLDAP use its own default. --->
  <cfif NOT FileExists(caOut)>
    <cfthrow message="Combined CA bundle was not written">
  </cfif>
  <cfset caCheck = FileRead(caOut, "utf-8")>
  <cfif FindNoCase("BEGIN CERTIFICATE", caCheck) LTE 0>
    <cftry><cffile action="delete" file="#caOut#"><cfcatch></cfcatch></cftry>
    <cfthrow message="Combined CA bundle contained no certificates">
  </cfif>

  <cfset caEffectivePath = caOut>

  <cfcatch type="any">
    <cfset caEffectivePath = "">
  </cfcatch>
</cftry>
