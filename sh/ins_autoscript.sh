#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_autoscript.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que architecture este instalado
[ ! -e "/home/$USER/log/ins_buckets.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


sudo  cp   /home/$USER/cloud-install/unit/autoscript@.service   /etc/systemd/system/

sudo  systemctl daemon-reload
sudo  systemctl enable /etc/systemd/system/autoscript@$USER.service
sudo  systemctl start  autoscript@$USER.service

# systemctl status autoscript

bitacora   "autoscript"

# finalizo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
exit 0
