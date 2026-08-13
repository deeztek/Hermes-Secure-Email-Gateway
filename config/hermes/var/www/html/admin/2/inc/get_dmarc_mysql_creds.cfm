
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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


   <!--- GET MYSQL OPENDMARC CREDENTIALS BELOW

     /opt/hermes/creds is the source of truth for service credentials.

     This used to read system_settings.mysql_username_opendmarc and
     mysql_password_opendmarc (password AES-encrypted with
     /opt/hermes/keys/hermes.key). The installer never writes those rows: it
     generates opendmarc_username / opendmarc_password into the creds directory
     and creates the DB user from them. hermes_install.sql seeds both rows as ''
     because the baseline was sanitised from a DEV dump, and DEV had real values
     there from however it was first set up. So the row is populated on DEV and
     empty on every fresh install, and saving DMARC settings aborted with
     "opendmarc mysql username empty".

     Reading the creds files removes the second source of truth and matches the
     rest of the current code, e.g. generate_postfix_configuration.cfm reads
     /opt/hermes/creds/hermes_username and hermes_password the same way. No
     decryption is involved because the files are the primary store.

     Of the eight credential rows the baseline seeds empty (hermes, opendmarc,
     djigzo, syslog x username/password), this was the only one read on a normal
     operational path. The others are touched only by the credential-rotation
     pages, whose purpose is to set them. The two rows are left in place rather
     than dropped, because update_opendmarc_db_creds.cfm,
     validate_opendmarc_db_creds_pass_variables.cfm and
     update_all_file_db_creds.cfm still reference them and the rotation flow
     needs checking before they can be retired. --->

   <cfset _dmarcUserFile = "/opt/hermes/creds/opendmarc_username">
   <cfset _dmarcPassFile = "/opt/hermes/creds/opendmarc_password">

   <cfloop array="#[_dmarcUserFile, _dmarcPassFile]#" index="_dmarcCredFile">
      <cfif NOT FileExists(_dmarcCredFile)>
         <cfset m="get_dmarc_mysql_creds: #_dmarcCredFile# does not exist. The installer creates it; re-run './scripts/install_hermes_docker.sh --init-db' or restore it from backup.">
         <cfinclude template="error.cfm">
         <cfabort>
      </cfif>
   </cfloop>

   <cffile action="read" file="#_dmarcUserFile#" variable="mysqlusernameopendmarc" charset="utf-8">
   <cfset mysqlusernameopendmarc = Trim(mysqlusernameopendmarc)>

   <cffile action="read" file="#_dmarcPassFile#" variable="mysqlpasswordopendmarc" charset="utf-8">
   <cfset mysqlpasswordopendmarc = Trim(mysqlpasswordopendmarc)>

   <cfif mysqlusernameopendmarc EQ "">
      <cfset m="get_dmarc_mysql_creds: #_dmarcUserFile# is empty">
      <cfinclude template="error.cfm">
      <cfabort>
   </cfif>

   <cfif mysqlpasswordopendmarc EQ "">
      <cfset m="get_dmarc_mysql_creds: #_dmarcPassFile# is empty">
      <cfinclude template="error.cfm">
      <cfabort>
   </cfif>

   <!--- GET MYSQL OPENDMARC CREDENTIALS ABOVE --->
