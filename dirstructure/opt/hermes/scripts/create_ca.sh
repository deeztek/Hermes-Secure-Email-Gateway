/bin/mkdir /opt/hermes/CA/CA-DIRECTORY

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca/certs

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca/crl

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca/newcerts

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca/private

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca/requests

/bin/mkdir /opt/hermes/CA/CA-DIRECTORY/root_ca/PFX

/usr/bin/touch /opt/hermes/CA/CA-DIRECTORY/root_ca/serial

/bin/echo 0100 > /opt/hermes/CA/CA-DIRECTORY/root_ca/serial

/usr/bin/touch /opt/hermes/CA/CA-DIRECTORY/root_ca/index.txt

/usr/bin/touch /opt/hermes/CA/CA-DIRECTORY/root_ca/crlnumber

/bin/echo 0100 > /opt/hermes/CA/CA-DIRECTORY/root_ca/crlnumber

/bin/mv /opt/hermes/templates/CUSTOM-TRANS_rootca_openssl.cnf /opt/hermes/CA/CA-DIRECTORY/root_ca/openssl.cnf

cd /opt/hermes/CA/CA-DIRECTORY/root_ca

openssl genrsa -out ./private/cakey.pem SHOW-ENCRYPTION

/usr/bin/openssl req -x509 -days SHOW-VALIDITY -new -key ./private/cakey.pem -out ./certs/cacert.pem -config openssl.cnf -subj "/C=SHOW-COUNTRYNAME/ST=SHOW-STATEPROVINCENAME/O=SHOW-ORGANIZATIONNAME/OU=SHOW-UNITNAME/CN=SHOW-CA-COMMONNAME"

/bin/cat /opt/hermes/CA/CA-DIRECTORY/root_ca/certs/cacert.pem > /opt/hermes/CA/CA-DIRECTORY/root_ca/cachain.pem

cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CertStore --import-certificates < /opt/hermes/CA/CA-DIRECTORY/root_ca/certs/cacert.pem
