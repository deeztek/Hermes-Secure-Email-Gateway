#!/bin/bash
# Read key ID from GPG output (written by create_pgp_key.sh)
THEKEYID=$(cat /opt/hermes/tmp/CUSTOM-TRANS_gpg_output | tr -d '[:space:]')

#Export Public Key
/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --export -a "$THEKEYID" > /opt/hermes/tmp/CUSTOM-TRANS_public.key

#Export Private Key (NEW)
/usr/bin/gpg --pinentry-mode=loopback --passphrase "THE-PASSWORD" --homedir /opt/hermes/.gnupg/ --export-secret-key -a "$THEKEYID" > /opt/hermes/tmp/CUSTOM-TRANS_private.key

/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.PGPTool --import-keys /opt/hermes/tmp/CUSTOM-TRANS_public.key

/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.PGPTool --import-keys /opt/hermes/tmp/CUSTOM-TRANS_private.key --password THE-PASSWORD
