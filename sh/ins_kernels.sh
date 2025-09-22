#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_kernels.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que los lenguajes y jupyterlab esten instalados
[ ! -e "/home/$USER/log/ins_pyworld_final.txt" ] && exit 1
[ ! -e "/home/$USER/log/ins_jupyterlab.txt" ] && exit 1

source  /home/$USER/.venv/bin/activate

source  /home/$USER/cloud-install/sh/common.sh

#------------------------------------------------------------------------------
# configuro R para que pueda usarse desde Jupyter, kernel de R
# Cuarta instalacion de paquetes de R
# Documentacion  https://developers.refinitiv.com/article/setup-jupyter-notebook-r

if [ -e /home/$USER/log/ins_rworld_final.txt ]; then
  Rscript --verbose  /home/$USER/cloud-install/r/instalar_paquetes_4.r
  bitacora   "R  kernel"
fi

# Used  25G
#------------------------------------------------------------------------------
# Agrego el kernel de Julia a Jupyterlab

if [ -e /home/$USER/log/ins_jlworld_final.txt ]; then
  /home/$USER/.juliaup/bin/julia   /home/$USER/cloud-install/jl/instalar_paquetes_julia_2.jl
  bitacora   "Julia kernel"
fi


bitacora   "Julia kernel"

#------------------------------------------------------------------------------
# Define home directory and data directory (adjust to your needs)

mkdir  -p /home/$USER/.jupyter/
USER_HOME_DIR=$(echo ~)
DATA_DIR="$USER_HOME_DIR"/
# Create the data directory

#------------------------------------------------------------------------------
# El servicio de Jupyter Lab

# password default
mkdir  -p /home/$USER/.jupyter
cat > /home/$USER/.jupyter/jupyter_server_config.json <<FILE
{
  "IdentityProvider": {
    "hashed_password": "argon2:$argon2id$v=19$m=10240,t=10,p=8$KuB64Bj/00OM/8CMhHaLPA$6yhxYaw+uQ+nl1GwDQObfuP8tG8ck1sjKIlF8ySLP/E"
  }
} 
FILE
chmod  0600    /home/$USER/.jupyter/jupyter_server_config.json


cat > /home/$USER/install/jupyterlab.sh  <<FILE
#!/bin/bash
source /home/$USER/.venv/bin/activate
/home/$USER/.venv/bin/jupyter-lab --no-browser --port=8888 --ip=0.0.0.0 --NotebookApp.token= --notebook-dir=/home/$USER/
FILE
chmod  u+x    /home/$USER/install/jupyterlab.sh



sudo  cp /home/$USER/cloud-install/unit/jupyterlab@.service   /etc/systemd/system/
sudo  systemctl daemon-reload
sudo  systemctl enable jupyterlab@$USER.service
sudo  systemctl start jupyterlab@$USER.service
# el servicio aun NO esta corriendo

# systemctl status jupyterlab


bitacora   "kernels"

sleep 10
systemctl is-active --quiet jupyterlab@$USER.service
if [ ! $? -eq 0 ]; then
    echo "servicio jupyterlab no esta funcionando"
    exit 1
else
  fecha=$(date +"%Y%m%d %H%M%S")
  echo $fecha > /home/$USER/log/$logito
  exit 0
fi

