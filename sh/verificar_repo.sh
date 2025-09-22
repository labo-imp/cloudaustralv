#!/bin/bash
# fecha revision   2025-09-22  13:55

source  /home/$USER/install/common.sh
source  /home/$USER/install/secrets.sh

if [ ! -d /home/$USER/$github_catedra_repo ]; then
    printf "\nError Fatal : No existe la carpeta del repositorio /home/$USER/$github_catedra_repo\n\n"
    exit 1
fi

if [ ! -d /home/$USER/$github_catedra_repo/src ]; then
    printf "\nError Fatal : No existe la carpeta  del repositorio  /home/$USER/$github_catedra_repo/src\n\n"
    exit 1
fi


if [ ! -d /home/$USER/$github_catedra_repo/$repo_check_directory ]; then
    printf "\nError Fatal : No existe la carpeta  del repositorio  /home/$USER/$github_catedra_repo/$repo_check_directory\n\n"
    exit 1
fi

if [ ! -f /home/$USER/$github_catedra_repo/$repo_check_directory/$repo_check_file ]; then
    printf "\nError Fatal : No existe el archivo  /home/$USER/$github_catedra_repo/$repo_check_directory/$repo_check_file\n\n"
    exit 1
fi


cd /home/$USER/$github_catedra_repo/

git rev-parse
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: git rev-parse fallo\n\n"
  exit 1
fi

git status
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: git status fallo\n\n"
  exit 1
fi

git branch --all
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: git branch -all  fallo\n\n"
  exit 1
fi

git rev-parse --verify   main
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: No existe branch  main\n\n"
  exit 1
fi

git rev-parse --verify   origin/main
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: No existe branch  origin/main\n\n"
  exit 1
fi

# git rev-parse --verify   instance-instalacion
# if [ ! $? -eq 0 ]; then 
#  echo "Error Fatal: No existe instance-instalacion"
#  exit
#fi


git ls-remote --exit-code --heads origin  main
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: No existe main en remote\n\n"
  exit 1
fi

git ls-remote --exit-code --heads origin  catedra
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: No existe catedra en remote\n\n"
  exit 1
fi

# git ls-remote --exit-code --heads origin  instance-instalacion
# if [ ! $? -eq 0 ]; then 
#  echo "Error Fatal: No existe instance-instalacion en remote"
#  exit
# fi


git fetch upstream
if [ ! $? -eq 0 ]; then 
  printf "\nError Fatal: Fallo  git fetch upstream\n\n"
  exit 1
fi


source  /home/$USER/install/common.sh
source  /home/$USER/install/secrets.sh

if [ ! -f /home/$USER/cloud-install/r/"$kaggleprueba" ]; then
    printf "\nError : No existe el archivo  /home/$USER/install/""$kaggleprueba\n\n"
    exit 1
fi

cp /home/$USER/cloud-install/r/"$kaggleprueba"  /home/$USER/$github_catedra_repo/$repo_check_directory/
if [ ! $? -eq 0 ]; then 
  printf "\nError : No se pudo copiar /home/$USER/install/$kaggleprueba\n\n"
  exit 1
fi

cd /home/$USER/$github_catedra_repo/

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

git checkout catedra
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git checkout catedra\n\n"
  exit 1
fi

git pull origin catedra
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git pull origin catedra\n\n"
  exit 1
fi

git fetch upstream
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git fetch upstream\n\n"
  exit 1
fi

git merge  -X theirs   upstream/main  -m "sync upstream/main to catedra"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git merge  -X theirs   upstream/main  -m 'sync upstream/main to catedra' \n\n"
  exit 1
fi

git push  origin  catedra
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git push  origin  catedra \n"
  printf "\nFatal Error : POSIBLEMENTE  su github token es INCORRECTO \n\n"
  exit 1
fi

#--------

git checkout main
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git checkout main\n\n"
  exit 1
fi

git pull origin main
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git pull origin main\n\n"
  exit 1
fi

git merge  -X theirs  catedra   -m "catedra domina a main"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git merge  -X theirs  catedra   -m 'catedra domina a main'\n\n"
  exit 1
fi

git push --set-upstream origin  main
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git push --set-upstream origin  main\n\n"
  exit 1
fi

git checkout main
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git checkout main\n\n"
  exit 1
fi


# activo el branch
git checkout $MIHOST
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git checkout $MIHOST \n\n"
  exit 1
fi

git pull origin $MIHOST
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git pull origin $MIHOST \n\n"
  exit 1
fi

git merge  -X theirs  catedra   -m "catedra domina  a MIHOST"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git merge  -X theirs  catedra   -m 'catedra domina  a MIHOST' \n\n"
  exit 1
fi

git merge  -X ours    main      -m "MIHOST domina  a main"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git merge  -X ours    main      -m 'MIHOST domina  a main' \n\n"
  exit 1
fi

git push  origin  $MIHOST
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git push  origin  $MIHOST \n\n"
  exit 1
fi

git checkout main

git merge  -X theirs  $MIHOST   -m "MIHOST domina  a main"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git merge  -X theirs  $MIHOST   -m 'MIHOST domina  a main' \n\n"
  exit 1
fi

git push  origin  main
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git push  origin  main\n\n"
  exit 1
fi


# cargo lo nuevo
git checkout $MIHOST

cp /home/$USER/cloud-install/r/"$kaggleprueba"  /home/$USER/$github_catedra_repo/$repo_check_directory/
if [ ! $? -eq 0 ]; then 
  printf "\nError : No se pudo copiar /home/$USER/install/$kaggleprueba\n\n"
  exit 1
fi

git add /home/$USER/$github_catedra_repo/$repo_check_directory/"$kaggleprueba"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git add /home/$USER/$github_catedra_repo/$repo_check_directory/$kaggleprueba  \n\n"
  exit 1
fi

git commit -m "$repo_check_directory/$kaggleprueba"


git push   origin  $MIHOST
git checkout main
git merge  -X theirs  $MIHOST   -m "MIHOST domina  a main"
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git merge  -X theirs  $MIHOST   -m 'MIHOST domina  a main' \n\n"
  exit 1
fi

git push  origin  main
if [ ! $? -eq 0 ]; then 
  printf "\nFatal Error : git push  origin  main\n\n"
  exit 1
fi

git checkout $MIHOST


echo
echo  repositorio OK

fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/ins_verificar_repo.txt

exit 0