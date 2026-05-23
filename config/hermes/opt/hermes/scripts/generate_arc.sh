#!/bin/bash
# Generate an ARC signing keypair using flowerysong's openarc-keygen.
# Placeholders replaced by inc/arc_create_key.cfm before invocation:
#   THE-KEY      = bit size (1024 / 2048)
#   THE-SELECTOR = selector label (used as DNS hostname component)
#   THE-DOMAIN   = signing domain (the gateway's own domain)
#
# openarc-keygen is invoked by bare name (no /usr/sbin/ or /usr/bin/ prefix)
# because flowerysong installs Python helper scripts to bindir (/usr/bin/)
# while the daemon goes to sbindir (/usr/sbin/). Bare name + PATH lookup
# tolerates either location across upstream releases.
openarc-keygen -b THE-KEY -s THE-SELECTOR -d THE-DOMAIN -D /opt/hermes/arc/keys/
# flowerysong's openarc-keygen produces files named:
#   <selector>._domainkey.<domain>.key   (private key, NOT .private like opendkim-genkey)
#   <selector>._domainkey.<domain>.txt   (public key / DNS record)
# Rename to Hermes' internal convention (<selector>_<domain>.arc.{private,txt})
# so arc_sign.private/.public column values match what arc_create_key.cfm
# inserts and what arc_generate_config_file.cfm references.
mv /opt/hermes/arc/keys/THE-SELECTOR._domainkey.THE-DOMAIN.key /opt/hermes/arc/keys/THE-SELECTOR_THE-DOMAIN.arc.private
mv /opt/hermes/arc/keys/THE-SELECTOR._domainkey.THE-DOMAIN.txt /opt/hermes/arc/keys/THE-SELECTOR_THE-DOMAIN.arc.txt
