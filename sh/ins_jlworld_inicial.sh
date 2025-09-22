#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_jlworld_inicial.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

# Instalo Julia   version: 1.11.5  | Release Date: 2025-04-14 ---------------
# Documentacion  https://julialang.org/downloads/platform/#linux_and_freebsd

sudo  DEBIAN_FRONTEND=noninteractive  apt-get update

# Instalo la ultima version estable de Julia
cd  /home/$USER/install/
curl -fsSL https://install.julialang.org > julia_install.sh
chmod  u+x /home/$USER/install/julia_install.sh
./julia_install.sh --yes  --add-to-path true

cd
. /home/$USER/.bashrc
source  /home/$USER/.venv/bin/activate

# corro script de Julia
/home/$USER/.juliaup/bin/julia  /home/$USER/cloud-install/jl/test_julia.jl  /home/$USER/log/ins_julia.txt

[ ! -e "/home/$USER/log/ins_julia.txt" ] && exit 1

bitacora   "Julia language"


# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
