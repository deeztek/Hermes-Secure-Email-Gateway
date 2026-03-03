#!/bin/bash
#CREATE PGP KEYRING
/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --keyid-format long --batch --gen-key /opt/hermes/tmp/CUSTOM-TRANS_gpg_template 2>/dev/null

# Extract the email from the template and look up the key ID
EMAIL=$(grep 'Name-Email' /opt/hermes/tmp/CUSTOM-TRANS_gpg_template | awk '{print $2}')
/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --keyid-format long --with-colons --list-keys "$EMAIL" 2>/dev/null | awk -F: '/^pub/{print $5}' | tail -1
