/bin/rm -rf /opt/hermes/tmp/*generate_csr.sh
/bin/rm -rf /opt/hermes/tmp/*csr_key.rar

/usr/bin/openssl req -nodes -SHA-TYPE -newkey rsa:KEY-LENGTH -keyout /opt/hermes/tmp/SESSION.key.txt -out /opt/hermes/tmp/SESSION.csr.txt -subj "/C=COUNTRY/ST=STATE/L=LOCALITY/O=ORGANIZATION/OU=DEPARTMENT/CN=COMMON-NAME"

/usr/bin/rar a -ep /opt/hermes/tmp/SESSION_csr_key.rar /opt/hermes/tmp/SESSION.key.txt /opt/hermes/tmp/SESSION.csr.txt

/bin/rm -rf /opt/hermes/tmp/SESSION.key.txt
/bin/rm -rf /opt/hermes/tmp/SESSION.csr.txt
