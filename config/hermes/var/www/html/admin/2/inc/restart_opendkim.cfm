
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

<!--- SET PERMISSIONS IN /ETC/OPENDKIM.CONF FILE --->
<cftry>

 <cfexecute name = "/usr/local/bin/docker"
 arguments="exec hermes_postfix_dkim /bin/chown opendkim:opendkim /etc/opendkim.conf"
timeout = "240">
</cfexecute>


 <cfcatch type="any">


    <cfset m="Reload Opendkim: There was an error running chown opendkim:opendkim /etc/opendkim.conf">
    <cfinclude template="error.cfm">
    <cfabort>   

  </cfcatch>


 </cftry>

<!--- SET PERMISSIONS IN /opt/hermes/dkim/ --->
<cftry>

 <cfexecute name = "/usr/local/bin/docker"
 arguments="exec hermes_postfix_dkim /bin/chown -R opendkim:opendkim /opt/hermes/dkim/"
timeout = "240">
</cfexecute>


 <cfcatch type="any">


    <cfset m="Reload Opendkim: There was an error running chown opendkim:opendkim /etc/opendkim.conf">
    <cfinclude template="error.cfm">
    <cfabort>   

  </cfcatch>


 </cftry>

<!--- Restart OpenDKIM service inside the container (not the whole container) --->
<cftry>
<cfexecute name="/usr/local/bin/docker"
  arguments="exec hermes_postfix_dkim service opendkim restart"
  timeout="240"
  variable="dkimOutput"
  errorVariable="dkimError" />
<cfcatch type="any">
  <cfset m="Restart OpenDKIM: There was an error restarting OpenDKIM service. Error was #cfcatch.message#">
  <cfinclude template="error.cfm">
  <cfabort>
</cfcatch>
</cftry>

      
