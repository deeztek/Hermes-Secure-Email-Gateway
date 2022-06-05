#1/bin/bash
while getopts m:f: flag
do
      case "${flag}" in
	      m) message=${OPTARG};;
	      f) field=${OPTARG};;
      esac
done
echo "Message: $message";
echo "Field: $field";
echo "1=$1"
echo "2=$2"
echo "3=$3"
echo "4=$4"
echo "5=$5"

#echo "/usr/sbin/postcat -qh $message | awk -F: '/$field:/ { print '$2' }'" 
THEMESSAGE=`/usr/sbin/postcat -qh $message`
export THEMESSAGE
#echo "msg=$THEMESSAGE"
/opt/hermes/scripts/get_mailque_parameter.sh

