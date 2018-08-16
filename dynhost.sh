#/bin/sh

#
# CONFIG
#

HOSTS="dynhost.othalland.xyz nextcloud.othalland.xyz tautulli.othalland.xyz nas.othalland.xyz netdata.othalland.xyz"
LOGIN=CHANGEME
PASSWORD=CHANGEME

PATH_LOG=/var/log/dynhost
CURRENT_DATE=`date`

#
# GET IPs
#

CURRENT_IP=`curl -4 ifconfig.co`

for HOST in $HOSTS
do
  HOST_IP=`dig +short $HOST`
  echo "Processing host $HOST - current IP $HOST_IP" >> $PATH_LOG
  #
  # DO THE WORK
  #
  if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
  then
    echo "No IP retrieved" >> $PATH_LOG
  else
    echo "$HOST_IP - $CURRENT_IP"
    if [ "$HOST_IP" != "$CURRENT_IP" ]
    then
      RES=`curl --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP"`
      echo "Result request dynHost:" >> $PATH_LOG
      echo "$RES" >> $PATH_LOG
    else
      echo "$CURRENT_DATE"": Current IP:" "$CURRENT_IP" "and" "Host IP:" "$HOST_IP" "   IP has not changed" >> $PATH_LOG
    fi
  fi
done
