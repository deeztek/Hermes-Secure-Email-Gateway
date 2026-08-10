/bin/rm /etc/razor/identity*
/bin/rm /etc/razor/razor-agent.conf
/usr/bin/razor-admin -home=/etc/razor -create
/usr/bin/razor-admin -home=/etc/razor -register
# SpamAssassin runs as amavis and the razor agent writes its home at scan time
# (servers.*.lst, per-server .conf), so root-owned files here leave Razor mute.
/bin/chown -R amavis:amavis /etc/razor

