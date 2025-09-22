options(repos = c("https://duckdb.r-universe.dev/"))
options(Ncpus = 8)

require("bspm")
bspm::disable()

require("pak")
pak::pkg_install( c("duckdb","duckplyr"))


quit( save="no" )
