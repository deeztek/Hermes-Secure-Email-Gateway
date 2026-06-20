
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<!--- CONFIGURE OPENDKIM.CONF FILE --->

<!--- Read template and perform all replacements in memory --->
<cffile action="read" file="/opt/hermes/conf_files/opendkim.conf.HERMES" variable="dkimfile">

<cfset dkimfile = REReplace(dkimfile, "HEADER-CANONICALIZATION", form.headers_canonicalization, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "BODY-CANONICALIZATION", form.body_canonicalization, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "DEFAULT-ACTION", form.default_action, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "BADSIGNATURE-ACTION", form.badsignature_action, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "DNSERROR-ACTION", form.dnserror_action, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "INTERNALERROR-ACTION", form.internalerror_action, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "NOSIGNATURE-ACTION", form.nosignature_action, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "SECURITY-ACTION", form.security_action, "ALL")>
<cfset dkimfile = REReplace(dkimfile, "SIGNATURE-ALGORITHM", form.signature_algorithm, "ALL")>

<!--- Write directly to /etc/opendkim.conf (single-file bind mount — cannot copy/move, must write in place) --->
<cffile action="write" file="/etc/opendkim.conf" output="#dkimfile#">
