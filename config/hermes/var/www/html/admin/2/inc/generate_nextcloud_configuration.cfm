

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

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- GET SERVER URL FOR TRUSTED DOMAIN --->
<cfquery name="getconsolehost" datasource="hermes">
  select value2 from parameters2 where module = 'console' and parameter = 'console.host'
</cfquery>
<cfset consoleHost = getconsolehost.value2>

<!--- READ NEXTCLOUD CREDENTIALS FROM CREDENTIAL FILES --->
<cffile action="read" file="/opt/hermes/creds/nextcloud_redis_password" variable="ncRedisPassword">
<cfset ncRedisPassword = Trim(ncRedisPassword)>
<cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncDbUser">
<cfset ncDbUser = Trim(ncDbUser)>
<cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncDbPassword">
<cfset ncDbPassword = Trim(ncDbPassword)>

<!--- DERIVE MAIL DOMAIN FROM CONSOLE HOST (e.g., smtp-dev.deeztek.com → deeztek.com) --->
<cfset ncMailDomain = ListRest(consoleHost, ".")>

<!--- GET HOST IP from parameters2 (managed from Server Setup page) --->
<cfquery name="getHostIP" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'server_ip' AND module = 'network'
</cfquery>
<cfset ncHostIP = getHostIP.value2>

<!--- READ EXISTING NEXTCLOUD CONFIG TO EXTRACT INSTALLATION-SPECIFIC VALUES --->
<cfset ncPasswordSalt = "">
<cfset ncSecret = "">
<cfset ncInstanceId = "">
<cfset ncVersion = "">
<cftry>
  <cffile action="read" file="/mnt/data/nextcloud/config/config.php" variable="existingConfig">

  <!--- Extract passwordsalt --->
  <cfset saltMatch = REFind("'passwordsalt'\s*=>\s*'([^']*)'", existingConfig, 1, true)>
  <cfif saltMatch.pos[1] GT 0>
    <cfset ncPasswordSalt = Mid(existingConfig, saltMatch.pos[2], saltMatch.len[2])>
  </cfif>

  <!--- Extract secret --->
  <cfset secretMatch = REFind("'secret'\s*=>\s*'([^']*)'", existingConfig, 1, true)>
  <cfif secretMatch.pos[1] GT 0>
    <cfset ncSecret = Mid(existingConfig, secretMatch.pos[2], secretMatch.len[2])>
  </cfif>

  <!--- Extract instanceid --->
  <cfset instanceMatch = REFind("'instanceid'\s*=>\s*'([^']*)'", existingConfig, 1, true)>
  <cfif instanceMatch.pos[1] GT 0>
    <cfset ncInstanceId = Mid(existingConfig, instanceMatch.pos[2], instanceMatch.len[2])>
  </cfif>

  <!--- Extract version - CRITICAL: Nextcloud compares this against the
       installed code version on every page load. If it's missing, lower
       than the code version, or hardcoded to a stale value, NC bounces to
       the upgrade screen. We must preserve whatever the live config says
       so the regenerator never causes a phantom upgrade prompt. --->
  <cfset versionMatch = REFind("'version'\s*=>\s*'([^']*)'", existingConfig, 1, true)>
  <cfif versionMatch.pos[1] GT 0>
    <cfset ncVersion = Mid(existingConfig, versionMatch.pos[2], versionMatch.len[2])>
  </cfif>

  <cfcatch type="any">
    <!--- Existing config not found (fresh install) - values will remain empty --->
  </cfcatch>
</cftry>

<!--- READ NEXTCLOUD CONFIG.PHP TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/config.php" variable="config">

<!--- REPLACE ALL PLACEHOLDERS --->
<!--- Credentials from credential files --->
<cfset config = Replace(config, "NEXTCLOUD_REDIS_PASSWORD", ncRedisPassword, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_DB_USER", ncDbUser, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_DB_PASSWORD", ncDbPassword, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_MAIL_DOMAIN", ncMailDomain, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_TRUSTED_DOMAIN_IP", ncHostIP, "ALL")>

<!--- Domain/host from database --->
<cfset config = Replace(config, "NEXTCLOUD_TRUSTED_DOMAIN_HOST", consoleHost, "ALL")>

<!--- Installation-specific values from existing config --->
<cfset config = Replace(config, "NEXTCLOUD_PASSWORD_SALT", ncPasswordSalt, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_SECRET", ncSecret, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_INSTANCE_ID", ncInstanceId, "ALL")>
<cfset config = Replace(config, "NEXTCLOUD_VERSION", ncVersion, "ALL")>

<!--- WRITE GENERATED CONFIG --->
<cffile action="write" file="/opt/hermes/tmp/#customtrans3#_config.php" output="#config#">

<!--- BACKUP EXISTING CONFIG.PHP FILE --->
<cftry>
  <cffile action="copy"
    source="/mnt/data/nextcloud/config/config.php"
    destination="/mnt/data/nextcloud/config/config.HERMES">
  <cfcatch type="any">
    <!--- No existing config to backup (fresh install) --->
  </cfcatch>
</cftry>

<!--- REPLACE EXISTING CONFIG.PHP FILE WITH NEWLY GENERATED ONE --->
<cffile action="move"
  source="/opt/hermes/tmp/#customtrans3#_config.php"
  destination="/mnt/data/nextcloud/config/config.php">

<!--- GIVE PROPER PERMISSIONS TO CONFIG.PHP --->
<cftry>
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_nextcloud /usr/bin/chown www-data:www-data /var/www/html/config/config.php"
    timeout="240">
  </cfexecute>

  <cfcatch type="any">
    <cfset m="Nextcloud: There was an error setting permissions to /var/www/html/config/config.php">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfcatch>
</cftry>
