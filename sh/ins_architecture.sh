#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_architecture.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

source  /home/$USER/cloud-install/sh/common.sh

# instalo Google Cloud SDK
# Documentacion  https://cloud.google.com/sdk/docs/install#deb

sudo  DEBIAN_FRONTEND=noninteractive  apt-get update
sudo  DEBIAN_FRONTEND=noninteractive apt-get install --yes nala

sudo  DEBIAN_FRONTEND=noninteractive  nala install --assume-yes  apt-transport-https ca-certificates gnupg curl perl

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo  DEBIAN_FRONTEND=noninteractive  nala install --assume-yes  google-cloud-cli


# arquitectura
#sudo  DEBIAN_FRONTEND=noninteractive  apt-get update  && sudo dpkg --add-architecture  i386
sudo  DEBIAN_FRONTEND=noninteractive  nala install --assume-yes  software-properties-common  build-essential


bitacora   "architecture"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
