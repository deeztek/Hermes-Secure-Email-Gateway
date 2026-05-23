#/sbin/ifconfig ens160 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
/bin/hostname -I | cut -d' ' -f1
