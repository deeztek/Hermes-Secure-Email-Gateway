<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
DELETE ONE ORG SIGNATURE'S ON-DISK FILES (#226 Phase 2B).

Wipes /etc/hermes/body_milter/signatures/files/org_<id>/. Caller MUST
set:

    orgSignatureDeleteRowId = <id of org_signatures row that was just deleted>

Idempotent: no error if the dir doesn't exist (e.g. row was disabled
before delete or DEV deploy is fresh). signature_regen_map.cfm runs
after this to rebuild the map without any reference to the option.
--->

<cfif NOT isDefined("orgSignatureDeleteRowId") OR NOT IsNumeric(orgSignatureDeleteRowId)>
    <cfthrow message="org_signature_delete_files: caller must set orgSignatureDeleteRowId">
</cfif>

<cfset orgSigDelDir = "/etc/hermes/body_milter/signatures/files/org_" & Val(orgSignatureDeleteRowId)>

<cfif DirectoryExists(orgSigDelDir)>
    <cfdirectory action="delete" directory="#orgSigDelDir#" recurse="yes" />
</cfif>

<cfset StructDelete(variables, "orgSignatureDeleteRowId", false)>
