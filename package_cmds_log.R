# Initialize Package ####

#install.packages("devtools")
library(devtools)
#devtools::install_github("klutometis/roxygen")
library(roxygen2)

wd = "/krummellab/data1/rebeccagj/repos/"

#setwd(wd)
#create('zzz')

# mv package_init.R to zzz

# Build Documentation after updates / as necessary ####

wd = "/krummellab/data1/rebeccagj/repos/zzz/"
setwd(wd)
document()

# Install ####

# from within cloned directory
setwd('..')
install("zzz/")

# from github
devtools::install_github('rebeccagj/zzz')