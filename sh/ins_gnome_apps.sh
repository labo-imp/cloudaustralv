#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_gnome_apps.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que gnome este instalado
[ ! -e "/home/$USER/log/ins_gnome.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh


# LibreOffice
sudo  DEBIAN_FRONTEND=noninteractive  apt-get update
sudo  DEBIAN_FRONTEND=noninteractive  apt-get --yes install libreoffice

# Google Chrome
cd
wget  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive  dpkg -i google-chrome-stable_current_amd64.deb
rm   ./google-chrome-stable_current_amd64.deb
sudo  DEBIAN_FRONTEND=noninteractive  apt --yes  modernize-sources

# Brave Browser
sudo  curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo  "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo  DEBIAN_FRONTEND=noninteractive  apt-get update
sudo  DEBIAN_FRONTEND=noninteractive  apt-get install --yes brave-browser
sudo  DEBIAN_FRONTEND=noninteractive  apt --yes  modernize-sources


# RStudio desktop (atencion que NO es el servidor)
cd
sudo  DEBIAN_FRONTEND=noninteractive  apt-get update
wget  https://download1.rstudio.org/electron/jammy/amd64/rstudio-2025.09.0-387-amd64.deb
sudo  DEBIAN_FRONTEND=noninteractive  apt-get install  --yes -f ./rstudio-2025.09.0-387-amd64.deb
rm    rstudio-2025.09.0-387-amd64.deb

# bug RStudio desktop que se cuelga al arrancar
sudo chmod 4755 /usr/lib/rstudio/chrome-sandbox

# instalar VSCode -------------------------------------------------------------
sudo  DEBIAN_FRONTEND=noninteractive  apt-get update
sudo  apt-get install software-properties-common apt-transport-https wget -y
sudo snap install --classic code
sudo cp  /snap/code/current/snap/gui/code.desktop  /usr/share/applications/code.desktop

#wget  -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
#sudo  add-apt-repository --yes "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
#sudo  DEBIAN_FRONTEND=noninteractive  apt-get install --yes code


#instalo extensiones de VSCode
code  --install-extension  ms-python.python
code  --install-extension  ms-python.vscode-pylance

code  --install-extension  KevinRose.vsc-python-indent

code  --install-extension  ms-toolsai.jupyter
code  --install-extension  ms-toolsai.jupyter-keymap
code  --install-extension  ms-toolsai.jupyter-renderers

code  --install-extension  eamodio.gitlens
code  --install-extension  GitHub.copilot
code  --install-extension  GitHub.copilot-chat

code  --install-extension  REditorSupport.r
code  --install-extension  RDebugger.r-debugger

code  --install-extension  julialang.language-julia

code  --install-extension  usernamehw.todo-md

bitacora   "gnome_apps"
#------------------------------------------------------------------------------
# gnome extension  Vitals, show  only  Memory and CPU usage on bar

mkdir -p /home/$USER/.local/share/gnome-shell/extensions
git clone https://github.com/corecoding/Vitals.git   /home/$USER/.local/share/gnome-shell/extensions/Vitals@CoreCoding.com  -b  develop

# Se exporta con: dconf dump /

# hardcodeo la configuracion para mostrar solo  memoria y CPU
cp  /home/$USER/cloud-install/cfg/desktop.dconf  /home/$USER/.config/dconf/desktop.dconf

/usr/bin/gnome-extensions  enable  Vitals@CoreCoding.com

/usr/bin/gnome-extensions  disable Vitals@CoreCoding.com
/usr/bin/gnome-extensions  enable Vitals@CoreCoding.com


rm -rf  /home/$USER/.local/share/gnome-shell/extensions/executor@raujonas.github.io
wget  https://github.com/raujonas/executor/archive/refs/tags/v28.zip  -O  /home/$USER/install/executor-28.zip
gnome-extensions install  /home/$USER/install/executor-28.zip
/usr/bin/gnome-extensions  enable  executor@raujonas.github.io


cd /home/$USER/.config/dconf/  
dconf load / <  desktop.dconf
cd

#------------------------------------------------------------------------------
source  /home/$USER/cloud-install/sh/common.sh

wget  $webfiles/khabylame.png  \
      -O  /home/$USER/install/khabylame.png
      
envsubst < /home/$USER/cloud-install/direct/repobrutalcopy.desktop   >   /home/$USER/install/repobrutalcopy.desktop
sudo  cp  /home/$USER/install/repobrutalcopy.desktop    \
          /usr/share/applications/repobrutalcopy.desktop

envsubst < /home/$USER/cloud-install/direct/reposync.desktop   >   /home/$USER/install/reposync.desktop
sudo  cp  /home/$USER/install/reposync.desktop    \
          /usr/share/applications/reposync.desktop


# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
