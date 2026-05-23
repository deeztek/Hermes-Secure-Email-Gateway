#!/bin/bash
#Delete sites-available *mailbox-ssl.conf
rm -f /etc/nginx/sites-available/*mailbox-ssl.conf

#Delete sites-enabled *-mailbox-ssl.conf
rm -f /etc/nginx/sites-enabled/*mailbox-ssl.conf
