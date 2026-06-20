<!---
Hermes SEG - License Check
Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Usage:
  <cfinclude template="./inc/license_check.cfm" />

Blocks access if license state is:
  VIOLATION          - License used on wrong machine (UUID mismatch)
  N/A                - No license present
  REVOKED            - License was revoked by server
  INVALID            - License format is invalid/tampered
  TAMPERED           - Template files have been modified (integrity check failed)
  EXPIRED            - License has expired
  PENDING_VALIDATION - Server unreachable, no baseline fingerprint established
--->

<cfif StructKeyExists(session, "license")>

    <!--- Check for template tampering first (specialized page) --->
    <cfif session.license EQ "TAMPERED">
        <cfinclude template="license_tampered.cfm">
        <cfabort>
    </cfif>

    <!--- Check for pending validation (server unreachable, no baseline fingerprint) --->
    <cfif session.license EQ "PENDING_VALIDATION">
        <cfinclude template="license_pending_validation.cfm">
        <cfabort>
    </cfif>

    <!--- Check for other invalid license states --->
    <cfif session.license EQ "VIOLATION"
       OR session.license EQ "N/A"
       OR session.license EQ "REVOKED"
       OR session.license EQ "INVALID"
       OR session.license EQ "EXPIRED">

        <cfinclude template="license_invalid.cfm">
        <cfabort>

    </cfif>

</cfif>
