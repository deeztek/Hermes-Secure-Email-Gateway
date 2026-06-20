<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.
--->

<!---
HEADLESS NGINX VHOST REGENERATION (#186).

Re-renders the console + per-domain mailbox vhosts from the templates at
/opt/hermes/templates/* (picking up template changes such as the Link Guard
`/lg/` public location) and restarts nginx so the new config takes effect.

This is the curl-able counterpart to the admin-UI regeneration that fires on a
Console Settings / cert / mailbox-domain change. It exists so an UPGRADE can
land template changes without a manual admin action &mdash; editing a vhost
template does NOT update already-generated vhosts, and a plain `nginx -s reload`
of a stale vhost does nothing.

Invoked headlessly (from the update orchestrator) via:
    docker exec hermes_commandbox curl -s http://localhost:8888/schedule/regen_nginx_config.cfm

Mirrors the established schedule-page pattern in `acme_validate_ip.cfm`, which
already includes these same two helpers headlessly. The helpers use only
absolute paths + `datasource="hermes"` (provided by the schedule app), so they
run correctly outside the admin session context.

Prints `LINKGUARD_NGINX_REGEN_OK` on success; the orchestrator greps for it.
--->

<cfsetting requesttimeout="300">

<!--- Regenerate console + mailbox vhosts from the templates. --->
<cfinclude template="../admin/2/inc/generate_nginx_configuration.cfm">

<!--- Restart nginx so the regenerated vhosts take effect. --->
<cfinclude template="../admin/2/inc/restart_nginx.cfm">

<cfoutput>LINKGUARD_NGINX_REGEN_OK</cfoutput>
