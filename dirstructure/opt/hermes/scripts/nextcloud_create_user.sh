#!/bin/bash
docker exec -u www-data -it nextcloud  sh -c 'export OC_PASS="THE-PASSWORD" && /var/www/html/occ user:add --password-from-env --display-name "FULL-NAME" THE-USERNAME'

docker exec -u www-data nextcloud /var/www/html/occ mail:account:create THE-USERNAME "FULL-NAME" THE-EMAIL mail.hosting.deeztek.com 993 ssl dino.edwards@mydirectmail.net Tit3p4m20987? mail.hosting.deeztek.com 587 tls dino.edwards@mydirectmail.net Tit3p4m20987? password
