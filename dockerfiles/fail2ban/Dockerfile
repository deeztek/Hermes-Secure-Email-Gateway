FROM lscr.io/linuxserver/fail2ban

#Install curl and mysql-client for quota-warning script
RUN apk add mysql-client

# Copy iptables backend detection script to custom init
COPY config/fail2ban/scripts/detect-iptables-backend.sh /custom-cont-init.d/10-detect-iptables-backend
RUN chmod +x /custom-cont-init.d/10-detect-iptables-backend

