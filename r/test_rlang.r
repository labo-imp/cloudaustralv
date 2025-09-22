args <- commandArgs(trailingOnly=TRUE)

fecha <- format(Sys.time(), "%Y%m%d %H%M%S\n")
cat( fecha, file=args[1] )

quit( save="no" )