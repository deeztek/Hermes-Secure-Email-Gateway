
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


<cftry>
  

    <cfexecute name = "/usr/bin/spamassassin --lint"
    timeout = "10"
    variable="salint">
    </cfexecute>

    <cfcatch type="any">
    
    <cfoutput>    
    <cfset m="Test Spamassassin: Error #salint# while testing Spamassassin Configuration ">
    </cfoutput>

    <cfinclude template="error.cfm">
    <cfabort>   
                
    </cfcatch>
    </cftry>


<cftry>
  

    <cfexecute name = "/bin/systemctl restart spamassassin"
    timeout = "10"
    outputfile ="/dev/null">
    </cfexecute>

    <cfcatch type="any">
                
    <cfset m="Restart Spamassassin: There was an error restarting Spamassassin">
    <cfinclude template="error.cfm">
    <cfabort>   
                
    </cfcatch>
    </cftry>