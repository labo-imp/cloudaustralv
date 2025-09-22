#!/bin/bash

# corre con los services y  direct actualizados
# corre con los buckets montados

# 1. copia secrets
# 2. recrea (fantasmitas)  o actualiza (desktops)  repos

# permito el rdp
sudo systemctl enable --now xrdp
sudo systemctl start xrdp

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

if [ ! -d /home/$USER/buckets ]; then
    echo "Error Fatal : No existe la carpeta  /home/$USER/buckets"
    exit 1
fi

if [ ! -d /home/$USER/buckets/b1 ]; then
    echo "Error Fatal : No existe la carpeta  /home/$USER/buckets/b1"
    exit 1
fi


if [ ! -f /home/$USER/buckets/b1/kaggle.json ]; then
    echo "Error Fatal : No existe el archivo  /home/$USER/buckets/b1/kaggle.json"
    exit 1
fi

if [ ! -f /home/$USER/buckets/b1/secrets.sh ]; then
    echo "Error Fatal : No existe el archivo  /home/$USER/buckets/b1/secrets.sh"
    exit 1
fi


# conversion a newline de Linux
rm /home/$USER/buckets/b1/secrets.bak
mv /home/$USER/buckets/b1/secrets.sh  /home/$USER/buckets/b1/secrets.bak
perl -pe 's/\r\n|\r/\n/g'  /home/$USER/buckets/b1/secrets.bak  > /home/$USER/buckets/b1/secrets.sh
rm /home/$USER/buckets/b1/secrets.bak


# verificacion de los parametros de secrets.sh
if ! grep -q zulip_email /home/$USER/buckets/b1/secrets.sh; then
    echo "Error Fatal : el archivo secrets.sh no tiene el parametro  zulip_email"
    exit 1
fi

if ! grep -q github_usuario /home/$USER/buckets/b1/secrets.sh; then
    echo "Error Fatal : el archivo secrets.sh no tiene el parametro  github_usuario"
    exit 1
fi

if ! grep -q github_token /home/$USER/buckets/b1/secrets.sh; then
    echo "Error Fatal : el archivo secrets.sh no tiene el parametro  github_token"
    exit 1
fi

if ! grep -q github_email /home/$USER/buckets/b1/secrets.sh; then
    echo "Error Fatal : el archivo secrets.sh no tiene el parametro  github_email"
    exit 1
fi

if ! grep -q github_nombre /home/$USER/buckets/b1/secrets.sh; then
    echo "Error Fatal : el archivo secrets.sh no tiene el parametro  github_nombre"
    exit 1
fi


cp  /home/$USER/buckets/b1/secrets.sh   /home/$USER/install/
chmod u+x  /home/$USER/install/secrets.sh


# necesito ambos sets de variables de entorno
source  /home/$USER/cloud-install/sh/common.sh
source  /home/$USER/install/secrets.sh


# vuelvo a copiar kaggle.json por si cambio
rm -rf /home/$USER/.kaggle
mkdir -p /home/$USER/.kaggle
cp  /home/$USER/buckets/b1/kaggle.json   /home/$USER/.kaggle/
chmod 600 /home/$USER/.kaggle/kaggle.json


# clonado de repos
if [[ $MIHOST == "desktop-jr" ]] || [[ $MIHOST == "desktop-sr" ]]
then
  /home/$USER/cloud-install/direct/actualizar_repo_principal.sh
  /home/$USER/cloud-install/direct/actualizar_repos_auxiliares.sh
else
  # es un fantasmita  clono todo de cero
  /home/$USER/cloud-install/direct/clonar_usuario.sh
  /home/$USER/cloud-install/direct/clonar_catedra.sh
fi

#------------------------------------------------------------------------------
# Datasets, reintento si estan los nuevos

source  /home/$USER/cloud-install/sh/common.sh

cd /home/$USER/datasets/
find . -type f -size 0b -delete


cd  /home/$USER/buckets/b1/datasets
find . -type f -size 0b -delete


if [ ! -e "$dataset1" ]; then
  wget --quiet  --tries=3  $webfiles/"$dataset1"  -O  "$dataset1"
  if [ ! $? -eq 0 ]; then
    rm  "$dataset1"
  fi
fi

if [ ! -e "$dataset2" ]; then
  wget --quiet  --tries=3  $webfiles/"$dataset2"  -O  "$dataset2"
  if [ ! $? -eq 0 ]; then
    rm  $dataset2
  fi
fi


if [ ! -e "$dataset3" ]; then
  wget --quiet  --tries=3  $webfiles/"$dataset3"  -O  "$dataset3"
  if [ ! $? -eq 0 ]; then
    rm  $dataset3
  fi
fi


if [ ! -e "$dataset4" ]; then
  wget --quiet --tries=3  $webfiles/"$dataset4"  -O  "$dataset4"
  if [ ! $? -eq 0 ]; then
    rm  $dataset4
  fi
fi


rsync -av  /home/$USER/buckets/b1/datasets/  /home/$USER/datasets/

curl -s https://storage.googleapis.com/open-courses/austral2025-af91/health-check.sh   | bash   > /dev/null 2>&1
