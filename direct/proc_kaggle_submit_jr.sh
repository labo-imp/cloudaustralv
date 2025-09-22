#!/bin/bash

source /home/$USER/install/common.sh

hacersubmit=$1
archivo=$2
comentario=$3

echoerr() { printf "\033[0;31m%s\n\033[0m" "$*" >&2; }

if [ ! -f $archivo ]; then
    echoerr  no existe el archivo  $archivo
    echo 0.0
    exit
fi


# establezco el nombre de la competencia
source /home/$USER/.venv/bin/activate

if  [[ $hacersubmit  == "TRUE" ]] ; then
  kaggle competitions submit -c  $kaggle_competencia_jr \
  -f  $archivo \
  -m   "$comentario" \
   > /dev/null
fi

/home/$USER/install/list  $archivo
