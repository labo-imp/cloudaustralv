
require("yaml")
require("mlflow")


#para que muestre el lugar del error
options(show.error.locations = TRUE)

#para que se DETENGA  ante un error, y muestre el stack
options(error = function() { 
  traceback(20); 
  options(error = NULL); 
  stop("exiting after script error") 
})


#------------------------------------------------------------------------------
#inicializo el ambiente de mlflow

exp_mlflow_iniciar  <- function( puser_st )
{
  #leo uri, usuario y password
  MLFLOW  <<- read_yaml(  paste0("/home/", puser_st, "/install/mlflow.yml" ) )
  MLFLOW$tracking_uri <- gsub( "\"", "", MLFLOW$tracking_uri )

  Sys.setenv( MLFLOW_TRACKING_USERNAME= MLFLOW$tracking_username )
  Sys.setenv( MLFLOW_TRACKING_PASSWORD= MLFLOW$tracking_password )
  res <- mlflow_set_tracking_uri( MLFLOW$tracking_uri )

  Sys.setenv( PATH=paste0( "/home/", Sys.info()["user"], "/.venv/bin:",
                           Sys.getenv("PATH")) )

  Sys.setenv(MLFLOW_BIN= Sys.which("mlflow") )
  Sys.setenv(MLFLOW_PYTHON_BIN= Sys.which("python3") )
  Sys.setenv(MLFLOW_TRACKING_URI= MLFLOW$tracking_uri, intern= TRUE )
}
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#Aqui empieza el programa

user_st  <- Sys.info()[["user"]]
exp_mlflow_iniciar( user_st )

#creo el experimento del usuario
exp_st   <- paste0( "/vm" )
mlflow_set_experiment( experiment_name = exp_st )   #si ya esta creado, no pasa nada

#Seteo el tag del nombre de usuario
mlflow_set_experiment_tag( key= "user", value= user_st )

res <- mlflow_start_run( nested= TRUE )
mlflow_set_tag("mlflow.runName", "vm")

mlflow_log_param( key= "user", value= user_st )
mlflow_log_param( key= "machine",  value= Sys.info()["nodename"] )
mlflow_log_param( key= "boot",   value= format(Sys.time(), "%Y%m%d %H%M%S") )

#grabo el id del experimento
write_yaml( res,  file=  paste0("/home/", user_st, "/log/start.yml") )



quit( save= "no" )
