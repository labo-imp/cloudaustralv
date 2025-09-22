#!/bin/bash


source  /home/$USER/install/common.sh

mkdir -p /home/$USER/tmp/
wget https://github.com/"$github_catedra_user"/"$github_install_repo" -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm -rf  /home/$USER/tmp
  echo "No existe el repo $github_catedra_user/$github_catedra_repo  en GitHub"
  exit 0
fi


# clono el repo de instalacion
rm -rf /home/$USER/cloud-install
cd
git clone  https://github.com/"$github_catedra_user"/"$github_install_repo".git   cloud-install
if [ ! $? -eq 0 ]; then
  echo "No clonar $github_catedra_user/$github_install_repo"
  exit 1
fi

sudo  cp  /home/$USER/cloud-install/unit/*@.service   /etc/systemd/system/
sudo  systemctl daemon-reload
sudo  systemctl enable  runatboot@$USER.service

# permisos de ejecucion
chmod u+x  /home/$USER/cloud-install/sh/*.sh
chmod u+x  /home/$USER/cloud-install/jl/*.jl
chmod u+x  /home/$USER/cloud-install/direct/*.sh


# despersonalizacion
mkdir -p /home/$USER/install/
cp /home/$USER/cloud-install/sh/common_austral.sh   /home/$USER/cloud-install/sh/common.sh
cp /home/$USER/cloud-install/sh/common.sh  /home/$USER/install/


if [ -e /home/$USER/cloud-install/direct/services_recrear.sh ]; then
  cp /home/$USER/cloud-install/direct/services_recrear.sh  /home/$USER/install/
fi

# copia de direct
cp /home/$USER/cloud-install/direct/*   /home/$USER/install/


# shared dirs
source  /home/$USER/install/common.sh
envsubst < /home/$USER/cloud-install/cfg/expshared_cred.txt   >   /home/$USER/install/expshared_cred.txt

# memcpu
rm /home/$USER/install/memcpu  /home/$USER/install/settimeout
gcc -Wall /home/$USER/cloud-install/c/memcpu.cpp   -o /home/$USER/install/memcpu `pkg-config --libs gio-2.0 --cflags`
gcc  /home/$USER/cloud-install/c/settimeout.cpp   -o /home/$USER/install/settimeout
cp /home/$USER/cloud-install/direct/settimeout.sh  /home/$USER/install/

# mlflow
cp /home/$USER/cloud-install/r/startup_mlflow.r   /home/$USER/install
cp /home/$USER/cloud-install/r/shutdown_mlflow.r  /home/$USER/install
cp /home/$USER/cloud-install/r/alive_mlflow.r     /home/$USER/install

