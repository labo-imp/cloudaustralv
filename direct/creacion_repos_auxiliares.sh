#!/bin/bash

# corre durante instalacion
mkdir  -p  /home/$USER/repos
mkdir  -p  /home/$USER/buckets/b1/repos
mkdir  -p  /home/$USER/buckets/b1/repos/catedra
mkdir  -p  /home/$USER/buckets/b1/repos/"$github_catedra_repo"

source  /home/$USER/install/common.sh

# repo oficial de la catedra "de cero"
# corre durante instalacion
cd /home/$USER/repos/
rm -rf /home/$USER/repos/catedra
cd  /home/$USER/repos/
git  clone https://github.com/$github_catedra_user/$github_catedra_repo   catedra
cd /home/$USER/repos/catedra
git checkout main


# sincronizo con la copia del bucket
rsync -a /home/$USER/repos/catedra/   /home/$USER/buckets/b1/repos/catedra/  --delete-after

