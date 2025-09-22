#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_expshared.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

export smb_shared=expshared-austral

envsubst < /home/$USER/cloud-install/sh/shareddirs.sh   >   /home/$USER/install/shareddirs.sh
chmod u+x  /home/$USER/install/shareddirs.sh

envsubst < /home/$USER/cloud-install/cfg/expshared_cred.txt   >   /home/$USER/install/expshared_cred.txt

sudo  cp /home/$USER/cloud-install/unit/shareddirs@.service  /etc/systemd/system/
sudo  systemctl enable /etc/systemd/system/shareddirs@$USER.service
sudo  systemctl daemon-reload
sudo  systemctl start  shareddirs@$USER.service

# sudo systemctl status  shareddirs

bitacora   "expshared"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
