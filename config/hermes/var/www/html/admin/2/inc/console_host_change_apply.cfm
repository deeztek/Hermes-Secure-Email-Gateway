
<!---
Hermes Secure Email Gateway - Apply a Console Host Change

Fires the Nginx container restart and then holds the operator on a page that
waits for the new hostname to come up, instead of redirecting them into it.

WHY THIS EXISTS

Changing the console host used to lock the operator out every time. The save
path restarted Authelia, whose session cookie is scoped to a single domain
(session.cookies[].domain), so the instant it came back on the new hostname
there was no session configuration for the old one. It then handed the browser
a redirect to preload_restart_nginx.cfm to do the Nginx restart. That page, and
the inc/restart_nginx_post.cfm its JavaScript calls, both live under /admin/2/
and are auth-protected, so neither could load: the only thing that triggers the
Nginx restart sat behind the auth flow the hostname change had just invalidated.
Nginx kept serving the previous portal URL indefinitely, the operator got
"unable to determine user state" against the OLD host, and the only way back in
was restarting hermes_nginx by hand from the Docker host (#294).

This hit every new install, not an edge case: install_hermes_docker.sh sets
console.host to the host IP on purpose because DNS does not exist yet, and
expects the administrator to change it afterwards, so this was step one of every
deployment.

Two constraints follow, and they are what shape this file:

  1. The restart has to be triggered by THIS request, the last one that is still
     authenticated. Nothing after this point can rely on reaching /admin/2/.
  2. It has to be a container restart, not `nginx -s reload`. A reload does not
     reliably pick up a newly selected certificate, and a console host change
     normally comes with one.

Because a container restart drops the listening socket, the browser must
already be holding a rendered page when it happens. That is why this emits the
holding page as the response to the save itself rather than redirecting: a
redirect would need a second request that no longer authenticates.

The page then waits out the restart before sending the operator to the new
hostname. That ordering matters. restart_nginx.sh sleeps 10 seconds before
restarting so the current response can finish, which it does in milliseconds,
but a plain redirect would put the operator at a login form roughly when the
restart lands, so their credentials would post into a dead socket. Waiting here
means their login happens after Nginx is back and settled.

Layout note: html_head, the navbar and the sidebar are already emitted by
view_console_settings.cfm before its action handlers run, so this closes the
layout itself (</main> then main_footer.cfm, which closes .app-wrapper) and
aborts.

Expects: newConsoleHost (the value that actually landed in the database).
--->

<cfinclude template="generate_customtrans.cfm">

<!--- Launch restart_nginx.sh detached. It sleeps 10s, then restarts the
     container. A temp wrapper is used because backgrounding needs a shell
     redirect, and quoting those inside cfexecute's arguments is unreliable. --->
<cfset restartScript = "/opt/hermes/tmp/#customtrans3#_restart_nginx_detached.sh">

<!--- Built by concatenation rather than written straight into cffile's output
     attribute: the body carries a shell redirect, and a bare '>' inside a tag
     attribute is exactly the kind of thing that bites here. Same reason the
     rest of this codebase assembles shell scripts with & and chr(10). --->
<cfset restartBody = "##!/bin/bash" & chr(10)
    & "nohup /opt/hermes/scripts/restart_nginx.sh " & chr(62) & "/dev/null 2" & chr(62) & "&1 &" & chr(10)>

<cffile action="write" file="#restartScript#" output="#restartBody#" addnewline="no">

<cfset restartProblem = "">

<cftry>
  <cfexecute name="/usr/bin/dos2unix" arguments="#restartScript#" timeout="10" />
  <cfexecute name="/bin/chmod" arguments="+x #restartScript#" timeout="10" />
  <cfexecute name="/bin/bash" arguments="#restartScript#" timeout="15"
      variable="restartOut" errorVariable="restartErr" />
  <cfset restartFired = true>

  <cfcatch type="any">
    <cfset restartFired = false>
    <cfset restartProblem = cfcatch.message>
  </cfcatch>
</cftry>

<cfset nh = Trim(newConsoleHost)>

<!--- view_console_settings.cfm has already opened, and not closed:
       body > .app-wrapper > main.app-main > .app-content > .container-fluid
     so this renders inside the open .container-fluid, then closes
     .container-fluid, .app-content and main. main_footer.cfm closes
     .app-wrapper. --->
<cfoutput>
<cfif NOT restartFired>
    <div class="callout callout-danger">
      <h5><i class="fas fa-times-circle"></i> Nginx restart could not be started</h5>
      <p class="mb-1">Your settings are saved and the configuration files have been
      written, but Nginx is still serving the previous configuration, so the console
      is still reachable only at its old address.</p>
      <p class="mb-1">Restart it from the Docker host to finish the change:</p>
      <pre class="mb-1">docker container restart hermes_nginx</pre>
      <p class="mb-0">Then open <strong>https://#HTMLEditFormat(nh)#/admin/</strong>.
      Error was: #HTMLEditFormat(restartProblem)#</p>
    </div>
<cfelse>
    <div class="row justify-content-center">
      <div class="col-md-8">
        <div class="card card-primary card-outline mt-4">
          <div class="card-header">
            <h3 class="card-title"><i class="fas fa-sync fa-spin"></i> Applying the new console address</h3>
          </div>
          <div class="card-body text-center">
            <p class="mb-3">The console address is now
            <strong>#HTMLEditFormat(nh)#</strong>.</p>
            <p class="mb-3">Nginx is restarting to pick up the new address and
            certificate. This page will move you to the new address once it is
            back, usually within half a minute. <strong>Do not close this tab.</strong></p>
            <div class="progress mb-3">
              <div id="hostChangeBar" class="progress-bar progress-bar-striped progress-bar-animated"
                   role="progressbar" style="width: 5%"></div>
            </div>
            <p id="hostChangeStatus" class="text-muted mb-3">Waiting for Nginx to restart...</p>
            <p class="text-muted small mb-0">You will need to sign in again, because your
            session belonged to the previous address. If the certificate you selected does
            not cover #HTMLEditFormat(nh)#, your browser will warn you about it.</p>
            <p id="hostChangeManual" class="mt-3 mb-0" style="display:none">
              <a class="btn btn-primary" href="https://#HTMLEditFormat(nh)#/admin/">
                Continue to https://#HTMLEditFormat(nh)#/admin/</a>
            </p>
          </div>
        </div>
      </div>
    </div>

  <script>
  (function () {
    var host   = '#EncodeForJavaScript(nh)#';
    var probe  = 'https://' + host + '/';
    var target = 'https://' + host + '/admin/';
    var bar    = document.getElementById('hostChangeBar');
    var status = document.getElementById('hostChangeStatus');
    var manual = document.getElementById('hostChangeManual');

    // restart_nginx.sh sleeps 10s before restarting, so a probe fired earlier
    // than that would succeed against the OLD Nginx and send the operator
    // straight into the restart. Start after the sleep has elapsed, and require
    // two consecutive successes so a reply from a process on its way down does
    // not count.
    var START_DELAY = 15000;
    var INTERVAL    = 2000;
    var GIVE_UP     = 120000;

    var hits = 0, waited = START_DELAY;

    function bail() {
      status.textContent = 'Nginx is taking longer than expected. Use the button below, ' +
                           'or restart hermes_nginx from the Docker host.';
      bar.classList.remove('progress-bar-animated');
      bar.style.width = '100%';
      manual.style.display = 'block';
    }

    function tick() {
      if (waited > GIVE_UP) { bail(); return; }
      bar.style.width = Math.min(95, (waited / GIVE_UP) * 100) + '%';
      // no-cors: this is a cross-origin liveness probe, so the response is
      // opaque on purpose. Resolving at all means something answered.
      fetch(probe, { mode: 'no-cors', cache: 'no-store' })
        .then(function () {
          hits++;
          if (hits >= 2) {
            status.textContent = 'Nginx is back. Taking you to ' + host + '...';
            bar.style.width = '100%';
            window.location.href = target;
          } else {
            status.textContent = 'Nginx is answering, confirming...';
            waited += INTERVAL;
            setTimeout(tick, INTERVAL);
          }
        })
        .catch(function () {
          hits = 0;
          status.textContent = 'Nginx is down, waiting for it to come back...';
          waited += INTERVAL;
          setTimeout(tick, INTERVAL);
        });
    }

    setTimeout(tick, START_DELAY);
  })();
  </script>
</cfif>

</div><!-- /.container-fluid, opened by view_console_settings.cfm -->
</div><!-- /.app-content -->
</main>
</cfoutput>

<!--- Closes .app-wrapper. --->
<cfinclude template="main_footer.cfm">
<cfabort>
