#!/bin/bash
# fecha revision   2025-09-22  13:55


source  /home/$USER/cloud-install/sh/common.sh
source  /home/$USER/install/secrets.sh



rm -rf  /home/$USER/tmp
mkdir -p /home/$USER/tmp


mkdir -p  /home/$USER/repos/
mkdir -p   /home/$USER/buckets/b1/repos/
mkdir -p   /home/$USER/buckets/b1/repos/catedra

rm -rf /home/$USER/repos/catedra


wget https://github.com/$github_catedra_user -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm -rf  /home/$USER/tmp
  echo "Error Fatal: no existe el usuario $github_catedra_user  en GitHub"
  exit 1
fi


wget https://github.com/$github_catedra_user/$github_catedra_repo -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm -rf  /home/$USER/tmp
  echo "Error Fatal: no existe el repo $github_catedra_user/$github_catedra_repo  en GitHub"
  exit 1
fi


cd /home/$USER/repos/
git  clone https://github.com/$github_catedra_user/$github_catedra_repo   catedra
if [ ! $? -eq 0 ]; then
  echo "Error Fatal: no pude clonar https://github.com/$github_catedra_user/$github_catedra_repo"
  exit 1
fi

cd /home/$USER/repos/catedra
git checkout main

# sincronizo con la copia del bucket
mkdir -p /home/$USER/buckets/b1/repos/
mkdir -p /home/$USER/buckets/b1/repos/catedra
rsync -a /home/$USER/repos/catedra/   /home/$USER/buckets/b1/repos/catedra/  --delete-after

exit 0
