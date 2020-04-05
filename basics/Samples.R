# Load packages & get help
library("datasets")
?datasets
library(help = "datasets")

# SOme samples from "datasets"

?iris
iris

# some tabular samples
?UCBAdmissions
?UCBAdmissions

?Titanic
Titanic

?state.x77
state.x77

?swiss
swiss

# Clean up
rm(list = ls())

# Clear packages
detach("package:datasets", unload= T)