<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- Regenerate /etc/openarc/openarc.conf from the template at
      /opt/hermes/conf_files/openarc.conf.HERMES (single source of truth
      for the config FORMAT) + the active arc_sign row + the global ARC
      settings in system_settings.

      Mirrors the dkim_generate_config_file.cfm pattern: read template,
      REReplace placeholders, write the rendered result in place to the
      bind-mounted /etc/openarc/openarc.conf.

      OpenARC is single-identity-per-gateway. The "active" signing key is
      the FIRST enabled arc_sign row. If no key is enabled, Mode is
      forced to "v" (verify-only) and the Domain/Selector/KeyFile triple
      is replaced with a comment placeholder. --->

<cfinclude template="get_arc_settings.cfm">

<cfquery name="getarcactive" datasource="hermes">
    SELECT domain, selector, private
    FROM arc_sign
    WHERE enabled = '1'
    ORDER BY id ASC
</cfquery>

<!--- ARC true on/off via PeerList. OpenARC has no native "disabled" mode
     (Mode=v still verifies + writes A-R headers); the canonical way to
     make the daemon a true passthrough is to list every peer in PeerList,
     which makes openarc accept-and-do-nothing for every connection. --->
<cfif arc_signing_enabled IS "0">
    <!--- 0.0.0.0/0 + ::/0 covers every possible peer. OpenARC sees every
         message as "from a listed peer" -> skips signing AND verifying.
         No ARC headers added, no chain extension. True passthrough. --->
    <cfset peerlist_contents = "0.0.0.0/0" & Chr(10) & "::/0" & Chr(10)>
<cfelse>
    <!--- Empty PeerList = process all messages normally. --->
    <cfset peerlist_contents = "">
</cfif>

<cffile action="write" file="/opt/hermes/arc/PeerList" output="#peerlist_contents#" addnewline="no">

<!--- Build the signing-identity block (or its commented-out placeholder).
     Even when arc_signing_enabled=0, the openarc.conf still gets a real
     Domain/Selector/KeyFile if one is configured -- PeerList wins at
     runtime and short-circuits everything anyway. Keeping the identity
     in the file means re-enabling ARC is a single Save click (the
     PeerList rewrite is the only state that changes). --->
<cfif getarcactive.recordcount GTE 1>
    <cfset effective_mode = arc_mode>
    <cfset signing_identity = "Domain                  " & getarcactive.domain & Chr(10) &
                              "Selector                " & getarcactive.selector & Chr(10) &
                              "KeyFile                 /opt/hermes/arc/keys/" & getarcactive.private>
<cfelse>
    <!--- No active key. Force Mode=v + stub so openarc starts cleanly
         on a system with ARC enabled-but-not-yet-configured. --->
    <cfset effective_mode = "v">
    <cfset signing_identity = "## No ARC signing key configured -- Mode forced to verify-only." & Chr(10) &
                              "## Generate or import a key in the ARC Settings UI to enable signing.">
</cfif>

<!--- Read template and do all substitutions in memory. --->
<cffile action="read" file="/opt/hermes/conf_files/openarc.conf.HERMES" variable="arcconf">

<cfset arcconf = REReplace(arcconf, "THE-MODE",             effective_mode,          "ALL")>
<cfset arcconf = REReplace(arcconf, "THE-AUTHSERV-ID",      arc_authserv_id_effective, "ALL")>
<cfset arcconf = REReplace(arcconf, "THE-SIGNING-IDENTITY", signing_identity,        "ALL")>

<!--- Write directly to /etc/openarc/openarc.conf (single-file bind mount
      semantics like /etc/opendkim.conf — write in place, do not move). --->
<cffile action="write" file="/etc/openarc/openarc.conf" output="#arcconf#">
