options(repos = c("https://cloud.r-project.org/"))
options(Ncpus = 8)

require("bspm")
bspm::disable()

library("devtools")
install_github("lantanacamara/lightgbmExplainer", INSTALL_opts="--no-multiarch" )

quit( save="no" )
