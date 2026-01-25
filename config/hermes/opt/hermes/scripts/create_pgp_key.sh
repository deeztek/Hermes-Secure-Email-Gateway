#CREATE PGP KEYRING
/usr/bin/gpg --homedir /opt/hermes/.gnupg/ --keyid-format long --batch --gen-key /opt/hermes/tmp/CUSTOM-TRANS_gpg_template 2>&1
