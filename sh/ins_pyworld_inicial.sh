#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_pyworld_inicial.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

# Instalo Python SIN  Anaconda, Miniconda, etc-------------------------------
# Documentacion  https://docs.python-guide.org/starting/install3/linux/

# instalacion  uv
curl -LsSf https://astral.sh/uv/install.sh | sh

export PATH="$PATH:/home/$USER/.local/bin"
echo  "export PATH=/home/\$USER/.local/bin:\$PATH"  >>  /home/$USER/.bashrc
chmod u+x /home/$USER/.bashrc
source /home/$USER/.bashrc 


sudo  apt-get update

#--------------------------------------
# Python 3.11

uv venv  .venv311 --python 3.11

# activo python 3.11
source /home/$USER/.venv311/bin/activate

uv pip install --upgrade pip
uv pip install setuptools

# Pycaret en  Python 3.11
uv pip install  pycaret[full]

# instalo  datatable desde su repo   en  Python  3.11
uv pip install  datatable

# instalo  auto-sklearn   en  Python  3.11
# pip3 install numpy scipy scikit-learn pandas dask distributed joblib psutil lockfile
# pip install pyrfr
# pip3 install  auto-sklearn

# desactivo Python 3.11
deactivate


#--------------------------------------
# Python 3.12

uv venv  .venv312 --python 3.12

# activo python 3.12
source /home/$USER/.venv312/bin/activate

uv pip install --upgrade pip
uv pip install setuptools

# instalo AutoGluon en  Python  3.12
uv pip install -U setuptools wheel
pip install uv
python -m uv pip install autogluon --extra-index-url https://download.pytorch.org/whl/cpu --index-strategy unsafe-best-match

# instalo  datatable desde su repo   en  Python  3.12
uv pip install  datatable

uv pip install  tensorflow  Keras

# desactivo Python 3.12
deactivate

#--------------------------------------
# Python 3.13.7  2025-09-02

#sudo  DEBIAN_FRONTEND=noninteractive  apt-get --yes install \
#        python3.13 python3-pip  python3-dev  ipython3  python3.12-venv


uv venv  .venv --python 3.13

# activo python 3.13
source /home/$USER/.venv/bin/activate


# actualizo  pip
uv pip install --upgrade pip
uv pip install setuptools
uv pip install -U setuptools wheel

bitacora   "Python"

# instalo paquetes iniciales de Python
uv pip install  kaggle  zulip


#--------------------------------------

bitacora   "python packages"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
