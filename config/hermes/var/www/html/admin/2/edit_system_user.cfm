<!DOCTYPE html>

  
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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
 
<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Edit System User</title>

  <cfinclude template="./inc/html_head.cfm" />
<!--- SCRIPT TO SHOW/HIDE UPDATE PASSWORD --->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const passwordToggle = document.querySelector('#userpasswordfield a');
    if (passwordToggle) {
        passwordToggle.addEventListener('click', function(event) {
            event.preventDefault();
            const input = document.querySelector('#userpasswordfield input');
            const icon = document.querySelector('#userpasswordfield i');
            if (input.type === 'text') {
                input.type = 'password';
                icon.classList.add('fa-eye-slash');
                icon.classList.remove('fa-eye');
            } else {
                input.type = 'text';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    }
});
</script>


<!--- STYLE FOR EYE-SLASH STARTS HERE --->    
<style>
  td {
   word-break: break-all;
       },

body{
 padding:100px 0;
 background-color:#efefef
}

a, a:hover{
 color:#333
}


</style>
<!--- STYLE FOR EYE-SLASH ENDS HERE --->  

<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW ENDS HERE --->  

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  
  


  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Edit System User</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit System User</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

     
<!--- CFML CODE STARTS HERE --->


<cfparam name = "step" default = "0"> 

<cfparam name = "m" default = "0">
<cfif StructKeyExists(session, "m")>
<cfif session.m is not "">
<cfset m = session.m>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>#session.m#</cfoutput>
--->

<!--- /CFIF for session.m is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.m --->
</cfif>

<!---
<cfoutput>session M: #m#</cfoutput>
--->

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfset action = form.action>

<!--- /CFIF StructKeyExists(form, "action")> --->
</cfif>


<!---
<cfparam name = "applied" default = "1"> 
<cfquery name="getapplied" datasource="hermes">
select applied from system_users where applied = '2'
</cfquery>

<cfif #getapplied.recordcount# GTE 1>
<cfset applied = 2>
</cfif>
--->

<cfparam name = "theID" default = ""> 
<cfif StructKeyExists(url, "id")>
<cfif IsValid("integer", url.id)>
<cfset theID = url.id>
<cfelse>
<cfset m="Edit System User: url.id not valid interger">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>


<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit System User: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getuser" datasource="hermes">
select id, username, password, email, first_name, last_name, system, access_control, applied, auth_type, remoteauth_domain from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- CHECK IF REMOTEAUTH IS AVAILABLE (Pro edition + enabled + has mappings) --->
<cfset remoteauthAvailable = false>
<cfset remoteauthDomains = []>

<cfif isDefined("session.edition") AND session.edition EQ "Pro">
    <!--- Check if remoteauth is enabled and has mappings --->
    <cfquery name="getRemoteauthStatus" datasource="hermes">
        SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'enabled'
    </cfquery>
    <cfquery name="getRemoteauthDomains" datasource="hermes">
        SELECT domain_name, server_address FROM remoteauth_mappings WHERE enabled = 1 ORDER BY domain_name
    </cfquery>

    <cfif getRemoteauthStatus.recordcount GT 0 AND getRemoteauthStatus.setting_value EQ "1" AND getRemoteauthDomains.recordcount GT 0>
        <cfset remoteauthAvailable = true>
        <cfloop query="getRemoteauthDomains">
            <cfset arrayAppend(remoteauthDomains, {domain: getRemoteauthDomains.domain_name, server: getRemoteauthDomains.server_address})>
        </cfloop>
    </cfif>
</cfif>

<cfif #getuser.recordcount# LT 1>
<cfset m="Edit System User: getuser.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>

<cfparam name = "theUsername" default = "#getuser.username#"> 

<cfparam name = "thePassword" default = ""> 

<cfparam name = "theEmail" default = "#getuser.email#"> 

<cfparam name = "theFirstName" default = "#getuser.first_name#"> 

<cfparam name = "theLastName" default = "#getuser.last_name#"> 

<cfparam name = "theAccessControl" default = "#getuser.access_control#">

<cfparam name = "theAuthType" default = "#getuser.auth_type#">
<cfif theAuthType EQ ""><cfset theAuthType = "local"></cfif>

<cfparam name = "theRemoteauthDomain" default = "#getuser.remoteauth_domain#">

<cfparam name = "setPassword" default = "NO"> 

<cfquery name="checkpasswordexists" datasource="hermes">
  select id, password from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
<cfif #checkpasswordexists.password# is "">
<cfset setPassword = "YES">
  </cfif>




<cfparam name = "checkHibp" default = "YES"> 



<!--- DEBUG --->
<!---
<cfoutput>Step: #step#<br>
Message: #m#<br>
Username: #theusername#<br>
first: #theFirstname#<br>
Last: #theLastname#<br>
Email: #theEmail#<br>
Password: #thePassword#<br>
SetPassword: #setPassword#<br>
hibp: #checkHibp#<br>
Action: #action#
</cfoutput>
--->

<cfif #action# is "edituser">

  
<!--- VALIDATE FORM INPUTS STARTS HERE --->
<cfif NOT StructKeyExists(form, "username")>

  <cfset m="Edit System User: form.username does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "username") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "password")>
  
  <cfset m="Edit System User: form.password does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "password") --->
  </cfif>
  
  <cfif NOT StructKeyExists(form, "email")>
  
  <cfset m="Edit System User: form.email does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "email") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "first_name")>
  
  <cfset m="Edit System User: form.first_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "first_name") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "last_name")>
  
  <cfset m="Edit System User: form.last_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "last_name") --->
  </cfif>

  <cfif NOT StructKeyExists(form, "access_control")>

    <cfset m="Edit System User: form.access_control does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <cfelse>

  <cfif form.access_control is "one_factor" OR form.access_control is "two_factor">

  <cfelse>

  <cfset m="Edit System User: form.access_control is not one_factor or two_factor">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF form.access_control is "one_factor" OR form.access_control is "two_factor" --->
  </cfif>

  <!--- /CFIF StructKeyExists(form, "access_control") --->
  </cfif>

  <!--- VALIDATE AUTH_TYPE (only if Pro edition) --->
  <cfif NOT StructKeyExists(form, "auth_type")>
    <cfset form.auth_type = "local">
  </cfif>

  <cfif form.auth_type NEQ "local" AND form.auth_type NEQ "remote">
    <cfset form.auth_type = "local">
  </cfif>

  <!--- If remote auth selected, validate remoteauth_domain --->
  <cfif form.auth_type EQ "remote">
    <cfif NOT StructKeyExists(form, "remoteauth_domain") OR form.remoteauth_domain EQ "">
      <cfset session.m = 17>
      <cfoutput>
      <cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
      </cfoutput>
    </cfif>
  <cfelse>
    <cfset form.remoteauth_domain = "">
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "setpassword")>
  
  <cfset m="Edit System User: form.setpassword does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelse>

  <cfif form.setpassword is "YES" OR form.setpassword is "NO">

  <cfelse>

  <cfset m="Edit System User: form.setpassword is not YES or NO">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF form.setpassword is "YES" OR form.setpassword is "NO" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "setpassword") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "hibp")>
  
  <cfset m="Edit System User: form.hibp does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelse>

  <cfif form.hibp is "YES" OR form.hibp is "NO">

  <cfelse>
  
  <cfset m="Edit System User: form.hibp is not YES or NO">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF form.hibp is "YES" OR form.hibp is "NO" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "hibp") --->
  </cfif>
  
  <!--- VALIDATE FORM INPUTS ENDS HERE --->
  

<cfif #form.username# is "">

<cfset step=0>
<cfset session.m=2>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<cfset step=1>
  
<!--- /CFIF the username is/not ""  --->
</cfif>

<cfif #step# is "1">

<cfif REFind("[^A-Za-z0-9\_\.\-\@]",form.username) gt 0>

<cfset step=0>
<cfset session.m=1>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  

<cfelse>

<cfset step=2>

<!--- /CFIF REFind("[^_a-zA-Z0-9-]",form.username) gt 0>  --->
</cfif>

<!--- /CFIF step is 1 --->
</cfif>


<cfif #step# is "2">

<cfquery name="checkusername" datasource="hermes">
select username from system_users where username = '#form.username#' and id <> <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkusername.recordcount# LT 1>

<!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
username = '#form.username#',
applied='2'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step = 3>

<cfelse>

<cfset step=0>
<cfset session.m=13>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF checkusername.recordcount --->
</cfif>

<!--- /CFIF step is 2 --->
</cfif>


<cfif #step# is "3" and "#form.email#" is not "">

<cfif not IsValid("email", form.email)>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
  update system_users set
  email = '#form.email#',
  applied='2'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=4>

<!--- /CFIF IsValid("email", form.email) --->
</cfif>

<cfelseif #step# is "3" and #form.email# is "">

<cfset step=0>
<cfset session.m=4>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF step 3 --->
</cfif>


<cfif #step# is "4" and #form.first_name# is "">

<cfset step=0>
<cfset session.m=6>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<cfif REFind("[^A-Za-z0-9\_\-]",form.first_name) gt 0>

<cfset step=0>
<cfset session.m=5>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

  <!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
  update system_users set
  first_name = '#form.first_name#',
  applied='2'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=5>

<!--- /CFIF  REFind("[^A-Za-z0-9\_\-]",form.first_name) gt 0> --->
</cfif>

<!--- /CFIF step 4 --->
</cfif>

<cfif #step# is "5" and #form.last_name# is "">

<cfset step=0>
<cfset session.m=9>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  
<cfelse>
  
<cfif REFind("[^A-Za-z0-9\_\-]",form.last_name) gt 0>
<cfset step=0>
<cfset session.m=8>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  
<cfelse>

  <!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
  update system_users set
  last_name = '#form.last_name#',
  applied='2'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=6>
  
<!--- /CFIF  REFind("[^A-Za-z0-9\_\-]",form.last_name) gt 0> --->
</cfif>
  
<!--- /CFIF step 5 --->
</cfif>

<cfif #step# is "6">

<!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
access_control = '#form.access_control#',
auth_type = <cfqueryparam value="#form.auth_type#" cfsqltype="cf_sql_varchar">,
remoteauth_domain = <cfqueryparam value="#form.remoteauth_domain#" cfsqltype="cf_sql_varchar" null="#(form.remoteauth_domain EQ '')#">,
applied='2'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step=7>


<!--- /CFIF step 6 --->
</cfif>
  

<cfif step is "7">

<!--- IF REMOTE AUTH USER, SKIP PASSWORD VALIDATION AND GO TO LDAP SYNC --->
<cfif form.auth_type EQ "remote">
    <cfset step = 13>
<cfelseif #form.setpassword# is "NO">

<cfquery name="checkpasswordexists" datasource="hermes">
select id, password from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkpasswordexists.password# is "">
<cfset step=0>
<cfset session.m=12>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- IF SETPASSWORD IS "NO" AND PASSWORD EXISTS GOTO LAST STEP --->
<cfelse>

<cfset step=12>

<!--- /CFIF #checkpasswordexists.password# is "" --->
</cfif>

<cfelseif #form.setpassword# is "YES">

<cfset step = 8>

<!--- /CFIF form.auth_type is remote or form.setpassword is YES or NO --->
</cfif>


<!--- /CFIF step 7--->
</cfif>


<cfif step is "8" and #form.password# is "">

<cfset step=0>
<cfset session.m=10>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelseif step is "8" and #form.password# is not "">

<!--- CODE TO ENFORCE MIN 8 CHARACTER LENGTH --->
<cfif NOT ( len(form.password) GTE 8)>
<cfset step=0>
<cfset session.m=11>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- CODE TO ENFORCE MIN 64 CHARACTER LENGTH --->
<cfelseif NOT ( len(form.password) LTE 64)>
<cfset step=0>
<cfset session.m=11>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  
<cfelse>

<cfset step=9>

<!--- /CFIF NOT ( len(form.password) GTE 8) --->
</cfif>

<!--- /CFIF step 8 --->
</cfif>

<cfif step is "9">

<cfif #form.hibp# is "YES">

<!--- SET NEXTSTEP VARIABLE TO BE PARSED BY CHECK_HIBP.CFM TEMPLATE --->
<cfset nextstep=10>

<!--- INVOKE HIBP TEMPLATE --->
<cfinclude template="./inc/check_hibp.cfm" />

<cfelse>

<cfset step=10>

<!--- /CFIF form.hibp is YES or NO --->
</cfif>

<!--- /CFIF step --->
</cfif>

<cfif step is "10">

<!--- GENERATE LDAP ARGON2 PASSWORD --->
<cfinclude template="./inc/generate_ldap_password.cfm">

<cfset step = 11>

<!--- /CFIF step is 10 --->
</cfif>

<cfif step is "11">

<!--- UPDATE DATABASE WITH PASSWORD HASH --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
password = '#TRIM(ldapPassword)#',
applied='1'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- CHECK IF THIS IS A NEW LDAP USER OR EXISTING USER --->
<cfquery name="checkLdapUser" datasource="hermes">
select ldap_synced from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- SET VARIABLES FOR LDAP OPERATIONS --->
<cfset ldapUsername = form.username>
<cfset ldapFirstName = form.first_name>
<cfset ldapLastName = form.last_name>
<cfset ldapEmail = form.email>
<cfset ldapAccessControl = form.access_control>

<cfif checkLdapUser.ldap_synced NEQ 1>
    <!--- NEW USER: TRY TO ADD TO LDAP --->
    <cfset ldapUserExists = false>
    <cfinclude template="./inc/ldap_add_user.cfm">

    <!--- IF USER ALREADY EXISTS IN LDAP, MODIFY INSTEAD --->
    <cfif ldapUserExists>
        <!--- User exists in LDAP but not marked as synced in DB - update them --->
        <cfinclude template="./inc/ldap_modify_user.cfm">
        <cfinclude template="./inc/ldap_modify_user_password.cfm">
    <cfelse>
        <!--- New user was added successfully - add to groups --->
        <cfinclude template="./inc/ldap_add_user_groups.cfm">
    </cfif>

    <!--- MARK USER AS SYNCED TO LDAP --->
    <cfquery name="updateLdapSynced" datasource="hermes">
    update system_users set ldap_synced = 1 where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
<cfelse>
    <!--- EXISTING USER: MODIFY IN LDAP --->
    <cfinclude template="./inc/ldap_modify_user.cfm">
    <cfinclude template="./inc/ldap_modify_user_password.cfm">

    <!--- CHECK IF ACCESS CONTROL CHANGED --->
    <cfset ldapOldAccessControl = getuser.access_control>
    <cfset ldapNewAccessControl = form.access_control>
    <cfinclude template="./inc/ldap_change_user_access_control.cfm">
</cfif>

<cfset session.m=14>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF for step 11 --->
</cfif>

<cfif step is "12">

<!--- NO PASSWORD CHANGE - JUST UPDATE USER ATTRIBUTES --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
applied='1'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- CHECK IF THIS IS A NEW LDAP USER OR EXISTING USER --->
<cfquery name="checkLdapUser" datasource="hermes">
select ldap_synced, password from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- SET VARIABLES FOR LDAP OPERATIONS --->
<cfset ldapUsername = form.username>
<cfset ldapFirstName = form.first_name>
<cfset ldapLastName = form.last_name>
<cfset ldapEmail = form.email>
<cfset ldapAccessControl = form.access_control>

<cfif checkLdapUser.ldap_synced NEQ 1>
    <!--- USER NOT YET IN LDAP - CANNOT SYNC WITHOUT PASSWORD --->
    <!--- Old database passwords are in Authelia format, not LDAP format --->
    <!--- User must set a new password to sync to LDAP --->
    <cfset session.m=16>
    <cfoutput>
    <cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
    </cfoutput>
<cfelse>
    <!--- EXISTING USER: MODIFY IN LDAP (no password change) --->
    <cfinclude template="./inc/ldap_modify_user.cfm">

    <!--- CHECK IF ACCESS CONTROL CHANGED --->
    <cfset ldapOldAccessControl = getuser.access_control>
    <cfset ldapNewAccessControl = form.access_control>
    <cfinclude template="./inc/ldap_change_user_access_control.cfm">
</cfif>

<cfset session.m=14>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF for step 12 --->
</cfif>

<cfif step is "13">

<!--- REMOTE AUTH USER - NO LOCAL PASSWORD NEEDED --->
<!--- Update user as applied and sync to LDAP with seeAlso attribute --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
applied='1'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- CHECK IF THIS IS A NEW LDAP USER OR EXISTING USER --->
<cfquery name="checkLdapUser" datasource="hermes">
select ldap_synced from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- SET VARIABLES FOR LDAP OPERATIONS --->
<cfset ldapUsername = form.username>
<cfset ldapFirstName = form.first_name>
<cfset ldapLastName = form.last_name>
<cfset ldapEmail = form.email>
<cfset ldapAccessControl = form.access_control>
<cfset ldapAuthType = form.auth_type>
<cfset ldapRemoteauthDomain = form.remoteauth_domain>

<cfif checkLdapUser.ldap_synced NEQ 1>
    <!--- NEW REMOTE AUTH USER: ADD TO LDAP WITH SEEALSO ATTRIBUTE --->
    <cfset ldapUserExists = false>
    <cfinclude template="./inc/ldap_add_user_remoteauth.cfm">

    <!--- IF USER ALREADY EXISTS IN LDAP, MODIFY INSTEAD --->
    <cfif ldapUserExists>
        <cfinclude template="./inc/ldap_modify_user_remoteauth.cfm">
    <cfelse>
        <!--- New user was added successfully - add to groups --->
        <cfinclude template="./inc/ldap_add_user_groups.cfm">
    </cfif>

    <!--- MARK USER AS SYNCED TO LDAP --->
    <cfquery name="updateLdapSynced" datasource="hermes">
    update system_users set ldap_synced = 1 where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
<cfelse>
    <!--- EXISTING REMOTE AUTH USER: MODIFY IN LDAP --->
    <cfinclude template="./inc/ldap_modify_user_remoteauth.cfm">

    <!--- CHECK IF ACCESS CONTROL CHANGED --->
    <cfset ldapOldAccessControl = getuser.access_control>
    <cfset ldapNewAccessControl = form.access_control>
    <cfinclude template="./inc/ldap_change_user_access_control.cfm">
</cfif>

<cfset session.m=18>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF for step 13 --->
</cfif>


<cfelseif #action# is "deleteuser">

  <cfif NOT StructKeyExists(form, "user")>

    <cfset m="Delete System User: form.user does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "user")>
    
    <cfif #form.user# is "">
    <cfset m="Delete System User: form.user blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelseif #form.user# is not "">
    <cfset theUser = #form.user#>

    <!--- /CFIF form.user is/is not "" --->
    </cfif>

    <!--- /CFIF StructKeyExists(form, "user") --->
    </cfif>

<cfquery name="getuser" datasource="hermes">
SELECT  id, username, system, ldap_synced from system_users where id = <cfqueryparam value = #theUser# CFSQLType = "CF_SQL_INTEGER"> and system <> '1' and id <> '#session.userid#'
</cfquery>

<cfif #getuser.recordcount# GTE 1>

<cfset theUsername="#getuser.username#">
<cfset theUserid="#getuser.id#">

<!--- ONLY DELETE FROM LDAP IF USER WAS SYNCED --->
<cfif getuser.ldap_synced EQ 1>
    <cfset ldapUsername = theUsername>
    <cfinclude template="./inc/ldap_delete_user.cfm">
</cfif>

<!--- DELETE USER FROM DATABASE --->
<cfinclude template="./inc/delete_system_user.cfm">

<!--- DELETE USER 2FA DEVICES --->
<cfinclude template="./inc/delete_system_user_devices.cfm">

<cfset session.m=1>

<cfoutput>
<cflocation url="view_system_users.cfm" addtoken="no">
</cfoutput>



<cfelse>

  <cfset m="Delete System User: getuser.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getuser.recordcount# GTE 1 --->
</cfif>

<cfelseif #action# is "deleteuserdevices">

  <cfif NOT StructKeyExists(form, "user")>

    <cfset m="Delete System User: form.user does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "user")>
    
    <cfif #form.user# is "">
    <cfset m="Delete System User: form.user blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelseif #form.user# is not "">
    <cfset theUser = "#form.user#">

    <!--- /CFIF form.user is/is not "" --->
    </cfif>

    <!--- /CFIF StructKeyExists(form, "user") --->
    </cfif>

<cfquery name="getuser" datasource="hermes">
SELECT  id, username, system from system_users where username = <cfqueryparam value = #theUser# CFSQLType = "cf_sql_varchar">
</cfquery>

<cfif #getuser.recordcount# GTE 1>

<cfset theUsername="#getuser.username#">
<cfset theUserid="#getuser.id#">

<cfinclude template="./inc/delete_system_user_devices.cfm">

<cfset session.m=15>

<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
  thread = CreateObject("java", "java.lang.Thread"); 
  thread.sleep(5000); 
  </cfscript> 

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>



<cfelse>

  <cfset m="Delete System User: getuser.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getuser.recordcount# GTE 1 --->
</cfif>
 
 

<!--- /CFIF #action# --->
</cfif>

<!--- CFML CODE ENDS HERE --->


<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Username. Usernames can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), periods (.) and at signs (@)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Username field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The E-mail Address field is not a valid e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The E-mail Address field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid First Name. First Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The First Name field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Last Name. Last Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>




<cfif #m# is "9">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Last Name field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Password field cannot blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "11">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Password must be between 8 and 64 characters long</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>No password has been set for this user. You must set the <strong>Set User Password</strong> field to YES in order to continue</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "13">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Username you are attempting to use already exists</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "14">

<div class="alert alert-success alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  <cfoutput>System User was saved successfully</cfoutput> 
    
</div>

<cfset session.m = 0>

</cfif>

<cfif #m# is "15">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>System User 2FA devices were deleted successfully</cfoutput>

  </div>

  <cfset session.m = 0>

  </cfif>

<cfif #m# is "16">

  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fas fa-exclamation-triangle"></i> Password Required for LDAP Sync</h4>
    <cfoutput>This user has not yet been synchronized to LDAP. To complete the synchronization, you must set <strong>Set User Password</strong> to YES and enter a new password. The user's existing password cannot be migrated to LDAP.</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "17">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select a RemoteAuth Domain when Authentication Type is set to Remote</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "18">

<div class="alert alert-success alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  <cfoutput>Remote Auth System User was saved successfully</cfoutput>

</div>

<cfset session.m = 0>

</cfif>


<cfif #m# is "99">

      <div class="alert alert-danger alert-dismissible">
                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
                  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                  <cfoutput>The Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href="https://haveibeenpwned.com/Passwords" target="_blank">haveibeenpwned.com</a></cfoutput>
                </div>

                <cfset session.m = 0>
</cfif>


<cfif #m# is "100">

  <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>There was a problem accessing haveibeenpwned.com to check your password against previous data breaches. Either ensure Hermes SEG has outbound Internet access over 443 to <a href="https://api.pwnedpasswords.com">https://api.pwnedpasswords.com</a> OR set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO</cfoutput>
    </div>

    <cfset session.m = 0>

</cfif>



<!--- ERROR MESSAGES END HERE --->


<span>
  <p>       

<!--- BACK TO SYSTEM USERS BUTTON STARTS HERE --->
<a href="view_system_users.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to System Users</a>

<!--- BACK TO SYSTEM USERS CONNECTIONS BUTTON ENDS HERE --->

<!--- DELETE USER 2FA DEVICES BUTTON STARTS HERE --->

<cfoutput>
  <!-- Delete User devices Button-->
  <a href="##delete_devices_modal"  class="btn btn-danger" role="button" data-bs-toggle="modal" data-user="#getuser.username#"><i class="fa fa-mobile"></i>&nbsp;&nbsp;Delete 2FA Devices</a>
  </cfoutput>
<!--- DELETE USER 2FA DEVICES BUTTON STARTS HERE --->


<!--- DELETE USER BUTTON STARTS HERE --->

<!--- IF USER TO EDIT ID IS THE SAME AS USER LOGGED IN ID OR USER TO EDIT ID IS BUILT-IN USER THEN DON'T SHOW DELETE USER BUTTON --->
<cfif #session.userid# is "#theID#" OR #getuser.system# is "1">

<cfelse>

<cfoutput>
<!-- Delete User Button-->
<a href="##delete_modal"  class="btn btn-danger" role="button" data-bs-toggle="modal" data-user="#theId#"><i class="fa fa-trash"></i>&nbsp;&nbsp;Delete User</a>
</cfoutput>

<!--- /CFIF #session.userid# is "#theID#" OR #getuser.system# is "1" --->
</cfif>



<!--- DELETE USER BUTTON ENDS HERE --->



</p>


</span>


<!--- DELETE USER MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete System User </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this user? This action is irreversible! If you click <strong>Yes</strong>, the user and any Two Factor TOTP and Security Keys will be deleted. If the user has any Duo Devices, they must be manually deleted from the Duo Control Panel.</p>

      </div>
      <div class="modal-footer">
        <form name="delete_user" method="post">

          <input type="hidden" name="action" value="deleteuser">
          <input type="hidden" name="user" value=""/>

          
          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          
          
            </form>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE USER MODAL HTML ENDS HERE --->


<!--- DELETE USER DEVICES MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_devices_modal" tabindex="-1" role="dialog" aria-labelledby="deleteUserDevicesModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete 2FA Devices </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this user's 2FA Devices? This action is irreversible! If you click <strong>Yes</strong>, all user 2FA TOTP and Security Keys will be deleted. If the user has any Duo Devices, they must be manually deleted from the Duo Control Panel.</p>

      </div>
      <div class="modal-footer">
        <form name="delete_user" method="post">

          <input type="hidden" name="action" value="deleteuserdevices">
          <input type="hidden" name="user" value=""/>

          
          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          
          
            </form>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE USER DEVICES MODAL HTML ENDS HERE --->




<!-- EDIT SYSTEM USER FORM STARTS HERE -->


<!-- form start -->
  <form name="edit_system_users.cfm" method="post" action="">

  <input type="hidden" name="action" value="edituser">

    <div class="box-body">

<!--- LOGIN PREVIEW — updates live as admin fills the form so they
     know exactly what the system user will type to log in. --->
<cfoutput>
<div class="alert alert-primary mb-3" id="loginPreview">
  <h5 class="mb-2"><i class="icon fas fa-sign-in-alt"></i> Login Information (for this system user)</h5>
  <div class="row">
    <div class="col-md-4"><strong>URL</strong></div>
    <div class="col-md-8"><code id="lpUrl">https://#cgi.http_host#/admin/</code></div>
  </div>
  <div class="row">
    <div class="col-md-4"><strong>Username</strong></div>
    <div class="col-md-8"><code id="lpUsername"><cfif Len(Trim(theUsername))>#encodeForHTML(theUsername)#<cfelse>username</cfif></code> <small class="text-muted">&mdash; the bare username you enter below (not an email)</small></div>
  </div>
  <div class="row">
    <div class="col-md-4"><strong>Password</strong></div>
    <div class="col-md-8" id="lpPassword"><cfif theAuthType EQ "remote">The remote password from the selected RemoteAuth domain<cfelse>The password you set below</cfif></div>
  </div>
</div>
</cfoutput>

<!--- AUTHENTICATION TYPE (Pro Edition Only) - PLACED AT TOP OF FORM --->
<div class="form-group">
  <label><strong>Authentication Type</strong></label>
  <cfif remoteauthAvailable>
    <div class="alert alert-info">
      <h5><i class="icon fas fa-info-circle"></i> Remote Authentication</h5>
      <p>Select <strong>Remote</strong> to authenticate this user against an external AD/LDAP server. The user will not need a local password - authentication will be handled by the remote server configured in RemoteAuth settings.</p>
    </div>
    <select class="form-control" name="auth_type" data-placeholder="auth_type" style="width: 100%;" id="authType">
      <cfif theAuthType EQ "local">
        <option value="local" selected>Local</option>
        <option value="remote">Remote</option>
      <cfelse>
        <option value="remote" selected>Remote</option>
        <option value="local">Local</option>
      </cfif>
    </select>

    <!--- RemoteAuth Domain Selection (shown when Remote is selected) --->
    <div class="form-group mt-3" id="remoteauthDomainGroup" style="<cfif theAuthType NEQ 'remote'>display:none;</cfif>">
      <label><strong>RemoteAuth Domain</strong></label>
      <select class="form-control" name="remoteauth_domain" id="remoteauthDomain" style="width: 100%;">
        <option value="">-- Select Domain --</option>
        <cfloop array="#remoteauthDomains#" index="domainItem">
          <cfoutput>
          <option value="#domainItem.domain#" <cfif theRemoteauthDomain EQ domainItem.domain>selected</cfif>>#domainItem.domain# (#domainItem.server#)</option>
          </cfoutput>
        </cfloop>
      </select>
      <small class="text-muted">Select the domain this user will authenticate against</small>
    </div>
  <cfelse>
    <!--- RemoteAuth not available - show current auth type as disabled --->
    <input type="hidden" name="auth_type" value="#theAuthType#">
    <select class="form-control" name="auth_type_display" disabled style="width: 100%;">
      <cfif theAuthType EQ "remote">
        <option value="remote" selected>Remote</option>
      <cfelse>
        <option value="local" selected>Local</option>
      </cfif>
    </select>
    <small class="text-muted">
      <cfif theAuthType EQ "remote">
        This user uses Remote Authentication. Pro License required to modify authentication settings.
      <cfelseif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
        Remote Authentication requires Hermes SEG Pro Edition
      <cfelse>
        Remote Authentication requires RemoteAuth to be enabled with at least one domain mapping configured
      </cfif>
    </small>
  </cfif>
</div>
<!--- END AUTHENTICATION TYPE --->


      <div class="form-group">
        <label for="username"><strong>Username</strong></label>

        <!--- Warning for 2FA devices - always shown --->
        <div class="alert alert-warning" id="username2faWarning">
          <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
          <p>If the System User has 2FA Devices enrolled in the system (TOTP, Security Keys, Duo) <strong>DO NOT</strong> change the username unless you first <strong>delete all the user's 2FA devices</strong> by clicking the <strong>Delete 2FA Devices</strong> button above or the user will not be able to login with the new username. Please note that Duo devices must be manually removed from the Duo Control panel.</p>
        </div>

        <!--- Warning for Remote Auth username requirement - shown only when Remote is selected --->
        <div class="alert alert-warning" id="usernameRemoteWarning" style="<cfif theAuthType NEQ 'remote'>display:none;</cfif>">
          <h5><i class="icon fas fa-exclamation-triangle"></i> Important: Username Requirement</h5>
          <p>The <strong>Username</strong> must match the user's existing account name on the remote AD/LDAP server (e.g., <code>jsmith</code> or <code>john.smith</code>). The user will authenticate using their remote server credentials.</p>
        </div>

          <cfoutput>
        <input type="text" class="form-control" name="username" value="#theUsername#" id="username" placeholder="Username">
      </div>
      </cfoutput>

      
        <cfoutput>
            <div class="form-group">
              <label for="email"><strong>E-Mail Address</strong></label>
              <input type="text" class="form-control" name="email" value="#theEmail#" id="email" placeholder="E-Mail Address">
            </div>
            </cfoutput>

            <cfoutput>
              <div class="form-group">
                <label for="first_name"><strong>First Name</strong></label>
                <input type="text" class="form-control" name="first_name" value="#theFirstName#" id="first_name" placeholder="First Name">
              </div>
              </cfoutput>       

              <cfoutput>
                <div class="form-group">
                  <label for="last_name"><strong>Last Name</strong></label>
                  <input type="text" class="form-control" name="last_name" value="#theLastName#" id="last_name" placeholder="Last Name">
                </div>
                </cfoutput>      


                <div class="form-group">
                  <label><strong>Access Control Policy</strong></label>
          
                  <div class="alert alert-warning">
                    <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
                    <p>Before setting <strong>Access Control Policy</strong> to <strong>Two Factor</strong> ensure you first read the <a href="##" onClick="window.open('https://docs.deeztek.com/books/administrator-guide/page/system-users#bkmrk-access-control-polic', '_blank')">Access Control Policy Documentation</a>, ensure e-mail delivery works as expected and the e-mail addresses for this System User is correct.</p>
                    </div>
              
                  <select class="form-control" name="access_control" data-placeholder="access_control" style="width: 100%;"  id="access_control">
                    <cfif #theAccessControl# is "one_factor">                           
                      <option value="one_factor" selected>One Factor</option>
                      <option value="two_factor">Two Factor</option>
          
                    <cfelseif #theAccessControl# is "two_factor">
                      <option value="two_factor" selected>Two Factor</option>
                      <option value="one_factor">One Factor</option>
                   
                    </cfif>
                      </select>   
                
                    </div>

  <!--- Hide password fields for remote auth users --->
  <cfif theAuthType NEQ "remote">
  <div class="form-group" id="setPasswordGroup">
    <label><strong>Set User Password</strong></label>

    <select class="form-control" name="setpassword" data-placeholder="setpassword" style="width: 100%;"  id="setUserPassword">
      <cfif #setPassword# is "NO">
        <option value="NO" selected>NO</option>
        <option value="YES">YES</option>
      <cfelseif #setPassword# is "YES">
        <option value="YES" selected>YES</option>
        <option value="NO">NO</option>
      </cfif>
        </select>

      </div>
  <cfelse>
    <!--- Remote auth user - no local password needed --->
    <input type="hidden" name="setpassword" value="NO">
    <input type="hidden" name="hibp" value="NO">
    <input type="hidden" name="password" value="">
  </cfif>





<cfif theAuthType NEQ "remote">
<cfif #setPassword# is "NO">



                          <div class="form-group" id="UserPassword" style="display:none;">
                            <label><strong>Check Password Against haveibeenpwned.com</strong></label>
                         <!---
                            <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                          --->
                            <select class="form-control select2" name="hibp" data-placeholder="hibp" style="width: 100%;">
                            
                          <cfif #checkHibp# is "NO">                         
                              <option value="NO" selected>NO</option>
                              <option value="YES">YES</option>
                            <cfelseif #checkHibp# is "YES">
                              <option value="YES" selected>YES</option>
                              <option value="NO">NO</option>
                            </cfif>
                              </select>   

                              
                              <cfoutput>
                                <div class="form-group" id="userpasswordfield">
                                  <label for="password"><strong>User Password</strong></label>
                                  <div class="input-group">
                                  <input type="password" class="form-control" name="password" value="#thePassword#" id="password" placeholder="Enter the password for Username above" maxLength="64">
                                  <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                </div>
                                </div>
                                </cfoutput> 

                              </div>


                            <cfelse>
                            

                              <div class="form-group" id="UserPassword">
                                <label><strong>Check Password Against haveibeenpwned.com</strong></label>
                             <!---
                                <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                              --->
                                <select class="form-control select2" name="hibp" data-placeholder="hibp" style="width: 100%;">
                                
                              <cfif #checkHibp# is "NO">                         
                                  <option value="NO" selected>NO</option>
                                  <option value="YES">YES</option>
                                <cfelseif #checkHibp# is "YES">
                                  <option value="YES" selected>YES</option>
                                  <option value="NO">NO</option>
                                </cfif>
                                  </select>  

                                  <cfoutput>
                                    <div class="form-group" id="userpasswordfield">
                                      <label for="password"><strong>User Password</strong></label>
                                      <div class="input-group">
                                      <input type="password" class="form-control" name="password" value="#thePassword#" id="password" placeholder="Enter the password for Username above">
                                      <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                    </div>
                                    </div>
                                    </cfoutput> 

                                  </div>

                  <!--- /CFIF for #setpassword# is YES or NO --->
                </cfif>
<!--- /CFIF for theAuthType NEQ remote (password fields) --->
</cfif>





<!--- <p class="help-block">Help Block Text</p> --->


<input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">


  </form>

  <div>&nbsp;</div>


<!-- EDIT SYSTEM USER FORM ENDS HERE -->

</div>
</div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>


<!--- SCRIPT TO SHOW/HIDE REMOTE AUTH DOMAIN AND PASSWORD FIELDS STARTS HERE --->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const authTypeSelect = document.getElementById('authType');
    const remoteauthDomainGroup = document.getElementById('remoteauthDomainGroup');
    const usernameRemoteWarning = document.getElementById('usernameRemoteWarning');
    const setPasswordGroup = document.getElementById('setPasswordGroup');
    const userPasswordDiv = document.getElementById('UserPassword');
    const setUserPasswordSelect = document.getElementById('setUserPassword');

    function updateFormForAuthType() {
        if (!authTypeSelect) return;

        if (authTypeSelect.value === 'remote') {
            // Show domain selector and username warning, hide password fields
            if (remoteauthDomainGroup) remoteauthDomainGroup.style.display = '';
            if (usernameRemoteWarning) usernameRemoteWarning.style.display = '';
            if (setPasswordGroup) setPasswordGroup.style.display = 'none';
            if (userPasswordDiv) userPasswordDiv.style.display = 'none';
        } else {
            // Hide domain selector and username warning, show password fields
            if (remoteauthDomainGroup) remoteauthDomainGroup.style.display = 'none';
            if (usernameRemoteWarning) usernameRemoteWarning.style.display = 'none';
            if (setPasswordGroup) setPasswordGroup.style.display = '';
            // Show/hide password based on setUserPassword value
            if (setUserPasswordSelect && setUserPasswordSelect.value === 'YES') {
                if (userPasswordDiv) userPasswordDiv.style.display = '';
            }
        }
    }

    if (authTypeSelect) {
        authTypeSelect.addEventListener('change', updateFormForAuthType);
        // Run on page load
        updateFormForAuthType();
    }

    // ============================================================
    // LOGIN PREVIEW — keep in sync with username + auth type.
    // URL is always /admin/ for system users.
    // ============================================================
    function updateLoginPreview() {
        var usernameField = document.getElementById('username');
        var username = usernameField ? usernameField.value.trim() : '';
        var lpUsername = document.getElementById('lpUsername');
        if (lpUsername) lpUsername.textContent = username || 'username';

        var lpPassword = document.getElementById('lpPassword');
        if (!lpPassword) return;
        if (authTypeSelect && authTypeSelect.value === 'remote') {
            var rdSelect = document.getElementById('remoteauthDomain');
            var rdText = rdSelect && rdSelect.options[rdSelect.selectedIndex]
                       ? rdSelect.options[rdSelect.selectedIndex].text
                       : '';
            rdText = rdText.replace(/\s*\(.+\)\s*$/, '');
            if (!rdText || rdText === '-- Select Domain --') rdText = 'the selected RemoteAuth domain';
            lpPassword.innerHTML = 'The <strong>remote password</strong> from <code>' + rdText + '</code> (their AD/LDAP account password).';
        } else {
            lpPassword.innerHTML = 'The <strong>local password</strong> you set below.';
        }
    }

    var unameEl = document.getElementById('username');
    if (unameEl) unameEl.addEventListener('input', updateLoginPreview);
    if (authTypeSelect) authTypeSelect.addEventListener('change', updateLoginPreview);
    var rdEl = document.getElementById('remoteauthDomain');
    if (rdEl) rdEl.addEventListener('change', updateLoginPreview);
    updateLoginPreview();
});
</script>
<!--- SCRIPT TO SHOW/HIDE REMOTE AUTH DOMAIN AND PASSWORD FIELDS ENDS HERE --->

<!--- SCRIPT TO SHOW/HIDE SET USER PASSWORD SCRIPT STARTS HERE  --->
<script>
document.getElementById('setUserPassword')?.addEventListener('change', function() {
    const userPasswordDiv = document.getElementById('UserPassword');
    const authTypeSelect = document.getElementById('authType');
    // Only show password fields if auth type is local
    if (!authTypeSelect || authTypeSelect.value === 'local') {
        if (this.value === 'YES') {
            userPasswordDiv.style.display = '';
        } else {
            userPasswordDiv.style.display = 'none';
        }
    }
});
</script>
<!--- SCRIPT TO SHOW/HIDE SET USER PASSWORD SCRIPT ENDS HERE  --->




<!--- DELETE USER MODAL SCRIPT STARTS HERE  --->
<script>
document.getElementById('delete_modal')?.addEventListener('show.bs.modal', function(e) {
    const user = e.relatedTarget.dataset.user;
    this.querySelector('input[name="user"]').value = user;
});
</script>
<!--- DELETE USER MODAL SCRIPT ENDS HERE  --->

<!--- DELETE USER 2FA DEVICES MODAL SCRIPT STARTS HERE  --->
<script>
document.getElementById('delete_devices_modal')?.addEventListener('show.bs.modal', function(e) {
    const user = e.relatedTarget.dataset.user;
    this.querySelector('input[name="user"]').value = user;
});
</script>
<!--- DELETE USER 2FA DEVICES MODAL SCRIPT ENDS HERE  --->

 


</html>