#!/bin/bash

sudo /usr/bin/ssh-keygen -A
mkdir -p /home/$USER/log

/home/$USER/install/zulip_enviar.sh  "startup     $HOSTNAME"

/usr/bin/gnome-extensions  enable Vitals@CoreCoding.com
/usr/bin/gnome-extensions  enable  executor@raujonas.github.io

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)


rm  /mnt/gcsfuse/log.txt

if [ ! -f /home/$USER/log/manual.txt ]; then

  if [[ $MIHOST == "zzzzzzzz" ]]; then
    /home/$USER/install/settimeout.sh  60 120 10
  fi

  if [[ $MIHOST == "desktop-jr" ]]; then
    /home/$USER/install/settimeout.sh  30 15 10
  fi
  
fi


if [[ $MIHOST == "desktop-jr" ]]; then
  /home/$USER/install/correr_en_desktop_jr.sh
fi

printf "antes\trunatboot\t$MIHOST\t$(date)\n"  >> /home/$USER/install/logmagico.txt

/home/$USER/install/startup-head.sh
printf "despueshead\trunatboot\t$MIHOST\t$(date)\n"  >> /home/$USER/install/logmagico.txt

cd /home/$USER/install/
rm autoexec.sh

github_catedra_user="labo-imp"
github_catedra_repo="cloud-install"

# clono el repo de instalacion
rm -rf /home/$USER/cloud-install
cd
git clone  https://github.com/"$github_catedra_user"/"$github_catedra_repo".git   cloud-install

# permisos de ejecucion
chmod u+x  /home/$USER/cloud-install/sh/*.sh
chmod u+x  /home/$USER/cloud-install/jl/*.jl
chmod u+x  /home/$USER/cloud-install/direct/*.sh

# despersonalizacion
cp /home/$USER/cloud-install/sh/common_austral.sh   /home/$USER/cloud-install/sh/common.sh
cp /home/$USER/cloud-install/sh/common.sh /home/$USER/install/

# copia de direct
cp /home/$USER/cloud-install/direct/*   /home/$USER/install/


source  /home/$USER/cloud-install/sh/common.sh

# ejecuto  autoexec.sh  es LA oportunidad de corregir
rm /home/$USER/install/autoexec_pre.sh
cp /home/$USER/cloud-install/direct/autoexec_pre.sh   /home/$USER/install/autoexec_pre.sh
chmod u+x /home/$USER/install/autoexec_pre.sh
cd /home/$USER/install/
./autoexec_pre.sh

/usr/bin/Rscript  /home/$USER/install/startup_mlflow.r


cp /home/$USER/cloud-install/direct/cambiar_claves.sh   /home/$USER/cambiar_claves.sh