#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_sysstat.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


sudo  sed -i  's/5-55\/10/1-59\/1/' /etc/cron.d/sysstat
sudo  sed -i  's/ENABLED=\"false\"/ENABLED=\"true\"/'    /etc/default/sysstat
sudo  service sysstat restart
sudo  systemctl daemon-reload


bitacora   "sysstat"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
