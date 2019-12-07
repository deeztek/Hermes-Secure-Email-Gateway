<IfModule mod_ssl.c>
<VirtualHost _default_:9080>
ProxyRequests Off

SSLEngine on
SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
SSLProtocol -all +TLSv1.2

SetEnvIf User-Agent ".*MSIE.*" nokeepalive ssl-unclean-shutdown
<Proxy *>
Order deny,allow
Allow from all
</Proxy>

#RequestHeader set X-FORWARDED-PROTOCOL https
#RequestHeader set X-Forwarded-Ssl on

#HERMES SEG CONFIGURATION
ProxyPass /admin ajp://localhost:8009/admin
ProxyPassReverse /admin ajp://localhost:8009/admin
ProxyPass /users ajp://localhost:8009/users
ProxyPassReverse /users ajp://localhost:8009/users
ProxyPass /main ajp://localhost:8009/main
ProxyPassReverse /main ajp://localhost:8009/main

#CIPHERMAIL CONFIGURATION
SSLProxyEngine On
ProxyPreserveHost On
SSLProxyVerify none
SSLProxyCheckPeerName off
SSLProxyCheckPeerCN off
SSLProxyCheckPeerExpire off

ProxyPass /ciphermail https://localhost:8443/ciphermail
ProxyPassReverse /ciphermail https://localhost:8443/ciphermail
ProxyPass /web https://localhost:8443/web
ProxyPassReverse /web https://localhost:8443/web

ProxyTimeout 3600

LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" combined
CustomLog /var/log/apache2/hermes combined

</VirtualHost>
</IfModule>
