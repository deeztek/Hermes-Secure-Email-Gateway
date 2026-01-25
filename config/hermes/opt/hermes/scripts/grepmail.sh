#!/bin/sh
cd /mnt/data/amavis/

/bin/grep -R -i -l 'SEARCH-STRING' * > /opt/hermes/tmp/CUSTOM-TRANS_results.txt

if [ -r /opt/hermes/tmp/CUSTOM-TRANS_results.txt ]; then

/usr/bin/mysql --local-infile=1 -uMYSQL-USER  -pMYSQL-PASSWORD -e "use hermes; LOAD DATA LOCAL INFILE '/opt/hermes/tmp/CUSTOM-TRANS_results.txt' INTO TABLE body_temp (quar_loc, customtrans) SET customtrans = 'CUSTOM-TRANS'"

/usr/bin/mysql -h localhost -u MYSQL-USER -pMYSQL-PASSWORD -e "use hermes; update searches set status = 'completed' where customtrans = 'CUSTOM-TRANS'"

/usr/bin/mysql -h localhost -u MYSQL-USER -pMYSQL-PASSWORD -e "use hermes; update searches set ended = CURRENT_TIMESTAMP() where customtrans = 'CUSTOM-TRANS'"

/usr/bin/curl --data "trans=CUSTOM-TRANS" http://localhost:8888/schedule/delete_search_task.cfm

else

/usr/bin/mysql -h localhost -u MYSQL-USER -pMYSQL-PASSWORD -e "use hermes; update searches set status = 'completed' where customtrans = 'CUSTOM-TRANS'"

/usr/bin/mysql -h localhost -u MYSQL-USER -pMYSQL-PASSWORD -e "use hermes; update searches set ended = CURRENT_TIMESTAMP() where customtrans = 'CUSTOM-TRANS'"

/usr/bin/curl --data "trans=CUSTOM-TRANS" http://localhost:8888/schedule/delete_search_task.cfm

fi

