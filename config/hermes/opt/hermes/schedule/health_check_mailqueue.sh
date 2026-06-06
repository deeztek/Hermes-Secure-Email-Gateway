#!/bin/bash
/usr/local/bin/docker exec hermes_postfix_dkim mailq | grep -E '^[A-Z0-9]' | wc -l
