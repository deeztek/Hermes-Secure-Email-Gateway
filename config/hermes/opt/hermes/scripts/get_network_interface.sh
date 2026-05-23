#/sbin/ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'
/sbin/ip route get 8.8.8.8 | sed -nr 's/.*dev ([^\ ]+).*/\1/p'
