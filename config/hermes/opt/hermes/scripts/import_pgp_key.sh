#!/bin/bash
cat /opt/hermes/CA/CA-DIRECTORY/root_ca/PFX/RCPT-NAME.pfx | /usr/local/bin/docker exec -i hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CertStore --import-keys --keystore-password THE-PASSWORD
