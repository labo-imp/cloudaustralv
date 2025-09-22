#!/bin/bash

printf "\n\n"
echo "ahora vamos a cambiar la password de Ubuntu y RStudio"
echo "se sugiere una facil compartible con su companeros de equipo"
sudo passwd $USER

printf "\n\n\n"
echo \"Tu nombre de usuario Ubuntu es :  \"  $USER
printf "\n\n\n"

echo "ahora vamos a cambiar la password de Jupyter Lab"
echo "se sugiere fuertemente poner la misma password que la anterior"
PATH=$PATH:/home/$USER/.venv/bin
DATA_DIR="$HOME"
sudo  systemctl stop  jupyterlab@$USER.service
sudo  systemctl disable jupyterlab@$USER.service
sudo  systemctl daemon-reload


rm -f /home/$USER/.jupyter/jupyter_server_config.py.old
if [ -f /home/$USER/.jupyter/jupyter_server_config.py ]; then
    mv  /home/$USER/.jupyter/jupyter_server_config.py  /home/$USER/.jupyter/jupyter_server_config.py.old
fi

/home/$USER/.venv/bin/jupyter lab password

sudo  systemctl enable jupyterlab@$USER.service
sudo  systemctl daemon-reload
sudo  systemctl start jupyterlab@$USER.service

# permito el rdp
sudo systemctl enable --now xrdp
sudo systemctl start xrdp
