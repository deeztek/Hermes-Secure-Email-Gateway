#!/bin/bash
/usr/bin/shasum /opt/hermes/updates/THE-FILE | grep `cat /opt/hermes/updates/THE-FILE.hash | tr '[:upper:]' '[:lower:]'`
