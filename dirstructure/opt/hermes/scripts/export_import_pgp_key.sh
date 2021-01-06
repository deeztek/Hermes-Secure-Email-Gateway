/bin/cat /opt/hermes/tmp/CUSTOM-TRANS_gpg_output | awk '/gpg: key/ {print $3}' > /opt/hermes/tmp/CUSTOM-TRANS_temp.txt && mv /opt/hermes/tmp/CUSTOM-TRANS_temp.txt /opt/hermes/tmp/CUSTOM-TRANS_gpg_output

THEKEYID=`cat /opt/hermes/tmp/CUSTOM-TRANS_gpg_output`

#Export Public Key
/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --export -a "$THEKEYID" > /opt/hermes/tmp/CUSTOM-TRANS_public.key

#Export Private Key (OLD)
#/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --export-secret-key -a "$THEKEYID" > /opt/hermes/tmp/CUSTOM-TRANS_private.key

#Export Private Key (NEW)
/usr/bin/gpg --pinentry-mode=loopback --passphrase "THE-PASSWORD" --homedir /opt/hermes/.gnupg/ --export-secret-key -a "$THEKEYID" > /opt/hermes/tmp/CUSTOM-TRANS_private.key

cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.PGPTool --import-keys /opt/hermes/tmp/CUSTOM-TRANS_public.key

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.PGPTool --import-keys /opt/hermes/tmp/CUSTOM-TRANS_private.key --password THE-PASSWORD
