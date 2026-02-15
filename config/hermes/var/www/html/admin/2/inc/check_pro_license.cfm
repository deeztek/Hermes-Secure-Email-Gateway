<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Standalone license check for scheduled tasks (no session required).
Sets: isProEdition (boolean), licenseStatus (VALID/EXPIRED/VIOLATION/N/A)
--->

<cfset isProEdition = false>
<cfset licenseStatus = "N/A">

<cfset uuid2_file = "/usr/share/UUID2">

<cfif fileExists(uuid2_file)>

    <!--- UUID2 exists - check if it's a valid Pro license --->
    <cffile action="read" file="/usr/share/UUID" variable="uuid">
    <cffile action="read" file="/usr/share/UUID2" variable="uuid2">
    <cfset compare_uuid = Compare(trim(uuid), trim(uuid2))>

    <cfif compare_uuid EQ 0>
        <!--- UUIDs match - check license expiration --->
        <cfset lt_file = "/usr/share/lt">
        <cfset date_file = "/usr/share/djigzo/ADDITIONAL-NOTES.TXT">

        <cfif fileExists(lt_file) AND fileExists(date_file)>
            <cffile action="read" file="#lt_file#" variable="lt">
            <cffile action="read" file="#date_file#" variable="licenseDate">

            <cfset lt2 = trim(lt)>
            <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
            <cfset timenow = TimeFormat(now(), "HH:mm:ss")>
            <cfset difference = datediff("d", "#datenow# #timenow#", trim(licenseDate))>

            <cfif difference GTE 1>
                <!--- License is valid and not expired --->
                <cfset isProEdition = true>
                <cfset licenseStatus = "VALID">
            <cfelse>
                <!--- License expired --->
                <cfset isProEdition = false>
                <cfset licenseStatus = "EXPIRED">
            </cfif>
        </cfif>
    <cfelse>
        <!--- UUID mismatch - license violation --->
        <cfset isProEdition = false>
        <cfset licenseStatus = "VIOLATION">
    </cfif>

<cfelse>
    <!--- No UUID2 file - Community edition --->
    <cfset isProEdition = false>
    <cfset licenseStatus = "N/A">
</cfif>
