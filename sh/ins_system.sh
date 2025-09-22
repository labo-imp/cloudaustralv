#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_system.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0


# requiero que architecture este instalado
[ ! -e "/home/$USER/log/ins_architecture.txt" ] && exit 1

# requiero que secrets este instalado
[ ! -e "/home/$USER/log/ins_secrets.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

sudo  DEBIAN_FRONTEND=noninteractive  apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes nala

# librerias necesarias para R, Python, Julia, JupyterLab, son mas de 700
sudo  DEBIAN_FRONTEND=noninteractive  nala install --assume-yes \
      libssl-dev  apt-utils                \
      libcurl4-openssl-dev  libxml2-dev    \
      libgeos-dev  libproj-dev             \
      libgdal-dev  librsvg2-dev            \
      ocl-icd-opencl-dev  libmagick++-dev  \
      libv8-dev  libsodium-dev             \
      libharfbuzz-dev  libfribidi-dev      \
      pandoc texlive  texlive-xetex        \
      texlive-fonts-recommended            \
      texlive-latex-recommended            \
      cmake  gdebi  curl  sshpass  nano    \
      htop  atop  iotop  iputils-ping      \
      cron  tmux  git-core  zip  unzip     \
      sysstat  smbclient cifs-utils  rsync \
      libudunits2-dev  inotify-tools       \
      libssh2-1-dev  libgit2-dev           \
      ffmpeg  gir1.2-gtop-2.0 lm-sensors   \
      libdbus-glib-1-dev libdbus-1-dev     \
      debconf-utils  swig  libopenblas-dev \
      libhiredis-dev  gdal-bin             \
      libglu1-mesa-dev  libgmp3-dev        \
      libgsl0-dev  jags  libmpfr-dev       \
      libopenmpi-dev  openssh-server sshfs 

bitacora   "system packages"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
