#!/bin/bash
/usr/sbin/opendkim-genkey -b THE-KEY -s THE-SELECTOR -d THE-DOMAIN -D /opt/hermes/dkim/keys/
mv /opt/hermes/dkim/keys/THE-SELECTOR.private /opt/hermes/dkim/keys/THE-SELECTOR_THE-DOMAIN.dkim.private
mv /opt/hermes/dkim/keys/THE-SELECTOR.txt /opt/hermes/dkim/keys/THE-SELECTOR_THE-DOMAIN.dkim.txt
