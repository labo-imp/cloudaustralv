#!/bin/bash

sudo /usr/bin/ssh-keygen -A
mkdir -p /home/$USER/log

/home/$USER/install/zulip_enviar.sh  "startup     $HOSTNAME"

/usr/bin/gnome-extensions  enable Vitals@CoreCoding.com
/usr/bin/gnome-extensions  enable  executor@raujonas.github.io

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

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

