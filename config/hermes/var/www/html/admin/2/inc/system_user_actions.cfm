<!---
Hermes Secure Email Gateway - System User Action Handler
Routes create, edit, delete, and delete-devices actions for system users.
All LDAP includes are reused as-is.
--->

<cfif action is "createuser">

  <!--- VALIDATE REQUIRED FIELDS --->
  <cfloop list="username,email,first_name,last_name,access_control,password" index="f">
    <cfif NOT StructKeyExists(form, f)>
      <cfset session.m = "system_user_actions.cfm: form.#f# does not exist">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>
  </cfloop>

  <!--- Default auth_type and related fields --->
  <cfif NOT StructKeyExists(form, "auth_type")><cfset form.auth_type = "local"></cfif>
  <cfif form.auth_type NEQ "local" AND form.auth_type NEQ "remote"><cfset form.auth_type = "local"></cfif>
  <cfif NOT StructKeyExists(form, "remoteauth_domain")><cfset form.remoteauth_domain = ""></cfif>
  <cfif NOT StructKeyExists(form, "hibp")><cfset form.hibp = "YES"></cfif>
  <cfif NOT StructKeyExists(form, "setpassword")><cfset form.setpassword = "YES"></cfif>

  <!--- Validate auth_type remote requires domain --->
  <cfif form.auth_type EQ "remote">
    <cfif form.remoteauth_domain EQ "">
      <cfset session.m = 17>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>
    <!--- Remote auth: force no password --->
    <cfset form.setpassword = "NO">
    <cfset form.password = "">
  </cfif>

  <!--- Validate access_control --->
  <cfif NOT ListFindNoCase("one_factor,two_factor", form.access_control)>
    <cfset session.m = "system_user_actions.cfm: invalid access_control value">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate username not blank --->
  <cfif trim(form.username) is "">
    <cfset session.m = 2>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate username format --->
  <cfif REFind("[^A-Za-z0-9\_\.\-\@]", form.username) GT 0>
    <cfset session.m = 21>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate username uniqueness --->
  <cfquery name="checkusername" datasource="hermes">
    SELECT username FROM system_users WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkusername.recordcount GTE 1>
    <cfset session.m = 13>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate email --->
  <cfif trim(form.email) is "">
    <cfset session.m = 4>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsValid("email", form.email)>
    <cfset session.m = 3>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate first_name --->
  <cfif trim(form.first_name) is "">
    <cfset session.m = 6>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^A-Za-z0-9\_\-]", form.first_name) GT 0>
    <cfset session.m = 5>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate last_name --->
  <cfif trim(form.last_name) is "">
    <cfset session.m = 9>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^A-Za-z0-9\_\-]", form.last_name) GT 0>
    <cfset session.m = 8>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- PASSWORD HANDLING --->
  <cfif form.auth_type EQ "remote">
    <!--- Remote auth: no password needed, insert and sync to LDAP --->
    <cfquery name="insertuser" datasource="hermes" result="insertResult">
      INSERT INTO system_users (username, email, first_name, last_name, system, applied, access_control, auth_type, remoteauth_domain, password)
      VALUES (
        <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.first_name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.last_name#" cfsqltype="cf_sql_varchar">,
        '2', '1',
        <cfqueryparam value="#form.access_control#" cfsqltype="cf_sql_varchar">,
        'remote',
        <cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar">,
        ''
      )
    </cfquery>
    <cfset theID = insertResult.GENERATED_KEY>

    <!--- LDAP SYNC: Add remote auth user --->
    <cfset ldapUsername = form.username>
    <cfset ldapFirstName = form.first_name>
    <cfset ldapLastName = form.last_name>
    <cfset ldapEmail = form.email>
    <cfset ldapAccessControl = form.access_control>
    <cfset ldapRemoteauthDomain = form.remoteauth_domain>
    <cfset ldapUserExists = false>
    <cfinclude template="ldap_add_user_remoteauth.cfm">
    <cfif ldapUserExists>
      <cfinclude template="ldap_modify_user_remoteauth.cfm">
    <cfelse>
      <cfinclude template="ldap_add_user_groups.cfm">
    </cfif>
    <cfquery datasource="hermes">
      UPDATE system_users SET ldap_synced = 1 WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfset session.m = 20>
    <cflocation url="view_system_users.cfm" addtoken="no">

  <cfelse>
    <!--- Local auth: password required for create --->
    <cfif trim(form.password) is "">
      <cfset session.m = 10>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>
    <cfif len(form.password) LT 8 OR len(form.password) GT 64>
      <cfset session.m = 11>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>

    <!--- HIBP check --->
    <cfif form.hibp is "YES">
      <cfset nextstep = "hibp_create_done">
      <cfset hibpRedirectUrl = "view_system_users.cfm">
      <cfinclude template="check_hibp.cfm">
      <!--- If check_hibp set step=0, it already redirected --->
    </cfif>

    <!--- Generate LDAP password --->
    <cfinclude template="generate_ldap_password.cfm">

    <!--- Insert user with password --->
    <cfquery name="insertuser" datasource="hermes" result="insertResult">
      INSERT INTO system_users (username, email, first_name, last_name, system, applied, access_control, auth_type, remoteauth_domain, password)
      VALUES (
        <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.first_name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.last_name#" cfsqltype="cf_sql_varchar">,
        '2', '1',
        <cfqueryparam value="#form.access_control#" cfsqltype="cf_sql_varchar">,
        'local', '',
        '#TRIM(ldapPassword)#'
      )
    </cfquery>
    <cfset theID = insertResult.GENERATED_KEY>

    <!--- LDAP SYNC: Add local user --->
    <cfset ldapUsername = form.username>
    <cfset ldapFirstName = form.first_name>
    <cfset ldapLastName = form.last_name>
    <cfset ldapEmail = form.email>
    <cfset ldapAccessControl = form.access_control>
    <cfset ldapUserExists = false>
    <cfinclude template="ldap_add_user.cfm">
    <cfif ldapUserExists>
      <cfinclude template="ldap_modify_user.cfm">
      <cfinclude template="ldap_modify_user_password.cfm">
    <cfelse>
      <cfinclude template="ldap_add_user_groups.cfm">
    </cfif>
    <cfquery datasource="hermes">
      UPDATE system_users SET ldap_synced = 1 WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfset session.m = 20>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

<cfelseif action is "edituser">

  <!--- Validate ID --->
  <cfif NOT StructKeyExists(form, "id") OR NOT IsValid("integer", form.id)>
    <cfset session.m = "system_user_actions.cfm: invalid user ID">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfset theID = form.id>

  <!--- Get current user data before changes --->
  <cfquery name="getuser" datasource="hermes">
    SELECT id, username, password, email, first_name, last_name, system, access_control, applied, auth_type, remoteauth_domain, ldap_synced
    FROM system_users WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif getuser.recordcount LT 1>
    <cfset session.m = "system_user_actions.cfm: user not found">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- VALIDATE REQUIRED FIELDS --->
  <cfloop list="username,email,first_name,last_name,access_control,password,setpassword,hibp" index="f">
    <cfif NOT StructKeyExists(form, f)>
      <cfset session.m = "system_user_actions.cfm: form.#f# does not exist">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>
  </cfloop>

  <!--- Default auth_type --->
  <cfif NOT StructKeyExists(form, "auth_type")><cfset form.auth_type = "local"></cfif>
  <cfif form.auth_type NEQ "local" AND form.auth_type NEQ "remote"><cfset form.auth_type = "local"></cfif>
  <cfif NOT StructKeyExists(form, "remoteauth_domain")><cfset form.remoteauth_domain = ""></cfif>

  <!--- Validate access_control --->
  <cfif NOT ListFindNoCase("one_factor,two_factor", form.access_control)>
    <cfset session.m = "system_user_actions.cfm: invalid access_control">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate setpassword --->
  <cfif NOT ListFindNoCase("YES,NO", form.setpassword)>
    <cfset session.m = "system_user_actions.cfm: invalid setpassword value">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Validate auth_type remote requires domain --->
  <cfif form.auth_type EQ "remote">
    <cfif form.remoteauth_domain EQ "">
      <cfset session.m = 17>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>
  <cfelse>
    <cfset form.remoteauth_domain = "">
  </cfif>

  <!--- STEP 1: Validate username not blank --->
  <cfif trim(form.username) is "">
    <cfset session.m = 2>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- STEP 2: Validate username format --->
  <cfif REFind("[^A-Za-z0-9\_\.\-\@]", form.username) GT 0>
    <cfset session.m = 21>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- Check username uniqueness (exclude self) --->
  <cfquery name="checkusername" datasource="hermes">
    SELECT username FROM system_users WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar"> AND id <> <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkusername.recordcount GTE 1>
    <cfset session.m = 13>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- STEP 3: Validate email --->
  <cfif trim(form.email) is "">
    <cfset session.m = 4>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsValid("email", form.email)>
    <cfset session.m = 3>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- STEP 4: Validate first_name --->
  <cfif trim(form.first_name) is "">
    <cfset session.m = 6>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^A-Za-z0-9\_\-]", form.first_name) GT 0>
    <cfset session.m = 5>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- STEP 5: Validate last_name --->
  <cfif trim(form.last_name) is "">
    <cfset session.m = 9>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^A-Za-z0-9\_\-]", form.last_name) GT 0>
    <cfset session.m = 8>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

  <!--- STEP 6: Update core fields --->
  <cfquery datasource="hermes">
    UPDATE system_users SET
      username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
      email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
      first_name = <cfqueryparam value="#form.first_name#" cfsqltype="cf_sql_varchar">,
      last_name = <cfqueryparam value="#form.last_name#" cfsqltype="cf_sql_varchar">,
      access_control = <cfqueryparam value="#form.access_control#" cfsqltype="cf_sql_varchar">,
      auth_type = <cfqueryparam value="#form.auth_type#" cfsqltype="cf_sql_varchar">,
      remoteauth_domain = <cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar" null="#(form.remoteauth_domain EQ '')#">,
      applied = '2'
    WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- STEP 7: Route based on auth type and password setting --->
  <cfif form.auth_type EQ "remote">
    <!--- REMOTE AUTH: No password, sync with seeAlso --->
    <cfquery datasource="hermes">
      UPDATE system_users SET applied = '1' WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfset ldapUsername = form.username>
    <cfset ldapFirstName = form.first_name>
    <cfset ldapLastName = form.last_name>
    <cfset ldapEmail = form.email>
    <cfset ldapAccessControl = form.access_control>
    <cfset ldapRemoteauthDomain = form.remoteauth_domain>

    <cfif getuser.ldap_synced NEQ 1>
      <cfset ldapUserExists = false>
      <cfinclude template="ldap_add_user_remoteauth.cfm">
      <cfif ldapUserExists>
        <cfinclude template="ldap_modify_user_remoteauth.cfm">
      <cfelse>
        <cfinclude template="ldap_add_user_groups.cfm">
      </cfif>
      <cfquery datasource="hermes">
        UPDATE system_users SET ldap_synced = 1 WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
      </cfquery>
    <cfelse>
      <cfinclude template="ldap_modify_user_remoteauth.cfm">
      <cfset ldapOldAccessControl = getuser.access_control>
      <cfset ldapNewAccessControl = form.access_control>
      <cfinclude template="ldap_change_user_access_control.cfm">
    </cfif>

    <cfset session.m = 18>
    <cflocation url="view_system_users.cfm" addtoken="no">

  <cfelseif form.setpassword is "NO">
    <!--- NO PASSWORD CHANGE --->
    <cfquery name="checkpasswordexists" datasource="hermes">
      SELECT password FROM system_users WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif checkpasswordexists.password is "" AND getuser.ldap_synced NEQ 1>
      <!--- Cannot sync to LDAP without a password --->
      <cfset session.m = 16>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
      UPDATE system_users SET applied = '1' WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfset ldapUsername = form.username>
    <cfset ldapFirstName = form.first_name>
    <cfset ldapLastName = form.last_name>
    <cfset ldapEmail = form.email>
    <cfset ldapAccessControl = form.access_control>

    <cfif getuser.ldap_synced NEQ 1>
      <cfset session.m = 16>
      <cflocation url="view_system_users.cfm" addtoken="no">
    <cfelse>
      <cfinclude template="ldap_modify_user.cfm">
      <cfset ldapOldAccessControl = getuser.access_control>
      <cfset ldapNewAccessControl = form.access_control>
      <cfinclude template="ldap_change_user_access_control.cfm">
    </cfif>

    <cfset session.m = 14>
    <cflocation url="view_system_users.cfm" addtoken="no">

  <cfelseif form.setpassword is "YES">
    <!--- PASSWORD CHANGE REQUESTED --->
    <cfif trim(form.password) is "">
      <cfset session.m = 10>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>
    <cfif len(form.password) LT 8 OR len(form.password) GT 64>
      <cfset session.m = 11>
      <cflocation url="view_system_users.cfm" addtoken="no">
    </cfif>

    <!--- HIBP check --->
    <cfif form.hibp is "YES">
      <cfset nextstep = "hibp_edit_done">
      <cfset hibpRedirectUrl = "view_system_users.cfm">
      <cfinclude template="check_hibp.cfm">
    </cfif>

    <!--- Generate LDAP password --->
    <cfinclude template="generate_ldap_password.cfm">

    <!--- Update password in DB --->
    <cfquery datasource="hermes">
      UPDATE system_users SET
        password = '#TRIM(ldapPassword)#',
        applied = '1'
      WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- LDAP SYNC --->
    <cfset ldapUsername = form.username>
    <cfset ldapFirstName = form.first_name>
    <cfset ldapLastName = form.last_name>
    <cfset ldapEmail = form.email>
    <cfset ldapAccessControl = form.access_control>

    <cfif getuser.ldap_synced NEQ 1>
      <cfset ldapUserExists = false>
      <cfinclude template="ldap_add_user.cfm">
      <cfif ldapUserExists>
        <cfinclude template="ldap_modify_user.cfm">
        <cfinclude template="ldap_modify_user_password.cfm">
      <cfelse>
        <cfinclude template="ldap_add_user_groups.cfm">
      </cfif>
      <cfquery datasource="hermes">
        UPDATE system_users SET ldap_synced = 1 WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
      </cfquery>
    <cfelse>
      <cfinclude template="ldap_modify_user.cfm">
      <cfinclude template="ldap_modify_user_password.cfm">
      <cfset ldapOldAccessControl = getuser.access_control>
      <cfset ldapNewAccessControl = form.access_control>
      <cfinclude template="ldap_change_user_access_control.cfm">
    </cfif>

    <cfset session.m = 14>
    <cflocation url="view_system_users.cfm" addtoken="no">
  </cfif>

<cfelseif action is "deleteuser">

  <cfif NOT StructKeyExists(form, "user") OR trim(form.user) is "" OR NOT IsValid("integer", form.user)>
    <cfset m = "Delete System User: invalid user ID">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfif>

  <cfquery name="getuser" datasource="hermes">
    SELECT id, username, system, ldap_synced FROM system_users
    WHERE id = <cfqueryparam value="#form.user#" cfsqltype="cf_sql_integer"> AND system <> '1' AND id <> <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif getuser.recordcount LT 1>
    <cfset m = "Delete System User: user not found or cannot be deleted">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfif>

  <cfset theUsername = getuser.username>
  <cfset theUserid = getuser.id>

  <!--- Delete from LDAP if synced --->
  <cfif getuser.ldap_synced EQ 1>
    <cfset ldapUsername = theUsername>
    <cfinclude template="ldap_delete_user.cfm">
  </cfif>

  <!--- Delete from database --->
  <cfinclude template="delete_system_user.cfm">

  <!--- Delete 2FA devices --->
  <cfinclude template="delete_system_user_devices.cfm">

  <cfset session.m = 1>
  <cflocation url="view_system_users.cfm" addtoken="no">

<cfelseif action is "deleteuserdevices">

  <cfif NOT StructKeyExists(form, "user") OR trim(form.user) is "">
    <cfset m = "Delete 2FA Devices: invalid user">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfif>

  <cfquery name="getuser" datasource="hermes">
    SELECT id, username FROM system_users WHERE username = <cfqueryparam value="#form.user#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif getuser.recordcount LT 1>
    <cfset m = "Delete 2FA Devices: user not found">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfif>

  <cfset theUsername = getuser.username>
  <cfset theUserid = getuser.id>

  <cfinclude template="delete_system_user_devices.cfm">

  <cfset session.m = 15>

  <!--- Wait for Authelia to restart --->
  <cfscript>
    thread = CreateObject("java", "java.lang.Thread");
    thread.sleep(5000);
  </cfscript>

  <cflocation url="view_system_users.cfm" addtoken="no">

<cfelseif action is "forcelogout">

  <!--- FORCE LOGOUT: invalidate all sessions for a specific user --->
  <cfparam name="form.logout_username" default="">
  <cfif form.logout_username NEQ "">
      <cfset targetSessionUser = form.logout_username>
      <cfinclude template="invalidate_user_sessions.cfm">
      <cfset session.m = 30>
      <cfset session.alerttype = "success">
  </cfif>
  <cflocation url="view_system_users.cfm" addtoken="no">

<cfelseif action is "forcelogoutall">

  <!--- FORCE LOGOUT ALL: flush the entire Authelia session store --->
  <cfset targetSessionUser = "*">
  <cfinclude template="invalidate_user_sessions.cfm">
  <cfset session.m = 31>
  <cfset session.alerttype = "success">
  <cflocation url="view_system_users.cfm" addtoken="no">

</cfif>
