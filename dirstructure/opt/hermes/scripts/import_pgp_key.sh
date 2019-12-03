

cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CertStore --import-keys < /opt/hermes/CA/CA-DIRECTORY/root_ca/PFX/RCPT-NAME.pfx --keystore-password THE-PASSWORD
