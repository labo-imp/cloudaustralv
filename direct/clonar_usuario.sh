#!/bin/bash
# fecha revision   2025-09-22  13:55


source  /home/$USER/cloud-install/sh/common.sh
source  /home/$USER/install/secrets.sh



rm -rf  /home/$USER/tmp
mkdir -p /home/$USER/tmp

wget https://github.com/$github_usuario -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm -rf  /home/$USER/tmp
  echo "Error Fatal: no existe el usuario $github_usuario  en GitHub"
  exit 1
fi


wget https://github.com/$github_usuario/$github_catedra_repo -O  /home/$USER/tmp/caca
if [ ! $? -eq 0 ]; then
  rm -rf  /home/$USER/tmp
  echo "Error Fatal: no existe el repo $github_usuario/$github_catedra_repo  en GitHub"
  exit 1
fi



rm -rf /home/$USER/"$github_catedra_repo"

cd
git clone https://"$github_usuario":"$github_token"@github.com/"$github_usuario"/"$github_catedra_repo".git
if [ ! $? -eq 0 ]; then
  echo "Error Fatal: no pude clonar  $github_usuario / $github_catedra_repo"
  exit 1
fi

if [ ! -d  /home/$USER/"$github_catedra_repo" ]; then
  echo "No existe la carpeta del repo $github_catedra_repo"
  exit 1
fi

cd  "$github_catedra_repo"
git config  user.email "$github_email"
git config  user.name "$github_nombre"


MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)
git remote  add  upstream  https://github.com/"$github_catedra_user"/"$github_catedra_repo"
if [ ! $? -eq 0 ]; then
  echo "Error Fatal: no pude add upstream  $github_usuario / $github_catedra_repo"
  exit 1
fi

git checkout -b catedra
git commit --allow-empty  -m "catedra empty"
git push  origin  catedra

git checkout catedra
git fetch upstream
git merge --no-ff  --allow-unrelated-histories  upstream/main  -m "sync upstream/main to catedra"
git push  origin  catedra

git checkout main
git merge  -X theirs  catedra   -m "catedra manda"
git push --set-upstream origin  main

# activo el branch
git checkout main
git branch   $MIHOST
git checkout $MIHOST
git push origin $MIHOST

exit 0
