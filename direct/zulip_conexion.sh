#!/bin/bash

echo "ingrese SU email utilizado en Zulip"
read  leido
sed -i  's/email/'"\$leido"'/g'  /home/$USER/install/zulip_enviar.sh

sleep 2
/home/$USER/install/zulip_enviar.sh  "se ha vinculado Zulip correctamente"
