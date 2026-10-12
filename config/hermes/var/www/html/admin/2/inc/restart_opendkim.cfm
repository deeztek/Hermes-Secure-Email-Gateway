
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

<!--- Restart the CONTAINER, not the opendkim service.

     `docker exec hermes_postfix_dkim service opendkim restart` was silently
     broken and left the box permanently unable to load DKIM changes:

       opendkim: Unable to bind to port inet:8891@127.0.0.1: Address already
                 in use
       opendkim: smfi_opensocket() failed

     The stop half failed to kill the running instance, then the start half
     launched a new process which wrote ITS pid into
     /run/opendkim/opendkim.pid before failing to bind and exiting. The pid
     file was left pointing at a dead process, so every later stop looked for
     a pid that no longer existed, reported success, and left the original
     instance running with its original configuration. Once a box reached that
     state, no DKIM settings change could ever take effect again.

     Restarting the container is the correct fix rather than a bigger hammer:

       - #232 runs TWO opendkim instances -- the sysvinit-managed one on 8891
         and a sign-only instance started directly by the entrypoint with
         `-x /etc/opendkim-sign.conf` on 8892. The entrypoint is the only place
         that knows how to bring both up; reimplementing that here, including
         telling the two apart to avoid killing the signer, would be inventing
         a second source of truth for something the image already does.
       - It cannot be poisoned by a stale pid file, and it repairs a box that
         is already in that state.
       - It is the documented pattern for this service (see CLAUDE.md).

     Unlike nginx, postfix does not serve the admin console, so restarting it
     does not cut the request that triggered it and needs no holding page. The
     cost is a few seconds during which SMTP refuses connections; senders
     retry, and this only happens on an explicit settings save. --->
<cftry>
<cfexecute name="/usr/local/bin/docker"
  arguments="container restart hermes_postfix_dkim"
  timeout="240"
  variable="dkimOutput"
  errorVariable="dkimError" />
<cfcatch type="any">
  <cfset m="Restart OpenDKIM: There was an error restarting the hermes_postfix_dkim container. Error was #cfcatch.message#">
  <cfinclude template="error.cfm">
  <cfabort>
</cfcatch>
</cftry>

<!--- WAIT FOR POSTFIX TO COME BACK UP.

     `docker container restart` returns as soon as the container process is
     running, but the entrypoint takes a few more seconds to start Postfix.
     Callers that go straight on to generate_postfix_configuration.cfm (the
     DKIM Settings save) ran its closing `postfix reload` in that window,
     which fails with "the Postfix mail system is not running": the settings
     were saved but the new main.cf was never loaded. 9c98df65 made that
     failure report cleanly; this removes the cause.

     Waiting here rather than reordering the caller: dkim_set_settings.cfm
     toggles the :8891 milter rows BEFORE restarting, so the generator must
     run after it. `postfix status` exits non-zero until the master is up,
     which cfexecute raises, hence the cftry per attempt. Bounded at 30
     seconds; if Postfix is still down after that, carry on and let the
     generator report it as before. --->
<cfset postfixUp = false>
<cfloop from="1" to="30" index="postfixWait">
  <cftry>
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim /usr/sbin/postfix status"
      timeout="10"
      variable="postfixStatusOutput"
      errorVariable="postfixStatusError" />
    <cfset postfixUp = true>
    <cfcatch type="any"></cfcatch>
  </cftry>
  <cfif postfixUp>
    <cfbreak>
  </cfif>
  <cfscript>
    thread = CreateObject("java", "java.lang.Thread");
    thread.sleep(1000);
  </cfscript>
</cfloop>
<cfif NOT postfixUp>
  <cflog file="hermes" type="warning"
         text="restart_opendkim: Postfix was not running 30 seconds after restarting hermes_postfix_dkim">
</cfif>

      
