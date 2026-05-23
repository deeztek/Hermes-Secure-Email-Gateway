#!/bin/bash

#Attempt Renewal
echo 'Attempting renewal'

RENEWAL=`/usr/local/bin/docker run --rm --name hermes_certbot -v DOCKER-DIR/config/hermes/var/www/html:/var/www/certbot -v DOCKER-DIR/config/certbot/conf:/etc/letsencrypt -v DOCKER-DIR/config/certbot/logs:/var/log certbot/certbot:latest renew --webroot --webroot-path /var/www/certbot`

if [[ $RENEWAL == *"Congratulations"* ]]; then

        echo 'Acme Certificate(s) were renewed. Restarting Containers...'

    /usr/local/bin/docker container restart hermes_nginx
    /usr/local/bin/docker container restart hermes_postfix_dkim
    /usr/local/bin/docker container restart hermes_dovecot


else
        echo 'Acme Certificate(s) were not renewed. Exiting...'

fi

