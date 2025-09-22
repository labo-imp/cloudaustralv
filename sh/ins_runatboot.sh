#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_runatboot.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que architecture este instalado
[ ! -e "/home/$USER/log/ins_buckets.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


sudo  cp   /home/$USER/cloud-install/unit/runatboot@.service   /etc/systemd/system/

sudo  systemctl daemon-reload
sudo  systemctl enable /etc/systemd/system/runatboot@$USER.service
sudo  systemctl start  runatboot@$USER.service

# systemctl status runatboot

bitacora   "runatboot"

# finalizo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
exit 0
