#!/bin/bash

source  /home/$USER/install/common.sh

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

cd  /home/$USER/$github_catedra_repo
git checkout $MIHOST || git checkout -b $MIHOST
rsync -a /home/$USER/$github_catedra_repo/   /home/$USER/buckets/b1/repos/$github_catedra_repo/  --delete-after


if [[ $MIHOST == "desktop-analistajr" ]]; then
  rsync -a /home/$USER/buckets/b1/   /home/$USER/buckets/b2/
fi

