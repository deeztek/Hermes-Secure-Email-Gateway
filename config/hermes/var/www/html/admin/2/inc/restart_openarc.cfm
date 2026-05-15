<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- Reload OpenARC after KeyTable / SigningTable / openarc.conf changes.
      Mirrors restart_opendkim.cfm. Three steps:
        1. chown /etc/openarc to openarc:openarc
        2. chown -R /opt/hermes/arc/ to openarc:openarc
        3. restart the whole hermes_openarc container (no in-container init system
           to do `service openarc restart`, so a container restart is the
           cleanest reload path) --->

<!--- 1. PERMISSIONS ON /etc/openarc/ --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_openarc /bin/chown -R openarc:openarc /etc/openarc"
        timeout="240">
    </cfexecute>
    <cfcatch type="any">
        <cfset m="Reload OpenARC: error running chown openarc:openarc /etc/openarc">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- 2. PERMISSIONS ON /opt/hermes/arc/ --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_openarc /bin/chown -R openarc:openarc /opt/hermes/arc/"
        timeout="240">
    </cfexecute>
    <cfcatch type="any">
        <cfset m="Reload OpenARC: error running chown openarc:openarc /opt/hermes/arc/">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- 3. RESTART THE OPENARC CONTAINER --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="container restart hermes_openarc"
        timeout="240"
        variable="arcOutput"
        errorVariable="arcError" />
    <cfcatch type="any">
        <cfset m="Restart OpenARC: error restarting hermes_openarc container. Error: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>
