#!/bin/bash

# Reload systemd and enable services (replaces postinst actions for -nosystemd.deb builds)
systemctl daemon-reload
systemctl enable ciphermail-gateway-backend 2>/dev/null || true
systemctl enable tomcat9 2>/dev/null || true
systemctl enable postfix 2>/dev/null || true
systemctl enable rsyslog 2>/dev/null || true

# Restart all services in the background
setsid systemctl restart rsyslog && systemctl restart ciphermail-gateway-backend && systemctl restart tomcat9 && systemctl restart postfix

# Run systemd
exec /sbin/init
