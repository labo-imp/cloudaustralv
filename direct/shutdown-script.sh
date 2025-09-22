#!/bin/bash

bucket=$(/usr/bin/gsutil ls)

tab="	"
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha$tab$HOSTNAME  >  /home/$USER/install/z-GCshutdown.txt

ruta=""
if [ -f /home/$USER/install/rutashutdown.txt ]; then
  ruta=$(</home/$USER/install/rutashutdown.txt)
fi

/usr/bin/gsutil  cp  /home/$USER/install/z-GCshutdown.txt  $bucket$ruta/z-GCshutdown.txt
/home/$USER/install/zulip_enviar.sh  "SHUTDOWN     $HOSTNAME"
/home/$USER/install/shutdown-tail.sh
