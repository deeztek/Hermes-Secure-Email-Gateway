
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

<!--- SET PERMISSIONS IN /ETC/OPENDMARC/ DIRECTORY --->
<cftry>
  

    <cfexecute name = "/bin/chown"
    timeout = "240"
    arguments = "-R opendmarc:opendmarc /etc/opendmarc/"
    outputfile ="/dev/null">
    </cfexecute>

    <cfcatch type="any">
                
    <cfset m="Reload Opendmarc: There was an error running chown -R opendmarc:opendmarc /etc/opendmarc">
    <cfinclude template="error.cfm">
    <cfabort>   
                
    </cfcatch>
    </cftry>

    <!--- RESTART OPENDMARC --->
<cftry>
  

    <cfexecute name = "/bin/systemctl reload opendmarc"
    timeout = "240"
    outputfile ="/dev/null">
    </cfexecute>

    <cfcatch type="any">
                
    <cfset m="Reload Opendmarc: There was an error re-loading Opendmarc">
    <cfinclude template="error.cfm">
    <cfabort>   
                
    </cfcatch>
    </cftry>

      
