#!/bin/bash
authelia storage user totp delete THE-USER --config /etc/authelia/configuration.yml
authelia storage user webauthn delete THE-USER --config /etc/authelia/configuration.yml --all
