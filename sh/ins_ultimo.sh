#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_final.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


sudo adduser $USER sudo


#------------------------------------------------------------------------------
# copio el siguiente paso  final.sh


source  /home/$USER/install/common.sh

wget  $webfiles/$script_final -O   /home/$USER/install/final.sh 
chmod  u+x /home/$USER/install/final.sh

#------------------------------------------------------------------------------
# ULTIMO  paso  Reacomodo la instalacion

sudo  DEBIAN_FRONTEND=noninteractive   apt-get  --yes  update
sudo  DEBIAN_FRONTEND=noninteractive   apt-get  --yes  dist-upgrade
sudo  DEBIAN_FRONTEND=noninteractive   apt-get  --yes  autoremove

bitacora   "update upgrade"

# Used  27G
#------------------------------------------------------------------------------
cd

bitacora   "final"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
