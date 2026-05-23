#/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --export-secret-key -a "THE_KEY" > /opt/hermes/tmp/THE_KEY_private.asc
#Export Private Key (NEW)
/usr/bin/gpg --pinentry-mode=loopback --passphrase "THE-PASSWORD" --homedir /opt/hermes/.gnupg/ --export-secret-key -a "THE_KEY" > /opt/hermes/tmp/THE_KEY_private.asc
