#!/bin/bash
# fecha revision   2025-11-05  10:13

logito="ins_buckets.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que architecture este instalado
[ ! -e "/home/$USER/log/ins_architecture.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

# instalo Google Cloud Fuse  para poder ver el bucket  Version:  3.4.3 | Released:2025-11-05
# Documentacion https://cloud.google.com/storage/docs/gcs-fuse?hl=en-419

gcsfusever="3.4.4"
gcsfusepack="gcsfuse_"$gcsfusever"_amd64.deb"
cd
curl  -L -O "https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v$gcsfusever/$gcsfusepack"
sudo  DEBIAN_FRONTEND=noninteractive  dpkg --install $gcsfusepack
rm   /home/$USER/$gcsfusepack


sudo mkdir -p  /mnt/
sudo mkdir -p  /mnt/gcsfuse/
sudo mkdir -p  /mnt/alive/
sudo chown -R  $USER:$USER /mnt/gcsfuse/
sudo chown -R  $USER:$USER /mnt/alive/

# Preparo para que puedan haber 9 buckets al mismo tiempo
mkdir  -p  /home/$USER/buckets
mkdir  -p  /home/$USER/buckets/b1
mkdir  -p  /home/$USER/buckets/b2
mkdir  -p  /home/$USER/buckets/b3
mkdir  -p  /home/$USER/buckets/b4
mkdir  -p  /home/$USER/buckets/b5
mkdir  -p  /home/$USER/buckets/b6
mkdir  -p  /home/$USER/buckets/b7
mkdir  -p  /home/$USER/buckets/b8
mkdir  -p  /home/$USER/buckets/b9


sudo ln -s /home/$USER/   /content
sudo chown -R  $USER:$USER /content



sudo  cp   /home/$USER/cloud-install/unit/buckets@.service   /etc/systemd/system/


sudo  systemctl daemon-reload
sudo  systemctl enable  buckets@$USER.service
sudo  systemctl start  buckets@$USER.service
#systemctl status buckets@$USER.service

bitacora   "buckets"

sleep 5

# finalizo
systemctl is-active --quiet buckets@$USER.service
if [ ! $? -eq 0 ]; then
    echo "servicio buckets no esta funcionando"
    exit 1
else
  fecha=$(date +"%Y%m%d %H%M%S")
  echo $fecha > /home/$USER/log/$logito
  exit 0
fi

