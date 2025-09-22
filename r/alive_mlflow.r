
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
  mlflow_set_tracking_uri( MLFLOW$tracking_uri )

  Sys.setenv( PATH=paste0( "/home/", Sys.info()["user"], "/.venv/bin:",
                           Sys.getenv("PATH")) )

  Sys.setenv(MLFLOW_BIN= Sys.which("mlflow") )
  Sys.setenv(MLFLOW_PYTHON_BIN= Sys.which("python3") )
  Sys.setenv(MLFLOW_TRACKING_URI= MLFLOW$tracking_uri, intern= TRUE )
}
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#Aqui empieza el programa

user_st  <-  Sys.info()["user"]
exp_mlflow_iniciar( user_st )


res  <- read_yaml(  paste0("/home/", user_st, "/log/start.yml")  )

t0  <- Sys.time()

mlflow_log_metric( run_id= res$run_uuid, 
                  key= "alive_date", 
                  value= as.numeric( format( t0, "%Y%m%d")) )

mlflow_log_metric( run_id= res$run_uuid, 
                  key= "alive_time", 
                  value= as.numeric( format( t0, "%H.%M%S")) )


quit( save= "no" )
