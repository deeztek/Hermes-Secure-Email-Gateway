#!/bin/bash
# generate_csr.sh -- CSR + private key generator for view_system_certificates.cfm
#
# Invoked by inc/generate_csr.cfm after the CFML side substitutes the
# uppercase placeholders (SHA-TYPE, KEY-LENGTH, SESSION, COUNTRY, STATE,
# LOCALITY, ORGANIZATION, DEPARTMENT, COMMON-NAME) with the admin's input
# and writes a sibling .cnf file at /opt/hermes/tmp/SESSION.csr.cnf that
# carries the distinguished name and the [req_ext]/[alt_names] sections
# with one DNS.N = <san> line per sanitized SAN.
#
# The .cnf file is the source of truth for both the DN and the SANs --
# this script just hands it to openssl. That keeps comma-escaping and
# SAN-count concerns on the CFML side where they belong.

/bin/rm -rf /opt/hermes/tmp/*generate_csr.sh
/bin/rm -rf /opt/hermes/tmp/*csr_key.rar

/usr/bin/openssl req \
    -nodes \
    -SHA-TYPE \
    -newkey rsa:KEY-LENGTH \
    -keyout /opt/hermes/tmp/SESSION.key.txt \
    -out /opt/hermes/tmp/SESSION.csr.txt \
    -config /opt/hermes/tmp/SESSION.csr.cnf \
    -reqexts req_ext

/usr/bin/rar a -ep /opt/hermes/tmp/SESSION_csr_key.rar \
    /opt/hermes/tmp/SESSION.key.txt \
    /opt/hermes/tmp/SESSION.csr.txt

/bin/rm -rf /opt/hermes/tmp/SESSION.key.txt
/bin/rm -rf /opt/hermes/tmp/SESSION.csr.txt
/bin/rm -rf /opt/hermes/tmp/SESSION.csr.cnf
