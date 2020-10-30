as.data.frame(installed.packages()[,c(3:4)])

# check package version
packageVersion("dplyr")

# get package description
packageDescription("dplyr")

# Packages installation

install.packages("tidyverse") # install few packages

install.packages("psych")
install.packages("rio")
install.packages("party")
install.packages("readr")
install.packages("data.table")
install.packages("rlist")
install.packages("caret")
install.packages("rpart.plot")
install.packages("corrplot")
install.packages("e1071")
install.packages("randomForest")
install.packages("Hmisc")

# graphics
install.packages("ggplot2")
install.packages("RColorBrewer")
install.packages("gridExtra")
install.packages("ggthemes")
install.packages("gganimate")
install.packages("maps")
install.packages("gifski") # large

# reports
install.packages("knitr")

# benchmarking
install.packages("microbenchmark")

# databases
install.packages("RODBC")
install.packages("odbc")

# neural networks
install.packages("keras")
install.packages("neuralnet")