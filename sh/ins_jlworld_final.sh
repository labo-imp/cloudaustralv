#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_jlworld_final.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1

[ ! -e "/home/$USER/log/ins_jlworld_inicial.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

# Used  23G

# genero script con paquetes a instalar de Julia
# Documentacion  https://datatofish.com/install-package-julia/

/home/$USER/.juliaup/bin/julia  /home/$USER/cloud-install/jl/instalar_paquetes_julia_1.jl

bitacora   "Julia packages"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
