# Initialize Package ####

#install.packages("devtools")
library(devtools)
#devtools::install_github("klutometis/roxygen")
library(roxygen2)

wd = "./"

#setwd(wd)
#create('zzz')

# mv package_init.R to zzz

# Build Documentation after updates / writing a new function ####

wd = "./../zzz/"
setwd(wd)
devtools::document()

# Install ####

# from within cloned directory
setwd('..')
install("zzz/")

# from github
devtools::install_github('rebeccagj/zzz')
