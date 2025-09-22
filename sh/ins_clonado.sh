#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_clonado.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_rlang.txt" ] && exit 1


MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)


# mi repositorio
cd  /home/$USER/$github_catedra_repo

git remote  add  upstream  https://github.com/labo-imp/labo2024ba

git checkout -b catedra
git commit --allow-empty  -m "catedra empty"
git push  origin  catedra

git checkout catedra
git fetch upstream
git merge --no-ff  --allow-unrelated-histories  upstream/main  -m "sync upstream/main to catedra"
git push  origin  catedra

git checkout main
git merge  -X theirs  catedra   -m "catedra manda"
git push --set-upstream origin  main

# activo el branch
git checkout main
git branch   $MIHOST
git checkout $MIHOST
git push origin $MIHOST


bitacora   "clonado"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
