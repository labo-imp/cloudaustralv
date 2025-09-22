#!/bin/bash

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

if [[ ! $MIHOST == "desktop-jr" ]]; then
  exit
fi

if [ ! -f /home/$USER/buckets/b2/iniciado.txt ]; then
  rsync -a /home/$USER/buckets/b2/   /home/$USER/buckets/b1/
  echo "iniciado" > /home/$USER/buckets/b2/iniciado.txt
fi

