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
    <cfparam name="form.google_subject"        default="">
    <cfparam name="form.graph_tenant_id"       default="">
    <cfparam name="form.graph_client_id"       default="">
    <cfparam name="form.graph_client_secret"   default="">
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
    <cfif NOT Len(dcName)>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "A name is required.">
      <cflocation url="view_directory_connections.cfm" addtoken="no">
    </cfif>

    <!--- The REST providers have none of the LDAP connection fields, so the
          base DN check below does not apply to them. Each needs its own
          credentials instead. --->
    <cfif dcProvider IS "google">
      <cfif NOT Len(Trim(form.google_subject))>
        <cfset session.m = "dc_error">
        <cfset session.dcError = "Enter the super administrator the service account should impersonate. Domain-wide delegation will not work without one.">
        <cflocation url="view_directory_connections.cfm" addtoken="no">
      </cfif>
    <cfelseif dcProvider IS "graph">
      <cfif NOT Len(Trim(form.graph_tenant_id)) OR NOT Len(Trim(form.graph_client_id))>
        <cfset session.m = "dc_error">
        <cfset session.dcError = "Microsoft 365 needs both the Directory (tenant) ID and the Application (client) ID from the app registration.">
        <cflocation url="view_directory_connections.cfm" addtoken="no">
      </cfif>
      <!--- Only on add. On edit a blank secret means "keep the stored one",
            the same convention the bind password already uses, so demanding
            one here would force it to be retyped on every unrelated edit. --->
      <cfif form.action IS "add" AND NOT Len(Trim(form.graph_client_secret))>
        <cfset session.m = "dc_error">
        <cfset session.dcError = "Enter the client secret VALUE from the app registration. Entra shows it only once, at creation.">
        <cflocation url="view_directory_connections.cfm" addtoken="no">
      </cfif>
    <cfelseif NOT Len(Trim(form.base_dn))>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "A base DN is required.">
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
          supplies it. The RemoteAuth mapping answers a different question.
          Neither REST provider has a server to enter: the endpoint is fixed
          and the tenant is identified by credentials, not by address. --->
    <cfif dcProvider IS NOT "google" AND dcProvider IS NOT "graph" AND NOT Len(Trim(form.server_address))>
      <cfset session.m = "dc_error">
      <cfset session.dcError = "Enter the address of the directory to read the user list from.">
      <cflocation url="view_directory_connections.cfm" addtoken="no">
    </cfif>

    <!--- Mutual TLS for this directory (#335). Stored under
          /opt/hermes/certs/directories/, keyed by connection so two
          directories can hold different pairs. Written before the row exists
          on an add, so the filename is derived from entry_name and settled
          on the connection id afterwards is not worth the complexity: the
          name is unique because entry_name is. --->
    <cfset dcCertDir  = "/opt/hermes/certs/directories">
    <cfset dcSlug     = ReReplaceNoCase(LCase(dcName), "[^a-z0-9]", "_", "all")>
    <cfset dcCertFile = "">
    <cfset dcKeyFile  = "">
    <cfset dcCaFile   = "">

    <cfif form.action IS "edit">
      <cfquery name="dcPriorCert" datasource="hermes">
        SELECT client_cert_file, client_key_file, ca_cert_file FROM directory_connections
         WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
      </cfquery>
      <cfif dcPriorCert.recordcount GTE 1>
        <cfset dcCertFile = dcPriorCert.client_cert_file>
        <cfset dcKeyFile  = dcPriorCert.client_key_file>
        <cfset dcCaFile   = dcPriorCert.ca_cert_file>
      </cfif>
    </cfif>

    <cfif StructKeyExists(form, "remove_client_cert") AND form.remove_client_cert EQ "1">
      <cfloop list="#dcCertFile#,#dcKeyFile#" index="oneOld">
        <cfif Len(Trim(oneOld)) AND FileExists("#dcCertDir#/#Trim(oneOld)#")>
          <cftry><cffile action="delete" file="#dcCertDir#/#Trim(oneOld)#"><cfcatch></cfcatch></cftry>
        </cfif>
      </cfloop>
      <cfset dcCertFile = "">
      <cfset dcKeyFile  = "">
    </cfif>

    <cfif StructKeyExists(form, "remove_ca_cert") AND form.remove_ca_cert EQ "1">
      <cfif Len(Trim(dcCaFile)) AND FileExists("#dcCertDir#/#Trim(dcCaFile)#")>
        <cftry><cffile action="delete" file="#dcCertDir#/#Trim(dcCaFile)#"><cfcatch></cfcatch></cftry>
      </cfif>
      <cfset dcCaFile = "">
    </cfif>

    <cfif StructKeyExists(form, "ca_cert_file") AND Len(form.ca_cert_file)>
      <cftry>
        <cfif NOT DirectoryExists(dcCertDir)>
          <cfdirectory action="create" directory="#dcCertDir#" mode="755">
        </cfif>
        <!--- Upload before replacing, so a rejected file cannot destroy a
              working bundle. --->
        <cffile action="upload" fileField="ca_cert_file" destination="#dcCertDir#"
                nameConflict="makeunique" accept="application/x-x509-ca-cert,application/pkix-cert,application/x-pem-file,text/plain,.pem,.crt,.cer">
        <cfset dcUpCa  = cffile.serverFile>
        <cfset dcNewCa = dcSlug & "_ca.pem">
        <cfif dcUpCa NEQ dcNewCa>
          <cfif FileExists("#dcCertDir#/#dcNewCa#")><cffile action="delete" file="#dcCertDir#/#dcNewCa#"></cfif>
          <cffile action="rename" source="#dcCertDir#/#dcUpCa#" destination="#dcCertDir#/#dcNewCa#">
        </cfif>
        <cfset dcCaFile = dcNewCa>
        <cfcatch>
          <cfset session.m = "dc_error">
          <cfset session.dcError = "CA bundle upload failed: " & cfcatch.message>
          <cflocation url="view_directory_connections.cfm" addtoken="no">
        </cfcatch>
      </cftry>
    </cfif>

    <!--- Both or neither. Half a pair produces a handshake that fails in a
          way that reads as a server problem. --->
    <cfif StructKeyExists(form, "client_cert_file") AND Len(form.client_cert_file)
      AND StructKeyExists(form, "client_key_file")  AND Len(form.client_key_file)>
      <cftry>
        <cfif NOT DirectoryExists(dcCertDir)>
          <cfdirectory action="create" directory="#dcCertDir#" mode="755">
        </cfif>
        <cffile action="upload" fileField="client_cert_file" destination="#dcCertDir#"
                nameConflict="makeunique" accept="application/x-x509-ca-cert,application/pkix-cert,application/x-pem-file,text/plain,.pem,.crt,.cer">
        <cfset dcUpCert = cffile.serverFile>
        <cffile action="upload" fileField="client_key_file" destination="#dcCertDir#"
                nameConflict="makeunique" accept="application/x-pem-file,application/pkcs8,text/plain,.pem,.key">
        <cfset dcUpKey = cffile.serverFile>

        <cfset dcNewCert = dcSlug & "_client.pem">
        <cfset dcNewKey  = dcSlug & "_client.key">
        <cfif dcUpCert NEQ dcNewCert>
          <cfif FileExists("#dcCertDir#/#dcNewCert#")><cffile action="delete" file="#dcCertDir#/#dcNewCert#"></cfif>
          <cffile action="rename" source="#dcCertDir#/#dcUpCert#" destination="#dcCertDir#/#dcNewCert#">
        </cfif>
        <cfif dcUpKey NEQ dcNewKey>
          <cfif FileExists("#dcCertDir#/#dcNewKey#")><cffile action="delete" file="#dcCertDir#/#dcNewKey#"></cfif>
          <cffile action="rename" source="#dcCertDir#/#dcUpKey#" destination="#dcCertDir#/#dcNewKey#">
        </cfif>

        <cffile action="write" file="/opt/hermes/tmp/dc_keyperm.sh" mode="700" addNewLine="no"
                output="##!/bin/bash#Chr(10)#chmod 600 '#dcCertDir#/#dcNewKey#'#Chr(10)#">
        <cftry>
          <cfexecute name="/bin/bash" arguments="/opt/hermes/tmp/dc_keyperm.sh" timeout="15" variable="dcKpOut" errorVariable="dcKpErr"></cfexecute>
          <cfcatch></cfcatch>
        </cftry>
        <cftry><cffile action="delete" file="/opt/hermes/tmp/dc_keyperm.sh"><cfcatch></cfcatch></cftry>

        <cfset dcCertFile = dcNewCert>
        <cfset dcKeyFile  = dcNewKey>
        <cfcatch>
          <cfset session.m = "dc_error">
          <cfset session.dcError = "Client certificate upload failed: " & cfcatch.message>
          <cflocation url="view_directory_connections.cfm" addtoken="no">
        </cfcatch>
      </cftry>
    </cfif>

    <!--- Service account key. Encrypted like every other credential here, and
          kept out of the certs directory because it is not a certificate: it
          is a password-equivalent that can act as a super administrator. --->
    <cfset dcSaJson = "">
    <cfif form.action IS "edit">
      <cfquery name="dcPriorSa" datasource="hermes">
        SELECT google_sa_json FROM directory_connections
         WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.connection_id)#">
      </cfquery>
      <cfif dcPriorSa.recordcount GTE 1><cfset dcSaJson = dcPriorSa.google_sa_json></cfif>
    </cfif>

    <cfif StructKeyExists(form, "google_sa_json") AND Len(form.google_sa_json)>
      <cftry>
        <cfset dcSaTmp = "/opt/hermes/tmp/" & dcSlug & "_sa_upload.json">
        <cffile action="upload" fileField="google_sa_json" destination="/opt/hermes/tmp"
                nameConflict="makeunique" accept="application/json,text/plain,.json">
        <cfset dcSaUploaded = "/opt/hermes/tmp/" & cffile.serverFile>
        <cffile action="read" file="#dcSaUploaded#" variable="dcSaRaw" charset="utf-8">
        <cftry><cffile action="delete" file="#dcSaUploaded#"><cfcatch></cfcatch></cftry>

        <!--- Validate before storing. A key that is not JSON, or is the OAuth
              client file rather than the service account key, fails later as
              an authentication error that says nothing about the upload. --->
        <cfif NOT IsJSON(Trim(dcSaRaw))>
          <cfthrow message="That file is not valid JSON.">
        </cfif>
        <cfset dcSaParsed = DeserializeJSON(Trim(dcSaRaw))>
        <cfif NOT StructKeyExists(dcSaParsed, "client_email") OR NOT StructKeyExists(dcSaParsed, "private_key")>
          <cfthrow message="That JSON has no client_email or private_key, so it is not a service account key. Download the key from the service account itself, not the OAuth client.">
        </cfif>

        <cfset dcSaJson = encrypt(Trim(dcSaRaw), hermesKey, "AES", "Base64")>
        <cfcatch>
          <cfset session.m = "dc_error">
          <cfset session.dcError = "Service account key rejected: " & cfcatch.message>
          <cflocation url="view_directory_connections.cfm" addtoken="no">
        </cfcatch>
      </cftry>
    </cfif>

    <!--- Graph client secret. Same convention as the bind password: blank on
          edit leaves the stored one in place. --->
    <cfset encGraphSecret = "">
    <cfif Len(Trim(form.graph_client_secret))>
      <cftry>
        <cfset encGraphSecret = encrypt(Trim(form.graph_client_secret), hermesKey, "AES", "Base64")>
        <cfcatch>
          <cfset session.m = "dc_error">
          <cfset session.dcError = "Could not encrypt the client secret.">
          <cflocation url="view_directory_connections.cfm" addtoken="no">
        </cfcatch>
      </cftry>
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
             tls_mode, base_dn, bind_dn, bind_password, object_class, mail_attribute, extra_filter,
             client_cert_file, client_key_file, ca_cert_file,
             google_sa_json, google_subject,
             graph_tenant_id, graph_client_id, graph_client_secret, enabled,
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
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcCertFile#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcKeyFile#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcCaFile#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#dcSaJson#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.google_subject),255)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.graph_tenant_id),255)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.graph_client_id),255)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#encGraphSecret#">,
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
                 client_cert_file      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcCertFile#">,
                 client_key_file       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcKeyFile#">,
                 ca_cert_file          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dcCaFile#">,
                 google_sa_json        = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#dcSaJson#">,
                 google_subject        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.google_subject),255)#">,
                 graph_tenant_id       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.graph_tenant_id),255)#">,
                 graph_client_id       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Trim(form.graph_client_id),255)#">,
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
                 <cfif Len(encGraphSecret)>, graph_client_secret = <cfqueryparam cfsqltype="cf_sql_varchar" value="#encGraphSecret#"></cfif>
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
