#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_xgboost.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_rlang.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

/home/$USER/install/semaforo open /sem_xgboost  0

cd
rm -rf  xgboost
git clone --recursive  https://github.com/dmlc/xgboost
cd xgboost
git submodule init
git submodule update
cd R-package
R CMD INSTALL .
cd
rm -rf  xgboost


/home/$USER/install/semaforo  post /sem_xgboost

bitacora   "xgboost"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
