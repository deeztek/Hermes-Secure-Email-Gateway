#Backup /etc/network/interfaces
/bin/cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.HERMES.BACKUP

#Replace /etc/network/interfaces
/bin/mv /opt/hermes/tmp/THE-TRANSACTION50-cloud-init.yaml.HERMES.static /etc/netplan/50-cloud-init.yaml

#Backup /etc/amavis/conf.d/50-user
/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP

#Replace /etc/amavis/conf.d/50-user
/bin/mv /opt/hermes/tmp/THE-TRANSACTION50-user /etc/amavis/conf.d/50-user

#Backup /etc/hosts
/bin/cp /etc/hosts /etc/hosts.HERMES.BACKUP

#Replace /etc/hosts
/bin/mv /opt/hermes/tmp/THE-TRANSACTIONhosts /etc/hosts

#Backup /etc/mailname
/bin/cp /etc/mailname /etc/mailname.HERMES.BACKUP

#Replace /etc/mailname
/bin/mv /opt/hermes/tmp/THE-TRANSACTIONmailname /etc/mailname

#Set hostname
/usr/bin/hostnamectl SERVER-NAME

#Restart Amavis
/etc/init.d/amavis restart

#Set Server Hostname and Server Domain in /etc/main.cf
/usr/sbin/postconf -e ""myorigin = SERVER-DOMAIN""
/usr/sbin/postconf -e ""myhostname = SERVER-NAME.SERVER-DOMAIN""

#Reload & Restart Postfix
/usr/sbin/postfix reload
/etc/init.d/postfix restart

#Restart Networking
THE-NET-COMMAND
