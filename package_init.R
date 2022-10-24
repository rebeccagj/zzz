#install.packages("devtools")
library(devtools)
#devtools::install_github("klutometis/roxygen")
library(roxygen2)

wd = "/krummellab/data1/rebeccagj/repos/"

setwd(wd)
create('zzz')

# mv package_init.R to zzz