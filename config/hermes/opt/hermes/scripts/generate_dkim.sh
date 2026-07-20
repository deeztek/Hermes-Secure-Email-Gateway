#!/bin/bash
# opendkim-genkey does not create its output directory (-D) and fails if it is
# missing, which then makes both mv calls below fail with "cannot stat".
mkdir -p /opt/hermes/dkim/keys
/usr/sbin/opendkim-genkey -b THE-KEY -s THE-SELECTOR -d THE-DOMAIN -D /opt/hermes/dkim/keys/
mv /opt/hermes/dkim/keys/THE-SELECTOR.private /opt/hermes/dkim/keys/THE-SELECTOR_THE-DOMAIN.dkim.private
mv /opt/hermes/dkim/keys/THE-SELECTOR.txt /opt/hermes/dkim/keys/THE-SELECTOR_THE-DOMAIN.dkim.txt
