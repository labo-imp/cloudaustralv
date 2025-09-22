#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_halfswap.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

sudo  cp  /home/$USER/cloud-install/unit/halfswap@.service   /etc/systemd/system/
sudo  systemctl daemon-reload
sudo  systemctl enable halfswap@$USER.service


# sudo  systemctl start  halfswap
# sudo systemctl status  shareddirs

bitacora   "halfswap"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
