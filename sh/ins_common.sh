#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_common.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0



source  /home/$USER/cloud-install/sh/common.sh


# multiples verificaciones
rm -rf  /home/$USER/tmp
mkdir -p /home/$USER/tmp

wget https://github.com/$github_catedra_user -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm   /home/$USER/tmp/*
  echo "Error Fatal: no existe el usuario $github_catedra_user  en GitHub"
  exit 1
fi


wget https://github.com/$github_catedra_user/$github_catedra_repo  -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm   /home/$USER/tmp/*
  echo "Error Fatal: no existe el repo $github_catedra_user/$github_catedra_repo  en GitHub"
  exit 1
fi


wget $webfiles/existe.txt  -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm   /home/$USER/tmp/*
  echo "Error Fatal: no existe el archivo $webfiles/existe.txt"
  exit 1
fi


rm -rf  /home/$USER/tmp

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito

exit 0