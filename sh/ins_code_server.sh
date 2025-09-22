#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_code_server.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que gnome este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@$USER


# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
