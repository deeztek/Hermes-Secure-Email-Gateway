cd /opt/hermes/CA/CA-DIRECTORY/root_ca

/usr/bin/truncate  -s 0 index.txt

/usr/bin/openssl genrsa -out private/RCPT-NAME_key.pem THE-ENCRYPTION

/usr/bin/openssl req -new -THE-ALGORITHM -days THE-VALIDITY -key private/RCPT-NAME_key.pem -out requests/RCPT-NAME.csr -subj "/CN=THE-RECIPIENT/emailAddress=THE-RECIPIENT"

/usr/bin/openssl ca -md THE-ALGORITHM -days THE-VALIDITY -batch -in requests/RCPT-NAME.csr -out newcerts/RCPT-NAME_cert.pem -config openssl.cnf

/usr/bin/openssl pkcs12 -export -out PFX/RCPT-NAME.pfx -inkey private/RCPT-NAME_key.pem -in newcerts/RCPT-NAME_cert.pem -certfile /opt/hermes/CA/CA-DIRECTORY/root_ca/cachain.pem -passout pass:THE-PASSWORD


cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CertStore --import-keys < /opt/hermes/CA/CA-DIRECTORY/root_ca/PFX/RCPT-NAME.pfx --keystore-password THE-PASSWORD
