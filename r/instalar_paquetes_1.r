options(repos = c("https://cloud.r-project.org/"))
options(Ncpus = 8)

install.packages( "pak",  dependencies= TRUE, INSTALL_opts="--no-multiarch" )
require("pak")

install.packages( "bspm",  dependencies= TRUE, INSTALL_opts="--no-multiarch" )
require("bspm")

bspm::disable()
paq1 <- c("data.table", "rpart", "yaml", "httr", "devtools", "yaml", "rlist")
paq2 <- c("magrittr", "stringi", "curl", "openssl", "roxygen2", "ranger")
paq3 <- c("dplyr", "caret", "covr", "lintr", "tidyverse", "tidyr", "shiny")
paq4 <- c("ggplot2", "plotly", "mlflow","markdown")
paq5 <- c()

paquetes <-  c( paq1, paq2, paq3, paq4, paq5 )
pak::pkg_install( paquetes )


library( "devtools" )
pak::pkg_install("IRkernel/IRkernel")
pak::pkg_install("krlmlr/ulimit")

quit( save="no" )