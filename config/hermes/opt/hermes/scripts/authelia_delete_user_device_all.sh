#!/bin/bash
# Delete all 2FA devices (TOTP and WebAuthn) for a user
# This script runs inside Docker containers
# THE-USER placeholder is replaced at runtime

# Delete TOTP device
docker exec hermes_authelia authelia storage user totp delete THE-USER --config /etc/authelia/configuration.yml 2>/dev/null || true

# Delete all WebAuthn devices
docker exec hermes_authelia authelia storage user webauthn delete THE-USER --config /etc/authelia/configuration.yml --all 2>/dev/null || true
