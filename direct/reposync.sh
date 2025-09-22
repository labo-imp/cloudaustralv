#!/bin/bash

source  /home/$USER/install/common.sh

#!/bin/bash
MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

seq=$(cat /home/$USER/install/reposequence.txt)
seq=$((seq+1))
echo $seq  > /home/$USER/install/reposequence.txt

fecha=$(date +"%Y%m%d %H%M%S")

# actualizo repo catedra PURO ---------
# aqui solamente bajo, JAMAS escribo
cd /home/$USER/repos/catedra
git checkout develop
git pull origin develop
git checkout main
git pull origin main
rsync -a /home/$USER/repos/catedra/   /home/$USER/buckets/b1/repos/catedra/  --delete-after  &


# mi repositorio ----------------------
cd  /home/$USER/$github_catedra_repo

# catedra nunca tiene problemas
git checkout catedra || git checkout -b catedra
git fetch origin catedra
git merge  -X theirs   origin/catedra  -m "origin/catedra domina a catedra"
git fetch upstream
git merge  -X theirs   upstream/main  -m "sync upstream/main to catedra"
git push  origin  catedra


# activo el branch y lo pongo al dia con origin
git checkout $MIHOST || git checkout -b $MIHOST
git fetch origin $MIHOST
git merge  -X theirs   origin/$MIHOST  -m "origin/MIHOST domina a MIHOST"
git merge  -X theirs  catedra   -m "catedra domina  a MIHOST"
git merge  -X ours    main      -m "MIHOST domina  a main"
git push  origin  $MIHOST

# agrego lo nuevo al branch  MIHOST
git checkout $MIHOST || git checkout -b $MIHOST
git add .
git commit -m "auto commit $seq       $fecha"
git push   origin  $MIHOST


git checkout main
git merge  -X theirs  $MIHOST   -m "MIHOST domina  a main"
git fetch origin main
git merge  -X ours  origin/main   -m "MIHOST domina  a main"
git push  origin  main


# LENTA copia al bucket
git checkout $MIHOST || git checkout -b $MIHOST
rsync -a /home/$USER/$github_catedra_repo/   /home/$USER/buckets/b1/repos/$github_catedra_repo/  --delete-after  &


echo "Esperando 30 segundos"
sleep 30
