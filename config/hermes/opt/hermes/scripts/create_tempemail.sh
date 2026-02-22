#!/bin/bash
cd /opt/hermes/CA/CA-DIRECTORY/root_ca

/usr/bin/openssl genrsa -out private/bobaoltld_key.pem 2048

/usr/bin/openssl req -new -sha256 -days 365 -key private/bobaoltld_key.pem -out requests/bobaoltld.csr -subj "/CN=bob@aol.tld/emailAddress=bob@aol.tld"

/usr/bin/openssl ca -md sha256 -days 365 -batch -in requests/bobaoltld.csr -out newcerts/bobaoltld_cert.pem -config openssl.cnf

/usr/bin/openssl pkcs12 -export -out PFX/bobaoltld.pfx -inkey private/bobaoltld_key.pem -in newcerts/bobaoltld_cert.pem -certfile opt/hermes/CA/CA-DIRECTORY/root_ca/cachain.pem -passout pass:12345678

cat /opt/hermes/CA/CA-DIRECTORY/root_ca/PFX/bobaoltld.pfx | /usr/local/bin/docker exec -i hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CertStore --import-keys --keystore-password 12345678
