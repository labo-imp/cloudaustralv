#!/bin/bash
# fecha revision   2025-09-22  13:55

# corre en  instance-instalacion, llamado desde Cloud Shell

# parametros fundamentales
github_catedra_user="labo-imp"
github_install_repo="cloudaustralv"

sudo  DEBIAN_FRONTEND=noninteractive  apt-get update

rm -rf  /home/$USER/install
mkdir  -p  /home/$USER/install
mkdir  -p  /home/$USER/log

sudo  apt-get --yes  install  git rsync htop


# clono el repo de instalacion
rm -rf /home/$USER/cloud-install
cd
git clone  https://github.com/"$github_catedra_user"/"$github_install_repo".git   cloud-install

# permisos de ejecucion
chmod u+x  /home/$USER/cloud-install/sh/*.sh
chmod u+x  /home/$USER/cloud-install/jl/*.jl
chmod u+x  /home/$USER/cloud-install/direct/*.sh

# despersonalizacion
cp /home/$USER/cloud-install/sh/common.sh /home/$USER/install/

# copia de direct
cp /home/$USER/cloud-install/direct/*   /home/$USER/install/


source  /home/$USER/cloud-install/sh/common.sh
bitacora   "START  instalar.sh"

# tmux vim
/home/$USER/cloud-install/sh/ins_vimtmux.sh

