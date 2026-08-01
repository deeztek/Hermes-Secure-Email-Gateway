<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.
--->

<!---
HEADLESS OFELIA SCHEDULE REGENERATION (#288).

Re-renders /etc/ofelia/config.ini from the `ofelia_jobs` table (the source of
truth for the scheduler) and restarts hermes_ofelia so the jobs take effect.

This is the curl-able counterpart to the admin-UI regeneration that fires on a
Scheduled Tasks toggle or an SPF / DMARC / ACME / malware-feeds save. It exists
because NOTHING regenerated the file on a fresh install: the repo shipped a
config.ini rendered from a host at the v260612 release, compose bind-mounts
`./config/ofelia` straight onto /etc/ofelia, and the generator only ever ran
from an admin action page -- so every fresh install inherited that frozen
snapshot. It was missing four seeded jobs outright (mail-queue health check,
DMARC reports, Authelia log rotation, and the fangfrisch malware-feed refresh)
and still pointed hermes-update-check at the pre-#218 update_check.sh, which
is why the dashboard read UPDATE CHECK PENDING forever.

Invoked headlessly (from install_hermes_docker.sh phase 2, and available to the
update orchestrator) via:
    docker exec hermes_commandbox curl -s http://localhost:8888/schedule/regen_ofelia_config.cfm

Mirrors the established schedule-page pattern in `regen_nginx_config.cfm` and
`acme_validate_ip.cfm`, which already include admin/2/inc helpers headlessly.
The helper uses only absolute paths + `datasource="hermes"` (provided by the
schedule app), so it runs correctly outside the admin session context.

Prints `OFELIA_CONFIG_REGEN_OK` on success; callers grep for it.
--->

<cfsetting requesttimeout="300">

<!--- Render config.ini from ofelia_jobs, then restart hermes_ofelia (the
     helper includes inc/restart_ofelia.cfm itself). --->
<cfinclude template="../admin/2/inc/ofelia_generate_config.cfm">

<cfoutput>OFELIA_CONFIG_REGEN_OK</cfoutput>
