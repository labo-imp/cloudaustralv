#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_pyworld_final.txt"
# si ya corrio esta seccion, exit
[ -e "/home/$USER/log/$logito" ] && exit 0

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1
[ ! -e "/home/$USER/log/ins_pyworld_inicial.txt" ] && exit 1



source  /home/$USER/cloud-install/sh/common.sh

# Instalo Python SIN  Anaconda, Miniconda, etc-------------------------------
# Documentacion  https://docs.python-guide.org/starting/install3/linux/


source  /home/$USER/.venv/bin/activate

# instalo paquetes de Python
/home/$USER/.local/bin/uv pip install  \
    Pandas  Scikit-learn  Statsmodels       \
    Numpy  Matplotlib  fastparquet          \
    pyarrow  tables  plotly  seaborn xlrd   \
    scrapy  SciPy  wheel  testresources     \
    Requests  Selenium  PyTest  Unit        \
    dask  numba  polars  Flask 

/home/$USER/.local/bin/uv pip install  duckdb  jupysql  duckdb-engine

/home/$USER/.local/bin/uv pip install  XGBoost  LightGBM  CatBoost HyperOpt  optuna

/home/$USER/.local/bin/uv pip install  Boruta lime

# AutoML varios
/home/$USER/.local/bin/uv pip install  h2o
/home/$USER/.local/bin/uv pip install  flaml
/home/$USER/.local/bin/uv pip install  tpot

/home/$USER/.local/bin/uv pip install --no-deps  evalml

# Keras
/home/$USER/.local/bin/uv pip install  Keras

# librerias puntuales
/home/$USER/.local/bin/uv pip install  kaggle  zulip  pika  gdown  mlflow
/home/$USER/.local/bin/uv pip install  black[jupyter] category-encoders colorama featuretools holidays

/home/$USER/.local/bin/uv pip install \
   imbalanced-learn ipywidgets kaleido nlp-primitives pmdarima scikit-optimize --no-build-isolation --index-strategy unsafe-best-match

/home/$USER/.local/bin/uv pip install  shap sktime texttable tomli woodwork[dask]
/home/$USER/.local/bin/uv pip install  nbconvert[webpdf]
/home/$USER/.local/bin/uv pip install  nb_pdf_template


/home/$USER/.local/bin/uv pip install  pydbus

/home/$USER/.local/bin/uv pip install  shap
/home/$USER/.local/bin/uv pip install  dask-expr
/home/$USER/.local/bin/uv pip install  umap umap-learn 



bitacora   "python packages final"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
