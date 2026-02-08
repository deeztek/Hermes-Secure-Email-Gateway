#!/bin/bash

# Get Docker compose working directory dynamically
DOCKER_DIR=$(/usr/local/bin/docker inspect hermes_commandbox --format '{{index .Config.Labels "com.docker.compose.project.working_dir"}}' 2>/dev/null)

if [ -z "$DOCKER_DIR" ]; then
    echo 'ERROR: Could not determine Docker working directory. Is hermes_commandbox running?'
    exit 1
fi

echo "Docker Directory: $DOCKER_DIR"

# Check retention policy status
POLICY_STATUS=$(curl -s "http://localhost:8888/schedule/get_retention_status.cfm" 2>/dev/null)

if [[ "$POLICY_STATUS" != *"ENABLED"* ]]; then
    echo "Advanced certificate management requires valid retention policy configuration. Exiting..."
    exit 0
fi

# Attempt Renewal
echo 'Attempting Acme Certificate(s) Renewal'

RENEWAL=`/usr/local/bin/docker run --rm --name hermes_certbot --network host --dns 8.8.8.8 --dns 8.8.4.4 -v ${DOCKER_DIR}/config/hermes/var/www/html:/var/www/certbot -v ${DOCKER_DIR}/config/certbot/conf:/etc/letsencrypt -v ${DOCKER_DIR}/config/certbot/logs:/var/log certbot/certbot:latest renew --webroot --webroot-path /var/www/certbot`

if [[ $RENEWAL == *"Congratulations"* ]]; then

	echo 'Acme Certificate(s) were renewed. Restarting Containers...'

    /usr/local/bin/docker container restart hermes_nginx
    /usr/local/bin/docker container restart hermes_postfix_dkim
    /usr/local/bin/docker container restart hermes_dovecot

  
else
	echo 'Acme Certificate(s) were not renewed. Exiting...'

fi

