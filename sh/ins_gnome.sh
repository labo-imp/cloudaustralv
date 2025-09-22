#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_gnome.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


# primera etapa, se instalan unos 1050 paquetes con el gnome
sudo  DEBIAN_FRONTEND=noninteractive  apt-get --yes  update
sudo  DEBIAN_FRONTEND=noninteractive  apt-get --yes  dist-upgrade
#sudo  DEBIAN_FRONTEND=noninteractive  apt-get  install  --yes  slim
sudo  DEBIAN_FRONTEND=noninteractive  nala  install  --assume-yes  ubuntu-gnome-desktop

sudo  DEBIAN_FRONTEND=noninteractive  apt-get --yes  update
sudo  DEBIAN_FRONTEND=noninteractive  apt-get --yes  dist-upgrade

#sudo  DEBIAN_FRONTEND=noninteractive  apt-get  install  --yes  kde-plasma-desktop 

sudo  DEBIAN_FRONTEND=noninteractive  nala  install  --assume-yes \
  gnome-tweaks  language-pack-gnome-en  language-pack-gnome-es \


# instalo xrdp para acceder desde Windows por Remote Desktop
sudo  DEBIAN_FRONTEND=noninteractive  nala  install  --assume-yes  xrdp

# abro en Google Cloud el puerto 3389
source  /home/$USER/cloud-install/sh/common.sh
MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

gcloud compute firewall-rules create xrdp --allow tcp:3389 --source-ranges=0.0.0.0/0 --description="xrdp" --project=$MY_PROJECT_ID


# disable multiple warnings
sudo  sed -i 's/<allow_inactive>no</<allow_inactive>yes</' /usr/share/polkit-1/actions/org.freedesktop.color.policy
sudo  sed -i 's/<allow_any>.*</<allow_any>yes</' /usr/share/polkit-1/actions/org.freedesktop.color.policy
sudo  sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades

# para que no salga ventana de warning por culpa de bluetooth
sudo  systemctl  stop     bluetooth
sudo  systemctl  disable  bluetooth
sudo  DEBIAN_FRONTEND=noninteractive  apt-get remove --yes  bluez

sudo  systemctl disable --now systemd-oomd.socket
sudo  systemctl disable --now systemd-oomd
# sudo  systemctl status systemd-oomd

# sudo systemctl status systemd-networkd-wait-online.service
sudo systemctl disable systemd-networkd-wait-online.service
# sudo systemctl status systemd-networkd-wait-online.service

# quito imagen fondo de pantalla, dejo color BLACK  solido
gsettings set org.gnome.desktop.background picture-uri none
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background color-shading-type 'solid'

# cambio los timeouts de idle
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay 1200
gsettings set org.gnome.desktop.session idle-delay 600

bitacora   "gnome"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
