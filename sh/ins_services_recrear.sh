#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_services_recrear.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que architecture este instalado
[ ! -e "/home/$USER/log/ins_architecture.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


sudo  cp   /home/$USER/cloud-install/unit/services_recrear@.service   /etc/systemd/system/
cp  /home/$USER/cloud-install/direct/services_recrear.sh  /home/$USER/install

sudo  systemctl daemon-reload
sudo  systemctl enable  services_recrear@$USER.service
# No le hago el start


bitacora   "services_recrear"


fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
exit 0


