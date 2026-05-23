#!/bin/bash
openssl x509 -in THE-PATH -noout -text | grep -A1 "Subject Alternative Name" | tail -1 | sed 's/ //g' | tr ',' '\n' | sed -E 's/^.*:(.+)/\1/' | paste -sd ',' -
