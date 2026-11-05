<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE ATTACHMENT HASH BLOCKLIST (#386)

Writes attachment_hash_blocklist out as a ClamAV hash signature file and
reloads clamd. Sets request.hashBlocklistError on failure.

ClamAV refuses to load a signature directory holding a malformed file, and an
EMPTY .hsb counts as malformed. So the file is staged outside the signature
directory, checked with clamscan, and only then moved live; with no entries it
is deleted, never left empty. A failed build leaves the live file as it was.

Signature names come from the row id, so no admin text reaches the file. ClamAV
appends .UNOFFICIAL itself. A hash with no known size needs the wildcard form,
which requires functionality level 73.
--->

<cfset hbLive = "/var/lib/clamav/hermes_hash_blocklist.hsb">
<cfset hbStageDir = "/var/lib/clamav/hermes-staging">
<cfset hbStage = hbStageDir & "/hermes_hash_blocklist.hsb">
<cfset request.hashBlocklistError = "">

<cfquery name="getHashBlocklist" datasource="hermes">
    SELECT id, sha256, file_size FROM attachment_hash_blocklist ORDER BY id
</cfquery>

<cftry>
    <cfif getHashBlocklist.recordcount EQ 0>
        <cfif FileExists(hbLive)>
            <cffile action="delete" file="#hbLive#">
        </cfif>
    <cfelse>
        <cfset hbLines = []>
        <cfloop query="getHashBlocklist">
            <cfif Len(getHashBlocklist.file_size)>
                <cfset ArrayAppend(hbLines, "#getHashBlocklist.sha256#:#getHashBlocklist.file_size#:Hermes.Blocklist.#getHashBlocklist.id#")>
            <cfelse>
                <cfset ArrayAppend(hbLines, "#getHashBlocklist.sha256#:*:Hermes.Blocklist.#getHashBlocklist.id#:73")>
            </cfif>
        </cfloop>

        <cfif NOT DirectoryExists(hbStageDir)>
            <cfdirectory action="create" directory="#hbStageDir#">
        </cfif>
        <cffile action="write" file="#hbStage#" output="#ArrayToList(hbLines, Chr(10))##Chr(10)#" addnewline="no">

        <!--- Must scan a real file: clamscan skips /proc. A good database prints
             "<file>: OK"; anything else is treated as a failed check. --->
        <cfset hbOut = "">
        <cfset hbErr = "">
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_mail_filter clamscan --no-summary -d #hbStage# /etc/passwd"
            timeout="120" variable="hbOut" errorVariable="hbErr" />
        <cfif NOT FindNoCase("/etc/passwd: OK", hbOut)>
            <cfthrow message="clamscan rejected the staged blocklist: #Left(hbErr & hbOut, 300)#">
        </cfif>

        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_mail_filter chown clamav:clamav #hbStage#"
            timeout="10" variable="hbOut" errorVariable="hbErr" />
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_mail_filter mv -f #hbStage# #hbLive#"
            timeout="10" variable="hbOut" errorVariable="hbErr" />
        <cfif NOT FileExists(hbLive) OR FileExists(hbStage)>
            <cfthrow message="could not move the blocklist into place: #Left(hbErr, 300)#">
        </cfif>
    </cfif>

    <!--- Not fatal if this fails: clamd's SelfCheck picks the change up within the hour. --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter clamdscan --reload"
        timeout="60" variable="hbOut" errorVariable="hbErr" />

    <cfcatch type="any">
        <cfset request.hashBlocklistError = cfcatch.message>
        <cflog file="hermes" type="error" text="generate_attachment_hash_blocklist: #cfcatch.message#">
    </cfcatch>
</cftry>
