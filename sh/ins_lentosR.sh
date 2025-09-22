#!/bin/bash
# fecha revision   2025-09-22  13:55


logito="ins_lentosR_finalizado.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_rlang.txt" ] && exit 1


# grabacion  inicial
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/ins_lentosR_iniciado.txt


source  /home/$USER/cloud-install/sh/common.sh

/home/$USER/install/semaforo open /sem_lentosR  0

mkdir -p /home/$USER/.R
echo "MAKEFLAGS = -j4"  >> /home/$USER/.R/Makevars
Rscript --verbose  /home/$USER/cloud-install/r/instalar_paquetes_lentos.r

/home/$USER/install/semaforo  post /sem_lentosR
/home/$USER/install/semaforo  post /sem_lentosR

bitacora   "lentosR"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
