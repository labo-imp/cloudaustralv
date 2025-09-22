#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_mlflow.txt"
# si ya corrio esta seccion, exit

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_pyworld_inicial.txt" ] && exit 1
[ ! -e "/home/$USER/log/ins_rworld_inicial.txt" ] && exit 1

source  /home/$USER/cloud-install/sh/common.sh

envsubst < /home/$USER/cloud-install/cfg/mlflow.yml   >   /home/$USER/install/mlflow.yml

cp /home/$USER/cloud-install/r/startup_mlflow.r   /home/$USER/install
cp /home/$USER/cloud-install/r/shutdown_mlflow.r  /home/$USER/install
cp /home/$USER/cloud-install/r/alive_mlflow.r     /home/$USER/install


sudo  cp   /home/$USER/cloud-install/unit/alive_mlflow@.service   /etc/systemd/system/
sudo  cp   /home/$USER/cloud-install/unit/alive_mlflow@.timer   /etc/systemd/system/
sudo  systemctl enable alive_mlflow@$USER.timer
sudo  systemctl daemon-reload
sudo systemctl enable --now  alive_mlflow@$USER.timer


sudo  cp   /home/$USER/cloud-install/unit/shutdown_mlflow@.service   /etc/systemd/system/
sudo  systemctl daemon-reload
sudo  systemctl enable  shutdown_mlflow@$USER.service


bitacora   "mlflow"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
