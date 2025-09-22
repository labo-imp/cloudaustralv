#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_secrets.txt"
# si ya corrio esta seccion, exit
#   [ -e "/home/$USER/log/$logito" ] && exit 0


# requiero que buckets este instalado
[ ! -e "/home/$USER/log/ins_buckets.txt" ] && exit 0


source  /home/$USER/cloud-install/sh/common.sh

# multiples verificaciones

if [ ! -d /home/$USER/install ]; then
    echo "Error Fatal : No existe la carpeta  /home/$USER/install"
    exit 1
fi

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
rm -f /home/$USER/buckets/b1/secrets.bak
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


source  /home/$USER/buckets/b1/secrets.sh

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


rm -rf /home/$USER/.kaggle
mkdir -p /home/$USER/.kaggle
cp  /home/$USER/buckets/b1/kaggle.json   /home/$USER/.kaggle/
chmod 600 /home/$USER/.kaggle/kaggle.json



# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito

exit 0