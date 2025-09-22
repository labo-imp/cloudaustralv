#!/bin/bash

source  /home/$USER/install/common.sh

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

cd  /home/$USER/$github_catedra_repo

# upstream a  catedra
git checkout catedra
git pull origin catedra
git fetch upstream
git merge -X theirs  upstream/main  -m "sync upstream/main to catedra"


# catedra a main
git checkout main
git pull origin main
git merge  -X theirs  catedra   -m "catedra domina a main"

# creo la branch en caso que no exista, a partir de main
git branch    $MIHOST

# catedra pisa a HOST
git checkout  $MIHOST
git merge  -X theirs  catedra   -m "catedra domina  a HOST"
git merge  -X ours  main   -m "HOST domina  a main"
git checkout  $MIHOST
