#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_gnome_menus.txt"
# si ya corrio esta seccion, exit
# [ -e "/home/$USER/log/$logito" ] && exit 0


# requiero que buckets este instalado
[ ! -e "/home/$USER/log/ins_gnome.txt" ] && exit 0
[ ! -e "/home/$USER/log/ins_gnome_apps.txt" ] && exit 0


source  /home/$USER/cloud-install/sh/common.sh
source  /home/$USER/install/secrets.sh


# reposync --------------------------------------
wget  $webfiles/github.png  \
      -O  /home/$USER/install/github.png


envsubst < /home/$USER/cloud-install/cfg/reposync.desktop   >   /home/$USER/install/reposync.desktop

sudo  cp  /home/$USER/install/reposync.desktop    \
          /usr/share/applications/reposync.desktop


# repobrutalcopy ---------------------------------
wget  $webfiles/khabylame.png  \
      -O  /home/$USER/install/khabylame.png


envsubst < /home/$USER/cloud-install/cfg/repobrutalcopy.desktop   >   /home/$USER/install/repobrutalcopy.desktop

sudo  cp  /home/$USER/install/repobrutalcopy.desktop    \
          /usr/share/applications/repobrutalcopy.desktop


# Establecer  Menu Dash -------------------------


gsettings set org.gnome.shell favorite-apps "[ 'thunderbird.desktop', \
     'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', \
     'yelp.desktop', 'firefox_firefox.desktop', 'google-chrome.desktop', \
     'brave-browser.desktop', 'org.gnome.Terminal.desktop', 'htop.desktop', \
     'jupyterlab.desktop', 'R.desktop', 'rstudio.desktop', \
     'code.desktop', 'reposync.desktop', 'repobrutalcopy.desktop' ]"


bitacora   "aplicaciones"


# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito

exit 0
