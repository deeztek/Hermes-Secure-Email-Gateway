#!/bin/bash

ip=/opt/hermes/tmp/CUSTOM-TRANS_7z_pid

for i in `cat "$ip"`
do

/bin/kill -9 $i

done

/bin/rm -rf /opt/hermes/tmp/CUSTOM-TRANS_7z_pid
