<!---
  directory_connection_actions.cfm (#332)

  Add / edit / delete / enable / disable for directory_connections, plus the
  "test" probe. Included by view_directory_connections.cfm before any output.

  Every branch that sets session.m ends in a cflocation. Without the redirect
  the alert never fires, because the page reads session.m on the NEXT request.

  The bind password is encrypted with the shared key at /opt/hermes/keys/hermes.key
  and stored in the column. It is never written to a file, and never rendered
  back into the edit form; an admin who wants to change it types a new one, and
  leaving the field blank on edit keeps the stored value.
--->

<cfparam name="form.action" default="">

<cfif form.action IS NOT "">

  <!--- Shared key, needed by add/edit/test. --->
  <cfset hermesKey = "">
  <cftry>
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermesKey" charset="utf-8">
    <cfcatch>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "Cannot read the Hermes encryption key. Directory credentials cannot be stored.">
      <cflocation url="view_directory_connections.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <!--- ================================================================
       ADD / EDIT
       ================================================================ --->
  <cfif form.action IS "add" OR form.action IS "edit">

    <cfparam name="form.entry_name"            default="">
    <cfparam name="form.remoteauth_mapping_id" default="0">
    <cfparam name="form.server_address"        default="">
    <cfparam name="form.server_port"           default="389">
    <cfparam name="form.tls_mode"              default="ldaps">
    <cfparam name="form.base_dn"               default="">
    <cfparam name="form.bind_dn"               default="">
    <cfparam name="form.bind_password"         default="">
    <cfparam name="form.object_class"          default="user">
    <cfparam name="form.mail_attribute"        default="mail">
    <cfparam name="form.extra_filter"          default="">
    <cfparam name="form.connection_id"         default="0">
    <!--- Provisioning defaults. auth_type is independent of provider: the
          directory we enumerate is not necessarily the one we authenticate
          against. --->
    <cfparam name="form.provider"              default="ldap">
    <cfparam name="form.auth_type"             default="local">
    <cfparam name="form.policy_id"             default="0">
    <cfparam name="form.report_enabled"        default="YES">
    <cfparam name="form.train_bayes"           default="0">
    <cfparam name="form.download_msg"          default="0">
    <cfparam name="form.enforce_mfa"           default="0">
    <cfparam name="form.send_welcome"          default="1">
    <cfparam name="form.auto_apply"            default="0">

    <!--- Whitelisted, not trusted: only 'ldap' has a working connector, and
          the other two are disabled in the form. Anything else falls back. --->
    <cfset dcProvider = (ListFindNoCase("ldap,google,graph", Trim(form.provider)) ? LCase(Trim(form.provider)) : "ldap")>
    <cfset dcTls      = (form.tls_mode IS "none" ? "none" : "ldaps")>
    <!--- Server side, because a hidden option is not a control. RemoteAuth is
          Pro, so Community cannot SELECT it.

          But a directory already set to remote keeps that value. Downgrading it
          on save would erase the only record of how those recipients
          authenticate, while their LDAP entries keep working: a lapse does not
          tear down seeAlso, so existing remote recipients still sign in. An
          admin opening the edit modal to change an unrelated field would
          silently lose the setting, and it would not come back when the licence
          did. The import gate already refuses to CREATE remote recipients
          without Pro, which is the part that actually needs preventing. --->
    <cfset dcIsProEdit = (isDefined("session.edition") AND session.edition EQ "Pro")>
    <cfset dcAuth = "local">
    <cfif form.auth_type IS "remote" AND dcIsProEdit>
      <cfset dcAuth = "remote">
    </cfif>

    <cfif form.action IS "edit" AND NOT dcIsProEdit>
      <cfquery name="dcPriorAuth" datasource="hermes">
        SELECT auth_type FROM directory_connections
         WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
      </cfquery>
      <cfif dcPriorAuth.recordcount GTE 1 AND dcPriorAuth.auth_type IS "remote">
        <cfset dcAuth = "remote">
      </cfif>
    </cfif>
    <cfset dcReport   = (form.report_enabled IS "NO" ? "NO" : "YES")>
    <cfset dcBayes    = (val(form.train_bayes)  EQ 1 ? 1 : 0)>
    <cfset dcDownload = (val(form.download_msg) EQ 1 ? 1 : 0)>
    <cfset dcMfa      = (val(form.enforce_mfa)  EQ 1 ? 1 : 0)>
    <cfset dcWelcome  = (val(form.send_welcome) EQ 1 ? 1 : 0)>
    <cfset dcAuto     = (val(form.auto_apply)   EQ 1 ? 1 : 0)>
    <cfset dcName = Trim(form.entry_name)>
    <cfset dcPort = val(form.server_port)>
    <cfif dcPort LTE 0 OR dcPort GT 65535><cfset dcPort = 636></cfif>

    <!--- A connection with no base DN enumerates the whole tree, and one with
          no domain has nowhere to file what it finds. Both are refused rather
          than defaulted. --->
    <cfif NOT Len(dcName) OR NOT Len(Trim(form.base_dn))>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "Name and base DN are both required.">
      <cflocation url="view_directory_connections.cfm" addtoken="no">
    </cfif>

    <!--- Remote auth records recipients.remoteauth_domain from the mapping, so
          there has to be one. Caught here as well as at import, because a
          connection saved in an unusable state is a worse surprise later. --->
    <cfif dcAuth IS "remote" AND val(form.remoteauth_mapping_id) LTE 0>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "Remote authentication needs a RemoteAuth mapping. Choose one, or set Authentication to Local.">
      <cflocation url="view_directory_connections.cfm" addtoken="no">
    </cfif>

    <!--- The server is where the user list is read from, and nothing else
          supplies it. The RemoteAuth mapping answers a different question. --->
    <cfif NOT Len(Trim(form.server_address))>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "Enter the address of the directory to read the user list from.">
      <cflocation url="view_directory_connections.cfm" addtoken="no">
    </cfif>

    <cfset encPw = "">
    <cfif Len(Trim(form.bind_password))>
      <cftry>
        <cfset encPw = encrypt(Trim(form.bind_password), hermesKey, "AES", "Base64")>
        <cfcatch>
          <cfset session.m = "dc_error">
          <cfset session.dcError = "Could not encrypt the bind password.">
          <cflocation url="view_directory_connections.cfm" addtoken="no">
        </cfcatch>
      </cftry>
    </cfif>

    <cftry>
      <cfif form.action IS "add">
        <cfquery datasource="hermes">
          INSERT INTO directory_connections
            (entry_name, provider, remoteauth_mapping_id, server_address, server_port,
             tls_mode, base_dn, bind_dn, bind_password, object_class, mail_attribute, extra_filter, enabled,
             auth_type, policy_id, report_enabled, train_bayes, download_msg, enforce_mfa, send_welcome, auto_apply)
          VALUES (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(dcName,255)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcProvider#">,
            <cfif val(form.remoteauth_mapping_id) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.remoteauth_mapping_id)#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.server_address),255)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#dcPort#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcTls#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.base_dn),500)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.bind_dn),500)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#encPw#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.object_class),64)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.mail_attribute),64)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.extra_filter),500)#">,
            1,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcAuth#">,
            <cfif val(form.policy_id) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.policy_id)#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcReport#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#dcBayes#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#dcDownload#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#dcMfa#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#dcWelcome#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#dcAuto#">
          )
        </cfquery>
        <cfset session.m = "dc_add">
      <cfelse>
        <cfquery datasource="hermes">
          UPDATE directory_connections
             SET entry_name            = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(dcName,255)#">,
                 provider              = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcProvider#">,
                 remoteauth_mapping_id = <cfif val(form.remoteauth_mapping_id) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.remoteauth_mapping_id)#"><cfelse>NULL</cfif>,
                 server_address        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.server_address),255)#">,
                 server_port           = <cfqueryparam cfsqltype="cf_sql_integer" value="#dcPort#">,
                 tls_mode              = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcTls#">,
                 base_dn               = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.base_dn),500)#">,
                 bind_dn               = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.bind_dn),500)#">,
                 object_class          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.object_class),64)#">,
                 mail_attribute        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.mail_attribute),64)#">,
                 extra_filter          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.extra_filter),500)#">,
                 auth_type             = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcAuth#">,
                 policy_id             = <cfif val(form.policy_id) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.policy_id)#"><cfelse>NULL</cfif>,
                 report_enabled        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcReport#">,
                 train_bayes           = <cfqueryparam cfsqltype="cf_sql_integer" value="#dcBayes#">,
                 download_msg          = <cfqueryparam cfsqltype="cf_sql_integer" value="#dcDownload#">,
                 enforce_mfa           = <cfqueryparam cfsqltype="cf_sql_integer" value="#dcMfa#">,
                 send_welcome          = <cfqueryparam cfsqltype="cf_sql_integer" value="#dcWelcome#">,
                 auto_apply            = <cfqueryparam cfsqltype="cf_sql_integer" value="#dcAuto#">
                 <!--- Blank password on edit means "leave it alone". --->
                 <cfif Len(encPw)>, bind_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#encPw#"></cfif>
           WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
        </cfquery>
        <cfset session.m = "dc_edit">
      </cfif>

      <cfcatch>
        <cfset session.m = "dc_error">
        <cfif FindNoCase("uk_directory_entry_name", cfcatch.message)>
          <cfset session.dcError = "A connection named '" & dcName & "' already exists.">
        <cfelse>
          <cfset session.dcError = cfcatch.message>
        </cfif>
      </cfcatch>
    </cftry>

    <cflocation url="view_directory_connections.cfm" addtoken="no">
  </cfif>

  <!--- ================================================================
       DELETE

       Staged rows go with the connection. Recipients it already created do
       not: they are live users with portal access and encryption, and are no
       more the connection's property after the fact than a hand-added one.
       ================================================================ --->
  <cfif form.action IS "delete">
    <cfparam name="form.connection_id" default="0">
    <cftry>
      <cfquery datasource="hermes">
        DELETE FROM directory_import_staging
         WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
      </cfquery>
      <cfquery datasource="hermes">
        DELETE FROM directory_connections
         WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
      </cfquery>
      <cfset session.m = "dc_delete">
      <cfcatch>
        <cfset session.m = "dc_error">
        <cfset session.dcError = cfcatch.message>
      </cfcatch>
    </cftry>
    <cflocation url="view_directory_connections.cfm" addtoken="no">
  </cfif>

  <!--- ================================================================
       ENABLE / DISABLE
       ================================================================ --->
  <cfif form.action IS "toggle">
    <cfparam name="form.connection_id" default="0">
    <cfparam name="form.enabled"       default="0">
    <cfquery datasource="hermes">
      UPDATE directory_connections
         SET enabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#(val(form.enabled) EQ 1 ? 1 : 0)#">
       WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
    </cfquery>
    <cfset session.m = (val(form.enabled) EQ 1 ? "dc_enabled" : "dc_disabled")>
    <cflocation url="view_directory_connections.cfm" addtoken="no">
  </cfif>

  <!--- ================================================================
       SYNC NOW

       Runs the same page Ofelia runs, scoped to one connection. The sync
       stages only; nothing reaches `recipients` here.
       ================================================================ --->
  <cfif form.action IS "sync_now">
    <cfparam name="form.connection_id" default="0">
    <cftry>
      <cfhttp method="get"
              url="http://localhost:8888/schedule/directory_sync.cfm?connection_id=#val(form.connection_id)#"
              timeout="600"
              result="syncCall">
      <cfset session.m = "dc_synced">
      <cfcatch>
        <cfset session.m = "dc_error">
        <cfset session.dcError = "Sync could not be started: " & cfcatch.message>
      </cfcatch>
    </cftry>
    <cflocation url="view_directory_connections.cfm" addtoken="no">
  </cfif>

</cfif>
