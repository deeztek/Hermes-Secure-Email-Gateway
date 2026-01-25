FROM dovecot/dovecot:2.3.21.1

#Install curl and mysql-client for quota-warning script
RUN apt-get update && apt-get -y install curl default-mysql-client

#Copy dovecot logrotate files
#COPY ../config/dovecot/logrotate.d/dovecot /etc/logrotate.d/
#COPY ../config/dovecot/logrotate.d/dovecot-info /etc/logrotate.d/
#COPY ../config/dovecot/logrotate.d/dovecot-debug /etc/logrotate.d/
