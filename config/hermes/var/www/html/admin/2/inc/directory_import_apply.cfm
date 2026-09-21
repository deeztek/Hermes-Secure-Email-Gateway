<!---
  directory_import_apply.cfm (#332)

  Creates recipients from staged directory rows. Included INLINE by
  view_directory_import.cfm, inside the page body, because the work is slow
  and visible: add_internal_recipients_manual.cfm takes roughly fourteen
  seconds per recipient (LDAP entry, user_settings row, CipherMail entry) and
  the admin needs to watch it finish rather than stare at a redirect.

  NOTHING IS REIMPLEMENTED HERE. This builds the same variables the Add Relay
  Recipients screen builds and then includes the same file it includes. That is
  deliberate: a parallel INSERT would drift from the real path and produce rows
  that look right in the console but fail at portal login, which is the one
  outcome this feature exists to prevent.

  ENCRYPTION IS OFF. S/MIME and PGP stay disabled ('2') on import. Turning them
  on is a separate, already-built action: select rows on the Relay Recipients
  page and bulk edit, which enqueues into cert_generation_queue and is drained
  by process_cert_queue.cfm. Coupling encryption to enumeration would mean every
  later sync had to decide whether to re-enable it for someone who turned it off.

  Expects: applyConnId (numeric), applyIds (list of directory_import_staging ids)
--->

<cfparam name="applyConnId" default="0">
<cfparam name="applyIds"    default="">

<cfset applyOk     = 0>
<cfset applySkipped = 0>
<cfset applyErrors = []>

<cfquery name="getConn" datasource="hermes">
  SELECT c.id, c.entry_name, c.remoteauth_mapping_id,
         c.auth_type, c.policy_id, c.report_enabled, c.train_bayes,
         c.download_msg, c.enforce_mfa, c.send_welcome,
         m.domain_name AS mapping_domain, m.remote_dn_pattern
    FROM directory_connections c
    LEFT JOIN remoteauth_mappings m ON m.id = c.remoteauth_mapping_id
   WHERE c.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(applyConnId)#">
</cfquery>

<cfif getConn.recordcount LT 1>
  <div class="alert alert-danger"><i class="fas fa-ban"></i>&nbsp;That directory no longer exists.</div>
  <cfexit>
</cfif>

<!--- Only remote auth needs a mapping: recipients.remoteauth_domain is how it
      is recorded, and without one the users could not sign in. Local auth has
      no such dependency, so a Google or M365 connection provisioning local
      accounts imports fine with no mapping at all.

      auth_type is deliberately independent of provider. The directory Hermes
      reads is not necessarily the one it authenticates against: a tenant
      synced from on-prem AD is commonly enumerated from Google or M365 and
      authenticated against that AD over ordinary LDAP. --->
<!--- A connection saved under Pro can outlive the licence. Creating users
     against an overlay the edition no longer supports would leave them unable
     to sign in, so the import stops rather than half-provisioning.

     session.edition only exists in a browser request. Ofelia calls the sync
     page with curl and no cookie, so nothing populates it and a session-only
     check would refuse EVERY unattended remote import. The headless path
     therefore falls back to the cached licence state, which is the same source
     message_cleanup.cfm uses to decide whether to tear Pro features down. --->
<cfset dcIsPro = false>
<cfif isDefined("session.edition")>
    <cfset dcIsPro = (session.edition EQ "Pro")>
<cfelse>
    <!--- Mirror setsession.cfm's own precedence. The SERIAL is checked first:
         an empty serial is Community outright, with no validation attempted.
         Only then does the cached policy matter.

         Consulting the cached policy alone fails OPEN, because that cache
         outlives the serial being cleared. That is not theoretical: it let an
         unattended remote import run on a Community install during testing. --->
    <cftry>
        <cfquery name="dcSerial" datasource="hermes">
            SELECT value FROM system_settings WHERE parameter = 'serial'
        </cfquery>
        <cfif dcSerial.recordcount GTE 1 AND Len(Trim(dcSerial.value))>
            <cfinclude template="/schedule/retention_policy_functions.cfm">
            <cfset dcIsPro = isRetentionEnabled()>
        </cfif>
        <cfcatch><cfset dcIsPro = false></cfcatch>
    </cftry>
</cfif>

<cfif getConn.auth_type IS "remote" AND NOT dcIsPro>
  <cfoutput>
  <div class="alert alert-warning">
    <i class="fas fa-triangle-exclamation"></i>&nbsp;
    <strong>#EncodeForHTML(getConn.entry_name)#</strong> uses Remote authentication, which requires Pro.
    Switch it to Local, or restore the licence, then import.
  </div>
  </cfoutput>
  <cfexit>
</cfif>

<cfif getConn.auth_type IS "remote" AND NOT Len(Trim(getConn.mapping_domain))>
  <cfoutput>
  <div class="alert alert-warning">
    <i class="fas fa-triangle-exclamation"></i>&nbsp;
    <strong>#EncodeForHTML(getConn.entry_name)#</strong> is set to Remote authentication
    but is not linked to a RemoteAuth mapping, so imported recipients would have no way
    to sign in. Edit the directory and either choose a mapping, or switch it to Local.
  </div>
  </cfoutput>
  <cfexit>
</cfif>

<cfif NOT Len(Trim(applyIds))>
  <div class="alert alert-warning"><i class="fas fa-triangle-exclamation"></i>&nbsp;Nothing was selected.</div>
  <cfexit>
</cfif>

<!--- Only rows that are still pending 'insert' for this connection. Anything
      else in the submitted list is ignored rather than trusted. --->
<cfquery name="getRows" datasource="hermes">
  SELECT id, email, first_name, last_name, display_name, source_dn
    FROM directory_import_staging
   WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(applyConnId)#">
     AND status = 'pending'
     AND action = 'insert'
     AND id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#applyIds#">)
   ORDER BY email
</cfquery>

<cfif getRows.recordcount LT 1>
  <div class="alert alert-warning"><i class="fas fa-triangle-exclamation"></i>&nbsp;None of the selected rows are still pending.</div>
  <cfexit>
</cfif>

<!--- The DN pattern decides the payload format. add_internal_recipients_manual
      switches to CSV parsing when the pattern needs a first or last name, so
      the same test is made here to hand it the shape it expects. --->
<cfset needsCsv = false>
<cfif getConn.auth_type IS "remote" AND Len(Trim(getConn.remote_dn_pattern))>
  <cfset needsCsv = (FindNoCase("{firstname}", getConn.remote_dn_pattern) GT 0
                  OR FindNoCase("{lastname}",  getConn.remote_dn_pattern) GT 0)>
</cfif>

<!--- Real DNs, keyed by address, for ldap_add_user_remoteauth.cfm. Skips the
     remote_dn_pattern entirely, so a directory whose account name differs from
     the email local part still resolves. --->
<cfset dirSourceDnByEmail = {}>
<cfset payloadLines = []>
<cfset appliedIds   = []>
<cfloop query="getRows">
  <cfif needsCsv>
    <!--- Positional First,Last,Email. A name the directory did not carry is
          sent as a blank field rather than omitted, so the columns still line
          up for the positional parser. --->
    <cfset ArrayAppend(payloadLines, Trim(getRows.first_name) & "," & Trim(getRows.last_name) & "," & Trim(getRows.email))>
  <cfelse>
    <cfset ArrayAppend(payloadLines, Trim(getRows.email))>
  </cfif>
  <cfif Len(Trim(getRows.source_dn))>
    <cfset dirSourceDnByEmail[LCase(Trim(getRows.email))] = Trim(getRows.source_dn)>
  </cfif>
  <cfset ArrayAppend(appliedIds, getRows.id)>
</cfloop>

<cfquery name="getPolicy" datasource="hermes">
  SELECT policy_id FROM spam_policies WHERE default_policy = '1'
</cfquery>

<!--- The contract add_internal_recipients_manual.cfm reads, filled from the
      connection's provisioning defaults.

      The encryption values stay hardcoded to '2' (Disable). That is the one
      setting deliberately not offered per connection: S/MIME and PGP are
      turned on afterwards from Relay Recipients using Bulk Edit, which
      enqueues into cert_generation_queue. A connection-level default would
      mean every later sync had to decide whether to re-enable encryption for
      someone who had turned it off.

      '2' is Disable for the encryption selects and for signing; the Bayes and
      download flags use 0 and 1. val() is applied to the tinyint columns so a
      driver-side boolean can never reach an insert expecting 0 or 1. --->
<cfset show_recipient         = ArrayToList(payloadLines, Chr(10))>
<cfset show_auth_type         = (getConn.auth_type IS "remote" ? "remote" : "local")>
<cfset show_remoteauth_domain = (show_auth_type IS "remote" ? Trim(getConn.mapping_domain) : "")>
<cfset show_policy            = (val(getConn.policy_id) GT 0 ? val(getConn.policy_id)
                                 : (getPolicy.recordcount GTE 1 ? getPolicy.policy_id : 7))>
<cfset show_pdf_enabled       = "2">
<cfset show_smime_enabled     = "2">
<cfset show_pgp_enabled       = "2">
<cfset show_sign              = "2">
<cfset show_enforce_mfa       = val(getConn.enforce_mfa)>
<cfset show_reports           = (getConn.report_enabled IS "NO" ? "NO" : "YES")>
<cfset show_train_bayes       = val(getConn.train_bayes)>
<cfset show_download_msg      = val(getConn.download_msg)>
<cfset suppressWelcomeEmail   = (val(getConn.send_welcome) EQ 0)>

<!--- add_internal_recipients_djigzo.cfm reads the RAW form names, not the
     show_ ones, so both spellings have to exist. Same values: '2' is Disable. --->
<cfset pdf_enabled   = show_pdf_enabled>
<cfset smime_enabled = show_smime_enabled>
<cfset pgp_enabled   = show_pgp_enabled>

<!--- add_internal_recipients_manual.cfm increments these but never declares
     them: its normal caller, add_internal_recipients.cfm, cfparams them at
     the top of the page. Calling the include without them throws on the first
     recipient that reaches the counter, which looks like a partial import. --->
<cfparam name="step"                     default="0">
<cfparam name="errormessage"             default="0">
<cfparam name="emptyrecipients"          default="0">
<cfparam name="emptyemail"               default="0">
<cfparam name="invalidemail"             default="0">
<cfparam name="invalidemailrecipient"    default="">
<cfparam name="alreadyexists"            default="0">
<cfparam name="alreadyexistsrecipient"   default="">
<cfparam name="invaliddomain"            default="0">
<cfparam name="invaliddomainrecipient"   default="">
<cfparam name="success"                  default="0">
<cfparam name="successrecipient"         default="">
<cfparam name="djigzonotadded"           default="0">
<cfparam name="djigzonotaddedrecipient"  default="">

<cfoutput>
<div class="alert alert-info">
  <i class="fas fa-hourglass-half"></i>&nbsp;
  Creating #ArrayLen(payloadLines)# recipient(s).
  
  This takes roughly fourteen seconds each, so about
  #Ceiling((ArrayLen(payloadLines) * 14) / 60)# minute(s).
  Do not close or navigate away from this page.
</div>
</cfoutput>
<cfflush>

<cftry>
  <cfinclude template="add_internal_recipients_manual.cfm">
  <cfcatch>
    <cfset ArrayAppend(applyErrors, cfcatch.message)>
  </cfcatch>
</cftry>

<!--- Believe the recipients table, not the include's return: it swallows
      per-recipient failures by design (one bad row must not abort a batch), so
      each address is checked before its staged row is called applied. --->
<cfloop query="getRows">
  <cfquery name="verifyOne" datasource="hermes">
    SELECT id FROM recipients
     WHERE recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(getRows.email)#">
     LIMIT 1
  </cfquery>

  <cfif verifyOne.recordcount GTE 1>
    <cfset applyOk++>
    <cfquery datasource="hermes">
      UPDATE directory_import_staging
         SET status = 'applied', applied_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
       WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getRows.id#">
    </cfquery>
  <cfelse>
    <cfset applySkipped++>
    <cfquery datasource="hermes">
      UPDATE directory_import_staging
         SET status = 'failed',
             error_message = 'Recipient was not present in the recipients table after the import ran.'
       WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getRows.id#">
    </cfquery>
  </cfif>
</cfloop>

<cfoutput>
<div class="alert <cfif applySkipped GT 0>alert-warning<cfelse>alert-success</cfif>">
  <i class="fas fa-check"></i>&nbsp;
  <strong>#applyOk#</strong> recipient(s) created.
  <cfif applySkipped GT 0>
    <strong>#applySkipped#</strong> did not appear afterwards and are marked failed below.
  </cfif>
  <br><small>Encryption was not enabled. To turn on S/MIME or PGP, select the
  recipients on the Relay Recipients page and use Bulk Edit; certificates and
  keyrings are then generated in the background.</small>
</div>
<cfloop array="#applyErrors#" index="anErr">
  <div class="alert alert-danger"><i class="fas fa-ban"></i>&nbsp;#EncodeForHTML(anErr)#</div>
</cfloop>
</cfoutput>
