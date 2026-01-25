cd /opt/hermes/CA/CA-DIRECTORY/root_ca

/usr/bin/openssl genrsa -out private/bobaoltld_key.pem 2048

/usr/bin/openssl req -new -sha256 -days 365 -key private/bobaoltld_key.pem -out requests/bobaoltld.csr -subj "/CN=bob@aol.tld/emailAddress=bob@aol.tld"

/usr/bin/openssl ca -md sha256 -days 365 -batch -in requests/bobaoltld.csr -out newcerts/bobaoltld_cert.pem -config openssl.cnf

/usr/bin/openssl pkcs12 -export -out PFX/bobaoltld.pfx -inkey private/bobaoltld_key.pem -in newcerts/bobaoltld_cert.pem -certfile opt/hermes/CA/CA-DIRECTORY/root_ca/cachain.pem -passout pass:12345678

cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CertStore --import-keys < /opt/hermes/CA/CA-DIRECTORY/root_ca/PFX/bobaoltld.pfx --keystore-password 12345678
