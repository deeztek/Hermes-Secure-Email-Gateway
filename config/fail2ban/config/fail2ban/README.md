# Configuration README

!! NOTICE !!

When using [linuxserver/fail2ban](https://github.com/linuxserver/docker-fail2ban), the `*.conf` files in this directory and its subdirectories will be replaced every time the container restarts. The files are meant to be easily viewed so that you can reference them.

If you would like to customize anything, create a `*.local` file with the same name as the `*.conf` file and apply your customizations. You do not need to copy the entire `*.conf` file to `*.local`, you only need to include things you want to change.

For example, to adjust `jail.conf`, create `jail.local` and apply your customizations there.

## File Parsing Order

Fail2ban will combine action configurations in the following order:

```text
action.d/*.conf (in alphabetical order)
action.d/*.local (in alphabetical order)
```

Fail2ban will combine filter configurations in the following order:

```text
filter.d/*.conf (in alphabetical order)
filter.d/*.local (in alphabetical order)
```

Fail2ban will combine jail configurations in the following order:

```text
jail.conf
jail.d/*.conf (in alphabetical order)
jail.local
jail.d/*.local (in alphabetical order)
```

## Chains

Chains affect how access is restricted. There are two primary ways to restrict access.

### `DOCKER-USER`

The `DOCKER-USER` chain is used to restrict access to applications running in Docker containers. This will restrict access to all containers, not just the one that the jail is configured for.

### `INPUT`

The `INPUT` chain is used to restrict access to applications running on the host. This will restrict access to the host network stack. The host network stack may not be inclusive of all Docker network stacks, thus the `DOCKER-USER` chain is used separately for applications running in Docker containers.

### `FORWARD` (for legacy versions of Docker)

The `FORWARD` chain may be used on systems running older versions of Docker where the `DOCKER-USER` chain is not available.

## `jail.local` Examples

These are examples of what you can do in your `jail.local`. There is no universally correct way to setup `jail.local` as it depends on your needs.
You can enable any of the pre-made jails by reviewing the files in `jail.d/` and adding a few lines to your `jail.local` to enable the jail.

### Basic Example

This example shows how to enable jails for sshd on the host, and SWAG (nginx) running in a container. It also includes some general recommendations and optional lines commented out.

In order for bans to work correctly, the `INPUT` chain should be used for applications running on the host, and the `DOCKER-USER` chain should be used for applications running in containers.

In this basic example:

- `sshd` expects ssh to be running on the host (not in a container), so the `INPUT` chain is used
- `nginx-http-auth` expects nginx to be running in a container (ex: SWAG), so the `DOCKER-USER` chain is used

```ini
[DEFAULT]

# Prevents banning LAN subnets
ignoreip    = 127.0.0.1/8 ::1
              10.0.0.0/8
              172.16.0.0/12
              192.168.0.0/16

# The ban action "iptables-multiport" (default) should work for most
# The ban action "iptables-allports" can be used if multiport causes issues
#banaction = %(banaction_allports)s

[sshd]
# configuration inherits from jail.conf
enabled = true
chain   = INPUT
action  = %(known/action)s

[nginx-http-auth]
# configuration inherits from jail.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s

[nginx-badbots]
# configuration inherits from jail.d/nginx-badbots.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s

[nginx-botsearch]
# configuration inherits from jail.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s

[nginx-deny]
# configuration inherits from jail.d/nginx-deny.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s

[nginx-unauthorized]
# configuration inherits from jail.d/nginx-unauthorized.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s
```

### Incremental Banning

This example only includes the configurations for incremental banning. You can add these lines to the `[DEFAULT]` section of your existing config.

With these configurations, after an IP is unbanned, if it gets banned again the ban time will increase exponentially.

```ini
[DEFAULT]

# "bantime.increment" allows to use database for searching of previously banned ip's to increase a
# default ban time
bantime.increment = true

# "bantime.maxtime" is the max number of seconds using the ban time can reach (doesn't grow further)
bantime.maxtime = 5w

# "bantime.factor" is a coefficient to calculate exponent growing of the formula or common multiplier
bantime.factor = 24

# "bantime" is the number of seconds that a host is banned.
bantime = 1h

# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime = 24h

# "maxretry" is the number of failures before a host get banned.
maxretry = 5
```

### unRAID

Add these lines to your `jail.local` to enable jails for unRAID's sshd and Web GUI.
The `port` line for the Web GUI is optional, but if you use unRAID's My Servers plugin to enable public access you should add the port you use (replace `YOUR-UNRAID-MY-SERVERS-WAN-PORT`)
Both of these jails protect unRAID at the host level using the `INPUT` chain.

```ini
[unraid-sshd]
# configuration inherits from jail.d/unraid-sshd.conf
enabled = true
chain   = INPUT
action  = %(known/action)s

[unraid-webgui]
# configuration inherits from jail.d/unraid-webgui.conf
enabled = true
chain   = INPUT
port    = http,https,YOUR-UNRAID-MY-SERVERS-WAN-PORT
action  = %(known/action)s
```

### Unifi-Controller

Add these lines to enable the jail for Unifi-Controller.

```ini

[unifi-controller-auth]
# configuration inherits from jail.d/unifi-controller-auth.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s
```

### Additional Actions

The default `action` will use `iptables` to perform bans. You may also apply bans using other services such as CloudFlare, report bans to services such as AbuseIPDB, or setup notifications for with services such as Apprise or Discord Webhooks.

```ini
[DEFAULT]
# Apply additional actions to all bans with all jails
action  = %(action_)s
          apprise-api[host="127.0.0.1", tag="fail2ban"]
          cloudflare[cfuser="YOUR-EMAIL", cftoken="YOUR-TOKEN"]
          discord-webhook[webhook="https://discord.com/api/webhooks/######/######"]

abuseipdb_apikey = YOUR-API-KEY

[sshd]
# Apply additional actions only to bans for the sshd jail
action  = %(known/action)s
          abuseipdb[abuseipdb_apikey="%(abuseipdb_apikey)s", abuseipdb_category="18,22"]

[unifi-controller-auth]
# Apply additional actions only to bans for the unifi-controller-auth jail
action  = %(known/action)s
          abuseipdb[abuseipdb_apikey="%(abuseipdb_apikey)s", abuseipdb_category="18,21"]

```

### Full Example

```ini
[DEFAULT]

# "bantime.increment" allows to use database for searching of previously banned ip's to increase a
# default ban time
bantime.increment = true

# "bantime.maxtime" is the max number of seconds using the ban time can reach (doesn't grow further)
bantime.maxtime = 5w

# "bantime.factor" is a coefficient to calculate exponent growing of the formula or common multiplier
bantime.factor = 24

# "bantime" is the number of seconds that a host is banned.
bantime = 1h

# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime = 24h

# "maxretry" is the number of failures before a host get banned.
maxretry = 5

# Prevents banning LAN subnets
ignoreip    = 127.0.0.1/8 ::1
              10.0.0.0/8
              172.16.0.0/12
              192.168.0.0/16

# The ban action "iptables-multiport" (default) should work for most
# The ban action "iptables-allports" can be used if multiport causes issues
#banaction = %(banaction_allports)s

# Read https://github.com/sebres/PoC/blob/master/FW.IDS-DROP-vs-REJECT/README.md before changing block type
# The block type "REJECT --reject-with icmp-port-unreachable" (default behavior) should respond to, but then instantly reject connection attempts
# The block type "DROP" should not respond to connection attempts, resulting in a timeout
#banaction = iptables-multiport[blocktype=DROP]

# Add additional actions
action  = %(action_)s
          apprise-api[host="127.0.0.1", tag="fail2ban"]
          cloudflare[cfuser="YOUR-EMAIL", cftoken="YOUR-TOKEN"]

abuseipdb_apikey = YOUR-API-KEY

[unraid-sshd]
# configuration inherits from jail.d/unraid-sshd.conf
enabled = true
chain   = INPUT
action  = %(known/action)s
          abuseipdb[abuseipdb_apikey="%(abuseipdb_apikey)s", abuseipdb_category="18,22"]

[unraid-webgui]
# configuration inherits from jail.d/unraid-webgui.conf
enabled = true
chain   = INPUT
port    = http,https,YOUR-UNRAID-MY-SERVERS-WAN-PORT
action  = %(known/action)s
          abuseipdb[abuseipdb_apikey="%(abuseipdb_apikey)s", abuseipdb_category="18,21"]

[unifi-controller-auth]
# configuration inherits from jail.d/unifi-controller-auth.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s
          abuseipdb[abuseipdb_apikey="%(abuseipdb_apikey)s", abuseipdb_category="18,21"]

[vaultwarden-auth]
# configuration inherits from jail.d/vaultwarden-auth.conf
enabled = true
chain   = DOCKER-USER
action  = %(known/action)s
          abuseipdb[abuseipdb_apikey="%(abuseipdb_apikey)s", abuseipdb_category="18,21"]

```

## Customizing jails

You can customize additional aspects about a jail by modifying your `jail.local` file.

```ini
[unifi-controller-auth]
# configuration inherits from jail.d/unifi-controller-auth.conf
enabled = true

# If you are using non-standard ports for your unifi-controller, you can specify the ports you use
port    = 8081,8442

# If your log file is mounted to a non-standard location inside the container, you can specify the path that the container will see your log file
logpath = /path/to/unificontroller/server.log

# If you are running the unifi-controller on your host (not in a docker container) you can change the chain to INPUT
#chain   = INPUT
# If you are running the unifi-controller in a docker container you can change the chain to DOCKER-USER
#chain   = DOCKER-USER
```
