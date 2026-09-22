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
  directory_sync.cfm (#332)

  Enumerates relay recipients from the directory a connection points at and
  STAGES what it finds. Called by Ofelia via the single 'hermes-directory-sync'
  job; every enabled connection is drained in one pass, because the legacy AD
  sync's cron-file-per-connection model does not survive the move to Docker.

  THIS FILE NEVER WRITES TO `recipients`. It writes only to
  directory_import_staging and to the last_run_* columns on
  directory_connections. Creating a recipient is an expensive, side-effecting
  operation (LDAP entry, maddr row, two cert queue jobs) and an admin approves
  it from the review screen. Enumerating and applying are deliberately separate.

  Four rules this file exists to honour:

  1. A FAILED OR EMPTY ENUMERATION STAGES NOTHING. If the bind fails, the
     filter matches nothing, or the server is unreachable, the connection is
     marked failed and the previous staged run is left untouched. An empty
     result is treated as a failure, not as "the directory is now empty",
     because the second reading is how a transient outage turns into a report
     saying every user has vanished.

  2. NOTHING IS EVER DELETED. A recipient that is gone upstream is staged as
     'vanished' and reported, never removed. A relay domain set to ANY still
     delivers their mail, so an over-eager sync cannot bounce anything, but it
     could strip portal access and encryption from live users. Reporting is
     enough.

  3. ADDRESSES OUTSIDE THE CONNECTION'S DOMAIN ARE DISCARDED. One AD commonly
     holds several mail domains. A connection populates exactly one relay
     domain, so anything else that comes back is dropped rather than filed
     under the wrong domain.

  4. THE BIND PASSWORD NEVER REACHES THE FILESYSTEM. It is decrypted into a
     local variable here and nowhere else. The legacy AD sync substituted it
     into a generated .cfm under the web root; that is the specific mistake
     this design exists to avoid.

  The query runs as ldapsearch inside hermes_ldap rather than as cfldap here.
  cfldap would validate LDAPS against the JVM truststore, which nothing in
  Hermes populates, so a directory with a private CA would fail even though the
  administrator had uploaded its certificate for RemoteAuth. Going through
  hermes_ldap means one trust store for both login and enumeration, and it
  brings real paging with it, so Active Directory's MaxPageSize no longer
  truncates large directories silently.
--->

<cfsetting requesttimeout="1800">
<cfparam name="url.debug" default="0">
<cfparam name="url.connection_id" default="0">

<cfscript>
// Short random id for temp file names. No DB round trip, and distinct per
// connection so two runs cannot collide on the shared /opt/hermes/tmp mount.
function dsTempId() {
    var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    var out = "";
    for (var i = 1; i <= 10; i++) {
        out &= Mid(chars, RandRange(1, Len(chars), "SHA1PRNG"), 1);
    }
    return out;
}

// Make a value safe to sit inside single quotes in the generated script.
// A bind DN of CN=O'Brien,OU=Users is ordinary, and every value below this
// point is admin-supplied, so without this the apostrophe both breaks the
// command and opens a shell injection through a console form field.
function shq(required string v) {
    return Replace(arguments.v, "'", "'\''", "all");
}
</cfscript>

<cfset runStarted = Now()>
<cfset summary = []>

<!--- Auto-apply budget for this run, shared across every connection.
      Creating a recipient costs roughly fourteen seconds (LDAP entry,
      user_settings row, CipherMail entry), so an uncapped first sync of a few
      hundred users would run for the better part of an hour inside one
      request. 25 is about six minutes and drains across successive runs, the
      same shape as process_cert_queue.cfm's batch of 5. Raise the job
      frequency in Scheduled Tasks to drain a large backfill faster. --->
<cfset autoApplyBudget = 25>

<!--- The shared key every Hermes credential at rest is encrypted under. If it
      is unreadable there is nothing useful to do, so fail loudly and stop
      rather than silently skipping every connection. --->
<cftry>
  <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermesKey" charset="utf-8">
  <cfcatch>
    <cfoutput>FATAL: cannot read /opt/hermes/keys/hermes.key -- #cfcatch.message#</cfoutput>
    <cfabort>
  </cfcatch>
</cftry>

<!--- One connection when invoked from the review screen's "Sync Now", every
      enabled connection when Ofelia calls it. --->
<cfquery name="getConnections" datasource="hermes">
  SELECT c.*
    FROM directory_connections c
   WHERE c.enabled = 1
     AND c.provider = 'ldap'
   <cfif val(url.connection_id) GT 0>
     AND c.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.connection_id)#">
   </cfif>
   ORDER BY c.entry_name
</cfquery>

<cfif getConnections.recordcount LT 1>
  <cfoutput>No enabled LDAP directory connections.</cfoutput>
  <cfabort>
</cfif>

<cfloop query="getConnections">

  <cfset connId      = getConnections.id>
  <cfset connName    = getConnections.entry_name>
  <!--- Every relay domain, not one chosen at setup. add_internal_recipients
        already rejects an address whose domain is not here, so scoping to a
        single domain only forced one directory per domain for an AD that
        serves several. --->
  <cfquery name="getRelayDomains" datasource="hermes">
    SELECT LOWER(domain) AS domain FROM domains WHERE domain IS NOT NULL AND domain <> ''
  </cfquery>
  <cfset relayDomains = {}>
  <cfloop query="getRelayDomains"><cfset relayDomains[getRelayDomains.domain] = true></cfloop>
  <cfset runId       = LCase(Replace(CreateUUID(), "-", "", "all"))>
  <cfset runId       = Left(runId, 32)>
  <cfset failMessage = "">
  <cfset foundRows   = []>

  <!--- The connection's own server, always. It used to inherit from the linked
        RemoteAuth mapping, which was wrong: the mapping says where recipients
        authenticate, not where the user list is read from. Those are commonly
        the same host and sometimes not, the clearest case being a tenant
        enumerated from Google while authenticating against on-prem AD. --->
  <cfset ldapServer = Trim(getConnections.server_address)>
  <cfset ldapPort   = val(getConnections.server_port)>
  <cfif ldapPort LTE 0><cfset ldapPort = 636></cfif>

  <cfset bindDN = Trim(getConnections.bind_dn)>
  <cfset bindPW = "">
  <cfif Len(Trim(getConnections.bind_password))>
    <cftry>
      <cfset bindPW = decrypt(Trim(getConnections.bind_password), hermesKey, "AES", "Base64")>
      <cfcatch><cfset bindPW = ""></cfcatch>
    </cftry>
  </cfif>

  <!--- (&(objectClass=X)(mail=*)) plus whatever the admin added. The mail
        presence term is not optional: without it every computer, contact and
        service object in the tree comes back. --->
  <cfset mailAttr = Trim(getConnections.mail_attribute)>
  <cfif NOT Len(mailAttr)><cfset mailAttr = "mail"></cfif>
  <cfset theFilter = "(&(objectClass=" & Trim(getConnections.object_class) & ")(" & mailAttr & "=*)">
  <cfif Len(Trim(getConnections.extra_filter))>
    <cfset theFilter = theFilter & Trim(getConnections.extra_filter)>
  </cfif>
  <cfset theFilter = theFilter & ")">

  <!--- The query runs as ldapsearch inside hermes_ldap, not as cfldap here.

       Three reasons, all of which cfldap loses:

       1. TRUST. cfldap runs on the JVM and validates LDAPS against the JVM
          truststore, which nothing in Hermes populates. ldapsearch in
          hermes_ldap uses the same CA bundle slapd does, so the certificate an
          admin uploaded for RemoteAuth covers enumeration too. One trust store,
          not two.
       2. PAGING. Active Directory caps a single search at MaxPageSize, 1000 by
          default, and silently truncates. -E pr=1000/noprompt pages properly.
       3. Shelling out to ldapsearch via docker exec is already the pattern
          here; see inc/ldap_get_user_groups.cfm.

       The bind password goes to a file read with -y, never into an argument,
       so it cannot be read out of the host process list. -LLL drops comments
       and the version header, -o ldif-wrap=no stops LDIF folding long values
       across continuation lines. --->
  <cfset tmpId    = dsTempId()>
  <cfset pwPath   = "/opt/hermes/tmp/#tmpId#_dirsync.pw">
  <cfset shPath   = "/opt/hermes/tmp/#tmpId#_dirsync.sh">
  <cfset outPath  = "/opt/hermes/tmp/#tmpId#_dirsync.out">
  <cfset errPath  = "/opt/hermes/tmp/#tmpId#_dirsync.err">
  <cfset rawLdif  = "">
  <cfset rawErr   = "">

  <cftry>

    <cfif NOT Len(ldapServer) OR NOT Len(Trim(getConnections.base_dn))>
      <cfthrow message="Connection is missing a server address or base DN">
    </cfif>

    <cfset ldapUri = (getConnections.tls_mode IS "ldaps" ? "ldaps" : "ldap") & "://" & ldapServer & ":" & ldapPort>

    <!--- Mirror the RemoteAuth trust settings so enumeration and login agree
         about which directories are acceptable. --->
    <cfquery name="getRaTls" datasource="hermes">
      SELECT setting_name, setting_value FROM remoteauth_settings
       WHERE setting_name IN ('tls_reqcert', 'ca_cert_file', 'client_cert_file', 'client_key_file')
    </cfquery>
    <cfset raTls = {}>
    <cfloop query="getRaTls"><cfset raTls[getRaTls.setting_name] = getRaTls.setting_value></cfloop>
    <!--- LDAPS means verified, same rule the RemoteAuth sync applies. It cannot
         be read from remoteauth_settings: that sync derives "demand" in memory
         and leaves the stored value alone, so reading the row here would pick
         up a stale "never" and encrypt to a server it never authenticated. --->
    <cfset reqCert = "never">
    <cfif getConnections.tls_mode IS "ldaps">
      <cfset reqCert = "demand">
    <cfelseif StructKeyExists(raTls,"tls_reqcert") AND Len(raTls.tls_reqcert)>
      <cfset reqCert = raTls.tls_reqcert>
    </cfif>
    <cfset envOpts = "-e LDAPTLS_REQCERT=" & shq(reqCert)>
    <cfif StructKeyExists(raTls,"ca_cert_file") AND Len(raTls.ca_cert_file)>
      <cfset envOpts = envOpts & " -e LDAPTLS_CACERT='/opt/hermes/certs/remoteauth/" & shq(raTls.ca_cert_file) & "'">
    </cfif>

    <!--- Mutual TLS, sharing the client certificate uploaded for RemoteAuth
         (#335). This is what lets provider='ldap' enumerate Google Secure
         LDAP: ldap.google.com is an ordinary LDAPS endpoint that simply
         insists the client prove who it is. Without these two the connection
         is refused during the handshake and no REST connector would help,
         because the obstacle was never the protocol.

         Both or neither, as with the overlay: a certificate with no key
         cannot be used. --->
    <cfif StructKeyExists(raTls,"client_cert_file") AND Len(raTls.client_cert_file)
      AND StructKeyExists(raTls,"client_key_file")  AND Len(raTls.client_key_file)>
      <cfset envOpts = envOpts & " -e LDAPTLS_CERT='/opt/hermes/certs/remoteauth/" & shq(raTls.client_cert_file) & "'">
      <cfset envOpts = envOpts & " -e LDAPTLS_KEY='/opt/hermes/certs/remoteauth/"  & shq(raTls.client_key_file)  & "'">
    </cfif>

    <!--- addNewLine="no" is load-bearing. ldapsearch -y uses the COMPLETE
         contents of the file as the password, trailing newline included, and
         cffile appends one by default. Without this the bind fails as AD
         data 52e, which reads as a wrong password rather than a stray byte. --->
    <cffile action="write" file="#pwPath#" output="#bindPW#" charset="utf-8" mode="600" addNewLine="no">

    <cfsavecontent variable="shBody"><cfoutput>##!/bin/bash
/usr/local/bin/docker exec #envOpts# hermes_ldap ldapsearch -LLL -o ldif-wrap=no -x \
  -H '#shq(ldapUri)#' \
  -D '#shq(bindDN)#' \
  -y '#pwPath#' \
  -b '#shq(Trim(getConnections.base_dn))#' \
  -s sub \
  -E pr=1000/noprompt \
  '#shq(theFilter)#' \
  dn '#shq(mailAttr)#' givenName sn displayName \
  > '#outPath#' 2> '#errPath#'
exit $?
</cfoutput></cfsavecontent>

    <cffile action="write" file="#shPath#" output="#shBody#" charset="utf-8" mode="700">

    <cfexecute name="/bin/bash" arguments="#shPath#" timeout="300" variable="shOut" errorVariable="shErr"></cfexecute>

    <cfif FileExists(outPath)><cffile action="read" file="#outPath#" variable="rawLdif" charset="utf-8"></cfif>
    <cfif FileExists(errPath)><cffile action="read" file="#errPath#" variable="rawErr" charset="utf-8"></cfif>

    <!--- stderr is never treated as data. inc/rbl_test_entry.cfm learned this
         the expensive way: an unseparated stderr got folded into the output
         variable and an error string passed the emptiness test. ldapsearch
         writes progress notes to stderr on success, so only text that names a
         failure counts. --->
    <cfif Len(Trim(rawErr))
          AND (FindNoCase("ldap_bind", rawErr) GT 0
            OR FindNoCase("Can't contact", rawErr) GT 0
            OR FindNoCase("Invalid credentials", rawErr) GT 0
            OR FindNoCase("error", rawErr) GT 0)>
      <cfset failMessage = "ldapsearch failed: " & Left(Trim(rawErr), 400)>
    </cfif>

    <cfcatch>
      <cfset failMessage = "LDAP query failed: " & cfcatch.message>
    </cfcatch>
  </cftry>

  <!--- The password file goes first and unconditionally. --->
  <cfloop list="#pwPath#,#shPath#,#outPath#,#errPath#" index="junk">
    <cftry><cfif FileExists(junk)><cffile action="delete" file="#junk#"></cfif><cfcatch></cfcatch></cftry>
  </cfloop>

  <!--- Rule 1. Anything other than a successful, non-empty result stops here
        and leaves the previous staged run alone. --->
  <cfif Len(failMessage) OR NOT Len(Trim(rawLdif))>
    <cfif NOT Len(failMessage)>
      <cfset failMessage = "Directory returned no entries for filter " & theFilter & ". Previous results left unchanged.">
    </cfif>
    <cfquery datasource="hermes">
      UPDATE directory_connections
         SET last_run_at      = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
             last_run_status  = 'failed',
             last_run_message = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#failMessage#">
       WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
    </cfquery>
    <cfset ArrayAppend(summary, connName & ": FAILED -- " & failMessage)>
    <cfcontinue>
  </cfif>

  <!--- Parse the LDIF into records.

        -o ldif-wrap=no means one attribute per line, so no continuation
        unfolding is needed. A blank line ends a record. ldapsearch base64
        encodes any value that is not safe as plain UTF-8, signalled by a
        double colon, which is how a name with an accent or a leading space
        arrives; those are decoded rather than stored mangled.

        A multi-valued attribute such as proxyAddresses appears as repeated
        lines, and each value carries an "smtp:" or "SMTP:" prefix, so both
        shapes are handled rather than assuming one bare address in `mail`. --->
  <cfset seen    = {}>
  <cfset records = []>
  <cfset curRec  = {}>

  <!--- ListToArray with includeEmptyFields, NOT cfloop list. A CFML list
        collapses consecutive delimiters, so a list loop never yields the blank
        line between LDIF records and every entry merges into one: the first
        user's givenName and sn end up attached to every address in the tree,
        and dn becomes every DN concatenated. --->
  <cfset ldifLines = ListToArray(rawLdif, Chr(10), true)>

  <cfloop array="#ldifLines#" index="ldifLine">
    <cfset ldifLine = Replace(ldifLine, Chr(13), "", "all")>

    <cfif NOT Len(Trim(ldifLine))>
      <cfif NOT StructIsEmpty(curRec)><cfset ArrayAppend(records, curRec)></cfif>
      <cfset curRec = {}>
      <cfcontinue>
    </cfif>
    <cfif Left(ldifLine, 1) IS "##"><cfcontinue></cfif>

    <cfset colonAt = Find(":", ldifLine)>
    <cfif colonAt LTE 1><cfcontinue></cfif>

    <cfset attrName = LCase(Left(ldifLine, colonAt - 1))>
    <cfset attrVal  = Mid(ldifLine, colonAt + 1, Len(ldifLine))>

    <cfif Left(attrVal, 1) IS ":">
      <cftry>
        <cfset attrVal = ToString(ToBinary(Trim(Mid(attrVal, 2, Len(attrVal)))), "utf-8")>
        <cfcatch><cfset attrVal = ""></cfcatch>
      </cftry>
    <cfelse>
      <cfset attrVal = Trim(attrVal)>
    </cfif>

    <cfif Len(attrVal)>
      <cfif StructKeyExists(curRec, attrName)>
        <cfset curRec[attrName] = curRec[attrName] & Chr(9) & attrVal>
      <cfelse>
        <cfset curRec[attrName] = attrVal>
      </cfif>
    </cfif>
  </cfloop>
  <cfif NOT StructIsEmpty(curRec)><cfset ArrayAppend(records, curRec)></cfif>

  <cfset mailKey = LCase(mailAttr)>

  <cfloop array="#records#" index="rec">
    <cfset recDn      = StructKeyExists(rec, "dn")          ? ListFirst(rec.dn, Chr(9))          : "">
    <cfset recFirst   = StructKeyExists(rec, "givenname")   ? ListFirst(rec.givenname, Chr(9))   : "">
    <cfset recLast    = StructKeyExists(rec, "sn")          ? ListFirst(rec.sn, Chr(9))          : "">
    <cfset recDisplay = StructKeyExists(rec, "displayname") ? ListFirst(rec.displayname, Chr(9)) : "">
    <cfset recMail    = StructKeyExists(rec, mailKey)       ? rec[mailKey]    : "">

    <cfloop list="#recMail#" index="oneAddr" delimiters="#Chr(9)#">
      <cfset addr = LCase(Trim(oneAddr))>
      <cfif addr CONTAINS ":">
        <cfset addr = LCase(Trim(ListLast(addr, ":")))>
      </cfif>

      <!--- Rule 3. One connection populates exactly one relay domain. --->
      <cfif Len(addr) AND addr CONTAINS "@" AND StructKeyExists(relayDomains, LCase(ListLast(addr, "@")))
            AND NOT StructKeyExists(seen, addr)>
        <cfset seen[addr] = true>
        <cfset ArrayAppend(foundRows, {
          email   = addr,
          dn      = recDn,
          first   = recFirst,
          last    = recLast,
          display = recDisplay
        })>
      </cfif>
    </cfloop>
  </cfloop>

  <cfif ArrayLen(foundRows) LT 1>
    <!--- Zero records is a filter that matched nothing, not entries that
         failed the domain test. Saying "returned 0 entries but none carried
         an address" reads as a contradiction and sends the admin looking at
         their relay domains instead of their filter. --->
    <cfif ArrayLen(records) EQ 0>
      <cfset failMessage = "No entries matched the filter " & theFilter & " under " & Trim(getConnections.base_dn) & ". Previous results left unchanged.">
    <cfelse>
      <cfset failMessage = "Directory returned " & ArrayLen(records) & " entries, but none carried an address in a relay domain. Check the Mail Attribute, or whether these users belong in Hermes at all. Previous results left unchanged.">
    </cfif>
    <cfquery datasource="hermes">
      UPDATE directory_connections
         SET last_run_at      = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
             last_run_status  = 'failed',
             last_run_message = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#failMessage#">
       WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
    </cfquery>
    <cfset ArrayAppend(summary, connName & ": FAILED -- " & failMessage)>
    <cfcontinue>
  </cfif>

  <!--- The enumeration succeeded, so this run supersedes the last one. Rows an
        admin already applied or skipped are history and stay; only untouched
        pending rows are cleared. --->
  <cfquery datasource="hermes">
    DELETE FROM directory_import_staging
     WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
       AND status = 'pending'
  </cfquery>

  <!--- Failed rows are retry noise, not history: the address is about to be
        staged again, so the old failure would sit beside the new attempt and
        the review list grows a duplicate per retry. 'applied' and 'skipped'
        survive, because those record decisions rather than attempts. --->
  <cfquery datasource="hermes">
    DELETE FROM directory_import_staging
     WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
       AND status = 'failed'
  </cfquery>

  <cfquery name="getExisting" datasource="hermes">
    SELECT LOWER(recipient) AS recipient FROM recipients
     WHERE recipient NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="@%">
  </cfquery>
  <cfset existingMap = {}>
  <cfloop query="getExisting"><cfset existingMap[getExisting.recipient] = true></cfloop>

  <!--- Vanished is scoped to what THIS directory actually imported, not to
        everything in a domain. A recipient another directory or an admin
        created can no longer be implicated by this one's search coming back
        short. --->
  <cfquery name="getMine" datasource="hermes">
    SELECT DISTINCT LOWER(email) AS email
      FROM directory_import_staging
     WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
       AND status = 'applied'
  </cfquery>

  <cfset nInsert = 0>
  <cfset nExisting = 0>

  <cfloop array="#foundRows#" index="row">
    <cfset theAction = StructKeyExists(existingMap, row.email) ? "existing" : "insert">
    <cfif theAction IS "insert"><cfset nInsert++><cfelse><cfset nExisting++></cfif>

    <cfquery datasource="hermes">
      INSERT INTO directory_import_staging
        (connection_id, run_id, email, display_name, first_name, last_name, source_dn, action, status)
      VALUES (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#runId#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(row.email, 255)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(row.display, 255)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(row.first, 128)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(row.last, 128)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(row.dn, 500)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#theAction#">,
        'pending'
      )
    </cfquery>
  </cfloop>

  <!--- Rule 2. Recipients this connection is responsible for (auth_type
        'remote', so hand-added local recipients are never implicated) that did
        not come back are reported and left in place. --->
  <cfset nVanished = 0>
  <cfloop query="getMine">
    <cfif NOT StructKeyExists(seen, getMine.email) AND StructKeyExists(existingMap, getMine.email)>
      <cfset nVanished++>
      <cfquery datasource="hermes">
        INSERT INTO directory_import_staging
          (connection_id, run_id, email, action, status)
        VALUES (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#runId#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(getMine.email, 255)#">,
          'vanished',
          'pending'
        )
      </cfquery>
    </cfif>
  </cfloop>

  <cfset okMessage = "#ArrayLen(foundRows)# address(es) read. #nInsert# new, #nExisting# already present, #nVanished# no longer in the directory.">
  <cfquery datasource="hermes">
    UPDATE directory_connections
       SET last_run_at       = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
           last_run_status   = 'ok',
           last_run_message  = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#okMessage#">,
           last_found_count  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ArrayLen(foundRows)#">
     WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
  </cfquery>

  <cfset ArrayAppend(summary, connName & ": OK -- " & okMessage)>

  <!--- AUTO-APPLY. Only 'insert' rows, only when the connection is set to it,
        and only within this run's budget. 'vanished' is never auto-applied at
        any setting: a recipient gone upstream keeps receiving mail through the
        domain's ANY wildcard, and removing them would strip portal access and
        encryption from a live user.

        This includes the same file the review screen includes, so a scheduled
        provision and a hand-approved one take an identical path. Including an
        admin/2/inc helper headlessly from schedule/ is the established pattern
        (see regen_ofelia_config.cfm and acme_validate_ip.cfm). --->
  <cfif val(getConnections.auto_apply) EQ 1 AND autoApplyBudget GT 0>
    <cfquery name="getAutoRows" datasource="hermes">
      SELECT id FROM directory_import_staging
       WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#connId#">
         AND status = 'pending'
         AND action = 'insert'
       ORDER BY email
       LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#autoApplyBudget#">
    </cfquery>

    <cfif getAutoRows.recordcount GTE 1>
      <cfset applyConnId = connId>
      <cfset applyIds    = ValueList(getAutoRows.id)>
      <cfset applyOk     = 0>
      <cfinclude template="../admin/2/inc/directory_import_apply.cfm">

      <!--- Report what the include actually did, not what it was asked to do.
            It exits early on several refusals (edition, missing mapping, rows
            no longer pending) and the previous version credited the full batch
            regardless, so a refused run still read as "auto-applied 2" and
            still spent the budget. applyOk is the verified count: the include
            checks each address against `recipients` before claiming it. --->
      <cfset autoApplyBudget = autoApplyBudget - val(applyOk)>
      <cfif val(applyOk) GT 0>
        <cfset ArrayAppend(summary, connName & ": auto-applied " & val(applyOk)
                                  & " recipient(s), " & autoApplyBudget & " left in this run's budget.")>
      <cfelse>
        <cfset ArrayAppend(summary, connName & ": " & getAutoRows.recordcount
                                  & " row(s) were ready to provision but none were created. See the notice above.")>
      </cfif>
    </cfif>
  </cfif>

</cfloop>

<cfoutput>
directory_sync #DateFormat(runStarted, "yyyy-mm-dd")# #TimeFormat(runStarted, "HH:mm:ss")#<br>
<cfloop array="#summary#" index="line">#EncodeForHTML(line)#<br></cfloop>
Done in #DateDiff("s", runStarted, Now())#s.
</cfoutput>
