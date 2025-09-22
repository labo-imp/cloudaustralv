#!/bin/bash

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

/snap/bin/gsutil ls | sed -r 's/gs:\/\///' | sed 's/.$//'       \
|  sed 's/^/\/usr\/bin\/gcsfuse  --implicit-dirs --temp-dir \/mnt\/gcsfuse --log-file \/mnt\/gcsfuse\/log.txt  --log-severity TRACE --file-mode 777 --dir-mode 777    /'    \
|  sed 's/$/ \/home\/$USER\/buckets\/b/'    \
|  awk '{ print $0NR}' >  /home/$USER/install/linkear_buckets2.sh


if [[ $MIHOST == "desktop-analistajr" ]]; then

  cat <(echo 1111  & /snap/bin/gsutil ls) | sed -r 's/gs:\/\///' | sed 's/.$//'       \
  |  sed 's/^/\/usr\/bin\/gcsfuse  --implicit-dirs --temp-dir \/mnt\/gcsfuse --log-file \/mnt\/gcsfuse\/log.txt  --log-severity TRACE --file-mode 777 --dir-mode 777    /'    \
  |  sed 's/$/ \/home\/$USER\/buckets\/b/'    \
  |  awk '{ print $0NR}' | tail -n+2 >  /home/$USER/install/linkear_buckets2.sh

fi

chmod  u+x  /home/$USER/install/linkear_buckets2.sh
/home/$USER/install/linkear_buckets2.sh
