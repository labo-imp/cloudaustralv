#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_autoexec.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_services_recrear.txt" ] && exit 1

source  /home/$USER/cloud-install/sh/common.sh

sudo  cp  /home/$USER/cloud-install/unit/autoexec@.service   /etc/systemd/system/
sudo  systemctl daemon-reload
sudo  systemctl enable autoexec@$USER.service



bitacora   "autoexec"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito

exit 0