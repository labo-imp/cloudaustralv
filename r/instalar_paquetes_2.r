options(repos = c("https://cloud.r-project.org/"))
options(Ncpus = 8)

require("bspm")
bspm::disable()

paq1 <- c("microbenchmark")
paq2 <- c("Rcpp", "Matrix", "glm2")
paq3 <- c("ROCR", "MASS", "synchronicity")
paq4 <- c("rsvg", "DiagrammeRsvg", "DiagrammeR", "modules")
paq5 <- c("DiceKriging",  "mlrMBO", "ParBayesianOptimization")
paq6 <- c("rpart", "rpart.plot", "randomForest", "mice")
paq7 <- c("languageserver")
paq8 <- c("SHAPforxgboost", "shapr", "mlflow", "visNetwork")
paq9 <- c("iml","primes","RhpcBLASctl")
paq10 <- c("mlr3","mlr3mbo","mlr3learners","mlr3tuning","bbotk","treeClust")
paq11 <- c("DBI","RMariaDB","filelock","Boruta","lime")
paq12 <- c("h2o","agua","automl")

paq <- c( paq1, paq2, paq3, paq4, paq5, paq6, paq7, paq8, paq9, paq10, paq11, paq12 )

require("pak")
pak::pkg_install( paq )


library( "devtools" )
pak::pkg_install("tibble")
pak::pkg_install("AppliedDataSciencePartners/xgboostExplainer")

pak::pkg_install( c("purrr","ps","diffobj","pkgbuild","fs","sass","mime","commonmark","tinytex"))
pak::pkg_install("NorskRegnesentral/shapr")

devtools::install_url('https://github.com/catboost/catboost/releases/download/v1.2.8/catboost-R-Linux-1.2.8.tgz', INSTALL_opts = c("--no-multiarch", "--no-test-load"))

pak::pkg_install("ManuelHentschel/vscDebugger")

pak::pkg_install("ja-thomas/autoxgboost")

Sys.setenv(NOT_CRAN = "true")
install.packages("polars", repos = "https://community.r-multiverse.org", INSTALL_opts="--no-multiarch" )

quit( save="no" )
