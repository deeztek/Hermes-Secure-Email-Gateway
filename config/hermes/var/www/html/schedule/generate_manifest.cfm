<!---
Hermes SEG - Generate Template Manifest (Lucee endpoint)

Computes the manifest JSON using the SAME javaSHA256() function that
manifest_verify.cfm uses at validation time. Returns JSON that can be
uploaded directly to the license server.

This endpoint runs on the SAME Lucee instance that will later compute
the fingerprint for validation — guaranteeing a match.

Usage:
  curl "http://localhost:8888/schedule/generate_manifest.cfm?version=260119"

Protected by isRetentionEnabled() — Pro Edition only.
--->
<cfsetting enablecfoutputonly="yes" showdebugoutput="no">

<!--- Include retention policy functions for Pro gate --->
<cfinclude template="retention_policy_functions.cfm">

<cfif NOT isRetentionEnabled()>
    <cfcontent type="application/json" reset="yes">
    <cfoutput>{"error":"Pro Edition required"}</cfoutput>
    <cfabort>
</cfif>

<cfparam name="url.version" default="">
<cfif Len(Trim(url.version)) EQ 0>
    <cfcontent type="application/json" reset="yes">
    <cfoutput>{"error":"Missing version parameter. Usage: ?version=260119"}</cfoutput>
    <cfabort>
</cfif>

<!--- Include manifest_verify.cfm which has javaSHA256() and computeTemplateHashes() --->
<cfinclude template="../admin/2/inc/manifest_verify.cfm">

<!--- Compute hashes using the same code path as validation --->
<cfset hashes = computeTemplateHashes()>
<cfset fingerprint = computeTemplateFingerprint(hashes)>

<!--- Build manifest JSON --->
<cfset manifest = {
    "version" = Trim(url.version),
    "generated" = DateFormat(Now(), "yyyy-mm-dd") & "T" & TimeFormat(Now(), "HH:mm:ss") & "Z",
    "algorithm" = "SHA-256",
    "templates" = hashes,
    "fingerprint" = fingerprint
}>

<cfcontent type="application/json" reset="yes">
<cfoutput>#SerializeJSON(manifest)#</cfoutput>
