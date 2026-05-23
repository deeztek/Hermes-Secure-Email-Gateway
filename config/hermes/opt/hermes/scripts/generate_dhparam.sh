#!/bin/bash

cd /opt/hermes/tmp
/usr/bin/openssl dhparam -out dhparam.pem 4096
/bin/mv /opt/hermes/tmp/dhparam.pem /opt/hermes/ssl/dhparam.pem

