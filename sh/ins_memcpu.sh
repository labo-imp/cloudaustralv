#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_memcpu.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1

source  /home/$USER/cloud-install/sh/common.sh



rm /home/$USER/install/memcpu  /home/$USER/install/settimeout
gcc -Wall /home/$USER/cloud-install/c/memcpu.cpp   -o /home/$USER/install/memcpu `pkg-config --libs gio-2.0 --cflags`
gcc  /home/$USER/cloud-install/c/settimeout.cpp   -o /home/$USER/install/settimeout


cp /home/$USER/cloud-install/direct/settimeout.sh  /home/$USER/install/


sudo  cp  /home/$USER/cloud-install/unit/memcpu@.service   /etc/systemd/system/

sudo  systemctl daemon-reload
sudo  systemctl enable  memcpu@$USER.service
# sudo  systemctl start  memcpu
# sudo  systemctl status  memcpu

bitacora   "memcpu"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
