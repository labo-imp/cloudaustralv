#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_zulip.txt"

# requiero que system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh
source  /home/$USER/install/secrets.sh

# cambio in-situ zulip_email es el del usuario
cp /home/$USER/cloud-install/direct/zulip_enviar.sh  /home/$USER/install/
sed -i  's/email/'"$zulip_email"'/g'  /home/$USER/install/zulip_enviar.sh


bitacora   "zulip"

fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito

exit 0
